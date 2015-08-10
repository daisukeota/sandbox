#!/usr/bin/env perl
use XML::FeedPP;
use URI::Escape;

my %jvn_params;
&search_jvn_by_cve( uri_escape_utf8('CVE-2015-5477') );

sub search_jvn_by_cve{
        # =========================================================================== #
        # 引数は CVN 番号（単一）。JVN API を叩いて CVSS, CWE, CPE を取得する。
        # --------------------------------------------------------------------------- #
        # 応答は RSS フィード
        # ex) http://jvndb.jvn.jp/myjvn?method=getVulnOverviewList&rangeDatePublic=n&rangeDatePublished=n&rangeDateFirstPublished=n&keyword=CVE-2015-5477&lang=ja
        my $source = 'http://jvndb.jvn.jp/myjvn?method=getVulnOverviewList&rangeDatePublic=n&rangeDatePublished=n&rangeDateFirstPublished=n&keyword='."@_".'&lang=ja';
        print $source."\n";
        my $feed = XML::FeedPP->new( $source, utf8_flag => 0 );
        &dump($feed->get_item());
        
        print "\n\n".'--- 上記データの取得結果 ---'."\n";
        foreach ( $feed->get_item() ){
                # 普通に取得できる
                print 'title:', $_->title(), "\n";
                print 'link:', $_->link(), "\n";
                print 'description:', $_->description(), "\n";

                # get() 利用で取得できる　（参考：http://worklog.be/archives/3048）
                print 'sec:identifier:', $_->get("sec:identifier"), "\n";
                print '-rdf:about:', $_->get("-rdf:about"), "\n";
                
                # get() 利用で取得できる　（参考：http://milk-tea.myvnc.com/blog/adiary.cgi/0173）
                print 'sec:cpe-item_-name:', $_->get('sec:cpe-item/-name'), "\n";
                print 'sec:cvss:', $_->get('sec:cvss/-score'), "\n";
                
                # get() で取得できない場合の取得方法
                print 'sec:cpe-item_sec:title:', $_->{'sec:cpe-item'}->{'sec:title'}, "\n";
                print 'sec:cpe-item_sec:vname:', $_->{'sec:cpe-item'}->{'sec:vname'}, "\n";
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
