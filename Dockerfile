FROM maven:3.3-jdk-8
RUN apt update
RUN apt install make
RUN DEBIAN_FRONTEND=noninteractive apt -yq install vim
#ADD . /app
#WORKDIR /app/sapho-server-fe
#ENV PATH="/app/sapho-server-fe/nodejs/node/yarn/dist/bin:/app/sapho-server-fe/nodejs/node:$PATH"
