<%
Dim sUsername, sPassword
'sUsername = "admin"
'sPassword = "85087235"

Dim aStyle()
Redim aStyle(1)
aStyle(1) = "popup||||||officexp|||../../../../public/up/fck/|||550|||350|||rar|zip|pdf|doc|xls|ppt|chm|hlp|||swf|||gif|jpg|jpeg|bmp|||rm|mp3|wav|mid|midi|ra|avi|mpg|mpeg|asf|asx|wma|mov|||gif|jpg|bmp|||5000|||3000|||500|||5000|||300|||1|||1|||EDIT|||1|||0|||0|||||||||1|||0|||V4.x,standard550,office2003,gif|||||||||0|||300|||120|||0|||...|||000000|||12|||||||||0|||jpg|jpeg|||100|||FFFFFF|||1|||1|||gif|jpg|bmp|wmz|png|||500|||100|||1|||66|||17|||5|||5|||0|||100|||100|||1|||5|||5|||88|||31|||1|||1|||1|||1|||1|||1|||1|||0"

Dim aToolbar()
Redim aToolbar(3)
aToolbar(1) = "1|||TBHandle|FormatBlock|FontName|FontSize|Bold|Italic|UnderLine|StrikeThrough|TBSep|SuperScript|SubScript|UpperCase|LowerCase|TBSep|JustifyLeft|JustifyCenter|JustifyRight|JustifyFull|||1|||1"
aToolbar(2) = "1|||TBHandle|Cut|Copy|Paste|PasteText|FindReplace|Delete|RemoveFormat|TBSep|UnDo|ReDo|SelectAll|UnSelect|TBSep|OrderedList|UnOrderedList|Indent|Outdent|ParagraphAttr|TBSep|ForeColor|BackColor|BgColor|BackImage|TBSep|RemoteUpload|LocalUpload|ImportWord|ImportExcel|||2|||2"
aToolbar(3) = "1|||TBHandle|Image|Flash|Media|File|GalleryMenu|TBSep|TableMenu|FormMenu|TBSep|Fieldset|Iframe|HorizontalRule|Marquee|CreateLink|Unlink|Map|Anchor|TBSep|Template|Symbol|Emot|Art|Excel|Quote|ShowBorders|TBSep|Save|||3|||3"
%>

<%
'// Add by cm.ivan  //
'// Time:2010-09-05 //
' if session("kmsys_admin")="" then
'    response.Write("Can't find this page!")
'    response.End()
' end if
%>
