<%
'<><><><><><><><><><><><><><><><><>
' 定义获取后台操作信息的函数 Time:2010-07-26
' By:Cm.ivan Contact:Cm.ivan@163.com
'<><><><><><><><><><><><><><><><><>



 
 '----------- 返回文章文件名 ---------------
 Function H_FileName(sid,id)
    'H_FileName=sid&html_line&md5(id)&html_fix
     dim getName
     getName=getCN(sid)
     if getName<>"" then H_FileName=getName&html_fix
 End Function
 
  '----------- 返回文章文件目录 ------------
 Function H_Folder(bid)
    'H_folder=html_path&"\type"&html_line&bid&"\"
	 H_folder=html_path&"\"
 End Function

   '----------- 返回分页文件名 ---------------
 Function H_Paging(Sid,page)
     if page>1 then
        H_Paging=replace(Sid,html_fix,html_line&page&html_fix)
	 else
        H_Paging=replace(Sid,html_fix,html_fix)
	 end if 
 End Function



'//////////////////////////////////////////////////////////
'<><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
'//////////////////////////////////////////////////////////


'/////////////返回导航栏///////////////
 Function H_GetNav()
     dim NavStyle,href,t_href
     set rsNav=server.createobject("adodb.recordset")
	     sql_rsNav="select * from article where is_nav=1 order by order_id asc"
         rsNav.open sql_rsNav,conn,1,1
        '导航样式-----------------------
         NavStyle=GetMod(sys_navitem)
		 do while not rsNav.eof
		    href=site_url&rsNav("href")
		    t_href=NavStyle
		    t_href=replace(t_href,"{?:href}",href)
		    t_href=replace(t_href,"{?:html_open}",html_open)
		    t_href=replace(t_href,"{?:title}",rsNav("title"))
		    H_GetNav=H_GetNav&t_href
            rsNav.movenext
		 loop
         rsNav.close
     set rsNav=nothing
 End Function







' ---------- 取字串的前n个字符----------
 Function cutStr(str,strlen)
	dim l,t,c, i
	    l=len(str)
	    t=0
	for i=1 to l
	    c=Abs(Ascw(Mid(str,i,1)))
	    if c>255 then
	       t=t+2
	    else
	       t=t+1
	    end if
	    if t>=strlen then str=left(str,i)&"..."
		cutStr=str
	next
 end Function

' ---------- 得到安全字符串,在查询中或有必要强行替换的表单中使用----------
 Function GetSafeStr(str)
	GetSafeStr = Replace(Replace(Replace(Trim(str),"'",""),Chr(34),""),";","")
 End Function

' ---------- 错误返回处理------------
 Sub GoError(str)
	Response.Write "<script language=javascript>alert('" & str & "\n\n系统将自动返回前一页面...');history.back();</script>"
	Response.End()
 End Sub




'//////////////////////////////////////////////////////////
'<><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
'//////////////////////////////////////////////////////////


' ---------- 后台：读取模板\模块列表----------------
Sub getSMoban(id,Tid)
set get_rs=server.createobject("adodb.recordset")
        if Tid="" or isnumeric(Tid)=false then
        get_sql="select * from km_moban_item_type order by order_id asc"
        else
        get_sql="select * from km_moban_item_type where id="&Tid&" order by order_id asc"
        end if
response.Write(get_sql)
        get_rs.open get_sql,conn,1,1
		do while not get_rs.eof
		response.Write("<optgroup label="""&get_rs("title")&""">")
    set getS_rs=server.createobject("adodb.recordset")
        getS_sql="select * from km_moban_item where type_id="&get_rs("id")&" order by id desc"
        getS_rs.open getS_sql,conn,1,1
        do while not getS_rs.eof
	       if int(id)=int(getS_rs("id")) then
	          response.Write("<option value="""&getS_rs("id")&""" selected> - "&getS_rs("title")&"</option>")
	       else
	          response.Write("<option value="""&getS_rs("id")&""">"&getS_rs("title")&"</option>")
	       end if
        getS_rs.movenext  
        loop
        getS_rs.close 
    set getS_rs=nothing
        response.Write("</optgroup>")
        get_rs.movenext  
        loop
        get_rs.close 
    set get_rs=nothing
End Sub

' ---------- 后台：读取模块 分类----------------
Sub getSModType(db_table,id)
    set getSMod_rs=server.createobject("adodb.recordset")
        getSMod_sql="select * from "&db_table&"_type"
        getSMod_rs.open getSMod_sql,conn,1,1
        do while not getSMod_rs.eof
	       if int(id)=int(getSMod_rs("id")) then
	          response.Write("<option value="""&getSMod_rs("id")&""" selected>"&getSMod_rs("title")&"</option>")
	       else
	          response.Write("<option value="""&getSMod_rs("id")&""">"&getSMod_rs("title")&"</option>")
	       end if
           getSMod_rs.movenext  
        loop
        getSMod_rs.close 
    set getSMod_rs=nothing
End Sub



function get_template(gt_id)
   if gt_id<>"" and isnumeric(gt_id) then
      set gt_rs=conn.execute("select * from km_moban_item where id="&gt_id)
	      if not gt_rs.eof then
		     filename=gt_rs("filename")
			 filename=server.MapPath(".\")&"\..\template\"&filename
			 template=getfile(filename)
			 get_template=replace(template,chr(10),"")
		  end if
	  set gt_rs=nothing
   end if
end function



function paging(page_href,page_max,page)


end function
%>