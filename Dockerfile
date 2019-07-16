FROM ubuntu:latest
ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    apache2 \
    libapache2-mod-wsgi-py3 \
    python-dev \
    libpq-dev \
    postgresql \
    postgresql-contrib
RUN pip3 install Django django-nose django-tinymce4-lite psycopg2 selenium
WORKDIR /var/www/Demo_DevOps
COPY . .
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY apache2.conf /etc/apache2/apache2.conf
COPY pg_hba.conf /etc/postgresql/10/main/
#RUN service postgresql restart
RUN mkdir /var/www/logs
RUN chown www-data /var/www/Demo_DevOps/
RUN chmod +r /etc/postgresql/10/main/pg_hba.conf
#RUN service postgresql restart 
USER postgres
COPY dbexport.pgsql .
RUN  service postgresql restart   &&  psql -U postgres -c "CREATE DATABASE myproject" && \
     psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'password'" && \
     psql -U postgres myproject < dbexport.pgsql 
USER root
EXPOSE 80
WORKDIR /var/www/Demo_DevOps
RUN ls -l
RUN python3 manage.py collectstatic --noinput  && \
    service apache2 restart
CMD python3 manage.py runserver 0.0.0.0:8000"
#iCMD sleep 500
