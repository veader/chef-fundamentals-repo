name             'email_handler'
maintainer       'Shawn Veader'
maintainer_email 'shawn@veader.org'
license          'Apache 2.0'
description      'Email me on every Chef run'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "chef_handler"
depends "postfix"
depends "mailx"
