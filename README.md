# Cloud.gov MySQL STIG Compliance Overlay

Cloud.gov overlay for the baseline InSpec profile at <https://github.com/mitre/oracle-mysql-8-stig-baseline/> with modifications based on Cloud.gov's policy and compliance requirements.

The baseline InSpec profile is used to validate the secure configuration of Oracle MySQL 8.x exactly against DISA's Oracle MySQL 8.0 (STIG) Version 1 Release 1.

This Overlay profile clearly distinguishes and measures compliance to OUR policy requirements without modification to the baseline profile or misrepresentation that we are exactly compliant with the original Benchmark. This overlay allows us to show compliance with our own vetted requirements.

This overlay work is based on upstream work at <https://github.com/mitre/sample-mysql-overlay>.

For this work we use the open-source `cinc-auditor` from the [Cinc Project](https://cinc.sh), derived from [Chef InSpec](https://docs.chef.io/inspec/).

## About the Overlay

The Cloud.gov customizations are in `./controls/overlay.rb`. We've determined that serveral are "Not Applicable" in our environment, so we have set `impact: 0.0`.

## About the implementation

See the following code in our [Terraform provisioning](https://github.com/cloud-gov/terraform-provision) repository:

* [Module `rds_stig`](https://github.com/cloud-gov/terraform-provision/tree/main/terraform/modules/rds_stig)
* [Script to run MySQL SQL commands](https://github.com/cloud-gov/terraform-provision/blob/main/ci/scripts/create-and-update-mysql.sh)

## Testing this overlay against an existing AWS RDS DB in Cloud.gov

Auditing is currently done on-demand from a Cloud.gov platform operator's workstation.  Running as part of CI/CD is a future implementation step (as of 2025-08-06).  Assuming you're on a Cloud.gov dev workstation:

* Install `mysql-client` and `cinc-auditor`
  * e.g. `brew install cinc-workstation; brew install mysql-client`
  * note: We have requested that corporate policies allow access to downloads.cinc.sh, but that may not yet have happened.
* The next steps are fully described in <https://github.com/cloud.gov/internal-docs>:
  * Obtain the MySQL database hostname, username, and password
  * Establish an SSH tunnel from localhost:3306 to remote_server:3306
  * Test `mysql` connection with `mysql -p -h 127.0.0.1 -u <USERNAME>` (and password)
  * Note: **DO NOT** use `mysql -p$PASSWORD -h 127.0.0.1 -u <USERNAME>` as the passwords will be visible in the system process list.
* Copy `input_sample.yml` to `input.yml`
* Update `input.yml` with the `user` and `password`. Be sure to 
  * set strict file permissions
  * prevent commiting the file to Git
  * delete the file when your work is done
* Run `cinc-auditor` for the profile:

```sh
cinc-auditor exec .  --show-progress --input-file input.yml  \
 --reporter=cli json:reports/$(date +'%Y-%m-%dH%H%M').json 
```

* Or run `cinc-auditor` for a single control, e.g.:

```sh
cinc-auditor exec .  --show-progress --input-file input.yml  \
  --reporter=cli json:reports/$(date +'%Y-%m-%dH%H%M').json \
  --controls 'SV-235096'
```

## Using Heimdall for Viewing the JSON Results

The JSON results output file can be loaded into __[heimdall-lite](https://github.com/mitre/heimdall2/)__ for a user-interactive, graphical view of the InSpec results. For local usage:

```shell
npm install -g @mitre/heimdall-lite
npx @mitre/heimdall-lite &
```

The Heimdall-Lite interface will be available at <http://localhost:8080>. From the
Finder, you can then drag the `.json` results into the viewer to see if there are any variations from our standards.
