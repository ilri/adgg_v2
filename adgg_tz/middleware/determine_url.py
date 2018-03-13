from django.conf import settings
from urllib.parse import urlsplit, urlunsplit


# Determine the url of the request and set the sentry settings appropriately
class DetermineURL(object):
    def __init__(self, get_response):
        print("Wassup")
        self.get_response = get_response

    def __call__(self, request):
        # settings.ABSOLUTE_ROOT = request.build_absolute_uri('/')[:-1].strip("/")
        absolute_url = request.build_absolute_uri('/').strip("/")
        split_url = urlsplit(absolute_url)
        settings.ABSOLUTE_ROOT = split_url.netloc

        return self.get_response(request)

    # Check the URL being used
    def process_request(self, request):
        settings.ABSOLUTE_ROOT = request.build_absolute_uri('/')[:-1].strip("/")
        settings.ABSOLUTE_ROOT_URL = request.build_absolute_uri('/').strip("/")
        print("Wassup")

        # Return None to ensure processing goes on well
        return None
