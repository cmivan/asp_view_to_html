<%
if edit_id="" or isnumeric(edit_id)=false then
   editStr="添加"
else
   editStr="修改"
end if

if request.Form("edit")="ok" then
'///////////  写入数据部分 //////////
   set rs=server.createobject("adodb.recordset") 
    if edit_id="" or isnumeric(edit_id)=false then
       exec="select * from "&db_table                       '判断,添加数据
	   rs.open exec,conn,1,3
       rs.addnew
	else
	   exec="select * from "&db_table&" where id="&edit_id  '判断,修改数据
       rs.open exec,conn,1,3
	end if

	if edit_id<>"" and isnumeric(edit_id) and rs.eof then
	   response.Write("写入数据失败!")
	else

'——————接收数据
    title    =request.Form("title")
    type_ids =request.Form("type_ids")
	list_id  =request.Form("list_id")  '//页面id
	page_id  =request.Form("page_id")
'——————数据处理
    if title="" then
	   response.Write("<script>alert('请填写标题!');history.go(-1);</script>")
	   response.End()
	end if
	
	titleEN   =request.Form("titleEN")
	keywords  =request.Form("keywords")
	descriptions=request.Form("descriptions")
	
    content   =request.Form("content")
    big_pic   =request.Form("big_pic")
    small_pic =request.Form("small_pic")
    order_id  =request.Form("order_id")
	
	strong    =request.Form("strong")
	color     =request.Form("color")
	sizes     =request.Form("size")
	toUrl     =request.Form("toUrl")
	note      =request.Form("note")
	add_data  =request.Form("add_data")
    if isdate(add_data)=false then add_data=now()
    '@@@@@审核\热门\最新\推荐
	if type_id="" then type_id=0

	ok  =request.Form("ok")
	hot =request.Form("hot")
	news=request.Form("news")
	tj  =request.Form("tj")
	
	'@@@@@排序
    if order_id="" or isnumeric(order_id)=false then order_id=0
 
'——————分类
dim type_id
    type_id=get_arrid(type_ids)
	
	'@@系统参数
	rs("title")    =title
    rs("type_id")  =type_id
	rs("type_ids") =type_ids
	session("type_id")=type_id    '记录本次操作分类	
	rs("class_id") =class_id      '记录是页面还是栏目
	rs("href")     = htm_href(type_ids,title,class_id)  '//静态目录
	rs("list_id")  = list_id
	rs("page_id")  = page_id

	

	'@@其他参数
	rs("titleEN")  =titleEN
	rs("keywords") =keywords
	rs("descriptions")  =descriptions

	rs("content")  =content
	rs("big_pic")  =big_pic
	rs("small_pic")=small_pic
	rs("order_id") =order_id
	
	rs("ok")  =getBool(ok)
	rs("hot") =getBool(hot)
	rs("news")=getBool(news)
	rs("tj")  =getBool(tj)

	rs("strong")=getBool(strong)
	rs("color") =color
	rs("size")  =sizes
	rs("toUrl") =toUrl
	rs("note")  =note
	rs("add_data")=add_data

	rs.update
	rs.close
set rs=nothing

    '生成静态文件
	if err=0 then
	   response.Write("<script>alert('"&editStr&"成功!');window.location.href='article_manage.asp?type_ids="&type_ids&"';</script>")
	end if
   end if

end if
%>





<%

'@获取栏目id
edit_typeid=request("type_ids")
if edit_typeid<>"" then session("type_id")=edit_typeid

'@@@@转换参数class_id 只能是0或1
class_id=getBool(class_id)
'//判断是页面还是栏目
if class_id=1 then
   '在页面状态 article_id 为相应的栏目,edit_id 为相应的文章id
   '通过栏目id获取页面设置
   a_id=get_set_id(article_id,1)
   '通过页面id获取页面设置id
   if a_id="" or isnumeric(a_id)=false then a_id=get_set_id(edit_id,1)
else
   '直接获取栏目信息
   a_id=get_set_id(edit_id,0)
end if


'@@@@读取页面设置
if edit_id<>"" and isnumeric(edit_id) then
set rs_n=conn.execute("select top 1 * from "&db_table&" where id="&edit_id&" and class_id="&class_id)
    if not rs_n.eof then
       title   =rs_n("title")
       titleEN =rs_n("titleEN")
       type_id =rs_n("type_id")
       type_ids=rs_n("type_ids")
       session("type_id")=type_ids
	   'page_id =rs_n("page_id")
	   list_id = get_list_id(edit_id)
	   page_id = get_page_id(edit_id)

    end if
set rs_n=nothing
end if

