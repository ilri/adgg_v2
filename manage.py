#!/usr/bin/env python
import os
import sys

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "adgg_tz.settings")
    try:
        import django
        django.setup()

        from django.core.management.commands.runserver import Command as runserver
        runserver.default_port = "8001"
        from django.core.management import execute_from_command_line
    except ImportError:
        # The above import may fail for some other reason. Ensure that the
        # issue is really that Django is missing to avoid masking other
        # exceptions on Python 2.
        raise
    execute_from_command_line(sys.argv)
