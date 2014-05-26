#!C:\strawberry\perl\bin\perl
# $Id: $
# =========================================================================== #
# McAfee Labs の Threat Intelligence が提供する「Detection Namnes of Recent Malware」
# のページから Malware Name 抽出して PukiWiki へポスト。 MBO FY2014Q2
use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::More "no_plan";
use Test::Exception;

my $sel = Test::WWW::Selenium->new( host => "localhost", 
                                    port => 4444, 
                                    browser => "*chrome", 
                                    browser_url => "http://www.mcafee.com/" );

$sel->open_ok("/threat-intelligence/malware/latest.aspx");

for (my $i=0;$i<=49;$i++){
	#$sel->get_html_source();
	print $sel->get_html_source();
	$sel->click_ok("css=img.MALWARE_LATEST-page-next");
}


__END__