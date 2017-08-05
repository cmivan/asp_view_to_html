<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
 Response.CodePage= 65001
 Response.Charset="UTF-8"
 Server.ScriptTimeout=99990
 '### 容错模式
 on error resume next
%>
<%
'@@数据库连接
on error resume next
dim syspath,rootpath
    syspath ="../"
	rootpath=syspath&syspath

dim connstr1,connstr2
    connstr1 ="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="&server.mappath(syspath&"bin/KM_09_12_20.mdb")
    connstr2 ="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="&server.mappath(syspath&syspath&"bin/KM_09_12_20.mdb")
	
 '############  第1次连接    ############
set conn=Server.CreateObject("ADODB.Connection")
    conn.Open connstr1
    if err then
       err.clear
       set conn = nothing
	
 '############  第2次连接    ############
    set conn=Server.CreateObject("ADODB.Connection")
        conn.Open connstr2
        if err then
           err.clear
           set conn = nothing
           response.write("err...")
           response.end()
		end if	
		
		syspath=syspath&syspath
	
 end if
%>
<!--#include file="sys_config.asp"-->
<!--#include file="sys_pinyin.asp"-->
<!--#include file="sys_function.asp"-->
<!--#include file="sys_file.asp"-->
<!--#include file="sys_mod.asp"-->
<!--#include file="sys_system.asp"-->
<!--#include file="../../bin/class.asp"-->