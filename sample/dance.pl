#!/usr/local/bin/perl
#### ��WWW-Dancing-Bee WDB ����ץ�������ե����� 
#### Copyright 1999 GORRY. 
#### mailto: gorry@hauN.org 
#### 
#### History: 
#### 1999/09/28 V1.08 $HINA_HTML_FORMAT����%s�򳰤���
####                  $HINA_NOERRORMARK�������
#### 1999/09/07 V1.03 $HINA_HTML_FORMAT�Х�������
#### 1999/08/22 V1.00 ������
#### 1999/04/18 V0.14 ���������� 

# WDB�����Ϥ�������ե��������� 
$WDBFILE = "config.wdb";

# WDB�����Ѥ���PROXY��"������:�ݡ���"�ǻ��� 
# $PROXY    = "yourserver:8080";

# ����ƥʥ����ƥ��URI 
$ANTENNA_URI  = "http://yourserver.net/~yourhome/yourantenna/";

# HINA.HTML�ؤν��ϥե����ޥå� 
$HINA_HTML_FORMAT = 
"<li>%l (%m%E%g) <a href=\"%h\"><B>%t</B> by %n %C</a>\n";
$HINA_NOERRORMARK = ':';

# HINA.HTML��sort���뤫�ɤ����λ��� 
$SORT = !0;

# �����ॾ��������
$TZ = "JST";

# �ʲ���ɬ�פʾ��Τ����� 
$DEBUG    = 0;
# $DEBUG    = 1;
$DEBUGOUT = "sample.debug";
$DIOUT    = "sample.di";
$HINAOUT  = "sample.hina";
# $AGENT_COMMENT = " (WWW-Dancing-Bee; )";
# $HTTP_TIMEOUT = 10;

# WDB���Τ�ư 
require 'wdb.pl';

# [EOF]
