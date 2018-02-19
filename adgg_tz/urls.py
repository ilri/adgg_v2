
from django.conf.urls import url
from django.contrib import admin
from django.conf.urls import include

from adgg_tz import views

urlpatterns = [
    url(r'^', include('odk_dashboard.urls')),
    url(r'^logout$', views.logout_view, name='logout'),
    url(r'^admin/', admin.site.urls),
    url(r'^$', views.show_landing, name='landing_page'),
    url(r'^home$', views.show_dashboard, name='landing_page'),
    url(r'^dashboard$', views.show_dashboard, name='dashboard'),
    url(r'^accounts/', include('django.contrib.auth.urls')),
    url(r'static/(?P<path>.*)$', views.serve_static_files),
    url(r'^farmers$', views.farmers, name='farmers'),
    url(r'^fetch_farmers_list', views.fetch_farmers_list, name='fetch_farmers_list'),
]
