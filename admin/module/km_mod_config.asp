<!--#include file="../bin/header.asp"-->
<%
 '//设置相应的表
 db_table = "km_moban_item"

'####### 使用递归，生成无限级菜单 ########
dim rsnum,dict
set dict=Server.CreateObject("Scripting.Dictionary")
    dict.item("typeid0")="0|"    '根类
sub getTypeTree(id,tree,oid)
    on error resume next '容错模式
         dim rsc,selected,rs_sql
		 if id="" or isnumeric(id)=false then id=0
	 set rsc=server.CreateObject("Adodb.recordset")   
	     rs_sql="select * from "&db_table&"_type where type_id="&id&" order by order_id asc,id desc"
	     rsc.open rs_sql,conn,1,1
			itemNum=tree
		    dict.item("item_"&itemNum)=0
		 while not rsc.eof
			tree=tree+1
			dict.item("item_"&itemNum)=dict.item("item_"&itemNum)+1  '用于累计当前分类的数目
			dict.item("typeid"&rsc("id"))=dict.item("typeid"&rsc("type_id"))&rsc("id")&"|"
			rsnum=""
		   '-------------------------------
		    Dtype_id=dict.item("typeid"&rsc("id"))
			Dtype_ids=split(Dtype_id,"|")
			
		    for rsN=1 to tree
				if rsN<tree then
				   rsnum=rsnum&"&nbsp;│"
				   else
				   rsnum=rsnum&"&nbsp;├ "
				end if
			next

			   selected=""
	        if cstr(oid)=cstr(rsc("id")) then selected="selected style='color:#ff0000'"
	           response.Write("<option value='" & rsc("id") & "' "&selected&">" &rsnum&rsc("title")&"</option>")
			   call getTypeTree(rsc("id"),tree,oid)
		   '-------------------------------
		  tree=tree-1
          rsc.movenext
         wend
	     rsc.close
     set rsc=nothing
end sub
%>
