#!/usr/local/bin/perl
#### ◇WDB用ライブラリ 「WDBLIB」 V2.06
#### Copyright 1999-2001 GORRY. 
#### mailto: gorry@hauN.org 
#### 
#### History: 
#### 2001/11/28 V2.06 ・Virtualで取得したHTMLからメタ情報収集を行わないようにした。
####                  ・hina.diにhina-2.2beta準拠全フィールドを出力するようにした。
####                  ・hina.diの読み込み時にLast-Modified-Detectedフィールドがない
####                    場合、他から値を補完していた機能を削除した。
#### 2001/11/14 V2.05 ・認識時刻フォーマット追加。
####                    "MM/DD_hh:mm:ss"（１月２３日 １６時５６分０７秒）
#### 2001/11/09 V2.04 ・WDBファイルの行が"COMMENT:"など（":"のあとに空白がない）に
####                    なっていると誤動作するバグを修正。
####                  ・http HEADERに存在するTitle:・Author:に対応。
#### 2001/09/11 V2.03 ・Perl4対応修正。（thanks to SARUMARU）
####                  ・認識時刻フォーマット追加。（thanks to SARUMARU）
####                    "YYYY/MM/DD_hh:mm_PM" （2001/01/23 4:56PM）
####                    "YYYY/MM/DD_PM_hh:mm"（２００１年１月２３日 午後４時５６分）
####                    "MM/DD_hh:mm_PM" （01/23 4:56PM）
####                    "MM/DD_PM_hh:mm"（１月２３日 午後４時５６分）
####                    "MM/DD_PM_hh:"（１月２３日 午後４時）
####                    "MM/DD_hh:"（１月２３日 １６時）
#### 2001/07/11 V2.02 ・WDBファイルのパラメータに": "が入っているとそれ以降の文字列が切れるバグを修正。
#### 2001/05/17 V2.01 ・GETで採ったドキュメントに"^HINA/2.[0-9]$"がある場合の
####                    hina.di処理時に、既存情報をクリアしないバグを修正。
#### 2000/10/17 V2.00 ・朝日奈アンテナ meta data format version 2.2 (HINA/2.2) document 0.9に準拠。
####                  ・従来のLast-Modified-Detectedの役目「現在の更新時刻を最初に検知した時刻」を
####                    X-First-Modified-Detectに移行させ、Last-Modified-Detectedは
####                    「最後に更新時刻を確認した時刻」とした。
####                  ・X-No-Time-In-ContentsをX-LM-Is-FMDに移行。
#### 2000/09/24 V1.16 ・GETで採ったドキュメントに"^HINA/2.[0-9]$"がある場合、
####                    hina.diであるとみなして処理するように変更。
####                  ・"Expires:"を処理・出力するよう変更。
#### 2000/08/03 V1.16 ・hauNikki独自処理を廃止、代わりに"URL: "があるファイルを
####                    hina.diであるとして認識するように変更。
#### 2000/05/25 V1.15 ・X-WDB-Title・X-WDB-Author-Nameを出力するよう変更。
####                  ・GETしたものについて、<TITLE></TITLE>・<META NAME="AUTHOR">を
####                    解析してTitle・Author-Nameを抽出するよう変更。
#### 2000/05/22 V1.15 ・$HTTP_REMOTE_TIMEOUTを追加。
#### 2000/03/14 V1.15 ・hina.diのparse時に、nodelistを捨て損なうために前ブロックの
####                    データを持ち越してしまうことがあるバグを修正。
#### 2000/01/12 V1.14 ・Purveyor（"Purveyor / v1.2 Windows NT"）をクエリ不可
####                    httpdとして追加。
#### 2000/01/05 V1.13 ・"1-Jan-0"形式の日付に対応。
####                  ・"2000年 01月 06日"のような日付を読みとれるよう修正。
#### 2000/01/03 V1.12 ・HINA/2.1に対応。
#### 1999/12/31 V1.11 ・1999/12/31を2000/01/01と誤認するバグを修正。
#### 1999/11/04 V1.10 ・URIのポート番号を認識しないバグを修正。
#### 1999/09/29 V1.09 ・V1.08での
####                    ・「1980/01/01 00:00:00 GMT」の時刻データを無視するよう変更。
####                    を元に戻したうえで、新たに作業をし直した。
####                  ・圧縮diに対応。
#### 1999/09/27 V1.08 ・検索結果行に更新時刻が検知されなかったとき、次の行の
####                    調査を行なわないバグを修正。
####                  ・年号のない更新日を去年と判定するバグを修正。
####                  ・Print_HINATXT()・Print_HINADI()において、
####                    自己取得したデータのみを出力するモードを追加。
####                  ・「1980/01/01 00:00:00 GMT」の時刻データを無視するよう変更。
####                  ・OVERALLモードに「uniqする／しない」モードを新設。
#### 1999/09/22 V1.07 ・タイムゾーンの判定を誤ることがあったのを修正。
####                  ・HINA_TXTの出力がすべて"HINA_OK"になるバグを修正。
####                  ・HEAD/GET失敗時にLast-Modifiedをクリアしないように変更。
#### 1999/09/15 V1.06 ・gmtime()・localtime()の$yearが年でなく「1900年からの
####                    経過年数」であることに起因するY2K問題に対処。
####                  ・タイムゾーンの"+0030"の項を修正。
####                  ・X-No-Time-In-Contentsは"0"でないときのみ出力するよう変更。
#### 1999/09/10 V1.05 ・splitの":[ \t]+"をsplitの":[ \t]*"に変更。
####                  ・BuildRemoteDI()・BuildDirectDI()の引数処理ミスを修正。
####                  ・hina.diのヘッダに"Date:"・"Content-Type:"を出力するようにした。
####                  ・検索キーに".*"を付けたときに正しく切り取らないバグを修正。
####                  ・HEAD取得の時の検索キーを"Last-Modified:"(case insensitive)に
####                    変更した。
####                  ・Last-Modified-Detectedあたりの判定を変更。
#### 1999/09/07 V1.04 ・fragmentを含んだURIを正しく処理しないバグを修正。
####                  ・%dance$$.downは存在時のみ削除するよう変更。
####                  ・hina.diの判定をcase insensitiveに変更。
####                  ・REMOTEでの「Authorized-url:」判定を外した。
####                    つまり、REMOTEは外部をアクセスしない。
####                  ・ExtractNormalURI()はURIが２つ以上含まれる場合に最右でなく最左を
####                    取り出すようにした。
####                  ・$EXTRACTTIMEFORMATに、最後に変換した時刻フォーマットを
####                    残すようにした。これがX-Time-Formatに記録される。
####                  ・年号なしの日付を更新時刻として採れるようにした。
####                  ・検索キーに".*"を付け、前後を切り取れるように変更。
####                  ・512バイト以上の行は分割してキー検索するよう変更。
####                  ・タイムゾーンを追加。
#### 1999/08/27 V1.03 ステータス-200が出るべきときに出ないバグを修正。
####                  ターゲット取得でタイムアウトになったときも更新時刻検索を
####                  行なうよう変更。
####                  %dance.downへのロードを%dance$$.downへ行なうよう変更。
####                  DEBUGOUTを開く位置を変更、CloseDebugFile)を追加。
####                  hauNikki DI対応。
#### 1999/08/26 V1.02 負の値となる日付が出力されるバグを修正。
#### 1999/08/23 V1.01 hina.txtからリモート取得したときにX-No-Time-In-Contentsが
####                  強制的に削除されるのを「updateが検出されたときのみ削除」に
####                  変更。
####                  hina.txtのExpire:をhina.txtそのものの更新時刻から導くよう
####                  仕様追加。
####                  タイムアウトのエラー検出ミスを修正。
####                  -200を「更新時刻が検知できない」エラーとして規定、hina.txtに
####                  "<!--HINA_NOT_DETECTED-->"を出力する。
#### 1999/08/22 V1.00 公開。
#### 1999/07/07 V0.14 GET/HEAD失敗時にリモート情報を復活させる処理を修正。
####                  Last-Modified-Detectedを追加。
####                  X-No-Time-In-Contentsを追加。コンテンツには更新時刻情報が
####                  含まれず、Last-Modified-DetectedをLast-Modifedの代わりに
####                  使うべきであることを"1"で示す。
#### 1999/06/29 V0.13 method指定がない場合にGET取得になってしまっていたのを
####                  HEAD取得に戻す。 
#### 1999/06/28 V0.12 年月日だけのGETに対応。
#### 1999/06/16 V0.11 GET2・HEAD2を新設。
####                  内部処理では秒データを保存し、出力時にカットするよう修正。
####                  hina.diの出力時刻フォーマットに秒を追加。
#### 1999/05/07 V0.10 Overallモード新設。
####                  Host:が間違っていたのを修正。
####                  DI情報のURIに"?"が含まれているときの不都合回避。
#### 1999/04/26 V0.09 Zone以降の余計な文字を落とし忘れるバグを修正。
#### 1999/04/25 V0.08 デバッグプリントの最適化。 
#### 1999/04/22 V0.07 DI情報出力のMethodを複数結果出力対応。
####                  HOP数出力対応。
#### 1999/04/21 V0.06 引数解析の"<>"置換をやめた。 
####                  カレンダー解釈方法を修正。
####                  DI情報が読めないバグを修正。
####                  HINA.TXTの"<!-- HINA"を"<!--HINA"にした。
#### 1999/04/20 V0.05 「Day Month Year hh:mm:ss Zone」のZoneを見落とすバグを修正。 
#### 1999/04/18 V0.04 カレンダー解釈方法を追加。 
#### 1999/04/18 V0.03 カレンダー解釈方法を追加。 
#### 1999/04/17 V0.02 CERN情報がhina.txtに出ないバグを修正。 
#### 1999/04/17 V0.01 アンテナリストからの削除機能を追加。 
#### 1999/04/16 V0.00 新規作成。 

require 'jcode.pl';
require 'wdb.ph';

# &Initialize();
# $a = "2000/01/02 03:04:05";
# $b = &DateToClock($a);
# $c = &ClockToDate($b);
# print $c;
# exit;

########################################################################
### 引数解析 
## GetArg()
#
sub GetArg
{
	local( $i );
	local( $s );
	local( $ss );
	local( $ssym, $val );

	if ( $ENV{'REQUEST_METHOD'} eq "POST" ) {
		read( STDIN, $s, $ENV{'CONTENT_LENGTH'} );
	} else {
		$s = $ENV{'QUERY_STRING'};
	}

	@ss = split( '&', $s );
	foreach $i (@ss) {
		( $sym, $val ) = split( '=', $i );
		$val =~ tr/+/ /;
		$val =~ s/%([0-9a-fA-F][0-9a-fA-F])/pack("C", hex($1))/eg;
		&jcode'convert( *val, $JCODE );
#		$val =~ s/</&lt;/g;
#		$val =~ s/>/&gt;/g;
		$val =~ s/\015\012/\012/g;
		$val =~ s/\015/\012/g;
		if ( $CGI{$sym} eq "" ) {
			$CGI{$sym} = $val;
		} else {
			$CGI{$sym} .= "," . $val;
		}
	}
}

