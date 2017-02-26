#!/usr/local/bin/perl
#### 「WDB [WWW-Dancing-Bee]」 サンプル用設定ファイル 
#### Copyright 1999 GORRY. 
#### mailto: gorry@hauN.org 
#### 
#### History: 
#### 1999/08/22 V1.00 公開。
#### 1999/07/14 V0.14 新規作成。 

# WDBに入力する設定ファイルを指定 
$WDBFILE = "config.wdb";

# このファイルを指定 
$DISP_PL = "disp.cgi";

# .wdbファイル更新通知先メールアドレスを指定 
$MAILTO = "";
# $MAILTO = "yourmail@yourserver";

# 以下は必要な場合のみ設定 
$DEBUG    = 0;
# $DEBUG    = 1;
$DEBUGOUT = "DISP.debug";

# WDBDISP本体を起動 
require 'wdbdisp.pl';

# [EOF]
