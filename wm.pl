use strict;

undef $/;

my $f = <>;

$f =~ s/.*\nSTART/\n/s;
$f =~ s/\nEND.*/\n/s;

my @out;

foreach my $par (split /\n\n+/, $f){
	chomp;
	$par =~ s/^\s*===\s*(.*?)\s*===\s*$/### $1\n/;
	$par =~ s/^\s*==\s*(.*?)\s*==\s*$/## $1\n/;
	$par =~ s/^\s*=\s*(.*?)\s*=\s*$/# $1\n/;

	# Tables
	$par =~ s/INSERT_TABLE\s+(\w+)\s+(.*?)\.\s+(.*)/\\begin{table}[!hbt]\\input{$2.tex}\\caption{$3}\\label{$1.tab}\\end{table}/g;
	$par =~ s/\(TABLE\s*(.*?)\)/\\tref{$1}/g;

	$par =~ s/MISSING_TABLE\s+(\w+)\s+(.*?)\.\s+(.*)/\\begin{table}[!hbt]\textbf{SKIPPING TABLE}\\caption{$3}\\label{$1.tab}\\end{table}/;

	# Figures
	$par =~ s/INSERT_FIGURE\s+(\w+)\s+(.*?)\.\s+(.*)/![$3]($2.pdf){#fig:$1}/;
	$par =~ s/\(FIGURE\s*(.*?)\)/+\@fig:$1/g;

	$par =~ s/'''(.*?)'''/__$1_}/g;
	$par =~ s/''(.*?)''/_$1_}/g;
	$par =~ s/\(\((.*?)\)\)/CITE{$1}/gs;

	while ($par =~ s/(CITE[{][^}]*),\s+/$1; @/){};
	$par =~ s/CITE[{]([^}]*)[}]/[\@$1]/gs;

	push @out, $par;
}

print join "\n\n", @out;
