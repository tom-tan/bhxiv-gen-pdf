# Generate PDF for BioHackrXiv.org

We use pandoc with LaTeX templates to generate the PDF from markdown
that can be submitted to https://biohackrxiv.org/. Note we also have plans for
an online tool that can do same from
http://biohackrxiv.genenetwork.org/.

Here you find the required steps to run to code on your own. There is also a [dockerized version](#run-via-docker).

If you find any bugs, please propose improvements via PRs. Thanks!

# Prerequisites

- ruby
- pandoc
- pandoc-citeproc
- pdflatex
- biblatex

Confirmed versions of the library can be found in [Dokerfile](https://github.com/biohackrxiv/bhxiv-gen-pdf/blob/master/docker/Dockerfile)

# Install

Clone this git repository and install the prerequisites listed above

# Run

Generate the PDF with

    ./bin/gen-pdf [dir] [bioh]

where *dir* points to a directory where paper.md and paper.bib reside
and *bioh* refers to the event. Example events (for a full list see ./bin/gen-pdf):

    "Japan2019", "France2019", "Covid2020"

For example from the repository try

    ./bin/gen-pdf example/logic/ "Covid2020"

which will currently generate the paper as *paper.pdf*.

# Run via Docker

Build docker container and run

    docker build -t biohackrxiv/gen-pdf:local -f docker/Dockerfile .
    docker run --rm -it -v $(pwd):/work -w /work biohackrxiv/gen-pdf:local gen-pdf /work/example/logic

Note that the current working directory of host machine is mounted on `/work` inside the container

# Run via GNU Guix

The [guix-deploy](./.guix-deploy) starts a Guix container which allows running
the generator and tests.

# Trouble shooting

If you are not using Docker or Guix you may need to explicitely add ruby

    ruby bin/gen-pdf [dir]
