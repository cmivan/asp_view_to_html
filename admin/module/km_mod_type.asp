<!--#include file="km_mod_config.asp"-->

<script>
<!--
//进入编辑状态
function getEdit(id){
window.location.href='?id='+id;
}

function MM_jumpMenu(selObj,restore){ //v3.0
  eval("window.location='?Etype_id="+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
//-->
</script>

<%
'################| 处理删除问题 |################
      Etype_id =request.QueryString("Etype_id")
   if Etype_id<>"" and isnumeric(Etype_id) then session("Etype_id")=Etype_id

   add_o_id=request.QueryString("add_o_id")
if add_o_id<>"" and isnumeric(add_o_id) then session("type_id")=add_o_id

'################| 处理删除问题 |################
   type_id_del=request.QueryString("type_id_del")
if type_id_del<>"" and isnumeric(type_id_del) then 
'-===================| 删除分类 |=====================-
  sql  ="delete from "&db_table&"_type where id="&type_id_del&" and mob<>'page'"
  conn.execute(sql)
  sql_s="delete from "&db_table&" A left join "&db_table&"_type B on B.id=A.type_id  where A.type_id="&type_id_del&" and B.mob<>'page'"
  conn.execute(sql_s)
  del_info="成功删除分类、相应的内容!"
  call backPage(del_info,"?",0)
end if





'################| 处理分类排序问题 |################
  order=request.QueryString("order")
  o_id=request.QueryString("o_id")
  
  if order<>"" and o_id<>"" and isnumeric(o_id) then
	 order_sql="select * from "&db_table&"_type where id="&o_id
     row_now=conn.execute(order_sql)

     if not row_now.eof then
        row_now_order_id=row_now("order_id")
		row_now_id      =row_now("id")
		row_now_typeid  =row_now("type_id")
	 else
		call backPage("参数有误!","?",0)
	 end if

    '---------------------------------------------
 	 if o_id<>"" and isnumeric(o_id) then
    	orderStr=" and type_id="&row_now_typeid
 	 end if
	 
  end if


  if order="up" then
    '---------------------------------------------
set row_up=server.CreateObject("adodb.recordset")
    order_sql_up="select * from "&db_table&"_type where order_id<"&row_now_order_id&orderStr&" order by order_id desc"
    row_up.open order_sql_up,conn,1,1
	 if not row_up.eof then
        row_up_order_id=row_up("order_id")
		conn.execute("update "&db_table&"_type set order_id="&row_now_order_id&" where order_id="&row_up_order_id&orderStr)
		conn.execute("update "&db_table&"_type set order_id="&row_up_order_id&" where id="&row_now_id&orderStr)
     else
		call backPage("排序已到上限!","?",0)
	 end if
	row_up.close
set row_up=nothing

  elseif order="down" then
set row_down=server.CreateObject("adodb.recordset")
    order_sql_down="select * from "&db_table&"_type where order_id>"&row_now_order_id&orderStr&" order by order_id asc"
    row_down.open order_sql_down,conn,1,1
	 if not row_down.eof then
        row_down_order_id=row_down("order_id")
		row_down_query ="update "&db_table&"_type set order_id="&row_now_order_id&" where order_id="&row_down_order_id&orderStr
		row_now_query  ="update "&db_table&"_type set order_id="&row_down_order_id&" where id="&row_now_id&orderStr
		conn.execute(row_down_query)
		conn.execute(row_now_query)
	 else
		call backPage("排序已到下限!","?",0)
	 end if
	row_down.close
set row_down=nothing
	 
  end if

  
  
'################| 处理添加分类问题 |################
   id=request("id")
   edit=request("edit")
   
   title   = request.form("title")
   order_id= request.form("order_id")
   pic     = request.form("pic")
   type_id = request.form("type_id")
   
IF order_id="" or isNumeric(order_id)=false then order_id=0
IF type_id="" or isNumeric(type_id)=false then type_id=0

if edit<>"" then
   IF title=""  then 
      response.Write("<script language=javascript>alert('分类名称不能为空!');history.go(-1)</script>") 
      response.end()
   End IF

set rs=server.createobject("adodb.recordset")
 if edit="update" and id<>"" and isnumeric(id) then
    editStr="修改"
    sql="select * from "&db_table&"_type where id="&id 
    rs.open sql,conn,1,3
 else
    editStr="添加"
    sql="select * from "&db_table&"_type"
    rs.open sql,conn,1,3
    rs.addnew
 end if

'######### 写入数据 #############
    rs("title")   = title
    rs("order_id")= order_id
	
 if edit="add" then rs("type_id") =type_id
    session("type_id")=type_id

    rs.update
    rs.close
set rs=nothing
Response.Write "<script>window.location.href='?';</script>" 
end if 

session("Etype_id")=""


up_img  ="<img src="""&syspath&"public/skin/images/ico/up_ico.gif"" border=""0"">"
down_img="<img src="""&syspath&"public/skin/images/ico/down_ico.gif"" border=""0"">"
%>



<%class_width="465px"%>

<body>
<TABLE width="500" border="0" align="center" cellpadding="0" cellspacing="10" class="forum1"
 style="width:<%=class_width%>;">
<TR class="forumin"><td>

<%if db_typeShow<>1 then%>
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="forum2">

<form name="mclass_type_add" method="post" action="?edit=add">
        <tr class="forumRaw">
          <td align="center">添加</td>
          <td align="left">
            <select name="type_id" onChange="MM_jumpMenu(this,0)" style="display:none">
			<option value='0'>- 全部 -</option>
            <%call getTypeTree(0,0,session("Etype_id"))%>
          </select>
          <input name="title" type="text" class="input2" id="title"></td>
          <td align="center"><input name="order_id" type="text" id="order_id" value="0" size="5"></td>
          <td align="center"><input name="submit" type="submit" value="添加" class="button_red"/></td>
        </tr>
</form>	
      </table>
<%end if%>


<%	
	set row_b=server.createobject("adodb.recordset") 
	    if session("Etype_id")<>"" and isnumeric(session("Etype_id")) then
		   row_b_sql="select * from "&db_table&"_type where type_id="&session("Etype_id")&" order by order_id asc"
		else
		   row_b_sql="select * from "&db_table&"_type where type_id=0 order by order_id asc"
		end if
		
	    row_b.open row_b_sql,conn,1,3
	 if row_b.eof then
		response.Write "<table width=100% border=0 align=center cellpadding=3 cellspacing=1 class=forMy><tr><td class=forumRow align=center>暂无"&db_title&"分类!</td></tr></table>"
	 else
%>

<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1" class="forum2">


<tr class="forumRaw">
<td align="center">编号</td>
<td width="350" align="left"> &nbsp;分类名称</td>
<td colspan="2" align="center" width="85">排序</td>
<td width="50" align="center">操作</td>
</tr>


<%
    do while not row_b.eof
	'#### 重写排序 ####
	r_b=r_b+1
	row_b("order_id")=r_b
	row_b.update()
%>
        <form name="article_type<%=row_b("id")%>" method="post" action="?edit=update&id=<%=row_b("id")%>">
         
<%if cstr(request("id"))=cstr(row_b("id")) then%>
<tr class="forumRow" onDblClick="submit();" title="双击可完成编辑!">
<td width="50" align="center"><%=row_b("id")%><a href="article_manage.asp?typeB_id=<%=row_b("id")%>">
              <input name="id" type="hidden" id="id" value="<%=row_b("id")%>" />
            </a></td>
           
            <td align="left"><input name="title" type="text" class="input2" id="title" value="<%=row_b("title")%>" /></td>
            <td width="35" align="center"><input style="background-color:#F7F7EE; text-align:center" name="order_id" type="text" value="<%=row_b("order_id")%>" size="4"></td>
            <td width="45" align="center">
<a href="?order=up&o_id=<%=row_b("id")%>"><%=up_img%></a>

<a href="?order=down&o_id=<%=row_b("id")%>"><%=down_img%></a></td>
            <td align="center"><input name="update2" type="submit" class="input_but" value="修改" id="input_but" /></td>
</tr>
<%else%>
<tr class="forumRow" onDblClick="getEdit(<%=row_b("id")%>);" title="双击可编辑该分类!">
<td width="50" align="center"><%=row_b("id")%><a href="article_manage.asp?typeB_id=<%=row_b("id")%>">
              <input name="id" type="hidden" id="id" value="<%=row_b("id")%>" />
            </a></td>
           
            <td align="left">&nbsp;<%=row_b("title")%></td>
		    <td width="35" align="center" class="forumRow2 red" style="font-weight:bold"><%=row_b("order_id")%></td>
            <td width="38" align="center">
<a href="?order=up&o_id=<%=row_b("id")%>"><%=up_img%></a>

<a href="?order=down&o_id=<%=row_b("id")%>"><%=down_img%></a>			</td>

<td align="center">
<input name="delete" type="button" class="input_but" onClick="javascript:if(confirm('确定要删除此导航栏吗？删除后不可恢复!')){window.location.href='?type_id_del=<%=row_b("id")%>';}else{history.go(0);}" value="删除" <%if row_b("mob")="page" then response.Write(" disabled")%>/>
</td></tr>
<%end if%> 
</form>
<%
	row_b.movenext
	loop
	end if
	row_b.close
set row_b=nothing
%>
      </table>


</td></TR></TABLE>
</body>
</html>