########################################################################
### 初期化 
## Initialize()
#
sub Initialize
{
	local($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);

	open( DEBUGOUT, ">$DEBUGOUT" );

	@REMOTE_CMDNAMELIST = (
	  "URI", 
	  "TITLE", 
	  "AUTHOR", 
	  "VIRTUAL", 
	  "MARK", 
	  "SAVEAS" 
	);
	@DIRECT_CMDNAMELIST = (
	  "URI", 
	  "TITLE", 
	  "AUTHOR", 
	  "VIRTUAL", 
	  "METHOD", 
	  "COMMENT", 
	  "KEY" 
	);
	@HINADI_CMDNAMELIST = (
	  "URL", 
	  "Date", 
	  "Title", 
	  "Author-Name",
	  "Keyword", 
	  "Last-Modified", 
	  "Server", 
	  "Authorized", 
	  "Authorized-url",
	  "Method", 
	  "Content-Type", 
	  "Expire",
	  "Expires",
	  "Last-Modified-Detected",
	  "Virtual",
	  "HINA-Version",
	  "Image-Width",
	  "Image-Height",
	  "X-First-Modified-Detected",
	  "X-LM-Is-FMD",
	  "X-WDB-Title",
	  "X-WDB-Author-Name",

	  # HINA.DI output terminator 
	  "TERMINATE",
	  "User-Agent"
	);
	@DAYOFMONTH = (
	  0,
	  31, 
	  31+28, 
	  31+28+31, 
	  31+28+31+30, 
	  31+28+31+30+31, 
	  31+28+31+30+31+30, 
	  31+28+31+30+31+30+31, 
	  31+28+31+30+31+30+31+31, 
	  31+28+31+30+31+30+31+31+30, 
	  31+28+31+30+31+30+31+31+30+31, 
	  31+28+31+30+31+30+31+31+30+31+30, 
	  31+28+31+30+31+30+31+31+30+31+30+31, 
	);
	@DAYOFMONTH_U = (
	  0,
	  31, 
	  31+29, 
	  31+29+31, 
	  31+29+31+30, 
	  31+29+31+30+31, 
	  31+29+31+30+31+30, 
	  31+29+31+30+31+30+31, 
	  31+29+31+30+31+30+31+31, 
	  31+29+31+30+31+30+31+31+30, 
	  31+29+31+30+31+30+31+31+30+31, 
	  31+29+31+30+31+30+31+31+30+31+30, 
	  31+29+31+30+31+30+31+31+30+31+30+31, 
	);
	@MDAY = (
	  "Sun",
	  "Mon",
	  "Tue",
	  "Wed",
	  "Thu",
	  "Fri",
	  "Sat",
	);
	@MONTH = (
	  "Jan",
	  "Feb",
	  "Mar",
	  "Apr",
	  "May",
	  "Jun",
	  "Jul",
	  "Aug",
	  "Sep",
	  "Oct",
	  "Nov",
	  "Dec",
	);
	%MONTHNAMETOMONTH = (
	  "Jan", 1,
	  "Feb", 2,
	  "Mar", 3,
	  "Apr", 4,
	  "May", 5,
	  "Jun", 6,
	  "Jul", 7,
	  "Aug", 8,
	  "Sep", 9,
	  "Oct", 10,
	  "Nov", 11,
	  "Dec", 12
	);
	%TZNAMETODIFFTIME = (
	  "GMT",0,
	  "UT",0,
	  "EST",+5,
	  "CST",+6,
	  "MST",+7,
	  "PST",+8,
	  "EDT",+4,
	  "CDT",+5,
	  "MDT",+6,
	  "PDT",+7,
	  "A",+1,
	  "B",+2,
	  "C",+3,
	  "D",+4,
	  "E",+5,
	  "F",+6,
	  "G",+7,
	  "H",+8,
	  "I",+9,
	  "K",+10,
	  "L",+11,
	  "M",+12,
	  "N",-1,
	  "O",-2,
	  "P",-3,
	  "Q",-4,
	  "R",-5,
	  "S",-6,
	  "T",-7,
	  "U",-8,
	  "V",-9,
	  "W",-10,
	  "X",-11,
	  "Y",-12,
	  "Z",0,
	  "JST",-9,
	  "ECT",-1,
	  "EET",-2,
	  "ART",-2,
	  "EAT",-3,
	  "MET",-3.5,
	  "NET",-4,
	  "PLT",-5,
	  "IST",-5.5,
	  "BST",-6,
	  "VST",-7,
	  "CTT",-8,
	  "JST",-9,
	  "ACT",-9.5,
	  "AET",-10,
	  "SST",-11,
	  "NST",-12,
	  "MIT",+11,
	  "HST",+10,
	  "AST",+9,
	  "PNT",+7,
	  "IET",+5,
	  "PRT",+4,
	  "CNT",+3.5,
	  "AGT",+3,
	  "BET",+3,
	  "CAT",+1,

	  "+00", 0,
	  "+01", -1,
	  "+02", -2,
	  "+03", -3,
	  "+04", -4,
	  "+05", -5,
	  "+06", -6,
	  "+07", -7,
	  "+08", -8,
	  "+09", -9,
	  "+10", -0,
	  "+11", -11,
	  "+12", -12,
	  "-00", 0,
	  "-01", 1,
	  "-02", 2,
	  "-03", 3,
	  "-04", 4,
	  "-05", 5,
	  "-06", 6,
	  "-07", 7,
	  "-08", 8,
	  "-09", 9,
	  "-10", 0,
	  "-11", 11,
	  "-12", 12,

	  "+0000", 0,
	  "+0030", -0.5,
	  "+0100", -1,
	  "+0130", -1.5,
	  "+0200", -2,
	  "+0230", -2.5,
	  "+0300", -3,
	  "+0330", -3.5,
	  "+0400", -4,
	  "+0430", -4.5,
	  "+0500", -5,
	  "+0530", -5.5,
	  "+0600", -6,
	  "+0630", -6.5,
	  "+0700", -7,
	  "+0730", -7.5,
	  "+0800", -8,
	  "+0830", -8.5,
	  "+0900", -9,
	  "+0930", -9.5,
	  "+1000", -10,
	  "+1030", -10.5,
	  "+1100", -11,
	  "+1130", -11.5,
	  "+1200", -12,
	  "-0000", 0,
	  "-0030", 0.5,
	  "-0100", 1,
	  "-0130", 1.5,
	  "-0200", 2,
	  "-0230", 2.5,
	  "-0300", 3,
	  "-0330", 3.5,
	  "-0400", 4,
	  "-0430", 4.5,
	  "-0500", 5,
	  "-0530", 5.5,
	  "-0600", 6,
	  "-0630", 6.5,
	  "-0700", 7,
	  "-0730", 7.5,
	  "-0800", 8,
	  "-0830", 8.5,
	  "-0900", 9,
	  "-0930", 9.5,
	  "-1000", 10,
	  "-1030", 10.5,
	  "-1100", 11,
	  "-1130", 11.5,
	  "-1200", 12,
	  # terminator 
	  "", 0
	);

	$DEFAULTTZDIFFTIME = 0;
	if ( defined( $TZNAMETODIFFTIME{$TZ} ) ) {
		$DEFAULTTZDIFFTIME = $TZNAMETODIFFTIME{$TZ};
	}
	$TZNAMETODIFFTIME{''} = $DEFAULTTZDIFFTIME;

	$time = time();

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($time);
	$year += 1900;
	if ( $year < 1980 ) {
		$year += 100;
	}
	$NOWTIME = sprintf( "%04d/%02d/%02d %02d:%02d:%02d GMT", $year, $mon+1, $mday, $hour, $min, $sec );
	$THISYEAR = $year;
	$THISMONTH = $mon+1;

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($time+3600);
	$year += 1900;
	if ( $year < 1980 ) {
		$year += 100;
	}
	$IGNORETIME = sprintf( "%04d/%02d/%02d %02d:%02d:%02d GMT", $year, $mon+1, $mday, $hour, $min, $sec );

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($time+3600*$DEFAULT_EXPIRETIME);
	$year += 1900;
	if ( $year < 1980 ) {
		$year += 100;
	}
	$EXPIRETIME = sprintf( "%04d/%02d/%02d %02d:%02d:%02d GMT", $year, $mon+1, $mday, $hour, $min, $sec );

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($time+3600*24);
	$year += 1900;
	if ( $year < 1980 ) {
		$year += 100;
	}
	$TOMORROWTIME = sprintf( "%04d/%02d/%02d %02d:%02d:%02d GMT", $year, $mon+1, $mday, $hour, $min, $sec );

	$FUTURETIME = "9999/12/31 23:59:59 GMT";
	$ERRTIME = "1980/01/01 00:00:00 GMT";

	$NOTIMEINCONTENTS = 0;
}

########################################################################
### デバッグファイルクローズ 
## CloseDebugFile()
#
sub CloseDebugFile
{
	close( DEBUGOUT );
}

########################################################################
### WDBファイル読み込み 
## ReadCFGFile( filename )
#
sub ReadCFGFile
{
	open( WDB, "$NKF $WDBFILE|" ) || die "cannot open [$NKF $WDBFILE|].";

	while (<WDB>) {
		if ( /^REMOTE:/i ) {
			&BuildRemoteDI( $_ );
		}
		if ( /^PAGE:/i ) {
			&BuildDirectDI( $_ );
		}
	}
	close( WDB );
}

########################################################################
### WDBからリモートファイル情報を構築 
## BuildRemoteDI( line )
#
sub BuildRemoteDI
{
	local( $pagename );
	local( $n );
	local( $param );

	shift;
	s/[\012\015]+//;
	split( /:[ \t]+/ );
	if ( @_[1] eq "" ) {
		print DEBUGOUT "line $. : GetRemoteDI(): illegal pagename.";
		exit 1;
	}
	$pagename = @_[1];
	$n = $RPLNO++;
	$RPL[$n] = $pagename;
	$RP{ $pagename } = "defined";
# print "BuildRemoteDI: $pagename\n";
	line: while (<WDB>) {
		s/[\012\015]+//;
# print "$_\n";
		last if ( $_ eq "" );
		foreach $cmdname ( @REMOTE_CMDNAMELIST ) {
# print "[$cmdname]";
			if ( $_ =~ ( "^$cmdname:" ) ) {
				$param = $_;
				$param =~ s/^$cmdname:[ \t]+//;
				$RP{ $pagename, $cmdname } = $param;
# print "\n";
				next line;
			}
		}
		next if ( $_ =~ "^[ \t]*#" );
		print DEBUGOUT "line $. : BuildRemoteDI() : syntax error.";
		exit 1;
	}
	$RP{ $pagename, "MARKURI" } = "<a href=\"$RP{ $pagename, \"URI\" }\"\>$RP{ $pagename, \"MARK\" }\<\/a\>";
}

########################################################################
### WDBから取得先情報を構築 
## BuildDirectDI( line )
#
sub BuildDirectDI
{
	local( $dpl );
	local( $n );
	local( $info );
	local( $param );

	shift;
	s/[\012\015]+//;
	split( /:[ \t]+/ );
	if ( @_[1] eq "" ) {
		print DEBUGOUT "line $. : GetDirectDI() : illegal dpl.";
		exit 1;
	}
	$dpl = @_[1];
	$n = $DPLNO++;
	$DPL[$n] = $dpl;
	$DP{ $dpl } = "defined";
# print "BuildDirectDI: $dpl\n";
	line: while (<WDB>) {
		s/[\012\015]+//;
# print "$_\n";
		last if ( $_ eq "" );
		foreach $cmdname ( @DIRECT_CMDNAMELIST ) {
			if ( $_ =~ ( "^$cmdname:[ \t]+" ) ) {
				$param = $_;
				$param =~ s/^$cmdname:[ \t]+//;
				if ( $param ne "" ) {
					$DP{ $dpl, $cmdname } = $param;
				}
#				split( /:[ \t]+/ );
# print "\[@_[1]\] ";
#				if ( @_[1] ne "" ) {
#					$DP{ $dpl, $cmdname } = @_[1];
#				}
				next line;
			}
		}
		next if ( $_ =~ "^[ \t]*#" );
		print DEBUGOUT "line $. : BuildRemoteDI() : syntax error.";
		exit 1;
	}

	$DP{ $dpl, "X-Diary-ID" } = $dpl;
#	$DP{ $dpl, "Title" } = $DP{ $dpl, "TITLE" };
	$DP{ $dpl, "VIRTUAL" } = &NormalURI( $DP{ $dpl, "VIRTUAL" } );
	$DP{ $dpl, "URI" } = &NormalURI( $DP{ $dpl, "URI" } );
	if ( $DP{ $dpl, "VIRTUAL" } eq $DP{ $dpl, "URI" } ) {
		undef $DP{ $dpl, "VIRTUAL" };
	}
	$DP{ $dpl, "X-VirtualURI" } = $DP{ $dpl, "VIRTUAL" };
	$DP{ $dpl, "X-ResultStatus" } = -101;

	$URI2PAGENAME{ &CaseLowerDomainNameURI( $DP{ $dpl, "URI" } ) } = $dpl;
}

########################################################################
### リモート情報読み込み 
## ReadRemortFile()
#
sub ReadRemortFile
{
	local( $i );
	local( $remotefile );
	local( $uri );
	local( $virtualuri );

 print DEBUGOUT "ReadRemoteFile():\n" if ($DEBUG);

	entry: for ( $i=0; $i<$RPLNO; $i++ ) {
		$uri = &NormalURI( $RP{ $RPL[$i], "URI" } );
		$RP{ $RPL[$i], "URI" } = $uri;
		$virtualuri = &NormalURI( $RP{ $RPL[$i], "VIRTUAL" } );
		undef $RP{ $RPL[$i], "X-VirtualURI" };
		if ( $virtualuri ne "" ) {
			$RP{ $RPL[$i], "X-VirtualURI" } = $virtualuri;
			$uri = $virtualuri;
		}
		if ( $uri =~ /^http:/ ) {
			$remotefile = $RP{ $RPL[$i], "SAVEAS" };
			&DownloadRemoteFileHTTP( $RPL[$i], "GET", $remotefile )
		} else {
			$remotefile = $uri;
		}
		eval {
			open( REMOTEFILE, "$NKF $remotefile|" ) || die "cannot open [$NKF $remotefile|].";
		};
 print DEBUGOUT "open remotefile:$@\n" if ($DEBUG);
		next entry if ( $@ );
		while (<REMOTEFILE>) {
			s/[\012\015]+//;
			if ( m:HINA/2.[0-9]: ) {
				close( REMOTEFILE );
				&ParseHinaDI( $RPL[$i], $remotefile, 1 );
				next entry;
			}
			if ( /^URL:[\t ]/i ) {
				close( REMOTEFILE );
				&ParseHinaDI( $RPL[$i], $remotefile, 1 );
				next entry;
			}
			if ( /HINA_OK/ ) {
				close( REMOTEFILE );
				&ParseHinaTxt( $RPL[$i], $remotefile, "HINA" );
				next entry;
			}
			# 日記猫専用 
			if ( /User-Agent: Cats/i ) {
				close( REMOTEFILE );
				&ParseHinaTxt( $RPL[$i], $remotefile, "CATS" );
				next entry;
			}
			# わっち専用 
			if ( $RP{ $RPL[$i], "URI" } =~ /sharl/i ) {
				close( REMOTEFILE );
				&ParseHinaTxt( $RPL[$i], $remotefile, "WATCH" );
				next entry;
			}
		}
		next entry;
	}
}

########################################################################
### Dancing 
## StartDance()
#
sub StartDance
{
	local( $i );
	local( $method );
	local( $dpl );

 print DEBUGOUT "StartDance():\n" if ($DEBUG);
 print DEBUGOUT "\$RPLNO=$RPLNO \$DPLNO=$DPLNO\n" if ($DEBUG);

	&ReadRemortFile();

	for ( $i=0; $i<$DPLNO; $i++ ) {
 		$method = "";
 		$dpl = $DPL[$i];
 print DEBUGOUT "========\n" if ($DEBUG);
 print DEBUGOUT "\$dpl = $dpl\n" if ($DEBUG);
 print DEBUGOUT "\$DP\{\$dpl,'METHOD'} = $DP{$dpl,'METHOD'}\n" if ($DEBUG);
		if ( $DP{$dpl,"METHOD" } eq 'GET2' ) {
			$method = "GET";
		} elsif ( $DP{$dpl,"METHOD" } eq 'HEAD2' ) {
			$method = "HEAD";
		} else {
			if ( $DP{$dpl,"METHOD"} eq 'REMOTE' ) {
				next;
#				if ( $DP{$dpl,"Authorized-url"} ne $ANTENNA_URI ) {
#					next;
#				}
#				$method = "GET";
			} else {
				if ( defined( $DP{$dpl,"Authorized-url" } ) ) {
					if ( $DP{$dpl,"Authorized-url"} ne $ANTENNA_URI ) {
						if ( defined( $DP{$dpl,"Expire"} ) ) {
							if ( $DP{$dpl,"Expire"} gt $NOWTIME ) {
 print DEBUGOUT "USE REMOTE Data\n" if ($DEBUG);
								next;
							}
						}
					}
				}
			}
			if ( $DP{$dpl,"METHOD" } eq 'GET' ) {
				$method = "GET";
			}
			if ( $DP{$dpl,"METHOD" } eq 'HEAD' ) {
				$method = "HEAD";
			}
			if ( $DP{$dpl,"KEY" } ne "" ) {
				$method = "GET";
				$DP{$dpl,"METHOD"} = $method;
			}
			if ( $method eq "" ) {
				$method = "HEAD";
				$DP{$dpl,"METHOD"} = $method;
			}
		}
 print DEBUGOUT "method = $method\n" if ($DEBUG);
		if ( &DownloadDocumentHTTP( $DPL[$i], $method, "\%dance$$.down" ) == 0 ) {
			if ( -e "\%dance$$.down" ) {
				if ( &ParseDocumentLocal( $DPL[$i], "\%dance$$.down", $method ) == 0 ) {
					unlink( "\%dance$$.down" );
					next;
				}
			}
		}
		unlink( "\%dance$$.down" ) if ( -e "\%dance$$.down" );
	}
}

