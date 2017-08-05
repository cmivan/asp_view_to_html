<!--#include file="article_config.asp"-->
<!--#include file = "../bin/sys_replace.asp" -->
<body>
<TABLE border="0" align="center" cellpadding="0" cellspacing="10" class="forum1"
 style="width:245px;">
<TR class="forumin"><td>
<table border="0" align="center" cellpadding="2" cellspacing="1" class="forum2">
<tr class="forumRaw"><td colspan="2" align="center">生成列表</td></tr>
<form name="postart" method="post" onSubmit="return checkForm()">
<tr class="forumRow"><td>&nbsp;选择分类
<select name="type_id">
<option value="all">- 全部分类 -</option>
</select>
<input type="submit" name="Submit" value="执行生成">
<input type="hidden" name="html_form" value="class">
</td></tr>
</form>
</table></td></TR></TABLE>


<div style="padding:30px; line-height:18px;">
<%


    html_form  =request.Form("html_form")
    type_id    =request.Form("type_id")

If html_form<>"" then
'=================================================================
set rstype = server.CreateObject ("adodb.recordset") 
 if type_id<>"" and isnumeric(type_id) then
	typesql = "select * from "&db_table&" where class_id=0 and id="&type_id&" order by order_id desc"
 else
	typesql = "select * from "&db_table&" where class_id=0 order by order_id desc"
 end if
 
    rstype.open typesql,conn,1,1

	do while not rstype.eof

	paging_href=rstype("href")    '该项是用于分类名称的，较为重要
	list_id=get_list_id(rstype("id"))
	
	echo("<b>"&rstype("id")&"、"&rstype("title")&"</b>")

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
set rs = server.CreateObject ("adodb.recordset")
	rssql = "select * from "&db_table&" where type_ids like '%|"&rstype("id")&"|%' order by order_id desc"
	rs.Open rssql,conn,1,1
	
	
	if not rs.eof then
	   rs.PageSize = sys_pagsize
       pagesum     = rs.pagecount
	   pages=true  '//返回是否需要分页
	else
	   echo("No Record!")
	   pages=false '//返回是否需要分页
    end if


     '先读取列表模板，再执行循环 节省资源
	  'MobanID=H_GetMobanID(rstype("id"),"Li")
	  moban_id=list_id
	  'lh_html_content =H_GetMoban(moban_id)
	  lh_html_content=get_template(list_id)
	  
	  lh_html_content =replace(lh_html_content,"{?cm-type:title}",rstype("title"))
	  html_content=lh_html_content
	  
	  '//替换匹配信息
      html_content=sys_replace_match(html_content,moban_id)
	  '//替换配置信息
      html_content=sys_replace_config(html_content)
	  
	  lh_html_content=html_content


    '产生分页
     if pages and pagesum>0 then
	    'ListModStr=GetMod("type|"&rstype("id"))  '读取模块样式
		ListModStr=GetMod(1)  '读取模块样式
  	 for page=1 to pagesum
	  	 rs.AbsolutePage=page
        '初始化列表、分页数据
		 temp_html_content=lh_html_content
         listcontent=""
	     pages=""
		 
	     for j=1 to rs.PageSize 
	     if rs.eof then exit for
		    TempMod= ListModStr   '模块样式
            href = rs("href")

		    if href<>"" then
               href  = site_url&href
			   html_content=replace(TempMod,"{?:href}",href)
		    end if
			
			'替换系统信息
			html_content=sys_replace_page(html_content,rs)
			
		    listcontent=listcontent&html_content
		    rs.movenext
	     next 


      '----------------------------------------------------------
	  pages=pages&"<form id='pageform' name='pageform'>"
      if page<2 then      
         pages=pages& "首页 上一页&nbsp;"
      else
         pages=pages& "<a href='"&site_url&H_Paging(paging_href,1)&"'>首页</a>&nbsp;"
         pages=pages& "<a href='"&site_url&H_Paging(paging_href,page-1)&"'>上一页</a>&nbsp;"
      end if
   '----------------------------------------------------------
	  if rs.pagecount-page<1 then
        pages=pages& "下一页 尾页"
      else
        pages=pages& "<a href='"&site_url&H_Paging(paging_href,page+1)&"'>"
        pages=pages& "下一页</a> <a href='"&site_url&H_Paging(paging_href,pagesum)&"'>尾页</a>"
      end if
   '----------------------------------------------------------
       pages=pages& "&nbsp;页次：<strong><font color=red>"&page&"</font>/"&rs.pagecount&"</strong>页 "
       pages=pages& "&nbsp;共<b><font color='#FF0000'>"&rs.recordcount&"</font></b>条记录 <b>"&rs.pagesize
       pages=pages& "</b>条记录/页 转到：<input type='text' name='page' size=4 maxlength=10  value="&page&">"
       pages=pages& "<input class=input type='button'  value=' Goto '  name='cndok' OnClick='goto()'></span>"     
       pages=pages& "</form>"	
      '----------------------------------------------------------

      '列表页的
	  html_content = temp_html_content
      html_content = replace(html_content,"{?:list}",listcontent)
      html_content = replace(html_content,"{?:paging}",pages)
	  
	  list_page = "../../"&H_Paging(paging_href,page)
  	  call creatfile(list_page,html_content)
	
      next 
	  
else
 '======== 当页面数小于1页时==========
      '列表页的
      html_content = replace(html_content,"{?:list}","暂无相关内容...")
      html_content = replace(html_content,"{?:paging}","")
	 
	  list_page = "../../"&H_Paging(paging_href,1)
  	  call creatfile(list_page,html_content)
	  
	 end if
	    rs.close
	set rs=nothing

    rstype.movenext
	loop
    rstype.close
set rstype = nothing
response.write"<SCRIPT language=JavaScript>alert('ok -> html!');</SCRIPT>"
response.end

End if
%>

</div>
</body>

</html>
