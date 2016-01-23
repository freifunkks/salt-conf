import os.path
import salt.utils

from string import Template

error_pages = '''
location /error_pages/ {
  alias /srv/http/error_pages/;
  internal;
}

'''

default_tpl = Template('''
# Generated by Salt, do not edit!
server {

listen $addr:$port;
server_name $server_names;

$config

}
''')

lets_encrypt_tpl = Template('''
# Generated by Salt, do not edit!
server {

listen 80;
server_name $server_names;

location /.well-known/acme-challenge/ {
  alias /srv/http/challenges/;
}

# Only used when the other location block doesn't match
location / {
  return 301 https://$$server_name$$request_uri;
}

}


server {

listen 443 ssl;
server_name $server_names;

ssl_certificate /etc/acme_tiny/$name.pem;
ssl_certificate_key /etc/acme_tiny/$name.key;

$config

}
''')

def _save_config(name, config):
  ret = {
    'name': name,
    'result': None,
    'comment': '',
    'changes': { }
  }

  filename = '/etc/nginx/sites-available/' + name
  linkname = '/etc/nginx/sites-enabled/' + name

  current_config = ''
  if os.path.exists(filename):
    with salt.utils.fopen(filename) as config_file:
      current_config = config_file.read()

  if config.strip() == current_config.strip():
    res = __states__['file.symlink'](name=linkname, target=filename)
    if res['result'] == False:
      ret['result'] = False
      ret['comment'] = 'Failed to enable site config.'
      return ret

    ret['result'] = True
    ret['comment'] = 'Site is up to date.'
    return ret
  elif __opts__['test']:
    ret['comment'] = 'Site will be updated.'
    ret['changes'] = {
      'old': current_config,
      'new': config
    }
    return ret

  try:
    with salt.utils.fopen(filename, 'w') as config_file:
      config_file.write(config)

    res = __states__['file.symlink'](name=linkname, target=filename)
    if res['result'] == False:
      ret['result'] = False
      ret['comment'] = 'Failed to enable site config.'
      return ret

    ret['result'] = True
    ret['comment'] = 'Successfully wrote site config.'
    ret['changes'] = {
      'old': current_config,
      'new': config
    }
  except IOError:
    ret['result'] = False
    ret['comment'] = 'Failed to write site config.'

  return ret

def _generate_config(template, name, server_names, **kwargs):
  names = server_names if len(server_names) > 0 else [name]
  return template.substitute(name=name, server_names=' '.join(names), **kwargs)

def _create_config(template, name, **kwargs):
  return _save_config(name, _generate_config(template, name, **kwargs))

def present(name, configfile, address='*', port=80, server_names=[]):
  '''
  Ensure an nginx site is present and enabled.

  name
    Name of the site

  configfile
    Config file, in case you need more fine-grained control over the configuration.
    Will be included as part of the server block.

  address
    Address part of the nginx listen directive. Default is '*' (all local interfaces).
    Other common options would be '0.0.0.0' for IPv4 interfaces only or 'localhost' for
    sites that aren't meant to be accessed from anywhere but the system nginx runs on.

  port
    Port part of the nginx listen directive

  server_names
    Domains this server block should apply for. When none are provided, name is used.
  '''
  config = error_pages + __salt__['cp.get_file_str'](configfile, saltenv=__env__)
  return _create_config(default_tpl, name, server_names=server_names,
    addr=address, port=port, config=config)

def present_le(name, configfile, server_names=[]):
  '''
  Ensure an nginx site with https over Let's Encrypt is present and enabled. Read the
  source code of this module if you want to use this state function; simply using this
  isn't going to make https work!

  name
    Name of the site

  configfile
    Config file, in case you need more fine-grained control over the configuration.
    Will be included as part of the server block.
  '''
  config = error_pages + __salt__['cp.get_file_str'](configfile, saltenv=__env__)
  return _create_config(lets_encrypt_tpl, name, server_names=server_names, config=config)

def reverse_proxy(name, target, address='*', port=80, server_names=[]):
  '''
  Ensure queries to a (sub)domain are passed on to another webserver.

  name
    Name of the site

  target
    The target server that serves the website. Usually `http://localhost:PORT`.

  address
    Address part of the nginx listen directive. Default is '*' (all local interfaces).
    Other common options would be '0.0.0.0' for IPv4 interfaces only or 'localhost' for
    sites that aren't meant to be accessed from anywhere but the system nginx runs on.

  port
    Port part of the nginx listen directive

  server_names
    Domains this server block should apply for. When none are provided, name is used.
  '''
  config = 'location / { proxy_pass %s; }' % target
  return _create_config(default_tpl, name, server_names=server_names,
    addr=address, port=port, config=config)

def reverse_proxy_le(name, target, server_names=[]):
  '''
  Ensure an nginx site with https over Let's Encrypt is present and enabled. Read the
  source code of this module if you want to use this state function; simply using this
  isn't going to make https work!

  name
    Name of the site

  configfile
    Config file, in case you need more fine-grained control over the configuration.
    Will be included as part of the server block.
  '''
  config = 'location / { proxy_pass %s; }' % target
  return _create_config(lets_encrypt_tpl, name, server_names=server_names, config=config)

def redirect(name, target, address='*', port=80, server_names=[]):
  '''
  Ensure a (sub)domain redirects to somewhere else.
  Currently all redirects are permanent ones.

  name
    Name of the site

  target
    The target site to redirect to, without a trailing '/'. When a server requests
    $a_server_name/somepage, the server will respond with a redirect to $target/somepage.

  address
    Address part of the nginx listen directive. Default is '*' (all local interfaces).
    Other common options would be '0.0.0.0' for IPv4 interfaces only or 'localhost' for
    sites that aren't meant to be accessed from anywhere but the system nginx runs on.

  port
    Port part of the nginx listen directive

  server_names
    Domains this server block should apply for. When none are provided, name is used.
  '''
  return _create_config(default_tpl, name, server_names=server_names,
    addr=address, port=port, config=('return 301 %s$request_uri;' % target))