########################################################################
### リモート情報出力 
## Print_Dance_Remote()
#
sub Print_Dance_Remote
{
	local( $i );

	for ( $i=0; $i<$RPLNO; $i++ ) {
 print DEBUGOUT "REMOTE:\t\t$RPL[$i]\n" if ($DEBUG);
		foreach $cmdname ( @REMOTE_CMDNAMELIST ) {
			print "$cmdname:\t\t$RP{$RPL[$i],$cmdname}\n";
		}
		print "\n";
	}
}

########################################################################
### 取得先情報出力 
## Print_Dance_Direct()
#
sub Print_Dance_Direct
{
	local( $i );

	for ( $i=0; $i<$DPLNO; $i++ ) {
		print "PAGE:\t\t$DPL[$i]\n";
		foreach $cmdname ( @DIRECT_CMDNAMELIST ) {
			print "$cmdname:\t\t$DP{$DPL[$i],$cmdname}\n";
		}
		print "\n";
	}
}

########################################################################
### URIを正規化 
## URI = NormalURI( URI )
#
sub NormalURI
{
	local( $uri ) = shift;

# print DEBUGOUT "NormalURI():\n" if ($DEBUG);
# print DEBUGOUT "$uri\n" if ($DEBUG);
	$uri =~ s/%7[Ee]/~/;
# print DEBUGOUT "$uri\n" if ($DEBUG);
	$uri =~ s%/index.html$%/%;
# print DEBUGOUT "$uri\n" if ($DEBUG);
	return ( $uri );
}

########################################################################
### HINA.TXTからHop数を抽出、正規化 
## URI = ExtractHop( URI )
#
sub ExtractHop
{
	local( $hop ) = shift;
# print DEBUGOUT "ExtractHop():\n" if ($DEBUG);
# print DEBUGOUT "$hop\n" if ($DEBUG);
	$hop =~ /\[(\d+)\]/;
	$hop = $1;
# print DEBUGOUT "$hop\n" if ($DEBUG);
	return ( $hop );
}

########################################################################
### URIを抽出、正規化 
## URI = ExtractNormalURI( URI )
#
sub ExtractNormalURI
{
	local( $uri ) = shift;
 print DEBUGOUT "ExtractNormalURI():\n" if ($DEBUG);
 print DEBUGOUT "$uri\n" if ($DEBUG);
	$uri =~ /(http:.*)/i;
	$uri = $1;
	if ( $1 eq "" ) {
# print DEBUGOUT "\=\=\>\[\"\"]\n" if ($DEBUG);
		return ("");
	}
# print DEBUGOUT "$uri\n" if ($DEBUG);
	$uri =~ s%^([^#>\" \t]+).*$%$1%;
	$uri =~ s%^(.*)([?][0-9]+)$%$1%;
# print DEBUGOUT "$uri\n" if ($DEBUG);
	$uri = &NormalURI( $uri );
# print DEBUGOUT "\=\=\>\[$uri\]\n" if ($DEBUG);
	return ( $uri );
}

########################################################################
### URIのドメイン部分を小文字化 
## URI = CaseLowerDomainNameURI( URI )
#
sub CaseLowerDomainNameURI
{
	local( $uri ) = shift;
# print DEBUGOUT "CaseLowerDomainNameURI( $uri ):\n" if ($DEBUG);
	$uri =~ s%(http://[^/]*)%\L\1\E%i;
# print DEBUGOUT "to: $uri\n" if ($DEBUG);
	return ($uri);
}

########################################################################
### Dateを抽出、正規化 
## DATE = ExtractNormalDate( DATE, IGNORETIME )
#
sub ExtractNormalDate
{
	local( $date ) = shift;
	local( $ignoretime ) = shift;
	local( $w );
	local( $s );
	local( $year, $month, $day, $hour, $min, $sec, $tz, $meridiem );
	local( $dummy1, $dummy2, $dummy3, $dummy4, $dummy5, $dummy6 );

# print DEBUGOUT "ExtractNormalDate():\n" if ($DEBUG);

	$NOTIMEINCONTENTS = 0;
	$EXTRACTTIMEFORMAT = "";

	$date =~ s%\t%\ %g;
	$date =~ s%−%\-%g;
	$date =~ s%：%\:%g;
	$date =~ s%／%\/%g;
	$date =~ s%．%\.%g;
	$date =~ s%　% %g;
# print DEBUGOUT "$date\n" if ($DEBUG);

	# DD Cal YYYY hh:mm:ss Zone
	$EXTRACTTIMEFORMAT = "DD_Cal_YYYY_hh:mm:ss_Zone";
	$w = " $date";
	if ( $w =~ s%^.*[^\d]+(\d{1,2})[- ]+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[- ]+(\d{1,4})[^\d]+(\d{1,2}[: ]+\d{1,2}[: ]+\d{1,2})(.*)$%\1 \2 \3 \4 \5% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz ) = ( -1, -1, -1, -1, -1, -1, "" );
		( $day, $month, $year, $hour, $min, $sec ) = split( "[/: ]+", $w );
		( $dummy1, $dummy2, $dummy3, $dummy4, $dummy5, $dummy6, $tz ) = split( "[/: ]+", $w );
		$month = $MONTHNAMETOMONTH{$month};
		$tz =~ s/[^A-Z]*([A-Z]+).*/\1/;
		$tz = "" if ( !defined($TZNAMETODIFFTIME{$tz}) );
# print DEBUGOUT "DD Cal YYYY hh:mm:ss Zone \[$day, $month, $year, $hour, $min, $sec, $tz \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) &&
		     ( (0 <= $sec) && ($sec <= 59) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $ignoretime ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	$date =~ s%０%0%g;
	$date =~ s%１%1%g;
	$date =~ s%２%2%g;
	$date =~ s%３%3%g;
	$date =~ s%４%4%g;
	$date =~ s%５%5%g;
	$date =~ s%６%6%g;
	$date =~ s%７%7%g;
	$date =~ s%８%8%g;
	$date =~ s%９%9%g;
	$date =~ s%ねん%年%g;
	$date =~ s%がつ%月%g;
	$date =~ s%にち%日%g;
	$date =~ s%じ%時%g;
	$date =~ s%ふん%分%g;
	$date =~ s%びょう%秒%g;
	$date =~ s%年%/%g;
	$date =~ s%月%/%g;
	$date =~ s%日% %g;
	$date =~ s%時%:%g;
	$date =~ s%分%:%g;
	$date =~ s%秒% %g;
 print DEBUGOUT "$date\n" if ($DEBUG);

	# YYYY/MM/DD hh:mm:ss Zone
	$EXTRACTTIMEFORMAT = "YYYY/MM/DD_hh:mm:ss_Zone";
	$w = " $date";
	$w =~ s%[^0-9\/\:\.\+\-A-Za-z]+% %g;
#	if ( $w =~ s%^.*[^\d]+(\d{2,4})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2}[: ]+\d{1,2}[: ]+\d{1,2})(.*)$%\1 \2 \3 \4 \5% ) {
	if ( $w =~ s%^.*[^\d]+(\d{2,4})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2})[^\d]+(\d{1,2}[: ]+\d{1,2}[: ]+\d{1,2})(.*)$%\1 \2 \3 \4 \5% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz ) = ( -1, -1, -1, -1, -1, -1, "" );
		( $year, $month, $day, $hour, $min, $sec ) = split( "[/: ]+", $w );
		( $dummy1, $dummy2, $dummy3, $dummy4, $dummy5, $dummy6, $tz ) = split( "[/: ]+", $w );
		$tz =~ s/[^A-Z]*([A-Z]+).*/\1/;
		$tz = "" if ( !defined($TZNAMETODIFFTIME{$tz}) );
# print DEBUGOUT "YYYY\/MM\/DD hh:mm:ss Zone \[$year, $month, $day, $hour, $min, $sec, $tz \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) &&
		     ( (0 <= $sec) && ($sec <= 59) ) ) {
			local( $s ) = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $ignoretime ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	# DD Cal hh:mm:ss Zone YYYY
	$EXTRACTTIMEFORMAT = "DD_Cal_hh:mm:ss_Zone_YYYY";
	$w = " $date";
	if ( $w =~ s%^.*[^\d]+(\d{1,2}) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[ ]+(\d{1,2}[: ]+\d{1,2}[: ]+\d{1,2})(.*)$%\1 \2 \3 \4 \5% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz ) = ( -1, -1, -1, -1, -1, -1, "" );
		( $day, $month, $hour, $min, $sec, $year ) = split( "[/: ]+", $w );
		if ( $year !~ /\d/ ) {
			( $dummy1, $dummy2, $dummy3, $dummy4, $dummy5, $tz, $year ) = split( "[/: ]+", $w );
			$tz =~ s/[^A-Z]*([A-Z]+).*/\1/;
			$tz = "" if ( !defined($TZNAMETODIFFTIME{$tz}) );
		}
		$month = $MONTHNAMETOMONTH{$month};
# print DEBUGOUT "DD Cal hh:mm:ss Zone YYYY \[$day, $month, $hour, $min, $sec, $tz, $year \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) &&
		     ( (0 <= $sec) && ($sec <= 59) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $ignoretime ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	# Cal DD hh:mm:ss Zone YYYY
	$EXTRACTTIMEFORMAT = "Cal_DD_hh:mm:ss_Zone_YYYY";
	$w = $date;
	if ( $w =~ s%^.*(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[ ]+(\d{1,2})[ ]+(\d{1,2}[: ]+\d{1,2}[: ]+\d{1,2})(.*)$%\1 \2 \3 \4% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz ) = ( -1, -1, -1, -1, -1, -1, "" );
		( $month, $day, $hour, $min, $sec, $year ) = split( "[/: ]+", $w );
		if ( $year !~ /\d/ ) {
			( $dummy1, $dummy2, $dummy3, $dummy4, $dummy5, $tz, $year ) = split( "[/: ]+", $w );
			$tz =~ s/[^A-Z]*([A-Z]+).*/\1/;
			$tz = "" if ( !defined($TZNAMETODIFFTIME{$tz}) );
		}
		$month = $MONTHNAMETOMONTH{$month};
# print DEBUGOUT "Cal DD hh:mm:ss Zone YYYY \[$month, $day, $hour, $min, $sec, $tz, $year \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) &&
		     ( (0 <= $sec) && ($sec <= 59) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $NOWTIME ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	$date =~ s%Jan[a-z]*%1%gi;
	$date =~ s%Feb[a-z]*%2%gi;
	$date =~ s%Mar[a-z]*%3%gi;
	$date =~ s%Apr[a-z]*%4%gi;
	$date =~ s%May[a-z]*%5%gi;
	$date =~ s%Jun[a-z]*%6%gi;
	$date =~ s%Jul[a-z]*%7%gi;
	$date =~ s%Aug[a-z]*%8%gi;
	$date =~ s%Sep[a-z]*%9%gi;
	$date =~ s%Oct[a-z]*%10%gi;
	$date =~ s%Nov[a-z]*%11%gi;
	$date =~ s%Dec[a-z]*%12%gi;
	$date =~ s%午前%AM%g;
	$date =~ s%午後%PM%g;
	$date =~ s%AM% AM %gi;
	$date =~ s%PM% PM %gi;
 print DEBUGOUT "$date\n" if ($DEBUG);

	# YYYY/MM/DD pm hh:mm
	$EXTRACTTIMEFORMAT = "YYYY/MM/DD_PM_hh:mm";
	$w = " $date";
	$w =~ s%[^0-9\/\:\.\+\-A-Za-z]+% %g;
	if ( $w =~ s%^.*[^\d]+(\d{2,4})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2})[\.\-/ ]+([AP]M)[\.\-/ ]+(\d{1,2}[: ]+\d{1,2})%\1 \2 \3 \4 \5% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz, $meridiem ) = ( -1, -1, -1, -1, -1, -1, "", "" );
		( $year, $month, $day, $meridiem, $hour, $min ) = split( "[/: ]+", $w );
		$hour = 0 if ( $hour == 0 );
		$hour += 12 if ( $meridiem eq "PM" );
		$sec = 0;
# print DEBUGOUT "MM\/DD pm hh:mm \[$month, $day, $meridiem, $hour, $min \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $ignoretime ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	# YYYY/MM/DD hh:mm pm
	$EXTRACTTIMEFORMAT = "YYYY/MM/DD_hh:mm_PM";
	$w = " $date";
	$w =~ s%[^0-9\/\:\.\+\-A-Za-z]+% %g;
#	if ( $w =~ s%^.*[^\d]+(\d{2,4})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2}[: ]+\d{1,2})[\.\-/ ]+([AP]M)%\1 \2 \3 \4 \5% ) {
	if ( $w =~ s%^.*[^\d]+(\d{2,4})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2})[^\d]+(\d{1,2}[: ]+\d{1,2})[\.\-/ ]+([AP]M)%\1 \2 \3 \4 \5% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz, $meridiem ) = ( -1, -1, -1, -1, -1, -1, "", "" );
		( $year, $month, $day, $hour, $min, $meridiem ) = split( "[/: ]+", $w );
		$hour = 0 if ( $hour == 0 );
		$hour += 12 if ( $meridiem eq "PM" );
		$sec = 0;
# print DEBUGOUT "YYYY\/MM\/DD hh:mm pm \[$year, $month, $day, $hour, $min, $meridiem\]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $ignoretime ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	# YYYY/MM/DD hh:mm
	$EXTRACTTIMEFORMAT = "YYYY/MM/DD_hh:mm";
	$w = " $date";
	$w =~ s%[^0-9\/\:\.\+\-A-Za-z]+% %g;
#	if ( $w =~ s%^.*[^\d]+(\d{2,4})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2}[: ]+\d{1,2})%\1 \2 \3 \4% ) {
	if ( $w =~ s%^.*[^\d]+(\d{2,4})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2})[^\d]+(\d{1,2}[: ]+\d{1,2})%\1 \2 \3 \4% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz ) = ( -1, -1, -1, -1, -1, -1, "" );
		( $year, $month, $day, $hour, $min ) = split( "[/: ]+", $w );
		$sec = 0;
