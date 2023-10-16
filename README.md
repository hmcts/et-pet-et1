# Apply to an Employment Tribunal

[![Code Climate](https://codeclimate.com/github/ministryofjustice/atet.png)](https://codeclimate.com/github/ministryofjustice/atet)
[![Test coverage](https://codeclimate.com/github/ministryofjustice/atet/coverage.png)](https://codeclimate.com/github/ministryofjustice/atet)
[![Build Status](https://travis-ci.org/ministryofjustice/atet.svg?branch=master)](https://travis-ci.org/ministryofjustice/atet)

[![Build Status](https://dev.azure.com/HMCTS-PET/pet-azure-infrastructure/_apis/build/status/et1?branchName=develop)](https://dev.azure.com/HMCTS-PET/pet-azure-infrastructure/_build/latest?definitionId=20&branchName=develop)
## Dependencies

### Installing postgres client

#### Linux

sudo apt-get install libpq-dev

### npm v2.x.x (not v3.x.x)

#### Linux

Use nvm - https://github.com/nvm-sh/nvm

#### OSX

To install npm v2 using brew:
```
brew install homebrew/versions/node4-lts
```
This should install node v4.4.3 and npm v2.15.1


## Running the application locally

### Install Docker and Docker Compose
If you already have Docker, be sure it's at least v1.11

If you're using [Kitematic] on OSX, use the terminal from there, or in any terminal run:

    eval $(docker-machine env default)

### Setup .env file
From the project's root folder, copy the `.env.template` file to `.env` and change as necessary.

### Running Locally (2019 Update)

Please note the [build section](#build) may be outdated. The following steps work in 2019:

1) After creating a `.env` file, add `DB_USERNAME=postgres`
1) From the project's root folder, run `bundle`
1) Run `docker-compose -f docker-compose-local-test.yml up`
1) Run `rails db:create db:migrate`
    1) If you get an error about `claim.rb`, open `app/models/claim.rb`
    1) Comment out lines 44-46:
        ```ruby
          # bitmask :discrimination_claims, as: DISCRIMINATION_COMPLAINTS
          # bitmask :pay_claims,            as: PAY_COMPLAINTS
          # bitmask :desired_outcomes,      as: DESIRED_OUTCOMES
        ```
    1) Run `rails db:create db:migrate` again
    1) Uncomment lines 44-46 to return them to their original state:
        ```ruby
          bitmask :discrimination_claims, as: DISCRIMINATION_COMPLAINTS
          bitmask :pay_claims,            as: PAY_COMPLAINTS
          bitmask :desired_outcomes,      as: DESIRED_OUTCOMES
        ```
1) Run `npm install`

### Build
From the project's root folder, build (this will take several minutes - grab a coffee):

    docker-compose build

Run the app containers:

    docker-compose up -d

Run DB setup:

    docker-compose run web bash -c "RAILS_ENV=local bundle exec rake db:setup"

Get the IP of the virtual docker machine with:

    docker-machine ip

Visit `http://<insert-ip-from-previous-command>:8080` to access the locally running site.


### Running the specs

```bash
rake
```

## Deploying

For deployment to all environments, see the documentation at the [Employment Tribunals Deployment section of Ops manual](https://opsmanual.dsd.io/run_books/employmenttribunals.html#deployment)

## Shuttering

In order to stop people using the system a maintenance page has been added which is controlled using environment
variables.

These are :-

MAINTENANCE_ENABLED - Set to 'true' to enable maintenance page to be enabled

Any of the environment variables below can be added if you want to customize from the defaults

MAINTENANCE_ALLOWED_IPS
MAINTENANCE_END - If added you will see "You will be able to use the service from " followed by this text.
