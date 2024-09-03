# Use the official Ruby image as the base image
FROM ruby:3.3-alpine

# Set environment variables
ENV RAILS_ENV=development \
    BUNDLE_JOBS=4 \
    BUNDLE_PATH=/gems

# Install dependencies
RUN apk update && \
    apk add --no-cache \
    nodejs \
    postgresql-client \
    build-base \
    git \
    tzdata \
    bash

# Set up the working directory
WORKDIR /app

# Install Rails
RUN gem install rails

# Copy the Gemfile and Gemfile.lock
COPY Gemfile* ./

# Install Gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Ensure the Rails server runs on all interfaces
RUN echo "rails s -b 0.0.0.0" >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Expose port 3000 for the Rails server (not needed if not starting the server immediately)
EXPOSE 3000

# Set the default command to run bash
CMD ["bash"]
