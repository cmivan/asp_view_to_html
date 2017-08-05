//定义鼠标移过样式
$(function(){
	
	$(".type_box").find(".typeitem").hover(
	   function(){$(this).css({"background-color":"#fff","border":"#F90 1px solid"});},
	   function(){$(this).css({"background-color":"","border":"#ccc 1px solid"});}
	);
		
	
//单条信息删除	
  $("a.del_item").click(function(){
	 var thisid =$(this).attr("id");
	 var thisnum=$(this).parent().parent().find("span.num").text();
	 var thisok=true;
	 var thisstr="确定要删除该栏目/页面吗？";
	 if(parseInt(thisnum)==thisnum){
	    if(thisnum>0){
		   thisok=false;
		}else{
		   thisok=true;	
		}
	 }else{
		thisok=true;	
	 }
	 
	 if(thisok==false){thisstr = "该栏目下还有 "+thisnum+" 条记录，"+thisstr;}
	 
	 if(confirm(thisstr)){
	   var thislink=$(this).attr("link");
	   $(this).attr("href",thislink);
	   return true;		
	 }else{
	   return false; 
	 }
	});
	 

//全选或取消列表项
  $("#delsel").click(function(){
	 var thischeck=$(this).attr("checked");
	 $(".delitem").attr("checked",thischeck);
	 });
	 
  $("#del_checkbox").click(function(){
	 var thischeck=$(this).attr("checked");
	 $(".del_id").attr("checked",thischeck);
	 });

  $("#Submit_delsel").click(function(){
	  if(ischecked()){
		if(confirm("确定要删除选中项?")){
			return true;
		}else{
			return false;	
		}
	  }else{
		return false;
	  }
	});
	


	
});


/*判断是否选中项*/
function ischecked(){
	var thisis=false;
	$(".del_id").each(function(){
		if(thisis==false){
			var thischecked=$(this).attr("checked");
			if(thischecked){thisis=true;}
			}
		});
	if(thisis==false){alert("至少要选择一项!");}
	return thisis;
	}