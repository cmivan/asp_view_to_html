<%
'<><><><><><><><><><><><><><><><><>
' 定义文件操作的函数 Time:2010-07-26
' By:Cm.ivan Contact:Cm.ivan@163.com
'<><><><><><><><><><><><><><><><><>


'****************************************
'** 创建目录 \ 支持多级 \文件夹不存在则生成
'****************************************
Function creatfolder(w_path)
	on error resume next
 	set fso=CREATEOBJECT("SCRIPTING.FILESYSTEMOBJECT")
	    w_path=replace(w_path,"/","\")
		w_path=split(w_path,"\")
		' 有后缀的--------------------------------
		i_path=ubound(w_path)
		if instr(w_path(ubound(w_path)),".")<>0 then i_path=i_path-1
	   '-----------------------------------------
		for i=0 to i_path
            if w_path(i)<>"" then
		       w_paths=w_paths&w_path(i)&"\"
			   if fso.folderexists(w_paths)=false then fso.createfolder(w_paths)
	        end if
		next
		creatfolder=true            
	set fso=nothing
End Function


'****************************************
'** 生成文件,可指定生成编码
'****************************************
sub WriteToFile(FileUrl,Str)
    Set stm = CreateObject("Adodb.Stream")
        stm.Type = 2
        stm.mode = 3
        stm.charset ="GB2312"
        stm.Open
        stm.WriteText Str
        stm.SaveToFile FileUrl, 2
        stm.flush
        stm.Close
    Set stm = Nothing
end sub


'****************************************
'** 创建文件,可指定生成编码
'****************************************
sub creatfile(filePath,nr)
    on error resume next
    Temp_filePath=filePath
    Temp_filePath=replace(Temp_filePath,"\\","\")
    filePath=replace(filePath,"\\","\")
    filePath=server.MapPath(filePath)
    T_filePath =filePath
    creatfolder filePath
    
	if getFileLen(nr) then  '判断是否要生成
       call WriteToFile (T_filePath,nr)
    else
       back="falis!(Too big!)"
    end if
	
    if err and back="" then
       back="falis!"
    elseif back="" then
       back="ok!"
    end if
	
    response.Write("<a href="""&Temp_filePath&""" target=""_blank""> "&Temp_filePath&"</a> "&back&"<br>")
    response.Flush()
end sub 


'****************************************
'** 检测文件大小,用于生成文件
'****************************************
function getFileLen(str)
  on error resume next
  dim l,t,i,c
   l=len(str)
   t=0
   for i=1 to l
     c=Abs(Asc(Mid(str,i,1)))
     if c>255 then
        t=t+2
     else
        t=t+1
     end if
   next
   IF INT(HtmlLimit)<=0 THEN HtmlLimit=100
   IF t>HtmlLimit*1024 then     '限制HTML文件大小
      getFileLen=false
	  else
	  getFileLen=true
   end IF
end function 


'****************************************
'** 读取文件,用于生成文件
'****************************************
function getfile(filepath)
    on error resume next 
 	Set fs = CreateObject("Scripting.FileSystemObject") 
 	set f = fs.OpenTextFile(filepath,1,True) 

	if err<>0 then
	   response.Write(err.description)
	   exit function
	end if
	
 	rdfile=f.ReadAll() 
 	getfile=rdfile 
 	f.Close 
 	set fs=nothing 
end function 


'****************************************
'** 文件的删除,用于生成文件
'****************************************
sub delfile(filePath) 
 	set fs=server.CreateObject("Scripting.FileSystemObject") 
 	 On Error Resume Next
	 if fs.FileExists(filePath) then
		fs.DeleteFile(filePath)
	 end if
	 Set fs = Nothing
end sub


'****************************************
'** ewebeditor的删除文件函数
'****************************************
Sub DoDelFile(sPathFile)
	On Error Resume Next
	Dim oFSO
	Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
	    oFSO.DeleteFile(Server.MapPath(sPathFile))
	Set oFSO = Nothing
End Sub
%>