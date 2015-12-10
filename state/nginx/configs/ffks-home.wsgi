import sys
from MoinMoin.web.serving import make_application

sys.path.insert(0, '/home/ffks-home')
application = make_application(shared=True)
