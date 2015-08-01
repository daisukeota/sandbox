#!/usr/bin/env perl
use XML::FeedPP;

my %jvn_params;
&search_jvn_by_cve('CVE-2015-5477');

sub search_jvn_by_cve{
        # =========================================================================== #
        # 引数は CVN 番号（単一）。JVN API を叩いて CVSS, CWE, CPE を取得する。
        # --------------------------------------------------------------------------- #
        # 応答は RSS フィード
        # ex) http://jvndb.jvn.jp/myjvn?method=getVulnOverviewList&keyword=CVE-2015-5477
        my $source = 'http://jvndb.jvn.jp/myjvn?method=getVulnOverviewList&keyword='."$_";
        my $feed = XML::FeedPP->new( $source, utf8_flag => 0 );
        &dump($feed->get_item());
        print "¥n¥n".'--- 上記データの取得結果 ---'."\n";
        foreach ( $feed->get_item() ){
        		# 普通に取得できる
                print 'title:', $_->title(), "\n";
                print 'description:', $_->description(), "\n";

                # get() 利用で取得できる　（参考：http://worklog.be/archives/3048）
                print 'sec:identifier:', $_->get("sec:identifier"), "\n";
                print '-rdf:about:',$_->get("-rdf:about"), "\n";

                # get() 利用でも取得できない？
                #print 'sec:cpe-item_-name:',$_->get_value("sec:cpe-item"), "\n";
                print 'sec:cpe-item_-name:',$_->get("sec:cpe-item", "sec:vname"), "\n";
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