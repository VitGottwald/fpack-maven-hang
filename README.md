First clone this repo and cd into it.

Then create a docker image based on official maven docker image. 
The `Dockerfile` in the root of the repo contains instructions 
for docker how to build it.
```
docker build -t fpack-reproduce-hang .
```
Then create a couple of volumes to persist maven and yarn cache,
node_modules, and node/yarn binaries installed by maven (nodejs volume).

This will be handy in case you run the test multiple times so that you do not
have to wait for mvn and yarn downloads and installs all the time.
```
volume create maven-cache
volume create yarn-cache
volume create node-modules
volume create nodejs
```

Run the docker image with the volumes we just created
```
docker run -it --rm --name fpack-hang-container \
  -v maven-cache:/root/.m2 \
  -v yarn-cache:/usr/local/share/.cache/yarn/v1 \
  -v node-modules:/app/node_modules \
  -v nodejs:/app/nodejs \
  fpack-reproduce-hang \
  bash
```
Now you should be in a bash of the container, in the `/app` directory.
Copy the sources from `/app-src` into `/app` and compile them with maven
```
cp /app-src/* 
mvn clean compile
```
You should see maven compiling, installing java packages, node packages and at the end
it should hang like this
```
root@00751bb943a8:/app# mvn clean compile
[INFO] Scanning for projects...
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building sapho-server-fe 5.1.0-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ sapho-server-fe ---
[INFO] 
[INFO] --- frontend-maven-plugin:1.6:install-node-and-yarn (install-node-and-yarn) @ sapho-server-fe ---
[INFO] Node v8.9.4 is already installed.
[INFO] Yarn 1.3.2 is already installed.
[INFO] 
[INFO] --- frontend-maven-plugin:1.6:yarn (yarn-install) @ sapho-server-fe ---
[INFO] Running 'yarn install' in /app
[INFO] yarn install v1.3.2
[ERROR] warning package.json: No license field
[ERROR] warning fpack-maven: No license field
[INFO] [1/5] Validating package.json...
[INFO] [2/5] Resolving packages...
[INFO] success Already up-to-date.
[INFO] Done in 0.13s.
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ sapho-server-fe ---
[WARNING] Using platform encoding (UTF-8 actually) to copy filtered resources, i.e. build is platform dependent!
[INFO] skip non existing resourceDirectory /app/src/main/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ sapho-server-fe ---
[INFO] No sources to compile
[INFO] 
[INFO] --- frontend-maven-plugin:1.6:yarn (build with fastpack) @ sapho-server-fe ---
[INFO] Running 'yarn fast' in /app
[INFO] yarn run v1.3.2
[ERROR] warning package.json: No license field
[INFO] $ ./fpack
[INFO] Building FE builder with fastpack
[INFO] Packed in 0.256s. Bundle: 2Kb. Modules: 3. Cache: disabled. Mode: development.
[INFO] Done in 0.36s.
```
