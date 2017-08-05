<%  
'======================================================================================
'C9 静态文章发布系统
'官方网站:http://www.csc9.cn
'======================================================================================
'判断内容是否存在此字符
'str1:内容 str2:字符
function boolstr(str1,str2)
  dim arrstr
  arrstr=split(str1,str2)
  if ubound(arrstr)>0 then
    boolstr="1"
  else
    boolstr="0"
  end if
end function
'==============================
'取出中间内容函数 midstr(str,str1,str2)
'str 内容 str1,开始 str2,结束
'==============================
function midstr(str,str1,str2)
  dim midstr1,midstr2
  midstr1=split(str,str1)
  if ubound(midstr1)>0 then
    midstr2=split(midstr1(1),str2)
	if ubound(midstr2)>0 then
	  midstr=midstr2(0)
	else
	  midstr="0"
	end if
  else
    midstr="0"
  end if
end function

'==============================
'获取字符长度GetStrLen
'参数str为指定字符,汉字为2. a,为输出数量
'==============================
Function GetStrLen(str,a)
If IsNull(str) Or str = "" Then
getStrLen = 0
Else
Dim i, n, k, chrA, chrb
k = 0
n = Len(str)
For i = 1 To n
chrA = Mid(str, i, 1)
If Asc(chrA) >= 0 And Asc(chrA) <= 255 Then
k = k + 1
Else
k = k + 2
End If

chrb=chrb & chrA

if k>=a then
exit for
end if

Next
'在此输出K可得字符数量,汉字为2
getStrLen = chrb
End If
End Function

'==================================================
'字符函数 funstr
'2009-06-05 Crazy
'==================================================
Function funstr(str)	 
	str = trim(str) 	 
	str = replace(str, "<", "&lt;", 1, -1, 1)
	str = replace(str, ">", "&gt;", 1, -1, 1)
	str = replace(str,"'","‘")
	
	funstr = str
End Function

Function unfunstr(str)	 	 
	str = replace(str, "&lt;","<", 1, -1, 1)
	str = replace(str, "&gt;",">", 1, -1, 1)
	str = trim(str)
	str = replace(str,"‘","'")	
	unfunstr = str
End Function
'==================================================
'读取文件内容
'==================================================
function openfile(url)
  fileurl=server.MapPath(url)
  set fso=server.CreateObject("scripting.filesystemobject") '定义FSO
  set mofile=fso.opentextfile(fileurl,1) '以读的方式打开文件
  mo_top=mofile.readall() '读取全部内容
  mofile.close
  
  openfile=mo_top
end function
'==================================================
'写入文件内容
'==================================================
sub createfile(url,str)
  fileurl=server.MapPath(url)
  set fso=server.CreateObject("scripting.filesystemobject") 
  set mofile=fso.createtextfile(fileurl,true)
  mofile.write str
  mofile.close

end sub
'==================================================
'检查文件夹是否存在,如果不存在则创建
'==================================================
sub createfolder(folder)
  folderurl=server.MapPath(folder)
  set fso=server.CreateObject("scripting.filesystemobject") 
  if fso.folderexists(folderurl) then
  
  else
    fso.createfolder(folderurl)
  end if
set fso=nothing '''*****
end sub

'==================================================
'删除文件夹 
'==================================================
sub delfolder(folder)
  folderurl=server.MapPath(folder)
  set fso=server.CreateObject("scripting.filesystemobject") 
  if fso.folderexists(folderurl) then
    fso.deletefolder folderurl,true
  end if
set fso=nothing '''*****
end sub
'==================================================
'删除文件
'==================================================
sub delfile(files)
  fileurl=server.MapPath(files)
  set fso=server.CreateObject("scripting.filesystemobject") '定义FSO
  if fso.fileexists(fileurl) then
    fso.deletefile fileurl,true
  end if
