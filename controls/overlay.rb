
## Works that still needs to be done
# SV-253137 -  
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Concepts.PasswordValidationPlugin.html
# Done:
# mysql>
# mysql> INSTALL PLUGIN validate_password SONAME 'validate_password.so';
# Query OK, 0 rows affected, 1 warning (0.24 sec)


include_controls 'oracle-mysql-8-stig-baseline' do

# High controls
	control 'SV-235095' do
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
end
