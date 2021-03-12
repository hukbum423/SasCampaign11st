<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>

<script language="JavaScript">

/* ready */
$(document).ready(function(){

	fn_search();

});

function fn_search() {
	
	  jQuery.ajax({
		    url           : '${staticPATH }/getCampaignContentList.do',
		    dataType      : "JSON",
		    scriptCharset : "UTF-8",
		    type          : "POST",
		    data          : { },
		        success: function(result, option) {
		          if(option=="success"){
		            var list = result.CampaignContentList;
		            
		            var txt ="";
		            txt += '<table class="table table-striped table-hover table-condensed table-bordered" >';
		            if(list.length>0){
			            txt += "<colgroup>";
			            txt += '<col width="10%"/>';     
		                txt += '<col width="14%"/>';
		                txt += '<col width="17%"/>';
		                txt += '<col width="11%"/>';
		                txt += '<col width="10%"/>';
		                txt += '<col width="14%"/>';
		                txt += '<col width="10%"/>';
		                txt += '<col width="14%"/>';
			            txt += "</colgroup>";
			           
		              $.each(list, function(key){
		                var data = list[key];
		                txt += "<tr>";
		                
		                txt += "<td align=\"center\" class=\"listtd\">"+data.offer_content_id+"</td>";
		                txt += "<td align=\"left\"   class=\"listtd\"><a href=\"javascript:fn_getDetailList('"+data.offer_content_id+"', '"+data.offer_content_nm+"', '"+data.offer_content_desc+"');\" class='link'>"+nvl(data.offer_content_nm,'')+"</td>";
		                txt += "<td align=\"left\"   class=\"listtd\">"+nvl(data.offer_content_desc,'')+"</td>";
		                txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.offer_template_resue_yn,'')+"</td>";
		                txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_id,'')+"</td>";
		                txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_dt,'')+"</td>";
		                txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.update_id,'')+"</td>";
		                txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.update_dt,'')+"</td>";
		                
		                txt += "</tr>";
		              }); 
		            }else{ 
		              txt += "<td align=\"center\" class=\"listtd\" colspn=\"\8\">데이터가 없습니다.</td>"; 
		            }
		           
		            txt += "</table>";
		            
		            $("#search_layer").html(txt);	
		            
		          }else{
		            alert("에러가 발생하였습니다.");  
		          }
		        },
		        error: function(result, option) {
		          alert("에러가 발생하였습니다.");
		        }
		  });
};
//상세조회
 function fn_getDetailList(offerContentId,offerContentNm,offerContentDesc) {
	
	 $("#OFFER_CONTENT_ID").val(offerContentId);
	 $("#OFFER_CONTENT_NM").val(offerContentNm);
	 $("#OFFER_CONTENT_DESC").val(offerContentDesc);
	
	 
	 jQuery.ajax({
		    url           : '${staticPATH }/getCampaignContentsOfferlist.do',
		    dataType      : "JSON",
		    scriptCharset : "UTF-8",
		    type          : "POST",
		    data          : { offerContentId:offerContentId},
		        success: function(result, option) {
		          if(option=="success"){
		        	  var list = result.CampaignOfferList;
			            
			            var txt ="";
			            txt += '<table class="table table-striped table-hover table-condensed table-bordered" >';
			            if(list.length>0){
				            txt += "<colgroup>";
				            txt += '<col width="20%"/>';     
			                txt += '<col width="20%"/>';
			                txt += '<col width="10%"/>';
			                txt += '<col width="10%"/>';
			                txt += '<col width="20%"/>'; 
			                txt += '<col width="10%"/>'; 
			                txt += '<col width="10%"/>'; 
				            txt += "</colgroup>";
				           
			              $.each(list, function(key){
			                var data = list[key];
			                txt += "<tr>";
			                txt += "<td align=\"left\"   class=\"listtd\">"+nvl(data.campaignname,'')+"</td>";
			                txt += "<td align=\"left\"   class=\"listtd\">"+nvl(data.cellname,'')+"</td>";
			                if(data.offer_type_cd =="ZZ"){//더미오퍼일 경우
			                   txt += "<td align=\"left\"   class=\"listtd\">"+nvl(data.offer_type_nm,'')+"</td>";
			                }else{
			               	   txt += "<td align=\"left\" class=\"listtd\"><a href=\"javascript:fn_clickOffer('"+data.offer_type_cd+"', '"+data.offer_type_nm+"', '"+data.offer_sys_cd+"' , '"+data.cellid+"' , '"+data.offerid+"', '"+data.campaignid+"');\" class='link'>"+data.offer_type_nm+"</a></td>";
			                }
			               
			                txt += "<td align=\"left\"   class=\"listtd\">"+nvl(data.offer_detail_nm,'')+"</td>";
			                txt += "<td align=\"left\"   class=\"listtd\">"+nvl(data.disp_name,'')+"</td>";
			                txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_delOfferDtl('"+data.offer_type_cd+"','"+data.offer_detail_cd+"','"+data.offerid+"');\" class='link'>"+'삭제'+"</a></td>";
			                if(data.offer_type_cd !="ZZ"){//더미오퍼일 경우
			                   txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_addOfferDtl('"+data.offer_type_cd+"');\" class='link'>"+'추가'+"</a></td>";
			                }else{
		                       txt += '<td></td>';
	                         }
			                
			                txt += "</tr>";
			              }); 
			              
			            }else{ 
			            	
			              txt += "<td align=\"center\" class=\"listtd\" colspn=\"\4\"><a href=\"javascript:fn_addOfferDtl('');\" class='link'>오퍼리스트 추가</td>"; 
			            }
			            
			            txt += "</table>";
			            
			            $("#offer_layer").html(txt);
		            		          
		          }else{
		            alert("에러가 발생하였습니다.");  
		          }
		        },
		        error: function(result, option) {
		          alert("에러가 발생하였습니다.");
		        }
		  });
	//켐패인 채널 리스트  조회
	  jQuery.ajax({
		    url           : '${staticPATH }/getContentChannelInfoList.do',
		    dataType      : "JSON",
		    scriptCharset : "UTF-8",
		    type          : "POST",
		    data          : {offerContentId:offerContentId},
		        
		    success: function(result, option) {
		      if(option=="success"){ 
		    	 
		    	  //$('#channel').css('display', '');
		    	  var list = result.channel_list;
		    	  
		            var txt ="";
		            txt += "<table class='table table-striped table-hover table-condensed table-bordered' width='100%' border='0' cellpadding='0' cellspacing='0'>";
		            if(list.length>0){
		  	    	 // if(result.channelValiChk =="N"){
		  	    		//  alert("대상수준이 PCID일경우에는 토스트배너만 사용이 가능합니다");
		  	    		//  return;
		  	    	 // }else if(result.channelValChkforMobile != "Y"){
		  	    		//  alert("대상수준이 DEVICEID일 경우에는 모바일 알리미 채널만 사용이 가능합니다.");
		  	  	        //  return;
		  	    	 // }else{
		  	    		  
		  	    		var old_celid2 = "";
		  	    		var old_cellname2 = "";
		  	    		
		            	txt += "<colgroup>";
			            txt += "<col width='15%'/>";
			            txt += "<col width='15%'/>";
			            txt += "<col width=''/>";
			            txt += "<col width='10%'/>";
			            txt += "<col width='10%'/>";
			            txt += "</colgroup>";
						
			            $.each(list, function(key){
			            	 var data = list[key];
			                 txt += "<tr>";
			                 if(data.cellname != old_cellname2){
				               	txt += "<td align=\"left\" class=\"listtd\"rowspan="+data.cellrow+">"+data.cellname+"</td>";
				               }
			                 
			                 if(data.channel_nm != null){
			                   txt += "<td align=\"left\" class=\"listtd\"><a href=\"javascript:fn_clickChannel('"+data.cellid+"','"+data.channel_cd+"');\" class='link'>"+data.channel_nm+"</a></td>";
			                 }else{
			                   txt += "<td align=\"left\" class=\"listtd\"></td>";
			                 }
	                     
			                 txt += "<td align=\"left\" class=\"listtd\"";
				               if (data.channel_cd =='TOAST'){
				                   txt += "title ='"+data.toast_title+"'";
				                  }
			                   if (data.channel_cd =='SMS'){
				                   txt += "title ='"+data.sms_msg+"'";
				                  }
			                   if (data.channel_cd =='EMAIL'){
				                   txt += "title ='"+ data.email_name+"'";
				                  }
			                   if (data.channel_cd =='MOBILE'){
				                   txt += "title ='"+  data.mobile_disp_title+"'";
				                  }
			                   if (data.channel_cd =='LMS'){
				                   txt += "title ='"+  data.lms_title+"'";
				                  }
			                 txt +=">";
			                   if (data.channel_cd =='TOAST'){
				                   txt +=(data.toast_title).substring(0,45);
				                   if ((data.toast_title).substring(0,45).length>=18){
				                   txt +='...';
				                   }
				                  }
			                   if (data.channel_cd =='SMS'){
			                	   txt +=(data.sms_msg).substring(0,45);
				                   if ((data.sms_msg).substring(0,45).length>=18){
				                   txt +='...';
				                   }
				                  }
			                   if (data.channel_cd =='EMAIL'){
			                	   txt +=(data.email_name).substring(0,45);
				                   if ((data.email_name).substring(0,45).length>=18){
				                   txt +='...';
				                   }
				                  }
			                   if (data.channel_cd =='MOBILE'){
			                	   txt +=(data.mobile_disp_title).substring(0,45);
				                   if ((data.mobile_disp_title).substring(0,45).length>=18){
				                   txt +='...';
				                   }
				                  }
			                   if (data.channel_cd =='LMS'){
			                	   txt +=(data.lms_title).substring(0,45);
				                   if ((data.lms_title).substring(0,45).length>=18){
				                   txt +='...';
				                   }
				                  }
			                    txt +="</td>";
			                   //if (data.channel_cd != null && data.camp_status_cd =='EDIT'){
			                       txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_delChannel('"+data.cellid+"','"+data.channel_cd+"');\" class='link'>"+'삭제'+"</a></td>";
			                  // }else{
			                   //  txt += '<td></td>';
			                   //}
			                   if(data.cellid !=old_celid2){
				                  // if (data.camp_status_cd =='EDIT'){
				                       txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_addChannel('');\" class='link' rowspan="+data.cellrow+">"+'추가'+"</a></td>"; 
	  		                  // }else{
	                          // txt += '<td></td>';
	                         //}
			                   }else{
	                         txt += '<td></td>';
	                       }
			                   old_celid2 = data.cellid;
			                   old_cellname2 =  data.cellname;
			                 txt += "</tr>";
			            }); 
		          //  }
		            }else{
		            	 txt += "<td align=\"center\" class=\"listtd\" colspn=\"\5\"><a href=\"javascript:fn_addChannel('');\" class='link'>채널리스트 추가</td>"; 
		            }
		            txt += "</table>";
		          
		            $("#search_channel").html(txt);
		 
		      }else{
		        alert("에러가 발생하였습니다.");  
		      }
		    },
		    error: function(result, option) {
		               alert("에러가 발생하였습니다.");
		           }
		  });
	 
};
//컨텐츠 매핑 ID 생성
function fn_add(){
	
	 $("#OFFER_CONTENT_NM").val("");
	 $("#OFFER_CONTENT_DESC").val("");
	
	 jQuery.ajax({
		    url           : '${staticPATH }/getOfferContentId.do',
		    dataType      : "JSON",
		    scriptCharset : "UTF-8",
		    type          : "POST",
		    data          : { },
		    success: function(result, option) {
		             if(option=="success"){
		            	 
		          	    $("#OFFER_CONTENT_ID").val(result.offerContentId);
		            		          
		          }else{
		            alert("에러가 발생하였습니다.");  
		          }
		        },
		        error: function(result, option) {
		          alert("에러가 발생하였습니다.");
		        }
		  });
};
/* 컨텐츠 매핑 정보 등록 */
function fn_save() {
	
	if(!confirm("저장 하시겠습니까?")){
		return;
	}
	
	jQuery.ajax({
		url           : '${staticPATH }/setCampaignContent.do',
		dataType      : "JSON",
		scriptCharset : "UTF-8",
		type          : "POST",
        data          : $("#form").serialize(),
        success: function(result, option) {
        	if(option=="success"){
        		
       			 alert("저장되었습니다");
       			
       			 $("#OFFER_CONTENT_ID").val("");
       			 $("#OFFER_CONTENT_NM").val("");
       			 $("#OFFER_CONTENT_DESC").val("");
       			
       			fn_search();
       			
        	}else{
        		alert("에러가 발생하였습니다.");	
        	}
        },
        error: function(result, option) {
        	alert("에러가 발생하였습니다.");
        }
	});		
};
//오퍼 정보 삭제
function fn_delOfferDtl(offerTypeCd,offerDetailCd,offerid){
	if(!confirm("삭제 하시겠습니까?")){
		return;
	}
	
	$("#OFFER_TYPE_CD").val(offerTypeCd);
	$("#OFFER_DETAIL_CD").val(offerDetailCd);
	$("#OFFERID").val(offerid);
	jQuery.ajax({
		url           : '${staticPATH }/delCampaignContentsOffer.do',
		dataType      : "JSON",
		scriptCharset : "UTF-8",
		type          : "POST",
        data          : $("#form").serialize(),
        success: function(result, option) {

        	if(option=="success"){
        		
    			alert("삭제되었습니다");
    			location.reload();
    			
        	}else{
        		alert("에러가 발생하였습니다.");	
        	}
        },
        error: function(result, option) {
        	alert("에러가 발생하였습니다.");
        }
	});

};
//오퍼 리스트 화면 이동
function fn_addOfferDtl(offerTypeCd){
	
    var frm = document.form;
	
	pop = window.open('', 'POP_OFFER', 'top=50,left=80, location=no,status=no,toolbar=no,scrollbars=yes,width=1070,height=500');
	frm.action = "${staticPATH }/contents/CampaignContentsOfferlist.do";
	frm.target = "POP_OFFER";
	frm.method = "POST";
	frm.submit();
    pop.focus();
};
//채널 추가
function fn_addChannel()
{ 
	 var frm = document.form;
	
	window.open("about:blank", "POP_CHANNEL", "top=50,left=80, location=no,status=no,toolbar=no,scrollbars=yes,width=1070,height=500");
	frm.action = "${staticPATH }/contents/channelInfo.do";
	frm.target = "POP_CHANNEL";
	frm.method = "POST";
	frm.submit();
  
 
}
/* 채널 정보 삭제 */
function fn_delChannel(cellid, channel_cd){
	
	if(!confirm("삭제 하시겠습니까?")){
		return;
	}
	
	$("#CELLID").val(cellid);
	$("#CHANNEL_CD").val(channel_cd);
	
	var campaign_id = $("#CAMPAIGNID").val();
	jQuery.ajax({
		url           : '${staticPATH }/delChannelInfo.do',
		dataType      : "JSON",
		scriptCharset : "UTF-8",
		type          : "POST",
        data          : $("#form").serialize(),
        success: function(result, option) {

        	if(option=="success"){
        		
    			alert("삭제되었습니다");
    			location.reload();
    			
        	}else{
        		alert("에러가 발생하였습니다.");	
        	}
        },
        error: function(result, option) {
        	alert("에러가 발생하였습니다.");
        }
	});

};
/* 채널정보 상세보기(수정화면)*/
function fn_clickChannel(cellid, channel_cd){
	
	var frmChannel = document.form;
	
	$("#ChannelCELLID").val(cellid);
	$("#CHANNEL_CD").val(channel_cd);

	pop = window.open('', 'POP_CHANNEL', 'top=50,left=80, location=no,status=no,toolbar=no,scrollbars=yes');
	if(channel_cd == "TOAST"){
		frmChannel.action = "${staticPATH }/contents/channelToast.do";
	}
	if(channel_cd == "SMS"){
		frmChannel.action = "${staticPATH }/contents/channelSms.do";
	}
	if(channel_cd == "EMAIL"){
		frmChannel.action = "${staticPATH }/contents/channelEmail.do";
	}
	if(channel_cd == "MOBILE"){
		frmChannel.action = "${staticPATH }/contents/channelMobile.do";
	}
	if(channel_cd == "LMS"){
		frmChannel.action = "${staticPATH }/contents/channelLms.do";
	}
	frmChannel.target = "POP_CHANNEL";
	frmChannel.method = "POST";
	frmChannel.submit();
  pop.focus();
	
};
/* 오퍼 종류 선택시 오퍼정보 입력할수 있는 팝업창 출력 */
function fn_clickOffer(offer_type_cd, offer_type_nm,offer_sys_cd, cellid, offerid, campaignid){
  var type = offer_sys_cd + offer_type_cd;
  
  var frm = document.form;
  
  $("#CELLID").val(cellid);
  $("#OFFERID").val(offerid);
  $("#CampaignId").val(campaignid);
  $("#OFFER_TYPE_CD").val(offer_type_cd);
  $("#OFFER_TYPE_NM").val(offer_type_nm);
  if(type == "OMCU"){ //일반 쿠폰(OMCU)
     pop = window.open('', 'POP_OFFER', 'top=150,left=100, location=no,status=no,toolbar=no,scrollbars=yes');
        frm.action = "${staticPATH }/contents/offerCoupon.do";
        frm.target = "POP_OFFER";
        frm.method = "POST";
        frm.submit();
        pop.focus();
  }else if(type == "OMPN" || type == "OMMI" || type == "OMOC" || type == "OMDP"){//일반포인트(OMPN), 일반마일리지(OMMI), 일반OKCashBack(OMOC), 즉시할인(OMDP)
    pop = window.open('', 'POP_OFFER', 'top=150,left=100, location=no,status=no,toolbar=no,scrollbars=yes');
        frm.action = "${staticPATH }/contents/offerPoint.do";
        frm.target = "POP_OFFER";
        frm.method = "POST";
        frm.submit();
        pop.focus();

  }else{
    alert("오퍼 정보가 유효하지 않습니다.");
  }
};
</script>
<!--PAGE CONTENT -->
<div id="content" style="width:100%; height100%;">
  <!--BLOCK SECTION -->
  <div class="row" style="width:100%; height100%;">
    <div class="col-lg-1"></div>
      <div class="col-lg-10">
        <div class="col-md-12 page-header" style="margin-top:0px;">
          <h3>고객세그먼트 컨텐츠매핑 관리</h3>
        </div>
        <form name="form" id="form" method="post">
         <input type="hidden" id="OFFER_TYPE_CD" name="OFFER_TYPE_CD"  value="" />
         <input type="hidden" id="OFFER_TYPE_NM" name="OFFER_TYPE_NM"  value="" />
         <input type="hidden" id="OFFER_DETAIL_CD" name="OFFER_DETAIL_CD" value="" />
         <input type="hidden" id="CHANNEL_CD" name="CHANNEL_CD" value="" />
         <input type="hidden" id="CELLID" name="CELLID" value="" />
         <input type="hidden" id="OFFERID" name="OFFERID" value="" />
         <input type="hidden" id="CampaignId" name="CampaignId" value="" />
        <div class="col-md-12" style="text-align:right;margin-bottom:10px;">
           <button type="button" class="btn btn-success btn-sm" onclick="fn_add();"><i class="fa fa-plus" aria-hidden="true"></i> 컨텐츠매핑ID 생성</button>
	       <button type="button" class="btn btn-success btn-sm" onclick="fn_save();"><i class="fa fa-floppy" aria-hidden="true"></i> 저장</button>
	    </div>
	   <div id="table">
          <table class="table table-striped" width="100%" border="2" bordercolor="#D3E2EC" bordercolordark="#FFFFFF" cellpadding="0" cellspacing="0">
	        <colgroup>
	          <col width="10%"/>
	          <col width="10%"/>
	          <col width="10%"/>
	          <col width="10%"/>
	          <col width="10%"/>
	          <col width="10%"/>
	        </colgroup>
	        
	        <tr>
	          <th class="info">컨텐츠매핑ID</th>
	          <td class="tbtd_content">
	            <input type="text" id="OFFER_CONTENT_ID" name="OFFER_CONTENT_ID" value="" readonly="readonly" style="width:150px;" class="txt"/>
	          </td>
	          <th class="info">컨텐츠매핑이름</th>
	          <td class="tbtd_content">
	            <input type="text" id="OFFER_CONTENT_NM" name="OFFER_CONTENT_NM" value=""  maxlength="100" style="width:180px;" class="txt"/>
	          </td>
	          <th class="info">컨텐츠매핑설명</th>
	          <td class="tbtd_content">
	            <input type="text" id="OFFER_CONTENT_DESC" name="OFFER_CONTENT_DESC" value="" maxlength="500" style="width:200px;" class="txt"/>
	          </td>
	          </tr>
	         
          </table>
        </div>
        <!-- List -->
	    <div id="table">
	      <table class="table table-striped" width="100%" border="0" cellpadding="0" cellspacing="0">
	        <colgroup>
	          <col width="10%"/>    <!-- 컨텐츠매핑ID      -->     
	          <col width="14%"/>    <!-- 컨텐츠매핑이름   -->
	          <col width="17%"/>    <!-- 컨텐츠매핑설명   -->
	          <col width="11%"/>     <!-- 컨텐츠매핑중복사용여부 -->
	          <col width="10%"/>    <!-- 등록자 -->
	          <col width="14%"/>    <!-- 등록일시 -->
	          <col width="10%"/>    <!-- 수정자   -->
	          <col width="14%"/>    <!-- 수정일시 -->
	       
	          
	        </colgroup>     
	        <tr class="info">
	          <th style="text-align:center;">컨텐츠매핑ID</th>
	          <th style="text-align:center;">컨텐츠매핑이름</th>
	          <th style="text-align:center;">컨텐츠매핑설명</th> 
	          <th style="text-align:center;">컨텐츠매핑중복사용여부</th>
	          <th style="text-align:center;">등록자</th>
	          <th style="text-align:center;">등록일시</th>
	          <th style="text-align:center;">수정자</th>
	          <th style="text-align:center;">수정일시</th>
	        </tr>
	      </table>
	    </div>
        <div id="search_layer"></div>
        <!-- /List -->
         </form>
       <div id="optionDiv" class="col-md-12" style="margin-top:15px;">
         <ul id="myTab" class="nav nav-tabs" role="tablist">
           <li role="presentation" class="active">
                  <a data-target="#offer" role="tab" id="home-tab" data-toggle="tab" aria-controls="offer" aria-expanded="true">
                    <i class="fa fa-filter"></i> 오 퍼
                  </a>
               </li>
               <li role="presentation" class="">
                  <a data-target="#channel" role="tab" id="profile-tab" data-toggle="tab" aria-controls="channel" aria-expanded="false">
                    <i class="fa fa-comments-o"></i> 채 널
                  </a>
               </li>
         </ul>
         <div id="myTabContent" class="tab-content">
            <div role="tabpanel" class="tab-pane fade active in" id="offer" aria-labelledby="profile-tab">
                  <div id="offerList" >
                    <table class="table table-striped table-hover table-condensed" width="100%" border="0" cellpadding="0" cellspacing="0">
                       <colgroup>
             			  <col width="20%"/>				
             			  <col width="20%"/>
             			  <col width="10%"/>
             			  <col width="10%"/>
             			  <col width="20%"/>
             			  <col width="10%"/>
             			  <col width="10%"/>
             			</colgroup>  
             			  <tr class="info">
              				  <th style="text-align:center;">캠페인명</th>
              				  <th style="text-align:center;">고객 세그먼트</th>
              				  <th style="text-align:center;">오퍼종류</th>
              				  <th style="text-align:center;">오퍼상세종류</th>
              				  <th style="text-align:center;">노출명</th>
              				  <th style="text-align:center;">삭제</th>
              				  <th style="text-align:center;">추가</th>
             			   </tr>
                				
                    </table>
                  </div>
                  <div id="offer_layer"></div>
               </div>
               <div role="tabpanel" class="tab-pane fade" id="channel" aria-labelledby="profile-tab">
               <form name="frmChannel" id="frmChannel">
                  <div id="table">
                		<table class="table table-striped table-hover table-condensed" width="100%" border="0" cellpadding="0" cellspacing="0">
                			<colgroup>
                				<col width="15%"/>				
                				<col width="15%"/>
                				<col width=""/>
                				<col width="10%"/>
                				<col width="10%"/>
                			</colgroup>		  
                			<tr class="info">
                				<th align="center">고객 세그먼트</th>
                				<th align="center">채널</th>
                				<th align="center">내용</th>
                				<th align="center">삭제</th>
                				<th align="center">추가</th>
                			</tr>
                		
                		</table>
                		<table class="table table-striped table-hover table-condensed" width="100%" border="0" cellpadding="0" cellspacing="0">
                			<colgroup>
                				<col width="15%"/>				
                				<col width="15%"/>
                				<col width=""/>
                				<col width="10%"/>
                				<col width="10%"/>
                			</colgroup>		
                		</table>
                	</div>
                	<div id="search_channel">
	                </div>
                	</form>
               </div>
         </div>
       </div>        
      </div>
      <div class="col-lg-1"></div>
   </div>
   <!--END BLOCK SECTION -->
   <div class="col-lg-3"></div>
</div>
<div id="modal-testNew" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="테스트정보 등록" aria-describedby="테스트 모달">
   <div class="modal-dialog" style="width:1200px;height:700px">
      <div class="modal-content">
      </div>
   </div>
</div>
<!--END PAGE CONTENT -->
<%@ include file="/WEB-INF/views/common/_footer.jsp"%>
