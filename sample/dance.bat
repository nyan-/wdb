rem @echo off
rem WDB���s�T���v���X�N���v�g�usample/dance.bat�v V1.00
rem Copyright 1999 GORRY. 
rem mailto: gorry@hauN.org 
rem 
rem History: 
rem 1999/08/22 V1.00 ���J
rem 1999/07/14 V0.14 �V�K�쐬

rem WDB���s
perl dance.pl | nkf -s > ..\tmp\dance.$$

type head.html>..\tmp\temp1.$$
type ..\tmp\dance.$$>>..\tmp\temp1.$$
type tail.html>>..\tmp\temp1.$$
nkf -s ..\tmp\temp1.$$>..\tmp\index.$$
copy sample.di ..\hina.di
copy index.$$ ..\index.html
del *.$$