'@@@@读取栏目或页面编辑框样式
if a_id<>"" and isnumeric(a_id) then
set rs_a=conn.execute("select * from article_set where article_id="&a_id&" and class_id="&class_id&" order by order_id asc")
    do while not rs_a.eof
       '获取字段,标题
       filed      =get_field(rs_a("filed_id"),"db_field")
	   filed_title=get_field(rs_a("filed_id"),"db_title")
       filed_style=get_field(rs_a("filed_id"),"db_style")
	   filed_value=get_article(db_table,edit_id,filed)

	   
       '替换出编辑框
	   
	   filed_styles=""
	   if filed_style=1 then
	      '//多选框演示
          filed_mob="{view}"  'filed_value=1 表示被选中
		  if cint(filed_value)=1 then filed_styles=" checked=checked"
	   else
	      '//普通样式
          filed_mob=get_db_type(rs_a("filed_mob_id"),"db_form")
	   end if

	   view=get_db_type(rs_a("filed_mob_id"),"db_input")
       filed_mob=replace(filed_mob,"{view}",view)
       filed_mob=replace(filed_mob,"{title}",filed_title)
       filed_mob=replace(filed_mob,"{filed}",filed)
       filed_mob=replace(filed_mob,"{wc}{name}",filed)
       filed_mob=replace(filed_mob,"{value}",filed_value)
	   filed_mob=replace(filed_mob,"{style}",filed_styles)
	   
	   '返回编辑框  
	   if filed_style=1 then
	      '//多选框演示
          filed_mob_diy1=filed_mob_diy1&filed_mob
	   else
	      '//普通样式
          filed_mob_diy0=filed_mob_diy0&filed_mob
	   end if
	   
       rs_a.movenext
    loop
set rs_a=nothing
end if

'@@@@处理数据
if filed_mob_diy1<>"" then
   filed_mob=replace(get_db_type("","db_form"),"{title}：","")
   filed_mob_diy1=replace(filed_mob,"{view}",filed_mob_diy1)
end if

'@@@@输出显示
filed_mob_all=filed_mob_sys&filed_mob_diy0
filed_mob_all=filed_mob_all&filed_mob_diy1
%>









<%
'####### 使用递归，生成无限级菜单 ########
dim at_num,dict,at_type_id

    at_type_id=session("type_id")
	if len(at_type_id)<=3 then at_type_id="|0|"
	at_type_id="0"&at_type_id

set dict=Server.CreateObject("Scripting.Dictionary")
    dict.item("typeid0")="0|"    '根类
sub getTypeTree(id,tree)
    on error resume next '容错模式
    dim rsc,selected,rs_sql
	if id="" or isnumeric(id)=false then id=0
	 set rsc=server.CreateObject("Adodb.recordset")   
	     rs_sql="select * from "&db_table&" where type_id="&id&" and class_id=0 order by order_id asc,id desc"
	     rsc.open rs_sql,conn,1,1
			itemNum=tree
		    dict.item("item_"&itemNum)=0
		 while not rsc.eof
			tree=tree+1
			dict.item("item_"&itemNum)=dict.item("item_"&itemNum)+1  '用于累计当前分类的数目
			dict.item("typeid"&rsc("id"))=dict.item("typeid"&rsc("type_id"))&rsc("id")&"|"
			at_num=""
		   '-------------------------------
		    Dtype_id=dict.item("typeid"&rsc("id"))
			Dtype_ids=split(Dtype_id,"|")
			
		    for rsN=1 to tree
				if rsN<tree then
				   at_num=at_num&"&nbsp;│"
				   else
				   at_num=at_num&"&nbsp;├ "
				end if
			next
 
			selected=""
	        if instr(at_type_id,"|"&rsc("id")&"|")<>0 then
			   selected="selected style='color:#ff0000'"
			end if
			
	        response.Write("<option value='|" & Dtype_id & "' "&selected&">")
			response.Write(at_num&rsc("title")&"</option>")
			
			call getTypeTree(rsc("id"),tree)
		   '-------------------------------
		  tree=tree-1
          rsc.movenext
         wend
	     rsc.close
     set rsc=nothing
end sub
%>

<body>
<div class="mainWidth">
<TABLE border="0" align="center" cellpadding="0" cellspacing="10" class="forum1"
 style="width:<%=class_width%>;">
<TR class="forumin"><td>

<table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="forum2">
<tr class="forumRaw"><td colspan="2" align="center" class="mainTitle"><%=class_title&editStr%></td></tr>
<form name="article_update" method="post" action="">

<!--分类-->
<tr class="forumRow"><td align="right" width="88">分类：</td>
<td class="forumRow">
<select name="type_ids" onChange="window.location.href1='?type_id='+this.value;">
<option value="|0|" <%if at_type_id="|0|" then%>selected style='color:#ff0000'<%end if%>>一级栏目</option>
<%call getTypeTree(0,0)%>
</select>
</td></tr>
<!--标题-->
<tr class="forumRow"><td align="right">标题：</td>
<td class="forumRow"><input name="title" type="text" value="<%=title%>" class="input_sor" />
<input type="hidden" name="type_id" value="<%=session("type_id")%>" /></td></tr>

<%=filed_mob_all%>


<%if class_id=0 then%>
<!--频道模板id-->
<tr class="forumRow"><td align="right">频道：</td>
<td class="forumRow">
<select name="list_id" >
<%call get_page_mobs(list_id)%>
</select> 
用于分类页面
</td></tr>
<%end if%>

<!--页面模板id-->
<tr class="forumRow"><td align="right">页面：</td>
<td class="forumRow">
<select name="page_id" >
<%call get_page_mobs(page_id)%>
</select> 
用于单页面或栏目下的详细页
</td></tr>



<!--保存-->
<tr class="forumRaw"><td width="88" align="right" valign="top">&nbsp;</td><td>
<input name="submit" type="submit" value="保存<%=editStr%>" class="button_red" />
<input name="edit" type="hidden" value="ok" />
</td></tr>

</form></table>
</td></TR></TABLE>
</div>
</body>