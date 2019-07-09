<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_pop.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="${staticPATH }/css/ui-lightness/jquery-ui.css">
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script src="${staticPATH }/js/jquery_1.9.2/jquery-ui-1.9.2.custom.js" type="text/javascript"></script>

<%-- <script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script> --%>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>

<script language="JavaScript">
	var oEditors = [];

	window.resizeTo(1080,780);
	
	$(document).ready(function(){
/* 		
		if("${bo.channel_priority_yn}" == "N" && "${user.title}" != "N"){
			alert("해당캠페인은 채널우선순위적용이 [N]입니다\n사용자는 권한이 없으므로 채널정보를 입력할수 없습니다");			
		}
 */		
   $("#EMAIL_DISP_DT").datepicker({
     showOn: "button",
     buttonImage: "${staticPATH }/image/calendar.gif",
     buttonImageOnly: true,
     buttonText: "Select date"
   });
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; margin-bottom:-2px; vertical-align:middle;");
		
		if("${bo.camp_term_cd}" == "02"){ //캠페인 기간구분이 반복일경우 노출일 disable
			$("#EMAIL_DISP_DT" ).datepicker("disable");
			$("#EMAIL_DISP_DT" ).addClass("essentiality");
		}
	
		//채널선택시 페이지 이동
		$("#CHANNEL_CD").bind("change",fn_selectChannel);
	
		//메세지 작성 선택시 이벤트 추가
		$("input:radio[name='EMAIL_EDIT_YN']").bind("change",fn_selectEmailEdit);
		
		//사용자 변수 더블클릭 이벤트
		$("#VAL_LIST").dblclick(function(){
			
// 			var sHTML = "{" + $("#VAL_LIST").val() + "}";
// 			oEditors.getById["EMAIL_CONTENT"].exec("PASTE_HTML", [sHTML]);
/* 			
			$("#EMAIL_CONTENT").focus();
			
			cRange = document.selection.createRange();
			cRange.text =  $("#VAL_LIST").val();
			
			 */
      $("#EMAIL_CONTENT").focus();
      
      if(document.selection){
        cRange = document.selection.createRange();
        cRange.text = "{" + $("#VAL_LIST").val() + "}";
      }else{
        $("#EMAIL_CONTENT").val($("#EMAIL_CONTENT").val() + "{" + $("#VAL_LIST").val() + "}");
      }
			
		});
		
		//오늘날짜 조회
		getToday();
		
		fn_hide();
		
		//SMARTEDITOR 설정
// 		nhn.husky.EZCreator.createInIFrame({
// 			oAppRef: oEditors,
// 			elPlaceHolder: "EMAIL_CONTENT",
// 			sSkinURI: "/UnicaExt/smartEdit/SmartEditor2Skin.html",	
// 			htParams : {
// 				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
// 				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
// 				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
// 				fOnBeforeUnload : function(){
// 				}
// 			},
// 			fOnAppLoad : function(){
				
// 				//ifame 사이즈 변경
// 				$("iframe").css("width","700");
				
// 				fn_hide();
// 			},
// 			fCreator: "createSEditor2"
// 		});

		
		//메세지 작성여부에 따른 이벤트
		fn_selectEmailEdit();
		
		//발송시간 설정
		fn_set_emailSendTime();
		
		//우선순위에 따른 발송시간 설정
		fn_chk_emailSendTime();
		$("#EMAIL_PRIORITY_RNK").bind("change",fn_chk_emailSendTime);
		
		// 기존에 저장된 채널발송시간이 있을 경우 선택
		if ( "${bo.email_disp_time}" != '' ){
			$("#EMAIL_DISP_TIME").val("${bo.email_disp_time}");
		}
		
		// 캠페인 데이터 전송방식이 Manual 또는 Time 일 경우 발송시간 항목 disable 처리
		if ( "${bo.manual_trans_yn}" == 'Y' || "${bo.manual_trans_yn}" == 'T'){
			$("#EMAIL_DISP_TIME").attr("disabled",true);
		}
		
    $("#useIndi").click(function(){
      if($('input:checkbox[id="useIndi"]').is(":checked") == true){
        $("#VAL_LIST").removeAttr("disabled");
      }else{
        $("#VAL_LIST").attr("disabled","disabled");
      }
    });
    
    <c:if test="${bo.email_person_msg_yn eq 'Y'}">
    $("#VAL_LIST").removeAttr("disabled");
    </c:if>
    <c:if test="${bo.email_person_msg_yn ne 'Y'}">
    $("#VAL_LIST").attr("disabled","disabled");
    </c:if>
		
	});

	
	
	//채널 선택
	function fn_selectChannel(){
		
		var frm = document.form;
		
		if($("#CHANNEL_CD").val() == "SMS"){
			frm.action = "${staticPATH }/channel/channelSms.do";
			frm.submit();
		}
		
		if($("#CHANNEL_CD").val() == "EMAIL"){
			frm.action = "${staticPATH }/channel/channelEmail.do";
			frm.submit();
		}
		
		if($("#CHANNEL_CD").val() == "TOAST"){
			frm.action = "${staticPATH }/channel/channelToast.do";
			frm.submit();
		}
		
		if($("#CHANNEL_CD").val() == "MOBILE"){
			frm.action = "${staticPATH }/channel/channelMobile.do";
			frm.submit();
		}
		if($("#CHANNEL_CD").val() == "LMS"){
			frm.action = "${staticPATH }/channel/channelLms.do";
			frm.submit();
		}
	}


	/* 등록 */
	function fn_save() {

		//유효성 체크
		if(!fn_validation()){
			return;
		}
		
		if(!fnChkByte($("#EMAIL_CONTENT"), 30000)){
		  return;
		}
	
		
		if(!confirm("저장 하시겠습니까?")){
			return;
		}

		var campaignid = $("#CampaignId").val();
		jQuery.ajax({
			url           : '${staticPATH }/setChannelEmail.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){

	        		if(result.CMP_STATUS == "START"){
	        			alert("진행중인 캠페인은 수정할수 없습니다.");
	        		}else{
						alert("저장되었습니다");
	        			
	        			//부모창 재조회
	        			window.opener.fn_getCampaignDtl(campaignid);
	        			
	        			//창닫기
	        			fn_close();
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
		if($("#EMAIL_NAME").val() ==""){
			alert("이메일명을 입력하세요");
			$("#EMAIL_NAME").focus();
			return false;
		}

		if($("#EMAIL_DESC").val() ==""){
			alert("이메일 설명을 입력하세요");
			$("#EMAIL_DESC").focus();
			return false;
		}

		if("${bo.camp_term_cd}" == "01"){
		
			if($("#EMAIL_DISP_DT").val() ==""){
				alert("이메일 노출일 입력하세요");
				$("#EMAIL_DISP_DT").focus();
				return false;
			}

			//from ~ to 일경우 노출일은 캠페인 기간에 포함되어야 한다
			if("${bo.camp_bgn_dt}" > $("#EMAIL_DISP_DT").val() || "${bo.camp_end_dt}" < $("#EMAIL_DISP_DT").val()){
				alert("노출일이 캠페인기간에 포함되지 않습니다\n (캠페인기간 : ${bo.camp_bgn_dt} ~ ${bo.camp_end_dt} )");
				$("#EMAIL_DISP_DT").focus();
				return false;
			}
		
			// 수동전송여부 : Y && 채널우선순위적용여부 : N ==> 오늘부터 입력가능(즉시전송 가능)
			// 수동전송여부 : N && 채널우선순위적용여부 : N ==> 내일부터 입력가능
			// 수동전송여부 : N && 채널우선순위적용여부 : Y ==> 내일부터 입력가능( 2015.02.16 고도화로 모레에서 내일로 변경 )
			if( "${bo.manual_trans_yn}" == "Y" && "${bo.channel_priority_yn}" =="N" ){ //오늘부터 입력가능
				if($("#TO_DATE").val() > $("#EMAIL_DISP_DT").val()){
					alert("수동전송 [Y], 채널우선순위적용여부 [N]일경우 채널전송일은 오늘("+$("#TO_DATE").val()+") 이후여야 합니다");
					$("#EMAIL_DISP_DT").focus();
					return false;				
				}
			}else if( "${bo.manual_trans_yn}" == "N" && "${bo.channel_priority_yn}" =="N" ){ //내일부터 입력가능
				if($("#TO_DATE_P1").val() > $("#EMAIL_DISP_DT").val()){
					alert("수동전송 [N], 채널우선순위적용여부 [N]일경우 채널전송일은 내일("+$("#TO_DATE_P1").val()+") 이후여야 합니다");
					$("#EMAIL_DISP_DT").focus();
					return false;				
				}			
			}else if( "${bo.manual_trans_yn}" == "N" && "${bo.channel_priority_yn}" =="Y" ){ //내일부터 입력가능
				if($("#TO_DATE_P1").val() > $("#EMAIL_DISP_DT").val()){
					alert("수동전송 [N], 채널우선순위적용여부 [Y]일경우 채널전송일은 내일("+$("#TO_DATE_P1").val()+") 이후여야 합니다");
					$("#EMAIL_DISP_DT").focus();
					return false;				
				}	
			}
			
		}

		//if($("input:radio[name='EMAIL_EDIT_YN']:checked").val() == "Y"){ //CMS 작성일때만 체크!
		if($("#EMAIL_EDIT_YN").val() == "Y"){ //CMS 작성일때만 체크!
			if($("#EMAIL_FROMNAME").val() ==""){
				alert("보내는이 이름을 입력하세요");
				$("#EMAIL_FROMNAME").focus();
				return false;
			}
	
			if($("#EMAIL_FROMADDRESS").val() ==""){
				alert("보내는이 이메일을 입력하세요");
				$("#EMAIL_FROMADDRESS").focus();
				return false;
			}
	
			if($("#EMAIL_REPLYTO").val() ==""){
				alert("회신 이메일을 입력하세요");
				$("#EMAIL_REPLYTO").focus();
				return false;
			}
			
			if($("#EMAIL_SUBJECT").val() ==""){
				alert("이메일 제목을 입력하세요");
				$("#EMAIL_SUBJECT").focus();
				return false;
			}
			
			if($("#EMAIL_SUBJECT").val().indexOf("(광고)") < 0){
				alert("이메일 제목에 (광고) 문구가 포함되어야 합니다.");
				$("#EMAIL_SUBJECT").focus();
				return false;
			}
	
			//SMART EDIT 내용을 TEXTAREA로 옮김
	// 		oEditors.getById["EMAIL_CONTENT"].exec("UPDATE_CONTENTS_FIELD", []);
			if($("#EMAIL_CONTENT").val() ==""){
				$('#TR_CONTENT').css('display', '');
				$('#TD_CONTENT').attr("rowspan","2");
				alert("이메일 내용을 입력하세요");
				$("#EMAIL_CONTENT").focus();
				return false;
			} else {
				if( $("#EMAIL_CONTENT").val().indexOf('[$_EMAIL_HASH_$]') < 0 ){
					$('#TR_CONTENT').css('display', '');
					$('#TD_CONTENT').attr("rowspan","2");
					alert("이메일 내용에 '이메일 수신거부 HASH' 치환태그가 포함되지 않았습니다.");
					$("#EMAIL_CONTENT").focus();
					return false;
				}
			}
		}
		
		return true;
		
	}
	
	
	//창닫기
	function fn_close(){
		
		//창닫기
		window.close();
		
	}
	

	/* 이메일 내용 숨기기/보이기 */
	function fn_hide(){
		
		if($('#TR_CONTENT').css('display') =="none"){
			$('#TR_CONTENT').css('display', '');
			$('#TD_CONTENT').attr("rowspan","2");
		}else{
			$('#TR_CONTENT').css('display', 'none');
			$('#TD_CONTENT').attr("rowspan","1");
		}
		
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
	
	//메세지 작성 라디오 버튼 클릭시 이벤트 추가
	function fn_selectEmailEdit(){
		
		if($("input:radio[name='EMAIL_EDIT_YN']:checked").val() == "Y"){
			$("#EMAIL_FROMNAME").removeClass("essentiality");
			$("#EMAIL_FROMNAME").attr("readonly",false);
			$("#EMAIL_FROMADDRESS").removeClass("essentiality");
			$("#EMAIL_FROMADDRESS").attr("readonly",false);
			$("#EMAIL_REPLYTO").removeClass("essentiality");
			$("#EMAIL_REPLYTO").attr("readonly",false);
			$("#EMAIL_SUBJECT").removeClass("essentiality");
			$("#EMAIL_SUBJECT").attr("readonly",false);
			$("#search").show();
			$('#TR_CONTENT').css('display', 'none');
			$('#TD_CONTENT').attr("rowspan","1");
			$('li:eq(2)').show();
		}else{
			$("#EMAIL_FROMNAME").addClass("essentiality");
			$("#EMAIL_FROMNAME").attr("readonly",false);
			$("#EMAIL_FROMADDRESS").addClass("essentiality");
			$("#EMAIL_FROMADDRESS").attr("readonly",false);
			$("#EMAIL_REPLYTO").addClass("essentiality");
			$("#EMAIL_REPLYTO").attr("readonly",false);
			$("#EMAIL_SUBJECT").addClass("essentiality");
			$("#EMAIL_SUBJECT").attr("readonly",false);
			$("#search").show();
			$('#TR_CONTENT').css('display', 'none');
			$('#TD_CONTENT').attr("rowspan","1");
			$('li:eq(2)').hide();
		}
		

		
	}
	

	/* 이메일 미리보기 */
	function fn_pre_view(){

		var email_text = $("#EMAIL_CONTENT").val();

		$("#pre_emal").html("" +email_text+"");
		
		//$("#emailWrap").slideToggle(1);
		$("#emailWrap").show();
		
	}
	
	
	/* 바로보기 닫기 */
	function fn_pre_viewClose(){
		$("#emailWrap").hide();
	}
	
	/* 발송시간 설정 */
	function fn_set_emailSendTime(){
		
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
					$("#EMAIL_DISP_TIME").append("<option value='"+ii+jj+"'>"+ii+":"+jj+"AM</option>");
				}else{
					$("#EMAIL_DISP_TIME").append("<option value='"+ii+jj+"'>"+ii+":"+jj+"PM</option>");
				}
			}
		}
		
	}
	
	/* 우선순위에 따른 EMAIL채널발송시간 설정 */
	function fn_chk_emailSendTime(){
		
		var i = 1;
		var sendtime = new Array(${fn:length(priority_rank_sendtime)});
		var sendtimevalue = new Array(${fn:length(priority_rank_sendtime)});
		
		<c:forEach var="val" items="${priority_rank_sendtime}">
		sendtime[i] = "${val.code_id}";
		sendtimevalue[i] = "${val.code_name}";
		i++;
		</c:forEach>
		
		for( var i = 1; i <= $("#EMAIL_PRIORITY_RNK option").size() ; i++ ){
			if( $("#EMAIL_PRIORITY_RNK").val() == sendtime[i] ){
				$("#EMAIL_DISP_TIME").val(sendtimevalue[i]);
			}
		}
		
		// 우선순위가 N 일 경우
		if ( $("#EMAIL_PRIORITY_RNK").val() == 'N' ){
			for ( var i = 1; i < sendtime.length; i++ ){
				if ( sendtime[i] = 'N' ){
					$("#EMAIL_DISP_TIME").val(sendtimevalue[i]);					
				}
			}
		}
		
	}

  function fnChkByte(obj, maxByte){
  	  var str = obj.val();
  	  var str_len = str.length;
  	  
  	  console.log(str_len);
  
  	  var rbyte = 0;
  	  var rlen = 0;
  	  var one_char = "";
  	  var str2 = "";
  
  	  for(var i=0; i<str_len; i++){
    	  one_char = str.charAt(i);
    	  if(escape(one_char).length > 4){
    	      rbyte += 2;                                         //한글2Byte
    	  }else{
    	      rbyte++;                                            //영문 등 나머지 1Byte
    	  }
    
    	  if(rbyte <= maxByte){
    	      rlen = i+1;                                          //return할 문자열 갯수
    	  }
  	  }
  	  
  	  console.log(rbyte + "/ " + maxByte);
  
  	  if(rbyte > maxByte){
  	      alert("한글 "+(maxByte/2)+"자 / 영문 "+maxByte+"자를 초과 입력할 수 없습니다.");
  	      str2 = str.substr(0,rlen);                                  //문자열 자르기
  	      obj.value = str2;
  	      //fnChkByte(obj, maxByte);
  	      return false;
  	  }else{
  	      //document.getElementById('byteInfo').innerText = rbyte;
  	      return true;
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
<input type="hidden" id="CampaignId" name="CampaignId" value="${bo.campaignid}" />
<input type="hidden" id="CAMPAIGNCODE" name="CAMPAIGNCODE" value="${bo.campaigncode}" />
<input type="hidden" id="FLOWCHARTID" name="FLOWCHARTID" value="${bo.flowchartid}" />
<input type="hidden" id="CELLID" name="CELLID" value="${bo.cellid}" />

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
		<div>		
			<table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
					<col width="15%"/>
        <col width="35%"/>
        <col width="15%"/>
        <col width="35%"/>
				</colgroup>
				<tr>
					<td class="info">이메일명</td>
					<td class="tbtd_content" colspan="3"><input type="text" id="EMAIL_NAME" name="EMAIL_NAME" style="width:500px;" value="${bo.email_name}" class="txt" maxlength="50"/></td>
				</tr>
				<tr>
					<td class="info">이메일 설명</td>
					<td class="tbtd_content" colspan="3"><input type="text" id="EMAIL_DESC" name="EMAIL_DESC" style="width:600px;" value="${bo.email_desc}" class="txt" maxlength="100"/></td>
				</tr>
				<tr>
					<td class="info">노출일</td>		
					<td class="tbtd_content" colspan="3">
						<input type="text" id="EMAIL_DISP_DT" name="EMAIL_DISP_DT" style="width:85px;" 
							<c:if test="${bo.email_disp_dt != null}">value="${bo.email_disp_dt}"</c:if>
							<c:if test="${bo.email_disp_dt == null && bo.camp_term_cd eq '01'}">value="${bo.camp_bgn_dt}"</c:if>
						readonly="readonly"/>
						<c:if test="${bo.camp_term_cd eq '02'}">(전송일 +1일)</c:if>
					</td>
				</tr>
				<tr>
					<td class="info">우선순위</td>
					<td class="tbtd_content">
						<select id="EMAIL_PRIORITY_RNK" name="EMAIL_PRIORITY_RNK"  style="width:60px;">
							<c:forEach var="val" items="${priority_rank}">
								
								<!-- 캠페인의 채널우선순위 적용여부 체크 -->
								<c:if test="${bo.channel_priority_yn == 'N' && bo.channel_priority_yn == val.code_id}">"
									<option value="${val.code_id}">
										${val.code_name}
									</option>
								</c:if>
								<c:if test="${bo.channel_priority_yn == 'Y' && val.code_id != 'N' }">
									
									<!-- 사용자의 권한체크(user.title) 우선순위 권한에 따라 보여준다 -->
									<%-- <c:if test="${user.title =='N' || user.title <= val.code_id  }"> --%>	
										<option value="${val.code_id}" <c:if test="${val.code_id eq bo.email_priority_rnk}">selected="selected"</c:if>>
											${val.code_name}
										</option>
									<%-- </c:if>								 --%>
								</c:if>
								
							</c:forEach>					
						</select>
					</td>
					<td class="info">발송시간</td>		
					<td class="tbtd_content">
						
						<select id="EMAIL_DISP_TIME" name="EMAIL_DISP_TIME"  style="width:80px;">
							
							
						</select>
					</td>
				</tr>
<!-- 
				<tr>
					<td class="info">메시지작성</td>		
					<td class="tbtd_content" colspan="3">
						<input type="radio" name="EMAIL_EDIT_YN" class="txt"  value="Y" checked="checked"/> CMS에서 작성
						<input type="radio" name="EMAIL_EDIT_YN" class="txt"  value="N" <c:if test="${bo.email_edit_yn eq 'N'}">checked="checked"</c:if>/> EMAIL시스템에서 작성
					</td>
				</tr>
         -->
         <input type="hidden" name="EMAIL_EDIT_YN" class="txt"  value="Y"/>
				<tr>
					<td class="info">보내는사람 이름</td>
					<td class="tbtd_content" colspan="1">
						<input type="text" id="EMAIL_FROMNAME" name="EMAIL_FROMNAME" style="width:100px;" value="${bo.email_fromname}" class="txt" maxlength="30"/>
					</td>
					<td class="info">보내는사람 이메일</td>
					<td class="tbtd_content" colspan="1"><input type="text" id="EMAIL_FROMADDRESS" name="EMAIL_FROMADDRESS" style="width:250px;" value="${bo.email_fromaddress}" class="txt" maxlength="60"/></td>
				</tr>
				<tr>
					<td class="info">회신 이메일</td>
					<td class="tbtd_content" colspan="3"><input type="text" id="EMAIL_REPLYTO" name="EMAIL_REPLYTO" style="width:250px;" value="${bo.email_replyto}" class="txt" maxlength="30"/></td>
				</tr>
				<tr>
					<td class="info">이메일 제목</td>
          
          <c:set var="subjectVal" value="${bo.email_subject}"/>
          <c:if test="${bo.email_subject == '' || bo.email_subject eq null}">
            <c:set var="subjectVal" value="(광고)"/>
          </c:if>
          
					<td class="tbtd_content" colspan="3"><input type="text" id="EMAIL_SUBJECT" name="EMAIL_SUBJECT" style="width:500px;" class="txt" maxlength="200" value="${subjectVal}" /></td>
				</tr>				
				<tr>
					<td id="TD_CONTENT"class="info" rowspan="2">내용</td>
					<td class="tbtd_content" colspan="3">
						<div id="search" style="text-align:right;margin-bottom:10px;">
							<button type="button" class="btn btn-success btn-sm" onclick="fn_hide();"><i class="fa fa-eye-slash" aria-hidden="true"></i> Visible</button>	
						</div>					
					</td>
				</tr>
				<tr id="TR_CONTENT">
					<td class="tbtd_content" colspan="3">
            <table border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td><textarea name="EMAIL_CONTENT" id="EMAIL_CONTENT" rows="13" cols="90">${bo.email_content}</textarea></td>
                <td width="10px"></td>
                <td valign="top">
                  <label fore="useIndi"><input type="checkbox" name="useIndi" value="Y" id="useIndi" <c:if test="${bo.email_person_msg_yn eq 'Y'}"> checked</c:if> > 개인별 적용</label><br/>
                  <select style="width:170px; height:183px; vertical-align: top;" size="10" id="VAL_LIST" name="VAL_LIST" >
                    <c:forEach var="val" items="${vri_list}">
                      <option value="${val.code_id}">
                        ${val.code_name}
                      </option>
                    </c:forEach>
                  </select>     
                </td>
               </tr>
            </table>
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
		<button type="button" class="btn btn-danger btn-sm" onclick="fn_save();"><i class="fa fa-floppy-o" aria-hidden="true"></i> 저장</button>	
		<button type="button" class="btn btn-default btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i> 닫기</button>
	</div>
		



<div id="emailWrap" style="background-color:#ffffff; position:fixed; display: none;left:75px; top: 50px; width: 900px; border: 2px solid #000000;">
	<div style="background-color:#CDCDCD;border: 1px solid #ffffff"><a href="javascript:fn_pre_viewClose();" class="bt"><img width="30" height="30" style="padding:0px; border:0px; margin-left: 97%;" alt="닫기" src="<c:url value='/image/btn/x_button.png'/>" ></a></div>	
	<div id="pre_emal" style="background-color:#ffffff; width:100%; height:450px; overflow-y:scroll; word-wrap:break-word ; "></div>
</div>

</form>
                   </div>
                            <div class="col-lg-1"></div>
                        </div>
                        <!--END BLOCK SECTION -->
                        <div class="col-lg-3"></div>
              
                      </div>
                      <!--END PAGE CONTENT -->