# print DEBUGOUT "YYYY\/MM\/DD hh:mm \[$year, $month, $day, $hour, $min \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $ignoretime ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	# MM/DD hh:mm:ss
	$EXTRACTTIMEFORMAT = "MM/DD_hh:mm:ss";
	$w = " $date";
	$w =~ s%[^0-9\/\:\.\+\-A-Za-z]+% %g;
#	if ( $w =~ s%^.*[^\d]+(\d{1,2})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2}[: ]+\d{1,2}[: ]+\d{1,2})%\1 \2 \3% ) {
	if ( $w =~ s%^.*[^\d]+(\d{1,2})[\.\-/ ]+(\d{1,2})[^\d]+(\d{1,2}[: ]+\d{1,2}[: ]+\d{1,2})%\1 \2 \3% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz ) = ( -1, -1, -1, -1, -1, -1, "" );
		( $month, $day, $hour, $min, $sec ) = split( "[/: ]+", $w );
		$year = $THISYEAR;
		$year-- if ( ($year*12+$month)-($THISYEAR*12+$THISMONTH) > 6 );
# print DEBUGOUT "MM\/DD hh:mm \[$year, $month, $day, $hour, $min, $sec \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) &&
		     ( (0 <= $sec) && ($sec <= 59) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $ignoretime ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	# MM/DD pm hh:mm
	$EXTRACTTIMEFORMAT = "MM/DD_PM_hh:mm";
	$w = " $date";
	$w =~ s%[^0-9\/\:\.\+\-A-Za-z]+% %g;
	if ( $w =~ s%^.*[^\d]+(\d{1,2})[\.\-/ ]+(\d{1,2})[\.\-/ ]+([AP]M)[\.\-/ ]+(\d{1,2}[: ]+\d{1,2})%\1 \2 \3 \4% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz, $meridiem ) = ( -1, -1, -1, -1, -1, -1, "", "" );
		( $month, $day, $meridiem, $hour, $min ) = split( "[/: ]+", $w );
		$year = $THISYEAR;
		$year-- if ( ($year*12+$month)-($THISYEAR*12+$THISMONTH) > 6 );
		$hour = 0 if ( $hour == 0 );
		$hour += 12 if ( $meridiem eq "PM" );
		$sec = 0;
# print DEBUGOUT "MM\/DD pm hh:mm \[$month, $day, $meridiem, $hour, $min \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $ignoretime ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	# MM/DD hh:mm pm
	$EXTRACTTIMEFORMAT = "MM/DD_hh:mm_PM";
	$w = " $date";
	$w =~ s%[^0-9\/\:\.\+\-A-Za-z]+% %g;
#	if ( $w =~ s%^.*[^\d]+(\d{1,2})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2}[: ]+\d{1,2})[\.\-/ ]+([AP]M)%\1 \2 \3 \4% ) {
	if ( $w =~ s%^.*[^\d]+(\d{1,2})[\.\-/ ]+(\d{1,2})[^\d]+(\d{1,2}[: ]+\d{1,2})[\.\-/ ]+([AP]M)%\1 \2 \3 \4% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz, $meridiem ) = ( -1, -1, -1, -1, -1, -1, "", "" );
		( $month, $day, $hour, $min, $meridiem ) = split( "[/: ]+", $w );
		$year = $THISYEAR;
		$year-- if ( ($year*12+$month)-($THISYEAR*12+$THISMONTH) > 6 );
		$hour = 0 if ( $hour == 0 );
		$hour += 12 if ( $meridiem eq "PM" );
		$sec = 0;
# print DEBUGOUT "MM\/DD hh:mm pm \[$month, $day, $hour, $min, $meridiem\]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $ignoretime ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	# MM/DD hh:mm
	$EXTRACTTIMEFORMAT = "MM/DD_hh:mm";
	$w = " $date";
	$w =~ s%[^0-9\/\:\.\+\-A-Za-z]+% %g;
 print DEBUGOUT "$w\n" if ($DEBUG);
#	if ( $w =~ s%^.*[^\d]+(\d{1,2})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2}[: ]+\d{1,2})%\1 \2 \3% ) {
	if ( $w =~ s%^.*[^\d]+(\d{1,2})[\.\-/ ]+(\d{1,2})[^\d]+(\d{1,2}[: ]+\d{1,2})%\1 \2 \3% ) {
 print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz ) = ( -1, -1, -1, -1, -1, -1, "" );
		( $month, $day, $hour, $min ) = split( "[/: ]+", $w );
		$year = $THISYEAR;
		$year-- if ( ($year*12+$month)-($THISYEAR*12+$THISMONTH) > 6 );
		$sec = 0;
# print DEBUGOUT "MM\/DD hh:mm \[$year, $month, $day, $hour, $min \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $ignoretime ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	# MM/DD pm hh:
	$EXTRACTTIMEFORMAT = "MM/DD_pm_hh:";
	$w = " $date";
	$w =~ s%[^0-9\/\:\.\+\-A-Za-z]+% %g;
	if ( $w =~ s%^.*[^\d]+(\d{1,2})[\.\-/ ]+(\d{1,2})[\.\-/ ]+([AP]M)[\.\-/ ]+(\d{1,2}[:])%\1 \2 \3 \4% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz, $meridiem ) = ( -1, -1, -1, -1, -1, -1, "", "" );
		( $month, $day, $meridiem, $hour ) = split( "[/: ]+", $w );
		$year = $THISYEAR;
		$year-- if ( ($year*12+$month)-($THISYEAR*12+$THISMONTH) > 6 );
		$hour = 0 if ( $hour == 0 );
		$hour += 12 if ( $meridiem eq "PM" );
		$min = 0;
		$sec = 0;
# print DEBUGOUT "MM\/DD hh:mm \[$year, $month, $day, $hour, $min \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $ignoretime ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	# MM/DD hh:
	$EXTRACTTIMEFORMAT = "MM/DD_hh:";
	$w = " $date";
	$w =~ s%[^0-9\/\:\.\+\-A-Za-z]+% %g;
#	if ( $w =~ s%^.*[^\d]+(\d{1,2})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2}[:])%\1 \2 \3% ) {
	if ( $w =~ s%^.*[^\d]+(\d{1,2})[\.\-/ ]+(\d{1,2})[^\d]+(\d{1,2}[:])%\1 \2 \3% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz ) = ( -1, -1, -1, -1, -1, -1, "" );
		( $month, $day, $hour ) = split( "[/: ]+", $w );
		$year = $THISYEAR;
		$year-- if ( ($year*12+$month)-($THISYEAR*12+$THISMONTH) > 6 );
		$min = 0;
		$sec = 0;
# print DEBUGOUT "MM\/DD hh:mm \[$year, $month, $day, $hour, $min \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) &&
		     ( (0 <= $hour) && ($hour <= 23) ) &&
		     ( (0 <= $min) && ($min <= 59) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $ignoretime ) {
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	# YYYY/MM/DD
	$EXTRACTTIMEFORMAT = "YYYY/MM/DD";
	$w = " $date";
	$w =~ s%(\d\d\d\d)(\d\d)(\d\d)% \1 \2 \3 /%g;
	$w =~ s%[^0-9\/\:\.\+\-A-Za-z]+% %g;
	if ( $w =~ s%^.*[^\d]+(\d{2,4})[\.\-/ ]+(\d{1,2})[\.\-/ ]+(\d{1,2})%\1 \2 \3% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz ) = ( -1, -1, -1, -1, -1, -1, "" );
		( $year, $month, $day ) = split( "[/: ]+", $w );
		$sec = 0;
# print DEBUGOUT "YYYY\/MM\/DD \[$year, $month, $day \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, 0, 0, 0 );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $TOMORROWTIME ) {
				$NOTIMEINCONTENTS = 1;
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	# MM/DD
	$EXTRACTTIMEFORMAT = "MM/DD";
	$w =~ s%(\d\d)(\d\d)% \1 \2 /%g;
	$w = " $date";
	$w =~ s%[^0-9\.\+\-A-Za-z\/\:]+% %g;
	if ( $w =~ s%^.*[^\d]+(\d{1,2})[\.\-/ ]+(\d{1,2})%\1 \2% ) {
# print DEBUGOUT "$w\n" if ($DEBUG);
		( $year, $month, $day, $hour, $min, $sec, $tz ) = ( -1, -1, -1, -1, -1, -1, "" );
		( $month, $day ) = split( "[/: ]+", $w );
		$year = $THISYEAR;
		$year-- if ( ($year*12+$month)-($THISYEAR*12+$THISMONTH) > 6 );
		$sec = 0;
# print DEBUGOUT "MM\/DD \[$year, $month, $day \]\n" if ($DEBUG);
		if ( $year < 1900 ) {
			$year += 1900;
			if ( $year < 1980 ) {
				$year += 100;
			}
		}
		if ( ( (1980 <= $year) && ($year <= 2100) ) &&
		     ( (1 <= $month) && ($month <= 12) ) &&
		     ( (1 <= $day) && ($day <= 31) ) ) {
			$s = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, 0, 0, 0 );
			$s = &DateToClock( $s );
			$s += $TZNAMETODIFFTIME{$tz}*60*60;
			$s = &ClockToDate( $s );
			$s = "$s GMT";
			if ( $s lt $TOMORROWTIME ) {
				$NOTIMEINCONTENTS = 1;
				return ($s);
			}
# print DEBUGOUT "$s \> $ignoretime\n" if ($DEBUG);
		}
	}

	$EXTRACTTIMEFORMAT = "";
	return ( sprintf( "%04d/%02d/%02d %02d:%02d:%02d GMT", 1980, 1, 1, 0, 0, 0 ) );
}

########################################################################
### HINA.TXTの解析 
## ParseHinaTxt( PAGENAME, INFILE, AGENT )
#
sub ParseHinaTxt
{
	local( $pagename ) = shift;
	local( $infile ) = shift;
	local( $agent ) = shift;
	local( $year, $month, $day, $hour, $min, $sec );
	local( $href );
	local( $lmdate );
	local( $lmddate );
	local( $dpl );
	local( $update );
	local( $cern );
	local( $hop );
	local( $author );
	local( $fmddate );
	local( $date );

 print DEBUGOUT "ParseHinaTxt( $pagename, $infile ):\n" if ($DEBUG);

	( $year, $month, $day, $hour, $min ) = ( 1970, 1, 1, 0, 0 );

	open( FIN, "$NKF $infile|" ) || die "cannot open [$NKF $infile|].";
	while (<FIN>) {
		s/[\012\015]+//;
		if ( /^Server: / ) {
			s/^Server: //;
			$RP{ $pagename, "Server" } = $_;
			next;
		}
		if ( /^Last-Modified: / ) {
			$RP{ $pagename, "Date" } = &ExtractNormalDate( $_, $IGNORETIME );
			next;
		}
		if ( /^Date: / ) {
			if ( $RP{ $pagename, "Date" } eq "" ) {
				$RP{ $pagename, "Date" } = &ExtractNormalDate( $_, $IGNORETIME );
			}
			next;
		}
		if ( $agent eq "HINA" ) {
			next if ( !/HINA_OK/ );
		} elsif ( $agent eq "CATS" ) {
			next if ( !/<LI>/ );
		} elsif ( $agent eq "WATCH" ) {
			next if ( !/<a href=/ );
		}
 print DEBUGOUT "========\n" if ($DEBUG);
		$href = &ExtractNormalURI( $_ );
		next if ( $href eq "" );

		if ( $OVERALL ) {
			if ( $OVERALL == 2 ) {
				$dpl = $pagename . $href;
			} else {
				$dpl = $href;
			}
			if ( $DP{ $dpl, "URI" } eq "" ) {
				$DPL[$DPLNO++] = $dpl;
				$DP{ $dpl } = "defined";
				$DP{ $dpl, "URI" } = $href;
				$DP{ $dpl,"X-Result-Method"} = "REMOTE";
				$URI2PAGENAME{&CaseLowerDomainNameURI($href)} = $dpl;
			}
		}

		$dpl = $URI2PAGENAME{&CaseLowerDomainNameURI($href)};
 print DEBUGOUT "\[$href\] \[$dpl\]\n" if ($DEBUG);
		if ( $DP{ $dpl, "URI" } ne "" ) {
			$cern = 0;
			$cern = !0 if ( /HINA_CERN/ );
			$hop = &ExtractHop( $_ );
			$lmdate = &ExtractNormalDate( $_, $IGNORETIME );
			next if ( $lmdate eq "" );

 printf( DEBUGOUT "lmddate: [%s] [%s] -> ", $NOWTIME, $RP{ $pagename, "Date" } ) if ($DEBUG);
			$lmddate = $NOWTIME;
#			$date = &ExtractNormalDate( $RP{ $pagename, "Date" }, $IGNORETIME );
#			$lmddate = $date if ( $date ne $ERRTIME );
 print DEBUGOUT "lmddate: [$lmddate]\n" if ($DEBUG);

 printf( DEBUGOUT "fmddate: [%s] [%s] -> ", $fmddate, $nodelist{ "X-First-Modified-Detected" } ) if ($DEBUG);
			$fmddate = $fmddate;
			$date = &ExtractNormalDate( $nodelist{ "X-First-Modified-Detected" }, $IGNORETIME );
			$fmddate = $date if ( $date ne $ERRTIME );
 print DEBUGOUT "fmddate: [$fmddate]\n" if ($DEBUG);

			$update = 0;
 print DEBUGOUT "new Last-Modified: $lmdate\n" if ($DEBUG);
 print DEBUGOUT "now Last-Modified: $DP{ $dpl, \"Last-Modified\" }\n" if ($DEBUG);
			if ( $DP{ $dpl, "Last-Modified" } lt $lmdate ) {
				$update = 1;
 print DEBUGOUT "updated newer Last-Modified on \[$pagename\].\n" if ($DEBUG);
			} else {
 print DEBUGOUT "new Last-Modified-Detected: $lmddate\n" if ($DEBUG);
 print DEBUGOUT "now Last-Modified-Detected: $DP{ $dpl, \"Last-Modified-Detected\" }\n" if ($DEBUG);
				if ( ( $DP{ $dpl, "Last-Modified" } eq $lmdate ) && 
			         ( $DP{ $dpl, "Last-Modified-Detected" } lt $lmddate ) ) {
					$update = 2;
 print DEBUGOUT "updated newer Remote-File on \[$pagename\].\n" if ($DEBUG);
				}
			}
			if ( $update ) {
				undef $DP{ $dpl, "Author-Name" };
				undef $DP{ $dpl, "Title" };
				undef $DP{ $dpl, "Keyword" };
				$DP{ $dpl, "Last-Modified" } = $lmdate;
				$DP{ $dpl, "Method" } .= "/" if ( $DP{ $dpl, "Method" } ne "" );
				$DP{ $dpl, "Method" } .= "REMOTE";
				$DP{ $dpl, "Date" } = $NOWTIME;
				$DP{ $dpl, "X-Authorized-Pagename" } = $pagename;
				$DP{ $dpl, "Authorized-url" } = $RP{ $pagename, "URI" };
				$DP{ $dpl, "Authorized" } = $AGENT;
				$DP{ $dpl, "Server" } = "";
				if ( $cern ) {
					$DP{ $dpl, "Server" } = "CERN";
				}
				$DP{ $dpl, "X-ResultStatus" } = 200;
				$DP{ $dpl, "X-Hop" } = $hop+1;
				$DP{ $dpl, "Expire" } = &ClockToDate2(&DateToClock($RP{ $pagename, "Date" })+3600*$DEFAULT_EXPIRETIME);
				$DP{ $dpl, "Expires" } = $DP{ $dpl, "Expire" };
				if ( $update == 1 ) {
					$DP{ $dpl, "X-First-Modified-Detected" } = $fmddate;
 printf( DEBUGOUT "updated X-First-Modified-Detected: [%s]\n", $DP{ $dpl, "X-First-Modified-Detected" } ) if ($DEBUG);
				}
				if ( $update == 2 ) {
					if ( !defined($DP{ $dpl, "X-First-Modified-Detected" }) ) {
						$DP{ $dpl, "X-First-Modified-Detected" } = $fmddate;
 printf( DEBUGOUT "updated X-First-Modified-Detected: [%s]\n", $DP{ $dpl, "X-First-Modified-Detected" } ) if ($DEBUG);
					}
				}
				$DP{ $dpl, "Last-Modified-Detected" } = $lmddate;
				$DP{ $dpl, "X-LM-Is-FMD" } = "0" if ( $update == 1 );
if (0) {
				if ( $DP{ $dpl, "AUTHOR" } eq "") {
					$author = $_;
# print DEBUGOUT "Set Author \[$author\].\n" if ($DEBUG);
					$author =~ s:^.*\<A HREF\=[^>]*\>(.*)\<\/A\>.*$:$1:i;
# print DEBUGOUT "Set Author \[$author\].\n" if ($DEBUG);
					$DP{ $dpl, "AUTHOR" } = $author;
				}
}
				$DP{$dpl,"X-Result-Method"} = "REMOTE";
			}
		}
	}
}


