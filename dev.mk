EDIT = gvim -f

export:
	$(MAKE) subclone
	cp code/DHS_convert/local.mk subclone/mc_status/code/DHS_convert/
	cd subclone/mc_status/ && make baseline
