.PHONY: clean
SHELL: /bin/bash

report.pdf:\
 report.Rmd\
 figures/pie-chart.png
	Rscript -e "rmarkdown::render('report.Rmd',output_format='pdf_document')"
	mkdir -p tagged_reports/
	cp report.pdf tagged_reports/`git log -1 | head -n 1| cut -d' ' -f2`-report.pdf

clean:
	rm -f report.pdf
	rm -f figures/*.png


figures/pie-chart.png\
 utils.R\
 source_data/battles.csv\
	Rscript 5-king.R
	
assets/comparison_of_heights_and_weights.png: figures/pie-chart.png
	cp figures/pie-chart.png assets/pie-chart.png

