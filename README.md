duppg
=====

`duppg` is a Docker application that, when built, will clone databases
that have been configured into `pgpass` file. Databases are cloned into a
Docker image. Build-time state can be restored simply by starting a new
instance of the image.


Requirements
------------

You need a functional Docker environment. Setup varies by platform.

  - For Linux, use OS package manager to install `docker` (package name
    varies)
  - For other OSes, install Virtualbox, `docker` and `boot2docker`


Usage
-----

  - Add wanted databases into `pgpass` file (take a copy from
    `pgpass.example`)
  - Build the image with `docker build -t pg-clone .`. Needs to be run when
    state from `pgpass` databases needs to be refreshed.
  - Default command to run the image is `docker run -it -p 5432:5432 --rm
    pg-clone`. After the command, Postgres starts to print its log and server
    is listening at Docker host port `5432`. Exit application by `ctrl-c`. See
    `docker help run` for command customization.

    Username is `postgres`, password is `postgres`.