########################################################################
### HINA.DIの解析 
## ParseHinaDI( PAGENAME, INFILE, REMOTEFLAG )
#
sub ParseHinaDI
{
	local( $pagename ) = shift;
	local( $infile ) = shift;
	local( $onremote ) = shift;
	local( $href );
	local( $dpl );
	local( $update );
	local( $lmddate );
	local( $fmddate );
	local( $lmdate );
	local( $date );
	local( %nodelist );

 print DEBUGOUT "ParseHinaDI( $pagename, $infile, $onremote ):\n" if ($DEBUG);

	open( FIN, "$NKF $infile|" ) || die "cannot open [$NKF $infile|].";;
	while (<FIN>) {
		s/[\012\015]+//;
		last if ( $_ eq "" );
		foreach $key ( @HINADI_CMDNAMELIST ) {
			if ( /^${key}:[ \t]*(.*)/i ) {
				$nodelist{ "#HEADER", $key } = $1;
# print DEBUGOUT "\$nodelist{ \"#HEADER\", $key } = $1\n" if ($DEBUG);
				last;
			}
		}
	}
 print DEBUGOUT "========\n" if ($DEBUG);
	line: while (<FIN>) {
		s/[\012\015]+//;
		if ( $_ eq "" ) {
			$lmdate = &ExtractNormalDate( $nodelist{ "Last-Modified" }, $IGNORETIME );
			next if ( $lmdate eq $ERRTIME );

			$lmddate = "";
 #			$lmddate = $NOWTIME;
printf( DEBUGOUT "lmddate: [%s] [%s] [%s] [%s] -> ", $NOWTIME, $nodelist{ "#HEADER", "Date" }, $nodelist{ "Date" }, $nodelist{ "Last-Modified-Detected" } ) if ($DEBUG);
#			$date = &ExtractNormalDate( $nodelist{ "#HEADER", "Date" }, $IGNORETIME );
#			$lmddate = $date if ( $date ne $ERRTIME );
#			$date = &ExtractNormalDate( $nodelist{ "Date" }, $IGNORETIME );
#			$lmddate = $date if ( $date ne $ERRTIME );
#			$date = &ExtractNormalDate( $nodelist{ "Last-Modified" }, $IGNORETIME );
#			$lmddate = $date if ( $date ne $ERRTIME );
			$date = &ExtractNormalDate( $nodelist{ "Last-Modified-Detected" }, $IGNORETIME );
			$lmddate = $date if ( $date ne $ERRTIME );
 print DEBUGOUT "lmddate: [$lmddate]\n" if ($DEBUG);

 printf( DEBUGOUT "fmddate: [%s] [%s] -> ", $lmddate, $nodelist{ "X-First-Modified-Detected" } ) if ($DEBUG);
			$fmddate = $lmddate;
			$date = &ExtractNormalDate( $nodelist{ "X-First-Modified-Detected" }, $IGNORETIME );
			$fmddate = $date if ( $date ne $ERRTIME );
 print DEBUGOUT "fmddate: [$fmddate]\n" if ($DEBUG);

			if ( $OVERALL ) {
				if ( $OVERALL == 2 ) {
					$dpl = $pagename . $href;
				} else {
					$dpl = $href;
				}
				if ( $DP{ $dpl, "URI" } eq "" ) {
					$DPL[$DPLNO++] = $dpl;
					$DP{ $dpl } = "defined";
					$DP{ $dpl, "URI" } = $href;
					$DP{ $dpl, "METHOD"} = "REMOTE";
					$URI2PAGENAME{&CaseLowerDomainNameURI($href)} = $dpl;
				}
			}

			$dpl = $URI2PAGENAME{&CaseLowerDomainNameURI($href)};
			if ( $DP{ $dpl, "URI" } ne "" ) {
				$update = 0;
 print DEBUGOUT "new Last-Modified: $lmdate\n" if ($DEBUG);
 print DEBUGOUT "now Last-Modified: $DP{ $dpl, \"Last-Modified\" }\n" if ($DEBUG);
				if ( $DP{ $dpl, "Last-Modified" } lt $lmdate ) {
					$update = 1;
 print DEBUGOUT "updated newer Last-Modified on \[$pagename\].\n" if ($DEBUG);
				} else {
 print DEBUGOUT "new Last-Modified-Detected: $lmddate\n" if ($DEBUG);
 print DEBUGOUT "now Last-Modified-Detected: $DP{ $dpl, \"Last-Modified-Detected\" }\n" if ($DEBUG);
					if ( ( $DP{ $dpl, "Last-Modified" } eq $lmdate ) && 
				         ( $DP{ $dpl, "Last-Modified-Detected" } lt $lmddate ) ) {
						$update = 2;
 print DEBUGOUT "updated newer Remote-File on \[$pagename\].\n" if ($DEBUG);
					}
				}
				if ( $update ) {
					$DP{ $dpl, "Last-Modified" } = $lmdate;
					$DP{ $dpl, "X-Diary-ID" } = $dpl;
					$DP{ $dpl, "TITLE" } = $nodelist{ "Title" } if ( $DP{ $dpl, "TITLE" } eq "" );
					undef $DP{ $dpl, "Title" };
					$DP{ $dpl, "Title" } = $nodelist{ "Title" } if ( defined $nodelist{ "Title" } );
					$DP{ $dpl, "AUTHOR" } = $nodelist{ "Author-Name" } if ( $DP{ $dpl, "AUTHOR" } eq "" );
					undef $DP{ $dpl, "Author-Name" };
					$DP{ $dpl, "Author-Name" } = $nodelist{ "Author-Name" } if ( defined $nodelist{ "Author-Name" } );
					$DP{ $dpl, "URI" } = &NormalURI( $nodelist{ "URL" } );
					$DP{ $dpl, "Keyword" } = $nodelist{ "Keyword" };
					$DP{ $dpl, "Server" } = $nodelist{ "Server" };
					$DP{ $dpl, "Authorized" } = $nodelist{ "Authorized" };
					$DP{ $dpl, "Authorized-url" } = &NormalURI( $nodelist{ "Authorized-url" } );
					$DP{ $dpl, "Expire" } = &ExtractNormalDate( $nodelist{ "Expires" }, $FUTURETIME );
					$DP{ $dpl, "Expire" } = &ExtractNormalDate( $nodelist{ "Expire" }, $FUTURETIME ) if ( $DP{ $dpl, "Expire" } lt $EXPIRETIME );
					$DP{ $dpl, "Expire" } = $EXPIRETIME if ( $DP{ $dpl, "Expire" } lt $EXPIRETIME );
					$DP{ $dpl, "Expires" } = $DP{ $dpl, "Expire" };

					if ( $update == 1 ) {
						$DP{ $dpl, "X-First-Modified-Detected" } = $fmddate;
 printf( DEBUGOUT "updated X-First-Modified-Detected: [%s]\n", $DP{ $dpl, "X-First-Modified-Detected" } ) if ($DEBUG);
					}
					if ( $update == 2 ) {
						if ( !defined($DP{ $dpl, "X-First-Modified-Detected" }) ) {
							$DP{ $dpl, "X-First-Modified-Detected" } = $fmddate;
 printf( DEBUGOUT "updated X-First-Modified-Detected: [%s]\n", $DP{ $dpl, "X-First-Modified-Detected" } ) if ($DEBUG);
						}
					}
					$DP{ $dpl, "Last-Modified-Detected" } = &ExtractNormalDate( $lmddate, $FUTURETIME );
					$DP{ $dpl, "X-LM-Is-FMD" } = $nodelist{ "X-LM-Is-FMD" };
					if ( $onremote ) {
						$DP{ $dpl, "Method" } .= "/" if ( $DP{ $dpl, "Method" } ne "" );
						$DP{ $dpl, "Method" } .= "REMOTE";
					}
					$DP{ $dpl, "Date" } = $NOWTIME;
					$DP{ $dpl, "X-Authorized-Pagename" } = $pagename;
					$DP{ $dpl, "X-ResultStatus" } = 200;
					$DP{ $dpl, "X-Result-Method" } = "REMOTE";
				}
 print DEBUGOUT "========\n" if ($DEBUG);
			}
			undef %nodelist;
		}
		foreach $key ( @HINADI_CMDNAMELIST ) {
			if ( /^${key}:[ \t]*(.*)/i ) {
# print DEBUGOUT "\$nodelist{ $key } = $1\n" if ($DEBUG);
				$nodelist{ $key } = $1;
				if ( $key eq "URL" ) {
					$href = $1;
					$href =~ s/\?/\%3f/g;
					$href = &ExtractNormalURI( $href );
					$href =~ s/%3f/?/g;
 print DEBUGOUT "[$href]\n" if ($DEBUG);
					next line;
				}
				last;
			}
		}
	}
}

