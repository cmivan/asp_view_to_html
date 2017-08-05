<!--#include file="article_config.asp"-->
<%
'@设置操作的类型
'@class_id=0 则分类，class_id=1 则页面
dim class_id,class_width,class_title
    class_id=0
	class_width="550px"
	class_title="栏目"
'///////////  处理提交数据部分 ////////// 
    edit_id=request("edit_id")
%>
<!--#include file="article_body.asp"-->