<!--#include file="conn.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=syspath%>public/skin/style/style.css" rel="stylesheet" type="text/css" />
<script src="<%=syspath%>public/skin/js/jquery.1.4.js" language="javascript"></script>
<script src="<%=syspath%>public/skin/js/jquery.edit.style.js" language="javascript"></script>
<script language="javascript">
//文件上传,弹出的窗口 js
function showUploadDialog(s_Type, s_Link, s_Thumbnail){
var arr = showModalDialog("<%=syspath%>public/editBox/fckupLoad/dialog/i_upload.htm?style=popup&type="+s_Type+"&link="+s_Link+"&thumbnail="+s_Thumbnail, window, "dialogWidth:0px;dialogHeight:0px;help:no;scroll:no;status:no");}
</script>
</head>


