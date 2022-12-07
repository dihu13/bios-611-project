.PHONY: clean
SHELL: /bin/bash

Report.html:\
 Report.Rmd\
 Report_files/figure-latex/unnamed-chunk-2-1.pdf Report_files/figure-latex/unnamed-chunk-3-1.pdf\
 Report_files/figure-latex/unnamed-chunk-4-1.pdf Report_files/figure-latex/unnamed-chunk-5-1.pdf\
 Report_files/figure-latex/unnamed-chunk-7-1.pdf Report_files/figure-latex/unnamed-chunk-9-1.pdf\
 Report_files/figure-latex/unnamed-chunk-10-1.pdf  Report_files/figure-latex/unnamed-chunk-11-1.pdf\     
	Rscript -e "rmarkdown::render('Report.Rmd',output_format='html_document')"

clean:
	rm -f Report.pdf


figures/pie-chart.png figures/pie-chart1.png figures/scatter.png: 5-King.R source_data/battles.csv
	Rscript 5-king.R

figures/corrplot.pdf figures/variance_explain.png figures/plot.team.png figures/cluster.pdf: Cluster_Analysis.R source_data/character-deaths.csv source_data/character-predictions.csv
	Rscript Cluster_Analysis.R	


