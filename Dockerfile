# Use Ubuntu as base image
FROM ubuntu:20.04

# Set working directory in container
WORKDIR /app

# Install OpenJDK 17, curl, and other necessary tools
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk curl gnupg

# Install sbt
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list && \
    curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x99E82A75642AC823" | apt-key add && \
    apt-get update && \
    apt-get install -y sbt

# Copy necessary files
COPY . /app

# Build project
RUN sbt package

# Make sure scripts are executable
RUN chmod +x /app/bin/start-uc-server /app/bin/uc

# Add /app/bin to PATH
ENV PATH="/app/bin:${PATH}"

# Expose port app runs on
EXPOSE 8080

# Run Unity Catalog server
CMD ["/bin/bash", "/app/bin/start-uc-server"]