set fso=nothing '''*****
end sub

'==================================================
'检测文件 返回值 真:1 假:0
'==================================================
function fileex(files)
  fileurl=server.MapPath(files)
  set fso=server.CreateObject("scripting.filesystemobject") '定义FSO
  if fso.fileexists(fileurl) then
    fileex=1
  else
    fileex=0
  end if
set fso=nothing '''*****
end function
'==================================================
'弹出对话框
'==================================================
sub getshow(str,url)
  if str="" and url <>"" then
    response.Write "<script language='javascript'>window.document.location.href='"& url &"'</script>"
    response.End()
  end if
  if str<>"" and url="" then
    response.Write "<script language='javascript'>alert('"&str&"');history.go(-1)</script>"
    response.End()
  end if
  if str<>"" and url<>"" then
    response.Write "<script language='javascript'>alert('"&str&"');window.document.location.href='"& url &"'</script>"
    response.End()
  end if
  
end sub
'==================================================
'风格输出过程
'==================================================
function showtemp()
  set fso=server.CreateObject("scripting.filesystemobject")
  set ff=fso.getfolder(server.MapPath("../temp"))
  set openfs=ff.subfolders
  for each openf in openfs
  showtemp=showtemp&"<option value='"&openf.name&"'>"&openf.name&"</option>"
  next
  set fso=nothing
  set ff=nothing
  set openfs=nothing
end function
'==================================================
'生成上传文件名函数 filenamestr
'==================================================
function filenamestr()
   str=now()
   strs=split(str," ")
   strsa=split(strs(0),"-")
   strsb=split(strs(1),":")
   filenamestr=""
   filenamestr=filenamestr&strsa(0)
   filenamestr=filenamestr&strsa(1)
   filenamestr=filenamestr&strsa(2)
   filenamestr=filenamestr&strsb(0)
   filenamestr=filenamestr&strsb(1)
   filenamestr=filenamestr&strsb(2)
end function

function filenametime(str)
  arr=split(str,"-")
  filenametime=arr(0)&arr(1)&arr(2)
end function

function timemd(str)
  arr=split(str,"-")
  if len(arr(2))=1 then
    arr(2)="0"&arr(2)
  end if
  if len(arr(1))=1 then
    arr(1)="0"&arr(1)
  end if
  timemd=arr(1)&"-"&arr(2)
end function
'==================================================
'清除HTML代码函数
'==================================================
Function ClearHtml(Content) 
Content=Zxj_ReplaceHtml("&#[^>]*;", "", Content) 
Content=Zxj_ReplaceHtml("</?marquee[^>]*>", "", Content) 
Content=Zxj_ReplaceHtml("</?object[^>]*>", "", Content) 
Content=Zxj_ReplaceHtml("</?param[^>]*>", "", Content) 
Content=Zxj_ReplaceHtml("</?embed[^>]*>", "", Content) 
Content=Zxj_ReplaceHtml("</?table[^>]*>", "", Content) 
Content=Zxj_ReplaceHtml(" ","",Content) 
Content=Zxj_ReplaceHtml("</?tr[^>]*>", "", Content) 
Content=Zxj_ReplaceHtml("</?th[^>]*>","",Content) 
Content=Zxj_ReplaceHtml("</?p[^>]*>","",Content) 
Content=Zxj_ReplaceHtml("</?a[^>]*>","",Content) 
'Content=Zxj_ReplaceHtml("</?img[^>]*>","",Content) 
Content=Zxj_ReplaceHtml("</?tbody[^>]*>","",Content) 
Content=Zxj_ReplaceHtml("</?li[^>]*>","",Content) 
Content=Zxj_ReplaceHtml("</?span[^>]*>","",Content) 

Content=Zxj_ReplaceHtml("</?div[^>]*>","",Content) 
Content=Zxj_ReplaceHtml("</?th[^>]*>", "", Content) 
Content=Zxj_ReplaceHtml("</?td[^>]*>", "", Content) 
Content=Zxj_ReplaceHtml("</?script[^>]*>", "", Content) 
Content=Zxj_ReplaceHtml("(javascript|jscript|vbscript|vbs):", "", Content) 
Content=Zxj_ReplaceHtml("on(mouse|exit|error|click|key)", "", Content) 
Content=Zxj_ReplaceHtml("<\\?xml[^>]*>", "", Content) 
Content=Zxj_ReplaceHtml("<\/?[a-z]+:[^>]*>", "", Content) 
Content=Zxj_ReplaceHtml("</?font[^>]*>", "", Content) 
Content=Zxj_ReplaceHtml("</?b[^>]*>","",Content) 
Content=Zxj_ReplaceHtml("</?u[^>]*>","",Content) 
Content=Zxj_ReplaceHtml("</?i[^>]*>","",Content)
Content=Zxj_ReplaceHtml("</?strong[^>]*>","",Content) 

