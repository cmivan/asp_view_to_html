<!--#include file="fun/funlogic.asp"-->
<!--#include file="fun/funclass.asp"-->

<%  
'On Error Resume Next
'======================================================================================
dbdir="db/#db.mdb"
'数据库地址
if fileex(dbdir) then
else
   dbdir="../"&dbdir
end if

ON ERROR RESUME NEXT
  set pluck_conn=server.CreateObject("adodb.connection")
      CONNSTR="DRIVER=MICROSOFT ACCESS DRIVER (*.MDB);DBQ="+SERVER.MAPPATH(dbdir)
      pluck_conn.OPEN CONNSTR

if err then
   ERR.CLEAR
   SET pluck_conn = NOTHING
   response.Write "连接数据库出错,请查看出错代码"
   response.End()
end if

'.mdb数据库路径
'======================================================================================
function rsfun(sql,i)
  select case i
    case 1
	  set rsa=server.CreateObject("adodb.recordset")
	      rsa.open sql,pluck_conn,1,1
	  set rsfun=rsa
	  set rsa=nothing
	case 3
	  set rsa=server.CreateObject("adodb.recordset")
	      rsa.open sql,pluck_conn,1,3
	  set rsfun=rsa
	  set rsa=nothing
  end select 
end function


'============
'关闭数据库
'============
sub connclose
    pluck_conn.close
set pluck_conn=nothing
end sub
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
	     rs_sql="select * from article where type_id="&id&" and class_id=0 order by order_id asc,id desc"
	     rsc.open rs_sql,conn,1,1
			itemNum=tree
		    dict.item("item_"&itemNum)=0
		 while not rsc.eof
			tree=tree+1
			dict.item("item_"&itemNum)=dict.item("item_"&itemNum)+1  '用于累计当前分类的数目
			dict.item("typeid"&rsc("id"))=dict.item("typeid"&rsc("type_id"))&rsc("id")&"|"
			at_num=""

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











<style>
body,td,div{
font-size:12px;
font-family:Arial, Helvetica, sans-serif}
.sysinfo{
	background-color:#D9F0F7;
	color: #007CA6;
	width: 100%;
	border-collapse:collapse;
	width:100%;
	margin-top:10px;
	border-color:#FFFFFF;
	background-color:#D9F0F7;
	border: 1px #B9E3F0 solid;
}
td{
padding-left:0px;}

textarea{
width:100%;}
.txt_box{
border:#0099CC 1px solid;
margin:auto;
padding:3px;
width:700px;}


/*进度条的*/
.bar{
	width:700px;
	background-color:#21A6DE;
	border:1px solid #0099CC;
	padding:3px;
	margin:auto;
}
#bar_txt{
width:700px;
color:#FFFFFF;
line-height:12px;
position:absolute;
text-align:center;
font-size:11px;
font-family:Verdana, Arial, Helvetica, sans-serif;
font-weight:bold;
}

#bar_loading{
width:1px;
background-color:#0099CC;
border:1px solid #0099CC;
line-height:12px;
}

.bar_info{
	width:690px;
	border:1px solid #0099CC;
	padding:8px;
	margin:auto;
	margin-top:15px;
	line-height:20px;
	font-family:Verdana, Arial, Helvetica, sans-serif;
	font-size:10PX;}
.bar_info UL{
margin-left:20PX;}
.bar_info UL LI{
margin-left:20PX;
padding-left:20PX;}	

