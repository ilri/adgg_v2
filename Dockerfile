FROM ubuntu:16.04

MAINTAINER Wangoru Kihara wangoru.kihara@badili.co.ke

# Add the application resources URL
# RUN echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main universe" >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get upgrade -y

# Install mariadb server sources
RUN apt-get install -y software-properties-common python-software-properties && \
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 && \
    add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu xenial main'

# Install build deps, then run `pip install`, then remove unneeded build deps all in a single step. Correct the path to your production requirements file, if needed.
RUN apt-get update && \
    apt-get install -y \
    git \
    python \
    python-dev \
    python-setuptools \
    python-pip \
    nginx \
    mariadb-server

# install uwsgi now because it takes a little while
RUN pip install uwsgi

# setup all the configfiles
# RUN echo "daemon off;" >> /etc/nginx/nginx.conf
# COPY nginx-app.conf /etc/nginx/sites-available/default

# COPY requirements.txt and RUN pip install BEFORE adding the rest of your code, this will cause Docker's caching mechanism
# to prevent re-installinig (all your) dependencies when you made a change a line or two in your app.

# Copy your application code to the container (make sure you create a .dockerignore file if any large files or directories should be excluded)
RUN mkdir /opt/azizi_amp/

COPY requirements.txt /opt/azizi_amp/
RUN pip install -r /opt/azizi_amp/requirements.txt

# add (the rest of) our code
COPY . /opt/azizi_amp/

# install django, normally you would remove this step because your project would already
# be installed in the code/app/ directory
# RUN django-admin.py startproject website /home/docker/code/app/

ADD . /opt/azizi_amp/

# uWSGI will listen on this port
EXPOSE 8089

WORKDIR /opt/azizi_amp

# Manually start the server for now
CMD python manage.py runserver

# Add any custom, static environment variables needed by Django or your settings file here:
# ENV DJANGO_SETTINGS_MODULE=azizi_amp.settings

# uWSGI configuration (customize as needed):
# ENV UWSGI_VIRTUALENV=/venv UWSGI_WSGI_FILE=azizi_amp/uwsgi.ini UWSGI_HTTP=:8089 UWSGI_MASTER=1 UWSGI_WORKERS=2 UWSGI_THREADS=8 UWSGI_UID=1000 UWSGI_GID=2000 UWSGI_LAZY_APPS=1 UWSGI_WSGI_ENV_BEHAVIOR=holy

# Call collectstatic (customize the following line with the minimal environment variables needed for manage.py to run):
# RUN DATABASE_URL=none /venv/bin/python manage.py collectstatic --noinput

# Start uWSGI
# CMD ["/venv/bin/uwsgi", "--http-auto-chunked", "--http-keepalive"]

