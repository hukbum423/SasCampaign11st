<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_pop.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<link href="${staticPATH }/css/jquery_1.9.2/base/jquery-ui-1.9.2.custom.css" rel="stylesheet">

<script src="${staticPATH }/js/common/jquery.min.js" type="text/javascript"></script>
<script src="${staticPATH }/js/jquery_1.9.2/jquery-ui-1.9.2.custom.js" type="text/javascript"></script>

<%-- <script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script> --%>

<script language="JavaScript">

	window.resizeTo(1080,820);

	$(document).ready(function(){
	  /*
		if("${bo.channel_priority_yn}" == "N" && "${user.title}" != "N"){
			alert("해당캠페인은 채널우선순위적용이 [N]입니다\n사용자는 권한이 없으므로 채널정보를 입력할수 없습니다");			
		}
		*/
		
		   $("#SMS_DISP_DT").datepicker({
			      showOn: "button",
			      buttonImage: "${staticPATH }/image/calendar.gif",
			      buttonImageOnly: true,
			      buttonText: "Select date"
			    });
		
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; margin-bottom:-2px; vertical-align:middle;");
		
		if("${bo.camp_term_cd}" == "02"){ //캠페인 기간구분이 반복일경우 노출일 disable
			$("#SMS_DISP_DT" ).datepicker("disable");
			$("#SMS_DISP_DT" ).addClass("essentiality");
		}

		//사용자 변수 더블클릭 이벤트
		$("#VAL_LIST").dblclick(function(){
			$("#SMS_INPUT_MSG").focus();
			
			if(document.selection){
	  			cRange = document.selection.createRange();
	  			cRange.text = "{" + $("#VAL_LIST").val() + "}";
				}else{
				  $("#SMS_INPUT_MSG").val($("#SMS_INPUT_MSG").val() + "{" + $("#VAL_LIST").val() + "}");
				}
		});
		
		//채널선택시 페이지 이동
		$("#CHANNEL_CD").bind("change",fn_selectChannel);
		
		
		//완료시 전달번호 대상자 체크
		var retrun_call = "${bo.sms_returncall}".split(";"); 
		for( var i =0; i < $(":checkbox[name='SMS_RETURNCALL']").length; i++ ){	//	
			for( var j =0; j < retrun_call.length; j++ ){ 

				if( $(":checkbox[name='SMS_RETURNCALL']").eq(i).val() == retrun_call[j] ){
					$(":checkbox[name='SMS_RETURNCALL']").eq(i).attr("checked",true);
				}
			}
		}
		
		//입력문자 길이 계산
		textCounter(document.form.SMS_INPUT_MSG,document.form.remChars, 80);
		
		//발송시간 설정
		fn_set_smsSendTime();
		
		//우선순위에 따른 발송시간 설정
		fn_chk_smsSendTime();
		$("#SMS_PRIORITY_RNK").bind("change",fn_chk_smsSendTime);

		// 기존에 저장된 채널발송시간이 있을 경우 선택
		if ( "${bo.sms_disp_time}" != '' ){
			$("#SMS_DISP_TIME").val("${bo.sms_disp_time}");
		}
		
		// 캠페인 데이터 전송방식이 Manual 또는 Time 일 경우 발송시간 항목 disable 처리
		if ( "${bo.manual_trans_yn}" == 'Y' || "${bo.manual_trans_yn}" == 'T'){
			$("#SMS_DISP_TIME").attr("disabled",true);
		}
		
		opener.setIFrameHeight('channel');
	});

	 function text_box_insert_text(obj_text_box, text) {
		    if (obj_text_box.createTextRange && obj_text_box.currentPos) {
		    var currentPos = obj_text_box.currentPos;
		    currentPos.text = currentPos.text.charAt(currentPos.text.length - 1) == ' ' ? text + ' ' : text;
		  }
		  }	
	//채널 선택
	function fn_selectChannel(){
		
		var frm = document.form;
		
		if($("#CHANNEL_CD").val() == "SMS"){
			frm.action = "${staticPATH }/contents/channelSms.do";
			frm.submit();
		}
		
		if($("#CHANNEL_CD").val() == "EMAIL"){
			frm.action = "${staticPATH }/contents/channelEmail.do";
			frm.submit();
		}
		
		if($("#CHANNEL_CD").val() == "TOAST"){
			frm.action = "${staticPATH }/contents/channelToast.do";
			frm.submit();
		}
		
		if($("#CHANNEL_CD").val() == "MOBILE"){
			frm.action = "${staticPATH }/contents/channelMobile.do";
			frm.submit();
		}
		if($("#CHANNEL_CD").val() == "LMS"){
			frm.action = "${staticPATH }/contents/channelLms.do";
			frm.submit();
		}
	}
	
	
	
	/* 등록 */
	function fn_save() {
		
		var offerContentId = $("#OFFER_CONTENT_ID").val();
		
		//유효성 체크
		if(!fn_validation()){
			return;
		}
		
		$("#SMS_MSG").val($("#SMS_INPUT_MSG").val());
		
		if(!confirm("저장 하시겠습니까?")){
			return;
		}
		
		$("#SMS_DISP_TIME").attr("disabled",false);
		
		jQuery.ajax({
			url           : '${staticPATH }/setContentsChannelSms.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){

	        		if(result.CMP_STATUS == "START"){
	        			alert("진행중인 캠페인은 수정할수 없습니다.");
	        		  $("#SMS_DISP_TIME").attr("disabled",true);
	        		}else{
						alert("저장되었습니다");
	        			
	        			//부모창 재조회
	        			opener.fn_getDetailList(offerContentId); 
	        			fn_close();
	        		}
        			
	        	}else{
	        		alert("에러가 발생하였습니다.");
	        		$("#SMS_DISP_TIME").attr("disabled",true);
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        	$("#SMS_DISP_TIME").attr("disabled",true);
	        }
		});
		
		
	};	
	
	
	/* 유효성 체크 */
	function fn_validation() {
		
		if("${bo.camp_status_cd}" == "START"){
			$("#btn_save").hide();
			alert("진행중인 캠페인은 수정할수 없습니다.");
			return false;
		}
		/*
		if("${bo.channel_priority_yn}" == "N" && "${user.title}" != "N"){
			alert("해당캠페인은 채널우선순위적용이 [N]입니다\n사용자는 권한이 없으므로 채널정보를 입력할수 없습니다");
			return false;			
		}
		*/
		
		if($("#SMS_INPUT_MSG").val() ==""){
			alert("SMS 메세지를 입력하세요");
			$("#SMS_INPUT_MSG").focus();
			return false;
		}
		
		if($("#SMS_INPUT_MSG").val().indexOf("(광고)") < 0){
			alert("SMS 메세지에 (광고) 문구가 포함되어야 합니다.");
			$("#SMS_INPUT_MSG").focus();
			return false;
		}
		
		if($("#SMS_INPUT_MSG").val().indexOf("무료") < 0){
			alert("SMS 메세지에 '무료' 문구가 포함되어야 합니다.");
			$("#SMS_INPUT_MSG").focus();
			return false;
		}
		
		if($("#SMS_INPUT_MSG").val().indexOf("거부") < 0){
			alert("SMS 메세지에 '거부' 문구가 포함되어야 합니다.");
			$("#SMS_INPUT_MSG").focus();
			return false;
		}
		
		if($("#SMS_INPUT_MSG").val().indexOf("0802020110") < 0){
			alert("SMS 메세지에 '0802020110'가 포함되어야 합니다.");
			$("#SMS_INPUT_MSG").focus();
			return false;
		}
		
		if($("#remChars").val() > 255){
			alert("메세지 길이가 255Byte가 초과할수 없습니다");
			$("#SMS_INPUT_MSG").focus();
			return false;
		}
		
		if("${bo.camp_term_cd}" == "01"){
			if($("#SMS_DISP_DT").val() ==""){
				alert("노출일를 입력하세요");
				$("#SMS_DISP_DT").focus();
				return false;
			}
	
			//from ~ to 일경우 노출일은 캠페인 기간에 포함되어야 한다
			if("${bo.camp_bgn_dt}" > $("#SMS_DISP_DT").val() || "${bo.camp_end_dt}" < $("#SMS_DISP_DT").val()){
				alert("노출일이 캠페인기간에 포함되지 않습니다\n (캠페인기간 : ${bo.camp_bgn_dt} ~ ${bo.camp_end_dt} )");
				$("#SMS_DISP_DT").focus();
				return false;
			}
			
			// 수동전송여부 : Y && 채널우선순위적용여부 : N ==> 오늘부터 입력가능(즉시전송 가능)
			// 수동전송여부 : N && 채널우선순위적용여부 : N ==> 내일부터 입력가능
			// 수동전송여부 : N && 채널우선순위적용여부 : Y ==> 내일부터 입력가능( 2015.02.16 고도화로 모레에서 내일로 변경 )
			if( "${bo.manual_trans_yn}" == "Y" && "${bo.channel_priority_yn}" =="N" ){ //오늘부터 입력가능
				if($("#TO_DATE").val() > $("#SMS_DISP_DT").val()){
					alert("수동전송 [Y], 채널우선순위적용여부 [N]일경우 채널전송일은 오늘("+$("#TO_DATE").val()+") 이후여야 합니다");
					$("#SMS_DISP_DT").focus();
					return false;				
				}
			}else if( "${bo.manual_trans_yn}" == "N" && "${bo.channel_priority_yn}" =="N" ){ //내일부터 입력가능
				if($("#TO_DATE_P1").val() > $("#SMS_DISP_DT").val()){
					alert("수동전송 [N], 채널우선순위적용여부 [N]일경우 채널전송일은 내일("+$("#TO_DATE_P1").val()+") 이후여야 합니다");
					$("#SMS_DISP_DT").focus();
					return false;				
				}			
			}else if( "${bo.manual_trans_yn}" == "N" && "${bo.channel_priority_yn}" =="Y" ){ //내일부터 입력가능
				if($("#TO_DATE_P1").val() > $("#SMS_DISP_DT").val()){
					alert("수동전송 [N], 채널우선순위적용여부 [Y]일경우 채널전송일은 내일("+$("#TO_DATE_P1").val()+") 이후여야 합니다");
					$("#SMS_DISP_DT").focus();
					return false;				
				}			
			}
			
		}
		
		if( $(":checkbox[name='SMS_RETURNCALL']:checked").length == 0 ){
			alert("완료시 전달받을 담당자를 선택하세요(필수1이상)");
			return false;
		}
		
		if( $(":checkbox[name='SMS_RETURNCALL']:checked").length > 10 ){
			alert("완료시 전달받을 담당자는 최대 10명까지만 가능합니다");
			return false;
		}
		
		return true;
	}
	
	
	//메세지 데이터 길이 체크
    function textCounter(theField, theCharCounter, maxChars) 
    {
        var strTemp        = "";
        var strCharCounter = 0;
        var li_len         = 0;

        var txta           = theField.value;
		
        //길이 체크할때 사용자 변수는 빼고 체크한다
		<c:forEach var="val" items="${vri_list}">
			var vari_name = "{" + "${val.vari_name}" + "}";
// 			txta = txta.replace(vari_name,"");
			txta = txta.replace(new RegExp(vari_name, "gi"), "");;  
		</c:forEach>
		
		
        for (var i = 0; i < txta.length; i++)
        {
            var strChar = txta.substring(i, i + 1); //입력값
            var l = 0;
                if (strChar == '\n') 
                {
                    strTemp += strChar;
                    strCharCounter += 2;
                }
                else {
                    strTemp += strChar;
                    strCharCounter += (strTemp.charCodeAt(i) > 128) ? 2 : 1;
                }

                if(strCharCounter <= maxChars) 
                {
                    li_len = i + 1;
                }
        }

        theCharCounter.value = strCharCounter;

        //80Byte를 초과하여도 계속 입력하게 해달라고 요청
//         if(theCharCounter.value < 0)
//         {
//             alert(maxChars + " Byte 까지만 입력 가능합니다.");
//             txta   = strTemp.substr(0, li_len);
//             theCharCounter.value = 0; 
//         }
        
    }
	
	
	//창닫기
	function fn_close(){
		
		//창닫기
	  //top.closeChannelAddFrame();
		window.close();
		
	}
	
	
	//shorturl 가져오기
	function fn_getShortUrl(){
		
		if($("#SMS_LONGURL").val() ==""){
			alert("URL 정보를 입력하세요");
			$("#SMS_LONGURL").focus();
			return;
		}

		jQuery.ajax({
			url           : '${staticPATH }/contentsChannelSmsShortUrl.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
	        		
	        		//short ulr설정
	        		$("#SP_SMS_SHORTURL").html(result.SHORT_URL);
	        		$("#SMS_SHORTURL").val(result.SHORT_URL);
	        		
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
		
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
	        		$("#TO_DATE_P2").val(result.TO_DATE_P2) ;
	        		
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});		
	}
	


	//미리보기
	function fn_pre_view(){
		
		if($("#SMS_INPUT_MSG").val() ==""){
			alert("메세지를 입력하세요");
			$("#SMS_INPUT_MSG").focus();
			return;
		}
		
		jQuery.ajax({
			url           : '${staticPATH}/contentsChannelSmsPreview.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
	        		
	        		//사용자변수 적용된 미리보기
	        		$("#smsContent").html("<pre>" +result.SMS_INPUT_MSG.cut2(80) +"</pre>"); //80Byte만 보여준다
	        		
	        		//$("#smsBannerWrap").slideToggle(1);
	        		$("#smsBannerWrap").show();
		        	
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
	}
	
	/* 바로보기 닫기 */
	function fn_pre_viewClose(){
		$("#smsBannerWrap").hide();
	}
	
	/* 발송시간 설정 */
	function fn_set_smsSendTime(){
		
		for( var i = 0; i < 24; i++ ){
			for ( var j = 0; j < 60; j+=30 ){
				var ii = i;
				var jj = j;
				if ( ii < 10 ){
					ii = '0' + i;
				}
				if ( jj < 10 ){
					jj = '0' + j;
				}
				
				
				
				if ( i < 12 ){
					$("#SMS_DISP_TIME").append("<option value='"+ii+jj+"'>"+ii+":"+jj+"AM</option>");
				}else{
					$("#SMS_DISP_TIME").append("<option value='"+ii+jj+"'>"+ii+":"+jj+"PM</option>");
				}
			}
		}
		
	}
	
	/* 우선순위에 따른 SMS채널발송시간 설정 */
	function fn_chk_smsSendTime(){
		
		var i = 1;
		var sendtime = new Array(${fn:length(priority_rank_sendtime)});
		var sendtimevalue = new Array(${fn:length(priority_rank_sendtime)});
		
		<c:forEach var="val" items="${priority_rank_sendtime}">
		sendtime[i] = "${val.code_id}";
		sendtimevalue[i] = "${val.code_name}";
		i++;
		</c:forEach>
		
		for( var i = 1; i <= $("#SMS_PRIORITY_RNK option").size() ; i++ ){
			if( $("#SMS_PRIORITY_RNK").val() == sendtime[i] ){
				$("#SMS_DISP_TIME").val(sendtimevalue[i]);
			}
		}
		
		// 우선순위가 N 일 경우
		if ( $("#SMS_PRIORITY_RNK").val() == 'N' ){
			for ( var i = 1; i < sendtime.length; i++ ){
				if ( sendtime[i] = 'N' ){
					$("#SMS_DISP_TIME").val(sendtimevalue[i]);					
				}
			}
		}
		
	}
	
</script>
<!--PAGE CONTENT -->
        <div id="content" style="width:100%; height100%;">
           <!--BLOCK SECTION -->
           <div class="row" style="width:100%; height100%;">
              <div class="col-lg-1"></div>
              <div class="col-lg-10">

              <div class="col-md-12 page-header" style="margin-top:0px;">
                <h3>채널 상세 정보</h3>
              </div>
<form name="form" id="form">
<input type="hidden" id="CAMPAIGNCODE" name="CAMPAIGNCODE" value="${bo.campaigncode}" />
<input type="hidden" id="OFFER_CONTENT_ID" name="OFFER_CONTENT_ID" value="${bo.offer_content_id}" />
<input type="hidden" id="SMS_SHORTURL" name="SMS_SHORTURL" value="${bo.sms_shorturl}" />
<input type="hidden" id="SMS_MSG" name="SMS_MSG" value="" />

<input type="hidden" id="TO_DATE" name="TO_DATE" value="" />
<input type="hidden" id="TO_DATE_P1" name="TO_DATE_P1" value="" />
<input type="hidden" id="TO_DATE_P2" name="TO_DATE_P2" value="" />

  <div class="col-lg-12" id="table">
    <table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%"/>
				<col width="35%"/>
				<col width="15%"/>
				<col width="35%"/>
			</colgroup>
			<tr>
				<td class="info">캠페인 코드/명</td>
				<td class="tbtd_content" colspan="3">[${bo.campaigncode}]${bo.campaignname}</td>
				<%-- <td class="info">플로차트 이름</td>
				<td class="tbtd_content">${bo.flowchartname}</td> --%>
			</tr>
			<tr>
				<td class="info">채널</td>
				<td class="tbtd_content">
					<select id="CHANNEL_CD" name="CHANNEL_CD"  style="width:125px;"<c:if test="${DISABLED == 'Y'}">disabled="disabled"</c:if>>
						<c:forEach var="val" items="${channel_list}">

							<option value="${val.code_id}" <c:if test="${val.code_id eq CHANNEL_CD}">selected="selected"</c:if>>
								${val.code_name}
							</option>
														
						</c:forEach>					
					</select>				
				</td>
				<td class="info">고객세그먼트</td>
				<td class="tbtd_content">${bo.cellname}</td>
			</tr>
		</table>

		<div style="padding-top: 5px;">		
			<table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
        <col width="15%"/>
        <col width="35%"/>
        <col width="15%"/>
        <col width="35%"/>
				</colgroup>
				<tr>				
					<td class="info">메세지데이터</td>		
					<td class="tbtd_content" colspan="3">
						<textarea rows="6" cols="65" id="SMS_INPUT_MSG" name="SMS_INPUT_MSG" onKeyUp="textCounter(SMS_INPUT_MSG, remChars, 80);"><c:if test="${bo.sms_msg eq null}">(광고)[11번가] http://11st.kr/&Aw7XAg 무료수신거부0802020110</c:if><c:if test="${bo.sms_msg != null}">${bo.sms_msg}</c:if></textarea>
						<select style="width:150px; height:93px" size="4" id="VAL_LIST" name="VAL_LIST">
							<c:forEach var="val" items="${vri_list}">
								<option value="${val.vari_name}">
									${val.vari_name}
								</option>
							</c:forEach>
						</select>
						<br></br>
						입력문자길이 : <input type="text" name="remChars" id="remChars" value="0" maxlength="3" style="background-color:transparent;border:0; width: 20px; text-align: right; color: red;" readonly>Bytes
						(매개변수를 제외한 Byte입니다, '{ }'는 매개변수로 인지됩니다)
					</td>
				</tr>
				<tr>				
					<td class="info">우선순위</td>		
					<td class="tbtd_content">
						<select id="SMS_PRIORITY_RNK" name="SMS_PRIORITY_RNK"  style="width:60px;">
							<c:forEach var="val" items="${priority_rank}">
								
								<!-- 캠페인의 채널우선순위 적용여부 체크 -->
								<c:if test="${bo.channel_priority_yn == 'N' && bo.channel_priority_yn == val.code_id}">
									<option value="${val.code_id}">
										${val.code_name}
									</option>
								</c:if>
								<c:if test="${bo.channel_priority_yn == 'Y' && val.code_id != 'N' }">
									
									<!-- 사용자의 권한체크(user.title) 우선순위 권한에 따라 보여준다 -->
									<%-- <c:if test="${user.title =='N' || user.title <= val.code_id  }"> --%>	
										<option value="${val.code_id}" <c:if test="${val.code_id eq bo.sms_priority_rnk}">selected="selected"</c:if>>
											${val.code_name}
										</option>
									<%-- </c:if>								 --%>
								</c:if>
								
							</c:forEach>					
						</select>
					</td>
					<td class="info">발송시간</td>		
					<td class="tbtd_content">
						
						<select id="SMS_DISP_TIME" name="SMS_DISP_TIME"  style="width:80px;">
						</select>
            <select id="SMS_SEND_PREFER_CD" name="SMS_SEND_PREFER_CD">
              <c:forEach var="val" items="${smsSendPreferCd}">
                <option value="${val.code_id}" <c:if test="${val.code_id eq bo.sms_send_prefer_cd}">selected="selected"</c:if>>
                  ${val.code_name}
                </option>             
              </c:forEach>
            </select>
					</td>
				</tr>
				
				<tr>				
					<td class="info">콜백 번호</td>		
					<td class="tbtd_content" colspan="3">
						<select id="SMS_CALLBACK" name="SMS_CALLBACK"  style="width:180px;">
							<c:forEach var="val" items="${callback_list}">
									<option value="${val.code_id}" <c:if test="${val.code_id eq bo.sms_callback}">selected="selected"</c:if>>
										${val.code_name}
									</option>
							</c:forEach>					
						</select>
					</td>
				</tr>
				
				<tr>
					<td class="info">URL</td>
					<td class="tbtd_content" colspan="3">
						<div id="search2">
							<input type="text" id="SMS_LONGURL" name="SMS_LONGURL" style="width: 550px;" value="${bo.sms_longurl}" maxlength="250" class="txt"/>
						     <button type="button" class="btn btn-success btn-sm" onclick="fn_getShortUrl();">ShortURL</button>
						</div>
					</td>
				</tr>
				<tr>				
					<td class="info">ShortURL</td>		
					<td class="tbtd_content" colspan="3"><span id="SP_SMS_SHORTURL" name="SP_SMS_SHORTURL">${bo.sms_shorturl}</span></td>
				</tr>
				<tr>
					<td class="info">노출일</td>		
					<td class="tbtd_content" colspan="3">
						<input type="text" id="SMS_DISP_DT" name="SMS_DISP_DT" class="txt" style="width:75px;" 
							<c:if test="${bo.sms_disp_dt != null}">value="${bo.sms_disp_dt}"</c:if>
							<c:if test="${bo.sms_disp_dt == null && bo.camp_term_cd eq '01'}">value="${bo.camp_bgn_dt}"</c:if>
						readonly="readonly"/>
						<c:if test="${bo.camp_term_cd eq '02'}">(전송일 +1일)</c:if>
					</td>
				</tr>
				<tr>
					<td class="info">완료시전달번호</td>		
					<td class="tbtd_content" colspan="3">
						<div  style="width:800px; height:70px; overflow: auto;">
							<c:forEach var="val" items="${comp_list}" varStatus="status">
								<input type="checkbox" name="SMS_RETURNCALL" value="${val.code_id}" />${val.code_name} <c:if test="${status.count%10 == 0}"> <br/></c:if> <!-- 10명이후에 br -->
							</c:forEach>
						</div>
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
	</div>

	<div id="sysbtn" class="col-md-12" style="text-align:right;margin-bottom:10px;">
		<button type="button" class="btn btn-success btn-sm" onclick="fn_pre_view();"><i class="fa fa-eye" aria-hidden="true"></i> 미리보기</button>
		<button type="button" class="btn btn-success btn-sm" onclick="fn_save();"><i class="fa fa-floppy-o" aria-hidden="true"></i> 저장</button>	
		<button type="button" class="btn btn-success btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i> 닫기</button>
	</div>
	
<div id="smsBannerWrap" style=" position:fixed; left:350px; top: 120px; width: 400px; display: none; border: 2px solid #000000; " >
	<div style="background-color:#CDCDCD;border: 1px solid #ffffff"><a href="javascript:fn_pre_viewClose();" class="bt"><img width="30" height="30" style="padding:0px; border:0px; margin-left: 92%;" alt="닫기" src="<c:url value='/image/btn/x_button.png'/>" ></a></div>	
	<div id="smsContWrap" style="background-image:url(${staticPATH }/image/sms2.jpg); background-repeat: no-repeat;  width:100%; height:300px; overflow:hidden;float:left;line-height:15px; white-space:nowrap; ">
		<div id="smsContent" style="width:380px; height:170px; position:absolute; top:165px; left:8px; clear: both; font-size: 14px;  word-wrap:break-word "></div>
	</div>
</div>

</form>
                  </div>
                            <div class="col-lg-1"></div>
                        </div>
                        <!--END BLOCK SECTION -->
                        <div class="col-lg-3"></div>
              
                      </div>
                      <!--END PAGE CONTENT -->

