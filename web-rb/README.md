# Web-server in Ruby/Sinatra/Docker

For testing:

```
$ docker build -t bhxiv-app:test .
$ docker run -it --rm -p 9292:9292 bhxiv-app:test
```

To run on background:

```
$ docker run -d --rm -p 9292:9292 bhxiv-app:test
```

To save intermediate files on local storage:

```
$ docker run -d --rm -v $(pwd)/tmp:/tmp -p 9292:9292 bhxiv-app:test
```
