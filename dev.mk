EDIT = gvim -f

export:
	$(MAKE) subclone
	cp code/DHS_convert/local.mk subclone/mc_status/code/DHS_convert/
	cd subclonemc_status/ && make baseline
