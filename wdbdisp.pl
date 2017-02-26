#!/usr/local/bin/perl
#### ◇WDB 設定ファイル表示「WDBDISP」
#### Copyright 1999-2001 GORRY. 
#### mailto: gorry@hauN.org 
#### 
#### History: 
#### 2001/06/18 V2.01 自動的にパスワード作成画面に移行するよう修正。
#### 1999/04/16 V1.00 公開。
#### 1999/04/16 V0.00 新規作成。 

########################################################################
### ユーザー毎の設定 
#

$DEBUG    = 1 if ( !defined( $DEBUG ) );
$DEBUGOUT = "WDBDISP.debug" if ( !defined( $DEBUGOUT ) );

########################################################################
### メイン 
#

require 'wdblib.pl';
$TMPWDBFILE  = "temp.wdb";
$PASSWDFILE  = "upload.pass";

&Initialize();
&GetArg();

if ( $CGI{'INFO'} ne "" ) {
	print "Content-Type: text/html\n\n";
}

if ( !(-e $PASSWDFILE ) ) {
	print <<EOF;
<HTML><HEAD><TITLE>WDB Maintainance Display</TITLE></HEAD>
<BODY><DIV>Not register password!<BR><A HREF="mkpasswd.html">[Push this]</A> to set password.</DIV>
</BODY></HTML>
EOF
	exit 1;
}

foreach $i ( sort keys %CGI ) {
#	printf( "\$CGI{%s} = %s<BR>\n", $i, $CGI{$i} );
}

&ReadCFGFile();

open (PASS, $PASSWDFILE )||die "$PASSWDFILE not exist.\n";
$passwd = <PASS>;
close(PASS);

# print "1\n";

$PASS = $CGI{'remotepass'};
$PASS = $CGI{'directpass'} if ( $PASS eq "" );

$reqpass = 0;
if ( $CGI{'remotecmd'} ne "" ) {
	$PASS = $CGI{'remotepass'};
	$reqpass = !0;
}
if ( $CGI{'directcmd'} ne "" ) {
	$PASS = $CGI{'directpass'};
	$reqpass = !0;
}

# print "2\n";

if ( $reqpass ) {
	if ( crypt( $PASS, "wdb" ) ne $passwd ) {
		print "Password Error. \n";
		exit 1;
	}
}

# print "3\n";

$reqwrite = 0;
$REMOTE = $CGI{'NOW_REMOTE'};
if ( $CGI{'remoterefer'} ne "" ) {
# print "4a\n";
	$REMOTE = $CGI{'REMOTE'};
} elsif ( ($CGI{'remotecmd'} ne "") && ($CGI{'remotemode'} eq "read") ) {
# print "4b\n";
	$REMOTE = $CGI{'remotecodename'};
} elsif ( ($CGI{'remotecmd'} ne "") && ($CGI{'remotemode'} eq "write") ) {
	if ( $CGI{'remotecodename'} ne "" ) {
# print "4c\n";
		$REMOTE = $CGI{'remotecodename'};
		&RegisterRemote( $REMOTE, 
		                $CGI{'remoteuri'}, 
		                $CGI{'remotetitle'}, 
		                $CGI{'remoteauthor'}, 
		                $CGI{'remotevirtual'}, 
		                $CGI{'remotemark'}, 
		                $CGI{'remotesaveas'} 
		);
# print "4c-2\n";
		$reqwrite = !0;
	}
} elsif ( ($CGI{'remotecmd'} ne "") && ($CGI{'remotemode'} eq "delete") ) {
	if ( $CGI{'remotecodename'} ne "" ) {
# print "4d\n";
		$REMOTE = $CGI{'remotecodename'};
		&UnregisterRemote( $REMOTE );
		$reqwrite = !0;
	}
}

# print "5\n";

$DIRECT = $CGI{'NOW_DIRECT'};
if ( $CGI{'directrefer'} ne "" ) {
# print "6a\n";
	$DIRECT = $CGI{'DIRECT'};
} elsif ( ($CGI{'directcmd'} ne "") && ($CGI{'directmode'} eq "read") ) {
# print "6b\n";
	$DIRECT = $CGI{'directcodename'};
} elsif ( ($CGI{'directcmd'} ne "") && ($CGI{'directmode'} eq "write") ) {
	if ( $CGI{'directcodename'} ne "" ) {
# print "6c\n";
		$DIRECT = $CGI{'directcodename'};
		&RegisterDirect( $DIRECT, 
		                 $CGI{'directuri'}, 
		                 $CGI{'directtitle'}, 
		                 $CGI{'directauthor'}, 
		                 $CGI{'directvirtual'}, 
		                 $CGI{'directmethod'}, 
		                 $CGI{'directcomment'}, 
		                 $CGI{'directkey'} 
		);
# print "6c-2\n";
		$reqwrite = !0;
	}
} elsif ( ($CGI{'directcmd'} ne "") && ($CGI{'directmode'} eq "delete") ) {
	if ( $CGI{'directcodename'} ne "" ) {
# print "6d\n";
		$DIRECT = $CGI{'directcodename'};
		&UnregisterDirect( $DIRECT );
		$reqwrite = !0;
	}
}


# print "7\n";

if ( $reqwrite ) {
# print "$TMPWDBFILE open\n";
	open( WDB, ">$TMPWDBFILE" )||die "$TMPWDBFILE cannot open.\n";
	$lastselect = select;
	select( WDB );
	&Print_WDBFileAll();
	select( $lastselect );
	close( WDB );
	close( STDIN );
# print "mv $TMPWDBFILE $WDBFILE\n";
	system( "mv $TMPWDBFILE $WDBFILE" );
# print "8\n";
	if ( $MAILTO ne "" ) {
		open( WDB, "|$MAILCMD $MAILTO" )||die "$MAILCMD cannot open.\n";
		$lastselect = select;
		select( WDB );
		&Print_WDBFileAll();
		select( $lastselect );
		close( WDB );
	}

}

# print "9\n";

&Print_WDBDISPHTML( $REMOTE, $DIRECT, $PASS );

# print "10\n";

########################################################################
1;
# [EOF]
