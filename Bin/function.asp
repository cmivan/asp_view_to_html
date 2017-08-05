<%
'/// 读取列表 ///
function cm_list(cm_type_id,cm_num,cm_class)
 dim cm_class_str,cm_num_str
  if cm_class<>"" and isnumeric(cm_class) then cm_class_str=" class="&cm_class&" and"
  if cm_num<>"" and isnumeric(cm_num) then cm_num_str=" top "&cm_num&""
 set cm_list_rs=conn.execute("select"&cm_num_str&" * from article where"&cm_class_str&" type_ids like '%"&cm_type_id&"%' order by order_id asc,id desc")
     do while not cm_list_rs.eof
%>
<div><a hre=""><%=cm_list_rs("title")%></a></div>
<%
     cm_list_rs.movenext
     loop
 set cm_list_rs=nothing
end function


'/// 读取列表 ///
function cm_conn(cm_type_id,cm_num,cm_class)
 dim cm_class_str,cm_num_str
  if cm_class<>"" and isnumeric(cm_class) then cm_class_str=" class="&cm_class&" and"
  if cm_num<>"" and isnumeric(cm_num) then cm_num_str=" top "&cm_num&""
  set cm_conn=conn.execute("select"&cm_num_str&" * from article where"&cm_class_str&" type_ids like '%"&cm_type_id&"%' order by order_id asc,id desc")
end function
%>