ClearHtml=Content 
End Function 

Function Zxj_ReplaceHtml(patrn, strng,content) 
IF IsNull(content) Then 
content="" 
End IF 
Set regEx = New RegExp ' 建立正则表达式。 
regEx.Pattern = patrn ' 设置模式。 
regEx.IgnoreCase = true ' 设置忽略字符大小写。 
regEx.Global = true ' 设置全局可用性。 
Zxj_ReplaceHtml=regEx.Replace(content,strng) ' 执行正则匹配 
End Function

'匹配第一项符合的要求把值输出

function reimgone(patrn,str)
  reimgone=""
  Set re = New RegExp
  re.Pattern = patrn
  re.IgnoreCase = true
  re.Global = true
  set reexe=re.Execute(str)
  
    if isnull(reexe(0)) then
      reimgone=""
    else
	  reimgone=reexe(0)
    end if
  
end function

'获取网络数据函数
 Function Gethttppage(Path,crzchars)      
 T = Getbody(Path)
 Gethttppage=Bytestobstr(T,crzchars)
 End Function

 Function Getbody(Url)      
 On Error Resume Next
 Set Retrieval = Createobject("Microsoft.Xmlhttp") 
     Retrieval.Open "Get",Url, False, "", "" 
     Retrieval.send()
     Getbody = Retrieval.Responsebody
 Set Retrieval = Nothing 
 End Function 

Function BytesToBstr(body,Cset)         
        dim objstream
        set objstream = Server.CreateObject("adodb.stream")
        objstream.Type = 1
        objstream.Mode =3
        objstream.Open
        objstream.Write body
        objstream.Position = 0
        objstream.Type = 2
        objstream.Charset = Cset
        BytesToBstr = objstream.ReadText 
        objstream.Close
        set objstream = nothing
End Function

Function Newstring(wstr,strng)              '
        Newstring=Instr(lcase(wstr),lcase(strng))
        if Newstring<=0 then Newstring=Len(wstr)
End Function
'获取网络数据函数结束


'Crazy增加以下函数 2009-06-06
'==================================================
'函数名：CheckDir2
'作 用：检查文件夹是否存在
'参 数：FolderPath ------文件夹地址
'==================================================
Function CheckDir2(byval FolderPath)
dim fso
folderpath=Server.MapPath(".")&"\"&folderpath
Set fso = Server.CreateObject("Scripting.FileSystemObject")
If fso.FolderExists(FolderPath) then
'存在
  CheckDir2 = True
Else
'不存在
  CheckDir2 = False
End if
Set fso = nothing
End Function


