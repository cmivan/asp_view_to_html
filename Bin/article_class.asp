<%
'--操作数据库类cmd
Class cmd
 Public  cm_rs       '--数据集操作对象
 Public  cm_i
 Public  cm_sql       '--是否显示审核
 Public  db_table    '--是否显示审核
 Private rs_query    '--数据库连接字符串

 Private Sub Class_Initialize  '--类初始化
  set cm_rs = Server.CreateObject("Adodb.Recordset")    '--
      rs_query = ""
      cm_i     =1
	  cm_sql    =0
 End Sub

'---打开数据库记录集 
 Public Sub cm_open(type_ids,num,paging,cm_sql)
   '########## 定义排序字符 #############
    on error resume next
    dim rs,selected,rs_sql,type_id,on_type_id,type_id_num,keyword
	
    type_ids=noCode(type_ids)
    type_ids=server.HTMLEncode(type_ids)
    type_id =split(type_ids,"|")
    type_id_num=ubound(type_id)

    if type_ids="" or isarray(type_id)=false or type_id_num<3 or left(type_ids,3)<>"|0|" then type_ids=""

	keyword =request("keyword")
	
	'//是否显示审核数据
	order_ok=""
	if cm_sql=0 or cm_sql=1 then order_ok=" ok="&cm_sql&" and"

	order_sql =" and"&order_ok&" class_id=1 order by order_id asc,id desc"
	order_sql2=order_ok&" class_id=1 order by order_id asc,id desc"
	
	   
	if paging then topnum=" *":else:topnum=" top "&num&" *" end if

	'########## 处理接收到搜索字符的情况 #############
	if keyword<>"" then
	   keyword_sql =" and (title like '%"&request("keyword")&"%')"
	   keyword_sql2=" (title like '%"&request("keyword")&"%') and"
	end if
	
	if type_ids<>"" then
	   rs_query="select"&topnum&" from article where (type_ids like '%"&type_ids&"%')"&keyword_sql&order_sql
	else
	   rs_query="select"&topnum&" from article where"&keyword_sql2&order_sql2
	end if

       cm_rs.open rs_query,conn,1,1
'///是否分页 --------------------------
    if not cm_rs.eof and paging then
       cm_rs.pagesize =num          '每页记录条数
	   iCount    =cm_rs.RecordCount '记录总数
	   ipagesize =cm_rs.pagesize
	   maxpage   =cm_rs.pagecount 
	   page      =request("page")

	   if Not IsNumeric(page) or page="" then page=1
	      page=cint(page)
	   if page<1 then page=1
	   if page>maxpage then page=maxpage

	   cm_rs.absolutepage=page
	   if page=maxpage then x=iCount-(maxpage-1)*ipagesize:else:x=ipagesize end if 
	end if
 End Sub

'---数据库集合移动到下一条
 Public Function cm_next()  
  cm_i=cm_i+1
  cm_rs.movenext
 End Function
'---数据库集合总条数
 Public Function cm_count()  
  cCount = cm_rs.recordcount
 End Function
 '---判断数据库记录是否已经到最后一条
 Public Function cm_eof()   
  if cm_rs.eof or cm_i>cm_rs.pagesize then
     cm_eof = true
  else
     cm_eof = false
  end if
 End Function
'---关闭数据库 
 Public Function cm_close()
      cm_rs.close
  set cm_rs = nothing
 End Function

End Class
%>
