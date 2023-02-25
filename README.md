# Multi-arch Scratch Images

When creating an image `FROM scratch` the resulting image matches the host machine's architecture.  This is not necessarily what you want if you're doing cross-compilation.

For example,
```bash
$ echo 'FROM scratch' >> Dockerfile
$ echo 'ADD files.arm64v8.tgz' >> Dockerfile
$ docker build . -t foo:arm64                       # where to put arch?

$ docker inspect foo:arm64 | jq -r .[].Architecture
amd64                                               # uh-oh
```

The multi-arch "scratch" images are empty scratch-like images but with the right metadata so that you can do this:

```bash
$ echo 'FROM paleozogt/scratch:arm64v8' >> Dockerfile
$ echo 'ADD files.arm64v8.tgz' >> Dockerfile
$ docker build . -t foo:arm64

$ docker inspect foo:arm64 | jq -r .[].Architecture
arm64                                                # yay!

$ docker inspect foo:arm64 | jq -r .[].Variant
v8                                                   # yay!
```
