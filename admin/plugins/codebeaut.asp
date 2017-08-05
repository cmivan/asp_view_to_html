<!--#include file="../bin/header.asp"-->
<%
'<><><><><><><><><><><><><><><><><><><><><><><><><><><><>
'        <><> 程序设计 编写 ：凡人
'        <><> 联系qq       ：394716221
'        <><> 版本 v1.2
'<><><><><><><><><><><><><><><><><><><><><><><><><><><><>

'绑定操作数据对象
dim connBeaut,MMconn
set connBeaut=conn

'用于规则数据绑定
set MMconn=conn    

'系统配置变量
dim web_cform,PageNum,type_id,Num,web_Num,sysPage
    web_cform   = "tf_"                       '控件前缀
    PageNum     = 3                           '生成的页面、路径上限
	type_id     = lcase(request.querystring("type_id"))  '要操作的表
    sysPage     = lcase(request.QueryString("sysPage"))
	
	if sysPage<>"" then session("sysPage")=sysPage
	sysPage=""&session("sysPage")

%>

<body>
<TABLE border="0" align="center" cellpadding="0" cellspacing="10" class="forum1">
<tr><td>
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" class="forum2 forumtop">
<tr class="forumRaw"><td>&nbsp;
<a href="?sysPage=manage">管理规则</a> - 
<a href="?sysPage=edit&Etype=add">添加规则</a>
</td></tr>
</table>
<%
select case sysPage
  case "","manage"
   Did=request.querystring("Did")
   CopyID=request.querystring("CopyID")
   ReID=request.querystring("ReID")
   oNum=request.querystring("oNum")
   
if Did<>"" and isNumeric(Did) then
  '### 删除栏目
   MMconn.execute("delete * from sys_db_type where id="&int(Did))
   response.Redirect("?")
elseif CopyID<>"" and isNumeric(CopyID) then
   '### 复制栏目
   set Rs=MMconn.execute("select * from sys_db_type where id="&int(CopyID))
       if not Rs.eof then
       set AddRs=server.createobject("adodb.recordset")
           AddRsStr="select * from sys_db_type"
           AddRs.open AddRsStr,MMconn,1,3
	       AddRs.addnew
		   AddRs("db_title")   =Rs("db_title")&"(2)"
		   AddRs("db_input")   =Rs("db_input")
		   AddRs("db_checkJS") =Rs("db_checkJS")
		   AddRs("db_form")    =Rs("db_form")
		   AddRs.update
           AddRs.close
       set AddRs=nothing
	   response.Redirect("?")
	   end if
   set Rs=nothing 
elseif ReID<>"" and isNumeric(ReID) and oNum<>"" and isNumeric(oNum) then  
   '### 更新栏目排序
   MMconn.execute("update sys_db_type set order_id="&oNum&" where id="&ReID)
   'response.Redirect("?")
end if

'///// 重排 /////
set ReRs=server.createobject("adodb.recordset")
    ReRsStr="select * from sys_db_type order by order_id asc,db_title asc,id desc"
	ReRs.open ReRsStr,MMconn,1,3
    dim reOrderNum
	do while not ReRs.eof
	   reOrderNum=reOrderNum+1
	   ReRs("order_id")=reOrderNum
	   ReRs.update
	   ReRs.movenext
	loop
    ReRs.close
set ReRs=nothing


set Lconn=MMconn.execute("select * from sys_db_type order by order_id asc,db_title asc,id desc")
%>
<table width="100%" align="center" cellpadding="2" cellspacing="1" class="forum2">
<tr class="forumRaw">
<td width="88%">&nbsp;名称/标题</td>
<td width="60" align="center">排序</td>
<td width="55" align="center">操作</td>
</tr>
<%do while not Lconn.eof%>
<tr class="forumRow"><td>
<a href="?sysPage=edit&page=<%=page%>&Etype=edit&Eid=<%=Lconn("id")%>" style="width:100%;padding-left:8px"><img src="<%=syspath%>public/skin/images/ico/ico_2.gif" width="6" height="6" />&nbsp;<%=Lconn("db_title")%></a></td>
<td align="center"><input name="order_id" type="text" id="order_id" style="width:40px; text-align:center; color:#FF6600; font-weight:bold" value="<%=Lconn("order_id")%>" onChange="window.location.href='?ReID=<%=Lconn("id")%>&oNum='+this.value;" /></td>
<td align="center">
<a href="?page=<%=page%>&Did=<%=Lconn("id")%>" onClick="return confirm('是否确定删除?');"><img src="<%=syspath%>public/skin/images/ico/delete.gif" width="10" height="10" /></a>&nbsp;&nbsp;<a href="?page=<%=page%>&CopyID=<%=Lconn("id")%>" onClick="return confirm('是否确定复制?');"><img src="<%=syspath%>public/skin/images/ico/copy.gif" width="12" height="12" alt="复制该项内容!" /></a></td></tr>
<%
    Lconn.movenext
    loop
