<!--#include file="article_config.asp"-->
<%
'---// 容错模式 //---
'on error resume next
dim rs,selected,rs_sql,type_id,type_ids,on_type_id,type_id_num
    type_ids=request.QueryString("type_ids")
    type_ids=noCode(type_ids)
    type_ids=server.HTMLEncode(type_ids)
    type_id =split(type_ids,"|")
    type_id_num=ubound(type_id)
 if type_ids="" or isarray(type_id)=false or type_id_num<2 or left(type_ids,3)<>"|0|" then
    response.Write("err!")
    response.End()
 end if
%>

<body>
<div class="mainWidth">
<!--#include file="article_nav.asp"-->

<div class="class_nav">
<%
dim tempType_id
    tempType_id="|0|"
for i=2 to type_id_num
%>
<div class="type_nav">
<%
if type_id(i)<>"" then
    tempType_id=tempType_id&type_id(i)&"|"
set rs=server.CreateObject("Adodb.recordset")   
    rs_sql="select * from "&db_table&" where type_ids='"&tempType_id&"' and class_id=0 order by order_id asc,id desc"
    rs.open rs_sql,conn,1,1
    while not rs.eof
       onStyle=""
    if instr(type_ids,"|"&rs("id")&"|")<>0 then onStyle=" class='on'"
%>
<a href='?type_ids=<%=tempType_id&rs("id")%>|'<%=onStyle%>><%=rs("title")%></a>
<%
    rs.movenext
    wend
    rs.close
set rs=nothing
end if
%>
</div>
<%next%>




<div class="type_box">
<%
'rs.cm_Open "分类",数目,是否分页
dim page,maxpage,iCount
set rs=new getList
	rs.cm_open type_ids,10,true,2
 if not rs.cm_eof then
 do while not rs.cm_eof
%>
<div class=typeitem><div class=item>
<div class=left>
<%=rs.cm_rs("id")%>、<a href="article_page.asp<%=reUrl("edit_id="&rs.cm_rs("id"))%>"><%=rs.cm_rs("title")%></a>
</div>
<div class=right>
<a href='javascript:void(0);' link="<%=reUrl("del_id="&rs.cm_rs("id"))%>" class='del_item' id='<%=rs.cm_rs("id")%>'>删除</a><%=T_Line%><a href="article_page.asp<%=reUrl("edit_id="&rs.cm_rs("id"))%>">修改</a>
</div>
</div></div>
<%
 rs.cm_next:loop
 else
   response.Write("<div class=typeitem><div class=item style=text-align:center>暂未找到相关信息！</div></div>")
 end if
 rs.cm_close
%>
</div>


<!--分页-->
<div class="typeitem">
<div class="item">
<div class="left">
&nbsp;&nbsp;
<%if page<=1 then%> 首页 上一页<%else%>   
<A class="liti" href="<%=reUrl("page=1")%>">首页</A>
<A class="liti" href="<%=reUrl("page="&(Page-1))%>">上一页</A>
<%end if%>
<%if page>=maxpage then%> 下一页 尾页<%else%>   
<A class="liti" href="<%=reUrl("page="&(Page+1))%>">下一页</A>
<A class="liti" href="<%=reUrl("page="&maxpage)%>">尾页</A>    
<%end if%>
&nbsp;页次：<%=page%>/<%=maxpage%>页  共 <%=iCount%> 条记录
</div></div></div>


</div>
</div>
</body>