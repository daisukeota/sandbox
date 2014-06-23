use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::More "no_plan";
use Test::Exception;

my $sel = Test::WWW::Selenium->new( host => "localhost", 
                                    port => 4444, 
                                    browser => "*chrome", 
                                    browser_url => "http://about-threats.trendmicro.com/" );

$sel->open_ok("/us/threatencyclopedia#malware");
$sel->click_ok("id=ctl00_body2_gvMalware_ctl13_lnkNext");
$sel->wait_for_page_to_load_ok("30000");
$sel->click_ok("id=ctl00_body2_gvMalware_ctl13_lnkNext");
$sel->wait_for_page_to_load_ok("30000");
$sel->click_ok("id=ctl00_body2_gvMalware_ctl13_lnkNext");
$sel->wait_for_page_to_load_ok("30000");
$sel->click_ok("id=ctl00_body2_gvMalware_ctl13_lnkNext");
$sel->wait_for_page_to_load_ok("30000");
$sel->click_ok("id=ctl00_body2_gvMalware_ctl13_lnkNext");
