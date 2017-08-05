<%
'set rs_a=conn.execute("select * from sys_db_type")
'    do while not rs_a.eof
'	sss=rs_a("db_form")
'	sss=replace(sss,"<div class=inputbox><div class=inputbox>{view}</div></div>","<div class=inputbox>{view}</div>")
'	conn.execute("update sys_db_type set db_form='"&sss&"' where id="&rs_a("id"))
'    rs_a.movenext
'    loop
'set rs_a=nothing



'@@返回静态生成的目录
dim site_name,site_url
    site_name="诺奇企业建站系统 v1.0 www.cmivan.com"         '网站名称
	site_url ="http://www.cmivan.com:8080/asp/mk_website/" '网站地址
	site_home="index"    '主页地址

'@@返回静态生成的目录
dim html_path,html_fix
    html_path="html"     '静态目录
    html_fix =".htm"     '静态后缀
	html_line="_"        '静态后缀
	html_open="_black"

'@@返回系统设置
dim sys_navitem
    sys_navitem=28
    sys_pagsize=18
	
'@@后台管理
dim T_Line
    T_Line="<img src='"&syspath&"public/skin/images/ico/line.gif' width='14' height='11' />"  '分割线
	
%>