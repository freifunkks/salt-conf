import sys
from MoinMoin.web.serving import make_application

sys.path.insert(0, '/var/www/home.ffks')
application = make_application(shared=True)