'==================================================
'函数名：MakeNewsDir2
'作 用：创建新的文件夹
'参 数：foldername ------文件夹名称
'==================================================
Function MakeNewsDir2(byval foldername)
dim fso
Set fso = Server.CreateObject("Scripting.FileSystemObject")
fso.CreateFolder(Server.MapPath(".") &"\" &foldername)
If fso.FolderExists(Server.MapPath(".") &"\" &foldername) Then
MakeNewsDir2 = True
Else
MakeNewsDir2 = False
End If
Set fso = nothing
End Function
'==================================================
'函数名：DefiniteUrl
'作 用：将相对地址转换为绝对地址
'参 数：PrimitiveUrl ------要转换的相对地址
'参 数：ConsultUrl ------当前网页地址
'==================================================
Function DefiniteUrl(Byval PrimitiveUrl,Byval ConsultUrl)
Dim ConTemp,PriTemp,Pi,Ci,PriArray,ConArray
If PrimitiveUrl="" or ConsultUrl="" or PrimitiveUrl="$False$" Then
DefiniteUrl="$False$"
Exit Function
End If
If Left(ConsultUrl,7)<>"HTTP://" And Left(ConsultUrl,7)<>"http://" Then
ConsultUrl= "http://" & ConsultUrl
End If
ConsultUrl=Replace(ConsultUrl,"://",":\\")
If Right(ConsultUrl,1)<>"/" Then
If Instr(ConsultUrl,"/")>0 Then
If Instr(Right(ConsultUrl,Len(ConsultUrl)-InstrRev(ConsultUrl,"/")),".")>0 then 
Else
ConsultUrl=ConsultUrl & "/"
End If
Else
ConsultUrl=ConsultUrl & "/"
End If
End If
ConArray=Split(ConsultUrl,"/")
If Left(PrimitiveUrl,7) = "http://" then
DefiniteUrl=Replace(PrimitiveUrl,"://",":\\")
ElseIf Left(PrimitiveUrl,1) = "/" Then
DefiniteUrl=ConArray(0) & PrimitiveUrl
ElseIf Left(PrimitiveUrl,2)="./" Then
DefiniteUrl=ConArray(0) & Right(PrimitiveUrl,Len(PrimitiveUrl)-1)
ElseIf Left(PrimitiveUrl,3)="../" then
Do While Left(PrimitiveUrl,3)="../"
PrimitiveUrl=Right(PrimitiveUrl,Len(PrimitiveUrl)-3)
Pi=Pi+1
Loop 
For Ci=0 to (Ubound(ConArray)-1-Pi)
If DefiniteUrl<>"" Then
DefiniteUrl=DefiniteUrl & "/" & ConArray(Ci)
Else
DefiniteUrl=ConArray(Ci)
End If
Next
DefiniteUrl=DefiniteUrl & "/" & PrimitiveUrl
Else
If Instr(PrimitiveUrl,"/")>0 Then
PriArray=Split(PrimitiveUrl,"/")
If Instr(PriArray(0),".")>0 Then
If Right(PrimitiveUrl,1)="/" Then
DefiniteUrl="http:\\" & PrimitiveUrl
Else
If Instr(PriArray(Ubound(PriArray)-1),".")>0 Then 
DefiniteUrl="http:\\" & PrimitiveUrl
Else
DefiniteUrl="http:\\" & PrimitiveUrl & "/"
End If
End If 
Else
If Right(ConsultUrl,1)="/" Then 
DefiniteUrl=ConsultUrl & PrimitiveUrl
Else
DefiniteUrl=Left(ConsultUrl,InstrRev(ConsultUrl,"/")) & PrimitiveUrl
End If
End If
Else
If Instr(PrimitiveUrl,".")>0 Then
If Right(ConsultUrl,1)="/" Then
If right(PrimitiveUrl,3)=".cn" or right(PrimitiveUrl,3)="com" or right(PrimitiveUrl,3)="net" or right(PrimitiveUrl,3)="org" Then
DefiniteUrl="http:\\" & PrimitiveUrl & "/"
Else
DefiniteUrl=ConsultUrl & PrimitiveUrl
End If
Else
If right(PrimitiveUrl,3)=".cn" or right(PrimitiveUrl,3)="com" or right(PrimitiveUrl,3)="net" or right(PrimitiveUrl,3)="org" Then
DefiniteUrl="http:\\" & PrimitiveUrl & "/"
Else
DefiniteUrl=Left(ConsultUrl,InstrRev(ConsultUrl,"/")) & "/" & PrimitiveUrl
End If
End If
Else
If Right(ConsultUrl,1)="/" Then
DefiniteUrl=ConsultUrl & PrimitiveUrl & "/"
Else
DefiniteUrl=Left(ConsultUrl,InstrRev(ConsultUrl,"/")) & "/" & PrimitiveUrl & "/"
End If 
End If
End If
End If
If Left(DefiniteUrl,1)="/" then
DefiniteUrl=Right(DefiniteUrl,Len(DefiniteUrl)-1)
End if
If DefiniteUrl<>"" Then
DefiniteUrl=Replace(DefiniteUrl,"//","/")
DefiniteUrl=Replace(DefiniteUrl,":\\","://")
Else
DefiniteUrl="$False$"
End If
End Function
'==================================================
'函数名：ReplaceSaveRemoteFile
'作 用：替换、保存远程文件
'参 数：ConStr ------ 要替换的字符串
'参 数：StarStr ----- 前导
'参 数：OverStr ----- 
'参 数：IncluL ------ 
'参 数：IncluR ------ 
'参 数：SaveTf ------ 是否保存文件，False不保存，True保存
'参 数：SaveFilePath- 保存文件夹
'参 数: TistUrl------ 当前网页地址
'==================================================
Function ReplaceSaveRemoteFile(ConStr,StartStr,OverStr,IncluL,IncluR,SaveTf,SaveFilePath,TistUrl)
If ConStr="$False$" or ConStr="" Then
ReplaceSaveRemoteFile="$False$"
Exit Function
End If
Dim TempStr,TempStr2,ReF,Matches,Match,Tempi,TempArray,TempArray2,OverTypeArray

Set ReF = New Regexp 
ReF.IgnoreCase = True 
ReF.Global = True
ReF.Pattern = "("&StartStr&").+?("&OverStr&")"
Set Matches =ReF.Execute(ConStr) 
For Each Match in Matches
If Instr(TempStr,Match.Value)=0 Then
If TempStr<>"" then 
TempStr=TempStr & "$Array$" & Match.Value
Else
TempStr=Match.Value
End if
End If
Next 
Set Matches=nothing
Set ReF=nothing
If TempStr="" or IsNull(TempStr)=True Then
ReplaceSaveRemoteFile=ConStr
Exit function
End if
If IncluL=False then
TempStr=Replace(TempStr,StartStr,"")
End if
If IncluR=False then
If Instr(OverStr,"|")>0 Then
OverTypeArray=Split(OverStr,"|")
For Tempi=0 To Ubound(OverTypeArray) 
TempStr=Replace(TempStr,OverTypeArray(Tempi),"")
Next
Else
TempStr=Replace(TempStr,OverStr,"")
End If 
End if
TempStr=Replace(TempStr,"""","")
TempStr=Replace(TempStr,"'","")

Dim RemoteFile,RemoteFileurl,SaveFileName,SaveFileType,ArrSaveFileName,RanNum
If Right(SaveFilePath,1)="/" then
SaveFilePath=Left(SaveFilePath,Len(SaveFilePath)-1)
End If
If SaveTf=True then
If CheckDir2(SaveFilePath)=False Then
If MakeNewsDir2(SaveFilePath)=False Then
SaveTf=False
End If
End If
End If
SaveFilePath=SaveFilePath & "/"

'图片转换/保存
TempArray=Split(TempStr,"$Array$")
For Tempi=0 To Ubound(TempArray)
RemoteFileurl=DefiniteUrl(TempArray(Tempi),TistUrl)
If RemoteFileurl<>"$False$" And SaveTf=True Then'保存图片
  ArrSaveFileName = Split(RemoteFileurl,".")
  SaveFileType=ArrSaveFileName(Ubound(ArrSaveFileName))'文件类型
  RanNum=Int(900*Rnd)+100
  SaveFileName = SaveFilePath&year(now)&month(now)&day(now)&hour(now)&minute(now)&second(now)&ranNum&"."&SaveFileType  
  Call SaveRemoteFile(SaveFileName,RemoteFileurl)
ConStr=Replace(ConStr,TempArray(Tempi),SaveFileName)
ElseIf RemoteFileurl<>"$False$" and SaveTf=False Then'不保存图片
SaveFileName=RemoteFileUrl
ConStr=Replace(ConStr,TempArray(Tempi),SaveFileName)
End If
If RemoteFileUrl<>"$False$" Then
If UploadFiles="" then
UploadFiles=SaveFileName
Else
UploadFiles=UploadFiles & "|" & SaveFileName
End if
End If
Next 
ReplaceSaveRemoteFile=ConStr
End function
'==================================================
'过程名：SaveRemoteFile
'作 用：保存远程的文件到本地
'参 数：LocalFileName ------ 本地文件名
'参 数：RemoteFileUrl ------ 远程文件URL
'==================================================
Function SaveRemoteFile(LocalFileName,RemoteFileUrl)
dim Ads,Retrieval,GetRemoteData
Set Retrieval = Server.CreateObject("Microsoft.XMLHTTP")
With Retrieval
  .Open "Get", RemoteFileUrl, False, "", ""
  .Send
  GetRemoteData = .ResponseBody
End With
Set Retrieval = Nothing
Set Ads = Server.CreateObject("Adodb.Stream")
With Ads
  .Type = 1
  .Open
  .Write GetRemoteData
  .SaveToFile server.MapPath(LocalFileName),2
  .Cancel()
  .Close()
End With
Set Ads=nothing
'开始加水印
If IsObjInstalled("Persits.Jpeg") then
'call Shuiyin(LocalFileName,18,"Arial",18,18,Crzshuiyin,1,Crzshuiyincolor) '调用Crzshuiyin
call Shuiyin(LocalFileName,Crzshuiyinsize,Crzshuiyinfamily,Crzshuiyinleft,Crzshuiyinright,Crzshuiyin,0,Crzshuiyincolor) '调用Crzshuiyin
End If
end Function

'==================================================
'过程名：GetImg
'作 用：取得文章中第一张图片
'参 数：str ------ 文章内容
'参 数：strpath ------ 保存图片的路径
'==================================================
Function GetImg(str,strpath)
set objregEx = new RegExp
objregEx.IgnoreCase = true
objregEx.Global = true
zzstr=""&strpath&"(.+?)\.(jpg|gif|png|bmp)"
objregEx.Pattern = zzstr
set matches = objregEx.execute(str)
for each match in matches
retstr = retstr &"|"& Match.Value
next
if retstr<>"" then
Imglist=split(retstr,"|")
Imgone=replace(Imglist(1),strpath,"")
GetImg=Imgone
else
GetImg=""
end if
end function


'添加水印函数
Function Shuiyin(imgurl,fontsize,family,top,left,content,Horflip,Color) '调用过程名 
'例子call Shuiyin("c9cms.jpg",13,"楷体",18,18,"www.c9cms.cn",1) 
Dim Jpeg,font_size,font_family,f_content,f_Horflip 
'建立实例 
Set Jpeg = Server.CreateObject("Persits.Jpeg") 
font_size=10 
font_family="宋体" 
f_left= 5 
f_top=5 
if imgurl<>"" then 
Jpeg.Open Server.MapPath(imgurl)'图片路径并打开它 
else 
response.write "未找到图片路径" 
exit Function 
end if 
if fontsize<>"" then font_size=fontsize '字体大小 
if family<>"" then font_family=family '字体 
if top<>"" then f_left=left '水印离图片左边位置 
if left<>"" then f_top=top '水印离图片top位置 
if content="" then '水印内容 
response.write "水印什么内容呢，水印不成功！" 
exit Function 
else 
f_content=content 
end if 
' 添加文字水印 
Jpeg.Canvas.Font.Color = Color  'ff0000     '颜色
Jpeg.Canvas.Font.Family = font_family '字体
jpeg.canvas.font.size= font_size    '字体打消
Jpeg.Canvas.Font.Bold = True        '加粗
Jpeg.Canvas.Font.Quality = 4        '输出质量
If Horflip = 1 Then 
Jpeg.FlipH '图片反方向？
'Jpeg.SendBinary 
End If 
Jpeg.Canvas.Print f_left, f_top, f_content 
' 保存文件 
Jpeg.Save Server.MapPath(imgurl) 
' 注销对象 
Set Jpeg = Nothing 
'response.write "水印成功，图片上加了 "&content&"" 
End Function 


'**************************************************
'函数名：IsObjInstalled
'作  用：检查组件是否已经安装
'参  数：strClassString ----组件名
'返回值：True  ----已经安装
'        False ----没有安装
'**************************************************
Function IsObjInstalled(strClassString)
 IsObjInstalled = False
 Err = 0
 Dim xTestObj
 Set xTestObj = Server.CreateObject(strClassString)
 If 0 = Err Then IsObjInstalled = True
 Set xTestObj = Nothing
 Err = 0
End Function



'*********************************************************
'函数： DetectUrl
'功能： 替换字符串中的远程文件相对路径为以http://..开头的绝对路径
'参数： sContent 要处理的含相对路径的网页的文本内容
'sUrl： 所处理的远程网页自身的URL，用于分析相对路径
'返回： 替换相对链接为绝对链接之后的新的网页文本内容
'*********************************************************
Function DetectUrl(sContent,sUrl)
Dim re,sMatch
Set re=new RegExp
re.Multiline=True
re.IgnoreCase =true
re.Global=True
re.Pattern = "(http://[-A-Z0-9.]+)/[-A-Z0-9+&@#%~_|!:,.;/]+/"
Dim sHost,sPath
'http://localhost/get/sample.asp
Set sMatch=re.Execute(sUrl)
'http://localhost
sHost=sMatch(0).SubMatches(0)
'http://localhost/get/
sPath=sMatch(0)
re.Pattern = "(src|href)=""?((?!http://)[-A-Z0-9+&@#%=~_|!:,.;/]+)""?"
Set RemoteFile = re.Execute(sContent)
'RemoteFile 正则表达式Match对象的集合
'RemoteFileUrl 正则表达式Match对象,形如src="Upload/a.jpg"
Dim sAbsoluteUrl
For Each RemoteFileUrl in RemoteFile
'<img src="a.jpg">,<img src="f/a.jpg">,<img src="/ff/a.jpg">
If Left(RemoteFileUrl.SubMatches(1),1)="/" Then
sAbsoluteUrl=sHost
Else
sAbsoluteUrl=sPath
End If
sAbsoluteUrl = RemoteFileUrl.SubMatches(0)&"="""&sAbsoluteUrl&RemoteFileUrl.SubMatches(1)&""""
sContent=Replace(sContent,RemoteFileUrl,sAbsoluteUrl)
Next
DetectUrl=sContent
End Function

function str2q(str)
    rem 检查过滤字符为全角
    dim dist
    dist=replace(str,"'","＇")
    dist=replace(dist,chr(34),"＂")
    dist=replace(dist,"<","＜")
    dist=replace(dist,">","＞")
    dist=replace(dist,"(","（")
    dist=replace(dist,")","）")
    ''dist=replace(dist,";;","；；")
    str2q=dist
end function

function str2b(str)
    rem 检查过滤字符为半角
    dim dist
    dist=replace(str,"＇","'")
    dist=replace(dist,"＂",chr(34))
    dist=replace(dist,"＜","<")
    dist=replace(dist,"＞",">")
    dist=replace(dist,"（","(")
    dist=replace(dist,"）",")")
    ''dist=replace(dist,"；；",";;")
    str2b=dist
end function

'==================================================
'函数名：delalert
'作  用：删除弹出确认、取消对话框
'参  数：strurl--弹出信息、地址、链接显示文字，用“|”隔开。
'例  子：delalert "是否进入C9CMS|http://c9cms.cn|访问悉久"
'==================================================
Function delalert(strurl)
 dim str,mgs,del,a,b,c,d
  str=split(strurl,"|")
   mgs="温馨提示：\r\n您确定要删除吗？\r\n删除后可不能恢复的哦！"
    del="删除"
    a="<a href=""#"" onclick='if(!confirm("""
   b=""")){return false;}else{window.document.location.href="""
  c=""";}'>"
 d="</a>"
  If str(0)="" and str(1)<>"" and str(2)<>"" then
    Wstr a&mgs&b&str(1)&c&str(2)&d
    Exit Function
    Elseif str(0)="" and str(1)<>"" and str(2)="" then
    Wstr a&mgs&b&str(1)&c&del&d
    Exit Function
    Elseif str(0)<>"" and str(1)<>"" and str(2)="" then
    Wstr a&str(0)&b&str(1)&c&del&d
    Exit Function
    Elseif str(0)<>"" and str(1)<>"" and str(2)<>"" then
    Wstr a&str(0)&b&str(1)&c&str(2)&d
    Exit Function
    Else
    Wstr a&mgs&b&str(1)&c&del&d
    Exit Function
  End If
End Function

Sub Wstr(str)
    Response.Write str
End Sub

Sub CrzColor(color,str)
    If color="" then
      Wstr "<Font color=""Red"">"&str&"</Font>"
      Else
       Wstr "<Font color="""&color&""">"&str&"</Font>"
    End If
End Sub

'=================================================
'过程： Sleep
'功能： 程序在此晢停几秒
'参数： iSeconds    要暂停的秒数
'说明： 该函数暂时还未用上，可能在下个版本中用到吧!
'=================================================
Sub Sleep(iSeconds)
    Wstr "<br><font color=blue>开始暂停 "&iSeconds&" 秒</font><br>"
    Dim t:t=Timer()
    While(Timer()<t+iSeconds)
    Response.Flush '即时输出
    Response.Clear
        'Do Nothing
    Wend
    Wstr "<font color=blue>暂停 "&iSeconds&" 秒结束</font><br>"
End Sub

%>