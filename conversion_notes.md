Converting
==========

Our wikitext is recognized (by pandoc) as mediawiki type, but the extra markup is not.

Best would be to convert to .md first, then write a perl script for the extra markup.

For this, though, we used a modified version of the old wt.pl, called wm.pl (wikitext2markup).

Work on this until a good stopping point is reached, and then:

* abandon (git rm) the old .wikitext file

* move new.md to ms.md and make it the main dude (add it to sources).

Figures
=======

I copied the format from the moments project, but I don't know what other magic needs to be added to make it work.

Citations
=========

We have code to parse our wikitext citation style, so need to convert it to markdown style (and see what magic is needed there). Right now using CITE as a placeholder

Tables
======

Who knows? Maybe it would be good to make these in markdown? Or learn more about pandoc and tables.
