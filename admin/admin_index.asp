<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
 Response.CodePage= 65001
 Response.Charset="UTF-8"
 Server.ScriptTimeout=99990
 '### 容错模式
 on error resume next
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="public/skin/style/style.css" rel="stylesheet" type="text/css" />
</head>
<body style="overflow:hidden;">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" id="index_box">
<tr><td style="height:80px;" id="index_top">
<div class="topnav" style="height:80px;">
<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr>
<td width="170" style="padding:15px;padding-right:5px;padding-left:10px;"><img src="public/skin/images/logo.png" width="174" height="50" align="absmiddle"></td>
<td valign="bottom" class="TopNav">
<a href="system/article_type.asp" target="main">
添加栏目</a>
<a href="system/article_manage_type.asp" target="main">管理栏目</a>
<a href="system/article_html_page.asp" target="main">生成静态</a>
<a href="system/article_html_list.asp" target="main">生成详细页</a>
<a href="plugins/codebeaut.asp" target="main">编辑样式</a>
<a href="plugins/pluckV/index.asp" target="main">采集</a>
<a href="module/km_mod_type.asp" target="main">模块分类</a>
<a href="module/km_mod.asp" target="main">模块管理</a>

</td>
</tr>
</table>
</div>
<div class="topline"></div>
</td></tr>
<tr><td valign="top" style="margin:auto;" id="index_main">
<iframe scrolling="auto" frameborder="0" name="main" src="system/article_manage_type.asp" style="width:100%; height:100%;"></iframe>
</td></tr>
</table>
</body>
</html>
