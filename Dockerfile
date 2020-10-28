FROM ruby:2.6.6

# Install 3rd Party Dependencies
RUN apt update && apt -y install nodejs postgresql-client
RUN gem install bundler:2.1.4

# Working directory
RUN mkdir /app
WORKDIR /app

# Script run when container first starts.
COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT [ "/app/docker-entrypoint.sh" ]
EXPOSE 3000
EXPOSE 5432
EXPOSE 6379

## Commands to Note
# Sets Docker-Compose Environment Variables if errors occur
# eval $(egrep -v '^#' .env | xargs) docker-compose config

# If no password is provided you can exec into the redis images command line
# docker exec -it redis_cache redis-cli

# Allows for running Poke-Simple-API with Binding.pry Support
# docker-compose run --service-ports web