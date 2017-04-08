### mc_status
### Hooks 
current: target

target pngtarget pdftarget vtarget acrtarget: dev 

##################################################################

Sources = Makefile .gitignore README.md LICENSE

## ADVANCED
## The recommended way to change these directories is with a local makefile. 
## The recommended way to make a local makefile is to push a file with a specific name, and then manually link local.mk to your specific local makefile
## local.mk does not exist out of the box; this should not cause problems
dirroot = ./
code = $(dirroot)/code
data = $(dirroot)/data

-include local.mk
ms = $(code)/makestuff

# This is the local configuration we happen to be using right now
Sources += dev.mk
dev:
	/bin/ln -fs dev.mk local.mk

##################################################################

# Pointers to specific upstream directories

mc_data = $(data)/mc_data
selection = $(code)/mc_data

######################################################################

## This stuff is not used here (further upstream), but is recorded for convenience in repo management

convert_code = code/DHS_convert/
Sources += $(convert_code)/README.md $(convert_code)/Makefile $(convert_code)/standard.files.mk
Sources += $(wildcard $(convert_code)/*.R)

downloads = data/DHS_downloads/
Sources += $(downloads)/README.md

######################################################################

Sources += $(wildcard *.R)

### Data sets
sets = ke4 ke7 ls4 ls7 mw4 mw6 mz4 mz6 nm5 nm6 rw5 rw6 tz4 tz6 ug5 ug6 zm5 zm6 zw5 zw6

######################################################################

baseline: combines.output surveys.Rout

### Selecting

### Upstream files are first "converted", then selected. We ask for selected files from the mc_data directory; Upstream rules responsible for asking for converted files.

Sources += $(selection)/README.md $(selection)/Makefile $(selection)/select.csv $(selection)/wselect.R
$(mc_data)/%.Rout:
	cd $(selection) && $(MAKE) selected/$*.Rout

### Recoding
Sources += $(wildcard *.ccsv *.tsv)

ke4.recode.Rout:

.PRECIOUS: %.recode.Rout
%.recode.Rout: $(mc_data)/%.Rout recodeFuns.Rout religion_basic.ccsv partnership_basic.ccsv mccut.csv recode.R
	$(run-R)

recodes.output: $(sets:%=%.recode.Routput)
	cat $^ > $@

recodes.summary.output: $(sets:%=%.recode.summary.Routput)
	cat $^ > $@

######################################################################

.PRECIOUS: %.knowledgeQual.Rout
%.knowledgeQual.Rout: %.recode.Rout knowledge.R qual.R
	$(run-R)

knowledgeQuals.output: $(sets:%=%.knowledgeQual.Routput)
	cat $^ > $@

knowledgeQuals.objects.output: $(sets:%=%.knowledgeQual.objects.Routput)
	cat $^ > $@

knowledgeQuals.summary.output: $(sets:%=%.knowledgeQual.summary.Routput)
	cat $^ > $@

.PRECIOUS: %.mediaQual.Rout
%.mediaQual.Rout: %.recode.Rout media.R qual.R
	$(run-R)

mediaQuals.output: $(sets:%=%.mediaQual.Routput)
	cat $^ > $@

mediaQuals.objects.output: $(sets:%=%.mediaQual.objects.Routput)
	cat $^ > $@

mediaQuals.summary.output: $(sets:%=%.mediaQual.summary.Routput)
	cat $^ > $@


.PRECIOUS: %.knowledgeQuant.Rout
%.knowledgeQuant.Rout: %.knowledgeQual.Rout levelcodes_knowledge.tsv quant.R
	$(run-R)

knowledgeQuants.output: $(sets:%=%.knowledgeQuant.Routput)
	cat $^ > $@

knowledgeQuants.objects.output: $(sets:%=%.knowledgeQuant.objects.Routput)
	cat $^ > $@

knowledgeQuants.summary.output: $(sets:%=%.knowledgeQuant.summary.Routput)
	cat $^ > $@

.PRECIOUS: %.mediaQuant.Rout
%.mediaQuant.Rout: %.mediaQual.Rout levelcodes_media.tsv quant.R
	$(run-R)

mediaQuants.output: $(sets:%=%.mediaQuant.Routput)
	cat $^ > $@

mediaQuants.objects.output: $(sets:%=%.mediaQuant.objects.Routput)
	cat $^ > $@

mediaQuants.summary.output: $(sets:%=%.mediaQuant.summary.Routput)
	cat $^ > $@

######################################################################

## PCA

.PRECIOUS: %.knowledgePCA.Rout
%.knowledgePCA.Rout: %.knowledgeQuant.Rout catPCA.R 
	$(run-R)

knowledgePCAs.output: $(sets:%=%.knowledgePCA.Routput)
	cat $^ > $@

knowledgePCAs.objects.output: $(sets:%=%.knowledgePCA.objects.Routput)
	cat $^ > $@

knowledgePCAs.summary.output: $(sets:%=%.knowledgePCA.summary.Routput)
	cat $^ > $@

.PRECIOUS: %.mediaPCA.Rout
%.mediaPCA.Rout: %.mediaQuant.Rout catPCA.R
	$(run-R)

mediaPCAs.output: $(sets:%=%.mediaPCA.Routput)
	cat $^ > $@

mediaPCAs.objects.output: $(sets:%=%.mediaPCA.objects.Routput)
	cat $^ > $@

mediaPCAs.summary.output: $(sets:%=%.mediaPCA.summary.Routput)
	cat $^ > $@

.PRECIOUS: %.combined.Rout
%.combined.Rout: %.recode.Rout %.knowledgePCA.Rout.envir %.mediaPCA.Rout.envir combinePCA.R
	$(run-R)

combines.output: $(sets:%=%.combined.Routput)
	cat $^ > $@

combines.objects.output: $(sets:%=%.combined.objects.Routput)
	cat $^ > $@

combines.summary.output: $(sets:%=%.combined.summary.Routput)
	cat $^ > $@

######################################################################

## Combine all of the surveys
## We already have a country code, but we need to code surveys as new or old.

surveys.Rout: $(sets:%=%.combined.Rout.envir) surveys.R
	$(run-R)

#####################################################################

finalrecode.Rout: surveys.Rout finalrecode.R
	$(run-R)

tables.Rout: finalrecode.Rout tables.R
	$(run-R)

old_tables.Rout: tables.Rout table_funs.R old_tables.R
	$(run-R)

old_table.tex: old_tables.Rout 

old_table.pdf: old_table.tex
	pdflatex old_table.tex

new_tables.Rout: tables.Rout table_funs.R new_tables.R
	$(run-R)

new_table.tex: new_tables.Rout

new_table.pdf: new_table.tex
	pdflatex new_table.tex

######################################################################

## Fit the main models
condomStatus.Rout: surveys.Rout condomStatus.R
partnerYearStatus.Rout: surveys.Rout partnerYearStatus.R

## Variable p-values
condomStatus_varlvlsum.Rout partnerYearStatus_varlvlsum.Rout:
%_varlvlsum.Rout: %.Rout varlvlsum.R
	$(run-R)

condomStatus_isoplots.Rout partnerYearStatus_isoplots.Rout:
.PRECIOUS: %_isoplots.Rout
%_isoplots.Rout: %_varlvlsum.Rout ordfuns.R plotFuns.R iso.R
	$(run-R)

## Interaction plots (status models only)
.PRECIOUS: %_intplots.Rout
condomStatus_intplots.Rout:
partnerYearStatus_isoplots.Rout:
%_intplots.Rout: %.Rout ordfuns.Rout plotFuns.Rout intfuns.Rout intplot.R
	$(run-R)

## Interaction summaries

condomStatus_int.Rout:
partnerYearStatus_int.Rout:

.PRECIOUS: %_int.Rout
%_int.Rout: %_intplots.Rout ordfuns.Rout effectSize.R
	$(run-R)

### Makestuff

Sources += $(wildcard $(ms)/*.mk)
Sources += $(wildcard $(ms)/RR/*.*)
Sources += $(wildcard $(ms)/wrapR/*.*)

-include $(ms)/os.mk
-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/wrapR.mk

