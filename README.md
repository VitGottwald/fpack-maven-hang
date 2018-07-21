This is an example how to reproduce a failure in fpack when run
on a bound mount in docker.

First run the example with hanging fastpack (master branch) to populate 
your node-modules, and nodejs volumes.

Then checkout this branch and create a docker image based on official 
maven docker image. The `Dockerfile` in the root of the repo contains 
instructions for docker how to build it.
```
docker build -t fpack-reproduce-rename-fail .
```

Run the docker image with the volumes from the hang issue.
```
docker run -it --rm --name fpack-rename-fail-container \
  -v maven-cache:/root/.m2 \
  -v yarn-cache:/usr/local/share/.cache/yarn/v1 \
  -v node-modules:/app/node_modules \
  -v nodejs:/app/nodejs \
  -v "$PWD":/app \
  fpack-reproduce-rename-fail \
  bash
```
Note the `-v "$PWD":/app`. This makes the current directory available
in the docker container under `/app` directory. It is called a bound mount
in docker lingo.

Now you should be in a bash of the container, in the `/app` directory.
Install yarn packages and run fastpack
```
yarn && yarn fast
```
After yarn installs packages, you should see something like:
```
root@0688bf993222:/app# yarn fast
yarn run v1.3.2
warning package.json: No license field
$ ./fpack
Building FE builder with fastpack
fpack: internal error, uncaught exception:
       Unix.Unix_error(Unix.EXDEV, "rename", "/tmp/bb6bff.bundle.js")
       Raised at file "Fastpack/Fastpack.ml", line 221, characters 9-18
       Called from file "src/core/lwt.ml", line 2068, characters 23-28
       Re-raised at file "Fastpack/Fastpack.ml", line 226, characters 7-440
       Re-raised at file "src/core/lwt.ml", line 3008, characters 20-29
       Called from file "src/unix/lwt_main.ml", line 42, characters 8-18
       Called from file "Fastpack/Fastpack.ml" (inlined), line 251, characters 2-52
       Called from file "bin/fpack.ml", line 45, characters 12-45
       Called from file "src/cmdliner_term.ml", line 27, characters 19-24
       Called from file "src/cmdliner.ml", line 27, characters 27-34
       Called from file "src/cmdliner.ml", line 106, characters 32-39
error Command failed with exit code 125.
info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
```
