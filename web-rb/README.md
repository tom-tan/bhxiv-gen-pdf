# Web-server in Ruby/Sinatra/Puma/Nginx on Docker-compose

For testing:

```
$ cd bhxiv-gen-pdf/web-rb
$ docker-compose up --build
```

To run on background:

```
$ docker-compose up -d --build
```

Stop and remove containers:

```
$ docker-compose down
```

# Run with GNU Guix

```
source ./web-rb/.guix-deploy
cd web-rb
puma

Puma starting in single mode...

* Puma version: 5.3.2 (ruby 2.6.5-p114) ("Sweetnighter")
*  Min threads: 0
*  Max threads: 16
*  Environment: production
* Listening on http://0.0.0.0:9292

```
