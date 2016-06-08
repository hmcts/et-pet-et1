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


## Installing the application

```bash
git clone git@github.com:ministryofjustice/atet.git
cd atet
bundle
npm install
bundle exec rake db:setup
```


## Running the specs

```bash
rake
```

## Deploying

For deployment to all environments, see the documentation at the [Employment Tribunals Deployment section of Ops manual](https://opsmanual.dsd.io/run_books/employmenttribunals.html#deployment)