set Lconn =nothing
%>  
</table>
<%
case "edit"


Etype    = request.querystring("Etype")
Eid      = request.querystring("Eid")
Ftype    = request.form("Ftype")
ErrInfo  = "<div style='font-size:12px;'>访问出错...</div>"
if not isempty(Ftype) then
set Econn=server.createobject("adodb.recordset")
 if Etype="add" then
	Econn_str="select * from sys_db_type"
	Econn.open Econn_str,MMconn,1,3
	Econn.addnew
	BackTip="添加成功!"
elseif Etype="edit" and not isempty(Eid) and isNumeric(Eid) then
    Econn_str="select * from sys_db_type where id="&int(Eid)
	Econn.open Econn_str,MMconn,1,3
	BackTip="修改成功!"
else
	response.write(ErrInfo)
    response.end() 	
end if 

if not Econn.eof then

   Econn("db_title")   = cstr(request.form("s_db_title"))
   'Econn("db_input")=cstr(request.form("s_db_input"))
   Econn("db_checkJS") = cstr(request.form("s_db_checkJS"))
   Econn("db_form")    = cstr(request.form("s_db_form"))
   
   s_db_input = request.form("s_db_input")
   s_db_input = replace(s_db_input,"< textarea","<textarea")
   s_db_input = replace(s_db_input,"< /textarea","</textarea")
   
   Econn("db_input")=cstr(s_db_input)

   response.write("<script>alert('" & BackTip & "');</script>")
end if
	Econn.update
	Econn.close
set Econn= nothing
end if

'判断是修改，还是添加||| 显示数据读取部分
if Etype="edit" and not isempty(Eid) and isNumeric(Eid) then
set Rconn=MMconn.execute("select * from sys_db_type where id="&int(Eid))
 if not Rconn.eof then
    s_db_title    = Rconn("db_title")
    s_db_input    = Rconn("db_input")
    s_db_checkJS  = Rconn("db_checkJS")
    s_db_form     = Rconn("db_form")
	
s_db_input = replace(s_db_input,"<textarea","< textarea")
s_db_input = replace(s_db_input,"</textarea","< /textarea")

 else
	response.write(ErrInfo)
    response.end() 	   
 end if
set Rconn=nothing
elseif Etype="add" then
else
    response.write(ErrInfo)
    response.end()   
end if
%>

<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1" class="forum2">
<form id="E_form" name="E_form" method="post" action="?Etype=<%=Etype%>&Eid=<%=Eid%>" >
<tr class="forumRaw">
<td width="10%" align='right'>标题：</td><td width="87%">
<input name="s_db_title" type="text" value="<%=s_db_title%>" size="40" /></td></tr>
<tr class="forumRow"><td align='right' valign="top">显示数据：</td><td>
  <textarea name="s_db_input" rows="10" style="width:99%"><%=s_db_input%></textarea></td></tr>
<tr class="forumRow"><td align='right' valign="top">表单数据：</td><td>
<textarea name="s_db_form" rows="10" style="width:99%"><%=s_db_form%></textarea></td></tr>
<tr class="forumRow"><td align='right' valign="top">JS检测：</td><td>
<textarea name="s_db_checkJS" rows="10" style="width:99%"><%=s_db_checkJS%></textarea></td></tr>
<tr class="forumRaw"><td align="right">&nbsp;</td><td>
<input name="button" type="submit" id="button" value="  保存   " class="button"/>
<input name="Ftype" type="hidden" value="<%=Etype%>" /></td>
</tr>
</form>
</table>

<%end select%>
</td></tr>
</TABLE>
</body>





<%
'///////////////////////////////////////////////////////////////////////
'- 返回信息框的   msgbox 函数
'- msg(str,Num) ,str="提示的内容" , Num:1=提示  2=提示、返回  3=提示、结束
'//////////////////////////////////////////////////////////////////////
sub msg(str,Num)
    select case Num
	       case 1
		   response.write("<script>alert('"&str&"');</script>")
		   case 2
		   response.write("<script>alert('"&str&"');history.go(-1);</script>")
		   response.end()
		   case 3
		   response.write("<script>alert('"&str&"');</script>")
		   response.end()
	end select
end sub


'## 返回模板目录
function getTemplatePath(id)
  if isnumeric(id) then
   set gt=MMconn.execute("select db_path from sys_db_template where id="&id)
       if not gt.eof then getTemplatePath=gt("db_path")
   set gt=nothing
  end if