########################################################################
### ローカルファイル解析 
## SUCCESS = ParseDocumentLocal( PAGENAME, INFILE, METHOD )
#
sub ParseDocumentLocal
{
	local( $pagename ) = shift;
	local( $infile ) = shift;
	local( $method ) = shift;
	local( $dpl );
	local( $key );
	local( $lmdate );
	local( $timeformat );
	local( $firstline );
	local( $isbody ) = 0;
	local( @a );
	local( %header );
	local( $tag );
	local( $param );
	local( $notimeincontents );
	local( $keypart );
	local( $l, $l2 );
	local( $restline );
	local( $foundlmd );
	local( $title );
	local( $metatitle );
	local( $author );
	local( $update );
	local( $date );
	local( $lmddate );
	local( $fmddate );

 print DEBUGOUT "ParseDocumentLocal( $pagename, $infile, $method ):\n" if ($DEBUG);

	$dpl = $pagename;
	$key = $DP{ $dpl, "KEY" };
	if ( $key eq "" ) {
		$key = "[Ll][Aa][Ss][Tt]";
	}
	if ( $method eq "HEAD" ) {
		$key = "[Ll][Aa][Ss][Tt]\-[Mm][Oo][Dd][Ii][Ff][Ii][Ee][Dd]\:";
	}
 print DEBUGOUT "\$key = $key\n" if ($DEBUG);
	$DP{ $dpl, "Method" } .= "/" if ( $DP{ $dpl, "Method" } ne "" );
	$DP{ $dpl, "Method" } .= $method;
	$DP{ $dpl, "X-ResultStatus" } = -200 if ( $DP{ $dpl, "X-ResultStatus" } eq -101 );

	undef $title;
	undef $metatitle;
	undef $author;
	$foundlmd = 0;
	$firstline = !0;
	open( FIN, "$NKF $infile|" ) || die "cannot open [$NKF $infile|].";;
	while (<FIN>) {
# print DEBUGOUT "$_\n" if ($DEBUG);
		if ( $firstline ) {
			$firstline = 0;
			if ( m%^HTTP\/% ) {
				@a = split( ' ' );
				if ( $a[1] == 200 ) {
					# success 
				} elsif ( $a[1] == 404 ) {
					# not found 
					$DP{ $dpl, "X-ResultStatus" } = $a[1];
					# $DP{ $dpl, "Last-Modified" } = "";
					return (1);
				} else {
					$DP{ $dpl, "X-ResultStatus" } = $a[1];
					# $DP{ $dpl, "Last-Modified" } = "";
					return (1);
				}
			}
		}
		s/[\012\015]+//;
		if ( $_ eq '' ) {
			$isbody = !0;
		}
		if ( !$isbody ) {
			( $tag, $param ) = split( ': ' );
			$header{ $tag } = $param;
		} else {
			if ( m:^HINA/2.[0-9]: ) {
				close( FIN );
				$URI2PAGENAME{ &CaseLowerDomainNameURI( $DP{ $dpl, "URI" } ) } = $dpl;
				undef $DP{ $dpl, "Author-Name" };
				undef $DP{ $dpl, "Title" };
				undef $DP{ $dpl, "Keyword" };
				undef $DP{ $dpl, "X-VirtualURI" };
				$DP{ $dpl, "Last-Modified" } = "";
				$DP{ $dpl, "X-Time-Format" } = $_;
				return ( &ParseHinaDI( $pagename, $infile, 0 ) );
			}
			if ( $DP{ $dpl, "X-VirtualURI" } eq "" ) {
				if ( /\<title\>(.*)\<\/title\>/i ) {
				$title = $1;
 print DEBUGOUT "TITLE($title) found: $_\n" if ($DEBUG);
				}
				if ( /\<meta[ \t]*name[ \t]*=[ \t]*\"author\"[ \t]*content[ \t]*=[ \t]*\"([^"]*)"/i ) {
					$author = $1;
 print DEBUGOUT "AUTHOR($author) found: $_\n" if ($DEBUG);
				}
				if ( /\<meta[ \t]*content[ \t]*=[ \t]*\"([^"]*)"[ \t]*name[ \t]*=[ \t]*\"author\"/i ) {
					$author = $1;
 print DEBUGOUT "AUTHOR($author) found: $_\n" if ($DEBUG);
				}
				if ( /\<meta[ \t]*name[ \t]*=[ \t]*\"title\"[ \t]*content[ \t]*=[ \t]*\"([^"]*)"/i ) {
					$metatitle = $1;
 print DEBUGOUT "METATITLE($metatitle) found: $_\n" if ($DEBUG);
				}
				if ( /\<meta[ \t]*content[ \t]*=[ \t]*\"([^"]*)"[ \t]*name[ \t]*=[ \t]*\"title\"/i ) {
					$metatitle = $1;
 print DEBUGOUT "METATITLE($metatitle) found: $_\n" if ($DEBUG);
				}
			}
		}

		next if ( $foundlmd );
		$restline = $_;
		&jcode'convert( *restline, 'euc' );
		$l = $LINEFOLDLEN;
		while ( $l > 0 ) {
			$l = index( $restline, "<", $LINEFOLDLEN );
			$l2 = $l;
			$l2 = $LINEFOLDLEN if ( $l2 < $LINEFOLDLEN );
			$l2 = length( $restline ) if ( $l2 < length( $restline ) );
			$_ = substr( $restline, 0, $l2 );
			$restline = substr( $restline, $l2 );
			next if ( !/($key)/ );
			$keypart = $1;
			if ( $key =~ /[\.\*\+]/ ) {
				$_ = $keypart;
			}
 print DEBUGOUT "KEY($key) found: $_\n" if ($DEBUG);
			$lmdate = &ExtractNormalDate( $_, $IGNORETIME );
			$notimeincontents = $NOTIMEINCONTENTS;
			$timeformat = $EXTRACTTIMEFORMAT;
			next if ( $timeformat eq "" );
			$update = 0;
 print DEBUGOUT "new Last-Modified: $lmdate\n" if ($DEBUG);
 print DEBUGOUT "now Last-Modified: $DP{ $dpl, \"Last-Modified\" }\n" if ($DEBUG);
			if ( ($OVERALL) || ($DP{ $dpl, "Last-Modified" } le $lmdate) ) {
 print DEBUGOUT "updated newer Last-Modified on \[$method\].\n" if ($DEBUG);
				$update = 2;
				if ( $DP{ $dpl, "Last-Modified" } lt $lmdate ) {
					$update = 1;
				}
				undef $DP{ $dpl, "Author-Name" };
				undef $DP{ $dpl, "Title" };
				undef $DP{ $dpl, "Keyword" };
				$DP{ $dpl, "Author-Name" } = $header{ "Author" } if ( $header{ "Author" } ne "" );
				$DP{ $dpl, "Title" } = $header{ "Title" } if ( $header{ "Title" } ne "" );
				$DP{ $dpl, "Keyword" } = $header{ "Keyword" } if ( $header{ "Keyword" } ne "" );
				$DP{ $dpl, "X-Time-Format" } = $timeformat;
				$DP{ $dpl, "X-LM-Is-FMD" } = $notimeincontents;
				$DP{ $dpl, "Last-Modified" } = $lmdate;
				$DP{ $dpl, "Server" } = $header{ "Server" } if ( $header{ "Server" } ne "" );
				$DP{ $dpl, "Date" } = $NOWTIME;

 printf( DEBUGOUT "lmddate: [%s] [%s] -> ", $NOWTIME, $header{ "Date" } ) if ($DEBUG);
				$lmddate = $NOWTIME;
#				$date = &ExtractNormalDate( $header{ "Date" }, $IGNORETIME );
#				$lmddate = $date if ( $date ne $ERRTIME );
 print DEBUGOUT "lmddate: [$lmddate]\n" if ($DEBUG);

 printf( DEBUGOUT "fmddate: [%s] [%s] -> ", $lmddate, $DP{ $dpl, "Date" }) if ($DEBUG);
				$fmddate = $lmddate;
				$date = &ExtractNormalDate( $DP{ $dpl, "Date" }, $IGNORETIME );
				$fmddate = $date if ( $date ne $ERRTIME );
 print DEBUGOUT "fmddate: [$fmddate]\n" if ($DEBUG);

				if ( $update == 1 ) {
					$DP{ $dpl, "X-First-Modified-Detected" } = $fmddate;
 printf( DEBUGOUT "updated X-First-Modified-Detected: [%s]\n", $DP{ $dpl, "X-First-Modified-Detected" } ) if ($DEBUG);
				}
				if ( $update == 2 ) {
					if ( !defined($DP{ $dpl, "X-First-Modified-Detected" }) ) {
						$DP{ $dpl, "X-First-Modified-Detected" } = $fmddate;
 printf( DEBUGOUT "updated X-First-Modified-Detected: [%s]\n", $DP{ $dpl, "X-First-Modified-Detected" } ) if ($DEBUG);
					}
				}

				$DP{ $dpl, "Last-Modified-Detected" } = $lmddate;
				$DP{ $dpl, "Authorized" } = $AGENT;
				$DP{ $dpl, "X-Authorized-Pagename" } = $pagename;
				$DP{ $dpl, "Authorized-url" } = $ANTENNA_URI;
				$DP{ $dpl, "X-ResultStatus" } = 200;
				$DP{ $dpl, "X-Hop" } = "0";
				$DP{ $dpl, "Expire" } = $EXPIRETIME;
				$DP{ $dpl, "Expires" } = $EXPIRETIME;
				$DP{ $dpl, "X-Result-Method" } = $method;
				$foundlmd = !0;
			}
		}
	}

	if ( $foundlmd ) {
		if ( defined $metatitle ) {
			$title = $metatitle;
		}
		if ( defined $title ) {
			$DP{ $dpl, "Title" } = $title;
			$DP{ $dpl, "TITLE" } = $title if ( $DP{ $dpl, "TITLE" } eq "" );
		}
		if ( defined $author ) {
			$DP{ $dpl, "Author-Name" } = $author;
			$DP{ $dpl, "AUTHOR" } = $author if ( $DP{ $dpl, "AUTHOR" } eq "" );
		}
		return (0);
	}

	return (1);
}

########################################################################
### HINA.TXT出力 
## Print_HINATXT()
#
sub Print_HINATXT
{
	local( $onlyorigdata ) = shift;
	local( $a );
	local( $i );
	local( $lastmod );
	local( $href );
	local( $title );
	local( $hop );
	local( $server );

	return if ( $HINAOUT eq "" );
 print DEBUGOUT "Print_HINATXT\n" if ($DEBUG);
	open( HINAOUT, ">$HINAOUT" );
	for ( $i=0; $i<$DPLNO; $i++ ) {
		if ( $onlyorigdata != 0 ) {
			next if ( $DP{$DPL[$i],"X-Result-Method" } =~ /remote/i );
		}
		$lastmod = $DP{$DPL[$i],"Last-Modified"};
		$lastmod = &DateToClock( $lastmod );
		$lastmod -= $DEFAULTTZDIFFTIME*60*60;
		$lastmod = &ClockToDate( $lastmod );
		$a = $DP{$DPL[$i],"X-ResultStatus"};
		if ( $a == 200 ) {
			$lastmod =~ s%(\d\d\d\d/\d\d/\d\d \d\d:\d\d):\d\d%$1%;
			$hop = $DP{$DPL[$i],"X-Hop"}+0;
			print HINAOUT "<!--HINA_OK $lastmod \[$hop\]-->";
			$lastmod =~ s%\d\d\d\d/(\d\d)/(\d\d) (\d\d):(\d\d)%\?$1$2$3$4%;
			$server = $DP{$DPL[$i],"Server"};
			if ( ( $server =~ /CERN/ ) ||
			     ( $server =~ /Microsoft-Internet-Information-Server/ ) ||
			     ( $server =~ m%Netscape-Communications/1.1$% ) ||
			     ( $server =~ m%Netscape-Enterprise/3.0$% ) ||
			     ( $server =~ /Purveyor/ ) ||
			     ( $server =~ /IBM-ICS/ ) ) {
				$lastmod = "";
				print HINAOUT "<!--HINA_CERN -->";
			}
		} else {
			$lastmod = "";
			if ( $a == 404 ) {
				print HINAOUT "<!--HINA_NOT_FOUND-->";
			} elsif ( $a == -100 ) {
				print HINAOUT "<!--HINA_TIMEOUT-->";
			} elsif ( $a == -101 ) {
				print HINAOUT "<!--HINA_REMOTE_OUT-->";
			} elsif ( $a == -200 ) {
				print HINAOUT "<!--HINA_NOT_DETECTED-->";
			} elsif ( $a == -300 ) {
				print HINAOUT "<!--HINA_ERR_CONNECT-->";
			} else {
				print HINAOUT "<!--HINA_ERR-->";
			}
		}
		$href = $DP{$DPL[$i],"URI"};
		if ( $href =~ /#/ ) {
			$href =~ s/(.*)#(.*)/$1$lastmod#$2/;
		} else {
			$href .= "$lastmod";
		}
		$title = $DP{$DPL[$i],"TITLE"};
		print HINAOUT "<a href=\"$href\">$title</a>\n";
	}
	close( HINAOUT );
}

########################################################################
### HINA.DI出力 
## Print_HINADI()
#
sub Print_HINADI
{
	local( $onlyorigdata ) = shift;
	local( $i );
	local( $cmdname );
	local( $data );

	return if ( $DIOUT eq "" );
 print DEBUGOUT "Print_HINADI\n" if ($DEBUG);
	open( DIOUT, ">$DIOUT" );
	print DIOUT "$HINA_VER\n";
	print DIOUT "User-Agent: $AGENT\n";
	print DIOUT "Date: " . &ClockToDate2(&DateToClock($NOWTIME)) . " GMT\n";
	print DIOUT "Content-Type: text/plain; charset=EUC-JP\n";
	print DIOUT "\n";

	for ( $i=0; $i<$DPLNO; $i++ ) {
 print DEBUGOUT "\[$DPL[$i]\]\n" if ($DEBUG);
		if ( $onlyorigdata != 0 ) {
			next if ( $DP{$DPL[$i],"X-Result-Method" } =~ /remote/i );
		}
		if ( &DateToClock( $DP{$DPL[$i],'Date'} ) == 0 ) {
			$DP{$DPL[$i],'Date'} = $NOWTIME;
		}
		$DP{$DPL[$i],'HINA-Version'} = $HINA_VER;
		foreach $cmdname ( @HINADI_CMDNAMELIST ) {
			last if ( $cmdname =~ /TERMINATE/ );
			$data = $DP{$DPL[$i],$cmdname};
			if ( $cmdname eq "Method" ) {
				$data .= "/" if ( $data ne "" );
				$data .= $DP{$DPL[$i],"X-ResultStatus"}
			} elsif ( $cmdname eq "URL" ) {
				$data = $DP{$DPL[$i],"URI"}
			} elsif ( $cmdname eq "Virtual" ) {
				$data = $DP{$DPL[$i],"X-VirtualURI"}
			} elsif ( $cmdname eq "X-WDB-Title" ) {
				$data = $DP{$DPL[$i],"TITLE"}
			} elsif ( $cmdname eq "X-WDB-Author-Name" ) {
				$data = $DP{$DPL[$i],"AUTHOR"}
			} elsif ( $cmdname eq "X-LM-Is-FMD" ) {
				next if ( $data eq "0" );
			}
			next if ( $data eq "" );
			if ( ( $cmdname eq "Date" ) ||
			     ( $cmdname eq "Last-Modified" ) ||
			     ( $cmdname eq "Last-Modified-Detected" ) ||
			     ( $cmdname eq "X-First-Modified-Detected" ) ||
			     ( $cmdname eq "Expires" ) ||
			     ( $cmdname eq "Expire" ) ) {
				$data = &DateToClock(&ExtractNormalDate( $data, "ZZZ" ));
				next if ( $data == 0 );
				$data = &ClockToDate2( $data ) . " GMT";
			}
			print DIOUT "$cmdname:\t\t$data\n";
		}
		print DIOUT "\n";
	}
	close( DIOUT );
}


