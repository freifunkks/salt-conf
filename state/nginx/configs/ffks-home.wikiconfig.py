# -*- coding: iso-8859-1 -*-

import sys
import os

from MoinMoin.config import multiconfig, url_prefix_static

class Config(multiconfig.DefaultConfig):
  # Base --------------------------------------------------------------
  base_dir = '/home/ffks-home'

  # Directory containing THIS wikiconfig:
  wikiconfig_dir = os.path.abspath(os.path.dirname(__file__))

  # Beautiful links
  #url_prefix = '/fixme'
  url_prefix_static = '/static'

  # Instance / repo directory
  instance_dir = base_dir + '/wikicontent'

  # Where your own wiki pages are (make regular backups of this directory):
  data_dir = os.path.join(instance_dir, 'data', '') # path with trailing /

  # Standard plugins are in the system directory
  plugin_dir = '/usr/share/moin/data/plugin'

  # Additional plugin directories
  plugin_dirs = [
    base_dir + '/theme/moinmoin/wiki/theme',
    base_dir + '/plugins/macro-ffks']

  # Where system and help pages are (you may exclude this from backup):
  data_underlay_dir = os.path.join(instance_dir, 'underlay', '') # path with trailing /

  # Site name, used by default for wiki name-logo [Unicode string]
  sitename = u'Freifunk Kassel'

  # Wiki logo. You can use an image, text or both. [Unicode string]
  logo_string = u'<img class="logo" src="%s/common/logo-ks-web.png" alt="Freifunk Kassel">' % url_prefix_static

  # Security ----------------------------------------------------------

  # First page to be loaded when visiting root
  page_front_page = u"Hallo"

  # This is checked by some rather critical and potentially harmful actions,
  # like despam or PackageInstaller action:
  superuser = [u"feliks", u"JonasPlatte"]

  # Restrict access to read-only
  acl_rights_default = u"All:read"
  acl_rights_before  = u"VerifiedGroup:read,write,delete,revert,admin"

  # Link spam protection for public wikis
  # Needs a reliable internet connection
  from MoinMoin.security.antispam import SecurityPolicy


  # Mail --------------------------------------------------------------
  # not yet configured

  # Configure to enable subscribing to pages (disabled by default)
  # or sending forgotten passwords.

  # SMTP server, e.g. "mail.provider.com" (None to disable mail)
  #mail_smarthost = ""

  # The return address, e.g u"J�rgen Wiki <noreply@mywiki.org>" [Unicode]
  #mail_from = u""

  # "user pwd" if you need to use SMTP AUTH
  #mail_login = ""


  # User interface ----------------------------------------------------

  # Main navigation seen at the toppom of the page
  navi_bar = [
      u'News',
      u'Firmware',
      u'Karte',
      u'Dienste',
      u'Spenden',
      u'Kontakt',
  ]

  # German date / time format
  date_fmt = '%d.%m.%Y'
  datetime_fmt = '%d.%m.%Y, %H:%M'

  # Disable WISIWYG editing
  editor_default = 'text'
  editor_force = True

  # Disable editing on doubleclick
  user_checkbox_defaults = {'edit_on_doubleclick': 0}
  user_checkbox_remove   = ['edit_on_doubleclick']

  # Disable CamelCase-Links
  default_markup = 'nocamelcase'

  # Prefer German language
  language_default = 'de'

  # Ignore visitors' preference
  language_ignore_browser = True

  # Surge protection (more lax than defaults)
  surge_action_limits = {
      # allow max. <count> <action> requests per <dt> secs
      'edit': (50, 120), # defaults 10, 120
      'AttachFile': (30, 60), # defaults 10, 60
  }

  # Edit bar options (below main navigation bar)
  edit_bar = ['Edit', 'Comments', 'Discussion', 'Info', 'Subscribe', 'Attachments', 'ActionsMenu']

  # Favicons for every device
  html_head = '''
    <link rel="apple-touch-icon" sizes="57x57" href="{0}/icons/apple-touch-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="{0}/icons/apple-touch-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="{0}/icons/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="{0}/icons/apple-touch-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="{0}/icons/apple-touch-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="{0}/icons/apple-touch-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="{0}/icons/apple-touch-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="{0}/icons/apple-touch-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="{0}/icons/apple-touch-icon-180x180.png">
    <link rel="icon" type="image/png" href="{0}/icons/favicon-32x32.png" sizes="32x32">
    <link rel="icon" type="image/png" href="{0}/icons/android-chrome-192x192.png" sizes="192x192">
    <link rel="icon" type="image/png" href="{0}/icons/favicon-96x96.png" sizes="96x96">
    <link rel="icon" type="image/png" href="{0}/icons/favicon-16x16.png" sizes="16x16">
    <link rel="manifest" href="{0}/icons/manifest.json">
    <link rel="shortcut icon" href="{0}/icons/favicon.ico">
    <meta name="apple-mobile-web-app-title" content="Freifunk Kassel">
    <meta name="application-name" content="Freifunk Kassel">
    <meta name="msapplication-TileColor" content="#ffc40d">
    <meta name="msapplication-TileImage" content="{0}/icons/mstile-144x144.png">
    <meta name="msapplication-config" content="{0}/icons/browserconfig.xml">
    <meta name="theme-color" content="#ffffff">
    <script type="text/javascript" src="{0}/ffks/js/jquery-2.1.4.min.js"></script>
    '''.format(url_prefix_static)

  # Enforce custom theme
  theme_default = u'ffks'
  theme_force = True

  # Thumbnail action plugin configuration
  thumbsizes = [160, 320, 640, 700]
  thumbname = "%(base)s_thumb_%(size)s.jpg"

  # Language options --------------------------------------------------

  # The main wiki language, set the direction of the wiki pages
  language_default = 'de'

  # the following regexes should match the complete name when used in free text
  # the group 'all' shall match all, while the group 'key' shall match the key only
  # e.g. CategoryFoo -> group 'all' ==  CategoryFoo, group 'key' == Foo
  # moin's code will add ^ / $ at beginning / end when needed
  # You must use Unicode strings here [Unicode]
  page_category_regex = ur'(?P<all>Category(?P<key>(?!Template)\S+))'
  page_dict_regex = ur'(?P<all>(?P<key>\S+)Dict)'
  page_group_regex = ur'(?P<all>(?P<key>\S+)Group)'
  page_template_regex = ur'(?P<all>(?P<key>\S+)Template)'

  # Content options ---------------------------------------------------

  # Show users hostnames in RecentChanges
  # only for anonymous users?
  show_hosts = 1

  # Enable graphical charts, requires gdchart.
  #chart_options = {'width': 600, 'height': 300}
