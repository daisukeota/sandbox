# 引数の受け取り
if ( $ARGV[0] eq 'production' ){
	my $YAML_PLANET_DIR = q{\\\\10.1.1.50\\neoflow.jp\\Neoflow-Web\\yaml\\keywordhash\\google.com\\};
	my $YAML_CHTML_DIR  = q{\\\\10.1.1.50\\neoflow.jp\\Neoflow-Web\\yaml\\keywordhash\\google.com\\mobile\\};
}
elsif( $ARGV[0] eq 'dev' ){
	my $YAML_PLANET_DIR = q{\\\\10.1.1.30\\neoflow.jp\\Neoflow-Web\\yaml\\keywordhash\\google.com\\};
	my $YAML_CHTML_DIR  = q{\\\\10.1.1.30\\neoflow.jp\\Neoflow-Web\\yaml\\keywordhash\\google.com\\mobile\\};
}
else{
	die "Please set value for: $0 [ production | dev ]";
}
__END__