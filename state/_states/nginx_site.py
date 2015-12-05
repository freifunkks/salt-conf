import os.path
import salt.utils

def genconfig(name, root, proxyurl, conf):
  # TODO: Implement
  return '# Generated by Salt, do not edit!\n'

# TODO: Add TLS support
def present(name, root=None, proxyurl=None, conf=None):
  '''
  Ensure an nginx site is present and enabled.

  name
    Name of the site

  root
    Document root of the site

  proxyurl
    Reverse proxy URL, for the case that the site has its own webserver running on a
    different port. Not to be used together with root.

  conf
    Config file, in case you need more fine-grained control over the configuration.
    Will be included as part of the server block.
  '''
  ret = {
    'name': name,
    'result': None,
    'comment': '',
    'changes': { }
  }

  filename = '/etc/nginx/sites-available/' + name
  linkname = '/etc/nginx/sites-enabled/' + name

  config = _genconfig(name, root, proxyurl, conf)
  current_config = ''
  if os.path.exists(filename):
    with salt.utils.fopen(filename) as config_file:
      current_config = config_file.read()

  if config == current_config.strip():
    # TODO: Ensure linkname is a symlink to filename
    ret['result'] = True
    ret['comment'] = 'Site is up to date.'
  elif __opts__['test']:
    ret['comment'] = 'Site will be updated.'
    ret['changes'] = {
      'old': current_config,
      'new': config
    }
    return ret

  try:
    with salt.utils.fopen(filename, 'w') as config_file:
      print(config, file = config_file)

    # TODO: Ensure linkname is a symlink to filename

    ret['result'] = True
    ret['comment'] = 'Successfully wrote site config.'
    ret['changes'] = {
      'old': current_config,
      'new': config
    }
  except Exception as exc:
    ret['result'] = False
    ret['comment'] = 'Failed to write site config.'

  return ret
