FROM ruby:2.6.6

# Install 3rd Party Dependencies
RUN apt update && apt -y install nodejs postgresql-client

# Working directory
RUN mkdir /app
WORKDIR /app

# Script run when container first starts.
COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT [ "/app/docker-entrypoint.sh" ]
EXPOSE 3000
#eval $(egrep -v '^#' ./db/.env | xargs) docker-compose config