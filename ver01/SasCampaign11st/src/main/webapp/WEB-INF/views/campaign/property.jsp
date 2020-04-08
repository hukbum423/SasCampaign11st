<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_modal.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="${staticPATH }/css/ui-lightness/jquery-ui.css">
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>

<script language="JavaScript">


$(document).ready(function(){

   // =================================================
	// 화면타이틀값 : 메뉴명칭
	
   // 		=================================================

	$( "#CAMP_BGN_DT_1" ).datepicker(dateOption);
	$( "#CAMP_END_DT_1" ).datepicker(dateOption);
	
	$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; margin-bottom:-2px; vertical-align:middle;");

	///수정중이 아닐경우 저장 불가능
	if("${bo.camp_status_cd}" == "START"){
		$("#btn_save").hide();
	}
	
	//캠페인 기간 라디오 버튼 클릭 이벤트
	$("input[name=CAMP_TERM_CD]").bind("click",fn_radioClick);
	
	//캠페인기간 선택 이벤트 호출
	fn_radioClick();
	
	//수동전송여부 선택시 채널우선순위적용여부 선택 이벤트
	$("#MANUAL_TRANS_YN").bind("change",fn_maualTransYnClick);
	
	//수동전송여부 선택시 채널우선순위적용여부 선택 이벤트
	$("#CHANNEL_PRIORITY_YN_1").bind("change",fn_channelPriorityYnClick);

	//오늘날짜 가져오기
	getToday();
	
	//캠페인기간 종료일의 시, 분을 23시 59분으로 설정
	if("${bo.camp_end_dt2}" == ""){
		$("#CAMP_END_DT2").val("23");
		$("#CAMP_END_DT3").val("59");
	}
	
});


//라디오 버튼 클릭 이벤트
function fn_radioClick(){
	
	var val = $("input:radio[name=CAMP_TERM_CD]:checked").val();

	if(val=="01"){ //From ~ To
		
		if($("#MANUAL_TRANS_YN").val() == "T"){
			alert("데이터전송방식이 Time 일 경우 캠페인 기간 From ~ To 방식은 사용할 수 없습니다.");
			
			// 캠페인 기간 전송일로부터 방식 선택
			$("input[name=CAMP_TERM_CD]").attr("checked",true);
			return false;
		}
		$("#CAMP_BGN_DT_1" ).datepicker("enable");
		$("#CAMP_END_DT_1" ).datepicker("enable");
		$("#CAMP_BGN_DT_1").removeClass("essentiality");
		$("#CAMP_END_DT_1").removeClass("essentiality");
		$("#CAMP_BGN_DT2").attr("disabled",false);
		$("#CAMP_END_DT2").attr("disabled",false);
		$("#CAMP_BGN_DT3").attr("disabled",false);
		$("#CAMP_END_DT3").attr("disabled",false);
		
		$("#CAMP_TERM_DAY1").addClass("essentiality");
		$("#CAMP_TERM_DAY1").attr("readonly",true);
	}else{ //자동 증가입력
		$("#CAMP_BGN_DT_1" ).datepicker("disable");
		$("#CAMP_END_DT_1" ).datepicker("disable");
		$("#CAMP_BGN_DT_1" ).addClass("essentiality");
		$("#CAMP_END_DT_1" ).addClass("essentiality");
		$("#CAMP_BGN_DT2").attr("disabled",true);
		$("#CAMP_END_DT2").attr("disabled",true);
		$("#CAMP_BGN_DT3").attr("disabled",true);
		$("#CAMP_END_DT3").attr("disabled",true);
		
		$("#CAMP_TERM_DAY1").attr("readonly",false);
		$("#CAMP_TERM_DAY1").removeClass("essentiality");
	}
}


