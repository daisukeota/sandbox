#!/usr/bin/env perl                                                                                                                                                           
# http://diary.overlasting.net/2013-04-10-1.html

use strict;
use warnings;
use utf8;
use autodie;
use File::Which;
use Encode qw/encode_utf8/;
use Log::Minimal qw/infof warnf/;
use Test::TCP;
use Try::Lite;
use Selenium::Remote::Driver;
use YAML;

&main();

sub main {
    my $url = "http://news.livedoor.com/";
    my $xpath = "//*[\@id=\"content\"]/div[1]/div[3]/ul/li[1]/a";
    (&scrape($url, $xpath)) ? infof "Success. ^^" : infof "Fail. orz";
    return;
}

sub scrape {
    my ($url, $xpath) = @_;
    my $bin = scalar which 'phantomjs';
    my @entities = ();
    my $is_success = 1;
    try {
        my $phantomjs = Test::TCP->new(                                                                                                                                       
            code => sub { # 空いてるポートで立ち上げる
                my $port = shift;
                exec $bin, '--webdriver', $port;
                die "cannot execute $bin: $!";
            },
        );
        my $driver = Selenium::Remote::Driver->new(
            remote_server_addr => '127.0.0.1',
            port => $phantomjs->port(),
        );
        my $res = $driver->get($url);
        my $elems = $driver->find_elements($xpath);
        foreach my $elem (@{$elems}) {
            my $link = encode_utf8($elem->get_attribute("href"));
            my $text = encode_utf8($elem->get_text);
            my %hash = (
                'text' => $text,
                'link' => $link,
            );
            push @entities, \%hash;
        }
        $driver->quit();
        print Dump \@entities,
                                                                                                                                                                              
    } '*' => sub {
        warnf($@);
        my $is_success = 0;
    };
    return $is_success;
}