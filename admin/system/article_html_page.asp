<!--#include file="article_config.asp"-->
<!--#include file = "../bin/sys_replace.asp" -->
<body>
<div class="mainWidth">
<!--#include file="article_nav.asp"-->

<div class="class_nav">
<div class="type_box">
<%
on error resume next
Server.ScriptTimeout=99999
page_nav =H_GetNav()       '读取导航栏

set rs=server.CreateObject("Adodb.recordset")   
    rs_sql="select * from "&db_table&" where class_id<>0 order by order_id asc,id desc"
    rs.open rs_sql,conn,1,3
    do while not rs.eof
	   id     =rs("id")
	   title  =rs("title")
	   href   =rs("href")
	   type_ids=rs("type_ids")
	   class_id=rs("class_id")
	   
	   if cstr(href)="" then
	      href=htm_href(type_ids,title,class_id)  '//静态目录
		  rs("href")=href
		  rs.update
	   end if

	   list_id=get_list_id(id)
	   page_id=get_page_id(id)

	   '#页面模板
	   if class_id=0 then
	      'html_content=get_page_mob(list_id)
		  html_content=get_template(list_id)
		  moban_id=list_id
	   else
	      'html_content=get_page_mob(page_id)
		  html_content=get_template(page_id)
	      moban_id=page_id
	   end if

	   
	  '//替换匹配信息
      html_content=sys_replace_match(html_content,moban_id)
	  '//替换页面内容
	  html_content=sys_replace_page(html_content,rs)
	  '//替换配置信息
      html_content=sys_replace_config(html_content)
%>
<div class=typeitem><div class=item>
<div class=left><%=rs("id")%>、<%=rs("title")%></div>
<div class=right><%call creatfile(rootpath&href,html_content)%></div>
</div></div>
<%
    rs.movenext
    loop
    rs.close
set rs=nothing
%>
</div>
</div>
</div>
</body>