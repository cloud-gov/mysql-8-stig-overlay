# Cloud.gov MySQL STIG Compliance Overlay

Cloud.gov overlay for the baseline InSpec profile at <https://github.com/mitre/oracle-mysql-8-stig-baseline/> with modifications based on Cloud.gov's different policy compliance requirements.

The original baseline InSpec profile is used to validate the secure configuration of Oracle MySQL 8.x exactly against the requirements in Oracle MySQL 8.0 against DISA's Oracle MySQL 8.0 (STIG) Version 1 Release 1.

This Overlay profile clearly distinguishes and measures to OUR policy requirements without modification to the baseline profile or misrepresentation that we are exactly compliant with the original Benchmark. This overlay allows us to show compliance with our own vetted requirements.

This is based on upstream work at <https://github.com/mitre/sample-mysql-overlay>

## Getting Started - Development 

This assumes you're on a Cloud.gov dev workstation

* Install `mysql-client` and `cinc-auditor`
* Establish an SSH tunnel on localhost:3306 to remote_server:3306
* Test `mysql` connection with `mysql -p -h 127.0.0.1 -u <USERNAME>` (and password)
* Run Inspec: `cinc-auditor exec .  --show-progress --input-file input_local.yml  --reporter=cli json:reports/<FILE>.json`

### Hints for PeterB

Use the .tfstate file to get the credentials... for `mysql_db`

```
✦ ❯ cf_go dev
cf switch dev

✦ ❯ cf api
API endpoint:   https://api.dev.us-gov-west-1.aws-us-gov.cloud.gov
API version:    3.195.0

✦ ❯ cf login --sso -o cloud-gov-operators -s peter.burkholder

✦ ❯ cf ssh -L3306:development-xxxxxxx99C.cxxxxxxxxxy.us-gov-west-1.rds.amazonaws.com:3306 -N cinc-auditor
```

**In another term**

```
✦ ❯ mysql -p -h 127.0.0.1 -umysql_stig
```



Latest versions and installation options are available at the [InSpec](http://inspec.io/) site.

## Tailoring to Your Environment

The following inputs may be configured in an inputs ".yml" file for the profile to run correctly for your specific environment. More information about InSpec inputs can be found in the [InSpec Profile Documentation](https://www.inspec.io/docs/reference/profiles/).

-- SEE <https://github.com/mitre/oracle-mysql-8-stig-baseline/tree/main?tab=readme-ov-file#tailoring-to-your-environment>

## Using Heimdall for Viewing the JSON Results

The JSON results output file can be loaded into __[heimdall-lite](https://heimdall-lite.mitre.org/)__ for a user-interactive, graphical view of the InSpec results. For local usage:

```shell
npm install -g @mitre/heimdall-lite
npx @mitre/heimdall-lite &
```

In Finder, you can then drag the `.json` results into the viewer and get to work on stomping out the variations.
