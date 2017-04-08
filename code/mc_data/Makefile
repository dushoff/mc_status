
# This directory has code to select specific variables for our MC analyses. It is based on the repo at 

# make files

Sources = Makefile .gitignore 
# include $(ms)/perl.def

### Directory basis
dirroot = ../../
code = $(dirroot)/code
data = $(dirroot)/data

### Directories
converted = $(data)/DHS_convert
convert_rules = $(code)/DHS_convert
selected = $(data)/mc_data

-include local.mk
ms = $(code)/makestuff

##################################################################

## Content

## converted is where we keep simple, slightly cleaned R versions of DHS sets
## convert_rules are the rules for converting them
converted/%: $(converted) 
	cd $(convert_rules) && $(MAKE) converted/$*

converted: $(converted)
	$(lnf)

$(converted):
	$(mkdir)

Sources += select.csv
selected/%.Rout: select.csv wselect.R 
	$(MAKE) selected
	$(run-R)

selected: $(selected)
	$(lnf)

now: $(selected)
	ls $<

$(selected):
	mkdir $@

######################################################################

## Sets and short names
## These rules are made by browsing standard.files.mk
selected/ke4.Rout: converted/Kenya_IV.DHS.IV.men.Rout
selected/ke7.Rout: converted/Kenya_VII.DHS.VI.men.Rout
selected/ls4.Rout: converted/Lesotho_IV.DHS.IV.men.Rout
selected/ls7.Rout: converted/Lesotho_VII.DHS.VI.men.Rout
selected/mw4.Rout: converted/Malawi_IVa.DHS.IV.men.Rout
selected/mw6.Rout: converted/Malawi_VI.DHS.V.men.Rout
selected/mw7.Rout: converted/Malawi_VII.DHS.VII.men.Rout
selected/mz4.Rout: converted/Mozambique_IV.DHS.IV.men.Rout
selected/mz6.Rout: converted/Mozambique_VI.DHS.VI.men.Rout
selected/nm5.Rout: converted/Namibia_V.DHS.V.men.Rout
selected/nm6.Rout: converted/Namibia_VI.DHS.VI.men.Rout
selected/rw5.Rout: converted/Rwanda_V.DHS.IV.men.Rout
selected/rw6.Rout: converted/Rwanda_VI.DHS.VI.men.Rout
selected/rw7.Rout: converted/Rwanda_VII.DHS.VI.men.Rout
selected/tz4.Rout: converted/Tanzania_IVa.DHS.IV.men.Rout
selected/tz6.Rout: converted/Tanzania_VI.DHS.V.men.Rout
selected/tz7.Rout: converted/Tanzania_VII.DHS.VII.men.Rout
selected/zm5.Rout: converted/Zambia_V.DHS.V.men.Rout
selected/zm6.Rout: converted/Zambia_VI.DHS.VI.men.Rout
selected/zw5.Rout: converted/Zimbabwe_V.DHS.V.men.Rout
selected/zw6.Rout: converted/Zimbabwe_VI.DHS.VI.men.Rout
selected/zw7.Rout: converted/Zimbabwe_VII.DHS.VII.men.Rout
selected/ug5.Rout: converted/Uganda_V.DHS.V.men.Rout
selected/ug6.Rout: converted/Uganda_VI.DHS.VI.men.Rout

# Older Malawi; not used
# converted/Malawi_IVb.DHS.IV.men.Rout: converted/mwmr41fl.sav

sets = ke4 ke7 ls4 ls7 mw4 mw6 mz4 mz6 nm5 nm6 rw5 rw6 rw7 tz4 tz6 ug5 ug6 zm5 zm6 zw5 zw6 zw7 mw7

### Download and convert all of the MC sets
download: $(sets:%=selected/%.Rout)
selection.out: $(sets:%=selected/%.Rout)
	$(cat)

### Makestuff

-include $(ms)/git.mk
-include $(ms)/wrapR.mk
-include $(ms)/os.mk
