<!--#include file="article_config.asp"-->
<%
'####### 使用递归，生成无限级菜单 ########
dim rsnum,dict,d_type_id
set dict=Server.CreateObject("Scripting.Dictionary")
    dict.item("typeid0")="0|"    '根类
sub getTypeTree(id,tree)
    on error resume next '容错模式
         dim rsc,selected,rs_sql
		 if id="" or isnumeric(id)=false then id=0
	 set rsc=server.CreateObject("Adodb.recordset")   
	     rs_sql="select * from "&db_table&" where type_id="&id&" and "
		 rs_sql=rs_sql&"(class_id=0 or (class_id=1 and type_id=0)) order by order_id asc,id desc"
	     rsc.open rs_sql,conn,1,1
			itemNum=tree
		    dict.item("item_"&itemNum)=0
		 while not rsc.eof
			tree=tree+1
			dict.item("item_"&itemNum)=dict.item("item_"&itemNum)+1  '用于累计当前分类的数目
			dict.item("typeid"&rsc("id"))=dict.item("typeid"&rsc("type_id"))&rsc("id")&"|"
			rsnum=""
		   '-------------------------------
		    d_type_id =dict.item("typeid"&rsc("id"))
			d_type_ids=split(d_type_id,"|")
			
		    for rsN=2 to tree
				if rsN<tree then
				   if dict.item("item_end"&d_type_ids(rsN))="end" then
				      rsnum=rsnum&"&nbsp;&nbsp;&nbsp;&nbsp;"
				   else
				      rsnum=rsnum&"&nbsp;&nbsp;│"
				   end if
				end if
				
				if cstr(dict.item("item_"&itemNum))=cstr(rsc.recordcount) and rsN=tree then
				   'rsnum=rsnum&"&nbsp;└ "
				   rsnum=rsnum&"&nbsp;&nbsp;├ "
				   dict.item("item_end"&rsc("id"))="end"
				elseif rsN=tree then
				   rsnum=rsnum&"&nbsp;&nbsp;├ "
				end if
			next

			selected=""
			d_type_id="|"&d_type_id
            if cstr(session("Etype_id"))=cstr(rsc("id")) then selected="selected style='color:#ff0000'"
			
			
			'栏目修改
            LMurl="article_type.asp?edit_id="&rsc("id")
			'栏目设置/内容设置
			TSurl="article_type_set.asp?article_id="&rsc("id")
			'内容添加
            NRurl="article_page.asp?article_id="&rsc("id")&"&type_ids="&d_type_id
			'内容修改
            YMurl="article_page.asp?edit_id="&rsc("id")
			'内容管理
			GLurl="article_manage.asp?type_ids="&d_type_id
			'删除栏目
			SCurl=reUrl("del_id="&rsc("id"))

			
			
		 if rsc("class_id")<>1 then
		 
            response.Write("<div class=typeitem><div class=item><div class=left>")
			response.Write(rsnum&"&nbsp;&nbsp;<a href='"&LMurl&"'>" &rsc("title")&"</a>&nbsp;<span>(ID:"&rsc("id")&")</span>")
			response.Write("</div><div class=right>")
			response.Write("<a href='javascript:void(0);' link='"&SCurl&"' class='del_item' id='"&rsc("id")&"'>删除</a>"&T_Line)
			response.Write("<a href='"&TSurl&"&class_id=0'>栏目设置</a>"&T_Line)
			response.Write("<a href='"&TSurl&"&class_id=1'>内容设置</a>"&T_Line)
			response.Write("<a href='"&GLurl&"'>管理</a>"&T_Line)
			response.Write("<a href='"&NRurl&"'>添加内容</a>"&T_Line)
			response.Write("<a href='"&LMurl&"'>修改</a>")
			response.Write("</div><div class=right><span class=num>"&get_article_count(db_table,d_type_id)&"</span>&nbsp;条记录</div></div></div>")
		else
            response.Write("<div class=typeitem><div class=item><div class=left>")
			response.Write(rsnum&"&nbsp;&nbsp;<a href='"&LMurl&"'>" &rsc("title")&"</a>&nbsp;<span>(ID:"&rsc("id")&")</span>")
			response.Write("</div><div class=right>")
			response.Write("<a href='javascript:void(0);' link='"&SCurl&"' class='del_item' id='"&rsc("id")&"'>删除</a>"&T_Line)
			response.Write("<a href='"&TSurl&"&class_id=1'>内容设置</a>"&T_Line)
			response.Write("<a href='"&YMurl&"'>修改</a>")
			response.Write("</div></div></div>")
		end if
		
		
			
			response.Write(chr(10)&chr(13))
            call getTypeTree(rsc("id"),tree)

		  tree=tree-1
          rsc.movenext
         wend
	     rsc.close
     set rsc=nothing
end sub

%>

<body>
<div class="mainWidth">
<!--#include file="article_nav.asp"-->

<div class="class_nav">
<div class="type_box">
<%call getTypeTree(0,0)%>
</div>
</div>

</div>
</body>
</html>