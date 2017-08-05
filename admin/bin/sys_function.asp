<%
'@@返回文字样式
  function echo(tip)
	  response.Write(tip&"<br>")
	  response.Flush()
  end function


'@@返回静态分类
  function htm_type(h_ty_id,h_cl_id)
      dim ids
	  if h_cl_id=1 then
	  '//页面
	     ids=h_ty_id&"TYPE"
	     ids=replace(ids,"|0|","")
	     ids=replace(ids,"|"&"TYPE","")
	     ids=replace(ids,"TYPE","")
	     ids=replace(ids,"|","_")
		 if ids<>"" then
		    ids=html_path&"/"&ids&"/"
		 end if
	  end if
	  htm_type=ids
  end function


'@@返回静态地址
  function htm_href(type_ids,title,cl_id)
      dim h_type,htmlname
	  '//返回分类目录
	  h_type=htm_type(type_ids,cl_id)
	  '//生成文件名称
	  h_type=h_type&pingyin(title)&html_fix
	  htm_href=h_type
  end function


'@@用于清空注射标签
  function noCode(str)
  	  if str<>"" then
         str=replace(trim(str),"'","")
	  end if
      noCode=str
  end function

'@@用于返回热门最新推荐审核等
  function getBool(num)
  	  if cint(num)=1 then
	     getBool =1
	  else
	     getBool =0
	  end if
  end function

'@@用于返回设置
  function get_db_types(id)
     set g_db_rs=conn.execute("select * from sys_db_type order by order_id asc")
	     do while not g_db_rs.eof
		    db_style=""
			if id=g_db_rs("id") then db_style=" selected='selected'"
			response.Write("<option value='"&g_db_rs("id")&"' "&db_style&">")
			response.Write(g_db_rs("db_title")&"</option>")
         g_db_rs.movenext
         loop
     set g_db_rs=nothing
  end function


'@@用于返回页面模板内容
'  function get_page_mob(id)
'     if id<>"" and isnumeric(id) then
'     set g_db_rs=conn.execute("select * from km_moban_item where Id="&id&" order by Id asc")
'	     if not g_db_rs.eof then get_page_mob=g_db_rs("mob")
'     set g_db_rs=nothing
'	 end if
'  end function


'@@用于返回页面模板
  function get_page_mobs(id)
     set g_db_rs=conn.execute("select A.* from km_moban_item A left join km_moban_item_type B on A.type_id=B.id where B.mob='page' order by A.Id asc")
	     do while not g_db_rs.eof
		    db_style=""
			if cstr(id)=cstr(g_db_rs("id")) then db_style=" selected='selected'"
			response.Write("<option value='"&g_db_rs("id")&"' "&db_style&">")
			response.Write(g_db_rs("title")&"</option>")
         g_db_rs.movenext
         loop
     set g_db_rs=nothing
  end function
  
  
'@@返回当前页面模板id的信息
'@@若当前返回为空，则递归返回上一级的
  function get_page_id(g_id)
     dim ga_id,gt_id
     get_page_id=""
     if g_id<>"" and isnumeric(g_id) then
	 '获取该类或内容的上一级
		ga_id=get_article(db_table,g_id,"page_id")
	    '继续调用函数
		if ga_id=0 or ga_id="" or isnumeric(ga_id)=false then
		   gt_id=get_article(db_table,g_id,"type_id")
		   if gt_id<>"" and gt_id<>0 and isnumeric(gt_id) then ga_id=get_page_id(gt_id)
		end if
	 end if
	 get_page_id=ga_id
  end function
  

'@@返回当前分类模板id的信息
'@@若当前返回为空，则递归返回上一级的
  function get_list_id(g_id)
     dim gl_id,gt_id
     get_list_id=""
     if g_id<>"" and isnumeric(g_id) then
	 '获取该类或内容的上一级
		gl_id=get_article(db_table,g_id,"list_id")
	    '继续调用函数
		if gl_id=0 or gl_id="" or isnumeric(gl_id)=false then
		   gt_id=get_article(db_table,g_id,"type_id")
		   if gt_id<>"" and gt_id<>0 and isnumeric(gt_id) then gl_id=get_list_id(gt_id)
		end if
	 end if
	 get_list_id=gl_id
  end function
  

