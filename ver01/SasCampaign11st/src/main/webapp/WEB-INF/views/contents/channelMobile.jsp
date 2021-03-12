<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_pop.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<!-- 운영 -->
<link rel="stylesheet" href="http://c.m.011st.com/MW/css/my/my.css" />
<script src="http://c.m.011st.com/MW/js/ui/ui.js"></script>

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>
<script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script>

<script>
//alimi list
if(window.attachEvent) window.attachEvent("onload", function(){mwUI.listToggle('myAlimi', 'btn_oc', 'on', '더보기', '닫기');});
else window.addEventListener("load",  function(){mwUI.listToggle('myAlimi', 'btn_oc', 'on', '더보기', '닫기');}, false);
</script>

<script language="JavaScript">
		
	var oEditors = [];

	$(document).ready(function(){
	  window.resizeTo(1080,820);
		/*
		if("${bo.channel_priority_yn}" == "N" && "${user.title}" != "N"){
			alert("해당캠페인은 채널우선순위적용이 [N]입니다\n사용자는 권한이 없으므로 채널정보를 입력할수 없습니다");			
		}
		*/
		
		$( "#MOBILE_DISP_DT" ).datepicker(dateOption);
		
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; margin-bottom:-2px; vertical-align:middle;");
		
		if("${bo.camp_term_cd}" == "02"){ //캠페인 기간구분이 반복일경우 노출일 disable
			$("#MOBILE_DISP_DT" ).datepicker("disable");
			$("#MOBILE_DISP_DT" ).addClass("essentiality");
		}
	
		//오늘날짜 조회
		getToday();
		
		if("${OFFERCODE}" =="NONE" && "${CHANNELCODE}" =="MOBILE" ){
			
			 $("#CHANNEL_CD").html("<option value="+"MOBILE"+">"+"모바일 알리미"+"</option>");
		}
		//채널선택시 페이지 이동
		$("#CHANNEL_CD").bind("change",fn_selectChannel);

// 		nhn.husky.EZCreator.createInIFrame({
// 			oAppRef: oEditors,
// 			elPlaceHolder: "MOBILE_ADD_TEXT",
// 			sSkinURI: "/UnicaExt/smartEdit/SmartEditor2Skin.html",	
// 			htParams : {
// 				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
// 				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
// 				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
// 				fOnBeforeUnload : function(){
// 				}
// 			},
// 			fOnAppLoad : function(){
				
// 			},
// 			fCreator: "createSEditor2"
// 		});
	
		//발송시간 설정
		fn_set_mobileSendTime();
		
		//우선순위에 따른 발송시간 설정
		fn_chk_mobileSendTime();
		$("#MOBILE_PRIORITY_RNK").bind("change",fn_chk_mobileSendTime);

		// 기존에 저장된 채널발송시간이 있을 경우 선택
		if ( "${bo.mobile_disp_time}" != '' ){
			$("#MOBILE_DISP_TIME").val("${bo.mobile_disp_time}");
		}
		
		// 캠페인 데이터 전송방식이 Manual 또는 Time 일 경우 발송시간 항목 disable 처리
		if ( "${bo.manual_trans_yn}" == 'Y' || "${bo.manual_trans_yn}" == 'T'){
			$("#MOBILE_DISP_TIME").attr("disabled",true);
		}
		
    //사용자 변수 더블클릭 이벤트
    $("#VAL_LIST").dblclick(function(){
      $("#MOBILE_ADD_TEXT").focus();
      
      if(document.selection){
        cRange = document.selection.createRange();
        cRange.text = "{" + $("#VAL_LIST").val() + "}";
      }else{
        $("#MOBILE_ADD_TEXT").val($("#MOBILE_ADD_TEXT").val() + "{" + $("#VAL_LIST").val() + "}");
      }
    });
    
    $("#useIndi").click(function(){
      if($('input:checkbox[id="useIndi"]').is(":checked") == true){
        $("#VAL_LIST").removeAttr("disabled");
      }else{
        $("#VAL_LIST").attr("disabled","disabled");
      }
    });

    $("#MOBILE_LNK_PAGE_TYP").bind("change", fn_set_mobile_lnk_page_url);
    
    <c:if test="${bo.mobile_person_msg_yn eq 'Y'}">
    $("#VAL_LIST").removeAttr("disabled");
    </c:if>
    <c:if test="${bo.mobile_person_msg_yn ne 'Y'}">
    $("#VAL_LIST").attr("disabled","disabled");
    </c:if>
    
    opener.setIFrameHeight('channel'); 
	});
	
  function fn_set_mobile_lnk_page_url(){
    if( $("#MOBILE_LNK_PAGE_TYP").val() == "01" ) {
      $("#MOBILE_LNK_PAGE_URL").val("http://m.11st.co.kr");
      $("#MOBILE_LNK_PAGE_URL").attr("readonly",true);
    } else {
      $("#MOBILE_LNK_PAGE_URL").val("");
      $("#MOBILE_LNK_PAGE_URL").attr("readonly",false);
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

		
		if(!confirm("저장 하시겠습니까?")){
			return;
		}
		
		$("#MOBILE_DISP_TIME").attr("disabled",false);

		jQuery.ajax({
			url           : '${staticPATH }/setContentsChannelMobile.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){

	        		if(result.CMP_STATUS == "START"){
	        			alert("진행중인 캠페인은 수정할수 없습니다.");
	        			$("#MOBILE_DISP_TIME").attr("disabled",true);
	        		}else{
		        		alert("저장되었습니다");
	        			
	        			//부모창 재조회
	        			opener.fn_getDetailList(offerContentId);
	        			
	        			//창닫기
	        			fn_close();
	        		}
        			
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        		$("#MOBILE_DISP_TIME").attr("disabled",true);
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        	$("#MOBILE_DISP_TIME").attr("disabled",true);
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

		if("${bo.camp_term_cd}" == "01"){
		
			if($("#MOBILE_DISP_DT").val() ==""){
				alert("모바일알리미 노출일 입력하세요");
				$("#MOBILE_DISP_DT").focus();
				return false;
			}

			//from ~ to 일경우 노출일은 캠페인 기간에 포함되어야 한다
			if("${bo.camp_bgn_dt}" > $("#MOBILE_DISP_DT").val() || "${bo.camp_end_dt}" < $("#MOBILE_DISP_DT").val()){
				alert("노출일이 캠페인기간에 포함되지 않습니다\n (캠페인기간 : ${bo.camp_bgn_dt} ~ ${bo.camp_end_dt} )");
				$("#MOBILE_DISP_DT").focus();
				return false;
			}
		
			// 수동전송여부 : Y && 채널우선순위적용여부 : N ==> 오늘부터 입력가능(즉시전송 가능)
			// 수동전송여부 : N && 채널우선순위적용여부 : N ==> 내일부터 입력가능
			// 수동전송여부 : N && 채널우선순위적용여부 : Y ==> 내일부터 입력가능( 2015.02.16 고도화로 모레에서 내일로 변경 )
			if( "${bo.manual_trans_yn}" == "Y" && "${bo.channel_priority_yn}" =="N" ){ //오늘부터 입력가능
				if($("#TO_DATE").val() > $("#MOBILE_DISP_DT").val()){
					alert("수동전송 [Y], 채널우선순위적용여부 [N]일경우 채널전송일은 오늘("+$("#TO_DATE").val()+") 이후여야 합니다");
					$("#MOBILE_DISP_DT").focus();
					return false;				
				}
			}else if( "${bo.manual_trans_yn}" == "N" && "${bo.channel_priority_yn}" =="N" ){ //내일부터 입력가능
				if($("#TO_DATE_P1").val() > $("#MOBILE_DISP_DT").val()){
					alert("수동전송 [N], 채널우선순위적용여부 [N]일경우 채널전송일은 내일("+$("#TO_DATE_P1").val()+") 이후여야 합니다");
					$("#MOBILE_DISP_DT").focus();
					return false;				
				}			
			}else if( "${bo.manual_trans_yn}" == "N" && "${bo.channel_priority_yn}" =="Y" ){ //내일부터 입력가능
				if($("#TO_DATE_P1").val() > $("#MOBILE_DISP_DT").val()){
					alert("수동전송 [N], 채널우선순위적용여부 [Y]일경우 채널전송일은 내일("+$("#TO_DATE_P1").val()+") 이후여야 합니다");
					$("#MOBILE_DISP_DT").focus();
					return false;				
				}	
			}
			
		}

    if($("#MOBILE_LNK_PAGE_URL").val() == ""){
      alert("연결페이지 URL을 입력 하세요.");
      return false;
    }

		if($("#MOBILE_DISP_TITLE").val() ==""){
			alert("푸시알림 노출제목을 입력하세요");
			$("#MOBILE_DISP_TITLE").focus();
			return false;
		}
		
		if($("#MOBILE_CONTENT").val() ==""){
			alert("푸시알림 노출내용을 입력하세요");
			$("#MOBILE_CONTENT").focus();
			return false;
		}
		
		if($("#MOBILE_CONTENT").val().indexOf("(광고)") < 0){
			alert("푸시알림 노출내용에 (광고) 문구가 포함되어야 합니다.");
			$("#MOBILE_CONTENT").focus();
			return false;
		}

		//SMART EDIT 내용을 TEXTAREA로 옮김
		//oEditors.getById["MOBILE_ADD_TEXT"].exec("UPDATE_CONTENTS_FIELD", []);
		if($("#MOBILE_ADD_TEXT").val() ==""){
			alert("푸시알림 추가텍스트를 입력하세요");
			return false;
		}
		
		return true;
	}
	
	
	//창닫기
	function fn_close(){
		
		//창닫기
	  //top.closeChannelAddFrame();
		window.close();
		
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
	
	
	/* 모바일 알리미 미리보기 */
	function fn_pre_view(){

		//oEditors.getById["MOBILE_ADD_TEXT"].exec("UPDATE_CONTENTS_FIELD", []);
		
		var title    = $("#MOBILE_DISP_TITLE").val();
		var content  = $("#MOBILE_CONTENT").val();
		var add_text = $("#MOBILE_ADD_TEXT").val();

		$("#mo_title").html(title);
		$("#mo_content").html(content);
		$("#mo_addText").html(add_text);
		
		//$("#wrap").slideToggle(1);
		//$("#wrap").show();
		$("#wrapA").css('display', 'block');
		
	}

	
	/* 바로보기 닫기 */
	function fn_pre_viewClose(){
		//$("#wrapA").hide();
	  $("#wrapA").css('display', 'none');
	}
	
	/* 발송시간 설정 */
	function fn_set_mobileSendTime(){
		
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
					$("#MOBILE_DISP_TIME").append("<option value='"+ii+jj+"'>"+ii+":"+jj+"AM</option>");
				}else{
					$("#MOBILE_DISP_TIME").append("<option value='"+ii+jj+"'>"+ii+":"+jj+"PM</option>");
				}
			}
		}
		
	}
	
	/* 우선순위에 따른 SMS채널발송시간 설정 */
	function fn_chk_mobileSendTime(){
		
		var i = 1;
		var sendtime = new Array(${fn:length(priority_rank_sendtime)});
		var sendtimevalue = new Array(${fn:length(priority_rank_sendtime)});
		
		<c:forEach var="val" items="${priority_rank_sendtime}">
		sendtime[i] = "${val.code_id}";
		sendtimevalue[i] = "${val.code_name}";
		i++;
		</c:forEach>
		
		for( var i = 1; i <= $("#MOBILE_PRIORITY_RNK option").size() ; i++ ){
			if( $("#MOBILE_PRIORITY_RNK").val() == sendtime[i] ){
				$("#MOBILE_DISP_TIME").val(sendtimevalue[i]);
			}
		}
		
		// 우선순위가 N 일 경우
		if ( $("#MOBILE_PRIORITY_RNK").val() == 'N' ){
			for ( var i = 1; i < sendtime.length; i++ ){
				if ( sendtime[i] = 'N' ){
					$("#MOBILE_DISP_TIME").val(sendtimevalue[i]);					
				}
			}
		}
		
	}
	
function fn_pre_view_img(target){
    
    var targetImg = document.getElementById(target).value;
    
    var img = new Image();
    img.src = targetImg;
    
    //alert(img.width + ' '+img.height);
    //alert(e.pageX + '' + e.pageY);
    
    
    cnj_win_view(targetImg);

  }
	
</script>
<script Language="Javascript"> 
var cnj_img_view = null; 
function cnj_win_view(img){ 
  img_conf1= new Image(); 
  img_conf1.src=(img); 
  cnj_view_conf(img); 
} 

function cnj_view_conf(img){ 
  if((img_conf1.width!=0)&&(img_conf1.height!=0)){ 
    cnj_view_img(img); 
  } else { 
    funzione="cnj_view_conf('"+img+"')"; 
    intervallo=setTimeout(funzione,20); 
  } 
} 

function cnj_view_img(img){ 
  if(cnj_img_view != null) { 
    if(!cnj_img_view.closed) { cnj_img_view.close(); } 
  } 
  cnj_width=img_conf1.width+20; 
  cnj_height=img_conf1.height+20; 
  str_img="width="+cnj_width+",height="+cnj_height; 
  cnj_img_view=window.open(img,"cnj_img_open",str_img); 
  cnj_img_view.focus(); 
return; 
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
				<td class="tbtd_content" colspan="3">${bo.flowchartname}</td> --%>
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
				<td class="tbtd_content" colspan="3">${bo.cellname}</td>
			</tr>
		</table>
		
  <div  style="padding-top: 5px;">
    <table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
          <col width="15%"/>
        <col width="35%"/>
        <col width="15%"/>
        <col width="35%"/>
				</colgroup>
				<tr>
					<td class="info">앱구분</td>
					<td class="tbtd_content">
						<select id="MOBILE_APP_KD_CD" name="MOBILE_APP_KD_CD"  style="width:90px;">
							<c:forEach var="val" items="${mobileApp_list}">
								<option value="${val.code_id}" <c:if test="${val.code_id eq bo.mobile_app_kd_cd}">selected="selected"</c:if>>
									${val.code_name}
								</option>							
							</c:forEach>
						</select>
					</td>
          <td class="info">발송시간</td>
          <td class="tbtd_content">
            <select id="MOBILE_DISP_TIME" name="MOBILE_DISP_TIME"  style="width:80px;"></select>
            <select id="MOBILE_SEND_PREFER_CD" name="MOBILE_SEND_PREFER_CD">
              <c:forEach var="val" items="${mobileSendPreferCd}">
                <option value="${val.code_id}" <c:if test="${val.code_id eq bo.mobile_send_prefer_cd}">selected="selected"</c:if>>
                  ${val.code_name}
                </option>             
              </c:forEach>
            </select>
          </td>
				</tr>
        <tr>
          <td class="info">연결페이지</td>
          <td class="tbtd_content" colspan="3">
            <select id="MOBILE_LNK_PAGE_TYP" name="MOBILE_LNK_PAGE_TYP"  style="width:115px;">
                <option value="01" <c:if test="${bo.mobile_lnk_page_typ eq '01' or bo.mobile_lnk_page_typ == null or bo.mobile_lnk_page_typ == ''}">selected</c:if>>모바일+URL</option>
                <option value="02" <c:if test="${bo.mobile_lnk_page_typ eq '02'}">selected</c:if>>URL</option>
            </select>&nbsp;
            <c:if test="${bo.mobile_lnk_page_typ eq '01' or bo.mobile_lnk_page_typ == null or bo.mobile_lnk_page_typ == ''}">
              <c:set var="mobile_lnk_page_url" value="http://m.11st.co.kr"/>
            </c:if>
            <c:if test="${bo.mobile_lnk_page_typ eq '02'}">
              <c:set var="mobile_lnk_page_url" value="${bo.mobile_lnk_page_url }"/>
            </c:if>
            <input name="MOBILE_LNK_PAGE_URL" class="txt" id="MOBILE_LNK_PAGE_URL" style="width: 400px;" type="text" maxlength="150" readonly="readonly" value="${mobile_lnk_page_url}">
          </td>
        </tr>

				<tr>				
					<td class="info">노출일</td>		
					<td class="tbtd_content">
						<input type="text" id="MOBILE_DISP_DT" name="MOBILE_DISP_DT" class="txt" style="width:95px;"  
							<c:if test="${bo.mobile_disp_dt != null}">value="${bo.mobile_disp_dt}"</c:if>
							<c:if test="${bo.mobile_disp_dt == null && bo.camp_term_cd eq '01'}">value="${bo.camp_bgn_dt}"</c:if>						
						readonly="readonly"/>
						<c:if test="${bo.camp_term_cd eq '02'}"><!-- (전송일 +1일)  --></c:if>
					</td>
					<td class="info">우선순위</td>
					<td class="tbtd_content">
						<select id="MOBILE_PRIORITY_RNK" name="MOBILE_PRIORITY_RNK"  style="width:60px;">
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
										<option value="${val.code_id}" <c:if test="${val.code_id eq bo.mobile_priority_rnk}">selected="selected"</c:if>>
											${val.code_name}
										</option>
									<%-- </c:if>								 --%>
								</c:if>
								
							</c:forEach>					
						</select>
					</td>

				</tr>
				<tr>
					<td class="info">푸시알림제목</td>
					<td class="tbtd_content" colspan="3"><input type="text" id="MOBILE_DISP_TITLE" name="MOBILE_DISP_TITLE" style="width:350px;" value="${bo.mobile_disp_title}" class="txt" maxlength="100"/></td>				
				</tr>
				<tr>
					<td class="info">푸시알림내용</td>
					<td class="tbtd_content" colspan="3"><input type="text" id="MOBILE_CONTENT" name="MOBILE_CONTENT" style="width:550px;" value="${bo.mobile_content}" class="txt" maxlength="216"/></td>				
				</tr>
				
				<tr>
					<td class="info">알리미타임라인에노출</td>
					<td class="tbtd_content">
					<c:forEach var="val" items="${timeline_disp_yn}" varStatus="status">
						<input type="radio" name="TIMELINE_DISP_YN" class="txt"  value="${val.code_id}"
              <c:if test="${status.first}">checked="checked"</c:if>
              <c:if test="${val.code_id eq bo.timeline_disp_yn}">checked="checked"</c:if> /> ${val.code_name}
					</c:forEach>
					</td>
					<td class="info">썸네일이미지URL</td>
					<td class="tbtd_content" colspan="3">
						<div id="search2">
	                        <input type="text" id="THUM_IMG_URL" name="THUM_IMG_URL" style="width:200px;" value="${bo.thum_img_url}" class="txt" maxlength="100"/>
								<button type="button" class="btn btn-success btn-sm" onclick="fn_pre_view_img('THUM_IMG_URL');"><i class="fa fa-eye" aria-hidden="true"></i> 미리보기</button>
						</div>
					</td>
				</tr>
				
				<tr>
					<td class="info">알림표시방법</td>
					<td class="tbtd_content">
					
					<c:forEach var="val" items="${push_msg_popup_indc_yn}" varStatus="status">
						<input type="radio" name="PUSH_MSG_POPUP_INDC_YN" class="txt"  value="${val.code_id}"
            <c:if test="${status.first}">checked="checked"</c:if>
            <c:if test="${val.code_id eq bo.push_msg_popup_indc_yn}">checked="checked"</c:if>/> ${val.code_name}
					</c:forEach>
					
					</td>
					<td class="info">스테이터스바배너이미지URL</td>
					<td class="tbtd_content" colspan="3">
						<div id="search2">
              <input type="text" id="BNNR_IMG_URL" name="BNNR_IMG_URL" style="width:200px;" value="${bo.bnnr_img_url}" class="txt" maxlength="100"/>
              <button type="button" class="btn btn-success btn-sm" onclick="fn_pre_view_img('BNNR_IMG_URL');"><i class="fa fa-eye" aria-hidden="true"></i> 미리보기</button>
						</div>
					</td>
				</tr>
				
				<tr>
					<td class="info">추가텍스트</td>
					<td class="tbtd_content" colspan="3">
						            <table>
              <tr>
                <td>
                  <textarea name="MOBILE_ADD_TEXT" id="MOBILE_ADD_TEXT" rows="12" cols="90">${bo.mobile_add_text}</textarea>
                </td>
                <td width="10px"></td>
                <td valign="top">
                  <label fore="useIndi"><input type="checkbox" name="useIndi" value="Y" id="useIndi"  <c:if test="${bo.mobile_person_msg_yn eq 'Y'}"> checked</c:if> > 개인별 적용</label><br/>
                  <select style="width:150px; height:123px" size="4" id="VAL_LIST" name="VAL_LIST">
                    <c:forEach var="val" items="${vri_list}">
                      <option value="${val.vari_name}">
                        ${val.vari_name}
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
					<td class="tbtd_content" colspan="3">${bo.create_dt}</td>
				</tr>
	
				<tr>
					<td class="info">수정자</td>
					<td class="tbtd_content">${bo.update_nm}</td>
					<td class="info">수정일시</td>
					<td class="tbtd_content" colspan="3">${bo.update_dt}</td>
				</tr>				
			</table>
		</div>
	</div>		

	<div id="sysbtn" class="col-md-12" style="text-align:right;margin-bottom:10px;">
		<button type="button" class="btn btn-success btn-sm" onclick="fn_pre_view();"><i class="fa fa-eye" aria-hidden="true"></i> 미리보기</button>
		<button type="button" class="btn btn-success btn-sm" onclick="fn_save();"><i class="fa fa-floppy-o" aria-hidden="true"></i> 저장</button>
		<button type="button" class="btn btn-success btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i> 닫기</button>
	</div>
		

<div id="wrapA" style="position:fixed; display: none;left:25%; top: 100px; width: 563px; background-color:#ffffff;">
	<div style="background-color:#CDCDCD;border: 1px solid #ffffff;">
    <a href="javascript:fn_pre_viewClose();" class="bt">
      <img width="30" height="30" style="padding:0px; border:0px; margin-left: 95%;" alt="닫기" src="<c:url value='/image/btn/x_button.png'/>" >
    </a>
  </div>

	<!-- contents -->
	<section id="cts">
	<h1 class="top_tit"><a href="#">알리미</a></h1>
	<ul id="myAlimi" class="my_alimi">
		<li class="app">
			<div class="al_title btn_oc">
				
				<!-- 제목 -->
				<h2 class="tit"><span id="mo_title"></span></h2>
				
			</div>
			<div class="alimi_con">
				<div class="al_html" style="background-color:#ffffff; width:100%; height:355px; overflow-y:scroll;float:left;font-size:12px;line-height:15px;white-space:nowrap; ">
					
					<!-- 알림내용 -->
					<span id="mo_content"></span>
					
					<!-- 추가텍스트 -->
					<span id="mo_addText"></span>
					
				</div>
			</div>
			<a href="#" class="btn_amore btn_oc">더보기</a>
		</li>
	</ul>
	</section>
</div>


</form>
                   </div>
                            <div class="col-lg-1"></div>
                        </div>
                        <!--END BLOCK SECTION -->
                        <div class="col-lg-3"></div>
              
                      </div>
                      <!--END PAGE CONTENT -->

