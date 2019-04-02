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

<link href="${staticPATH }/css/jquery_1.9.2/base/jquery-ui-1.9.2.custom.css" rel="stylesheet">
<script src="${staticPATH }/js/jquery_1.9.2/jquery-1.8.3.js"></script>
<script src="${staticPATH }/js/jquery_1.9.2/jquery-ui-1.9.2.custom.js"></script>

	<!--
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
	-->

<style>
	.my_table { border-spacing: 0px; border: 0px; }
	.my_table td { padding: 0px; }
</style>


<script>
	//alimi list
	if (window.attachEvent) window.attachEvent("onload", function(){mwUI.listToggle('myAlimi', 'btn_oc', 'on', '더보기', '닫기');});
	else window.addEventListener("load",  function(){mwUI.listToggle('myAlimi', 'btn_oc', 'on', '더보기', '닫기');}, false);
</script>

<script>
	var oEditors = [];

	// this window resize
	//window.resizeTo(1180,910);
	window.resizeTo(1180,1100);

	// document.ready
	$(document).ready(function() {
		/*
		if ("${bo.channel_priority_yn}" == "N" && "${user.title}" != "N"){
			alert("해당캠페인은 채널우선순위적용이 [N]입니다\n사용자는 권한이 없으므로 채널정보를 입력할수 없습니다");
		}
		*/
		$("#MOBILE_DISP_DT").datepicker({
			showOn: "button",
			buttonImage: "${staticPATH }/image/calendar.gif",
			buttonImageOnly: true,
			buttonText: "Select date"
		});
		if ("${bo.camp_term_cd}" == "02"){ //캠페인 기간구분이 반복일경우 노출일 disable
			$("#MOBILE_DISP_DT" ).datepicker("disable");
			$("#MOBILE_DISP_DT" ).addClass("essentiality");
		}
		//오늘날짜 조회
		getToday();
		//채널선택시 페이지 이동
		$("#CHANNEL_CD").bind("change",fn_selectChannel);
		/*
		nhn.husky.EZCreator.createInIFrame({
			oAppRef: oEditors,
			elPlaceHolder: "MOBILE_ADD_TEXT",
			sSkinURI: "/UnicaExt/smartEdit/SmartEditor2Skin.html",
			htParams : {
				bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				fOnBeforeUnload : function(){
				}
			},
			fOnAppLoad : function(){
			},
			fCreator: "createSEditor2"
		});
		*/
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
		$("#VAL_LIST").dblclick(function() {
			$("#MOBILE_ADD_TEXT").focus();

			if (document.selection){
				cRange = document.selection.createRange();
				cRange.text = "{" + $("#VAL_LIST").val() + "}";
			} else {
				$("#MOBILE_ADD_TEXT").val($("#MOBILE_ADD_TEXT").val() + "{" + $("#VAL_LIST").val() + "}");
			}
		});
		$("#useIndi").click(function() {
			if ($('input:checkbox[id="useIndi"]').is(":checked") == true){
				$("#VAL_LIST").removeAttr("disabled");
			} else {
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
		
		// KANG-20190325: add fn_new_alimi() for the new tab
		fn_new_alimi();
	});

	function fn_set_mobile_lnk_page_url(){
		if ($("#MOBILE_LNK_PAGE_TYP").val() == "01" ) {
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
		if ($("#CHANNEL_CD").val() == "SMS"){
			frm.action = "${staticPATH }/channel/channelSms.do";
			frm.submit();
		}
		if ($("#CHANNEL_CD").val() == "EMAIL"){
			frm.action = "${staticPATH }/channel/channelEmail.do";
			frm.submit();
		}
		if ($("#CHANNEL_CD").val() == "TOAST"){
			frm.action = "${staticPATH }/channel/channelToast.do";
			frm.submit();
		}
		if ($("#CHANNEL_CD").val() == "MOBILE"){
			frm.action = "${staticPATH }/channel/channelMobile.do";
			frm.submit();
		}
		if ($("#CHANNEL_CD").val() == "LMS"){
			frm.action = "${staticPATH }/channel/channelLms.do";
			frm.submit();
		}
	}

	/* 등록 */
	function fn_save() {
		//유효성 체크
		if (!fn_validation()){
			return;
		}
		if (!confirm("저장 하시겠습니까?")){
			return;
		}
		var campaignid = $("#CampaignId").val();
		jQuery.ajax({
			url           : '${staticPATH }/setChannelMobile.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
			data          : $("#form").serialize(),
			success: function(result, option) {
				if (option=="success"){
					if (result.CMP_STATUS == "START"){
						alert("진행중인 캠페인은 수정할수 없습니다.");
					} else {
					alert("저장되었습니다");
						//부모창 재조회
						window.opener.fn_getCampaignDtl(campaignid);
						//창닫기
						fn_close();
					}
				} else {
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
		if ("${bo.camp_status_cd}" == "START"){
			$("#btn_save").hide();
			alert("진행중인 캠페인은 수정할수 없습니다.");
			return false;
		}
		/*
		if ("${bo.channel_priority_yn}" == "N" && "${user.title}" != "N"){
			alert("해당캠페인은 채널우선순위적용이 [N]입니다\n사용자는 권한이 없으므로 채널정보를 입력할수 없습니다");
			return false;
		}
		*/
		if ("${bo.camp_term_cd}" == "01") {
			if ($("#MOBILE_DISP_DT").val() =="") {
				alert("모바일알리미 노출일 입력하세요");
				$("#MOBILE_DISP_DT").focus();
				return false;
			}
			//from ~ to 일경우 노출일은 캠페인 기간에 포함되어야 한다
			if ("${bo.camp_bgn_dt}" > $("#MOBILE_DISP_DT").val() || "${bo.camp_end_dt}" < $("#MOBILE_DISP_DT").val()){
				alert("노출일이 캠페인기간에 포함되지 않습니다\n (캠페인기간 : ${bo.camp_bgn_dt} ~ ${bo.camp_end_dt} )");
				$("#MOBILE_DISP_DT").focus();
				return false;
			}
			// 수동전송여부 : Y && 채널우선순위적용여부 : N ==> 오늘부터 입력가능(즉시전송 가능)
			// 수동전송여부 : N && 채널우선순위적용여부 : N ==> 내일부터 입력가능
			// 수동전송여부 : N && 채널우선순위적용여부 : Y ==> 내일부터 입력가능( 2015.02.16 고도화로 모레에서 내일로 변경 )
			if ( "${bo.manual_trans_yn}" == "Y" && "${bo.channel_priority_yn}" =="N" ){ //오늘부터 입력가능
				if ($("#TO_DATE").val() > $("#MOBILE_DISP_DT").val()){
					alert("수동전송 [Y], 채널우선순위적용여부 [N]일경우 채널전송일은 오늘("+$("#TO_DATE").val()+") 이후여야 합니다");
					$("#MOBILE_DISP_DT").focus();
					return false;
				}
			} else if ( "${bo.manual_trans_yn}" == "N" && "${bo.channel_priority_yn}" =="N" ){ //내일부터 입력가능
				if ($("#TO_DATE_P1").val() > $("#MOBILE_DISP_DT").val()){
					alert("수동전송 [N], 채널우선순위적용여부 [N]일경우 채널전송일은 내일("+$("#TO_DATE_P1").val()+") 이후여야 합니다");
					$("#MOBILE_DISP_DT").focus();
					return false;
				}
			} else if ( "${bo.manual_trans_yn}" == "N" && "${bo.channel_priority_yn}" =="Y" ){ //내일부터 입력가능
				if ($("#TO_DATE_P1").val() > $("#MOBILE_DISP_DT").val()){
					alert("수동전송 [N], 채널우선순위적용여부 [Y]일경우 채널전송일은 내일("+$("#TO_DATE_P1").val()+") 이후여야 합니다");
					$("#MOBILE_DISP_DT").focus();
					return false;
				}
			}
		}
		if ($("#MOBILE_DISP_TITLE").val() ==""){
			alert("푸시알림 노출제목을 입력하세요");
			$("#MOBILE_DISP_TITLE").focus();
			return false;
		}
		if ($("#MOBILE_CONTENT").val() ==""){
			alert("푸시알림 노출내용을 입력하세요");
			$("#MOBILE_CONTENT").focus();
			return false;
		}
		if ($("#MOBILE_CONTENT").val().indexOf("(광고)") < 0){
			alert("푸시알림 노출내용에 (광고) 문구가 포함되어야 합니다.");
			$("#MOBILE_CONTENT").focus();
			return false;
		}
		//SMART EDIT 내용을 TEXTAREA로 옮김
		//oEditors.getById["MOBILE_ADD_TEXT"].exec("UPDATE_CONTENTS_FIELD", []);
		if ($("#MOBILE_ADD_TEXT").val() ==""){
			alert("푸시알림 추가텍스트를 입력하세요");
			return false;
		}
		return true;
	}

	//창닫기
	function fn_close(){
		//창닫기
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
				if (option == "success"){
					$("#TO_DATE").val(result.TO_DATE) ;
					$("#TO_DATE_P1").val(result.TO_DATE_P1) ;
					$("#TO_DATE_P2").val(result.TO_DATE_P2) ;
				} else {
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
		$("#wrapA").show();
	}


	/* 바로보기 닫기 */
	function fn_pre_viewClose(){
		//$("#wrapA").hide();
		$("#wrapA").hide();
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
				} else {
					$("#MOBILE_DISP_TIME").append("<option value='"+ii+jj+"'>"+ii+":"+jj+"PM</option>");
				}
			}
		}
	}

	/* 우선순위에 따른 SMS채널발송시간 설정 */
	function fn_chk_mobileSendTime() {
		var i = 1;
		var sendtime = new Array(${fn:length(priority_rank_sendtime)});
		var sendtimevalue = new Array(${fn:length(priority_rank_sendtime)});
		<c:forEach var="val" items="${priority_rank_sendtime}">
			sendtime[i] = "${val.code_id}";
			sendtimevalue[i] = "${val.code_name}";
			i++;
		</c:forEach>
		for( var i = 1; i <= $("#MOBILE_PRIORITY_RNK option").size() ; i++ ){
			if ( $("#MOBILE_PRIORITY_RNK").val() == sendtime[i] ){
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





<script>
	var cnj_img_view = null;

	function cnj_win_view(img){
		img_conf1= new Image();
		img_conf1.src=(img);
		cnj_view_conf(img);
	}

	function cnj_view_conf(img){
		if ((img_conf1.width != 0) && (img_conf1.height != 0)){
			cnj_view_img(img);
		} else {
			funzione="cnj_view_conf('"+img+"')";
			intervallo=setTimeout(funzione,20);
		}
	}

	function cnj_view_img(img){
		if (cnj_img_view != null) {
			if (!cnj_img_view.closed) {
				cnj_img_view.close();
			}
		}
		cnj_width=img_conf1.width+20;
		cnj_height=img_conf1.height+20;
		str_img="width="+cnj_width+",height="+cnj_height;
		cnj_img_view=window.open(img,"cnj_img_open",str_img);
		cnj_img_view.focus();
		return;
	}
</script>





<script>
	/* KANG-20190325: adding script */
	function fn_new_alimi() {
		// add the click event listeners
		
		$("#type-1").click(function() {
			fn_hide_all();
			$("#content-1").show();
		});

		$("#type-2").click(function() {
			fn_hide_all();
			$("#content-2").show();
		});
		
		$("#type-3").click(function() {
			fn_hide_all();
			$("#content-3").show();
		});
		
		$("#type-4").click(function() {
			fn_hide_all();
			$("#content-4").show();
		});
		
		$("#type-5").click(function() {
			fn_hide_all();
			$("#content-5").show();
		});
		
		$("#type-6").click(function() {
			fn_hide_all();
			$("#content-6").show();
		});

		// click id type-1
		fn_hide_all();
		$("#content-1").show();
		
		
		// nav-tabs-old made active
		document.getElementById("nav-tabs-old").click();
		
		// type-1
		$("#add_img1").click(function() {
			if (true) alert("#add_img1.click");
			
			// max of img1
			var IMG1_MAX_IDX = 5;
			// get the count of tr of table
			var idx = $("#add_img1_tbl tr").length;
			if (idx >= IMG1_MAX_IDX) {
				alert("더이상 추가할 수 없습니다.")
				return false;
			}
			idx += 1;
			
			var rowHtml = "";
			rowHtml += "<tr>";
			rowHtml += "  <td class=\"info\">";
			// rowHtml += "    이미지 URL " + idx + " &nbsp;&nbsp;";
			rowHtml += "    이미지 URL &nbsp;&nbsp;";
			rowHtml += "    <div class=\"dropdown float-right\">";
			rowHtml += "      <button type=\"button\" class=\"btn btn-primary dropdown-toggle\" style=\"height:20px;width:40px;padding:2px; font-size:12px;\" data-toggle=\"dropdown\">";
			rowHtml += "        Opt";
			rowHtml += "      </button>";
			rowHtml += "      <div class=\"dropdown-menu\">";
			rowHtml += "        <a class=\"dropdown-item\" href=\"javascript:fn_img_del(this);\">삭제</a>";
			rowHtml += "        <a class=\"dropdown-item\" href=\"javascript:fn_img_up(this);\">위로</a>";
			rowHtml += "        <a class=\"dropdown-item\" href=\"javascript:fn_img_down(this);\">아래</a>";
			rowHtml += "        <!-- a class=\"dropdown-item\" href=\"#\">Clear</a -->";
			rowHtml += "        <button type=\"button\" class=\"btn btn-primary item-del\" style=\"height:20px;width:30px;padding:2px; font-size:12px;\">항목</button>";
			rowHtml += "      </div>";
			rowHtml += "    </div>";
			rowHtml += "  </td>";
			rowHtml += "  <td colspan=\"3\">";
			rowHtml += "    <input type=\"text\" style=\"width:700px;\" value=\"\" class=\"txt\" maxlength=\"100\" placeholder=\"http://\"/>";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			
			$("#add_img1_tbl > tbody:last").append(rowHtml);
			
			// if idx is max of img1, hide
			if (idx == IMG1_MAX_IDX) {
				//$("#add_img1").hide();
				$("#add_img1").attr("disabled", true);
			}
		});
		$("#add_img1_tbl").click(function() {
			//alert("add_img1_tbl");
			//alert("tr count: " + $("#add_img1_tbl tr").length);
		});
		
		$(".item-del").click(function() {
			var trNum = $(this).closest('tr').prevAll().length;
			if (true) alert(".item-del : " + trNum);
		});
	}
	
	function fn_hide_all() {
		$("#content-1").hide();
		$("#content-2").hide();
		$("#content-3").hide();
		$("#content-4").hide();
		$("#content-5").hide();
		$("#content-6").hide();
	}
	
	function fn_img_del(evt) {
		var trNum = $(evt).closest('tr').prevAll().length;
		if (true) alert("fn_img_del() : " + trNum);
	}
	
	function fn_img_up(evt) {
		if (true) alert("fn_img_up()");
	}
	
	function fn_img_down(evt) {
		if (true) alert("fn_img_down()");
	}
</script>





<!--PAGE CONTENT -->
		<div id="content" style="width:100%; height100%;">
			<!--BLOCK SECTION -->
			<div class="row" style="width:100%; height100%;">
				<div class="col-lg-1"></div>
				<div class="col-lg-10">
					<div class="col-md-12 page-header" style="margin-top:0px;">
						<h3>채널 상세 정보.</h3>
					</div>
					<form name="form" id="form">
						<input type="hidden" id="CampaignId" name="CampaignId" value="${bo.campaignid}" />
						<input type="hidden" id="CAMPAIGNCODE" name="CAMPAIGNCODE" value="${bo.campaigncode}" />
						<input type="hidden" id="FLOWCHARTID" name="FLOWCHARTID" value="${bo.flowchartid}" />
						<input type="hidden" id="CELLID" name="CELLID" value="${bo.cellid}" />
						<input type="hidden" id="TO_DATE" name="TO_DATE" value="" />
						<input type="hidden" id="TO_DATE_P1" name="TO_DATE_P1" value="" />
						<input type="hidden" id="TO_DATE_P2" name="TO_DATE_P2" value="" />
	<!-- Nav tabs -->
						<ul class="nav nav-tabs">
							<li class="nav-item">
								<a id="nav-tabs-old" class="nav-link active" data-toggle="tab" href="#oldAlimi">(구)알리미등록창</a>
							</li>
							<li class="nav-item">
								<a id="nav-tabs-new" class="nav-link" data-toggle="tab" href="#newAlimi">(신)알리미등록창</a>
							</li>
						</ul>
			
	<!-- Tab panes -->
						<div class="tab-content" style="margin: 0; padding: 0;">
			<!-- ############# -->
			<!-- (구)알리미 등록창 -->
			<!-- ############# -->
							<div id="oldAlimi" class="container-fluid tab-pane active" style="margin: 0 0 0 0;"><br>
								<div>
									<h6>* 캠페인 기본</h6>
								</div>
								<div class="col-lg-12" id="table">
									<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
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
								</div>
								<div>
									<h6>* 캠페인 내용</h6>
								</div>
								<div class="col-lg-12" style="padding-top: 5px;">
									<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
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
													<c:if test="${bo.camp_term_cd eq '02'}">(전송일 +1일)</c:if>
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
															<%-- </c:if> --%>
														</c:if>
													</c:forEach>
												</select>
											</td>
										</tr>
		
										<tr>
											<td class="info">푸시알림제목</td>
											<td class="tbtd_content" colspan="3">
												<input type="text" id="MOBILE_DISP_TITLE" name="MOBILE_DISP_TITLE" style="width:350px;" value="${bo.mobile_disp_title}" class="txt" maxlength="100"/>
											</td>
										</tr>
		
										<!-- 광고 -->
										<c:set var="subjectVal" value="${bo.mobile_content}"/>
										<c:if test="${bo.mobile_content == '' || bo.mobile_content eq null}">
											<c:set var="subjectVal" value="(광고)"/>
										</c:if>
		
										<tr>
											<td class="info">푸시알림내용</td>
											<td class="tbtd_content" colspan="3"><input type="text" id="MOBILE_CONTENT" name="MOBILE_CONTENT" style="width:550px;" value="${subjectVal}" class="txt" maxlength="216"/></td>
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
													<input type="text" id="THUM_IMG_URL" name="THUM_IMG_URL" style="width:250px;" value="${bo.thum_img_url}" class="txt" maxlength="100"/>
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
											<td class="info">스테이터스바<br/>배너이미지URL</td>
											<td class="tbtd_content" colspan="3">
												<div id="search2">
													<input type="text" id="BNNR_IMG_URL" name="BNNR_IMG_URL" style="width:250px;" value="${bo.bnnr_img_url}" class="txt" maxlength="100"/>
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
															<textarea name="MOBILE_ADD_TEXT" id="MOBILE_ADD_TEXT" rows="12" cols="100">${bo.mobile_add_text}</textarea>
														</td>
														<td width="10px"></td>
														<td valign="top">
															<!-- label for="useIndiL"></label -->
															<input type="radio" name="useIndi" value="N" id="useIndia" <c:if test="${bo.mobile_person_msg_yn eq 'N'}"> checked</c:if> > 개인별 적용(안함)<br/>
															<input type="radio" name="useIndi" value="Y" id="useIndib" <c:if test="${bo.mobile_person_msg_yn eq 'Y'}"> checked</c:if> > 개인별 적용(DB방식)<br/>
															<input type="radio" name="useIndi" value="P" id="useIndic" <c:if test="${bo.mobile_person_msg_yn eq 'P'}"> checked</c:if> > 개인별 적용(API방식)<br/>
															
															<select style="width:150px; height:123px" size="4" id="VAL_LIST" name="VAL_LIST" disabled >
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
							
							
							
							
							
			<!-- ############# -->
			<!-- (신)알리미 등록창 -->
			<!-- ############# -->
							<div id="newAlimi" class="container-fluid tab-pane fade"><br>
								<div id="base">
									<div>
										<h6>* 기본내용(Base)</h6>
									</div>
									<div>
										<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
											<colgroup>
												<col width="15%"/>
												<col width="35%"/>
												<col width="15%"/>
												<col width="35%"/>
											</colgroup>
											<tr>
												<td class="info">알림톡 노출여부</td>
												<td class="tbtd_content" colspan="3">
													<input id='talk_expose' name='talk_expose' type='radio' checked /> 알림톡 노출 &nbsp;&nbsp;&nbsp;
													<input id='talk_expose' name='talk_expose' type='radio' /> 알림톡 미노출 &nbsp;&nbsp;&nbsp;
												</td>
											</tr>
											<tr>
												<td class="info">알림톡 방문록 텍스트</td>
												<td class="tbtd_content" colspan="3">
													<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
												</td>
											</tr>
											<tr>
												<td class="info">알림톡 타입</td>
												<td class="tbtd_content" colspan="3">
													<input id='type-1' name='type-content' type='radio' checked /> 타입-1 &nbsp;&nbsp;&nbsp;
													<input id='type-2' name='type-content' type='radio' /> 타입-2 &nbsp;&nbsp;&nbsp;
													<input id='type-3' name='type-content' type='radio' /> 타입-3 &nbsp;&nbsp;&nbsp;
													<input id='type-4' name='type-content' type='radio' /> 타입-4 &nbsp;&nbsp;&nbsp;
													<input id='type-5' name='type-content' type='radio' /> 타입-5 &nbsp;&nbsp;&nbsp;
													<input id='type-6' name='type-content' type='radio' /> 타입-6 &nbsp;&nbsp;&nbsp;
												</td>
											</tr>
										</table>
									</div>
								</div>
								<!-- 타입-1 -->
								<div id='content-1'>
									<div id="_master-1">
										<div>
											<h6>* 마스터내용(Master)</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info">제목 1</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">광고 표시 문구</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="(광고)" class="txt" maxlength="100" readonly/>
													</td>
												</tr>
												<tr>
													<td class="info">제목 2</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">제목 3</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_images-1">
										<div>
											<h6>* 이미지내용(Images)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<button id="add_img1" type="button" class="btn btn-primary" style="height:20px;width:50px;padding:2px; font-size:12px;">항목추가</button>&nbsp;&nbsp;
												<!-- button type="button" class="btn btn-primary" style="height:20px;width:40px;padding:2px; font-size:12px;" disabled>Reset</button -->&nbsp;&nbsp;
											</h6>
										</div>
										<div>
											<table id="add_img1_tbl" class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info">
														이미지 URL &nbsp;&nbsp;
														<div class="dropdown float-right">
															<button type="button" class="btn btn-primary dropdown-toggle" style="height:20px;width:40px;padding:2px; font-size:12px;" data-toggle="dropdown">
																Opt
															</button>
															<div class="dropdown-menu">
																<a class="dropdown-item" href="javascript:fn_img_del(this);">삭제</a> |
																<a class="dropdown-item" href="javascript:fn_img_up(this);">위로</a> |
																<a class="dropdown-item" href="javascript:fn_img_down(this);">아래</a> |
																<a class="dropdown-item" href="#">클리어</a>
																<button type="button" class="btn btn-primary item-del" style="height:20px;width:30px;padding:2px; font-size:12px;">항목</button>
															</div>
														</div>
													</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100" placeholder="http://"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_footer-1">
										<div>
											<h6>* 하단내용(Footer)</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info" colspan="2">하단 문구</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info" rowspan="2">상세보기</td>
													<td class="info">Mobile URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">Web URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
								</div>
								<!-- 타입-2 -->
								<div id='content-2'>
									<div id="_master-2">
										<div>
											<h6>* 마스터내용(Master)</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info">제목 1</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">광고 표시 문구</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="(광고)" class="txt" maxlength="100" readonly/>
													</td>
												</tr>
												<tr>
													<td class="info">제목 2</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">제목 3</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_images-2">
										<div>
											<h6>* 이미지내용(Images)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:50px;padding:2px; font-size:12px;" >항목추가</button>&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:40px;padding:2px; font-size:12px;" disabled>Reset</button>&nbsp;&nbsp;
											</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info">
														이미지 URL 1 &nbsp;&nbsp;
														<div class="dropdown float-right">
															<button type="button" disabled class="btn btn-primary dropdown-toggle" style="height:20px;width:40px;padding:2px; font-size:12px;" data-toggle="dropdown">
																Opt
															</button>
															<div class="dropdown-menu">
																<a class="dropdown-item" href="#">Delete</a>
																<a class="dropdown-item" href="#">Up</a>
																<a class="dropdown-item" href="#">Down</a>
																<a class="dropdown-item" href="#">Clear</a>
															</div>
														</div>
													</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_goods-2">
										<div>
											<h6>* 상품내용(Goods)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:50px;padding:2px; font-size:12px;" >항목추가</button>&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:40px;padding:2px; font-size:12px;" disabled>Reset</button>&nbsp;&nbsp;
											</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info" rowspan="6">
														상품 1 &nbsp;&nbsp;
														<div class="dropdown float-right">
															<button type="button" class="btn btn-primary dropdown-toggle" style="height:20px;width:40px;padding:2px; font-size:12px;" data-toggle="dropdown">
																Opt
															</button>
															<div class="dropdown-menu">
																<a class="dropdown-item" href="#">Delete</a>
																<a class="dropdown-item" href="#">Up</a>
																<a class="dropdown-item" href="#">Down</a>
																<a class="dropdown-item" href="#">Clear</a>
															</div>
														</div>
													</td>
													<td class="info">이미지 URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">품명</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">가격</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">표시단위</td>
													<td colspan="2">
														<input id='money_sign2' name='money_sign2' type='radio' checked /> 원 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input id='money_sign2' name='money_sign2' type='radio' /> 달러 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input id='money_sign2' name='money_sign2' type='radio' /> 엔 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input id='money_sign2' name='money_sign2' type='radio' /> 위완화 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input id='money_sign2' name='money_sign2' type='radio' /> 유로화 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
													</td>
												</tr>
												<tr>
													<td class="info">보기(Mobile URL)</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">보기(Web URL)</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_footer-2">
										<div>
											<h6>* 하단내용(Footer)</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info" colspan="2">하단 문구</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info" rowspan="2">상세보기</td>
													<td class="info">Mobile URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">Web URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
								</div>
								<!-- 타입-3 -->
								<div id='content-3'>
									<div id="_master-3">
										<div>
											<h6>* 마스터내용(Master)</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info">제목 1</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">광고 표시 문구</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="(광고)" class="txt" maxlength="100" readonly/>
													</td>
												</tr>
												<tr>
													<td class="info">제목 2</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">제목 3</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_images-3">
										<div>
											<h6>* 이미지내용(Images)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:50px;padding:2px; font-size:12px;" >항목추가</button>&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:40px;padding:2px; font-size:12px;" disabled>Reset</button>&nbsp;&nbsp;
											</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info">
														이미지 URL 1 &nbsp;&nbsp;
														<div class="dropdown float-right">
															<button type="button" class="btn btn-primary dropdown-toggle" style="height:20px;width:40px;padding:2px; font-size:12px;" data-toggle="dropdown">
																Opt
															</button>
															<div class="dropdown-menu">
																<a class="dropdown-item" href="#">Delete</a>
																<a class="dropdown-item" href="#">Up</a>
																<a class="dropdown-item" href="#">Down</a>
																<a class="dropdown-item" href="#">Clear</a>
															</div>
														</div>
													</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_coupons-3">
										<div>
											<h6>* 쿠폰내용(Coupons)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:50px;padding:2px; font-size:12px;" >항목추가</button>&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:40px;padding:2px; font-size:12px;" disabled>Reset</button>&nbsp;&nbsp;
											</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info" rowspan="6">
														쿠폰 1 &nbsp;&nbsp;
														<div class="dropdown float-right">
															<button type="button" class="btn btn-primary dropdown-toggle" style="height:20px;width:40px;padding:2px; font-size:12px;" data-toggle="dropdown">
																Opt
															</button>
															<div class="dropdown-menu">
																<a class="dropdown-item" href="#">Delete</a>
																<a class="dropdown-item" href="#">Up</a>
																<a class="dropdown-item" href="#">Down</a>
																<a class="dropdown-item" href="#">Clear</a>
															</div>
														</div>
													</td>
													<td class="info">문구 1</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">문구 2</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">문구 3</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">문구 4</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">쿠폰번호</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">다운받기 노출</td>
													<td colspan="2">
														<input id='expose3' name='expose3' type='radio' checked /> 쿠폰 노출 &nbsp;&nbsp;&nbsp;
														<input id='expose3' name='expose3' type='radio' /> 쿠폰 미노출 &nbsp;&nbsp;&nbsp;
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_footer-3">
										<div>
											<h6>* 하단내용(Footer)</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info" colspan="2">하단 문구</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info" rowspan="2">상세보기</td>
													<td class="info">Mobile URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">Web URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
								</div>
								<!-- 타입-4 -->
								<div id='content-4'>
									<div id="_master-4">
										<div>
											<h6>* 마스터내용(Master)</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info">제목 1</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">광고 표시 문구</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="(광고)" class="txt" maxlength="100" readonly/>
													</td>
												</tr>
												<tr>
													<td class="info">제목 2</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">제목 3</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_announce-4">
										<div>
											<h6>* 안내내용(Announce)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:50px;padding:2px; font-size:12px;" >항목추가</button>&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:40px;padding:2px; font-size:12px;" disabled>Reset</button>&nbsp;&nbsp;
											</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info" rowspan="2">
														안내 1 &nbsp;&nbsp;
														<div class="dropdown float-right">
															<button type="button" class="btn btn-primary dropdown-toggle" style="height:20px;width:40px;padding:2px; font-size:12px;" data-toggle="dropdown">
																Opt
															</button>
															<div class="dropdown-menu">
																<a class="dropdown-item" href="#">Delete</a>
																<a class="dropdown-item" href="#">Up</a>
																<a class="dropdown-item" href="#">Down</a>
																<a class="dropdown-item" href="#">Clear</a>
															</div>
														</div>
													</td>
													<td class="info">문구</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">정렬</td>
													<td colspan="2">
														<input id='arrange' name='arrange' type='radio' /> 좌측정렬 &nbsp;&nbsp;&nbsp;
														<input id='arrange' name='arrange' type='radio' checked /> 중앙정렬 &nbsp;&nbsp;&nbsp;
														<input id='arrange' name='arrange' type='radio' /> 우측정렬 &nbsp;&nbsp;&nbsp;
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_footer-4">
										<div>
											<h6>* 하단내용(Footer)</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info" colspan="2">하단 문구</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info" rowspan="2">상세보기</td>
													<td class="info">Mobile URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">Web URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
								</div>
								<!-- 타입-5 -->
								<div id='content-5'>
									<div id="_master-5">
										<div>
											<h6>* 마스터내용(Master)</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info">제목 1</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">광고 표시 문구</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="(광고)" class="txt" maxlength="100" readonly/>
													</td>
												</tr>
												<tr>
													<td class="info">제목 2</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">제목 3</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_goods-5">
										<div>
											<h6>* 상품내용(Goods)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:50px;padding:2px; font-size:12px;" >항목추가</button>&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:40px;padding:2px; font-size:12px;" disabled>Reset</button>&nbsp;&nbsp;
											</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info" rowspan="6">
														상품 1 &nbsp;&nbsp;
														<div class="dropdown float-right">
															<button type="button" class="btn btn-primary dropdown-toggle" style="height:20px;width:40px;padding:2px; font-size:12px;" data-toggle="dropdown">
																Opt
															</button>
															<div class="dropdown-menu">
																<a class="dropdown-item" href="#">Delete</a>
																<a class="dropdown-item" href="#">Up</a>
																<a class="dropdown-item" href="#">Down</a>
																<a class="dropdown-item" href="#">Clear</a>
															</div>
														</div>
													</td>
													<td class="info">이미지 URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">품명</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">가격</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">표시단위</td>
													<td colspan="2">
														<input id='money_sign5' name='money_sign5' type='radio' checked /> 원 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input id='money_sign5' name='money_sign5' type='radio' /> 달러 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input id='money_sign5' name='money_sign5' type='radio' /> 엔 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input id='money_sign5' name='money_sign5' type='radio' /> 위완화 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														<input id='money_sign5' name='money_sign5' type='radio' /> 유로화 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
													</td>
												</tr>
												<tr>
													<td class="info">보기(Mobile URL)</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">보기(Web URL)</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_footer-5">
										<div>
											<h6>* 하단내용(Footer)</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info" colspan="2">하단 문구</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info" rowspan="2">상세보기</td>
													<td class="info">Mobile URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">Web URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
								</div>
								<!-- 타입-6 -->
								<div id='content-6'>
									<div id="_master-6">
										<div>
											<h6>* 마스터내용(Master)</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info">제목 1</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">광고 표시 문구</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="(광고)" class="txt" maxlength="100" readonly/>
													</td>
												</tr>
												<tr>
													<td class="info">제목 2</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">제목 3</td>
													<td colspan="3">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_coupons-6">
										<div>
											<h6>* 쿠폰내용(Coupons)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:50px;padding:2px; font-size:12px;" >항목추가</button>&nbsp;&nbsp;
												<button type="button" class="btn btn-primary" style="height:20px;width:40px;padding:2px; font-size:12px;" disabled>Reset</button>&nbsp;&nbsp;
											</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info" rowspan="6">
														쿠폰 1 &nbsp;&nbsp;
														<div class="dropdown float-right">
															<button type="button" class="btn btn-primary dropdown-toggle" style="height:20px;width:40px;padding:2px; font-size:12px;" data-toggle="dropdown">
																Opt
															</button>
															<div class="dropdown-menu">
																<a class="dropdown-item" href="#">Delete</a>
																<a class="dropdown-item" href="#">Up</a>
																<a class="dropdown-item" href="#">Down</a>
																<a class="dropdown-item" href="#">Clear</a>
															</div>
														</div>
													</td>
													<td class="info">문구 1</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">문구 2</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">문구 3</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">문구 4</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">쿠폰번호</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">다운받기 노출</td>
													<td colspan="2">
														<input id='expose' name='expose' type='radio' checked /> 쿠폰 노출 &nbsp;&nbsp;&nbsp;
														<input id='expose' name='expose' type='radio' /> 쿠폰 미노출 &nbsp;&nbsp;&nbsp;
													</td>
												</tr>
											</table>
										</div>
									</div>
									<div id="_footer-6">
										<div>
											<h6>* 하단내용(Footer)</h6>
										</div>
										<div>
											<table class="table table-striped table-hover table-condensed table-bordered my_table" style="width: 100%;">
												<colgroup>
													<col width="15%"/>
													<col width="15%"/>
													<col width="15%"/>
													<col width="55%"/>
												</colgroup>
												<tr>
													<td class="info" colspan="2">하단 문구</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info" rowspan="2">상세보기</td>
													<td class="info">Mobile URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
												<tr>
													<td class="info">Web URL</td>
													<td colspan="2">
														<input type="text" style="width:700px;" value="" class="txt" maxlength="100"/>
													</td>
												</tr>
											</table>
										</div>
									</div>
								</div>
							</div>
							
							
							
							
							
						</div>

						<div id="sysbtn" class="col-md-12" style="text-align: right; margin: 10px 10px 0px 0px;">
							<button type="button" class="btn btn-success btn-sm" onclick="fn_pre_view();"><i class="fa fa-eye" aria-hidden="true"></i> 미리보기</button>
							<button type="button" class="btn btn-danger btn-sm" onclick="fn_save();"><i class="fa fa-floppy-o" aria-hidden="true"></i> 저장</button>
							<button type="button" class="btn btn-default btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i> 닫기</button>
						</div>
					
					</form>
				</div>
			</div>
		</div>
<!--PAGE CONTENT END -->

		<div style="visibility: hidden; background-color:#e00; height:10px;"></div>  <!-- visibility: hidden/visible -->

