[![Stories in Ready](https://badge.waffle.io/ministryofjustice/atet.png?label=ready&title=Ready)](https://waffle.io/ministryofjustice/atet)
# Apply to an Employment Tribunal

[![Code Climate](https://codeclimate.com/github/ministryofjustice/atet.png)](https://codeclimate.com/github/ministryofjustice/atet)
[![Test coverage](https://codeclimate.com/github/ministryofjustice/atet/coverage.png)](https://codeclimate.com/github/ministryofjustice/atet)
[![Build Status](https://travis-ci.org/ministryofjustice/atet.svg?branch=master)](https://travis-ci.org/ministryofjustice/atet)

## Dependencies

### Installing pdftk

The application requires [pdftk](https://www.pdflabs.com/tools/pdftk-server/) to inject content into a template pdf file. This is the end result of completing a claim in the web application.

If you are running OS X 10.11(El Capitan) you can install pdftk with [this](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg) package.

For versions of OS X 10.10 and lower [this](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.6-setup.pkg) package should be suitable.

### npm v2.x.x (not v3.x.x)

To install npm v2 using brew:
```
brew install homebrew/versions/node4-lts
```
This should install node v4.4.3 and npm v2.15.1

### Dependencies for deployment

The application depends on 2 other repositories during deployment:

* [Parliamentary Questions Deploy](https://github.com/ministryofjustice/parliamentary-questions-deploy) - rather than having its own deploy app, this product uses the deploy shared with Parliamentary Questions.
* [ATET Smoketests](https://github.com/ministryofjustice/atet-smoketests) - these are run as part of the build process.



## Running the application locally

### Install Docker and Docker Compose
If you already have Docker, be sure it's at least v1.11

If you're using [Kitematic] on OSX, use the terminal from there, or in any terminal run:

    eval $(docker-machine env default)

### Setup .env file
From the project's root folder, copy the `.env.template` file to `.env` and change as necessary.

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
