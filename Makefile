.PHONY: all assets

TYP_SOURCES := $(wildcard template/*.typ)
WEBP_TARGETS := $(patsubst template/%.typ,assets/%.webp,$(TYP_SOURCES))

all: assets

assets: $(WEBP_TARGETS)

%.pdf: %.typ
	typst compile --root . --format pdf $< $@

assets/%.webp: template/%.typ
	typst compile --root . --format png $< $*.tmp.png
	magick $*.tmp.png -bordercolor black -border 1 $@
	rm -f $*.tmp.png
