
include_controls 'oracle-mysql-8-stig-baseline' do

# High controls
	control 'SV-235095' do
    impact 0.0
		desc 'caveat', 'This control has been satisfied outside the context of the MySQL STIG'
		describe 'The implementation of this control, integration "with an organization-level
		authentication/access mechanism providing account management and automation for
		all users, groups, roles, and any other principals", is satisfied by our AC-2(1) control
		as described in the Cloud.gov SSP. We leverage AWS IAM with Terraform Infrastructure as Code
		and CredHub secrets management' do
			skip 'This control is satisfied outside the context of MySQL auth'
		end
	end
	control 'SV-235134' do
    impact 0.0
		desc 'caveat', 'This control is N/A within AWS RDS'
		describe 'The implementation of this control, "The
		MySQL Database Server 8.0, when utilizing PKI-based
		authentication, must validate certificates by
		performing RFC 5280-compliant certification path
		validation." is not applicable since PKI auth is not available
		for AWS RDS per their documentation at 
		https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/database-authentication.html.
		FedRAMP has already accepted this implementation in AWS GovCloud' do
			skip 'This control is not applicable within AWS RDS'
		end
	end
	control 'SV-235136' do
    impact 0.0
		desc 'caveat', 'This control is N/A within AWS RDS'
		describe 'This control, "The DOD standard for authentication is DOD-approved 
		PKI certificates. Once a PKI certificate has been validated, it must be 
		mapped to a Database Management System (DBMS) user account for the authenticated 
		identity to be meaningful to the DBMS and useful for authorization decisions.",
		is not applicable for the Cloud.gov system.
		PKI auth is not available
		for AWS RDS per their documentation at 
		https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/database-authentication.html.
		FedRAMP has already accepted this implementation in AWS GovCloud' do
      skip 'This control is not applicable within AWS RDS'
		end
	end

  control 'SV-235096' do
    title "MySQL Database Server 8.0  must limit the number of concurrent
  sessions to an organization-defined number per user for all accounts and/or
  account types."
    impact 0.5
    tag severity: 'medium'
    tag gtitle: 'SRG-APP-000001-DB-000031'
    tag gid: 'V-235096'
    tag rid: 'SV-235096r638812_rule'
    tag stig_id: 'MYS8-00-000200'
    tag fix_id: 'F-38278r623409_fix'
    tag cci: ['CCI-000054']
    tag nist: ['AC-10']

    max_user_connection_headroom = input('max_user_connection_headroom')

    sql_session = mysql_session(input('user'), input('password'), input('host'), input('port'))

    global_max_connections_query = %(
    SELECT
      VARIABLE_NAME,
      VARIABLE_VALUE 
    FROM
      performance_schema.global_variables 
    WHERE
      VARIABLE_NAME LIKE 'max_connections' ;
    )

    global_max_connections = sql_session.query(global_max_connections_query).results.column('variable_value').first.to_i
    max_user_connection_limit = global_max_connections - max_user_connection_headroom

    global_max_user_connections = %(
    SELECT
      VARIABLE_NAME,
      VARIABLE_VALUE 
    FROM
      performance_schema.global_variables 
    WHERE
      VARIABLE_NAME LIKE 'max_user_connections' ;
    )

    user_concurrent_sessions = %(
    SELECT
      user,
      host,
      max_user_connections 
    FROM
      mysql.user 
    WHERE
      user not like 'mysql.%' 
      and user not like 'root';
    )

    describe "Global value of max_user_connections" do
      subject { sql_session.query(global_max_user_connections).results.column('variable_value') }
      it { should_not cmp 0 }
      it { should cmp <= max_user_connection_limit }
    end

    if !input('aws_rds')
      mysql_administrative_users = input('mysql_administrative_users')
    else
      mysql_administrative_users = input('mysql_administrative_users') + ['rdsadmin']
    end

    sql_session.query(user_concurrent_sessions).results.rows.each do |row|
      unless mysql_administrative_users.include? row['user']
        describe "User value of max_user_connections for user:#{row['user']} host:#{row['host']}" do
          subject { row['max_user_connections'] }
          it { should cmp <= max_user_connections }
        end
      end
    end
  end
end
