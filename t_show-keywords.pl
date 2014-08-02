#!/usr/bin/perl
# $Id: $
# Usage:
#  perl show-keywords.pl [ domain ]
# =========================================================================== #
# genKeywordHash.pl が生成した yaml ファイルを読み込み keyword をリストする
#
#
use strict;
use warnings;
use utf8;
use Encode;

use YAML::Tiny;
use Data::Dumper;

my $YAML_DIR = '';

if ( !defined $ARGV[0] ){
	die "Please set value for: $0 [ domain ]";
}
else{
	$YAML_DIR = q{\\\\10.1.1.50\\neoflow.jp\\Neoflow-Web\\yaml\\keywordhash\\}.$ARGV[0];
}

# =========================================================================== #
# 最新10件の yaml を取得
# 新しい順:	sort { $a->[1] <=> $b->[1] }
# 古い順:	sort { $b->[1] <=> $a->[1] }

opendir ( DIR, $YAML_DIR ) or die "opendir $YAML_DIR failed: $!";

my @files =
	map { $_->[0] }
	sort { $b->[1] <=> $a->[1] }
	map { [ $_, -M "$YAML_DIR/$_" ] }
	grep ( /^[^.]/, readdir DIR );
	close DIR;

for ( my $i=0; $i<=$#files; $i++ ){
	my ($ss, $mm, $hh, $DD, $MM, $YY, $wday, $yday, $isdst) = localtime( ( stat qq|$YAML_DIR/$files[$i]| )[9] );
	$YY += 1900;
	$MM ++;
	my ($yaml) = YAML::Tiny::LoadFile(qq|$YAML_DIR/$files[$i]|);
#	print Data::Dumper->Dumper($data);

	print encode('shiftjis', ($yaml->{plugins}->[0]->{config}->{keyword}) )."\n";
}


__END__
