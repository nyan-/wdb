#!/usr/local/bin/perl
#### ��WWW���������������������� ��WDB [WWW-Dancing-Bee]�� �ᥤ��ץ����
#### Copyright 1999 GORRY. 
#### mailto: gorry@hauN.org 
#### 
#### History: 
#### 1999/04/16 V1.00 ������
#### 1999/04/16 V0.00 ���������� 

########################################################################
### �ᥤ�� 
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