//수동전송여부 선택 이벤트
function fn_maualTransYnClick(){
	if($("#MANUAL_TRANS_YN").val() == "Y"){
		$("#CHANNEL_PRIORITY_YN_1").val("N") ;
	}
	
	// 데이터전송방식 'Time' 선택시
	if($("#MANUAL_TRANS_YN").val() == "T"){
		
		// 캠페인 기간 From ~ To Disable 처리
		$("#CAMP_BGN_DT_1" ).datepicker("disable");
		$("#CAMP_END_DT_1" ).datepicker("disable");
		$("#CAMP_BGN_DT_1" ).addClass("essentiality");
		$("#CAMP_END_DT_1" ).addClass("essentiality");
		$("#CAMP_BGN_DT2").attr("disabled",true);
		$("#CAMP_END_DT2").attr("disabled",true);
		$("#CAMP_BGN_DT3").attr("disabled",true);
		$("#CAMP_END_DT3").attr("disabled",true);
		
		$("#CAMP_TERM_DAY1").attr("readonly",false);
		$("#CAMP_TERM_DAY1").removeClass("essentiality");
		
		// 캠페인 기간 전송일로부터 방식 선택
		$("input[name=CAMP_TERM_CD]").attr("checked",true);
		
		// 채널우선순위적용 'N' 선택
		$("#CHANNEL_PRIORITY_YN_1").val("N");
		
	}
}


//채널우선순위적용여부 체크
function fn_channelPriorityYnClick(){
	if($("#MANUAL_TRANS_YN").val() == "Y" && $("#CHANNEL_PRIORITY_YN_1").val() !="N"){
		alert("수동전송일경우 채널우선순위는 [N] 이여야 합니다");
		$("#CHANNEL_PRIORITY_YN_1").val("N");
		$("#CHANNEL_PRIORITY_YN_1").focus();
		return false;		
	}
	
	// 데이터전송방식이 Time 일 경우 우선순위적용은 'N' 으로 설정
	if($("#MANUAL_TRANS_YN").val() == "T"){
		alert("데이터전송방식이 Time 일 경우 채널우선순위적용을 할 수 없습니다.");
		$("#CHANNEL_PRIORITY_YN_1").val("N");
		$("#CHANNEL_PRIORITY_YN_1").focus();
		return false;
	}
}


/* 조회 */
function fn_search() {
	var frm = document.form;
	
   	frm.action = "${staticPATH }/campaign/campaignList.do";
   	frm.target = "_self";
       frm.submit();
};




/* 등록 */
function fn_save() {
	
	//유효성 체크
	if(!fn_validation()){
		return;
	}
	
	
	jQuery.ajax({
		url           : '${staticPATH }/setCampaignInfo.do',
		dataType      : "JSON",
		scriptCharset : "UTF-8",
		type          : "POST",
        data          : $("#frm").serialize(),
        success: function(result, option) {

        	if(option=="success"){
        		
        		if(result.CMP_STATUS == "START"){
        			alert("진행중인 캠페인은 수정할수 없습니다.");
        		}else{
        			alert("저장되었습니다");
        			fn_search();
        		}
	        	
        	}else{
        		alert("에러가 발생하였습니다.");	
        	}
        },
        error: function(result, option) {
        	alert("에러가 발생하였습니다.");
        }
	});
	
};	



