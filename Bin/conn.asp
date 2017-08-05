<%
'=++++++++++++++++++++++++++++++++++++++++=
on error resume next
dim conns,connstr,mdbs
'-----------  Access数据库连接字符串 -----------
    mdbs="admin/Bin/KM_09_12_20.mdb"           '数据库文件目录
    Connstr="DRIVER=Microsoft Access Driver (*.mdb);DBQ="+server.mappath(mdbs)
'-----------  SQL数据库连接字符串    -----------
'	Connstr="driver={SQL Server};server=192.168.0.1,7788;database=KM_09_12_20;UID=sa;PWD=sa"
'---------------------------------------------
Set conn=Server.CreateObject("ADODB.Connection") 
    conn.Open connstr
'------------------------------------------==
 If Err Then
    Err.Clear
    Set Conns = Nothing
    Response.Write "err!"
    Response.End
 End If
'=++++++++++++++++++++++++++++++++++++++++=
%>
<!--#include file="function.asp"-->
<!--#include file="class.asp"-->
<style type="text/css">
<!--
body,td,th {
	font-size: 12px;
}
a{
	text-decoration: none;
	color: #000000;
}
a:hover {
	text-decoration: none;
	color:#333333;
}
-->
</style>