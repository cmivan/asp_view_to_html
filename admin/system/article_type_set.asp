<!--#include file="article_config.asp"-->
<body>
<div class="mainWidth">
<TABLE border="0" align="center" cellpadding="0" cellspacing="10" class="forum1" style="width:450px;">
<TR class="forumin"><td>

<table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="forum2">
<form name="article_update" method="post" action=""> 

<tr class="forumRaw">
  <td align="center">标题</td>
  <td width="83" align="center">显示模式</td>
  <td width="50" align="center">排序</td>
  <td width="40" align="center">选中</td>
</tr>  
  
<%
dim article_id,class_id,is_save
'@接受数据
article_id=request.QueryString("article_id")
if isnumeric(article_id)=false then response.End()

class_id=request.QueryString("class_id")
if isnumeric(class_id)=false then response.End()

'@提交并处理数据
is_save=request.Form("is_save")
if is_save="yes" then
   '删除原来的设置
   conn.execute("delete * from article_set where article_id="&article_id&" and class_id="&class_id)
   '新添加的设置
   set rs=conn.execute("select * from sys_db_fields")
       do while not rs.eof
	      db_type  = request.Form("db_type_"&rs("id"))
		  order_id = request.Form("order_id_"&rs("id"))
		  is_ok    = request.Form("is_ok_"&rs("id"))
		  '@----------
		  if is_ok=1 then
		     if isnumeric(db_type) =false then db_type =0
			 if isnumeric(order_id)=false then order_id=0
			 in_sql="insert into article_set (article_id,class_id,filed_id,filed_mob_id,order_id)"
			 in_sql=in_sql&" values("&article_id&","&class_id&","&rs("id")&","&db_type&","&order_id&")"
			 conn.execute(in_sql)
		  end if
       rs.movenext
       loop
   set rs=nothing
   '保存提示
   if err=0 then
	  response.Write("<script>alert('保存成功!');window.location.href='article_manage_type.asp';</script>")
	  response.End()
   end if
end if





'@读取数据
set rs=conn.execute("select * from sys_db_fields")
  do while not rs.eof
     db_title=rs("db_title")
	 db_id   =rs("id")
	 '//从设置表中读取相应的栏目设置信息
	 rst_sql="select * from article_set where article_id="&article_id
	 rst_sql=rst_sql&" and filed_id="&db_id&" and class_id="&class_id
	 set rst=conn.execute(rst_sql)
	  if not rst.eof then
	     article_id  =rst("article_id")
	     filed_mob_id=rst("filed_mob_id")
	     order_id    =rst("order_id")
	     article_yes =true
	  else
	     filed_mob_id=0
	     order_id    =0
	     article_yes =false
	  end if
%>
<tr class="forumRow">
<td align="center"><%=db_title%></td>
<td align="center">
<select name="db_type_<%=db_id%>" id="db_type_<%=db_id%>"><%get_db_types(filed_mob_id)%></select>
</td>
<td align="center">
<input name="order_id_<%=db_id%>" type="text" id="order_id_<%=db_id%>" value="<%=order_id%>" size="10" />
</td>
<td align="center">
<input name="is_ok_<%=db_id%>" type="checkbox" id="is_ok_<%=db_id%>" value="1" <%if(article_yes) then%>checked="checked"<%end if%> />
</td>
</tr>
<%
  rs.movenext
  loop
set rs=nothing
%>

<tr class="forumRaw"><td colspan="4" align="center">
<input type="hidden" name="is_save" id="is_save" value="yes" />
<input type="submit" name="button" id="button" value=" 保存 " class="button_red" />
</td></tr>  
  
</form>
</table></td></tr>
</table>
</div>
</body>
</html>