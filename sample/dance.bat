rem @echo off
rem WDB実行サンプルスクリプト「sample/dance.bat」 V1.00
rem Copyright 1999 GORRY. 
rem mailto: gorry@hauN.org 
rem 
rem History: 
rem 1999/08/22 V1.00 公開
rem 1999/07/14 V0.14 新規作成

rem WDB実行
perl dance.pl | nkf -s > ..\tmp\dance.$$

type head.html>..\tmp\temp1.$$
type ..\tmp\dance.$$>>..\tmp\temp1.$$
type tail.html>>..\tmp\temp1.$$
nkf -s ..\tmp\temp1.$$>..\tmp\index.$$
copy sample.di ..\hina.di
copy index.$$ ..\index.html
del *.$$
