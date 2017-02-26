#!/usr/local/bin/perl
#### ◇WWW更新時刻取得エージェント 「WDB [WWW-Dancing-Bee]」 メインプログラム
#### Copyright 1999 GORRY. 
#### mailto: gorry@hauN.org 
#### 
#### History: 
#### 1999/04/16 V1.00 公開。
#### 1999/04/16 V0.00 新規作成。 

########################################################################
### メイン 
#

require 'wdblib.pl';

&Initialize();
&ReadCFGFile();
&StartDance();
&Print_HINADI();
&Print_HINATXT();
&Print_HINAHTML();

########################################################################
1;
# [EOF]