.greed{
color:#00CC00;}
.red{
color:#FF0000;}
</style>


<script type="text/javascript" src="fun/site.js"></script>
<script type="text/javascript">
function loading(num){
document.getElementById("bar_loading").style.width=num*7;
document.getElementById("bar_txt").innerHTML="loading ... " + num +"%";
}
</script>

<%class_width="700px"%>




<TABLE border="0" align="center" cellpadding="0" cellspacing="10" class="forum1"
 style="width:<%=class_width%>;">
<TR><td>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" class="forum2 forumtop">
<tr class="forumRaw"> <td>
&nbsp;&nbsp;+ <a href="?rel=add">添加采集规则</a>    + <a href="?">管理采集规则</a>
</td></tr>
</table>



<%  
rel=funstr(request.QueryString("rel")) 
On Error Resume Next
times=date()
%>
<% if rel="" then  %>
<TABLE style="width:100%" border="0" align="center" cellpadding="1" cellspacing="1" class="forum2">
<tr class="forumRaw">
<td height="30" colspan="4" align="left"> <b>&nbsp;- [规则管理] - 提示：</b> [<a href="?rel=add">添加采集规则</a>]</td>
</tr>
<tr align="center" height="24" class="forumRaw"> 
<td align="left">&nbsp;规则名称</td>
<td align="center">所属分类</td>
<td align="left">&nbsp;采集地址</td>
<td width="135" align="center">操作</td>
</tr>
<%  
set rs=rsfun("select * from getinfo order by id asc",1)
do while not rs.eof
%>
<tr align="center" height="24" class="forumRow"> 
<td align="left">&nbsp;<%= rs("names") %></td>
<td align="center"><font color="#FF0000">
<%
type_id=get_arrid(rs("cid"))
if type_id<>"" and isnumeric(type_id) then
set rsa=conn.execute("select * from article where id="&type_id)
    if not rsa.eof then response.Write rsa("title")
set rsa=nothing
end if

%>


</font>
</td>
<td align="left">&nbsp;<a href="<%= rs("urls") %>" target="_blank"><%= rs("urls") %></a></td>
<td width="135" align="center"><a href="?rel=getces&id=<%= rs("id") %>">测试</a> <a href="?rel=get0&id=<%= rs("id") %>">采集</a> <a href="?rel=info&id=<%= rs("id") %>">修改</a> <a href="?rel=del&id=<%= rs("id") %>">删除</a></td>
</tr>
<%  
rs.movenext
loop
%>
</table>
<% end if %>
<% 
if rel="get0" then 
  id=funstr(request.QueryString("id"))
  set rs1=rsfun("select * from getinfo where id="&id,1)
  if not rs1.eof then
    urls=rs1("urls")

	
'---------------------------------------------
	if instr(urls,"|")<>0 then
	   urlNums=split(urls,"|")
		   x=0
		   redim urlN(1)
       for n=0 to 3
	       if isnumeric(urlNums(n)) then
		      urlN(x)=urlNums(n)
		      x=x+1
		   end if
	   next
	   
	   if ubound(urlN)=1 then
		  if int(urlN(0))>=int(urlN(1)) then 
		     response.Write("参数有误！")
			 response.End()
			 else

for paging=urlN(0) to urlN(1)
    urls=urlNums(0)&paging&urlNums(3)
    str=Gethttppage(urls,rs1("bian"))
	str=replace(str,"'","‘")
	
    urlintervalss=rs1("urlintervals")
	urlintervalsarr=split(urlintervalss,"[Kami]")

	urlintervals=midstr(str,urlintervalsarr(0),urlintervalsarr(1))
'if paging<3 then response.Write(paging&"___<br>"&urlintervals)

	
	url=""
	ruless   =rs1("rules")
	rulesarr=split(ruless,"[Kami]")
	rules=split(urlintervals,rulesarr(0))
	for rulesi=1 to ubound(rules)
	  rules2=split(rules(rulesi),rulesarr(1))
	  
	  if rs1("urlprefixs")<>"" then rules2(0)=rs1("urlprefixs")&rules2(0)
	  if rs1("urlincludes")<>"" then
	     urlincludes=split(rules2(0),rs1("urlincludes"))
		 if ubound(urlincludes)>0 then url=url&",,"&rules2(0)
	  else
	     url=url&",,"&rules2(0)
	  end if
	next
	
	allUrl=allUrl&url
next
		  end if
	   end if
'---------------------------------------------------
    else

    str=Gethttppage(urls,rs1("bian"))
	str=replace(str,"'","‘")
	urlintervalsarr=split(rs1("urlintervals"),"[Kami]")
	urlintervals=midstr(str,urlintervalsarr(0),urlintervalsarr(1))
	
	url=""
	rulesarr=split(rs1("rules"),"[Kami]")
	rules=split(urlintervals,rulesarr(0))
	for rulesi=1 to ubound(rules)
	  rules2=split(rules(rulesi),rulesarr(1))
	  
	  if rs1("urlprefixs")<>"" then rules2(0)=rs1("urlprefixs")&rules2(0)
	  if rs1("urlincludes")<>"" then
	    urlincludes=split(rules2(0),rs1("urlincludes"))
		if ubound(urlincludes)>0 then url=url&",,"&rules2(0)
	  else
	    url=url&",,"&rules2(0)
	  end if
	next	
	allUrl=allUrl&url  
'---------------------------------------------------
end if
'response.End()	

	
	
	
	createfolder("cache/getinfo/")
	urlfile="cache/getinfo/"&id&".txt"
	createfile urlfile,allUrl
	
  end if
  set rs1=nothing
  getshow "","?rel=get1&id="&id
end if
%>

<%  
if rel="get1" then
  id=funstr(request.QueryString("id"))
  urlfile="cache/getinfo/"&id&".txt"
  urlinfo=openfile(urlfile)
%>
<table width="100%" border="0" align="center" cellpadding="1" cellspacing="1" class="forum2">
<tr align="center" height="24" class="forumRaw">
  <td height="30" align="left"> <b>&nbsp;- [信息地址] - 列表 - 技巧提示：</b>信息地址列表. </td>
</tr>
<form id="form2" name="form2" method="post" action="?rel=get2">
<% 
urlpage=split(urlinfo,",,")
for i=1 to ubound(urlpage)
%>
<tr align="center" height="24" class="forumRow">
  <td height="30" align="left"><input type="checkbox" name="checkbox<%= i %>" value="<%= urlpage(i) %>" /><a href="<%= urlpage(i) %>" target="_blank"><%=i&"."&urlpage(i) %></a></td>
</tr>
<% next%>
<tr align="center" height="24" class="forumRow">
  <td height="30" align="left">&nbsp;<a href="javascript:;" onClick="checkbox('checkbox',<%= ubound(urlpage) %>)">全选/取消</a>
  <input type="hidden" name="id" value="<%= id %>" /><input type="hidden" name="num" value="<%= ubound(urlpage) %>" /> <input type="submit" name="Submit13" value="批量采集" class="button" /></td>
</tr>
</form>
</table>
<%  
end if
%>




<%  
if rel="get2" then
response.Write("<div class='txt_box'>")

  id=funstr(request.Form("id"))
  num=funstr(request.Form("num"))
  i=1
  urlpagearr=""
  do while num-i>0
    urlstr="checkbox"&i
    urlpage=request.Form(urlstr)
	if urlpage="" then
    else
      urlpagearr=urlpagearr&",,"&urlpage
    end if
    i=i+1
  loop
  
  urlfile="cache/getinfo/"&id&"_.txt"
  createfile urlfile,urlpagearr
  getshow "","?rel=get3&num=1&id="&id
  
response.Write("</div>")
end if
%>

<%  
if rel="get3" then
%>

<div class="bar">
<div id="bar_txt">loading</div>
<div id="bar_loading"><img src="fun/loading.gif" width="100%" height="14" /></div>
</div>

<%
 response.Write "<div class='bar_info'><ul type=1>"


  id=funstr(request.QueryString("id"))
 'num=funstr(request.QueryString("num"))
  urlfile="cache/getinfo/"&id&"_.txt"
  urlfiles=openfile(urlfile)
  urlfiles=replace(urlfiles,"'","‘")
  numarr=split(urlfiles,",,")

for num=1 to ubound(numarr)
'--------------------------------

  set rs1=rsfun("select * from getinfo where id="&id,1)
  if not rs1.eof then
  
    urlces=numarr(num)
	str=Gethttppage(urlces,rs1("bian"))

	tags=split(rs1("tags"),",")
	for tagsi=0 to ubound(tags)
	  tags2=split(tags(tagsi),"@")
	  str=replace(str,tags2(0),tags2(1))
	next
	
	titlesarr=split(rs1("titles"),"[Kami]")
	titles=midstr(str,titlesarr(0),titlesarr(1))
	
	mgsarr=split(rs1("mgs"),"[Kami]")
	mgs=midstr(str,mgsarr(0),mgsarr(1))
	
	if rs1("audits") then mgs=clearhtml(mgs)
  
    mgs=replace(mgs,"'","‘")

    imgurl=""
	fckarr=split(LCase(mgs),"<img")
    if imgurl="" and ubound(fckarr)>0 then
	  
      imgurl=reimgone("src=[\""]?(.[^<]*)(gif|jpg|png|bmp)",mgs)
	  imgurl=replace(imgurl,"src=","")
	  imgurl=replace(imgurl,"""","")
	  imgurl=DefiniteUrl(imgurl,urlces)
    end if
	
'###############  | 录入采集数据 |  ################
set getArticle=server.createobject("adodb.recordset") 
    getArticle_sql="select * from article where title='"&titles&"'" 
    getArticle.open getArticle_sql,conn,1,3
	if getArticle.eof then
	   getArticle.addnew
	   
	   type_ids =rs1("cid")
	   type_id  =get_arrid(type_ids)

	   getArticle("title")   = titles
	   getArticle("content") = mgs
	   
	   getArticle("type_id") = type_id
	   getArticle("type_ids")= type_ids
	   
	   getArticle("class_id")= 1
	   
	   if err=0 then
	      getArticle.update
	      getAok=1   '成功录入
	   else
	      getAok=2   '成功采集，录入失败
	   end if
	   
	   else
	   getAok=0      '已存在
	end if
	getArticle.close
set getArticle=nothing
'##################################################

   if getAok=0 then
      response.Write("<li><span class=greed>ok! √ </span>&nbsp;"&titles&"  &nbsp;(已存在)</li>")
   elseif getAok=1 then
      response.Write("<li><span class=greed>ok! √ </span>&nbsp;"&titles&"  &nbsp;(new)</li>")
   else
      response.Write("<li><span class=red>false,"&err.description&"! × </span>&nbsp;"&titles&"</li>")
   end if
	
    response.Write("<script>loading("&num/ubound(numarr)*100&");</script>")
    response.Flush()


      end if
  set rs1=nothing

'---------------------------------
next
 response.Write "<li>全部信息采集完毕!</li>"
 response.Write "</ul></div>"
 response.Flush()
 response.Write "<script>alert('全部信息采集完毕!');</script>"
 
end if
%>

<!--测试采集-->
<%  
if rel="getces" then
response.Write("<div class='txt_box'>")


  titles="尚未采集到标题<br />"
  mgs="尚未采集到内容<br />"
  id=funstr(request.QueryString("id"))
  set rs1=rsfun("select * from getinfo where id="&id,1)
  if not rs1.eof then
    urlces=rs1("urlces")
	str=Gethttppage(urlces,rs1("bian"))

	
	tags=split(rs1("tags"),",")
	for tagsi=0 to ubound(tags)
	  tags2=split(tags(tagsi),"@")
	  str=replace(str,tags2(0),tags2(1))
	next
	
	titlesarr=split(rs1("titles"),"[Kami]")
	titles=midstr(str,titlesarr(0),titlesarr(1))
	
	mgsarr=split(rs1("mgs"),"[Kami]")
	mgs=midstr(str,mgsarr(0),mgsarr(1))
	
	if rs1("audits") then mgs=clearhtml(mgs)
  end if
  set rs1=nothing
  
  response.Write "<font color='#FF0000'><b>标题：</b></font>"&titles&"<br /><br />"
  response.Write "<font color='#FF0000'><b>内容：</b></font>"&mgs
  
  
  response.Write("</div>")
  
end if
%>
<!--测试采集结束-->



<% if rel="add" then %>
<form id="form1" name="form1" method="post" action="?rel=add_info">
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" class="forum2">
<tr align="center" height="24" class="forumRaw">
  <td height="30" colspan="3" align="left"> <b>&nbsp;- [规则添加] -  技巧提示:本采集插件暂时只支持一级深度.</b>  </td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td width="70" height="30" align="right">规则名称：</td>
<td align="left"><input type="text" name="names" /></td>
<td align="left">采集规则标识</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">采集地址：</td>
<td align="left"><input name="urls" type="text" size="40" value="http://" /></td>
<td align="left">指定采集地址</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">目标编码：</td>
<td align="left">
<select name="bian">
<option value="utf-8">utf-8</option>
<option value="gb2312" selected="selected">gb2312</option>
<option value="gbk">gbk</option>
<option value="big5">big5</option>
</select></td>
<td align="left">指定目标编码方式</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">采集区间：</td>
<td align="left"><textarea name="urlintervals" cols="40" rows="3"></textarea></td>
<td align="left">列表区间规则识别符号: [Kami]<br />
  如: &lt;td&gt;文章列表&lt;/td&gt;<br />
  用&lt;td&gt;[Kami]&lt;/td&gt;标识</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">地址规则：</td>
<td align="left"><textarea name="rules" cols="40" rows="3"></textarea></td>
<td align="left">对采集区间获取的代码进行分析<br />
解析出对应的文章地址<br />
用 [Kami] 标识! </td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">地址包含：</td>
<td align="left"><input name="urlincludes" type="text" size="40"/></td>
<td align="left">信息地址必须包含</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">地址补全：</td>
<td align="left"><input name="urlprefixs" type="text" size="40"/></td>
<td align="left">如采集到的地址为相对地址,在此设置补全文章地址.</td>
</tr>
<tr align="center" height="24" class="forumRow">
<td height="30" colspan="3" align="left" class="forumRaw"> <b>&nbsp;文章信息页规则设置</b></td></tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">信息测试：</td>
<td align="left"><input name="urlces" type="text" size="40"/></td>
<td align="left">测试此信息地址</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">替换字符：</td>
<td align="left"><textarea name="tags" cols="40" rows="3"></textarea></td>
<td align="left">替换文章信息页字符,替换规则如下：<br />
替换字符1@替换成字符1,替换字符2@替换成字符2</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">文章标题：</td>
<td align="left"><textarea name="titles"><title>[Kami]</title></textarea></td>
<td align="left">标题规则:&lt;title&gt;[Kami]&lt;/title&gt;</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">文章来源：</td>
<td align="left"><textarea name="source"></textarea></td>
<td align="left">设置来源</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">文章作者：</td>
<td align="left"><textarea name="users"></textarea></td>
<td align="left">设置作者</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">文章内容：</td>
<td align="left"><textarea name="mgs" cols="40" rows="3"></textarea></td>
<td align="left">文章内容规则标识为: [Kami] </td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">导入分类：</td>
<td align="left">



<select name="type_ids">
<option value="|0|" <%if at_type_id="|0|" then%>selected style='color:#ff0000'<%end if%>>一级栏目</option>
<%call getTypeTree(0,0)%>
</select>



</td>
<td align="left">设置分类</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">其他选项：</td>
<td align="left"><input type="checkbox" name="html" value="1" />去除HTML标签</td>
<td align="left">&nbsp;</td>
</tr>
<tr align="center" height="24" class="forumRow">
<td height="30" align="left" class="forumRaw">&nbsp;</td>
<td height="30" align="left" class="forumRaw"><input type="submit" name="Submit2" value="确认添加规则" class="button" /></td>
<td height="30" align="left" class="forumRaw">&nbsp;</td></tr>
</table>
</form>
<% end if %>


<%  
if rel="add_info" then
  names=request.Form("names")
  cid=request.Form("cid")
  urls=request.Form("urls")
  urlintervals=request.Form("urlintervals")
  urlintervals = replace(urlintervals,"'","‘")
  rules=request.Form("rules")
  rules = replace(rules,"'","‘")
  urlincludes=request.Form("urlincludes")
  urlprefixs=request.Form("urlprefixs")
  urlces=request.Form("urlces")
  tags=request.Form("tags")
  titles=request.Form("titles")
  mgs=request.Form("mgs")
  mgs = replace(mgs,"'","‘")
  users=request.Form("users")
  sources=request.Form("source")
  html=request.Form("html")
  bian=request.Form("bian")
  
  type_ids =request.Form("type_ids")
  type_id  =get_arrid(type_ids)
  
  if html="" then html=0


'### 判断。正确获取分类 
  cids=split(cid,",")
  if ubound(cids)=1 then
     'cid_b=cids(0)
     'cid_s=cids(1)
  else
  
     cid_b=type_ids
  
'  if cid<>"" and isnumeric(cid) then
'     cid_b=cid
'     cid_s=""
'  else
'     response.Write("<script>alert('请正确选择相应的分类');history.back(1);</'script>")
'	 response.End()
'  end if
  
  
  end if
  
  
  
  
  set rs=rsfun("insert into getinfo(names,cid,trees,urls,urlintervals,rules,urlincludes,urlprefixs,tags,titles,mgs,users,source,audits,urlces,bian)values('"&names&"','"&cid_b&"','"&cid_s&"','"&urls&"','"&urlintervals&"','"&rules&"','"&urlincludes&"','"&urlprefixs&"','"&tags&"','"&titles&"','"&mgs&"','"&users&"','"&sources&"','"&html&"','"&urlces&"','"&bian&"')",3)
  set rs=nothing
  getshow "添加记录成功","?"
end if
%>

<%
if rel="info" then 
   id=request.QueryString("id")
set rs1=rsfun("select * from getinfo where id="&id,1)
if not rs1.eof then
%>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" class="forum2">
<tr align="center" height="24" class="forumRow">
  <td height="30" colspan="3" align="left" class="forumRaw"> <b>&nbsp;- 规则修改 - 技巧提示:本采集插件暂时只支持一级深度.</b>  </td>
</tr>
<form id="form1" name="form1" method="post" action="?rel=info_info">

<tr align="center" height="24" class="forumRow"> 
<td width="70" height="30" align="right">规则名称：</td>
<td align="left"><input type="text" name="names" value="<% =rs1("names") %>" /></td>
<td align="left">采集规则标识</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">采集地址：</td>
<td align="left"><input name="urls" type="text" size="40" value="<% =rs1("urls") %>" /></td>
<td align="left">指定采集地址</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">目标编码：</td>
<td align="left">
<select name="bian">
<option value="<% =rs1("bian") %>" selected="selected"><% =rs1("bian") %></option>
<option value="utf-8">utf-8</option>
<option value="gb2312">gb2312</option>
<option value="gbk">gbk</option>
<option value="big5">big5</option>
</select></td>
<td align="left">指定编码方式</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">采集区间：</td>
<td align="left"><textarea name="urlintervals" cols="40" rows="3"><% str = replace(rs1("urlintervals"),"‘","'") %><% =str %></textarea></td>
<td align="left">列表区间规则识别符号: [Kami]<br />
  如: &lt;td&gt;文章列表&lt;/td&gt;<br />
  用&lt;td&gt;[Kami]&lt;/td&gt;标识</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">地址规则：</td>
<td align="left"><textarea name="rules" cols="40" rows="3"><% str = replace(rs1("rules"),"‘","'") %><% =str %></textarea></td>
<td align="left">对采集区间获取的代码进行分析<br />
解析出对应的文章地址<br />
用 [Kami] 标识! </td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">地址包含：</td>
<td align="left"><input name="urlincludes" type="text" size="40" value="<% =rs1("urlincludes") %>"/></td>
<td align="left">信息地址必须包含</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">地址补全：</td>
<td align="left"><input name="urlprefixs" type="text" size="40" value="<% =rs1("urlprefixs") %>"/></td>
<td align="left">如采集到的地址为相对地址,在此设置补全文章地址.</td>
</tr>
<tr align="center" height="24" class="forumRow">
<td height="30" colspan="3" align="left" class="forumRaw"> <b>&nbsp;- 文章信息页规则设置</b></td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">信息测试：</td>
<td align="left"><input name="urlces" type="text" size="40" value="<% =rs1("urlces") %>"/></td>
<td align="left">测试此信息地址</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">替换字符：</td>
<td align="left"><textarea name="tags" cols="40" rows="3"><% =rs1("tags") %></textarea></td>
<td align="left">替换文章字符,替换规则如下：<br />
替换字符1@替换成字符1,替换字符2@替换成字符2</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">文章标题：</td>
<td align="left"><textarea name="titles"><% =rs1("titles") %></textarea></td>
<td align="left">标题规则:&lt;title&gt;[Kami]&lt;/title&gt;</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">文章来源：</td>
<td align="left"><textarea name="source"><% =rs1("source") %>
</textarea></td>
<td align="left">设置来源</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">文章作者：</td>
<td align="left"><textarea name="users"><% =rs1("users") %>
</textarea></td>
<td align="left">设置作者</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">文章内容：</td>
<td align="left"><textarea name="mgs" cols="40" rows="3"><% str = replace(rs1("mgs"),"‘","'") %><% =str %></textarea></td>
<td align="left">文章内容规则标识为: [Kami] </td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">导入分类：</td>
<td align="left">

<%at_type_id=rs1("cid")%>
<select name="type_ids">
<option value="|0|" <%if at_type_id="|0|" then%>selected style='color:#ff0000'<%end if%>>一级栏目</option>
<%call getTypeTree(0,0)%>
</select>

</td>
<td align="left">设置分类</td>
</tr>
<tr align="center" height="24" class="forumRow"> 
<td height="30" align="right">其他选项：</td>
<td align="left"><% 
html=""
if rs1("audits") then html="checked='checked'" %>
<input type="checkbox" name="html" value="1" <% =html %> />
&nbsp;去除HTML标签</td>
<td align="left">&nbsp;</td>
</tr>
<tr align="center" height="24" class="forumRow">
<td height="30" align="left" class="forumRaw">  
<input name="id" type="hidden" value="<% =rs1("id") %>" />
&nbsp;</td>
<td height="30" align="left" class="forumRaw"><input type="submit" name="Submit" value="确认添加规则" class="button" /></td>
<td height="30" align="left" class="forumRaw">&nbsp;</td></tr>
</form>
</table>
<% 
end if
set rs1=nothing
end if %>


<%  
if rel="info_info" then
  id=request.Form("id")
  names=request.Form("names")
  cid=request.Form("cid")
  urls=request.Form("urls")
  urlintervals=request.Form("urlintervals")
  urlintervals = replace(urlintervals,"'","‘")
  rules=request.Form("rules")
  rules = replace(rules,"'","‘")
  urlincludes=request.Form("urlincludes")
  urlprefixs=request.Form("urlprefixs")
  urlces=request.Form("urlces")
  tags=request.Form("tags")
  titles=request.Form("titles")
  mgs=request.Form("mgs")
  mgs = replace(mgs,"'","‘")
  users=request.Form("users")
  sources=request.Form("source")
  html=request.Form("html")
  bian=request.Form("bian")
  
  
  type_ids =request.Form("type_ids")
  type_id  =get_arrid(type_ids)
  
  if html="" then html=0

  cids=split(cid,",")
  if ubound(cids)=1 then
     cid_b=cids(0)
     cid_s=cids(1)
  else
  
  
     cid_b=type_ids
  
'  if cid<>"" and isnumeric(cid) then
'     cid_b=cid
'     cid_s=""
'  else
'     response.Write("<script>alert('请正确选择相应的分类');history.back(1);</'script>")
'	 response.End()
'  end if

  end if

   

  set rs=rsfun("update getinfo set names='"&names&"',cid='"&cid_b&"',trees='"&cid_s&"',urls='"&urls&"',urlintervals='"&urlintervals&"',rules='"&rules&"',urlincludes='"&urlincludes&"',urlprefixs='"&urlprefixs&"',tags='"&tags&"',titles='"&titles&"',mgs='"&mgs&"',users='"&users&"',source='"&sources&"',audits='"&html&"',urlces='"&urlces&"',bian='"&bian&"' where id="&id,3)
  set rs=nothing
  getshow "修改记录成功","?"
  
  
end if
%>

<% 
if rel="del" then
  id=request.QueryString("id")
  set rs=rsfun("delete from getinfo where id="&id,3)
  getshow "删除记录成功","?"
  set rs=nothing
end if
%>


</td></TR></TABLE>


<% connclose %>