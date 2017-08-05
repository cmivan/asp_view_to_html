<%  
'输出分类列表
'类型s 1为下拉列表 2为列表
function classlist(s)
  classlist=""
    set rs=rsfun("select * from class where cid=0 order by xu asc",1)
    do while not rs.eof
	  if s="1" then
      classlist=classlist&"<option value='"&rs("id")&","&rs("trees")&"'>"&rs("names")&"</option>"
	  end if
	  classlist=classlist&classlisttwo(rs("id"),s)
    rs.movenext
    loop
    set rs=nothing
end function

function classlisttwo(i,s)
  set rs=rsfun("select * from class where cid="&i&" order by xu asc",1)
  do while not rs.eof
    str="<font color=red><b>|-</b></font>"
    treesarr=split(rs("trees"),":")
    m=4
    do while m<ubound(treesarr)
	  str=str&"<font color=blue><b>|-</b></font>"
	  m=m+1
    loop
	
    if s="1" then
      classlisttwo=classlisttwo&"<option value='"&rs("id")&","&rs("trees")&"'>"&str&rs("names")&"</option>"
	end if
	classlisttwo=classlisttwo&classlisttwo(rs("id"),s)
	
  rs.movenext
  loop
  set rs=nothing
end function
%>

