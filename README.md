# Code to accompany [Shi et al., Evidence that Promotion of Male Circumcision did not lead to Sexual Risk Compensation in Prioritized Sub-Saharan Countries](http://dx.doi.org/10.1371/journal.pone.0175928)

To reproduce our work, you will need to download data from DHS, since we are not allowed to supply this, or any of its direct products. You can apply for access at http://dhsprogram.com/.

## Instructions 

These are tested on linux and Mac. Hacking will be required to make it the make rules work on Windows (but the R code should be runnable there).

* Clone or download the repo
* Download the DHS files required into data/DHS_downloads/ (see [README from that directory](data/DHS_downloads/README.md))
* type `make baseline` in a terminal to convert and crunch all the files

Going beyond here may be slow; the models take a while to fit.

You should be able to make targets by saying (for example) `make partnerYearStatus.Rout`, or pictures by saying `make condomStatus_isoplots.Rout.pdf`

## Requirements

* A new-ish version of R, and also several packages. A complete list of packages used in the project is given in packages.R. Some may be less important than others

* perl

* gnu make

## Set up

All of the R code is provided in .R files, and you are free to copy-paste and make use of it. To redo our project without rebuilding it, you will need to use a make-based approach that:

* figures out which R scripts depend on which other scripts
* makes `.wrapR.r` files that are the ones that R actually runs (these load and save data, move .pdf files around, and call the scripts with the real code)
* runs whatever scripts are necessary in the correct order to make the requested files (usually)
* usually avoids unnecessary repetition.

We can provide a complete set of `.wrapR.r` files on request.
