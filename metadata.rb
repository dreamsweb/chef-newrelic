name             "chef-newrelic"
maintainer       "Dwwd Software Inc."
maintainer_email "info@dwwd.ru"
description      "Installs/Configures newrelic server monitoring"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.2"

recipe "newrelic", "Installs newrelic"

supports "ubuntu"
