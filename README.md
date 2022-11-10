# Generate PDF for BioHackrXiv.org

We use pandoc with LaTeX templates to generate the PDF from markdown
that can be submitted to https://biohackrxiv.org/. Note we also have plans for
an online tool that can do same from
http://biohackrxiv.genenetwork.org/.


# Quick start

BioHackrXiv use [pandoc flavored markdown](https://pandoc.org/MANUAL.html#pandocs-markdown). It is very simple. See

=> https://github.com/biohackrxiv/bhxiv-gen-pdf/blob/master/example/logic/paper.md

and the raw text version

=> https://raw.githubusercontent.com/biohackrxiv/bhxiv-gen-pdf/master/example/logic/paper.md

It *can* embed LaTeX because pandoc generates LaTeX from markdown as an intermediate step towards generating the final PDF.

The easiest start is to take the files in ./example/doc and modify them. Don't change the file names as they are used to generate the final paper. In fact, you can copy these files into your own git repo and continue from there.

We have a web interface that allows you to generate the PDF at

=> http://preview.biohackrxiv.org/

Paste in the base URL for your repo and the tool will find the paper.md.

Notes:

1. Do not paste the path to the paper itself - only the base repo URL.
2. One repo can not contain multiple paper.md's. It will pick the first one it finds.
3. For biohackathons it pays to add a template repo people can template from, e.g

=> https://github.com/biohackrxiv/bhxiv-gen-pdf-template

# Introduction


Here you find the required steps to run to code on your own. There is also a [dockerized version](#run-via-docker).

If you find any bugs, please propose improvements via PRs. Thanks!

# Prerequisites

- ruby
- pandoc
- pandoc-citeproc
- pdflatex
- biblatex

Confirmed versions of the library can be found in [Dockerfile](https://github.com/biohackrxiv/bhxiv-gen-pdf/blob/master/docker/Dockerfile)

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

## Run tests

    ruby -I lib test/test_generator.rb