########################################################################
### HINA.HTML出力 
## Print_HINAHTML()
#
sub Print_HINAHTML
{
	local( $a );
	local( $i );
	local( $lastmod );
	local( $lastmod2 );
	local( $href );
	local( $title );
	local( $name );
	local( $comment );
	local( $gettime );
	local( $method );
	local( $mark );
	local( $codename );
	local( $status );
	local( $server );
	local( $s );
	local( $hop );
	local( $errormark );

 print DEBUGOUT "Print_HINAHTML\n" if ($DEBUG);
	if ( $SORT == 1 ) {
		open( SORT, "|sort -r" );
	}

	for ( $i=0; $i<$DPLNO; $i++ ) {
		$errormark = $HINA_NOERRORMARK;
		$lastmod = $DP{$DPL[$i],"Last-Modified"};
		if ( $DP{$DPL[$i],"X-LM-Is-FMD"} eq "1" ) {
			$lastmod = $DP{$DPL[$i],"X-First-Modified-Detected"};
		}
		$lastmod = &DateToClock( $lastmod );
		if ( $lastmod == 0 ) {
			$lastmod = "";
			$lastmod2 = "----/--/-- --:--";
		} else {
			$lastmod -= $DEFAULTTZDIFFTIME*60*60;
			$lastmod = &ClockToDate( $lastmod );
			$lastmod =~ s%(\d\d\d\d\/\d\d\/\d\d \d\d\:\d\d).*$%$1%;
			$lastmod2 = $lastmod;
			$hop = $DP{$DPL[$i],"X-Hop"};
			$status = "<!--HINA_OK $lastmod \[$hop\]-->";
			$lastmod =~ s%\d\d\d\d/(\d\d)/(\d\d) (\d\d):(\d\d)%\?$1$2$3$4%;
		}
		$a = $DP{$DPL[$i],"X-ResultStatus"};
		if ( $a == 200 ) {
		} else {
			if ( $a == 404 ) {
				$status = "<!--HINA_NOT_FOUND-->";
				$errormark = "N";
			} elsif ( $a == -100 ) {
				$status = "<!--HINA_TIMEOUT-->";
				$errormark = "T";
			} elsif ( $a == -101 ) {
				$status = "<!--HINA_REMOTE_OUT-->";
				$errormark = "R";
			} elsif ( $a == -200 ) {
				$status = "<!--HINA_NOT_DETECTED-->";
				$errormark = "D";
			} elsif ( $a == -300 ) {
				$status = "<!--HINA_ERR_CONNECT-->";
				$errormark = "C";
			} else {
				$status = "<!--HINA_ERR-->";
				$errormark = "E";
			}
		}
		$server = $DP{$DPL[$i],"Server"};
		if ( ( $server =~ /CERN/ ) ||
		     ( $server =~ /Microsoft-Internet-Information-Server/ ) ||
		     ( $server =~ m%Netscape-Communications/1.1$% ) ||
		     ( $server =~ m%Netscape-Enterprise/3.0$% ) ||
		     ( $server =~ /Purveyor/ ) ||
		     ( $server =~ /IBM-ICS/ ) ) {
			$lastmod = "";
			$status .= "<!--HINA_CERN -->";
		}
		$href = $DP{$DPL[$i],"URI"};
		if ( $href =~ /#/ ) {
			$href =~ s/(.*)#(.*)/$1$lastmod#$2/;
		} else {
			$href .= "$lastmod";
		}
		$title = $DP{$DPL[$i],"TITLE"};
		$name = $DP{$DPL[$i],"AUTHOR"};
		$comment = $DP{$DPL[$i],"COMMENT"};
		$codename = $DPL[$i];
		$mark = '';
		$gettime = sprintf( "%02ds", $DP{$DPL[$i],"X-GETTIME"} );
		$method = $DP{$DPL[$i],"X-Result-Method" };
# print DEBUGOUT "Method: $method\($mark\)\n" if ($DEBUG);
		if ( $method =~ /head/i ) {
			$mark = 'H';
		} elsif ( $method =~ /get/i ) {
			$mark = 'G';
		} elsif ( $method =~ /remote/i ) {
# print DEBUGOUT "X-Authorized-Pagename: $DP{$DPL[$i],\"X-Authorized-Pagename\"}\n" if ($DEBUG);
			$mark = $RP{ $DP{$DPL[$i],"X-Authorized-Pagename"}, "MARKURI" };
			$gettime = sprintf( "%02ds", $RP{ $DP{$DPL[$i],"X-Authorized-Pagename"}, "X-GETTIME" } );
		}
# print DEBUGOUT "Method: $method\($mark\)\n" if ($DEBUG);
		if ( $mark eq "" ) {
			$mark = "-";
		}

# print DEBUGOUT "Output: $status $href $lastmod2 $codename\n" if ($DEBUG);

#		$s = sprintf( "%s(%s:%s) <a href=\"%s\">%s</a> by %s %s", $lastmod2, $mark, $gettime, $href, $title, $name, $comment );
#		$s =~ s/[ ]+$//;
#		print "$s\n";

		$_ = $HINA_HTML_FORMAT;
		s/%s/$status/g;
		s/%h/$href/g;
		s/%t/$title/g;
		s/%n/$name/g;
		s/%l/$lastmod2/g;
		s/%m/$mark/g;
		s/%g/$gettime/g;
		s/%c/<!--codename $codename -->/g;
		s/%C/$comment/g;
		s/%E/$errormark/g;
		s/%H/$DP{$DPL[$i],"URI"}/;
		s/[ ]+\n/\n/g;
		s:[ ]+</a>:</a>:g;
		if ( $SORT == 0 ) {
			print;
		} else {
			print SORT;
		}

#		$s = sprintf( "<li>\n%s<a href=\"%s\">\n<B>%s</B> by %s %s", $status, $href, $title, $name, $comment );
#		$s =~ s/[ ]+$//;
#		print "$s";
#		$s = sprintf( "</a>\n%s (%s:%s)\n<!--codename %s -->\n\n", $lastmod2, $mark, $gettime, $codename );
#		print "$s";
	}
}

########################################################################
### WDBファイル出力 
## Print_WDBFileAll()
#
sub Print_WDBFileAll
{
	local( $i );
	local( $s );

	for ( $i=0; $i<$RPLNO; $i++ ) {
# print "$RPL[$i], $RP{ $RPL[$i] }\n";
		next if ( $RP{ $RPL[$i] } ne "defined" );
		print "REMOTE:\t\t$RPL[$i]\n";
		foreach $cmdname ( @REMOTE_CMDNAMELIST ) {
			print "$cmdname:\t\t$RP{$RPL[$i],$cmdname}\n";
		}
		print "\n";
	}
	for ( $i=0; $i<$DPLNO; $i++ ) {
		next if ( $DP{ $DPL[$i] } ne "defined" );
		print "PAGE:\t\t$DPL[$i]\n";
		foreach $cmdname ( @DIRECT_CMDNAMELIST ) {
			print "$cmdname:\t\t$DP{$DPL[$i],$cmdname}\n";
		}
		print "\n";
	}
}

########################################################################
### WDBの一部を編集用HTMLに出力 
## Print_WDBDISPHTML( REMOTE, DIRECT, PASS )
#
sub Print_WDBDISPHTML
{
	local( $remote ) = shift;
	local( $direct ) = shift;
	local( $pass ) = shift;
	local( $i );
	local( $selected );
	local( $s );
	local( $r1, $r2, $r3, $r4, $r51, $r52, $r53, $r54, $r55 );

	$s = <<EOF;
<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">
<!--  WDB MAINTENANCE DISPLAY  -->
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=ISO-2022-JP">
<META HTTP-EQUIV="Content-Language" CONTENT="ja">
<TITLE>WDB Maintainance Display</TITLE>
</HEAD>
<BODY>
<DIV>
<FORM ACTION="$DISP_PL" METHOD="POST">
EOF

	&jcode'convert( *s, 'jis' );
	print "$s";

#------

	$s = <<EOF;
<FONT SIZE=+2><B>[取得先登録]</B></FONT><BR>
<SELECT NAME="DIRECT" SIZE="5">
EOF

	&jcode'convert( *s, 'jis' );
	print "$s";

	for ( $i=0; $i<$DPLNO; $i++ ) {
		next if ( $DP{ $DPL[$i] } ne "defined" );
		$selected = "";
		$selected = " selected" if ( $DPL[$i] eq $direct );
		$s = "<OPTION VALUE=\"$DPL[$i]\"$selected>$DP{$DPL[$i],'TITLE'} （$DP{$DPL[$i],'AUTHOR'}）\n";
		&jcode'convert( *s, 'jis' );
		print "$s";
	}

	$r1 = $DP{$direct,'TITLE'};
	$r2 = $DP{$direct,'AUTHOR'};
	$r3 = $DP{$direct,'COMMENT'};
	$r4 = $DP{$direct,'KEY'};
	$r51 = ""; $r52 = ""; $r53 = ""; $r54 = ""; $r55 = "";
	if ( $DP{$direct,'METHOD'} eq "REMOTE" ) {
		$r51 = "selected";
	} elsif ( $DP{$direct,'METHOD'} eq "GET" ) {
		$r52 = "selected";
	} elsif ( $DP{$direct,'METHOD'} eq "HEAD" ) {
		$r53 = "selected";
	} elsif ( $DP{$direct,'METHOD'} eq "GET2" ) {
		$r54 = "selected";
	} elsif ( $DP{$direct,'METHOD'} eq "HEAD2" ) {
		$r55 = "selected";
	} elsif ( $DP{$direct,'KEY'} ne "" ) {
		$r52 = "selected";
	} else {
		$r53 = "selected";
	}

	$r1 =~ s/"/&#34;/g;
	$r2 =~ s/"/&#34;/g;
	$r3 =~ s/"/&#34;/g;
	$r4 =~ s/"/&#34;/g;
	$r5 =~ s/"/&#34;/g;
	$s = <<EOF;
</SELECT>
<INPUT TYPE="submit" NAME="directrefer" VALUE="左の一覧から呼び出し">
<BR>
<TABLE BORDER="1">
<TR><TD><NOBR>登録コード名         </NOBR><TD><INPUT TYPE="text" NAME="directcodename" SIZE="70" VALUE="$direct"               >
<BR>
<INPUT TYPE="submit" NAME="directcmd" VALUE=" OK ">
<INPUT TYPE="reset" VALUE="RESET">
<SELECT NAME="directmode">
<OPTION VALUE="read">呼び出し
<OPTION VALUE="write">記録
<OPTION VALUE="delete">削除
</SELECT>
PASS   :<INPUT TYPE="password" NAME="directpass" SIZE="16" VALUE="$pass">
<A HREF="readme.txt">[Help]</A><BR>
</TR>
<TR><TD><NOBR>URI                  </NOBR><TD><INPUT TYPE="text" NAME="directuri"      SIZE="70" VALUE="$DP{$direct,'URI'}"    ></TR>
<TR><TD><NOBR>タイトル             </NOBR><TD><INPUT TYPE="text" NAME="directtitle"    SIZE="70" VALUE="$r1"  ></TR>
<TR><TD><NOBR>著者                 </NOBR><TD><INPUT TYPE="text" NAME="directauthor"   SIZE="70" VALUE="$r2" ></TR>
<TR><TD><NOBR>コメント             </NOBR><TD><INPUT TYPE="text" NAME="directcomment"  SIZE="70" VALUE="$r3"></TR>
<TR><TD><NOBR>更新時刻取得用URI    </NOBR><TD><INPUT TYPE="text" NAME="directvirtual"  SIZE="70" VALUE="$DP{$direct,'VIRTUAL'}"></TR>
<TR><TD><NOBR>取得方法             </NOBR><TD><SELECT NAME="directmethod"><OPTION VALUE="REMOTE" $r51>リモート<OPTION VALUE="GET" $r52>GET<OPTION VALUE="HEAD" $r53>HEAD<OPTION VALUE="GET2" $r54>GET（強制）<OPTION VALUE="HEAD2" $r55>HEAD（強制）</SELECT></TR>
<TR><TD><NOBR>キーワード           </NOBR><TD><INPUT TYPE="text" NAME="directkey"      SIZE="70" VALUE="$r4"    ></TR>
</TABLE>
<BR>
EOF

	&jcode'convert( *s, 'jis' );
	print "$s";

#------

	$s = <<EOF;
<FONT SIZE=+2><B>[リモートアンテナ登録]</B></FONT><BR>
<INPUT TYPE="hidden" NAME="INFO" VALUE="WDB Maintainance" >
<INPUT TYPE="hidden" NAME="NOW_REMOTE" VALUE="$remote" >
<INPUT TYPE="hidden" NAME="NOW_DIRECT" VALUE="$direct" >
<SELECT NAME="REMOTE" SIZE="5">
EOF

	&jcode'convert( *s, 'jis' );
	print "$s";

	for ( $i=0; $i<$RPLNO; $i++ ) {
		next if ( $RP{ $RPL[$i] } ne "defined" );
		$selected = "";
		$selected = " selected" if ( $RPL[$i] eq $remote );
		$s = "<OPTION VALUE=\"$RPL[$i]\"$selected>$RP{$RPL[$i],'TITLE'}\n";
		&jcode'convert( *s, 'jis' );
		print "$s";
	}

	$r1 = $RP{$remote,'TITLE'};
	$r1 =~ s/"/&#34;/g;
	$s = <<EOF;
</SELECT>
<INPUT TYPE="submit" NAME="remoterefer" VALUE="左の一覧から呼び出し">
<BR>
<TABLE BORDER="1">
<TR><TD><NOBR>登録コード名         </NOBR><TD><INPUT TYPE="text" NAME="remotecodename" SIZE="70" VALUE="$remote"              >
<BR>
<INPUT TYPE="submit" NAME="remotecmd" VALUE=" OK ">
<INPUT TYPE="reset" VALUE="RESET">
<SELECT NAME="remotemode">
<OPTION VALUE="read">呼び出し
<OPTION VALUE="write">記録
<OPTION VALUE="delete">削除
</SELECT>
PASS   :<INPUT TYPE="password" NAME="remotepass" SIZE="16" VALUE="$pass">
<A HREF="readme.txt">[Help]</A><BR>
</TR>
<TR><TD><NOBR>アンテナURI          </NOBR><TD><INPUT TYPE="text" NAME="remoteuri"      SIZE="70" VALUE="$RP{$remote,'URI'}"   ></TR>
<TR><TD><NOBR>アンテナ名           </NOBR><TD><INPUT TYPE="text" NAME="remotetitle"    SIZE="70" VALUE="$r1"                  ></TR>
<TR><TD><NOBR>管理者               </NOBR><TD><INPUT TYPE="text" NAME="remoteauthor"   SIZE="70" VALUE="$RP{$remote,'AUTHOR'}"></TR>
<TR><TD><NOBR>アンテナファイル実体 </NOBR><TD><INPUT TYPE="text" NAME="remotevirtual"  SIZE="70" VALUE="$RP{$remote,'VIRTUAL'}"></TR>
<TR><TD><NOBR>アンテナマーク       </NOBR><TD><INPUT TYPE="text" NAME="remotemark"     SIZE="70" VALUE="$RP{$remote,'MARK'}"  ></TR>
<TR><TD><NOBR>保存ファイル名       </NOBR><TD><INPUT TYPE="text" NAME="remotesaveas"   SIZE="70" VALUE="$RP{$remote,'SAVEAS'}"></TR>
</TABLE>
<BR>
EOF

	&jcode'convert( *s, 'jis' );
	print "$s";

#------

	$s = <<EOF;
</FORM>
</DIV>
</BODY>
</HTML>
EOF

	&jcode'convert( *s, 'jis' );
	print "$s";

}

########################################################################
### リモートアンテナリストへ登録 
## RegisterRemote( PAGENAME, URI, TITLE, AUTHOR, VIRTUAL, MARK, SAVEAS )
#
sub RegisterRemote
{
	local( $n );
	local( $pagename ) = shift;

	if ( $RP{ $pagename } ne "defined" ) {
		$n = $RPLNO++;
		$RPL[$n] = $pagename;
		$RP{ $pagename } = "defined";
	}

	$RP{ $pagename, "URI" } = shift;
	$RP{ $pagename, "TITLE" } = shift;
	$RP{ $pagename, "AUTHOR" } = shift;
	$RP{ $pagename, "VIRTUAL" } = shift;
	$RP{ $pagename, "MARK" } = shift;
	$RP{ $pagename, "SAVEAS" } = shift;
}

