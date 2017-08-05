<%
'<><><><><><><><><><><><><><><><><>
' 定义模块操作的函数 Time:2010-07-26
' By:Cm.ivan Contact:Cm.ivan@163.com
'<><><><><><><><><><><><><><><><><>



'****************************************
'** 返回模块项内容
'****************************************
Function getTempMod(temp,rs,str)
	 set trs=rs
	 dim tsrt
         if trs(str)<>"" then tsrt=trs(str) else tsrt="&nbsp;" end if
		 temp=replace(temp,"{?:"&str&"}",tsrt)
         getTempMod=temp
end Function
'****************************************
Function getTempMob(temp,str1,str2)
         if str2="" then str2="&nbsp;"
		 temp=replace(temp,"{?:"&str1&"}",str2)
         getTempMob=temp
end Function



'****************************************
'** 替换静块内容,返回模板
'****************************************
function GetHTMLmod(srp_content)
	 set ghm_rs=conn.execute("select * from km_moban_item where tip<>'' order by id desc")
         do while not ghm_rs.eof
            srp_content=replace(srp_content,"<a id=""mod:"&ghm_rs("tip")&"""/>",ghm_rs("mob"))
            ghm_rs.movenext  
         loop
     set ghm_rs=nothing
	 GetHTMLmod=srp_content   '返回内容
end function


'****************************************
'** 读取模板后,NO.1(调用静块,独立模块替换函数)
'****************************************
function sys_replace_match(srp_content,srp_moban_id)
   srp_content=GetHTMLmod(srp_content)
   srp_content=replace(srp_content,chr(10),"")
   if moban_id<>"" and isnumeric(moban_id) then
      set rs_mob=conn.execute("select * from km_mob where m_mob_id="&int(srp_moban_id))
          do while not rs_mob.eof
	         srp_content=replace(srp_content,rs_mob("m_mob_tip"),rs_mob("m_mob"))
          rs_mob.movenext
          loop
      set rs_mob=nothing
   end if
   sys_replace_match=srp_content
end function


'****************************************
'** 替换,网站配置数据
'****************************************
function sys_replace_config(srp_content)
   srp_content=getTempMob(srp_content,"page_nav",page_nav)
   srp_content=getTempMob(srp_content,"site_name",site_name)
   srp_content=getTempMob(srp_content,"site_url",site_url)
   srp_content=getTempMob(srp_content,"site_home",site_home)
   srp_content=getTempMob(srp_content,"html_line",html_line)
   srp_content=getTempMob(srp_content,"html_fix",html_fix)
   srp_content=getTempMob(srp_content,"html_path",html_path)
   srp_content=getTempMob(srp_content,"html_open",html_open)
   sys_replace_config=srp_content
end function


'****************************************
'** 替换,文章数据
'****************************************
function sys_replace_page(srp_content,srp_rs)
   set rs_temp=srp_rs
   srp_content=getTempMod(srp_content,rs_temp,"id")
   srp_content=getTempMod(srp_content,rs_temp,"title")
   srp_content=getTempMod(srp_content,rs_temp,"type_id")
   srp_content=getTempMod(srp_content,rs_temp,"note")
   srp_content=getTempMod(srp_content,rs_temp,"content")
   srp_content=getTempMod(srp_content,rs_temp,"small_pic")
   srp_content=getTempMod(srp_content,rs_temp,"big_pic")
   srp_content=getTempMod(srp_content,rs_temp,"add_data")
   srp_content=getTempMod(srp_content,rs_temp,"hits")
   srp_content=getTempMod(srp_content,rs_temp,"tj")
   set rs_temp=nothing
   sys_replace_page=srp_content
end function
%>