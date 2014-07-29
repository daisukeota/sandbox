use strict;
use warnings;
use Image::ExifTool;

# .torrent の中身確認
my $img;
open ($img, "< C\:\\CentOS-7.0-1406-x86_64-DVD.torrent");

my $exifinfo = Image::ExifTool->new->ImageInfo($img);
close($img);

foreach (sort keys %$exifinfo) {
	print "$_ -----> $$exifinfo{$_}\n";
}


__END__