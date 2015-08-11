use LWP::UserAgent;

my $url = q{http://www.oricon.co.jp/rank/js/d/2015-05-07/};
my $chrome = q{Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36};

# Create a user agent object
$ua = LWP::UserAgent->new;
$ua->agent($chrome);

# Create a request
my $req = HTTP::Request->new(POST => $url);
$req->content_type('application/x-www-form-urlencoded');
$req->content('query=libwww-perl&mode=dist');

# Pass request to the user agent and get a response back
my $res = $ua->request($req);

# Check the outcome of the response
if ($res->is_success) {
  print $res->content;
}
else {
  print $res->status_line, "\n";
}