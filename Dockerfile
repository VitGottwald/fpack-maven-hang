FROM maven:3.3-jdk-8
RUN apt update
RUN apt install make
WORKDIR /app
ENV PATH="/app/nodejs/node/yarn/dist/bin:/app/nodejs/node:$PATH"
