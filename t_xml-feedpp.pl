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
			print 'jvn_title: ', $_->title(),"\n";
			print 'jvn_link: ', $_->link(),"\n";
			print 'jvn_description: ', $_->description(),"\n";
			
			# get() 利用で取得できる　（参考：http://milk-tea.myvnc.com/blog/adiary.cgi/0173）
			print 'jvn_publisher: ', $_->get("dc:publisher"),"\n";
			print 'jvn_creator: ', $_->get("dc:creator"),"\n";
			print 'jvn_modified: ', $_->get("dcterms:modified"),"\n";
			print 'jvn_date: ', $_->get("dc:date"),"\n";
			print 'jvn_identifier: ', $_->get("sec:identifier"),"\n";
			print 'jvn_issued: ', $_->get("dcterms:issued"),"\n";
			print 'jvn_about: ', $_->get("-rdf:about"),"\n";
			
			# 2層
			print 'jvn_cvss_severity: ', $_->get('sec:cvss/-severity'),"\n";
			print 'jvn_cvss_vector: ', $_->get('sec:cvss/-vector'),"\n";
			print 'jvn_cvss_version: ', $_->get('sec:cvss/-version'),"\n";
			print 'jvn_cvss_score: ', $_->get('sec:cvss/-score'),"\n";
			print 'jvn_cpe_title: ', $_->get('sec:cpe-item/sec:title'),"\n";
			print 'jvn_cpe_name: ', $_->get('sec:cpe-item/-name'),"\n";
			print 'jvn_cpe_vname: ', $_->get('sec:cpe-item/sec:vname'),"\n";
			
			# sec:references は　-id, -source, #text の3要素からなるハッシュ
			print 'jvn_references: ', $_->get('sec:references'),"\n";
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
