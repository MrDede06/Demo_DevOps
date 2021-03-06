FROM ubuntu:latest
RUN apt-get update
RUN apt-get install python3 python3-pip  apache2 libapache2-mod-wsgi-py3 libpq-dev   -y 
RUN pip3 install Django django-nose django-tinymce4-lite psycopg2
RUN mkdir /var/www/logs && mkdir /var/www/Demo_DevOp
COPY  . /var/www/Demo_DevOps/
WORKDIR /var/www/Demo_DevOps
COPY 000-default.conf /etc/apache2/sites-available/
COPY apache2.conf /etc/apache2/
#EXPOSE 80 
EXPOSE 8000
RUN service apache2 restart
RUN python3 manage.py collectstatic --noinput
CMD python3 manage.py runserver 0.0.0.0:8000 --noreload
