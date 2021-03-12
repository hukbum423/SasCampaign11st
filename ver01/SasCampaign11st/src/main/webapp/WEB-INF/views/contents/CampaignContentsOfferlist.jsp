<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_pop.jsp"%>

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
	
  window.resizeTo(1060,500);
  
	if("${OFFERCODE}" =="NONE" && "${CHANNELCODE}" =="MOBILE" ){//더미오퍼일겨우 기타 선택 불가
		
		//$("#OFFER_TYPE_CD").attr("disabled",true);
		$("#OFFER_TYPE_CD").val("ZZ");
		//$("#OFFER_DETAIL_CD").attr("disabled",true);
		$("#OFFER_DETAIL_CD").html("<option value="+'"DUMMY"'+">"+"더미오퍼"+"</option>");
		//$("#DISP_NAME").addClass("essentiality");
		//$("#DISP_NAME").attr("readonly",true);
		$("#DISP_NAME").val("더미오퍼");
		
	}else{
	
	  $("#OFFER_TYPE_CD").bind("change",fn_sel_offerDtlList);
	}
	fn_search();
	
});
//초기화
function fn_init(){
	
	$("#TYPE").val("");
	$("#OFFER_TYPE_CD").attr("disabled",false);//오퍼종류
	$("#OFFER_DETAIL_CD").attr("disabled",false);//오퍼상세종류
	$("#DISP_NAME").removeClass("essentiality");//노출명
	$("#DISP_NAME").attr("readonly",false);
	$("#DISP_NAME").val("");
	$("#OFFER_TYPE_CD").val("");
	$("#OFFER_DETAIL_CD option").remove();
    $("#OFFER_DETAIL_CD").html("<option value="+""+">"+"선택"+"</option>");
    $("#offerDtlList tr").remove();
    $("#btnAdd").show();
    fn_search();
};
//오퍼종류와 오퍼상세종류 연동
function fn_sel_offerDtlList() {
	
	if($("#OFFER_TYPE_CD").val() !=""){
		
		if($("#OFFER_TYPE_CD").val()=="ZZ"){//더미오퍼일겨우 기타 선택 불가
			
//			$("#OFFER_TYPE_CD").attr("disabled",true);
//			$("#OFFER_DETAIL_CD").attr("disabled",true);
			$("#OFFER_DETAIL_CD").html("<option value="+'"DUMMY"'+">"+"더미오퍼"+"</option>");
//			$("#DISP_NAME").addClass("essentiality");
//			$("#DISP_NAME").attr("readonly",true);
			$("#DISP_NAME").val("더미오퍼");
			
		}else{
			
			 jQuery.ajax({
				    url           : '${staticPATH }/getComboOfferDtllist.do',
				    dataType      : "JSON",
				    scriptCharset : "UTF-8",
				    type          : "POST",
				    data          : $("#form").serialize(),
				        success: function(result, option) {
				          if(option=="success"){
				        	  var list = result.offer_dtl_list;
				        	  var seHtml = "";
				        	  $.each(list, function(key){ 
				        		  var data = list[key];
				        		  
				        		  seHtml += "<option value="+data.code_id+">"+data.code_name+"</option>";
						 
				        	  }); 
				        	 
				        	  $("#OFFER_DETAIL_CD").html(seHtml);
		
				          }else{
				            alert("에러가 발생하였습니다.");  
				          }
				        },
				        error: function(result, option) {
				          alert("에러가 발생하였습니다.");
				        }
				  });
			 
			 $("#DISP_NAME").val('');
	 
		}
	}else{
		
	    $("#OFFER_DETAIL_CD").html("<option value="+""+">"+"선택"+"</option>");
	    
	}
};
//행 추가
function fn_add(){
	
	$("#TYPE").val("I");
	
	if("${OFFERCODE}" =="NONE" && "${CHANNELCODE}" =="MOBILE" ){// 더미오퍼만 선택 가능
	  if($("#OFFER_TYPE_CD").val() != "ZZ"){
	    alert("오퍼종류는 더미오퍼만 가능 합니다.");
	    $("#OFFER_TYPE_CD").val("ZZ");
	    return;
	  }
	}
	  
	var offer_type_cd = $("#OFFER_TYPE_CD").val();
	var offer_type_nm = $("#OFFER_TYPE_CD  option:selected").text();
	var offer_dtl_cd = $("#OFFER_DETAIL_CD").val();
	var offer_dtl_nm = $("#OFFER_DETAIL_CD  option:selected").text();
	var disp_name  = $("#DISP_NAME").val();
	
	if(offer_type_cd ==""){
		alert("오퍼종류를 선택하세요.");
		$("#OFFER_TYPE_CD").focus();
		return false;
	}
	if(offer_dtl_cd ==""){
		alert("오퍼 상세종류를 선택하세요.");
		$("#OFFER_DETAIL_CD").focus();
		return false;
	}
/* 	
	if(disp_name ==""){
		alert("설명을 입력하세요.");
		$("#DISP_NAME").focus();
		return false;
	}
*/	
	var txt ="";
	
	if($("#OFFER_TYPE_CD").val()=="ZZ"){ 
		
	    txt += "<colgroup>";
	    txt += '<col width="20%"/>';     
	    txt += '<col width="20%"/>';
	    txt += '<col width="40%"/>';
	    txt += '<col width="20%"/>';
	    txt += "</colgroup>";
	    
	    txt += "<tr>";
	    txt += "<td align='center' class='listtd'>"+offer_type_nm+"<input type='hidden' id='OfferTypeCd' name='OfferTypeCd' value='"+offer_type_cd+"' /></td>";
	    txt += "<td align='center' class='listtd'>"+offer_dtl_nm+"<input type='hidden' id='offerTypeDtl' name='offerTypeDtl' value='"+offer_dtl_cd+"' /></td>";
	    txt += "<td align='center' class='listtd'>"+disp_name+"<input type='hidden' id='dispName' name='dispName' value='"+disp_name+"' /></td>";
	    txt += "<td align='center' class='listtd'><span onclick='javascript:fn_delete(this);' style='cursor:pointer'>"+'삭제'+"</span></td>";
	    txt += "</tr>";
    
        $("#offerDtlList").html(txt); 
        
	}else{
	  
	   var dummyCheck = "N";
  	  $("input[id^=offerTypeDtl]").each(function(index) {
  	     if($(this).val() == 'DUMMY'){
  	       dummyCheck = "Y";
  	     }
  	  }); 
  	  
  	  if(dummyCheck == "N"){
  	    txt += "<tr>";
  	    txt += "<td align='center' class='listtd'>"+offer_type_nm+"<input type='hidden' id='OfferTypeCd' name='OfferTypeCd' value='"+offer_type_cd+"' /></td>";
  	    txt += "<td align='center' class='listtd'>"+offer_dtl_nm+"<input type='hidden' id='offerTypeDtl' name='offerTypeDtl' value='"+offer_dtl_cd+"' /></td>";
  	    txt += "<td align='center' class='listtd'>"+disp_name+"<input type='hidden' id='dispName' name='dispName' value='"+disp_name+"' /></td>";
  	    txt += "<td align='center' class='listtd'><span onclick='javascript:fn_delete(this);' style='cursor:pointer'>"+'삭제'+"</span></td>";
  	    txt += "</tr>";
  	    
  	    $("#offerDtlList").append(txt);
  	  }else{
  	    alert("더미 오퍼가 등록되어 있으면 다른 오퍼를 추가 할수 없습니다.");
  	  }
	}
};
//오퍼 정보 수정/저장
function fn_save(){
	
	var offerContentId = $("#OFFER_CONTENT_ID").val();
	
	if($("#TYPE").val()=="I"){//등록일 경우
		
			if($("#offerDtlList tr").length > 5 || $("#offerDtlList tr").length<1){
				
				alert("오퍼를 최소 1개, 최대 5개만 등록할 수 있습니다.");
				
				return false;
			}
		
	}
	
	if(!confirm("저장 하시겠습니까?")){
		return;
	}
	
	jQuery.ajax({
		url           : '${staticPATH }/setCampaignContentsOffer.do',
		dataType      : "JSON",
		scriptCharset : "UTF-8",
		type          : "POST",
        data          : $("#form").serialize(),
        success: function(result, option) {
        	if(option=="success"){
        		
       			 alert("저장되었습니다");
       		     //부모창 재조회
     			   opener.fn_getDetailList(offerContentId);
     			   //top.closeOfferAddFrame();
     			   window.close();
       			
        	}else{
        		alert("에러가 발생하였습니다.");	
        	}
        },
        error: function(result, option) {
        	alert("에러가 발생하였습니다.");
        }
	});
	
};
/* 행  삭제*/
function fn_delete(nowTr){
	
   $(nowTr).parent().parent().remove();
};
//오퍼 정보 조회
function fn_search(){
	
	jQuery.ajax({
	    url           : '${staticPATH }/getCampaignContentsOfferlist.do',
	    dataType      : "JSON",
	    scriptCharset : "UTF-8",
	    type          : "POST",
	    data          : { offerContentId: $("#OFFER_CONTENT_ID").val()},
	        success: function(result, option) {
	          if(option=="success"){
	        	  var list = result.CampaignOfferList;
		          var txt ="";
		             
		            if(list.length>0){
		            	 txt += "<colgroup>";
		            	 txt += '<col width="20%"/>';     
		            	 txt += '<col width="20%"/>';    
		            	 txt += '<col width="40%"/>';    
		            	 txt += '<col width="20%"/>';   
		            	 txt += "</colgroup>";     
		            	 
		            	 $("#OFFER_TYPE_CD option[value='ZZ']").remove();//오퍼 정보 존재할 경우 더미오퍼 선택 불가
		            	 
		              $.each(list, function(key){
		                var data = list[key];
		                txt += "<tr>";
		                txt += "<td align='center'   class='listtd'>"+nvl(data.offer_type_nm,'')+"</td>";
		                txt += "<td align='center'   class='listtd'>"+nvl(data.offer_detail_nm,'')+"</td>";
		                txt += "<td align='center'   class='listtd'><a href=\"javascript:fn_updDispName('"+data.offer_type_cd+"','"+data.offer_detail_cd+"','"+data.offer_detail_nm+"','"+data.disp_name+"');\" class='link'>"+nvl(data.disp_name,'')+"</td>";
		                txt += "<td></td>";
		                txt += "</tr>";
		              }); 
		            	 
		            }else{ 
		             
		            }
		          
		            $("#offerDtlList").append(txt);
		            
                //document.body.scrollIntoView(true);
                //parent.document.all.offerAddFrame.height = document.body.scrollHeight;
                opener.setIFrameHeight('offer');
	            		          
	          }else{
	            alert("에러가 발생하였습니다.");  
	          }
	        },
	        error: function(result, option) {
	          alert("에러가 발생하였습니다.");
	        }
	  }); 

};
//노출명 수정
function fn_updDispName(offerTypeCd,offerDetailCd,offerDetailNm,dispName){
	
	$("#TYPE").val("U");
	
	$("#OFFER_TYPE_CD").val(offerTypeCd);
	$("#offer_Type_Cd").val(offerTypeCd);
	$("#offer_Detail_Cd").val(offerDetailCd);
	$("#DISP_NAME").val(dispName);
	
	$("#OFFER_TYPE_CD").attr("disabled",true);
	$("#OFFER_DETAIL_CD").attr("disabled",true);
	
	$("#OFFER_DETAIL_CD").html("<option value="+offerDetailCd+">"+offerDetailNm+"</option>");
	
	$("#btnAdd").hide();
	
}
</script>
<!--PAGE CONTENT -->
<div id="content" style="width:100%; height100%;">
  <!--BLOCK SECTION -->
  <div class="row" style="width:100%; height100%;">
    <div class="col-lg-1"></div>
      <div class="col-lg-10">
        <div class="col-md-12 page-header" style="margin-top:0px;">
          <h3>오퍼리스트 관리</h3>
        </div>

        <form name="form" id="form" method="post">
        <input type="hidden" id="TYPE" name="TYPE" value="" />
        <input type="hidden" id="OFFER_CONTENT_ID" name="OFFER_CONTENT_ID" value="${OFFER_CONTENT_ID}" />
         <input type="hidden" id="offer_Type_Cd" name="offer_Type_Cd" value="" />
         <input type="hidden" id=offer_Detail_Cd name="offer_Detail_Cd" value="" />
	   <div id="table">
          <table class="table table-striped" width="100%" border="2" bordercolor="#D3E2EC" bordercolordark="#FFFFFF" cellpadding="0" cellspacing="0">
	       <colgroup>
             			  <col width="15%"/>				
             			  <col width="15%"/>
             			  <col width="15%"/>
             			  <col width="15%"/>
             			  <col width="15%"/>
             			  <col width="15%"/>
             			  <col width="10%"/>
             			  <col width="10%"/>
             			</colgroup>  
	        <tr>
	           <td class="info">컨텐츠매핑ID</td>
			   <td class="tbtd_content">${OFFER_CONTENT_ID}</span>
			   </td>
	           <td class="info">오퍼종류</td>
			   <td class="tbtd_content">
				  <select id="OFFER_TYPE_CD" name="OFFER_TYPE_CD"  style="width:80px;">
				     <option value="">선택</option>
					   	<c:forEach var="val" items="${offer_list}">
						 	  <option value="${val.code_id}">
										${val.code_name}
							  </option>
						   </c:forEach>			
				  </select>
			   </td>
			    <td class="info">오퍼 상세종류</td>
			   <td class="tbtd_content">
				  <select id="OFFER_DETAIL_CD" name="OFFER_DETAIL_CD"  style="width:100px;">
				    <option value="">선택</option>
				  </select>
			   </td>
			   <td class="info">설명</td>
			   <td class="tbtd_content">
			      <input type="text" id="DISP_NAME" name="DISP_NAME" style="width:150px;" class="txt"/>
			   </td>
	        </tr>
          </table>
        </div>
        <div class="col-md-12" style="text-align:right;margin-bottom:10px;">
           <button type="button" id="btnAdd" class="btn btn-success btn-sm" onclick="fn_add();"><i class="fa fa-plus" aria-hidden="true"></i> 추가</button>
	       <button type="button" class="btn btn-success btn-sm" onclick="fn_save();"><i class="fa fa-floppy" aria-hidden="true"></i> 저장</button>
	       <button type="button" class="btn btn-info btn-sm" onclick="fn_init();">
          <i class="fa fa-undo" aria-hidden="true"></i> 초기화
        </button>
	    </div>
        <!-- List -->
	    <div id="table">
	      <table class="table table-striped table-hover table-condensed table-bordered" border = '1'>
	        <colgroup>
	         
	          <col width="20%"/>    <!-- 컨텐츠매핑설명   -->
	          <col width="20%"/>     <!-- 컨텐츠매핑중복사용여부 -->
	          <col width="40%"/>    <!-- 등록자 -->   
	          <col width="20%"/>    <!-- 등록자 -->   
	        </colgroup>     
	        <tr class="info">
	          
	          <th style="text-align:center;">오퍼종류</th>
	          <th style="text-align:center;">오퍼상세종류</th>
	          <th style="text-align:center;">설명</th>
	          <th style="text-align:center;">삭제</th>
	        
	        </tr>
	      </table>
	    </div>
        <div id="offerList_layer">
         <table class="table table-striped table-hover table-condensed table-bordered" id = 'offerDtlList' border = '1'>
              <colgroup>
                <col width="20%"/>   
                <col width="20%"/> 
           	    <col width="40%"/>
           	    <col width="20%"/>
           	  </colgroup> 
         </table>
             
        </div>
        <!-- /List -->
       
        </form>  
      
      </div>
      <div class="col-lg-1"></div>
   </div>
   <!--END BLOCK SECTION -->
   <div class="col-lg-3"></div>
</div>

<!--END PAGE CONTENT -->

