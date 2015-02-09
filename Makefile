TARGET=archipelago

export SHELL=/bin/bash
export TEXINPUTS := .:./Styles//:${TEXINPUTS}

# make pdf by default
all: ${TARGET}.pdf

view: ${TARGET}.pdf
	xpdf ${TARGET}.pdf &

# it doesn't really need the .dvi, but this way all the refs are right
%.pdf : %.dvi
	xelatex $*

${TARGET}.bbl: #references.bib
	xelatex ${TARGET}.tex
# get the citations out of the bibliography
	bibtex ${TARGET}
# do it again in case there are out-of-order cross-references
	@xelatex ${TARGET}.tex

${TARGET}.dvi: ${TARGET}.bbl ${TARGET}.tex
	@xelatex  ${TARGET}.tex

# shortcut, so we can say "make ps"
ps: ${TARGET}.ps

${TARGET}.ps: ${TARGET}.dvi
	@dvips -t a4 ${TARGET}.dvi

clean:
	$(RM) *.aux *.ps *.dvi *.bbl *.blg *.lol *.lot *.lof *.log *.out *.toc *.snm *.nav *~ *.vrb

PHONY : ps all clean view
