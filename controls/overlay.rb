include_controls 'oracle-mysql-8-stig-baseline' do

# SV-235139 - fix pending in Terraform with require_secure_transport
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/mysql-ssl-connections.require-ssl.html
# SV-253137 -  
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Concepts.PasswordValidationPlugin.html
# Done:
# mysql>
# mysql> INSTALL PLUGIN validate_password SONAME 'validate_password.so';
# Query OK, 0 rows affected, 1 warning (0.24 sec)


#  control '1.2' do
#    impact 0.0
#    desc 'caveat', 'This is Not Applicable for our project since we have an approved risk-based decision on 10/1/2021 allowing use of root account for running mysql.'
#    describe 'This is Not Applicable for our project since we have an approved risk-based decision on 10/1/2021 allowing use of root account for running mysql.' do
#      skip 'This is Not Applicable for our project since we have an approved risk-based decision on 10/1/2021 allowing use of root account for running mysql.'
#    end
#  end
