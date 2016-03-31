# Apply to an Employment Tribunal

[![Code Climate](https://codeclimate.com/github/ministryofjustice/atet.png)](https://codeclimate.com/github/ministryofjustice/atet)
[![Test coverage](https://codeclimate.com/github/ministryofjustice/atet/coverage.png)](https://codeclimate.com/github/ministryofjustice/atet)
[![Build Status](https://travis-ci.org/ministryofjustice/atet.svg?branch=master)](https://travis-ci.org/ministryofjustice/atet)

### Dependencies

#### pdftk

The application requires [pdftk](https://www.pdflabs.com/tools/pdftk-server/) to inject content into a template pdf file. This is the end result of completing a claim in the web application.

If you are running OS X 10.11(El Capitan) you can install pdftk with [this](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg) package.

For versions of OS X 10.10 and lower [this](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.6-setup.pkg) package should be suitable.

================

#### Installing the application

```bash
git clone git@github.com:ministryofjustice/atet.git
cd atet
bundle
npm install
bundle exec rake db:setup
```

#### Running the specs

```bash
rake
```