end function


'///////// 返回表格<table>、<tr class="forumRow">、<td>、<div>../////////
function Totable(tablestr,t_type)
tablestr="<"&t_type&" class=""forumRow"">"&tablestr&"</"&t_type&">"&chr(13)
end function

'///////// 返回读取数据库的字段类型//////////////////////
function get_type(Num)
 set rs=conn.execute("select top 1 * from sys_db_ftype where db_Num="&Num)
	 if not rs.eof then
	    get_type=rs("db_tip")
	 else
	    get_type="none"
	 end if
 set rs=nothing
end function

'///////// 返回输入框方式的函数//////////////////////////////
function getCode(f_tip,f_name,db_filed,id) 
 dim show_input 
 set rs=conn.execute("select top 1 * from sys_db_type where id="&id)
  if not rs.eof then
	 show_input=rs(db_filed)
	 show_input=replace(show_input,"{tip}",f_tip)
	 show_input=replace(show_input,"{wc}",web_cform)
	 show_input=replace(show_input,"{name}",f_name)
	 show_input=replace(show_input,"{value}","<%|="&web_cform&f_name&"%|>")
	 show_input=replace(show_input,"%|","%")
  end if
 set rs=nothing
 getCode=show_input & chr(13)
end function

'///////// 字符替换，将特定的字符替换成要生成的网站代码////////////////
function strTocode(mybody)
	'-- 替换配置文件
	     mybody=replace(mybody,"{type_id}",type_id)
		 mybody=replace(mybody,"{db_title}",db_title)
	'-- 编辑页面的
	     mybody=replace(mybody,"{接收数据}",f_request)
		 mybody=replace(mybody,"{写入数据}",f_write)
		 mybody=replace(mybody,"{读取数据}",f_read)
	     mybody=replace(mybody,"{表单数据}",field_td)
		 mybody=replace(mybody,"{数据判断}",f_requestorm)
		 mybody=replace(mybody,"{表单判断}",field_js)
    '-- 列表页面的	
		 mybody=replace(mybody,"$admin_list_db_1$",admin_list_db_1)
		 mybody=replace(mybody,"$admin_list_db_2$",admin_list_db_2)
    '-- 详细页面的
	     mybody=replace(mybody,"$admin_detail_db_1$",admin_detail_db_1)
end function

'//////////////////////////////////////////////////////////////////
'  生成文件/目录 的函数(go)    sub web_create("文件名","文件内容","类型")
'//////////////////////////////////////////////////////////////////
function web_create(s_name,s_centent,s_type)
    on error resume next  '容错模式(防止内存不足)
    select case s_type
	       case "folder"                          '文件夹不存在则生成
		        folder_name=lcase(server.mappath(s_name))
	            folder_name=replace(folder_name,"\","/")
		        folder_name=split(folder_name,"/")
				i_paht=ubound(folder_name)
				if instr(folder_name(i_paht),".")<>0 then i_paht=i_paht-1
				
		    set fso=createobject("scripting.filesystemobject")
				for i=0 to i_paht
            		if folder_name(i)<>"" then
		      		   folder_names=folder_names&folder_name(i)&"/"
			   		if fso.folderexists(folder_names)=false then fso.createfolder(folder_names)
	        		end if 
				next
	        set fso=nothing 
			
		   case "file"                            '文件不存在则生成文件
		   
'               生成完整路径
		        temp_paths=lcase(s_name)
				temp_path =split(temp_paths,"/")
		        temp_path_str=temp_path(ubound(temp_path))
				full_path =replace(temp_paths,temp_path_str,"")
				call web_create(full_path,,"folder")

				set stm=server.createobject("adodb.stream") 
   				    stm.type=2 '以本模式读取 
   				    stm.mode=3 
    				stm.charset="utf-8"
    				stm.open
					stm.writetext s_centent 
    				stm.savetofile server.mappath(s_name),2 
    				stm.flush 
    				stm.close
				set stm=nothing

		   case "getfile"                        '读取文件内容
				dim str 
				set stm=server.createobject("adodb.stream") 
    				stm.type=2 '以本模式读取 
    				stm.mode=3 
    				stm.charset="utf-8"
    				stm.open
					stm.loadfromfile server.mappath(s_name) 
    				str=stm.readtext 
    				stm.close
				set stm=nothing 
   				    web_create=str 
					
		   case "copy"                        '复制文件
   				set fso=createobject("scripting.filesystemobject") 
   				set c=fso.getfile(s_name) '被拷贝文件位置
       				c.copy(s_centent)
   				set c=nothing
   				set fso=nothing
    end select
end function
%>