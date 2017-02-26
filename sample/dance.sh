#!/bin/sh
#### WDB�¹ԥ���ץ륹����ץȡ�sample_dance.sh�� V1.00
#### Copyright 1999 GORRY. 
#### mailto: gorry@hauN.org 
#### 
#### History: 
#### 1999/08/22 V1.00 ����
#### 1999/07/14 V0.14 ��������

# DIR�ϴĶ��˹�碌���ѹ����뤳�ȡ�
DIR="/home/your-home/public_html/your-antenna/wdb"

# �¹ԥѥ�����
PERL="/usr/local/bin/perl"
NKF="/usr/local/bin/nkf"

# WDB�¹�
cd $DIR
$PERL dance.pl | $NKF -s > dance.$$

if [ -s dance.$$ ]
then
# index.html����
    cat head.html dance.$$ tail.html | $NKF -j > index.$$
    mv sample.di ../hina.di
    mv index.$$ ../index.html
    rm dance.$$
fi
