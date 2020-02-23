;# $Id$
;#
;#  Copyright (c) 1991-1997, 2004-2006, Raphael Manfredi
;#  
;#  You may redistribute only under the terms of the Artistic Licence,
;#  as specified in the README file that comes with the distribution.
;#  You may reuse parts of this distribution only within the terms of
;#  that same Artistic Licence; a copy of which may be found at the root
;#  of the source tree for dist 4.0.
;#
;# $Log: rcsargs.pl,v $
;# Revision 3.0  1993/08/18  12:11:01  ram
;# Baseline for dist 3.0 netwide release.
;#
;#
sub rcsargs {
	local($result) = '';
	local($_);
	while ($_ = shift(@_)) {
		if ($_ =~ /^-/) {
			$result .= $_ . ' ';
		} elsif ($#_ >= 0 && &equiv($_,$_[0])) {
			$result .= $_ . ' ' . $_[0] . ' ';
			shift(@_);
		} else {
			$result .= $_ . ' ' . &other($_) . ' ';
		}
	}
	$result;
}

sub equiv {
	local($s1, $s2) = @_;
	$s1 =~ s|.*/||;
	$s2 =~ s|.*/||;
	if ($s1 eq $s2) {
		0;
	} elsif ($s1 =~ s/$RCSEXT$// || $s2 =~ s/$RCSEXT$//) {
		$s1 eq $s2;
	} else {
		0;
	}
}

sub other {
	local($s1) = @_;
	($dir,$file) = ('./',$s1) unless local($dir,$file) = ($s1 =~ m|(.*/)(.*)|);
	$dir = $TOPDIR . $dir if -d $TOPDIR . "$dir/RCS";
	local($wasrcs) = ($file =~ s/$RCSEXT$//);
	if ($wasrcs) {
		`mkdir $dir` unless -d $dir;
		$dir =~ s|RCS/||;
	} else {
		$dir .= 'RCS/';
		`mkdir $dir` unless -d $dir;
		$file .= $RCSEXT;
	}
	"$dir$file";
}

