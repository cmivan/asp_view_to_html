// JavaScript Document
function swf(i,j,k){
    var width = i ;
    var hight = j;
    var name = k; 
    var sTag1 = ''
        + '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width=" '
    var sTag2 = ''
        + '" height=" '
    var sTag3 = ''
        + '"> <param name="movie" value="'
    var sTag4 = ''
        + '"><param name="quality" value="tehigh">'
        + '<embed src=" '
    var sTag5 = ''
        + ' " quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width=" '
    var sTag6 = ''
        + '" height=" '
    var sTag7 = ''
        + '"></embed>'
        + '</object>'
        + '';
    document.write (sTag1 + width + sTag2 + hight + sTag3 + name + sTag4 + name + sTag5 + width + sTag6 + hight +sTag7);
}

// 新闻弹出页面

function shownews(newsid){
  window.open("NewsInfo.asp?newsid="+newsid,"_blank");
 }

// 英文新闻弹出页面

function showenews(newsid){
  window.open("En_NewsInfo.asp?newsid="+newsid,"_blank");
 }


// 产品弹出页面

function showPro(id){
  window.open("ProductInfo.asp?id="+id,"_blank");
 }

 
// 英文产品弹出页面

function showePro(id){
  window.open("En_ProductInfo.asp?id="+id,"_blank");
 }


 
// 底框

function movstar(a,time){
movx=setInterval("mov("+a+")",time)
}
function movover(){
clearInterval(movx)
}
function mov(a){
scrollx=new_date.document.body.scrollLeft
scrolly=new_date.document.body.scrollTop
scrolly=scrolly+a
new_date.window.scroll(scrollx,scrolly)
}
function o_down(theobject){
object=theobject
while(object.filters.alpha.opacity>60){
object.filters.alpha.opacity+=-10}
}
function o_up(theobject){
object=theobject
while(object.filters.alpha.opacity<100){
object.filters.alpha.opacity+=10}
}
function wback(){
if(new_date.history.length==0){window.history.back()}
else{new_date.history.back()}
}
<!--
function movstar(a,time){
	movx=setInterval("mov("+a+")",time)
	}
function movover(){
	clearInterval(movx)
	}
function mov(a){
	scrollx=new_date.document.body.scrollLeft
	scrolly=new_date.document.body.scrollTop
	scrolly=scrolly+a
	new_date.window.scroll(scrollx,scrolly)
	}
function o_down(theobject){
object=theobject
	while(object.filters.alpha.opacity>60){
		object.filters.alpha.opacity+=-10}
		}
function o_up(theobject){
object=theobject
	while(object.filters.alpha.opacity<100){
		object.filters.alpha.opacity+=10}
		}
function wback(){
	if(new_date.history.length==0){window.history.back()}
	else{new_date.history.back()}
	}

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_showHideLayers() { //v3.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
    obj.visibility=v; }
}
//-->


//function click() {
//if (event.button==2) { //改成button==2为禁止右键最好再加||button==3防止被破解如代码3
//alert('------------------------------------------------------\n对不起,未经本站允许,禁止拷贝本站信息!\n\n      感谢您对  [厦门翼讯科技]  的支持!\n\n  请记住本站永久域名:Www.YiSenCe.Com\n------------------------------------------------------')
//}
//}
//document.onmousedown=click

/* 左边隐藏显示菜单 */
function showsubleftmenu(sid)
{
	whichEl = eval("subleftmenu" + sid);
	if (whichEl.style.display == "none")
	{
		eval("subleftmenu" + sid + ".style.display=\"\";");
	}
	else
	{
		eval("subleftmenu" + sid + ".style.display=\"none\";");
	}
}