/* 유효성 체크 */
function fn_validation() {
	var val = $("input:radio[name=CAMP_TERM_CD]:checked").val();
	
	
	if("${bo.camp_status_cd}" == "START"){
		$("#btn_save").hide();
		alert("진행중인 캠페인은 수정할수 없습니다.");
		return false;
	}
	
	if(val=="01"){ //From ~ To
		
		if($("#CAMP_BGN_DT_1").val()==""){
			alert("캠페인기간 시작일을 입력하세요");
			$("#CAMP_BGN_DT_1").focus();
			return false;
		}
	
		if($("#CAMP_END_DT_1").val()==""){
			alert("캠페인기간 종료일을 입력하세요");
			$("#CAMP_END_DT_1").focus();
			return false;
		}
		
		var dt1 = $("#CAMP_BGN_DT_1").val() + $("#CAMP_BGN_DT2 option:selected").text() +  $("#CAMP_BGN_DT3 option:selected").text();
		var dt2 = $("#CAMP_END_DT_1").val() + $("#CAMP_END_DT2 option:selected").text() +  $("#CAMP_END_DT3 option:selected").text();
		
		if(dt1>dt2){
			alert("캠페인 종료일은 시작일보다 커야합니다.");
			$("#CAMP_END_DT_1").focus();
			return false;
		}
	
		//캠페인 시작일이 오늘보다 작을경우 에러처리
		if( $("#CAMP_BGN_DT_1").val() < $("#TO_DATE").val() && $("#MANUAL_TRANS_YN").val() == "N"){
			alert("캠페인 시작일은 오늘 이후부터 가능합니다");
			$("#CAMP_BGN_DT_1").focus();
			return false;			
		}
		
		//채널우선순위적용이  "Y"일경우 캠페인 시작일은 to_date +1일보다 작아야 한다(클경우 에러처리)
		if($("#CHANNEL_PRIORITY_YN_1").val() == "Y"){
			
    		if( $("#CAMP_BGN_DT_1").val() < $("#TO_DATE_P1").val()){
    			alert("채널우선순위 적용일경우 캠페인 시작일은 최소 " + $("#TO_DATE_P1").val() +" 이후\n(오늘 +1일) 이여야 합니다");
    			$("#CAMP_BGN_DT_1").focus();
    			return false;
    		} 
		}
		
	}else{

		if($("#CAMP_TERM_DAY1").val()==""){
			alert("캠페인기간을 입력하세요");
			$("#CAMP_TERM_DAY1").focus();
			return false;
		}
		
	}
	
	//수동전송일 경우 채널우선순위는 "N"만 가능함
	if($("#MANUAL_TRANS_YN").val() == "Y" && $("#CHANNEL_PRIORITY_YN_1").val() != "N" ){
		alert("수동전송일경우 채널우선순위는 [N] 이여야 합니다");
		$("#CHANNEL_PRIORITY_YN_1").focus();
		return false;			
	}
	
	
	//채널우선순위적용여부가 변경됬을경우
	if("${bo.channel_priority_yn}" != null &&"${bo.channel_priority_yn}" != $("#CHANNEL_PRIORITY_YN_1").val()){
		
		if("${bo.channelCnt}" > 0){ //채널정보가 존재할경우 경고 alert
			if($("#CHANNEL_PRIORITY_YN_1").val() == "Y"){ //N -> Y 변경됨(채널에 우선순위는 5로 바뀜)
				if(!confirm("모든 채널의 우선순위가 [5]로 적용됩니다.\n저장 하시겠습니까?")){
					return false;
				}else{
					$("#CHANNEL_CMD").val("NtoY");
				}
			}
			else if($("#CHANNEL_PRIORITY_YN_1").val() == "N"){ //Y -> N 변경됨(채널에 우선순위는 N으로 바뀜)
				if(!confirm("모든 채널의 우선순위가 [N]으로 적용됩니다.\n저장 하시겠습니까?")){
					return false;
				}else{
					$("#CHANNEL_CMD").val("YtoN");
				}
			}
		}
	}else{
		if(!confirm("저장 하시겠습니까?")){
			return false;
		}
	}
		
	return true;
}


