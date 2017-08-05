<% 
'======================================================================================
On Error Resume Next
'遇到错误继续往下执行
rel=funstr(request.QueryString("rel"))
'使用funstr函数过滤特殊字符
webfpurl="cache/config.txt"
if fileex(webfpurl) then
else
webfpurl="../"&webfpurl
end if
webfp=openfile(webfpurl)
'获取文本内容
web=split(webfp,",,")

web_name=web(0)    
web_url=web(1)  
web_keywords=web(2)   
web_dis=web(3)  
web_temp=web(4)   
web_indexclassnum=web(5)   
web_listnum=web(6)   
web_vipnum=web(7)   
web_hotnum=web(8)  
web_updatenum=web(9)  
web_end=web(10)   

webfpurl="cache/html.txt"
if fileex(webfpurl) then
else
webfpurl="../"&webfpurl
end if
'把文本内容分割成数组
webfp=openfile(webfpurl)
html=split(webfp,",,")

web_sono=html(0)  '是否开启搜索
web_lunno=html(1)  '评论是否审核
web_lanmuno=html(2)  '标题前显示栏目
web_timeno=html(3) ' 标题后显示时间
web_xmlnum=html(4)  'xml显示条数
web_jsnum=html(5)  'JS调用条数
web_titlenum=html(6)  '分类下显示文章标题字数

webfpurl="cache/gao.txt"
if fileex(webfpurl) then
else
webfpurl="../"&webfpurl
end if
sitegao=openfile(webfpurl)

'replace为替换文本函数
'使用方法为:(需要替换的变量,查找字符,查找到的字符替换成)
'rsfun为执行查询函数 参数1:可以查询 参数3:可以删除,修改
'使用方法:(sql语句,参数)
'do while 为循环开始
'rs.movenext 为指针指向下一条记录
'loop 为循环结束


'全局变量
function globals(str,temp)

  

  if boolstr(str,"{[csc:include file=header.htm]}") then
    fpheaderurl="../temp/"&temp&"/header.htm"
	if fileex(fpheaderurl)=0 then  fpheaderurl="temp/"&temp&"/header.htm"
    fpheader=openfile(fpheaderurl)
	str=replace(str,"{[csc:include file=header.htm]}",fpheader)
  end if
  if boolstr(str,"{[csc:include file=floot.htm]}") then
    fpflooturl="../temp/"&temp&"/floot.htm"
	if fileex(fpflooturl)=0 then  fpflooturl="temp/"&temp&"/floot.htm"
    fpfloot=openfile(fpflooturl)
    str=replace(str,"{[csc:include file=floot.htm]}",fpfloot)
  end if
  
  str=replace(str,"{[csc:global name=title]}",web_name)
  str=replace(str,"{[csc:global name=site]}",web_url)
  str=replace(str,"{[csc:global name=keywords]}",web_keywords)
  str=replace(str,"{[csc:global name=dis]}",web_dis)
  str=replace(str,"{[csc:global name=temp]}",web_temp)
  str=replace(str,"{[csc:global name=end]}",web_end)
  str=replace(str,"{[csc:global name=gao]}",sitegao)
  '替换标签
  
  
  '搜索热门关键字
  if boolstr(str,"{[csc:global so key]}") then
  sokey=""
  set rskey=rsfun("select top 10 * from so where hots=1 order by counts desc",1)
  do while not rskey.eof
    sokey=sokey&" <a href='"&web_url&"/so.asp?keys="&server.URLEncode(rskey("keywords"))&"' >"&rskey("keywords")&"</a> "
  rskey.movenext
  loop
  set rskey=nothing
  str=replace(str,"{[csc:global so key]}",sokey)
  end if
  
  '替换导航
  if boolstr(str,"{[csc:global name=toplist]}") then
  strtop=""
  set rstop=rsfun("select * from class where toplists=1 order by xu asc",1)
  do while not rstop.eof
    strtop=strtop&"<li><a href='"&web_url&"/"&rstop("htmldir")&"' >"&rstop("names")&"</a></li>"
  rstop.movenext
  loop
  set rstop=nothing
  str=replace(str,"{[csc:global name=toplist]}",strtop)
  end if
  
  if boolstr(str,"{[csc:global name=endlist]}") then
  '单页替换成底部导航
  strend=""
  set rsend=rsfun("select * from du where vip=1 order by id asc",1)
  do while not rsend.eof
    strend=strend&"<a href='"&web_url&"/htm/"&rsend("url")&"' >"&rsend("names")&"</a> "
  rsend.movenext
  loop
  set rsend=nothing
  str=replace(str,"{[csc:global name=endlist]}",strend)
  end if
  
  if boolstr(str,"{[csc:link]}") then
  '替换文字连接
  strlink=""
  set rslink=rsfun("select * from link where imgurl='http://' order by xu asc",1)
  do while not rslink.eof
    'if rslink("imgurl")="http://" then
    strlink=strlink&"<a href='"&rslink("url")&"' title='"&rslink("names")&"' target=_blank>"&rslink("names")&"</a> "
	'end if
  rslink.movenext
  loop
  set rslink=nothing
  str=replace(str,"{[csc:link]}",strlink)
  end if
  
  if boolstr(str,"{[csc:imglink]}") then
  '替换图片连接
  strlink=""
  set rsimglink=rsfun("select * from link where imgurl<>'http://' order by xu asc",1)
  do while not rsimglink.eof
    strlink=strlink&"<a href='"&rsimglink("url")&"' title='"&rsimglink("names")&"' target=_blank><img src="&rsimglink("imgurl")&"></a> "
  rsimglink.movenext
  loop
  set rsimglink=nothing
  str=replace(str,"{[csc:imglink]}",strlink)
  end if
  
  '替换广告
  set rsad=rsfun("select * from ad",1)
  do while not rsad.eof
    str=replace(str,"{[csc:global name="&rsad("tag")&"]}",unfunstr(rsad("mg")))
  rsad.movenext
  loop
  set rsad=nothing
  
  
  
  globals=str
end function


%>