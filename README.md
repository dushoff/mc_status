Code to accompany Shi, Li and Dushoff (add DOI, title, etc.)

To reproduce our work, you will need to download data from DHS, since we can't supply this, or any of its direct products. You can apply for access at http://dhsprogram.com/.

## Instructions 

These are tested on linux; should work on Mac; will need some hacking to work on Windows.

* Clone or download the repo
* Download the DHS files required into data/something
* type `make baseline` in a terminal to convert and crunch all the files

Going beyond here may be slow; the models take a while to fit.

You should be able to make targets by saying (for example) `make partnerYearStatus.Rout`, or pictures by saying `make condomStatus_isoplots.Rout.pdf`

## Requirements

You will need a new-ish version of R, and also several packages. A complete list of packages used in the project is given in packages.R. Some may be less important than others.