//오늘 날짜 가져오기
function getToday(){
	jQuery.ajax({
		url           : '${staticPATH }/getToday.do',
		dataType      : "JSON",
		scriptCharset : "UTF-8",
		type          : "POST",
        data          : {},
        success: function(result, option) {

        	if(option=="success"){
        		
        		$("#TO_DATE").val(result.TO_DATE) ;
        		$("#TO_DATE_P1").val(result.TO_DATE_P1) ;
        		
        	}else{
        		alert("에러가 발생하였습니다.");	
        	}
        },
        error: function(result, option) {
        	alert("에러가 발생하였습니다.");
        }
	});		
}
</script>
<!--PAGE CONTENT -->
<div id="content" style="width:100%; height100%;">
   <!--BLOCK SECTION -->
   <div class="row" style="width:100%; height100%;">
      <div class="col-md-1"></div>
      <div class="col-md-10">
         <div class="col-md-12 page-header" style="margin-top:0px;">
            <h3>캠페인 속성</h3>
         </div>
		 <form name="frm" id="frm">
		    <input type="hidden" id="TO_DATE" name="TO_DATE" value="" />
		    <input type="hidden" id="TO_DATE_P1" name="TO_DATE_P1" value="" />
		    <input type="hidden" id="CAMPAIGNCODE" name="CAMPAIGNCODE" value="${bo.campaigncode}" />
		    <input type="hidden" id="CAMPAIGNID" name="CAMPAIGNID" value="${bo.campaignid}" />
		    <input type="hidden" id="CHANNEL_CMD" name="CHANNEL_CMD" value="" />
            <div id="table">
		       <table class="table table-striped table-hover table-condensed">
			      <colgroup>
					 <col width="15%"/>
					 <col width="35%"/>
                     <col width="15%"/>
                     <col width="35%"/>
				  </colgroup>
				  <tr>
					 <td class="info">캠페인명</td>
					 <td class="tbtd_content">
						${bo.campaignname}
					 </td>
					 <td class="info">캠페인코드</td>
					 <td class="tbtd_content">
						${bo.campaigncode}
					 </td>
				  </tr>
			      <tr>
					 <td class="info">캠페인기간</td>
					 <td class="tbtd_content" colspan="3">
					    <div style="display:inline;">
					       <input type="radio" name="CAMP_TERM_CD" value="01" checked="checked"/>
						   <input type="text" id="CAMP_BGN_DT_1" name="CAMP_BGN_DT_1" style="width:75px;" value="${bo.camp_bgn_dt1}" readonly="readonly"/>
						   <select id="CAMP_BGN_DT2" name="CAMP_BGN_DT2" style="width: 45px;">
							  <c:forEach var="val" varStatus="i" begin="00" end="23" step="1">
								 <option value="${val}"  <c:if test="${bo.camp_bgn_dt2 eq val }">selected="selected"</c:if>>
								   <c:if test="${val < 10}">0</c:if><c:out value="${val}" />
								 </option>
							  </c:forEach>
						   </select>
					  	       시
						   <select id="CAMP_BGN_DT3" name="CAMP_BGN_DT3" style="width: 45px;">
							  <c:forEach var="val" varStatus="i" begin="00" end="59" step="1">
								 <option value="${val}" <c:if test="${bo.camp_bgn_dt3 eq val }">selected="selected"</c:if>>
								    <c:if test="${val < 10}">0</c:if><c:out value="${val}" />
								 </option>
							  </c:forEach>
						   </select>
						       분
					 	   ~
						   <input type="text" id="CAMP_END_DT_1" name="CAMP_END_DT_1" style="width:75px;" value="${bo.camp_end_dt1}" readonly="readonly"/>
						   <select id="CAMP_END_DT2" name="CAMP_END_DT2" style="width: 45px;">
							  <c:forEach var="val" varStatus="i" begin="00" end="23" step="1">
								 <option value="${val}" <c:if test="${bo.camp_end_dt2 eq val}">selected="selected"</c:if>>
								    <c:if test="${val < 10}">0</c:if><c:out value="${val}" />
								 </option>
							  </c:forEach>
						   </select>
						      시
						   <select id="CAMP_END_DT3" name="CAMP_END_DT3" style="width: 45px;">
							  <c:forEach var="val" varStatus="i" begin="00" end="59" step="1">
								 <option value="${val}"  <c:if test="${bo.camp_end_dt3 eq val}">selected="selected"</c:if>>
								    <c:if test="${val < 10}">0</c:if><c:out value="${val}" />
								 </option>
							  </c:forEach>
						   </select>
						      분						
					    </div>
					    <div style="margin-top: 5px;">
						   <input type="radio" name="CAMP_TERM_CD" value="02" <c:if test="${bo.camp_term_cd eq '02'}">checked="checked"</c:if>/>
						   <sapn>
							 전송일로 부터 <input type="text" id="CAMP_TERM_DAY1" name="CAMP_TERM_DAY1" style="width:65px;" value="${bo.camp_term_day}" onkeydown="javascript:keypressNumber();" maxlength="3" /> 일 까지
						   </sapn>
					    </div>
				     </td>
		       	  </tr>
			      <tr>
				     <td class="info">대상수준</td>
					 <td class="tbtd_content">
					    <select id="AUDIENCE_CD" name="AUDIENCE_CD"  style="width:105px;">
						   <c:forEach var="val" items="${audience_list}">
						 	  <option value="${val.code_id}"  <c:if test="${bo.audience_cd eq val.code_id }">selected="selected"</c:if> >
										${val.code_name}
							  </option>
						   </c:forEach>					
						</select>
					 </td>
				     <td class="info">데이터전송방식</td>
				     <td class="tbtd_content">
					    <select id="MANUAL_TRANS_YN" name="MANUAL_TRANS_YN" style="width:75px;">
					       <c:forEach var="val" items="${manual_trans_list}">
							  <option value="${val.code_id}"  <c:if test="${bo.manual_trans_yn eq val.code_id }">selected="selected"</c:if> >
									${val.code_name}
							  </option>
						  </c:forEach>
						</select>
				     </td>
			      </tr>
			      <tr>
					 <td class="info">오퍼자동 적용여부</td>
					 <td class="tbtd_content">
					    <select id="OFFER_DIRECT_YN_1" name="OFFER_DIRECT_YN_1" style="width:45px;">
						   <option value="N" <c:if test="${bo.offer_direct_yn eq 'N' }">selected="selected"</c:if>>N</option>
					   	   <option value="Y" <c:if test="${bo.offer_direct_yn eq 'Y' }">selected="selected"</c:if>>Y</option>
					    </select>
					 </td>
					 <td class="info">채널우선순위적용</td>
					 <td class="tbtd_content">
						<select id="CHANNEL_PRIORITY_YN_1" name="CHANNEL_PRIORITY_YN_1" style="width:45px;">
						   <option value="Y" <c:if test="${bo.channel_priority_yn eq 'Y' }">selected="selected"</c:if>>Y</option>
						   <option value="N" <c:if test="${bo.channel_priority_yn eq 'N' }">selected="selected"</c:if>>N</option>
					    </select>
					 </td>
				  </tr>			
				  <tr>
					 <td class="info">등록자</td>
					 <td class="tbtd_content">${bo.create_nm}</td>
					 <td class="info">등록일시</td>
				 	 <td class="tbtd_content">${bo.create_dt}</td>
				  </tr>
				  <tr>
					 <td class="info">수정자</td>
					 <td class="tbtd_content">${bo.update_nm}</td>
					 <td class="info">수정일시</td>
					 <td class="tbtd_content">${bo.update_dt}</td>
			 	  </tr>
		       </table>
	        </div>	
			<div id="sysbtn" class="col-md-12" style="text-align:right;margin-bottom:10px;">
		       <button type="button" class="btn btn-default btn-sm" onclick="window.close();"><i class="fa fa-times" aria-hidden="true"></i> Close</button>
		       <button type="button" class="btn btn-danger btn-sm" onclick="fn_save();"><i class="fa fa-floppy-o" aria-hidden="true"></i> 저 장 </button>
	 	    </div>
	     </form>	
      </div>
      <div class="col-md-1"></div>
   </div>
   <!--END BLOCK SECTION -->
   <div class="col-lg-3"></div>
</div>
<!--END PAGE CONTENT -->
                      
     