'@@返回当前id的信息 相应的栏目设置
'@@若当前返回为空，则递归返回上一级的
  function get_set_id(id,tid)
     dim ga_id,gs_id
     get_set_id=""
	 if tid<>0 and tid<>1 then tid=0
     if id<>"" and isnumeric(id) then
	 '获取当前的设置
	 set g_s_rs=conn.execute("select top 1 id from article_set where article_id="&id&" and class_id="&tid)
	     if not g_s_rs.eof then
		    gs_id=id
		 else
		    '获取该类或内容的上一级
			ga_id=get_article(db_table,id,"type_id")
			'继续调用函数
			if ga_id<>0 then
			   gs_id=get_set_id(ga_id,tid)
			end if
		 end if
	 set g_s_rs=nothing
	 end if
	 get_set_id=gs_id
  end function
  

'@@@ 获取文章信息
function get_article(db_table,id,filed)
   if id<>"" and isnumeric(id) and filed<>"" then
   set ga_rs=conn.execute("select top 1 "&filed&" from "&db_table&" where id="&id)
       if not ga_rs.eof then get_article=ga_rs(filed)
   set ga_rs=nothing
   end if
   get_article=""&get_article
end function


'@@@ 获取字段信息
function get_field(id,filed)
   set gf_rs=conn.execute("select "&filed&" from sys_db_fields where id="&id)
       if not gf_rs.eof then get_field=gf_rs(filed)
   set gf_rs=nothing
   get_field=""&get_field
end function

'@@@ 获取字段类型
function get_db_type(id,filed)
   if id="" or isnumeric(id)=false then
      gdb_sql="select top 1 "&filed&" from sys_db_type"
   else
      gdb_sql="select "&filed&" from sys_db_type where id="&id
   end if
   set gdb_rs=conn.execute(gdb_sql)
       if not gdb_rs.eof then get_db_type=gdb_rs(filed)
   set gdb_rs=nothing
   get_db_type=""&get_db_type
end function

'@@@ 从数组分类中获取分类id
function get_arrid(type_ids)
 thisType_id=0
 if type_ids<>"" then
    tempType_id=type_ids
    tempType_id=split(tempType_id,"|")
    if ubound(tempType_id)>=2 then 
       thisType_id=tempType_id(ubound(tempType_id)-1)
       if thisType_id="" or isnumeric(thisType_id)=false then thisType_id=0
    end if
 end if
 get_arrid=thisType_id
end function

'@@@ 获取指定栏目下的文章总数
function get_article_count(db_table,type_ids)
   set gac_rs=conn.execute("select count(id) from "&db_table&" where (type_ids like '%"&type_ids&"%') and class_id=1")
       if not gac_rs.eof then get_article_count=gac_rs(0)
   set gac_rs=nothing
   get_article_count=""&get_article_count
end function




'@@@ 重组url(重要)
function reUrl(url)
	  urls=request.ServerVariables("QUERY_STRING")
	  urls=lcase(urls)
	  urlsTemp="&"&urls&"&"
	  '返回url参数
	  url=lcase(url)
	  urlarr=split(url,"&")
	  for each ulls in urlarr
		  '返回有参数项
		  if ulls<>"" then ularr=split(ulls,"=")
		  if instr(urlsTemp,"&"&ularr(0)&"=")>0 then
			 '存在
			 'oldurl=lcase(ularr(0)&"="&urlencode(request.QueryString(ularr(0))))
			 oldurl=lcase(ularr(0)&"="&request.QueryString(ularr(0)))
			 urls=replace(urls,oldurl,ulls)
		  else
			 '不存在
			 if urls<>"" then urls=urls&"&"&ulls else urls=ulls end if
		  end if
	  next
	  if urls<>"" then urls="?"&urls
	  reUrl=urls
end function
%>