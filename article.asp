<!--#include file="Bin/conn.asp"-->
<%
'/// 读取列表 ///
 set rs=cm_conn("|0|119|",10,0)
     do while not rs.eof
%>
<div><a hre=""><%=rs("title")%></a></div>
<%
     rs.movenext
     loop
 set rs=nothing
%>