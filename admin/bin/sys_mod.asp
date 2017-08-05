<%
'<><><><><><><><><><><><><><><><><>
' 定义模块操作的函数 Time:2010-07-26
' By:Cm.ivan Contact:Cm.ivan@163.com
'<><><><><><><><><><><><><><><><><>



'------------- 返回小模块内容 -----------------
Function GetMod(GmodId)
    if GmodId<>"" and isnumeric(GmodId) then
	 set GetModstr=server.createobject("adodb.recordset")
	     GetModsql="select * from km_moban_item where id="&int(GmodId)
	     GetModstr.open GetModsql,conn,1,1
	       if not GetModstr.eof then GetMod=GetModstr("mob")
	     GetModstr.close   
	 set GetModstr=nothing 
	elseif instr(GmodId,"type|")<>0 then
	     GmodId=replace(GmodId,"type|","")
	 set GetModstr=server.createobject("adodb.recordset")
	     GetModsql="select * from article where id="&int(GmodId)
	     GetModstr.open GetModsql,conn,1,1
	       if not GetModstr.eof then GetMod=GetMod(GetModstr("mob_item"))
	     GetModstr.close   
	 set GetModstr=nothing
	else
	     GetMod="Get failes!<br>"
	end if
End Function

'----------- 返回相应的模板 ---------------
 Function H_GetMoban(M_id)
   if M_id<>"" and isnumeric(M_id) then
     set G_Moban=server.createobject("adodb.recordset")
	     sql_G_Mobanclass="select * from km_moban_item where id="&int(M_id)
         G_Moban.open sql_G_Mobanclass,conn,1,1
         if not G_Moban.eof then H_GetMoban = G_Moban("mob")
         G_Moban.close
     set G_Moban=nothing
   end if
 End Function 
 
'----------- 返回相应的大类的模板id ---------------
 Function H_GetMobanID(Bid,Bty)
   if Bid<>"" and isnumeric(Bid) then
     set G_MobanID=server.createobject("adodb.recordset")
	     sql_G_MobanID="select * from article where id="&int(Bid)
         G_MobanID.open sql_G_MobanID,conn,1,1
         if not G_MobanID.eof then
		    if Bty="Li" then
		       H_GetMobanID = G_MobanID("mob_list")   '返回列表模板
		    elseif Bty="Ar" then
			   H_GetMobanID = G_MobanID("mob_page")   '返回详细内容模板
			else
			   H_GetMobanID = G_MobanID("mob_main")   '返回主页面模板
			end if
		 end if
         G_MobanID.close
     set G_MobanID=nothing
   end if
 End Function

'----------- 返回模块内容 ---------------
Function GetMods(Gtype,GId,Gnum,GmodId)
		'/////////////////解析模块样式///////////////
		
		 if GmodId<>"" and instr(GmodId,"<!--else-->")=0 then
            modStr_1  =GmodId   '读取模块样式
	     else
		    modStrs=split(GmodId,"<!--else-->")
			if ubound(modStrs)=1 then
			   modStr_0=modStrs(0)  '读取模块样式1
			   modStr_1=modStrs(1)  '读取模块样式2
			elseif ubound(modStrs)=2 then
			   modStr_0=modStrs(0)  '读取模块样式1
			   modStr_1=modStrs(1)  '读取模块样式2
			   modStr_2=int(modStrs(2))          '读取样式2的显示数目
			else
			   exit function
			end if
		 end if

		 '判断显示的列数
		 if Gnum=0 or isnumeric(Gnum)=false then
			TopNum=int(h_artlinenum)
		 else
			TopNum=int(Gnum)
		 end if

        '生成sql
		 if Gtype="tj"  then
			sql="select top "&TopNum&" * from article where tj=1 order by id desc"
		 elseif Gtype="new" then
			sql="select top "&TopNum&" * from article order by id desc"
		 elseif Gtype="top" then
			sql="select top "&TopNum&" * from article order by hits desc,id desc"
		 elseif Gtype="list" and GId<>"" and isnumeric(GId) then
			sql="select top "&TopNum&" * from article where type_ids like '%|"&GId&"|%' order by id desc"
		 elseif Gtype="where" and GId<>"" then
		    sql="select top "&TopNum&" * from article where "&GId
		 else
			sql="select top "&TopNum&" * from article order by id desc"
		 end if


		 set getrs=server.createobject("adodb.recordset")
	   		 getrs.open sql,conn,1,1
	   		 if getrs.bof then
				getMStr= "暂时没有信息!"
	   		 else  
				dim I     '这个定义是必须的，否则会影响到下一次循环
				do while not getrs.eof 
				I=I+1
				'--------------分析处理模块样式-----------
				   IF modStr_2="" or isnumeric(modStr_2)=false then modStr_2=1
				   IF I<=modStr_2 and modStr_0<>"" then
					  TempMod=modStr_0
				   else
					  TempMod=modStr_1
				   End if

				   '--------- site_url 的值,在页面sys_config.asp中定义
				   F_href=site_url&getrs("href")
				   F_href=replace(F_href,"\","/")
				   '-----------------------------------------

				   TempMod=getTempMod(TempMod,getrs,"id")
				   TempMod=getTempMod(TempMod,getrs,"title")
				   TempMod=getTempMod(TempMod,getrs,"type_id")
				   TempMod=getTempMod(TempMod,getrs,"note")
				   TempMod=getTempMod(TempMod,getrs,"content")
				   TempMod=getTempMod(TempMod,getrs,"small_pic")
				   TempMod=getTempMod(TempMod,getrs,"big_pic")
				   TempMod=getTempMod(TempMod,getrs,"add_data")
				   TempMod=getTempMod(TempMod,getrs,"hits")
				   TempMod=getTempMod(TempMod,getrs,"tj")
				   
				   TempMod=replace(TempMod,"{?:href}",F_href)
				   TempMod=replace(TempMod,"{?:open}",HtmlOpen)
				   
				   if err<>0 then response.Write("___err"&err&"<br />")
	

				   getMStr=getMStr&TempMod
				   
				getrs.movenext
				loop
				
	   		 end if
	   		 getrs.close   
		 set getrs=nothing 

 GetMods=getMStr
End Function
%>