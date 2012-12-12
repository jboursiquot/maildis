# Maildis 

[![Code
Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jboursiquot/maildis) [![Dependency
Status](https://gemnasium.com/jboursiquot/maildis.png)](https://gemnasium.com/jboursiquot/maildis) 

Maildis is a command line bulk email dispatching tool. It supports HTML and plain text templates with merge tags and CSVs for specifying recipients. It relies on SMTP information you provide through your own configuration file. Subject, sender, path to CSV and path to the templates are all configurable through YAML.

## Installation

    $ gem install maildis

## Usage

### Maildis Commands:

    maildis dispatch mailer  # Dispatches the mailer through the SMTP server specified in the mailer configuration.
    maildis ping mailer      # Attempts to connect to the SMTP server specified in the mailer configuration
    maildis validate mailer  # Validates mailer configuration file

In the above task listing, _mailer_ refers to a YAML configuration file
for your mailer. You may get additional help on any of the available tasks, for example:

    $ maildis help dispath

    Usage:
      maildis ping mailer

    Options:
      -v, [--verbose=VERBOSE]  # Verbose

## Creating and Dispatching Mailers

### 1. Create a mailer configuration (e.g. mailer.yml)

    mailer:
      subject: "Test Mailer"
      sender:
        name: "Developer"
        email: "developer@company.com"
      recipients:
        csv: "/path/to/recipients.csv"
      templates:
        html: "/path/to/template.html"
        plain: "/path/to/template.txt"
    smtp:
      host: "my.mail.host"
      port: 25
      username: "username"
      password: "password"

### 2. Set up html and plain text templates, for example:

**HTML**

    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
              "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html>
      <head>
        <title>Test Mailer</title>
      </head>
      <body>
        <p>This is a test mailer</p>
        <p>The following merge field should be replaced with an actual URL: <a href="%url%">%url%</a></p>
        <p>Organization | Address | Unsubscribe Link</p>
      </body>
    </html>

**Plain**

    This is a test mailer.

    The following merge field should be replaced with an actual URL: %url%

    Organization | Address | Unsubscribe Link

Note the _%url%_ markers in the template files. This %{string}%
mechanism allows you to specify merge fields which are replaced by their
equivalent columns from your recipients CSV. In this case, the CSV example below,
lists a _url_ column that will be used as a merge field.

### 3. Prepare your recipients CSV, for example:

    name,email,url
    Johnny Boursiquot,jboursiquot@gmail.com,https://github.com/jboursiquot
    Johnny Boursiquot,jboursiquot@maark.com,http://www.maark.com

### 4. Validate your configuration

    $ maildis validate /path/to/your/mailer.yml

This will go through the settings in your mailer configuration and check

- sender email validity
- template path validity
- recipients CSV path and format validity
- SMTP server reachability

You can test the reachability of the SMTP server defined in your mailer configuration on its own by issueing the following command:

    $ maildis ping /path/to/your/mailer.yml

### 5. Invoke the maildis command while passing in the path to your
mailer configuration to its dispatch task

    $ maildis dispath /path/to/your/mailer.yml -v

When _maildis_ processes your _dispatch_ request, a logfile (.maildis.log) is written in the user's home directory. In the above command, the _dispatch_ task is invoked with the _verbose_ flag which will output to STDOUT as well as ~/.maildis.log. Example output based on the recipients.csv above might look like this:

    2012-12-11 20:18:10 -0500 INFO: Load /path/to/your/mailer.yml
    2012-12-11 20:18:10 -0500 INFO: Validate configuration
    2012-12-11 20:18:10 -0500 INFO: Validate recipients csv
    2012-12-11 20:18:10 -0500 INFO: Extract recipients from csv
    2012-12-11 20:18:10 -0500 INFO: Validate sender
    2012-12-11 20:18:10 -0500 INFO: Validate templates
    2012-12-11 20:18:10 -0500 INFO: Validate SMTP server localhost
    2012-12-11 20:18:10 -0500 INFO: Dispatching to 2 recipients
    2012-12-11 20:18:10 -0500 INFO: Sent: Johnny Boursiquot <jboursiquot@gmail.com>
    2012-12-11 20:18:10 -0500 INFO: Sent: Johnny Boursiquot <jboursiquot@maark.com>
    2012-12-11 20:18:11 -0500 INFO: Dispatch complete without errors

## Local SMTP Server For Testing

I recommend you use the _mailcatcher_ gem to get a local SMTP server up
and running while you test. This will speed up your testing and even
require network access. See http://mailcatcher.me for more details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes with tests (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