########################################################################
### リモートアンテナリストから削除 
## UnregisterRemote( PAGENAME );
#
sub UnregisterRemote
{
	local( $pagename ) = shift;

	if ( $RP{ $pagename } eq "defined" ) {
		$RP{ $pagename } = "undefined";
	}
}

########################################################################
### 取得先リストへ登録 
## RegisterDirect( PAGENAME, URI, TITLE, AUTHOR, VIRTUAL, METHOD, COMMENT, KEY )
#
sub RegisterDirect
{
	local( $n );
	local( $pagename ) = shift;

	if ( $DP{ $pagename } ne "defined" ) {
		$n = $DPLNO++;
		$DPL[$n] = $pagename;
		$DP{ $pagename } = "defined";
	}

	$DP{ $pagename, "URI"  } = shift;
	$DP{ $pagename, "TITLE"  } = shift;
	$DP{ $pagename, "AUTHOR"  } = shift;
	$DP{ $pagename, "VIRTUAL"  } = shift;
	$DP{ $pagename, "METHOD"  } = shift;
	$DP{ $pagename, "COMMENT"  } = shift;
	$DP{ $pagename, "KEY"  } = shift;
}

########################################################################
### 取得先リストから削除 
## UnregisterDirect( PAGENAME )
#
sub UnregisterDirect
{
	local( $pagename ) = shift;

	if ( $DP{ $pagename } eq "defined" ) {
		$DP{ $pagename } = "undefined";
	}
}

########################################################################
### date to clock 
## CLOCK = DateToClock( DATE )
#
sub DateToClock
{
	local( $lmdate ) = shift;
	local( $nday, $clock );
	local( $year, $month, $day, $hour, $min, $sec ) = split( "[/: ]", $lmdate );
	local( $u1, $u4, $u100, $u400 );
	local( $a1, $a4, $a100, $a400 );

	$nday = 365*($year-1980);
	$a4 = int( ($year-1980)%4 );
	$u4 = int( ($year-1980+3)/4 );
	$a100 = int( ($year-1900)%100 );
	$u100 = int( ($year-1900)/100 );
	$a400 = int( ($year-1600)%400 );
	$u400 = int( ($year-1600)/400 );
# print "$nday, $u1, $a4, $u4, $a100, $u100, $a400, $u400\n";
	if ( ( ($a4 == 0) && ($a100 != 0) ) || ($a400 == 0) ) {
		$nday += $u4-$u100+$u400+$DAYOFMONTH_U[$month-1];
	} else {
		$nday += $u4-$u100+$u400+$DAYOFMONTH[$month-1];
	}
	$nday += $day-1;
# print "$nday, $u1, $a4, $u4, $a100, $u100, $a400, $u400\n";
	$clock = $nday*24*60*60 + $hour*60*60 + $min*60 + $sec;
	$clock = 0 if ( $clock < 0 );
	return ($clock);
}

########################################################################
### clock to date
## DATE = ClockToDate( CLOCK )
#
sub ClockToDate
{
	local( $year, $month, $day, $hour, $min, $sec, $mday ) = &ClockToDateCore( shift );
	local( $s ) = sprintf( "%04d/%02d/%02d %02d:%02d:%02d", $year, $month, $day, $hour, $min, $sec );
	return ($s);
}

sub ClockToDate2
{
	local( $year, $month, $day, $hour, $min, $sec, $mday ) = &ClockToDateCore( shift );
	local( $s ) = sprintf( "%s, %d %s %d %02d:%02d:%02d", $MDAY[$mday], $day, $MONTH[$month-1], $year, $hour, $min, $sec );
	return ($s);
}

sub ClockToDateCore
{
	local( $clock ) = shift;
	local( $nday );
	local( $year, $month, $day, $hour, $min, $sec, $mday );
	local( $i );
	local( $u1, $u4, $u100, $u400 );
	local( $a1, $a4, $a100, $a400 );

	$clock = 0 if ( $clock < 0 );

	$nday = int( $clock/(24*60*60) );
	$clock -= $nday*(24*60*60);
	$hour = int( $clock/(60*60) );
	$clock -= $hour*(60*60);
	$min = int( $clock/60 );
	$sec = $clock%60;

# print "$nday, $u1, $u4, $u100, $u400\n";
	$mday = ($nday+2)%7;
	$nday += ((1980-1600)*365)+(1-4+95);
# print "$nday, $u1, $u4, $u100, $u400\n";
	$u400 = int( $nday/(365*400+1-4+100) );
	$nday -= $u400*    (365*400+1-4+100);
# print "$nday, $u1, $u4, $u100, $u400\n";
	$u100 = int( ($nday-1)/(365*100-1+25) );
	$nday -= $u100*        (365*100-1+25);
# print "$nday, $u1, $u4, $u100, $u400\n";
	$u4 = int( $nday/(365*4+1) );
	$nday -= $u4*    (365*4+1);
# print "$nday, $u1, $u4, $u100, $u400\n";
	$u1 = int( ($nday-1)/365 );
	$a1 = int( ($nday-1)%365 );
	$nday -= ($u1*365)+( $u1 ? 1 : 0);
# print "$nday, $u1, $u4, $u100, $u400\n";
	$year = $u1 + $u4*4 + $u100*100 + $u400*400 + 1600;
# print "$nday, $u1, $u4, $u100, $u400\n";
# print "$nday, $a1, $a4, $a100, $a400\n";

	if ( ( (($year%4) == 0) && (($year%100) != 0) ) || (($year%400) == 0) ) {
		for ( $i=1; $i<=12; $i++ ) {
# print "U $DAYOFMONTH_U[$i]\n";
			last if ( $nday < $DAYOFMONTH_U[$i] );
		}
		$day = $nday - $DAYOFMONTH_U[$i-1] + 1;
	} else {
		for ( $i=1; $i<=12; $i++ ) {
# print "$DAYOFMONTH[$i]\n";
			last if ( $nday < $DAYOFMONTH[$i] );
		}
		$day = $nday - $DAYOFMONTH[$i-1] + 1;
	}
	$month = $i;

	return ( $year, $month, $day, $hour, $min, $sec, $mday );
}

########################################################################
### リモートファイルダウンロード 
## SUCCESS = DownloadRemoteFileHTTP( REMOTENAME, METHOD, SAVEAS )
#
sub DownloadRemoteFileHTTP
{
	local( $remotename ) = shift;
	local( $method ) = shift;
	local( $saveas ) = shift;
	local( $href );
	local( $dpl );
	local( $staus );
	local( $gettime );
	local( $uri );

	$HTTP_REMOTE_TIMEOUT = 30 if ( !defined( $HTTP_REMOTE_TIMEOUT ) );
	$HTTP_TIMEOUT_G = $HTTP_REMOTE_TIMEOUT;

	$rpl = $remotename;
	$uri = $RP{ $rpl, "X-VirtualURI" };
	if ( $uri eq "" ) {
		$uri = $RP{ $rpl, "URI" };
	}
	$href = &ExtractNormalURI( $uri );
	if ( $href =~ /[.]gz$/i ) {
		$method .= "-GZIP";
	}
	( $status, $gettime ) = &DownloadHTTP( $href, $method, $saveas );
	$RP{ $rpl, "X-GETTIME" } = $gettime;
	if ( $status == 0 ) {
		# success;
	} elsif ( $status == 1 ) {
		$RP{ $rpl, "X-ResultStatus" } = -100; # timeout 
	} elsif ( $status == 2 ) {
		$RP{ $rpl, "X-ResultStatus" } = -300; # http error 
	}
	return ( $status );
}

########################################################################
### ドキュメントダウンロード 
## SUCCESS = DownloadDocumentHTTP( PAGENAME, METHOD, SAVEAS )
#
sub DownloadDocumentHTTP
{
	local( $pagename ) = shift;
	local( $method ) = shift;
	local( $saveas ) = shift;
	local( $href );
	local( $dpl );
	local( $staus );
	local( $gettime );
	local( $uri );

	$HTTP_TIMEOUT_G = $HTTP_TIMEOUT;

	$dpl = $pagename;
	$uri = $DP{ $dpl, "X-VirtualURI" };
	if ( $uri eq "" ) {
		$uri = $DP{ $dpl, "URI" };
	}
	$href = &ExtractNormalURI( $uri );
	( $status, $gettime ) = &DownloadHTTP( $href, $method, $saveas );
	$DP{ $dpl, "X-GETTIME" } = $gettime;
	if ( $status == 0 ) {
		# success;
	} elsif ( $status == 1 ) {
		$DP{ $dpl, "X-ResultStatus" } = -100; # timeout 
		$status = 0;
	} elsif ( $status == 2 ) {
		$DP{ $dpl, "X-ResultStatus" } = -300; # http error 
	}
	return ( $status );
}

########################################################################
### HTTPダウンロード 
## SUCCESS = DownloadHTTP( HREF, METHOD, SAVEAS )
#
sub DownloadHTTP
{
	local( $href ) = shift;
	local( $method ) = shift;
	local( $saveas ) = shift;
	local( $lmdate );
	local( $server );
	local( $port );
	local( $path );
	local( $host );
	local( $sendstr );
	local( $name, $aliases, $type, $len, $thataddr );
	local( $that );
	local( $proto );
	local( $oldselect );
	local( $gettime );
	local( $getgziped );
	local( $gzipreadbuf );
	local( $gzipreadlength );
	local( $contentlength );
	local( $isbody ) = 0;
	local($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);

 print DEBUGOUT "DownloadHTTP():\n" if ($DEBUG);

	$getgziped = 0;
	if ( $method eq "GET-GZIP" ) {
		$method = "GET";
		$getgziped = !0;
	}

	$path = $href;
	if ( $PROXY ne "" ) {
		$server = $PROXY;
		$server =~ s/:.*//;
		$port = $PROXY;
		$port =~ s/.*://;
		$path = $href;
		$host = $href;
		$host =~ s%http://([^/:]+).*$%$1%;
	} else {
		$server = $href;
		$server =~ s%http://([^/:]+).*$%$1%;
		$port = $href;
		$port =~ s%http://[^:/]+:%%;
		$port =~ s%^([^/]*).*$%$1%;
		if ( $port == 0 ) {
			$port = 80;
		}
		$path =~ s%http://[^/]+%%;
		$host = $server;
	}

	$sendstr = "$method $path HTTP/1.0\015\012";
	$sendstr .= "Host: $host\015\012";
	$sendstr .= "User-Agent: $AGENT\015\012";
	$sendstr .= "Referer: $ANTENNA_URI\015\012" if ( $ANTENNA_URI ne "" );
	$sendstr .= "Pragma: no-cache\015\012";
	$sendstr .= "\015\012";

 ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time());
 print DEBUGOUT sprintf( "%02d:%02d:%02d ", $hour, $min, $sec ) if ($DEBUG);
 print DEBUGOUT "access to $server:$port\n" if ($DEBUG);
 print DEBUGOUT "--\n$sendstr" if ($DEBUG);

	$gettime = time;

	if ( $server =~ /^(\d{1,3})[.](\d{1,3})[.](\d{1,3})[.](\d{1,3})$/ ) {
		$thataddr = pack( 'C4', $1, $2, $3, $4 );
	} else {
		( $name, $aliases, $type, $len, $thataddr ) = gethostbyname( $server );
	}

	$that = pack( $SOCKADDR, $AF_INET, $port, $thataddr );
	( $name, $aliases, $proto ) = getprotobyname( 'tcp' );

	eval {
		$SIG{'ALRM'} = 'timeout';
		sub timeout { die "timeout"; }
		eval {
			alarm( $HTTP_TIMEOUT_G );
		};
		if ( !socket( S, $AF_INET, $SOCK_STREAM, $proto ) ) {
			die "socket error";
		}
		if ( !connect( S, $that ) ) {
			die "connect error";
		}

		$oldselect = select;
		select ( S );
		$| = 1;
		print S "$sendstr";
		select ( $oldselect );

		if ( $getgziped ) {
			open( SAVEAS, ">$saveas" );
			while (<S>) {
				s/\015\12/\012/g;
				s/\015/\012/g;
				s/\012$//;
				if ( $_ eq '' ) {
					print DEBUGOUT "--\n" if ($DEBUG);
					last;
				}
				if ( $_ =~ /^Content-Length: (\d+)/i ) {
					$contentlength = $1;
				}
				print SAVEAS "$_\n";
 print DEBUGOUT "$_\n" if ($DEBUG);
			}
			close( SAVEAS );
 print DEBUGOUT "Get gzip data - $contentlength byte.\n" if ($DEBUG);
			open( SAVEAS, "|gzip -d>>$saveas" );
			binmode( SAVEAS );
			binmode( S );
			while ($contentlength) {
 print DEBUGOUT "Rest: $contentlength\n" if ($DEBUG);
				$gzipreadlength = $contentlength;
				$gzipreadlength = 1024 if $gzipreadlength > 1024;
				$gzipreadlength = read( S, $gzipreadbuf, $gzipreadlength );
				syswrite( SAVEAS, $gzipreadbuf, $gzipreadlength );
				$contentlength -= $gzipreadlength;
			}
			close(SAVEAS);
 print DEBUGOUT "Get gzip data - complete.\n" if ($DEBUG);
		} else {
			open( SAVEAS, ">$saveas" );
			while (<S>) {
				s/\015\12/\012/g;
				s/\015/\012/g;
				s/\012$//;
				if ($DEBUG) {
					if ( $_ eq '' ) {
						if ( !$isbody ) {
							print DEBUGOUT "--\n" if ($DEBUG);
							$isbody = !0;
						}
					}
					if ( !$isbody ) {
 print DEBUGOUT "$_\n" if ($DEBUG);
					}
				}
				print SAVEAS "$_\n";
			}
			close(SAVEAS);
		}
		close(S);
		eval {
			alarm( 0 );
		};
	};

	$gettime = time - $gettime;

	if ( $@ ne "" ) {
		close(S);
		close(SAVEAS);

		($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time());
		print DEBUGOUT sprintf( "%02d:%02d:%02d ", $hour, $min, $sec );
		print DEBUGOUT "ALARM $@ on $href.\n--\n";
		return (1, $gettime) if ( $@ =~ "timeout" );
		return (2, $gettime);
	}

	return (0, $gettime);
}

########################################################################
1;
# [EOF]

