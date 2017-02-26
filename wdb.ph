#!/usr/local/bin/perl
#### ��WWW���������������������� ��WDB [WWW-Dancing-Bee]�� ����ե�����
#### Copyright 1999,2000,2001 GORRY. 
#### mailto: gorry@hauN.org 
#### 
#### History: 
#### 2001/12/04 V2.07 $AGENT�ι�����ˡ���ѹ���
#### 2001/12/02 V2.06 $HINA_VER���ɲá�
#### 2000/05/22 V1.15 $HTTP_REMOTE_TIMEOUT���ɲá�
#### 1999/09/21 V1.07 $HINA_HTML_FORMAT��%E���ɲá�
####                  $HINA_NOERRORMARK���ɲá�
#### 1999/09/07 V1.04 $LINEFOLDLEN���ɲá�
#### 1999/08/22 V1.00 ������
#### 1999/08/16 V0.14 �᡼��������ɲá�
#### 1999/06/24 V0.11 TZ���ɲá�
#### 1999/04/18 V0.10 Overall�⡼�ɥե饰���ߡ�
#### 1999/04/18 V0.03 �����������̾������
#### 1999/04/16 V0.00 ���������� 

########################################################################
### �桼����������� 
#

$DEBUG    = 1 if ( !defined( $DEBUG ) );
$DEBUGOUT = "WDB.debug" if ( !defined( $DEBUGOUT ) );
$DIOUT    = "WDB.di" if ( !defined( $DIOUT ) );
$HINAOUT  = "WDB.hina" if ( !defined( $HINAOUT ) );
$AGENT_COMMENT = "WWW-Dancing-Bee" if ( !defined( $AGENT_COMMENT ) );
$HTTP_TIMEOUT = 10 if ( !defined( $HTTP_TIMEOUT ) );
$HTTP_REMOTE_TIMEOUT = 30 if ( !defined( $HTTP_REMOTE_TIMEOUT ) );
$DEFAULT_EXPIRETIME = 6 if ( !defined( $DEFAULT_EXPIRETIME ) );

# �����ץ���൯ưpath���� 
$ENV{'PATH'} = $ENV{'PATH'} . ":/usr/local/bin/";

# ����ʸ�������������*.pl��ʸ�������ɤ�Ʊ��ˤ���ɬ�פ������ 
$NKF = "nkf -e";
$JCODE = "euc";

# �᡼������
$MAILCMD = "nkf -j | mail -s \"\@\@WDB-POSTMAIL\"" if ( !defined( $MAILCMD ) );

# ��������������� 
$HINA_VER      = "HINA/2.2beta";
$AGENT_NAME    = "WDB";
$AGENT_VER     = "2.10";
$AGENT         = "$AGENT_NAME/$AGENT_VER (Antenna; $HINA_VER; $AGENT_COMMENT)";

# �����å����� 
$USE_IPV6      = 0;
# �ʲ���wdblib.pl��Socket.pm��Ȥ��褦�ˤʤä������ѻߤ��줿��
# $AF_INET = 2;
# $SOCK_STREAM = 1;
# $WNOHANG = 1;
# $SOCKADDR = 'S n a4 x8';

# HINA.HTML�ؤν��ϥե����ޥå� 
$HINA_HTML_FORMAT =
"<li>%l%E(%m%E%g) <a href=\"%h\"><B>%t</B> by %n %C</a>\n"
if ( !defined( $HINA_HTML_FORMAT ) );
$HINA_NOERRORMARK = ':'
if ( !defined( $HINA_NOERRORMARK ) );

# Overall�⡼������
$OVERALL = 0
if ( !defined( $OVERALL ) );

# �ǥե���ȤΥ����ॾ����
$TZ = "JST"
if ( !defined( $TZ ) );

# ��foldĹ��
$LINEFOLDLEN = 512;

########################################################################
1;
# [EOF]
