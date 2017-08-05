<!--#include file="km_mod_config.asp"-->
<!--#include file = "../bin/sys_replace.asp" -->

<%
'///////////  处理提交数据部分 ////////// 
   edit_id   =request("id")
if edit_id="" or isnumeric(edit_id)=false then
   editStr="添加"
   else
   editStr="修改"
end if
   
if request.Form("edit")="ok" then
'///////////  写入数据部分 //////////
   set rs=server.createobject("adodb.recordset") 
    if edit_id="" or isnumeric(edit_id)=false then
       exec="select * from "&db_table&" order by id desc"                       '判断，添加数据
	   rs.open exec,conn,1,3
       rs.addnew
	else
	   exec="select * from "&db_table&" where id="&edit_id&" order by id desc"  '判断，修改数据
       rs.open exec,conn,1,3
	end if

	if edit_id<>"" and isnumeric(edit_id) and rs.eof then
	   response.Write("写入数据失败!")
	else

'——————接收数据
	rs("title")   =request.Form("title")
	rs("tip")     =request.Form("tip")
	rs("mob")     =request.Form("mob")
	rs("type_id") =request.Form("type_id")

'——————保存文件
    call creatfile("..\template\"&rs("filename"),request.Form("mob"))


	end if
	rs.update

'/////// 处理，读取模板里的模块 //////////
%>
<!--#include file="km_html_match.asp"-->
<%
	  '//替换配置信息
      html_content=sys_replace_config(html_content)

'response.Write("<script>alert('"&editStr&"操作成功!');window.location.href='km_mod.asp?typd_id="&typd_id&"';</'script>")

	rs.close
set rs=nothing

end if


'#################  读取数据部分 #################

   id=request.QueryString("id") 
if id<>"" and isnumeric(id) then
  '@状态:编辑
   edit_stat="edit"
   set rs=server.createobject("adodb.recordset") 
       exec="select * from "&db_table&" where id="&id
       rs.open exec,conn,1,1 
	   if not rs.eof then
	      title  =rs("title")
		  tip    =rs("tip")
	      mob    =rs("mob")
	      type_id =rs("type_id")
	   end if
	   rs.close
   set rs=nothing
   
else
  '@状态:添加
   edit_stat="add"
end if

%>

<body>
<TABLE width="500" border="0" align="center" cellpadding="0" cellspacing="10" class="forum1"
 style="width:<%=class_width%>;">
<TR class="forumin"><td>
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="forum2">
<form name="form1" method="post" action="">
<tr class="forumRow">
<td height="22" colspan="2">
&nbsp;&nbsp;+ <%=editStr%>模块</td>
</tr>
<tr class="forumRow">
        <td width="80" align="right">名称:</td>
        <td align="left">
		<input name="title" type="text" id="title" value="<%=title%>">
		<input name="tip" type="text" id="tip" value="<%=tip%>">
<select name="type_id">
<%call getTypeTree(0,0,type_id)%>
</select>		</td>
      </tr>
<tr class="forumRow">
        <td colspan="2" align="center" valign="top">
          <textarea name="mob" style="width:100%; height:320px;"><%=mob%></textarea>
	</td>
        </tr>
<tr class="forumRow">
        <td colspan="2" align="center">
		        <input name="id" type="hidden" value="<%=id%>" />
				<input name="edit" type="hidden" value="ok" />		
            <input type="submit" name="Submit" value="提交" class="button_red" />
            <input name="button" type="button" onClick="history.go(-1)"  value="取消" />       </td>
        </tr>
</form>
    </table>
<br>

<table width="100%" border="0" cellspacing="1" cellpadding="0">
  
<tr class="forumRow">
<td valign="top"><table width="100%" border="0" cellspacing="1" cellpadding="2" class="forum2">
<tr class="forumRow">
<td colspan="3" align="left">&nbsp;&nbsp;+ 文章详细内容主要参数</td>
</tr>

<tr class="forumRow">
<td align="left">&nbsp;</td>
<td align="left">&nbsp;</td>
<td align="left">&nbsp;</td>
</tr>
              
    
<%
set rs_type=conn.execute("select * from sys_db_fields")
    do while not rs_type.eof
%>          
<tr class="forumRow">
<td width="100" align="right"><%=rs_type("db_title")%>：</td>
<td><input type="text" value="{?:<%=rs_type("db_field")%>}"></td>
<td><input type="text" value="{?cm-type:<%=rs_type("db_field")%>}"></td>
</tr>
<%
    rs_type.movenext
	loop
set rs_type=nothing
%>          

</table>

</td>
            <td valign="top"><table width="100%" border="0" cellspacing="1" cellpadding="2" class="forum2">
            <tr class="forumRow">
                  <td colspan="2" align="left">&nbsp;&nbsp;+ 前台模版主要参数</td>
                </tr>
                <tr class="forumRow">
                  <td width="100" align="right">列表：</td>
                  <td><textarea name="textfield45" cols="50" rows="3">{?cm-list:article|tj|0|15|1}
{?cm-list:表|操作类型|分类ID|显示数目|模块样式ID"}</textarea></td>
                </tr>

<tr class="forumRow">
<td align="right">独立模块：</td><td>
<textarea name="textfield442" cols="50" rows="3">
<a id="mod:left_foot"/>
<a id="mod:标签"/>
</textarea>
</td></tr></table>
              
              
<table width="100%" border="0" cellspacing="1" cellpadding="2" class="forum2">
              <tr class="forumRow">
                <td colspan="2" align="left">&nbsp;&nbsp;+ 系统配置参数 </td>
              </tr>
              <tr class="forumRow">
                <td width="100" align="right">站点名称：</td>
                <td><input type="text" value="{?:site_name}"></td>
              </tr>
              <tr class="forumRow">
                <td width="100" align="right">本站网址：</td>
                <td><input name="text" type="text" value="{?:site_url}"></td>
              </tr>
              <tr class="forumRow">
                <td align="right">站长信箱：</td>
                <td><input name="text2" type="text" value="{?:SiteMail}"></td>
              </tr>
              <tr class="forumRow">
                <td align="right">文件分割线：</td>
                <td><input name="text8" type="text" value="{?:html_line}"></td>
              </tr>
              <tr class="forumRow">
                <td align="right">文件后缀：</td>
                <td><input name="text9" type="text" value="{?:html_fix}"></td>
              </tr>
              <tr class="forumRow">
                <td align="right">文件存放目录：</td>
                <td><input name="text10" type="text" value="{?:html_path}"></td>
              </tr>
              <tr class="forumRow">
                <td align="right">页面打开方式：</td>
                <td><input name="text11" type="text" value="{?:html_open}"></td>
              </tr>
              
</table>  
              
              
              </td>
          </tr>
      </table>
	  
    </td>
</TR></TABLE>

