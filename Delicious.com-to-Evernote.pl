#!/usr/bin/perl

# use module
use XML::Simple;
use XML::LibXML;

binmode(STDOUT, ':utf8');

# create object
$xml = new XML::Simple (KeyAttr=>[]);

# read XML file
$data = $xml->XMLin("all.xml");

sub escape {
  my($str) = splice(@_);
  return XML::LibXML::Document->new('1.0', 'UTF-8')->createTextNode($str)->toString;
}

sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

print "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
print "<!DOCTYPE en-export SYSTEM \"http://xml.evernote.com/pub/evernote-export.dtd\">";
print "<en-export export-date=\"20101219T130824Z\" application=\"Evernote/Windows\" version=\"4.1\">";

my $n = 1;

foreach $p (reverse(@{$data->{post}}))
{
	print "<note>\n";
	if (trim(escape($p->{description})) ) { 
		print "<title>",escape($p->{description}),"</title>\n";
	} else {
		print "<title>#Unreadable</title>\n";
	}
	print "<content>\n";
	print "<![CDATA[<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
	print "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">\n";
	print "<en-note><a href=\"",escape($p->{href}),"\">",escape($p->{description}),"</a>",escape($p->{extended}),"</en-note>]]>\n";
	print "</content>\n";
	print "<created>",substr($p->{time},0,4),substr($p->{time},5,2),substr($p->{time},8,5),substr($p->{time},14,2),substr($p->{time},17,3),"</created>\n";
	print "<updated>",substr($p->{time},0,4),substr($p->{time},5,2),substr($p->{time},8,5),substr($p->{time},14,2),substr($p->{time},17,3),"</updated>\n";
	
    my @tags = split(' ', $p->{tag});
	foreach my $t (@tags) {
	   print "<tag>",$t,"</tag>\n";
	}
	print "<tag>delicious:bookmarks</tag>\n";
	print "<note-attributes>";
	print "<source-url>",escape($p->{href}),"</source-url>";
	print "</note-attributes>\n";
 	print "</note>\n";	
	}
print "</en-export>\n";
