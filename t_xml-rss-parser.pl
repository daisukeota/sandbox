#!/usr/bin/env perl
use XML::RSS::Parser;
use LWP::UserAgent;
use HTTP::Cookies;
use HTTP::Request::Common;

# =========================================================================== #
# LWP::UserAgent 設定
# --------------------------------------------------------------------------- #
my $jar		= HTTP::Cookies->new(
#    file	=>	"$ENV{'HOME'}/lwp_cookies.dat",
    file	=>	"./lwp_cookies.dat",
    autosave=>	1,
);
my $ua = LWP::UserAgent->new;
	$ua->agent('Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20100101 Firefox/11.0');
	#$ua->proxy('http','http://prox.jp:8080');
	$ua->cookie_jar($jar);


my %jvn_params;
&search_jvn_by_cve('CVE-2015-5477');

sub search_jvn_by_cve{
        # =========================================================================== #
        # 引数は CVN 番号（単一）。JVN API を叩いて CVSS, CWE, CPE を取得する。
        # --------------------------------------------------------------------------- #
        # 応答は RSS フィード
        # ex) http://jvndb.jvn.jp/myjvn?method=getVulnOverviewList&keyword=CVE-2015-5477
        my $uri = 'http://jvndb.jvn.jp/myjvn?method=getVulnOverviewList&keyword='."@_";
        my $req = GET($uri);
        my $res = $ua->request($req);
        my $parser = XML::RSS::Parser->new();
        my $feed = $parser->parse_string($res->content);
        #&dump($feed->query('item'));
        print '--- 上記データの取得結果 ---'."\n";
        foreach ( $feed->query('item') ){
                # 普通に取得できる
                print 'title:', $_->query('title')->text_content, "\n";
                print 'description:', $_->query('description')->text_content, "\n";
                
                # む？とれない。
                print 'sec:identifier:', $_->query('sec:identifier')->text_content, "\n";
                print '-rdf:about:',$_->query('-rdf:about')->text_content, "\n";
                
                # やっぱり取得できない？
                print 'sec:cpe-item_-name:',$_->query('sec:cpe-item/-name')->text_content, "\n";
        }
        return %jvn_params;
}

sub dump{
        # =========================================================================== #
        # DEBUG: データ構造確認(Data::Dumper)
        # --------------------------------------------------------------------------- #
        use Data::Dumper;
        print Dumper @_;
}

__END__