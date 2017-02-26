#!/usr/local/bin/perl
#### ◇WWW更新時刻取得エージェント 「WDB [WWW-Dancing-Bee]」 設定ファイル
#### Copyright 1999,2000,2001 GORRY. 
#### mailto: gorry@hauN.org 
#### 
#### History: 
#### 2001/12/04 V2.07 $AGENTの構成方法を変更。
#### 2001/12/02 V2.06 $HINA_VERを追加。
#### 2000/05/22 V1.15 $HTTP_REMOTE_TIMEOUTを追加。
#### 1999/09/21 V1.07 $HINA_HTML_FORMATに%Eを追加。
####                  $HINA_NOERRORMARKを追加。
#### 1999/09/07 V1.04 $LINEFOLDLENを追加。
#### 1999/08/22 V1.00 公開。
#### 1999/08/16 V0.14 メーラ設定を追加。
#### 1999/06/24 V0.11 TZを追加。
#### 1999/04/18 V0.10 Overallモードフラグを新設。
#### 1999/04/18 V0.03 エージェント名修正。
#### 1999/04/16 V0.00 新規作成。 

########################################################################
### ユーザー毎の設定 
#

$DEBUG    = 1 if ( !defined( $DEBUG ) );
$DEBUGOUT = "WDB.debug" if ( !defined( $DEBUGOUT ) );
$DIOUT    = "WDB.di" if ( !defined( $DIOUT ) );
$HINAOUT  = "WDB.hina" if ( !defined( $HINAOUT ) );
$AGENT_COMMENT = "WWW-Dancing-Bee" if ( !defined( $AGENT_COMMENT ) );
$HTTP_TIMEOUT = 10 if ( !defined( $HTTP_TIMEOUT ) );
$HTTP_REMOTE_TIMEOUT = 30 if ( !defined( $HTTP_REMOTE_TIMEOUT ) );
$DEFAULT_EXPIRETIME = 6 if ( !defined( $DEFAULT_EXPIRETIME ) );

# 外部プログラム起動path設定 
$ENV{'PATH'} = $ENV{'PATH'} . ":/usr/local/bin/";

# 内部文字コード設定（*.plの文字コードと同一にする必要がある） 
$NKF = "nkf -e";
$JCODE = "euc";

# メーラ設定
$MAILCMD = "nkf -j | mail -s \"\@\@WDB-POSTMAIL\"" if ( !defined( $MAILCMD ) );

# エージェント設定 
$HINA_VER      = "HINA/2.2beta";
$AGENT_NAME    = "WDB";
$AGENT_VER     = "2.10";
$AGENT         = "$AGENT_NAME/$AGENT_VER (Antenna; $HINA_VER; $AGENT_COMMENT)";

# ソケット設定 
$USE_IPV6      = 0;
# 以下はwdblib.plがSocket.pmを使うようになったため廃止された。
# $AF_INET = 2;
# $SOCK_STREAM = 1;
# $WNOHANG = 1;
# $SOCKADDR = 'S n a4 x8';

# HINA.HTMLへの出力フォーマット 
$HINA_HTML_FORMAT =
"<li>%l%E(%m%E%g) <a href=\"%h\"><B>%t</B> by %n %C</a>\n"
if ( !defined( $HINA_HTML_FORMAT ) );
$HINA_NOERRORMARK = ':'
if ( !defined( $HINA_NOERRORMARK ) );

# Overallモード設定
$OVERALL = 0
if ( !defined( $OVERALL ) );

# デフォルトのタイムゾーン
$TZ = "JST"
if ( !defined( $TZ ) );

# 行fold長さ
$LINEFOLDLEN = 512;

########################################################################
1;
# [EOF]
