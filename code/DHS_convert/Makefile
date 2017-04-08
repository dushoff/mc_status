# DHS_convert
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: converted/Kenya_IV.DHS.IV.men.Rout 

converted/Kenya_IV.DHS.IV.men.Rout:

##################################################################

# make files

Sources = Makefile .gitignore 

dirroot = ../../
code = $(dirroot)/code
data = $(dirroot)/data
converted = $(data)/DHS_convert
convert_rules = $(code)/DHS_convert

-include local.mk
ms = $(code)/makestuff

##################################################################

# Pointers to upstream and downstream directories

downloaded = $(data)/DHS_downloads
converted = $(data)/DHS_convert

######################################################################

### Directories

Makefile: downloaded converted

## Folder for RData files made here
converted: $(converted)
	$(lnf)
$(converted):
	$(MKDIR)

## Folder for .sav files downloaded from DHS
downloaded: $(downloaded)
	$(lnf)

##################################################################

### Reading, trimming ...

### This file was automatically made by the DHS overview repo, but is included here because the scraping pipeline is not robust
### Get fancy filenames
include standard.files.mk

### GPS files
.PRECIOUS: converted/%.gps.Rout
converted/%.gps.Rout: convert_gps.R

### HIV files 
.PRECIOUS: converted/%.hiv.Rout
converted/%.hiv.Rout: convert.R convert_hiv.R
	$(run-R)

### Dataset files 
### Separate specifications for each phase!
### Fix (or make sure to add the next phase before it makes you crazy!)
.PRECIOUS: converted/%.AIS.V.adults.Rout converted/%.AIS.VI.adults.Rout
converted/%.AIS.V.adults.Rout converted/%.AIS.VI.adults.Rout: convert.R convert_dataset.R
	$(run-R)

.PRECIOUS: converted/%.DHS.IV.women.Rout converted/%.DHS.V.women.Rout converted/%.DHS.VI.women.Rout converted/%.DHS.VII.women.Rout
converted/%.DHS.IV.women.Rout converted/%.DHS.V.women.Rout converted/%.DHS.VI.women.Rout converted/%.DHS.VII.women.Rout: convert.R convert_dataset.R
	$(run-R)

.PRECIOUS: converted/%.DHS.IV.men.Rout converted/%.DHS.V.men.Rout converted/%.DHS.VI.men.Rout converted/%.DHS.VII.men.Rout
converted/%.DHS.IV.men.Rout converted/%.DHS.V.men.Rout converted/%.DHS.VI.men.Rout converted/%.DHS.VII.men.Rout: convert.R  convert_mnames.R convert_dataset.R
	$(run-R)

.PRECIOUS: converted/%.DHS.IV.cr.Rout converted/%.DHS.V.cr.Rout converted/%.DHS.VI.cr.Rout converted/%.DHS.VII.cr.Rout
converted/%.DHS.IV.cr.Rout converted/%.DHS.V.cr.Rout converted/%.DHS.VI.cr.Rout converted/%.DHS.VII.cr.Rout: convert.R  convert_dataset.R
	$(run-R)

##################################################################

-include $(ms)/os.mk
-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/wrapR.mk
