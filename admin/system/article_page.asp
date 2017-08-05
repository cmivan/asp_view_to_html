<!--#include file="article_config.asp"-->
<%
'@设置操作的类型
'@class_id=0 则分类，class_id=1 则页面
dim class_id,class_width,class_title
    class_id=1
	class_width=""
	class_title="页面"
'///////////  处理提交数据部分 ////////// 
    edit_id    =request("edit_id")
    article_id =request("article_id")
%>
<!--#include file="article_body.asp"-->