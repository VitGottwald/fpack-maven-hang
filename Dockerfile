FROM maven:3.3-jdk-8
RUN apt update
RUN apt install make
ADD . /app-src
WORKDIR /app
ENV PATH="/app/sapho-server-fe/nodejs/node/yarn/dist/bin:/app/sapho-server-fe/nodejs/node:$PATH"
