#!/usr/local/bin/perl
#### ◇HTTP更新フォームパスワード生成 mkpasswd.pl V2.01 
#### Copyright 1998-2001 GORRY. 
#### mailto: gorry@hauN.org 
#### 
#### テスト済ターゲットはFreeBSDのみ。 
#### 
#### History: 
#### 2001/06/18 V2.01 自動的に管理画面に移行するよう修正。
#### 1998/12/14 V1.01 新規作成。 

require 'jcode.pl';

print "Content-Type: text/html\n\n";
print "<HTML><HEAD><TITLE>WDB password registration</TITLE></HEAD><BODY>\n";

if ( $ENV{'REQUEST_METHOD'} eq "POST" ) {
	$len = $ENV{'CONTENT_LENGTH'} + 0;
	read( STDIN, $str, $len );
} else {
	$str = $ENV{'QUERY_STRING'};
}

@part = split( '&', $str );
foreach $i (@part) {
	( $variable, $value ) = split( '=', $i );
	$value =~ tr/+/ /;
	$value =~ s/%([0-9a-fA-F][0-9a-fA-F])/pack("C", hex($1))/eg;
	&jcode'convert( *value, 'sjis' );
	$value =~ s/\015\012/\012/g;
	$value =~ s/\015/\012/g;
	if ( $cgi{$variable} eq "" ) {
		$cgi{$variable} = $value;
	} else {
		$cgi{$variable} .= "," . $value;
	}
}

$pass = $cgi{ 'pass' };
$retype = $cgi{ 'retype' };

if ( $pass ne $retype ) {
	print "<DIV>NOT EQUAL PASS and RETYPE!</DIV>\n";
	print "</BODY></HTML>!\n";
	exit;
}

$passwordfile = "upload.pass";

if ( -e $passwordfile ) {
	print "<DIV>PASSWORD already exist!</DIV>\n";
	print "</BODY></HTML>!\n";
	exit;
}

if ( !open( PASS, ">$passwordfile" ) ) {
	die "<DIV>$passwordfile cannot open.</DIV>\n";
	print "</BODY></HTML>!\n";
	exit;
}
$a = crypt( $pass, "wdb" );
print PASS $a;
close(PASS);

print "<DIV>PASSWORD registered!</DIV>\n";
print "<DIV><A HREF=\"disp.shtml\">[Push this]</A> to maintain WDB.</DIV>\n";
print "</BODY></HTML>\n";
exit;
