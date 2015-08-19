#!/usr/bin/env perl
use XML::Simple;
use LWP::Simple;
use URI::Escape;

my %jvn_params;
&search_jvn_by_cve( uri_escape_utf8('1999-0005') );

sub search_jvn_by_cve{
        # =========================================================================== #
        # 引数は CVN 番号（単一）。JVN API を叩いて CVSS, CWE, CPE を取得する。
        # --------------------------------------------------------------------------- #
        # 応答は RSS フィード
        # ex) http://jvndb.jvn.jp/myjvn?method=getVulnOverviewList&rangeDatePublic=n&rangeDatePublished=n&rangeDateFirstPublished=n&keyword=CVE-2015-5477&lang=ja
        my $uri = 'http://jvndb.jvn.jp/myjvn?method=getVulnOverviewList&rangeDatePublic=n&rangeDatePublished=n&rangeDateFirstPublished=n&keyword='."@_".'&lang=ja';
        print $uri."\n";
        my $xml = LWP::Simple::get( $uri );
        my $parser = new XML::Simple( SuppressEmpty => undef, forcearray => 1 );
        my $tree = $parser->XMLin( $xml );
        &dump( $tree );
        
        foreach ( $tree->{item} ) {
            print "\n\n".'--- 上記データの取得結果 ---'."\n";
			print 'jvn_title: ', $_->[0]->{'title'}->[0],"\n";
			print 'jvn_link: ', $_->[0]->{'link'}->[0],"\n";
			print 'jvn_description: ', $_->[0]->{'description'}->[0],"\n";
			print 'jvn_publisher: ', $_->[0]->{'dc:publisher'}->[0],"\n";
			print 'jvn_creator: ', $_->[0]->{'dc:creator'}->[0],"\n";
			print 'jvn_modified: ', $_->[0]->{'dcterms:modified'}->[0],"\n";
			print 'jvn_date: ', $_->[0]->{'dc:date'}->[0],"\n";
			print 'jvn_identifier: ', $_->[0]->{'sec:identifier'}->[0],"\n";
			print 'jvn_issued: ', $_->[0]->{'dcterms:issued'}->[0],"\n";
			print 'jvn_about: ', $_->[0]->{'rdf:about'},"\n";
			
			# 2層
			print 'jvn_cvss_severity: ', $_->[0]->{'sec:cvss'}->[0]->{'severity'},"\n";
			print 'jvn_cvss_vector: ', $_->[0]->{'sec:cvss'}->[0]->{'vector'},"\n";
			print 'jvn_cvss_version: ', $_->[0]->{'sec:cvss'}->[0]->{'version'},"\n";
			print 'jvn_cvss_score: ', $_->[0]->{'sec:cvss'}->[0]->{'score'},"\n";
			#print 'jvn_cpe_title: ', &dump( $_->[0]->{'sec:cpe-item'}->[0]->{name}[0] ),"\n";
			#print 'jvn_cpe_name: ', $_->[0]->{'sec:cpe-item/-name'}->[0],"\n";
			#print 'jvn_cpe_vname: ', $_->[0]->{'sec:cpe-item/sec:vname'}->[0],"\n";
			
			# sec:references は　-id, -source, #text の3要素からなるハッシュ
			#print 'jvn_references', $_->get('sec:references'),"\n";
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
