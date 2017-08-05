<%
'//////////////////////////////////////////////////////////			
Dim HTMLmod,reg,objMatches 
Dim objM_0,objM_1,objM_2,objM_3,objM_4
Dim objMods

	'----- 先清空原有的模块记录 -----
    conn.execute("delete from km_mob")
	
set rs_moban=server.createobject("adodb.recordset") 
    rs_moban_exec="select * from km_moban_item where type_id=14 order by id desc"
	rs_moban.open rs_moban_exec,conn,1,1
    do while not rs_moban.eof
	   dim moban_id
	   moban_id=rs_moban("id")

'--------------读取模板后,NO.1(调用静块,独立模块替换函数)-----------
	mob=get_template(moban_id)
	
	'//通过标签找到相应的模块
    HTMLmod =GetHTMLmod(mob)
	
	HTMLmod=replace(HTMLmod,chr(10),"")

    Set reg = new RegExp 
        reg.IgnoreCase = True 
        reg.Global = True 
		'reg.Pattern = "<a cmd:(.+?){(\d+?),(\d+?)}>(.+?)<\/a cmd>"
		reg.Pattern = "<a cmd:(.+?){(.+?),(\d+?)}>(.+?)<\/a cmd>"
		'<a cmd:list{1,5}>

'--------------------------------------------------------------------------------------------
'-- 模块正则含义：<a cmd:list{分类ID(整数),显示数目(整数)}
'-- 模块正则含义：<a cmd:list{top,new,tj,where(所有)}
'-- 模块正则含义：<a cmd:list{分类ID(整数),显示数目(整数)}
'-- 模块正则含义：<a cmd:list{分类ID(整数),显示数目(整数)}
'--------------------------------------------------------------------------------------------

	    Set objMatches = reg.Execute(HTMLmod)
		
	     if objMatches.Count >0 Then
	        for i=0 to objMatches.Count-1
	   	        objM_0=objMatches(i).SubMatches(0)
		        objM_1=objMatches(i).SubMatches(1)
		        objM_2=objMatches(i).SubMatches(2)
		        objM_3=objMatches(i).SubMatches(3)


		        '---- 读取相应的模块内容 -------------
				
				'正则ok->还原
				'objM_3=replace(objM_3,"{?:chr}",chr(10))
				
		        objMods=GetMods(objM_0,objM_1,objM_2,objM_3)
				mob_cmd="cmd:"&objM_0&"{"&objM_1&","&objM_2&"}"
				mob_tip="<a "&mob_cmd&">"&objM_3&"</a cmd>"
		        '-------------------------------------

			 if err=0 then
                set rs_mob=server.createobject("adodb.recordset") 
                    rs_exec="select * from km_mob order by id desc"  '判断，添加数据
	                rs_mob.open rs_exec,conn,1,3
                    rs_mob.addnew

	                rs_mob("m_mob_id") =moban_id
	                rs_mob("m_mob_tip")=mob_tip
	                rs_mob("m_mob")    =objMods
	                rs_mob.update
	                rs_mob.close
                set rs_mob=nothing

				'-----------------------
				echo("&nbsp;&nbsp;<font color=""#ff00000"">&lt;mod:&gt;&nbsp;reflash!</font>&nbsp;"&mob_cmd)
			 else
				echo("&nbsp;&nbsp;<font color=""#ff00000"">&lt;mod:&gt;&nbsp;faile!</font>&nbsp;"&mob_cmd)
			 end if

	        next
         end If
        Set objMatches=nothing
    Set reg =nothing
'------------------------------------------------------------------------------------
    rs_moban.movenext
	loop
	rs_moban.close
set rs_moban=nothing
%>