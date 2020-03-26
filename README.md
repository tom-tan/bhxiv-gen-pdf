* Generate PDF for BioHackrXiv.org

We use pandoc with LaTeX templates to generate the PDF from markdown
that can be submitted to https://biohackrxiv.org/. Note we also have
an online tool that can do same from
http://biohackrxiv.genenetwork.org/.

* Install

Install this repository, ruby and pandoc.

* Run

Generate the PDF with

    ./bin/gen-pdf [dir]

where *dir* points to a directory where paper.md and paper.bib reside.
For example from the repository try

    ./bin/gen-pdf example/logic/

which will generate the paper as *paper.pdf*.
