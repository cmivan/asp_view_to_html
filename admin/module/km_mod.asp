<!--#include file="km_mod_config.asp"-->
<%
dim del_id
del_id=request.QueryString("del_id")
if del_id<>"" and isnumeric(del_id) then conn.execute("delete from "&db_table&" where id="&del_id)
%>
<body>
<TABLE border="0" align="center" cellpadding="0" cellspacing="10" class="forum1"
 style="width:<%=class_width%>;">
<TR class="forumin"><td>
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="forum2">
<tr class="forumRow"><td height="22">
&nbsp;
<%
set rs=server.createobject("adodb.recordset")
    sql="select * from "&db_table&"_type order by order_id asc"
    rs.open sql,conn,1,1
do while not rs.eof

'//////////////add//////////////
if request.QueryString("type_id")="" then response.Redirect("?type_id="&rs("id"))
%>
<a href="?type_id=<%=rs("id")%>"<%IF cint(rs("id"))=cint(request.QueryString("type_id")) then%> style="color:#FF6600"<%end if%>><%=rs("title")%></a>&nbsp;|&nbsp;
<%
    rs.movenext     
loop
    rs.close 
set rs=nothing
%></td>
  <td align="center"><a href="km_mod_edit.asp">添加模块</a></td>
  </tr>
  
  
  <tr class="forumRow">
    <td colspan="2">
    <table width="100%" border="0" cellspacing="1" cellpadding="2" class="forum2">
      <tr class="forumRow">
        <td width="40" align="center">id</td>
        <td align="left">&nbsp;模版名称</td>
        <td align="left">&nbsp;Tip</td>
        <td colspan="2" align="center">管理</td>
        </tr>

<%
    type_id=request.QueryString("type_id")
set rs=server.createobject("adodb.recordset")
    if type_id<>"" and isnumeric(type_id) then
	sql="select * from "&db_table&" where type_id="&type_id&" order by id desc"
	else
	sql="select * from "&db_table&""
	end if 
    rs.open sql,conn,1,1
do while not rs.eof
%>	

 <tr class="forumRow">
        <td width="40" align="center"><%=rs("id")%></td>
        <td align="left">&nbsp;<%=rs("title")%></td>
        <td align="left">&nbsp;<input name="" type="text" value='<a id="mod:<%=rs("tip")%>"/>'></td>
        <td width="40" align="center"><a href="km_mod_edit.asp?id=<%=rs("id")%>">修改</a></td>
        <td width="40" align="center"><a href="?del_id=<%=rs("id")%>"  onClick='javascript: return confirm("确定要删除&nbsp;[<%=rs("title")%>]&nbsp;模块？") '>删除</a></td>
      </tr>
<%
    rs.movenext     
loop
    rs.close 
set rs=nothing   
conn.close
set conn=nothing
%>
	  
</table>
</td></tr></table>
</td></TR></TABLE>
</body>
</html>
