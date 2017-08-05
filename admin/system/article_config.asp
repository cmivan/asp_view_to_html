<!--#include file="../bin/header.asp"-->
<%
'//文章表
dim db_table
db_table="article"


'@@删除内容
dim del_id
   del_id=request.QueryString("del_id")
if del_id<>"" and isnumeric(del_id) then
   dim del_ids
   del_ids="|"&del_id&"|"
   '//删除当前页面或栏目
   conn.execute("delete * from "&db_table&" where id="&del_id)
   '//删除相关的记录
   conn.execute("delete * from "&db_table&" where type_ids like '%"&del_ids&"%'")
   '//删除相关的栏目设置
   conn.execute("delete * from article_set where article_id="&del_id)
end if
%>