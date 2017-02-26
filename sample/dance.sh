#!/bin/sh
#### WDB実行サンプルスクリプト「sample_dance.sh」 V1.00
#### Copyright 1999 GORRY. 
#### mailto: gorry@hauN.org 
#### 
#### History: 
#### 1999/08/22 V1.00 公開
#### 1999/07/14 V0.14 新規作成

# DIRは環境に合わせて変更すること。
DIR="/home/your-home/public_html/your-antenna/wdb"

# 実行パス設定
PERL="/usr/local/bin/perl"
NKF="/usr/local/bin/nkf"

# WDB実行
cd $DIR
$PERL dance.pl | $NKF -s > dance.$$

if [ -s dance.$$ ]
then
# index.html生成
    cat head.html dance.$$ tail.html | $NKF -j > index.$$
    mv sample.di ../hina.di
    mv index.$$ ../index.html
    rm dance.$$
fi
