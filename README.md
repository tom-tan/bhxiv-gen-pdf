# Generate PDF for BioHackrXiv.org

We use pandoc with LaTeX templates to generate the PDF from markdown
that can be submitted to https://biohackrxiv.org/. Note we also have
an online tool that can do same from
http://biohackrxiv.genenetwork.org/.

# Prerequisites

- ruby
- pandoc
- pandoc-citeproc
- pdflatex
- biblatex

# Install

Clone this git repository and install the prerequisites listed above

# Run

Generate the PDF with

    ./bin/gen-pdf [dir]

where *dir* points to a directory where paper.md and paper.bib reside.
For example from the repository try

    ./bin/gen-pdf example/logic/

which will currently generate the paper as *paper.pdf*.

# Run via Docker

Build docker container and run

    docker build -t biohackrxiv/gen-pdf:local -f docker/Dockerfile .
    docker run --rm -it -v $(pwd):/work -w /work biohackrxiv/gen-pdf:local gen-pdf /work/example/logic

Note that the current working directory of host machine is mounted on `/work` inside the container

# Trouble shooting

On some systems you may need to explitely add ruby

    ruby bin/gen-pdf [dir]
