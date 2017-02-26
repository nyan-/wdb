#!/usr/local/bin/perl
#### 「WWW-Dancing-Bee WDB サンプル用設定ファイル 
#### Copyright 1999 GORRY. 
#### mailto: gorry@hauN.org 
#### 
#### History: 
#### 1999/09/28 V1.08 $HINA_HTML_FORMATから%sを外す。
####                  $HINA_NOERRORMARKを定義。
#### 1999/09/07 V1.03 $HINA_HTML_FORMATバグ修正。
#### 1999/08/22 V1.00 公開。
#### 1999/04/18 V0.14 新規作成。 

# WDBに入力する設定ファイルを指定 
$WDBFILE = "config.wdb";

# WDBが使用するPROXYを"サーバ:ポート"で指定 
# $PROXY    = "yourserver:8080";

# アンテナシステムのURI 
$ANTENNA_URI  = "http://yourserver.net/~yourhome/yourantenna/";

# HINA.HTMLへの出力フォーマット 
$HINA_HTML_FORMAT = 
"<li>%l (%m%E%g) <a href=\"%h\"><B>%t</B> by %n %C</a>\n";
$HINA_NOERRORMARK = ':';

# HINA.HTMLをsortするかどうかの指定 
$SORT = !0;

# タイムゾーン設定
$TZ = "JST";

# 以下は必要な場合のみ設定 
$DEBUG    = 0;
# $DEBUG    = 1;
$DEBUGOUT = "sample.debug";
$DIOUT    = "sample.di";
$HINAOUT  = "sample.hina";
# $AGENT_COMMENT = " (WWW-Dancing-Bee; )";
# $HTTP_TIMEOUT = 10;

# WDB本体を起動 
require 'wdb.pl';

# [EOF]
