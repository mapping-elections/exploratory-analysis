INCLUDES  := $(wildcard www-lib/*.html)
NOTEBOOKS := $(patsubst %.Rmd, %.html, $(wildcard *.Rmd))

all : index.html
# all : $(NOTEBOOKS)

%.html : %.Rmd $(INCLUDES)
	R --slave -e "set.seed(100); rmarkdown::render('$(<F)')"

index.html : index.Rmd $(INCLUDES) 
# index.html : index.Rmd $(INCLUDES) $(filter-out index.html, $(NOTEBOOKS))

.PHONY : clean
clean :
	rm -rf $(NOTEBOOKS) index.html
