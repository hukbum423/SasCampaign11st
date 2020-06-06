<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_pop.jsp"%>



<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<!-- 운영 -->
<link rel="stylesheet" href="http://c.m.011st.com/MW/css/my/my.css" />
<script src="http://c.m.011st.com/MW/js/ui/ui.js"></script>

<script type="text/javascript"
	src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>

<link
	href="${staticPATH }/css/jquery_1.9.2/base/jquery-ui-1.9.2.custom.css"
	rel="stylesheet">
<script src="${staticPATH }/js/jquery_1.9.2/jquery-1.8.3.js"></script>
<script src="${staticPATH }/js/jquery_1.9.2/jquery-ui-1.9.2.custom.js"></script>

<!--
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
	-->

<style>
/*
		KANG-20190315: add for the belows
		cellmargin = 0; cellpadding = 0;
	*/
.my_table {
	border-spacing: 0px;
	border: 0px;
}

.my_table td {
	padding: 0px;
}
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
	window.resizeTo(1180,1060);  // KANG-20190323: resize of the popup
	//window.resizeTo(1180,1110);  // KANG-20190323: resize of the popup

	// document.ready
	$(document).ready(function() {
		// KANG-20200414: 'copyChannel' button viewable
		if (!true) {
			alert(">>>>> channelSms.jsp (CELLID,CHANNEL_CD,COPYCHANNEL) = (${CELLID},${CHANNEL_CD},${COPYCHANNEL})\n"
				+ " bo = .${bo.campaignid}.${bo.cellid}.${bo.channel_cd}.");
		}
		if (!true && "${COPYCHANNEL}" != "YES") {
			$("#copyChannel").hide();
		}

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
		
		// KANG-20200508:
		//$("#BNNR_IMG_URL").bind("change", fn_change_bnnr_img_url);
		//fn_change_bnnr_img_url();
		
		// KANG-20190325: add fn_newAlimi_init() for the new tab
		if (true) fn_newAlimi_init();
	});
	
	// 
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
		if (true) {
			var json = fn_get_alimi_json();
			if (!true) console.log("> " + json);
			if (json == false) {
				return false;
			}
			$('#ALIMI_PARAMS').val(json);
			if (true) console.log("> fn_save() processing: " + $('#ALIMI_PARAMS').val());
			//return true;
		}
		//유효성 체크
		if (!fn_validation()){   // KANG-20200416
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
						if ("${COPYCHANNEL}" != "YES") window.opener.fn_getCampaignDtl(campaignid);  // KANG-20200417
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
		if (true) {
			// KANG-20200508: 스테이터스바/배너이미지URL
			var bnnr_img_url = $("#BNNR_IMG_URL").val();
			var bnnr_str_img_url = $("#BNNR_STR_IMG_URL").val();
			if (bnnr_img_url != "" && bnnr_str_img_url == "")
				flg_bnnr_str_img_url = false;
			
			if (!true) alert(">>>>> KANG-20200508: fn_validation() \n"
					+ "flg_bnnr_str_img_url: " + flg_bnnr_str_img_url + "\n"
					+ "bnnr_img_url: " + bnnr_img_url + "\n"
					+ "bnnr_str_img_url: " + bnnr_str_img_url + "\n"
					);
			if (!flg_bnnr_str_img_url) {   // KANG-20200525: false추가, KANG-20200531: false제거
				alert("'스테이터스바/배너이미지URL' 항목의 [적용&보기] 버튼을 먼저 확인하세요.")
				// $("#BNNR_STR_IMG_URL").focus();
				$("#BNNR_STR_IMG_URL_BUTTON").focus();  // focus on the button
				return false;
			}
		}
		
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
</script>

<script>
	//
	// KANG-20200508: 스테이터스바/배너이미지URL
	// sample: http://i.011st.com/ui_img/cm_display/2017/03/MDP/1798-15/alimpush.png
	// search for fn_validation

	// KANG-20200508: flag for bnnr_img_url
	var flg_bnnr_str_img_url = true;

	// KANG-20200508: ready
	$(function() {
		$("#BNNR_IMG_URL").bind("change", fn_change_bnnr_img_url);
		//fn_change_bnnr_img_url();
	});

	// KANG-20200508: bnnr_img_url 값이 변할 때의 이벤트
	function fn_change_bnnr_img_url() {
		var bannerImg = $("#BNNR_IMG_URL").val();
		if (!true) alert(">>>>> KANG-20200428: fn_change_bnnr_img_url: '" + bannerImg + "'.");
		flg_bnnr_str_img_url = false;
		return;
	}

	// KANG-20200508: bnnr_img_url viewer
	function fn_pre_view_img(target){
		var targetImg = document.getElementById(target).value;
		var img = new Image();
		img.src = targetImg;
		//alert(img.width + ' '+img.height);
		//alert(e.pageX + '' + e.pageY);
		cnj_win_view(targetImg);
	}
	
	// KANG-20200508: bnnr_str_img_url viewer
	function fn_pre_view_str_img(){
		var bannerImg = $("#BNNR_IMG_URL").val();
		jQuery.ajax({
			url           : '${staticPATH }/channel/makeBnnrStrUrl.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
			data          : {
				"bannerImg": bannerImg
			},
			success: function (result, option) {
				if (option == "success"){
					if (!true) alert("만들었습니다.");
					// $("#BNNR_STR_IMG_URL").val("." + bannerImg + ".");
					$("#BNNR_STR_IMG_URL").val(result.rolImg);
					var targetImg = result.rolImg;
					var img = new Image();
					img.src = targetImg;
					//alert(img.width + ' '+img.height);
					//alert(e.pageX + '' + e.pageY);
					cnj_win_view(targetImg);
					flg_bnnr_str_img_url = true;
				} else {
					alert("에러가 발생하였습니다.");
				}
			},
			error: function(result, option) {
				alert("에러가 발생하였습니다.");
			}
		});
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
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	// KANG-20190325: new alimi script
	////////////////////////////////////////////////////////////////////////////////////
	function fn_for_test() {
		if (!true) alert("fn_for_test();");
		var base = { alimiShow: "show", alimiText: "임시" };
		var master = { title1: "1", title2: "2", title3: "3" };
		var arrImg2 = JSON.parse("["
			+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample1.png\"},"
			+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample2.png\"},"
			+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample1.png\"},"
			+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample2.png\"},"
			+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample1.png\"}"
			+ "]");

		// var obj = Object.assign(base, master, { arrImg: arrImg2 }, { arrPrd: arrPrd2 }, footer);
		var ret = "{" + fn_getCore(base) + "," + fn_getCore(master) + ", \"arrImg\":" + fn_getCore(arrImg2) + "}";
		console.log(">>>>> " + ret);

		var obj = JSON.parse(ret);
		console.log(">>>>> " + JSON.stringify(obj));
	}
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	// data for clear
	var _base = { alimiShow: "hide", alimiText: "", alimiType: "type1" };
	var _master = { title1: "", advText: "광고", title2: "", title3: "" };
	var _footer = { ftrText: "", ftrMblUrl: "", ftrWebUrl: "" };
	//var master = { title1: "title1", advText: "advText", title2: "title2", title3: "title3" };
	//var footer = { ftrText: "ftrText", ftrMblUrl: "http://localhost/mobile", ftrWebUrl: "http://localhost/web" };
	var _arrImg1 = [ { imgUrl: "" }];
	var _arrImg2 = [ { imgUrl: "" }];
	var _arrPrd2 = [ { prdUrl: "", prdName: "", prdPrice: "", prdUnit: "", prdMblUrl: "", prdWebUrl: "" } ];
	var _arrImg3 = [ { imgUrl: "" }];
	var _arrCpn3 = [ { cpnText1: "", cpnText2: "", cpnText3: "", cpnText4: "", cpnNumber: "", cpnVisible: "hide" } ];
	var _arrAnn4 = [ { annText: "", annFixed: "center" } ];
	var _arrPrd5 = [ { prdUrl: "", prdName: "", prdPrice: "", prdUnit: "", prdMblUrl: "", prdWebUrl: "" } ];
	var _arrCpn6 = [ { cpnText1: "", cpnText2: "", cpnText3: "", cpnText4: "", cpnNumber: "", cpnVisible: "hide" } ];
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	// data for usable
	var base = null;
	var master = null;
	var footer = null;
	var arrImg1 = null;
	var arrImg2 = null;
	var arrPrd2 = null;
	var arrImg3 = null;
	var arrCpn3 = null;
	var arrAnn4 = null;
	var arrPrd5 = null;
	var arrCpn6 = null;
</script>







<script>
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	var fn_cloneObject = function(obj) { return JSON.parse(JSON.stringify(obj)); };
	var fn_valueClear = function() {
		base = fn_cloneObject(_base);
		master = fn_cloneObject(_master);
		footer = fn_cloneObject(_footer);
		arrImg1 = fn_cloneObject(_arrImg1);
		arrImg2 = fn_cloneObject(_arrImg2);
		arrPrd2 = fn_cloneObject(_arrPrd2);
		arrImg3 = fn_cloneObject(_arrImg3);
		arrCpn3 = fn_cloneObject(_arrCpn3);
		arrAnn4 = fn_cloneObject(_arrAnn4);
		arrPrd5 = fn_cloneObject(_arrPrd5);
		arrCpn6 = fn_cloneObject(_arrCpn6);
	}
	fn_valueClear();     // set data to default values
	//
	function fn_getCore(orgObj) {              // for Object.assign on MS
		var jsonObj = JSON.stringify(orgObj)
		if (jsonObj.charAt(0) == '[') {
			//return JSON.stringify(orgObj);   // array
			return jsonObj;   // array
		} else {
			return jsonObj.substring(jsonObj.indexOf("{")+1, jsonObj.lastIndexOf("}"));
		}
	}
	function fn_checkQuotationMark(txt) {      // if contains some quotations, then return true.
		var result = txt.search("['\"]");
		if (result >= 0) {
			if (true) alert("인용부호( ' , \" )는 사용할 수 없습니다.");
			return true;
		}
		return false;
	}
	function fn_checkUrlSpace(txt) {      // KANG-20190530: If contains some white spaces, then return true
		var idx = -1;
		if (txt.indexOf(' ') >= 0) {
			if (true) alert("공백은 제외해 주세요.");
			return true;
		}
		if (txt.indexOf('\t') >= 0) {
			if (true) alert("공백은 제외해 주세요.");
			return true;
		}
		if (txt.indexOf('\n') >= 0) {
			if (true) alert("공백은 제외해 주세요.");
			return true;
		}
		
		return false;
	}
	// 넘어온 값이 빈값인지 체크합니다. 
	// !value 하면 생기는 논리적 오류를 제거하기 위해 
	// 명시적으로 value == 사용 
	// [], {} 도 빈값으로 처리 
	function isEmpty(value) {
		if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ){
			return true;
		} else {
			return false;
		}
	}
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	function fn_clearDisableAlimi_master() {
		if (true) console.log("fn_clearDisableAlimi_master(): ");
		$('input[name=alimiShow]').val(['hide']).attr('disabled',false);
		$('#alimiText').val("").attr('readonly',true);
		$('input[name=alimiType]').val(['']).attr('disabled',true);
	}
	function fn_clearDisableAlimi_type(type) {
		if (true) console.log("fn_clearDisableAlimi_type(" + type + "): ");
		$('#' + type + '_title1').val("").attr('readonly',true);
		$('#' + type + '_advText').val("").attr('readonly',true);
		$('#' + type + '_title2').val("").attr('readonly',true);
		$('#' + type + '_title3').val("").attr('readonly',true);
		switch (type) {
		case "type1":
			{
				arrImg1.forEach(function(value, index, array) {
					$('#type1_imgUrl' + index).val("").attr('readonly',true);
				});
				// button(항목추가 / 미리보기) disabled
				$('#img1_addItem').attr('disabled', true);  // 항목추가
				$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		case "type2":
			{
				arrImg2.forEach(function(value, index, array) {
					$('#type2_imgUrl' + index).val("").attr('readonly',true);
				});
				arrPrd2.forEach(function(value, index, array) {
					$('#type2_prdUrl' + index).val("").attr('readonly',true);
					$('#type2_prdName' + index).val("").attr('readonly',true);
					$('#type2_prdPrice' + index).val("").attr('readonly',true);
					$('#type2_prdUnit' + index).val("").attr('readonly',true);
					$('#type2_prdMblUrl' + index).val("").attr('readonly',true);
					$('#type2_prdWebUrl' + index).val("").attr('readonly',true);
				});
				// button(항목추가 / 미리보기) disabled
				$('#img2_addItem').attr('disabled', true);  // 항목추가
				$('#prd2_addItem').attr('disabled', true);  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		case "type3":
			{
				arrImg3.forEach(function(value, index, array) {
					$('#type3_imgUrl' + index).val("").attr('readonly',true);
				});
				arrCpn3.forEach(function(value, index, array) {
					$('#type3_cpnText1' + index).val("").attr('readonly',true);
					$('#type3_cpnText2' + index).val("").attr('readonly',true);
					$('#type3_cpnText3' + index).val("").attr('readonly',true);
					$('#type3_cpnText4' + index).val("").attr('readonly',true);
					$('#type3_cpnNumber' + index).val("").attr('readonly',true);
					$('input[name=cpnVisible3' + index + ']').val([""]).attr('disabled', true);
				});
				// button(항목추가 / 미리보기) disabled
				$('#img3_addItem').attr('disabled', true);  // 항목추가
				$('#cpn3_addItem').attr('disabled', true);  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		case "type4":
			{
				arrAnn4.forEach(function(value, index, array) {
					$('#type4_annText' + index).val("").attr('readonly',true);
					$('input[name=annFixed' + index + ']').val([""]).attr('disabled', true);
				});
				// button(항목추가 / 미리보기) disabled
				$('#ann4_addItem').attr('disabled', true);  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		case "type5":
			{
				arrPrd5.forEach(function(value, index, array) {
					$('#type5_prdUrl' + index).val("").attr('readonly',true);
					$('#type5_prdName' + index).val("").attr('readonly',true);
					$('#type5_prdPrice' + index).val("").attr('readonly',true);
					$('#type5_prdUnit' + index).val("").attr('readonly',true);
					$('#type5_prdMblUrl' + index).val("").attr('readonly',true);
					$('#type5_prdWebUrl' + index).val("").attr('readonly',true);
				});
				// button(항목추가 / 미리보기) disabled
				$('#prd5_addItem').attr('disabled', true);  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		case "type6":
			{
				arrCpn6.forEach(function(value, index, array) {
					$('#type6_cpnText1' + index).val("").attr('readonly',true);
					$('#type6_cpnText2' + index).val("").attr('readonly',true);
					$('#type6_cpnText3' + index).val("").attr('readonly',true);
					$('#type6_cpnText4' + index).val("").attr('readonly',true);
					$('#type6_cpnNumber' + index).val("").attr('readonly',true);
					$('input[name=cpnVisible6' + index + ']').val([""]).attr('disabled', true)
				});
				// button(항목추가 / 미리보기) disabled
				$('#cpn6_addItem').attr('disabled', true);  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		default:
			break;
		}
		$('#' + type + '_ftrText').val("").attr('readonly',true);
		$('#' + type + '_ftrMblUrl').val("").attr('readonly',true);
		$('#' + type + '_ftrWebUrl').val("").attr('readonly',true);
	}
	function fn_clearDisableAlimi() {
		fn_clearDisableAlimi_master();
		fn_clearDisableAlimi_type('type1');
		fn_clearDisableAlimi_type('type2');
		fn_clearDisableAlimi_type('type3');
		fn_clearDisableAlimi_type('type4');
		fn_clearDisableAlimi_type('type5');
		fn_clearDisableAlimi_type('type6');
	}
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	function fn_disableAlimi_master() {
		if (true) console.log("fn_disableAlimi_master(): ");
		$('#alimiText').attr('readonly',true);
		$('input[name=alimiType]').attr('disabled',true);
	}
	function fn_disableAlimi_type(type) {
		if (true) console.log("fn_disableAlimi_type(" + type + "): ");
		$('#' + type + '_title1').attr('readonly',true);
		$('#' + type + '_advText').attr('readonly',true);
		$('#' + type + '_title2').attr('readonly',true);
		$('#' + type + '_title3').attr('readonly',true);
		switch (type) {
		case "type1":
			{
				arrImg1.forEach(function(value, index, array) {
					$('#type1_imgUrl' + index).attr('readonly',true);
				});
				// button(항목추가 / 미리보기) disabled
				$('#img1_addItem').attr('disabled', true);  // 항목추가
				$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		case "type2":
			{
				arrImg2.forEach(function(value, index, array) {
					$('#type2_imgUrl' + index).attr('readonly',true);
				});
				arrPrd2.forEach(function(value, index, array) {
					$('#type2_prdUrl' + index).attr('readonly',true);
					$('#type2_prdName' + index).attr('readonly',true);
					$('#type2_prdPrice' + index).attr('readonly',true);
					$('#type2_prdUnit' + index).attr('readonly',true);
					$('#type2_prdMblUrl' + index).attr('readonly',true);
					$('#type2_prdWebUrl' + index).attr('readonly',true);
				});
				// button(항목추가 / 미리보기) disabled
				$('#img2_addItem').attr('disabled', true);  // 항목추가
				$('#prd2_addItem').attr('disabled', true);  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		case "type3":
			{
				arrImg3.forEach(function(value, index, array) {
					$('#type3_imgUrl' + index).attr('readonly',true);
				});
				arrCpn3.forEach(function(value, index, array) {
					$('#type3_cpnText1' + index).attr('readonly',true);
					$('#type3_cpnText2' + index).attr('readonly',true);
					$('#type3_cpnText3' + index).attr('readonly',true);
					$('#type3_cpnText4' + index).attr('readonly',true);
					$('#type3_cpnNumber' + index).attr('readonly',true);
					$('input[name=cpnVisible3' + index + ']').attr('disabled', true);
				});
				// button(항목추가 / 미리보기) disabled
				$('#img3_addItem').attr('disabled', true);  // 항목추가
				$('#cpn3_addItem').attr('disabled', true);  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		case "type4":
			{
				arrAnn4.forEach(function(value, index, array) {
					$('#type4_annText' + index).attr('readonly',true);
					$('input[name=annFixed' + index + ']').attr('disabled', true);
				});
				// button(항목추가 / 미리보기) disabled
				$('#ann4_addItem').attr('disabled', true);  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		case "type5":
			{
				arrPrd5.forEach(function(value, index, array) {
					$('#type5_prdUrl' + index).attr('readonly',true);
					$('#type5_prdName' + index).attr('readonly',true);
					$('#type5_prdPrice' + index).attr('readonly',true);
					$('#type5_prdUnit' + index).attr('readonly',true);
					$('#type5_prdMblUrl' + index).attr('readonly',true);
					$('#type5_prdWebUrl' + index).attr('readonly',true);
				});
				// button(항목추가 / 미리보기) disabled
				$('#prd5_addItem').attr('disabled', true);  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		case "type6":
			{
				arrCpn6.forEach(function(value, index, array) {
					$('#type6_cpnText1' + index).attr('readonly',true);
					$('#type6_cpnText2' + index).attr('readonly',true);
					$('#type6_cpnText3' + index).attr('readonly',true);
					$('#type6_cpnText4' + index).attr('readonly',true);
					$('#type6_cpnNumber' + index).attr('readonly',true);
					$('input[name=cpnVisible6' + index + ']').attr('disabled', true)
				});
				// button(항목추가 / 미리보기) disabled
				$('#cpn6_addItem').attr('disabled', true);  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		default:
			break;
		}
		$('#' + type + '_ftrText').attr('readonly',true);
		$('#' + type + '_ftrMblUrl').attr('readonly',true);
		$('#' + type + '_ftrWebUrl').attr('readonly',true);
	}
	function fn_disableAlimi() {
		fn_disableAlimi_master();
		fn_disableAlimi_type('type1');
		fn_disableAlimi_type('type2');
		fn_disableAlimi_type('type3');
		fn_disableAlimi_type('type4');
		fn_disableAlimi_type('type5');
		fn_disableAlimi_type('type6');
	}
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	function fn_editableAlimi_master() {
		if (true) console.log("fn_editableAlimi_master(): ");
		$('#alimiText').val("").attr('readonly',false);
		$('input[name=alimiType]').removeAttr('disabled');
	}
	function fn_editableAlimi_type(type) {
		if (true) console.log("fn_editableAlimi_type(" + type + "): ");
		$('#' + type + '_title1').val("").attr('readonly',false);
		$('#' + type + '_advText').val(master.advText).attr('readonly',true);
		$('#' + type + '_title2').val("").attr('readonly',false);
		$('#' + type + '_title3').val("").attr('readonly',false);
		switch(type) {
		case "type1":
			{
				arrImg1.forEach(function(value, index, array) {
					$('#type1_imgUrl' + index).val("").attr('readonly',false);
				});
				// button(항목추가 / 미리보기) disabled
				$('#img1_addItem').removeAttr('disabled');  // 항목추가
				$('#type1_imgUrl1').removeAttr('disabled');  // 미리보기
			}
			break;
		case "type2":
			{
				arrImg2.forEach(function(value, index, array) {
					$('#type2_imgUrl' + index).val("").attr('readonly',false);
				});
				arrPrd2.forEach(function(value, index, array) {
					$('#type2_prdUrl' + index).val("").attr('readonly',false);
					$('#type2_prdName' + index).val("").attr('readonly',false);
					$('#type2_prdPrice' + index).val("").attr('readonly',false);
					$('#type2_prdUnit' + index).val("").attr('readonly',false);
					$('#type2_prdMblUrl' + index).val("").attr('readonly',false);
					$('#type2_prdWebUrl' + index).val("").attr('readonly',false);
				});
				// button(항목추가 / 미리보기) disabled
				$('#img2_addItem').removeAttr('disabled');  // 항목추가
				$('#prd2_addItem').removeAttr('disabled');  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		case "type3":
			{
				arrImg3.forEach(function(value, index, array) {
					$('#type3_imgUrl' + index).val("").attr('readonly',false);
				});
				arrCpn3.forEach(function(value, index, array) {
					$('#type3_cpnText1' + index).val("").attr('readonly',false);
					$('#type3_cpnText2' + index).val("").attr('readonly',false);
					$('#type3_cpnText3' + index).val("").attr('readonly',false);
					$('#type3_cpnText4' + index).val("").attr('readonly',false);
					$('#type3_cpnNumber' + index).val("").attr('readonly',false);
					$('input[name=cpnVisible3' + index + ']').val([value.cpnVisible]).attr('disabled', false);
				});
				// button(항목추가 / 미리보기) disabled
				$('#img3_addItem').removeAttr('disabled');  // 항목추가
				$('#cpn3_addItem').removeAttr('disabled');  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', false);  // 미리보기
			}
			break;
		case "type4":
			{
				arrAnn4.forEach(function(value, index, array) {
					$('#type4_annText' + index).val("").attr('readonly',false);
					$('input[name=annFixed' + index + ']').val([value.annFixed]).attr('disabled', false);
				});
				// button(항목추가 / 미리보기) disabled
				$('#ann4_addItem').removeAttr('disabled');  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', false);  // 미리보기
			}
			break;
		case "type5":
			{
				arrPrd5.forEach(function(value, index, array) {
					$('#type5_prdUrl' + index).val("").attr('readonly',false);
					$('#type5_prdName' + index).val("").attr('readonly',false);
					$('#type5_prdPrice' + index).val("").attr('readonly',false);
					$('#type5_prdUnit' + index).val("").attr('readonly',false);
					$('#type5_prdMblUrl' + index).val("").attr('readonly',false);
					$('#type5_prdWebUrl' + index).val("").attr('readonly',false);
				});
				// button(항목추가 / 미리보기) disabled
				$('#prd5_addItem').attr('disabled', false);  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', false);  // 미리보기
			}
			break;
		case "type6":
			{
				arrCpn6.forEach(function(value, index, array) {
					$('#type6_cpnText1' + index).val("").attr('readonly',false);
					$('#type6_cpnText2' + index).val("").attr('readonly',false);
					$('#type6_cpnText3' + index).val("").attr('readonly',false);
					$('#type6_cpnText4' + index).val("").attr('readonly',false);
					$('#type6_cpnNumber' + index).val("").attr('readonly',false);
					$('input[name=cpnVisible6' + index + ']').val([value.cpnVisible]).attr('disabled', false);
				});
				// button(항목추가 / 미리보기) disabled
				$('#cpn6_addItem').removeAttr('disabled');  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', false);  // 미리보기
			}
			break;
		default:
			break;
		}
		$('#' + type + '_ftrText').val("").attr('readonly',false);
		$('#' + type + '_ftrMblUrl').val("").attr('readonly',false);
		$('#' + type + '_ftrWebUrl').val("").attr('readonly',false);
	}
	function fn_editableAlimi() {     // not be used
		fn_editableAlimi_master();
		fn_editableAlimi_type('type1');
		fn_editableAlimi_type('type2');
		fn_editableAlimi_type('type3');
		fn_editableAlimi_type('type4');
		fn_editableAlimi_type('type5');
		fn_editableAlimi_type('type6');
	}
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	function fn_dataFromAlimi_base() {
		if (true) console.log("fn_dataFromAlimi_master(ALIMI): ");
		if (ALIMI.alimiShow == 'Y') {
			base.alimiShow = ALIMI.alimiShow == 'Y' ? 'show' : 'hide';
			base.alimiText = ALIMI.alimiText;
			base.alimiType = 'type' + ALIMI.alimiType.substring(2);
		} else {
			base.alimiShow = ALIMI.alimiShow;
			base.alimiText = ALIMI.alimiText;
			base.alimiType = ALIMI.alimiType;
		}
	}
	function fn_dataFromAlimi_type() {
		if (true) console.log("fn_dataFromAlimi_type(alimi): type = " + base.alimiType);
		master.title1 = ALIMI.title1;
		master.advText = ALIMI.advText;
		master.title2 = ALIMI.title2;
		master.title3 = ALIMI.title3;
		switch(base.alimiType) {
		case "type1":
			arrImg1 = ALIMI.arrImg;
			break;
		case "type2":
			arrImg2 = ALIMI.arrImg;
			arrPrd2 = ALIMI.arrPrd;
			break;
		case "type3":
			arrImg3 = ALIMI.arrImg;
			arrCpn3 = ALIMI.arrCpn;
			break;
		case "type4":
			arrAnn4 = ALIMI.arrAnn;
			break;
		case "type5":
			arrPrd5 = ALIMI.arrPrd;
			break;
		case "type6":
			arrCpn6 = ALIMI.arrCpn;
			break;
		default:
			break;
		}
		footer.ftrText = ALIMI.ftrText;
		footer.ftrMblUrl = ALIMI.ftrMblUrl;
		footer.ftrWebUrl = ALIMI.ftrWebUrl;
	}
	function fn_dataFromAlimi() {
		fn_dataFromAlimi_base();
		fn_dataFromAlimi_type();
	}
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	function fn_dataAlimi_base() {
		if (true) console.log("fn_dataAlimi_master(): ");
		$('input[name="alimiShow"]').val([base.alimiShow]).removeAttr('disabled');
		$('#alimiText').val(base.alimiText).attr('readonly',false);
		$('input[name="alimiType"]').val([base.alimiType]).removeAttr('disabled');
	}
	function fn_dataAlimi_type(type) {
		if (true) console.log("fn_dataAlimi_type(" + type + "): ", master);
		$('#' + type + '_title1').val(master.title1).attr('readonly',false);
		$('#' + type + '_advText').val(master.advText).attr('readonly',true);
		$('#' + type + '_title2').val(master.title2).attr('readonly',false);
		$('#' + type + '_title3').val(master.title3).attr('readonly',false);
		switch(type) {
		case "type1":
			{
				arrImg1.forEach(function(value, index, array) {
					$('#type1_imgUrl' + index).val(value.imgUrl).attr('readonly',false);
				});
				// button(항목추가 / 미리보기) disabled
				$('#img1_addItem').removeAttr('disabled');  // 항목추가
				$('#type1_imgUrl1').removeAttr('disabled');  // 미리보기
			}
			break;
		case "type2":
			{
				arrImg2.forEach(function(value, index, array) {
					$('#type2_imgUrl' + index).val(value.imgUrl).attr('readonly',false);
				});
				arrPrd2.forEach(function(value, index, array) {
					$('#type2_prdUrl' + index).val(value.prdUrl).attr('readonly',false);
					$('#type2_prdName' + index).val(value.prdName).attr('readonly',false);
					$('#type2_prdPrice' + index).val(value.prdPrice).attr('readonly',false);
					$('#type2_prdUnit' + index).val(value.prdUnit).attr('readonly',false);
					$('#type2_prdMblUrl' + index).val(value.prdMblUrl).attr('readonly',false);
					$('#type2_prdWebUrl' + index).val(value.prdWebUrl).attr('readonly',false);
				});
				// button(항목추가 / 미리보기) disabled
				$('#img2_addItem').removeAttr('disabled');  // 항목추가
				$('#prd2_addItem').removeAttr('disabled');  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', true);  // 미리보기
			}
			break;
		case "type3":
			{
				arrImg3.forEach(function(value, index, array) {
					$('#type3_imgUrl' + index).val(value.imgUrl).attr('readonly',false);
				});
				arrCpn3.forEach(function(value, index, array) {
					$('#type3_cpnText1' + index).val(value.cpnText1).attr('readonly',false);
					$('#type3_cpnText2' + index).val(value.cpnText2).attr('readonly',false);
					$('#type3_cpnText3' + index).val(value.cpnText3).attr('readonly',false);
					$('#type3_cpnText4' + index).val(value.cpnText4).attr('readonly',false);
					$('#type3_cpnNumber' + index).val(value.cpnNumber).attr('readonly',false);
					$('input[name=cpnVisible3' + index + ']').val([value.cpnVisible]).removeAttr('disabled');
				});
				// button(항목추가 / 미리보기) disabled
				$('#img3_addItem').removeAttr('disabled');  // 항목추가
				$('#cpn3_addItem').removeAttr('disabled');  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', false);  // 미리보기
			}
			break;
		case "type4":
			{
				arrAnn4.forEach(function(value, index, array) {
					$('#type4_annText' + index).val(value.annText).attr('readonly',false);
					$('input[name=annFixed' + index + ']').val([value.annFixed]).removeAttr('disabled');
				});
				// button(항목추가 / 미리보기) disabled
				$('#ann4_addItem').removeAttr('disabled');  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', false);  // 미리보기
			}
			break;
		case "type5":
			{
				arrPrd5.forEach(function(value, index, array) {
					$('#type5_prdUrl' + index).val(value.prdUrl).attr('readonly',false);
					$('#type5_prdName' + index).val(value.prdName).attr('readonly',false);
					$('#type5_prdPrice' + index).val(value.prdPrice).attr('readonly',false);
					$('#type5_prdUnit' + index).val(value.prdUnit).attr('readonly',false);
					$('#type5_prdMblUrl' + index).val(value.prdMblUrl).attr('readonly',false);
					$('#type5_prdWebUrl' + index).val(value.prdWebUrl).attr('readonly',false);
				});
				// button(항목추가 / 미리보기) disabled
				$('#prd5_addItem').attr('disabled', false);  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', false);  // 미리보기
			}
			break;
		case "type6":
			{
				arrCpn6.forEach(function(value, index, array) {
					$('#type6_cpnText1' + index).val(value.cpnTest1).attr('readonly',false);
					$('#type6_cpnText2' + index).val(value.cpnTest2).attr('readonly',false);
					$('#type6_cpnText3' + index).val(value.cpnTest3).attr('readonly',false);
					$('#type6_cpnText4' + index).val(value.cpnTest4).attr('readonly',false);
					$('#type6_cpnNumber' + index).val(value.cpnNumber).attr('readonly',false);
					$('input[name=cpnVisible6' + index + ']').val([value.cpnVisible]).removeAttr('disabled');
				});
				// button(항목추가 / 미리보기) disabled
				$('#cpn6_addItem').removeAttr('disabled');  // 항목추가
				//$('#type1_imgUrl1').attr('disabled', false);  // 미리보기
			}
			break;
		default:
			break;
		}
		$('#' + type + '_ftrText').val(footer.ftrText).attr('readonly',false);
		$('#' + type + '_ftrMblUrl').val(footer.ftrMblUrl).attr('readonly',false);
		$('#' + type + '_ftrWebUrl').val(footer.ftrWebUrl).attr('readonly',false);
	}
	function fn_dataAlimi() {
		fn_dataAlimi_base();
		fn_dataAlimi_type('type1');
		fn_dataAlimi_type('type2');
		fn_dataAlimi_type('type3');
		fn_dataAlimi_type('type4');
		fn_dataAlimi_type('type5');
		fn_dataAlimi_type('type6');
	}
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	function fn_newAlimiHideAll() {
		$("#content-1").hide();
		$("#content-2").hide();
		$("#content-3").hide();
		$("#content-4").hide();
		$("#content-5").hide();
		$("#content-6").hide();
		fn_img1_appendTableTr();
		fn_img2_appendTableTr();
		fn_prd2_appendTableTr();
		fn_img3_appendTableTr();
		fn_cpn3_appendTableTr();
		fn_ann4_appendTableTr();
		fn_prd5_appendTableTr();
		fn_cpn6_appendTableTr();
	}
	function fn_newAlimiShow(type) {
		switch (type) {
		case "type1":
			//fn_img1_appendTableTr();
			$("#content-1").show();
			break;
		case "type2":
			//fn_img2_appendTableTr();
			//fn_prd2_appendTableTr();
			$("#content-2").show();
			break;
		case "type3":
			//fn_img3_appendTableTr();
			//fn_cpn3_appendTableTr();
			$("#content-3").show();
			break;
		case "type4":
			//fn_ann4_appendTableTr();
			$("#content-4").show();
			break;
		case "type5":
			//fn_prd5_appendTableTr();
			$("#content-5").show();
			break;
		case "type6":
			//fn_cpn6_appendTableTr();
			$("#content-6").show();
			break;
		}
	}
</script>









<script>
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	var ALIMI;
	var ALIMI_SHOW;
	var ALIMI_TYPE;
	// callback function
	function fn_setNewAlimi() {   // type of alimi is string
		ALIMI = JSON.parse(ALIMI);
		if (true) console.log("in fn_setNewAlimi: ALIMI = ", ALIMI);
		ALIMI.alimiShow = ALIMI.alimiShow == 'Y' ? 'show' : 'hide';
		ALIMI.alimiType = "type" + ALIMI.alimiType.substring(2);
		if (true) console.log("in fn_setNewAlimi: JSON.stringify(ALIMI) = " + JSON.stringify(ALIMI));
		if (true) console.log("ALIMI.alimiShow: " + ALIMI.alimiShow + ", ALIMI.alimiType: " + ALIMI.alimiType);
		
		if (ALIMI.alimiShow == 'hide') {
			// 알리미미노출
			fn_valueClear();
			//fn_clearDisableAlimi();
			fn_dataAlimi();
			fn_disableAlimi();
			//
			ALIMI_SHOW = 'hide';
			ALIMI_TYPE = 'type1';
			base.alimiType = 'ALIMI_TYPE';
			//
			fn_newAlimiHideAll();
			fn_newAlimiShow(ALIMI_TYPE);
			if (true) console.log(">>>>> FIRST: 알리미 미노출 <<<<< (" + ALIMI_SHOW + ", " + ALIMI_TYPE + ")");
			if (true) console.log("base = ", base);
		} else {
			// 알리미노출
			fn_valueClear();
			fn_dataFromAlimi();
			fn_dataAlimi();
			//
			ALIMI_SHOW = 'show';
			ALIMI_TYPE = base.alimiType;
			//
			fn_newAlimiHideAll();
			fn_newAlimiShow(ALIMI_TYPE);
			if (true) console.log(">>>>> FIRST: 알리미 노출 <<<<< (" + ALIMI_SHOW + ", " + ALIMI_TYPE + ")");
		}
		$('input[name=alimiShow]').val([ALIMI_SHOW]);
		$('input[name=alimiType]').val([ALIMI_TYPE]);
	}
	// init event
	function fn_init_event() {
		//
		// Event
		//
		$('#alimiShow_show').on({       // SHOW
			'click': function() {
				if (ALIMI_SHOW == 'show')
					return;
				if (true) console.log("show onclick(). 노출로 변경됨.");
				fn_valueClear();  // after fn_setDefaultValue()
				//fn_dataFromAlimi();
				//fn_dataFromAlimi_type()
				fn_dataAlimi();
				//
				ALIMI_SHOW = 'show';
				ALIMI_TYPE = base.alimiType;
				if (true) console.log(">>>>> show_click() <<<<< (" + ALIMI_SHOW + ", " + ALIMI_TYPE + ")");
				//ALIMI_TYPE = 'type1';
				fn_newAlimiHideAll();
				fn_newAlimiShow(ALIMI_TYPE);
				$('input[name=alimiShow]').val([ALIMI_SHOW]);
				$('input[name=alimiType]').val([ALIMI_TYPE]);
			}
		});
		$('#alimiShow_hide').on({       // HIDE
			'click': function() {
				if (ALIMI_SHOW == 'hide')
					return;
				if (!confirm("미노출 선택시 기존의 입력값들이 사라집니다.\n계속 진행하시겠습니까?")) {
					// 원래 노출로 돌아감.
					$("#alimiShow_show").trigger("click");
					return;
				}
				// 미노출로 변경됨.
				if (true) console.log("hide onclick(). 미노출로 변경됨.");
				fn_valueClear();  // after fn_setDefaultValue()
				fn_dataAlimi();
				fn_disableAlimi();
				//
				ALIMI_SHOW = 'hide';
				ALIMI_TYPE = 'type1';
				if (true) console.log(">>>>> hide_click() <<<<< (" + ALIMI_SHOW + ", " + ALIMI_TYPE + ")");
				fn_newAlimiHideAll();
				fn_newAlimiShow(ALIMI_TYPE);
				$('input[name=alimiShow]').val([ALIMI_SHOW]);
				$('input[name=alimiType]').val([ALIMI_TYPE]);
			}
		});
		$('input[name="alimiType"]').on({       // Type
			click: function() {
				var val = $('input[name="alimiType"]:checked').val();
				if (true) console.log("alimiType.click() = " + val);
				if (ALIMI_TYPE == val)
					return;
				if (!confirm("타입을 바꾸시면 기존에 작성한 내용은 사라집니다.\n타입을 바꾸시겠습니까?")) {
					$('input[name="alimiType"]').val([ALIMI_TYPE]);
					return;
				}
				ALIMI_SHOW = 'show';
				ALIMI_TYPE = val;
				if (true) console.log(">>>>> type_click() <<<<< (" + ALIMI_SHOW + ", " + ALIMI_TYPE + ")");
				fn_valueClear();  // after fn_setDefaultValue()
				fn_dataAlimi();
				//fn_editableAlimi_type(ALIMI_TYPE);
				fn_newAlimiHideAll();
				fn_newAlimiShow(ALIMI_TYPE);
				$('input[name=alimiShow]').val([ALIMI_SHOW]);
				$('input[name=alimiType]').val([ALIMI_TYPE]);
			}
		});
		// 항목추가 버튼
		$("#img1_addItem").click(fn_img1_addItem_click);
		$("#img2_addItem").click(fn_img2_addItem_click);
		$("#prd2_addItem").click(fn_prd2_addItem_click);
		$("#img3_addItem").click(fn_img3_addItem_click);
		$("#cpn3_addItem").click(fn_cpn3_addItem_click);
		$("#ann4_addItem").click(fn_ann4_addItem_click);
		$("#prd5_addItem").click(fn_prd5_addItem_click);
		$("#cpn6_addItem").click(fn_cpn6_addItem_click);
	}
	// ajax call
	function fn_ajax_getChannelMobileAlimi(cellid) {
		if (true) console.log(">>>>> ajax_url: " + '${staticPATH }/getChannelMobileAlimi.do?cellId=' + cellid);
		$('#nav-tabs-new').attr('disabled', true);  // 일단 (신)알리미 탭을 멈춘다.
		jQuery.ajax({
			url           : '${staticPATH }/getChannelMobileAlimi.do?cellId=' + cellid,
			//url           : '${staticPATH }/getChannelMobileAlimi.do',    // imsi cellId=25
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "GET",
			success: function(result, option) {
				if (option=="success"){
					if (true) console.log("STATUS: 성공입니다. -> result: " + JSON.stringify(result));
					ALIMI = result.alimi;
					if (true) fn_setNewAlimi();
					if (true) fn_init_event();
					$('#nav-tabs-new').removeAttr('disabled');  // 에러가 없으면 (신)알리미 탭을 살린다.
				} else {
					alert("에러가 발생하였습니다.");
				}
			},
			error: function(result, option) {
				alert("에러가 발생하였습니다.");
			}
		});
	};
	// ajax call and event functions
	function fn_getChannelMobileAlimi(cellid) {
		if (true) console.log(">>>>> cellid: " + cellid);
		if (true) fn_ajax_getChannelMobileAlimi(cellid);
	}
</script>







<script>
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	//
	// alimi initialization
	//
	function fn_newAlimi_init() {
		//if (!true) fn_for_test(); // for test
		//if (true) fn_getChannelMobileAlimi('${bo.cellid}');
		if (true) fn_getChannelMobileAlimi('${CELLID}');
		// 초기화면 세팅
		//fn_newAlimiHideAll();
		//fn_newAlimiShow("type1");
		document.getElementById("nav-tabs-old").click();  // 첫 화면은 (구)알리미
	}
</script>






<script>
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	//
	// type1 validation and json
	//
	function fn_alimi_type1_validation() {
		// master.title1
		if (isEmpty($('#type1_title1').val()) || fn_checkQuotationMark($('#type1_title1').val())) {
			$('#type1_title1').focus();
			return false;
		}
		master["title1"] = $('#type1_title1').val();
		// master.title2
		if (isEmpty($('#type1_title2').val()) || fn_checkQuotationMark($('#type1_title2').val())) {
			$('#type1_title2').focus();
			return false;
		}
		master["title2"] = $('#type1_title2').val();
		// master.title3
		/*
		if (isEmpty($('#type1_title3').val())) {
			$('#type1_title3').focus();
			return false;
		}
		*/
		if (fn_checkQuotationMark($('#type1_title3').val())) {
			$('#type1_title3').focus();
			return false;
		}
		master["title3"] = $('#type1_title3').val();
		//
		// array type
		var idx = "";
		arrImg1.forEach(function(value, index, array) {
			if (idx == "" && (isEmpty(value["imgUrl"]) || fn_checkQuotationMark(value["imgUrl"]) || fn_checkUrlSpace(value["imgUrl"]))) {   // KANG-20190530: add fn_checkUrlSpace
				idx = "type1_imgUrl" + index;
			}
		});
		if (idx != "") {
			$('#' + idx).focus();
			return false;
		}
		//
		// footer.ftrText
		if (isEmpty($('#type1_ftrText').val()) || fn_checkQuotationMark($('#type1_ftrText').val())) {
			$('#type1_ftrText').focus();
			return false;
		}
		footer["ftrText"] = $('#type1_ftrText').val();
		// footer.ftrMblUrl
		if (isEmpty($('#type1_ftrMblUrl').val()) || fn_checkQuotationMark($('#type1_ftrMblUrl').val()) || fn_checkUrlSpace($('#type1_ftrMblUrl').val())) {   // KANG-20190530: add fn_checkUrlSpace
			$('#type1_ftrMblUrl').focus();
			return false;
		}
		footer["ftrMblUrl"] = $('#type1_ftrMblUrl').val();
		// footer.ftrWebUrl
		if (isEmpty($('#type1_ftrWebUrl').val()) || fn_checkQuotationMark($('#type1_ftrWebUrl').val()) || fn_checkUrlSpace($('#type1_ftrWebUrl').val())) {   // KANG-20190530: add fn_checkUrlSpace
			$('#type1_ftrWebUrl').focus();
			return false;
		}
		footer["ftrWebUrl"] = $('#type1_ftrWebUrl').val();
		return true;
	}
	function fn_alimi_type1_json() {
		resultJson = "{" + fn_getCore(base) + "," + fn_getCore(master) + ",\"arrImg\":" + fn_getCore(arrImg1) + "," + fn_getCore(footer) + "}";
		if (true) console.log(">>> type1_resultJson: " + resultJson);
		return true;
	}

	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	//
	// type2 validation and json
	//
	function fn_alimi_type2_validation() {
		// master.title1
		if (isEmpty($('#type2_title1').val()) || fn_checkQuotationMark($('#type2_title1').val())) {
			$('#type2_title1').focus();
			return false;
		}
		master["title1"] = $('#type2_title1').val();
		// master.title2
		if (isEmpty($('#type2_title2').val()) || fn_checkQuotationMark($('#type2_title2').val())) {
			$('#type2_title2').focus();
			return false;
		}
		master["title2"] = $('#type2_title2').val();
		// master.title3
		/*
		if (isEmpty($('#type2_title3').val())) {
			document.getElementById('type2_title3').focus();
			return false;
		}
		*/
		if (fn_checkQuotationMark($('#type2_title3').val())) {
			$('#type2_title3').focus();
			return false;
		}
		master["title3"] = $('#type2_title3').val();
		//
		// array type
		var idx = "";
		arrImg2.forEach(function(value, index, array) {
			if (idx == "" && (isEmpty(value["imgUrl"]) || fn_checkQuotationMark(value["imgUrl"]) || fn_checkUrlSpace(value["imgUrl"]))) {   // KANG-20190530: add fn_checkUrlSpace
				idx = "type2_imgUrl" + index;
			}
		});
		if (idx != "") {
			$('#' + idx).focus();
			return false;
		}
		arrPrd2.forEach(function(value, index, array) {
			if (idx == "" && (isEmpty(value["prdUrl"]) || fn_checkQuotationMark(value["prdUrl"]) || fn_checkUrlSpace(value["prdUrl"]))) {   // KANG-20190530: add fn_checkUrlSpace
				idx = "type2_prdUrl" + index;
			}
			if (idx == "" && (isEmpty(value["prdName"]) || fn_checkQuotationMark(value["prdName"]))) {
				idx = "type2_prdName" + index;
			}
			if (idx == "" && (isEmpty(value["prdPrice"]) || fn_checkQuotationMark(value["prdPrice"]))) {
				idx = "type2_prdPrice" + index;
			}
			if (idx == "" && (isEmpty(value["prdUnit"]) || fn_checkQuotationMark(value["prdUnit"]))) {
				idx = "type2_prdUnit" + index;
			}
			if (idx == "" && (isEmpty(value["prdMblUrl"]) || fn_checkQuotationMark(value["prdMblUrl"]) || fn_checkUrlSpace(value["prdMblUrl"]))) {   // KANG-20190530: add fn_checkUrlSpace
				idx = "type2_prdMblUrl" + index;
			}
			if (idx == "" && (isEmpty(value["prdWebUrl"]) || fn_checkQuotationMark(value["prdWebUrl"]) || fn_checkUrlSpace(value["prdWebUrl"]))) {   // KANG-20190530: add fn_checkUrlSpace
				idx = "type2_prdWebUrl" + index;
			}
		});
		if (idx != "") {
			$('#' + idx).focus();
			return false;
		}
		//
		// footer.ftrText
		if (isEmpty($('#type2_ftrText').val()) || fn_checkQuotationMark($('#type2_ftrText').val())) {
			$('#type2_ftrText').focus();
			return false;
		}
		footer["ftrText"] = $('#type2_ftrText').val();
		// footer.ftrMblUrl
		if (isEmpty($('#type2_ftrMblUrl').val()) || fn_checkQuotationMark($('#type2_ftrMblUrl').val()) || fn_checkUrlSpace($('#type2_ftrMblUrl').val())) {   // KANG-20190530: add fn_checkUrlSpace
			$('#type2_ftrMblUrl').focus();
			return false;
		}
		footer["ftrMblUrl"] = $('#type2_ftrMblUrl').val();
		// footer.ftrWebUrl
		if (isEmpty($('#type2_ftrWebUrl').val()) || fn_checkQuotationMark($('#type2_ftrWebUrl').val()) || fn_checkUrlSpace($('#type2_ftrWebUrl').val())) {   // KANG-20190530: add fn_checkUrlSpace
			$('#type2_ftrWebUrl').focus();
			return false;
		}
		footer["ftrWebUrl"] = $('#type2_ftrWebUrl').val();
		return true;
	}
	function fn_alimi_type2_json() {
		resultJson = "{" + fn_getCore(base) + "," + fn_getCore(master) + ",\"arrImg\":" + fn_getCore(arrImg2) + ",\"arrPrd\":" + fn_getCore(arrPrd2) + "," + fn_getCore(footer) + "}";
		if (true) console.log(">>> type2_resultJson: " + resultJson);
		return true;
	}

	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	//
	// type3 validation and json
	//
	function fn_alimi_type3_validation() {
		// master.title1
		if (isEmpty($('#type3_title1').val()) || fn_checkQuotationMark($('#type3_title1').val())) {
			$('#type3_title1').focus();
			return false;
		}
		master["title1"] = $('#type3_title1').val();
		// master.title2
		if (isEmpty($('#type3_title2').val()) || fn_checkQuotationMark($('#type3_title2').val())) {
			$('#type3_title2').focus();
			return false;
		}
		master["title2"] = $('#type3_title2').val();
		// master.title3
		/*
		if (isEmpty($('#type3_title3').val())) {
			document.getElementById('type3_title3').focus();
			return false;
		}
		*/
		if (fn_checkQuotationMark($('#type3_title3').val())) {
			$('#type3_title3').focus();
			return false;
		}
		master["title3"] = $('#type3_title3').val();
		//
		// array type
		var idx = "";
		arrImg3.forEach(function(value, index, array) {
			if (idx == "" && (isEmpty(value["imgUrl"]) || fn_checkQuotationMark(value["imgUrl"]) || fn_checkUrlSpace(value["imgUrl"]))) {   // KANG-20190530: add fn_checkUrlSpace
				idx = "type3_imgUrl" + index;
			}
		});
		if (idx != "") {
			$('#' + idx).focus();
			return false;
		}
		arrCpn3.forEach(function(value, index, array) {
			if (idx == "" && (isEmpty(value["cpnText1"]) || fn_checkQuotationMark(value["cpnText1"]))) {
				idx = "type3_cpnText1" + index;
			}
			if (idx == "" && (isEmpty(value["cpnText2"]) || fn_checkQuotationMark(value["cpnText2"]))) {
				idx = "type3_cpnText2" + index;
			}
			if (idx == "" && (isEmpty(value["cpnText3"]) || fn_checkQuotationMark(value["cpnText3"]))) {
				idx = "type3_cpnText3" + index;
			}
			if (idx == "" && (isEmpty(value["cpnText4"]) || fn_checkQuotationMark(value["cpnText4"]))) {
				idx = "type3_cpnText4" + index;
			}
			if (idx == "" && (isEmpty(value["cpnNumber"]) || fn_checkQuotationMark(value["cpnNumber"]))) {
				idx = "type3_cpnNumber" + index;
			}
		});
		if (idx != "") {
			$('#' + idx).focus();
			return false;
		}
		//
		// footer.ftrText
		if (isEmpty($('#type3_ftrText').val()) || fn_checkQuotationMark($('#type3_ftrText').val())) {
			$('#type3_ftrText').focus();
			return false;
		}
		footer["ftrText"] = $('#type3_ftrText').val();
		// footer.ftrMblUrl
		if (isEmpty($('#type3_ftrMblUrl').val()) || fn_checkQuotationMark($('#type3_ftrMblUrl').val()) || fn_checkUrlSpace($('#type3_ftrMblUrl').val())) {   // KANG-20190530: add fn_checkUrlSpace
			$('#type3_ftrMblUrl').focus();
			return false;
		}
		footer["ftrMblUrl"] = $('#type3_ftrMblUrl').val();
		// footer.ftrWebUrl
		if (isEmpty($('#type3_ftrWebUrl').val()) || fn_checkQuotationMark($('#type3_ftrWebUrl').val()) || fn_checkUrlSpace($('#type3_ftrWebUrl').val())) {   // KANG-20190530: add fn_checkUrlSpace
			$('#type3_ftrWebUrl').focus();
			return false;
		}
		footer["ftrWebUrl"] = $('#type3_ftrWebUrl').val();
		return true;
	}
	function fn_alimi_type3_json() {
		resultJson = "{" + fn_getCore(base) + "," + fn_getCore(master) + ",\"arrImg\":" + fn_getCore(arrImg3) + ",\"arrCpn\":" + fn_getCore(arrCpn3) + "," + fn_getCore(footer) + "}";
		if (true) console.log(">>> type3_resultJson: " + resultJson);
		return true;
	}

	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	//
	// type4 validation and json
	//
	function fn_alimi_type4_validation() {
		// master.title1
		if (isEmpty($('#type4_title1').val()) || fn_checkQuotationMark($('#type4_title1').val())) {
			$('#type4_title1').focus();
			return false;
		}
		master["title1"] = $('#type4_title1').val();
		// master.title2
		if (isEmpty($('#type4_title2').val()) || fn_checkQuotationMark($('#type4_title2').val())) {
			$('#type4_title2').focus();
			return false;
		}
		master["title2"] = $('#type4_title2').val();
		// master.title3
		/*
		if (isEmpty($('#type4_title3').val())) {
			document.getElementById('type4_title3').focus();
			return false;
		}
		*/
		if (fn_checkQuotationMark($('#type4_title3').val())) {
			$('#type4_title3').focus();
			return false;
		}
		master["title3"] = $('#type4_title3').val();
		//
		// array type
		var idx = "";
		arrAnn4.forEach(function(value, index, array) {
			if (idx == "" && (isEmpty(value["annText"]) || fn_checkQuotationMark(value["annText"]))) {
				idx = "type4_annText" + index;
			}
		});
		if (idx != "") {
			$('#' + idx).focus();
			return false;
		}
		//
		// footer.ftrText
		if (isEmpty($('#type4_ftrText').val()) || fn_checkQuotationMark($('#type4_ftrText').val())) {
			$('#type4_ftrText').focus();
			return false;
		}
		footer["ftrText"] = $('#type4_ftrText').val();
		// footer.ftrMblUrl
		if (isEmpty($('#type4_ftrMblUrl').val()) || fn_checkQuotationMark($('#type4_ftrMblUrl').val()) || fn_checkUrlSpace($('#type4_ftrMblUrl').val())) {   // KANG-20190530: add fn_checkUrlSpace
			$('#type4_ftrMblUrl').focus();
			return false;
		}
		footer["ftrMblUrl"] = $('#type4_ftrMblUrl').val();
		// footer.ftrWebUrl
		if (isEmpty($('#type4_ftrWebUrl').val()) || fn_checkQuotationMark($('#type4_ftrWebUrl').val()) || fn_checkUrlSpace($('#type4_ftrWebUrl').val())) {   // KANG-20190530: add fn_checkUrlSpace
			$('#type4_ftrWebUrl').focus();
			return false;
		}
		footer["ftrWebUrl"] = $('#type4_ftrWebUrl').val();
		return true;
	}
	function fn_alimi_type4_json() {
		resultJson = "{" + fn_getCore(base) + "," + fn_getCore(master) + ",\"arrAnn\":" + fn_getCore(arrAnn4) + "," + fn_getCore(footer) + "}";
		if (true) console.log(">>> type4_resultJson: " + resultJson);
		return true;
	}

	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	//
	// type5 validation and json
	//
	function fn_alimi_type5_validation() {
		// master.title1
		if (isEmpty($('#type5_title1').val()) || fn_checkQuotationMark($('#type5_title1').val())) {
			$('#type5_title1').focus();
			return false;
		}
		master["title1"] = $('#type5_title1').val();
		// master.title2
		if (isEmpty($('#type5_title2').val()) || fn_checkQuotationMark($('#type5_title2').val())) {
			$('#type5_title2').focus();
			return false;
		}
		master["title2"] = $('#type5_title2').val();
		// master.title3
		/*
		if (isEmpty($('#type5_title3').val())) {
			document.getElementById('type5_title3').focus();
			return false;
		}
		*/
		if (fn_checkQuotationMark($('#type5_title3').val())) {
			$('#type5_title3').focus();
			return false;
		}
		master["title3"] = $('#type5_title3').val();
		//
		// array type
		var idx = "";
		arrPrd5.forEach(function(value, index, array) {
			if (idx == "" && (isEmpty(value["prdUrl"]) || fn_checkQuotationMark(value["prdUrl"]) || fn_checkUrlSpace(value["prdUrl"]))) {   // KANG-20190530: add fn_checkUrlSpace
				idx = "type5_prdUrl" + index;
			}
			if (idx == "" && (isEmpty(value["prdName"]) || fn_checkQuotationMark(value["prdName"]))) {
				idx = "type5_prdName" + index;
			}
			if (idx == "" && (isEmpty(value["prdPrice"]) || fn_checkQuotationMark(value["prdPrice"]))) {
				idx = "type5_prdPrice" + index;
			}
			if (idx == "" && (isEmpty(value["prdUnit"]) || fn_checkQuotationMark(value["prdUnit"]))) {
				idx = "type5_prdUnit" + index;
			}
			if (idx == "" && (isEmpty(value["prdMblUrl"]) || fn_checkQuotationMark(value["prdMblUrl"]) || fn_checkUrlSpace(value["prdMblUrl"]))) {   // KANG-20190530: add fn_checkUrlSpace
				idx = "type5_prdMblUrl" + index;
			}
			if (idx == "" && (isEmpty(value["prdWebUrl"]) || fn_checkQuotationMark(value["prdWebUrl"]) || fn_checkUrlSpace(value["prdWebUrl"]))) {   // KANG-20190530: add fn_checkUrlSpace
				idx = "type5_prdWebUrl" + index;
			}
		});
		if (idx != "") {
			$('#' + idx).focus();
			return false;
		}
		//
		// footer.ftrText
		if (isEmpty($('#type5_ftrText').val()) || fn_checkQuotationMark($('#type5_ftrText').val())) {
			$('#type5_ftrText').focus();
			return false;
		}
		footer["ftrText"] = $('#type5_ftrText').val();
		// footer.ftrMblUrl
		if (isEmpty($('#type5_ftrMblUrl').val()) || fn_checkQuotationMark($('#type5_ftrMblUrl').val()) || fn_checkUrlSpace($('#type5_ftrMblUrl').val())) {   // KANG-20190530: add fn_checkUrlSpace
			$('#type5_ftrMblUrl').focus();
			return false;
		}
		footer["ftrMblUrl"] = $('#type5_ftrMblUrl').val();
		// footer.ftrWebUrl
		if (isEmpty($('#type5_ftrWebUrl').val()) || fn_checkQuotationMark($('#type5_ftrWebUrl').val()) || fn_checkUrlSpace($('#type5_ftrWebUrl').val())) {   // KANG-20190530: add fn_checkUrlSpace
			$('#type5_ftrWebUrl').focus();
			return false;
		}
		footer["ftrWebUrl"] = $('#type5_ftrWebUrl').val();
		return true;
	}
	function fn_alimi_type5_json() {
		resultJson = "{" + fn_getCore(base) + "," + fn_getCore(master) + ",\"arrPrd\":" + fn_getCore(arrPrd5) + "," + fn_getCore(footer) + "}";
		if (true) console.log(">>> type5_resultJson: " + resultJson);
		return true;
	}
	
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	//
	// type6 validation and json
	//
	function fn_alimi_type6_validation() {
		// master.title1
		if (isEmpty($('#type6_title1').val()) || fn_checkQuotationMark($('#type6_title1').val())) {
			$('#type6_title1').focus();
			return false;
		}
		master["title1"] = $('#type6_title1').val();
		// master.title2
		if (isEmpty($('#type6_title2').val()) || fn_checkQuotationMark($('#type6_title2').val())) {
			$('#type6_title2').focus();
			return false;
		}
		master["title2"] = $('#type6_title2').val();
		// master.title3
		/*
		if (isEmpty($('#type6_title3').val())) {
			document.getElementById('type6_title3').focus();
			return false;
		}
		*/
		if (fn_checkQuotationMark($('#type6_title3').val())) {
			$('#type6_title3').focus();
			return false;
		}
		master["title3"] = $('#type6_title3').val();
		//
		// array type
		var idx = "";
		arrCpn6.forEach(function(value, index, array) {
			if (idx == "" && (isEmpty(value["cpnText1"]) || fn_checkQuotationMark(value["cpnText1"]))) {
				idx = "type6_cpnText1" + index;
			}
			if (idx == "" && (isEmpty(value["cpnText2"]) || fn_checkQuotationMark(value["cpnText2"]))) {
				idx = "type6_cpnText2" + index;
			}
			if (idx == "" && (isEmpty(value["cpnText3"]) || fn_checkQuotationMark(value["cpnText3"]))) {
				idx = "type6_cpnText3" + index;
			}
			if (idx == "" && (isEmpty(value["cpnText4"]) || fn_checkQuotationMark(value["cpnText4"]))) {
				idx = "type6_cpnText4" + index;
			}
			if (idx == "" && (isEmpty(value["cpnNumber"]) || fn_checkQuotationMark(value["cpnNumber"]))) {
				idx = "type6_cpnNumber" + index;
			}
		});
		if (idx != "") {
			$('#' + idx).focus();
			return false;
		}
		//
		// footer.ftrText
		if (isEmpty($('#type6_ftrText').val()) || fn_checkQuotationMark($('#type6_ftrText').val())) {
			$('#type6_ftrText').focus();
			return false;
		}
		footer["ftrText"] = $('#type6_ftrText').val();
		// footer.ftrMblUrl
		if (isEmpty($('#type6_ftrMblUrl').val()) || fn_checkQuotationMark($('#type6_ftrMblUrl').val()) || fn_checkUrlSpace($('#type6_ftrMblUrl').val())) {   // KANG-20190530: add fn_checkUrlSpace
			$('#type6_ftrMblUrl').focus();
			return false;
		}
		footer["ftrMblUrl"] = $('#type6_ftrMblUrl').val();
		// footer.ftrWebUrl
		if (isEmpty($('#type6_ftrWebUrl').val()) || fn_checkQuotationMark($('#type6_ftrWebUrl').val()) || fn_checkUrlSpace($('#type6_ftrWebUrl').val())) {   // KANG-20190530: add fn_checkUrlSpace
			$('#type6_ftrWebUrl').focus();
			return false;
		}
		footer["ftrWebUrl"] = $('#type6_ftrWebUrl').val();
		return true;
	}
	function fn_alimi_type6_json() {
		resultJson = "{" + fn_getCore(base) + "," + fn_getCore(master) + ",\"arrCpn\":" + fn_getCore(arrCpn6) + "," + fn_getCore(footer) + "}";
		if (true) console.log(">>> type6_resultJson: " + resultJson);
		return true;
	}
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	function fn_alimi_validation() {
		if (isEmpty($('#alimiText').val()) || fn_checkQuotationMark($('#alimiText').val())) {
			$('#alimiText').focus();
			return false;
		}
		base.alimiText = $('#alimiText').val();
		base.alimiShow = $('input[name=alimiShow]:checked').val();
		base.alimiType = $('input[name=alimiType]:checked').val();
		if (true) console.log("fn_alimi_validation(): base", base);
		//
		// 알리미 타입
		var val = $('input[name=alimiType]:checked').val();
		switch(val) {
		case "type1": if (!fn_alimi_type1_validation()) return false; break;
		case "type2": if (!fn_alimi_type2_validation()) return false; break;
		case "type3": if (!fn_alimi_type3_validation()) return false; break;
		case "type4": if (!fn_alimi_type4_validation()) return false; break;
		case "type5": if (!fn_alimi_type5_validation()) return false; break;
		case "type6": if (!fn_alimi_type6_validation()) return false; break;
		default: break;
		}
		return true;
	}
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	function fn_setSavingData() {
		var type = $('input[name=alimiType]:checked').val();
		if (true) console.log("fn_setSavingData(): type = " + type);
		if (true) {
			// base
			base.alimiShow = $('input[name=alimiShow]:checked').val() == 'show' ? 'Y' : 'N';
			base.alimiText = $('#alimiText').val();
			base.alimiType = "00" + $('input[name=alimiType]:checked').val().substring(4);
			if (true) console.log("saving base: ", base);
		}
		if (true) {
			// master
			master.title1 = $('#' + type + '_title1').val();
			master.advText = $('#' + type + '_advText').val();
			master.title2 = $('#' + type + '_title2').val();
			master.title3 = $('#' + type + '_title3').val();
			if (true) console.log("saving master: ", master);
		}
		if (true) {
			if (true) console.log("saving arrImg1: " + JSON.stringify(arrImg1));
			if (true) console.log("saving arrImg2: " + JSON.stringify(arrImg2));
			if (true) console.log("saving arrPrd2: " + JSON.stringify(arrPrd2));
			if (true) console.log("saving arrImg3: " + JSON.stringify(arrImg3));
			if (true) console.log("saving arrCpn3: " + JSON.stringify(arrCpn3));
			if (true) console.log("saving arrAnn4: " + JSON.stringify(arrAnn4));
			if (true) console.log("saving arrPrd5: " + JSON.stringify(arrPrd5));
			if (true) console.log("saving arrCpn6: " + JSON.stringify(arrCpn6));
		}
		if (true) {
			// footer
			footer.ftrText = $('#' + type + '_ftrText').val();
			footer.ftrMblUrl = $('#' + type + '_ftrMblUrl').val();
			footer.ftrWebUrl = $('#' + type + '_ftrWebUrl').val();
			if (true) console.log("saving footer: ", footer);
		}
	}
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	function fn_alimi_json() {
		var val = $('.alimiType:checked').val();
		if (true) console.log("fn_alimi_json() type:" + val);
		switch(val) {
		case "type1": if (!fn_alimi_type1_json()) return false; break;
		case "type2": if (!fn_alimi_type2_json()) return false; break;
		case "type3": if (!fn_alimi_type3_json()) return false; break;
		case "type4": if (!fn_alimi_type4_json()) return false; break;
		case "type5": if (!fn_alimi_type5_json()) return false; break;
		case "type6": if (!fn_alimi_type6_json()) return false; break;
		default: alert("ERROR in fn_alimi_json()"); break;
		}
		
		return true;
	}
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	//////////////////////////
	function fn_get_alimi_json() {
		var alimiShow = $('input[name=alimiShow]:checked').val();
		if (true) console.log("fn_get_alimi_json(): " + alimiShow);
		//
		// if show, then validation
		if (alimiShow == 'show') {
			if (!fn_alimi_validation()) return false;
		} else {
			// value clear for saving
			fn_valueClear();
		}
		//
		// set saving data
		fn_setSavingData();
		//
		// make json
		if (!fn_alimi_json()) return false;
		//
		// return result
		if (true) console.log("0405: fn_get_alimi_json(): " + resultJson);
		//return false;
		return resultJson;
	}
	var resultJson = "";
</script>














<script>
	/////////////////////////////////////////////////
	/////////////////////////////////////////////////
	/////////////////////////////////////////////////
	/////////////////////////////////////////////////
	/////////////////////////////////////////////////
	/////////////////////////////////////////////////
	// KANG-20190326: type-1 script BEGIN
	/////////////////////////////////////////////////
	var maxArrImg1 = 5;
	$("img1_addItem").tooltip();
	//
	//
	//
	function fn_img1_addItem_click() {
		if (arrImg1.length >= maxArrImg1) {
			if (true) alert("이미지는 " + maxArrImg1 + "개까지만 등록 가능합니다.");
			return;
		}
		if (!true) alert("fn_img1_addItem_click()");
		var idx = arrImg1.length + 1;
		arrImg1.push({ imgUrl: "" });
		fn_img1_appendTableTr();
		if (idx >= maxArrImg1) {
			$("#img1_addItem").attr("disabled", true);
		}
	}
	function fn_img1_inputBlur(idx, cls, value) {
		if (true) console.log(idx + ": " + cls + ": " + value);
		arrImg1[idx][cls] = value;   // KANG-20190405
	}
	function fn_img1_appendTableTr() {
		// clear
		$("#img1_table > tbody").empty();
		// value print
		arrImg1.forEach(function(value, index, array) {
			if (!true) alert("fn_img1_appendTableTr(): (" + index + "/" + array.length + ") : " + value.imgUrl);
			var rowHtml = "";
			rowHtml += "<tr>";
			rowHtml += "  <td class=\"info\">";
			rowHtml += "    이미지 URL " + (index+1) + " ";
			if (array.length > 1) {
				rowHtml += "    <span class=\"float-right\">";
				rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_img1_del(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">R</button>";
				if (index > 0) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_img1_up(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">U</button>";
				}
				if (index < array.length - 1) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_img1_down(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">D</button>";
				}
				rowHtml += "    </span>";
			}
			rowHtml += "  </td>";
			rowHtml += "  <td colspan='3'>";
			rowHtml += "    <input type='text' id='type1_imgUrl" + index + "' class='imgUrl' onblur=\"javascript:fn_img1_inputBlur(" + index + ",'imgUrl',this.value);\" style='width:700px;' value='" + value.imgUrl + "' maxlength='100' placeholder='500*500 사이즈 이미지 경로 입력' />";
			rowHtml += "    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <button type='button' id='type1_imgUrl" + index +"' class='btn btn-success btn-sm' onclick=\"fn_pre_view_img('type1_imgUrl" + index +"');\"><i class='fa fa-eye' aria-hidden='true'></i> 미리보기</button>";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			$("#img1_table > tbody:last").append(rowHtml);
		});
	}
	function fn_img1_del(idx) {
		if (!true) alert("fn_img_del(" + idx + ")");
		arrImg1.splice(idx, 1);
		fn_img1_appendTableTr();
		$("#img1_addItem").removeAttr("disabled");
	}
	function fn_img1_up(idx) {
		if (!true) alert("fn_img_up(" + idx + ")");
		var temp = arrImg1[idx-1];
		arrImg1[idx-1] = arrImg1[idx];
		arrImg1[idx] = temp;
		fn_img1_appendTableTr();
	}
	function fn_img1_down(idx) {
		if (!true) alert("fn_img_down(" + idx + ")");
		var temp = arrImg1[idx+1];
		arrImg1[idx+1] = arrImg1[idx];
		arrImg1[idx] = temp;
		fn_img1_appendTableTr();
	}
	/////////////////////////////////////////////////
	// KANG-20190326: type-1 script END
	/////////////////////////////////////////////////
</script>




<script>
	/////////////////////////////////////////////////
	// KANG-20190326: type-2 script BEGIN
	/////////////////////////////////////////////////
	var maxArrImg2 = 1;
	$("img2_addItem").tooltip();
	$("prd2_addItem").tooltip();
	//
	//
	//
	function fn_img2_addItem_click() {
		if (arrImg2.length >= maxArrImg2) {
			if (true) alert("이미지는 " + maxArrImg2 + "개까지만 등록 가능합니다.");
			return;
		}
		if (!true) alert("fn_img2_addItem_click()");
		var idx = arrImg2.length + 1;
		arrImg2.push({ imgUrl: "" });
		fn_img2_appendTableTr();
		if (idx >= maxArrImg2) {
			$("#img2_addItem").attr("disabled", true);
		}
	}
	function fn_img2_inputBlur(idx, cls, value) {
		if (true) console.log(idx + ": " + cls + ": " + value);
		arrImg2[idx][cls] = value;
	}
	function fn_img2_appendTableTr() {
		// clear
		$("#img2_table > tbody").empty();
		// value print
		arrImg2.forEach(function(value, index, array) {
			if (!true) alert("fn_img2_appendTableTr(): (" + index + "/" + array.length + ") : " + value.imgUrl);
			
			var rowHtml = "";
			rowHtml += "<tr>";
			rowHtml += "  <td class=\"info\">";
			rowHtml += "    이미지 URL " + (index+1) + " ";
			if (array.length > 1) {
				rowHtml += "    <span class=\"float-right\">";
				rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_img2_del(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">R</button>";
				if (index > 0) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_img2_up(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">U</button>";
				}
				if (index < array.length - 1) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_img2_down(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">D</button>";
				}
				rowHtml += "    </span>";
			}
			rowHtml += "  </td>";
			rowHtml += "  <td colspan='3'>";
			rowHtml += "    <input type='text' id='type2_imgUrl" + index + "' class='imgUrl' onblur=\"javascript:fn_img2_inputBlur(" + index + ",'imgUrl',this.value);\" style='width:700px;' value='" + value.imgUrl + "' maxlength='100' placeholder='500*240 사이즈 이미지 경로 입력' />";
			rowHtml += "    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <button type='button' id='type2_imgUrl" + index +"' class='btn btn-success btn-sm' onclick=\"fn_pre_view_img('type2_imgUrl" + index +"');\"><i class='fa fa-eye' aria-hidden='true'></i> 미리보기</button>";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			$("#img2_table > tbody:last").append(rowHtml);
		});
	}
	function fn_img2_del(idx) {
		if (!true) alert("fn_img_del(" + idx + ")");
		arrImg2.splice(idx, 1);
		fn_img2_appendTableTr();
		$("#img2_addItem").removeAttr("disabled");
	}
	function fn_img2_up(idx) {
		if (!true) alert("fn_img_up(" + idx + ")");
		var temp = arrImg2[idx-1];
		arrImg2[idx-1] = arrImg2[idx];
		arrImg2[idx] = temp;
		fn_img2_appendTableTr();
	}
	function fn_img2_down(idx) {
		if (!true) alert("fn_img_down(" + idx + ")");
		var temp = arrImg2[idx+1];
		arrImg2[idx+1] = arrImg2[idx];
		arrImg2[idx] = temp;
		fn_img2_appendTableTr();
	}
	////////////////////////////////////////////////////////////////////
	var maxArrPrd2 = 10;
	$("prd2_addItem").tooltip();
	//
	//
	//
	function fn_prd2_addItem_click() {
		if (arrPrd2.length >= maxArrPrd2) {
			if (true) alert("이미지는 " + maxArrPrd2 + "개까지만 등록 가능합니다.");
			return;
		}
		if (!true) alert("fn_prd2_addItem_click()");
		var idx = arrPrd2.length + 1;
		arrPrd2.push({ prdUrl: "", prdName: "", prdPrice: "", prdUnit: "", prdMblUrl: "", prdWebUrl: "" });
		fn_prd2_appendTableTr();
		if (idx >= maxArrPrd2) {
			$("#prd2_addItem").attr("disabled", true);
		}
	}
	function fn_prd2_inputBlur(idx, cls, value) {
		if (true) console.log(idx + ": " + cls + ": " + value);
		arrPrd2[idx][cls] = value;
	}
	function fn_prd2_appendTableTr() {
		// clear
		$("#prd2_table > tbody").empty();
		// value print
		arrPrd2.forEach(function(value, index, array) {
			if (true) console.log("fn_prd2_appendTableTr(): (" + index + "/" + array.length + ") : " + value.prdName + ", " + value.prdUnit);
			var rowHtml = "";
			rowHtml += "<tr>";
			rowHtml += "  <td class=\"info\" rowspan='6'>";
			rowHtml += "    상품 " + (index+1) + " ";
			if (array.length > 1) {
				rowHtml += "    <span class=\"float-right\">";
				rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_prd2_del(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">R</button>";
				if (index > 0) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_prd2_up(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">U</button>";
				}
				if (index < array.length - 1) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_prd2_down(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">D</button>";
				}
				rowHtml += "    </span>";
			}
			rowHtml += "  </td>";
			rowHtml += "  <td class='info'>이미지 URL</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type2_prdUrl" + index + "' class='prdUrl' onblur=\"javascript:fn_prd2_inputBlur(" + index + ",'prdUrl',this.value);\" style='width:600px;' value='" + value.prdUrl + "' maxlength='100' placeholder='188*188 사이즈 이미지 경로 입력' />";
			rowHtml += "    &nbsp;&nbsp;&nbsp; <button type='button' id='type2_prdUrl" + index +"' class='btn btn-success btn-sm' onclick=\"fn_pre_view_img('type2_prdUrl" + index +"');\"><i class='fa fa-eye' aria-hidden='true'></i> 미리보기</button>";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>상품명</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type2_prdName" + index + "' class='prdName' onblur=\"javascript:fn_prd2_inputBlur(" + index + ",'prdName',this.value);\" style='width:700px;' value='" + value.prdName + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>가격</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type2_prdPrice" + index + "' class='prdPrice' onblur=\"javascript:fn_prd2_inputBlur(" + index + ",'prdPrice',this.value);\" style='width:700px;' value='" + value.prdPrice + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>표시단위</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type2_prdUnit" + index + "' class='prdUnit' onblur=\"javascript:fn_prd2_inputBlur(" + index + ",'prdUnit',this.value);\" style='width:700px;' value='" + value.prdUnit + "' maxlength='10' placeholder='원~' />";
			/*
			rowHtml += "    <input name='prdUnit2" + index + "' onclick=\"javascript:fn_prd2_radioClick(" + index + ",'prdUnit','KRW');\" type='radio' " + checkedKRW + " /> 원화(KRW) &nbsp;&nbsp;&nbsp;";
			rowHtml += "    <input name='prdUnit2" + index + "' onclick=\"javascript:fn_prd2_radioClick(" + index + ",'prdUnit','USD');\" type='radio' " + checkedUSD + " /> 달러화(USD) &nbsp;&nbsp;&nbsp;";
			rowHtml += "    <input name='prdUnit2" + index + "' onclick=\"javascript:fn_prd2_radioClick(" + index + ",'prdUnit','EUR');\" type='radio' " + checkedEUR + " /> 유로화(EUR) &nbsp;&nbsp;&nbsp;";
			rowHtml += "    <input name='prdUnit2" + index + "' onclick=\"javascript:fn_prd2_radioClick(" + index + ",'prdUnit','CNY');\" type='radio' " + checkedCNY + " /> 위완화(CNY) &nbsp;&nbsp;&nbsp;";
			rowHtml += "    <input name='prdUnit2" + index + "' onclick=\"javascript:fn_prd2_radioClick(" + index + ",'prdUnit','JPY');\" type='radio' " + checkedJPY + " /> 엔화(JPY) &nbsp;&nbsp;&nbsp;";
			*/
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>보기(Mobile URL)</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type2_prdMblUrl" + index + "' class='prdMblUrl' onblur=\"javascript:fn_prd2_inputBlur(" + index + ",'prdMblUrl',this.value);\" style='width:700px;' value='" + value.prdMblUrl + "' maxlength='256' placeholder='http://' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>보기(Web URL)</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type2_prdWebUrl" + index + "' class='prdWebUrl' onblur=\"javascript:fn_prd2_inputBlur(" + index + ",'prdWebUrl',this.value);\" style='width:700px;' value='" + value.prdWebUrl + "' maxlength='256' placeholder='모바일 URL 입력' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			$("#prd2_table > tbody:last").append(rowHtml);
		});
	}
	function fn_prd2_del(idx) {
		if (!true) alert("fn_img_del(" + idx + ")");
		arrPrd2.splice(idx, 1);
		fn_prd2_appendTableTr();
		$("#prd2_addItem").removeAttr("disabled");
	}
	function fn_prd2_up(idx) {
		if (!true) alert("fn_img_up(" + idx + ")");
		var temp = arrPrd2[idx-1];
		arrPrd2[idx-1] = arrPrd2[idx];
		arrPrd2[idx] = temp;
		fn_prd2_appendTableTr();
	}
	function fn_prd2_down(idx) {
		if (!true) alert("fn_img_down(" + idx + ")");
		var temp = arrPrd2[idx+1];
		arrPrd2[idx+1] = arrPrd2[idx];
		arrPrd2[idx] = temp;
		fn_prd2_appendTableTr();
	}
	/////////////////////////////////////////////////
	// KANG-20190326: type-2 script END
	/////////////////////////////////////////////////
</script>




<script>
	/////////////////////////////////////////////////
	// KANG-20190326: type-3 script BEGIN
	/////////////////////////////////////////////////
	var maxArrImg3 = 1;
	$("img3_addItem").tooltip();
	//
	//
	//
	function fn_img3_addItem_click() {
		if (arrImg3.length >= maxArrImg3) {
			if (true) alert("이미지는 " + maxArrImg3 + "개까지만 등록 가능합니다.");
			return;
		}
		if (!true) alert("fn_img3_addItem_click()");
		var idx = arrImg3.length + 1;
		arrImg3.push({ imgUrl: "" });
		fn_img3_appendTableTr();
		if (idx >= maxArrImg3) {
			$("#img3_addItem").attr("disabled", true);
		}
	}
	function fn_img3_inputBlur(idx, cls, value) {
		if (true) console.log(idx + ": " + cls + ": " + value);
		arrImg3[idx][cls] = value;
	}
	function fn_img3_appendTableTr() {
		// clear
		$("#img3_table > tbody").empty();
		// value print
		arrImg3.forEach(function(value, index, array) {
			if (!true) alert("fn_img3_appendTableTr(): (" + index + "/" + array.length + ") : " + value.imgUrl);
			
			var rowHtml = "";
			rowHtml += "<tr>";
			rowHtml += "  <td class=\"info\">";
			rowHtml += "    이미지 URL " + (index+1) + " ";
			if (array.length > 1) {
				rowHtml += "    <span class=\"float-right\">";
				rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_img3_del(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">R</button>";
				if (index > 0) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_img3_up(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">U</button>";
				}
				if (index < array.length - 1) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_img3_down(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">D</button>";
				}
				rowHtml += "    </span>";
			}
			rowHtml += "  </td>";
			rowHtml += "  <td colspan='3'>";
			rowHtml += "    <input type='text' id='type3_imgUrl" + index + "' class='imgUrl' onblur=\"javascript:fn_img3_inputBlur(" + index + ",'imgUrl',this.value);\" style='width:700px;' value='" + value.imgUrl + "' maxlength='100' placeholder='500*240 사이즈 이미지 경로 입력' />";
			rowHtml += "    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <button type='button' id='type3_imgUrl" + index +"' class='btn btn-success btn-sm' onclick=\"fn_pre_view_img('type3_imgUrl" + index +"');\"><i class='fa fa-eye' aria-hidden='true'></i> 미리보기</button>";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			$("#img3_table > tbody:last").append(rowHtml);
		});
	}
	function fn_img3_del(idx) {
		if (!true) alert("fn_img_del(" + idx + ")");
		arrImg3.splice(idx, 1);
		fn_img3_appendTableTr();
		$("#img3_addItem").attr("disabled", false);
	}
	function fn_img3_up(idx) {
		if (!true) alert("fn_img_up(" + idx + ")");
		var temp = arrImg3[idx-1];
		arrImg3[idx-1] = arrImg3[idx];
		arrImg3[idx] = temp;
		fn_img3_appendTableTr();
	}
	function fn_img3_down(idx) {
		if (!true) alert("fn_img_down(" + idx + ")");
		var temp = arrImg3[idx+1];
		arrImg3[idx+1] = arrImg3[idx];
		arrImg3[idx] = temp;
		fn_img3_appendTableTr();
	}
	////////////////////////////////////////////////////////////
	var maxArrCpn3 = 3;
	$("cpn3_addItem").tooltip();
	//
	//
	//
	function fn_cpn3_addItem_click() {
		if (arrCpn3.length >= maxArrCpn3) {
			if (true) alert("이미지는 " + maxArrCpn3 + "개까지만 등록 가능합니다.");
			return;
		}
		if (!true) alert("fn_cpn3_addItem_click()");
		var idx = arrCpn3.length + 1;
		arrCpn3.push({ cpnText1: "", cpnText2: "", cpnText3: "", cpnText4: "", cpnNumber: "", cpnVisible: "hide" });
		fn_cpn3_appendTableTr();
		if (idx >= maxArrCpn3) {
			$("#cpn3_addItem").attr("disabled", true);
		}
	}
	function fn_cpn3_inputBlur(idx, cls, value) {
		if (true) console.log(idx + ": " + cls + ": " + value);
		arrCpn3[idx][cls] = value;
	}
	function fn_cpn3_radioClick(idx, cls, value) {
		if (true) console.log(idx + ": " + cls + ": " + value);
		arrCpn3[idx][cls] = value;
	}
	function fn_cpn3_appendTableTr() {
		// clear
		$("#cpn3_table > tbody").empty();
		// value print
		arrCpn3.forEach(function(value, index, array) {
			if (true) console.log("fn_cpn3_appendTableTr(): (" + index + "/" + array.length + ") : " + value.cpnText1 + ", " + value.cpnVisible);
			var rowHtml = "";
			rowHtml += "<tr>";
			rowHtml += "  <td class=\"info\" rowspan='6'>";
			rowHtml += "    쿠폰 " + (index+1) + " ";
			if (array.length > 1) {
				rowHtml += "    <span class=\"float-right\">";
				rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_cpn3_del(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">R</button>";
				if (index > 0) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_cpn3_up(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">U</button>";
				}
				if (index < array.length - 1) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_cpn3_down(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">D</button>";
				}
				rowHtml += "    </span>";
			}
			rowHtml += "  </td>";
			rowHtml += "  <td class='info'>쿠폰할인정보</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type3_cpnText1" + index + "' class='cpnText1' onblur=\"javascript:fn_cpn3_inputBlur(" + index + ",'cpnText1',this.value);\" style='width:700px;' value='" + value.cpnText1 + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>쿠폰명</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type3_cpnText2" + index + "' class='cpnText2' onblur=\"javascript:fn_cpn3_inputBlur(" + index + ",'cpnText2',this.value);\" style='width:700px;' value='" + value.cpnText2 + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>쿠폰사용조건</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type3_cpnText3" + index + "' class='cpnText3' onblur=\"javascript:fn_cpn3_inputBlur(" + index + ",'cpnText3',this.value);\" style='width:700px;' value='" + value.cpnText3 + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>쿠폰사용기간</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type3_cpnText4" + index + "' class='cpnText4' onblur=\"javascript:fn_cpn3_inputBlur(" + index + ",'cpnText4',this.value);\" style='width:700px;' value='" + value.cpnText4 + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>쿠폰번호</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type3_cpnNumber" + index + "' class='cpnNumber' onblur=\"javascript:fn_cpn3_inputBlur(" + index + ",'cpnNumber',this.value);\" style='width:700px;' value='" + value.cpnNumber + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>다운받기 노출</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input name='cpnVisible3" + index + "' onclick=\"javascript:fn_cpn3_radioClick(" + index + ",'cpnVisible','show');\" type='radio' value='show' /> 쿠폰 노출 &nbsp;&nbsp;&nbsp;";
			rowHtml += "    <input name='cpnVisible3" + index + "' onclick=\"javascript:fn_cpn3_radioClick(" + index + ",'cpnVisible','hide');\" type='radio' value='hide' /> 쿠폰 미노출 &nbsp;&nbsp;&nbsp;";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			$("#cpn3_table > tbody:last").append(rowHtml);
			$('input[name=cpnVisible3' + index + ']').val([value.cpnVisible]);
		});
	}
	function fn_cpn3_del(idx) {
		if (!true) alert("fn_img_del(" + idx + ")");
		arrCpn3.splice(idx, 1);
		fn_cpn3_appendTableTr();
		$("#cpn3_addItem").attr("disabled", false);
	}
	function fn_cpn3_up(idx) {
		if (!true) alert("fn_img_up(" + idx + ")");
		var temp = arrCpn3[idx-1];
		arrCpn3[idx-1] = arrCpn3[idx];
		arrCpn3[idx] = temp;
		fn_cpn3_appendTableTr();
	}
	function fn_cpn3_down(idx) {
		if (!true) alert("fn_img_down(" + idx + ")");
		var temp = arrCpn3[idx+1];
		arrCpn3[idx+1] = arrCpn3[idx];
		arrCpn3[idx] = temp;
		fn_cpn3_appendTableTr();
	}
	/////////////////////////////////////////////////
	// KANG-20190326: type-3 script BEGIN
	/////////////////////////////////////////////////
</script>




<script>
	/////////////////////////////////////////////////
	// KANG-20190326: type-4 script BEGIN
	/////////////////////////////////////////////////
	var maxArrAnn4 = 1;
	$("ann4_addItem").tooltip();
	//
	//
	//
	function fn_ann4_addItem_click() {
		if (arrAnn4.length >= maxArrAnn4) {
			if (true) alert("이미지는 " + maxArrAnn4 + "개까지만 등록 가능합니다.");
			return;
		}
		if (!true) alert("fn_ann4_addItem_click()");
		var idx = arrAnn4.length + 1;
		arrAnn4.push({ annText: "", annFixed: "center" });
		fn_ann4_appendTableTr();
		if (idx >= maxArrAnn4) {
			$("#ann4_addItem").attr("disabled", true);
		}
	}
	function fn_ann4_inputBlur(idx, cls, value) {
		if (true) console.log(idx + ": " + cls + ": " + value);
		arrAnn4[idx][cls] = value;
	}
	function fn_ann4_radioClick(idx, cls, value) {
		if (true) console.log(idx + ": " + cls + ": " + value);
		arrAnn4[idx][cls] = value;
	}
	function fn_ann4_appendTableTr() {
		// clear
		$("#ann4_table > tbody").empty();
		// value print
		arrAnn4.forEach(function(value, index, array) {
			if (true) console.log("fn_ann4_appendTableTr(): (" + index + "/" + array.length + ") : " + value.annText + ", " + value.annFixed);
			var rowHtml = "";
			rowHtml += "<tr>";
			rowHtml += "  <td class=\"info\" rowspan='2'>";
			rowHtml += "    안내 " + (index+1) + " ";
			if (array.length > 1) {
				rowHtml += "    <span class=\"float-right\">";
				rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_ann4_del(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">R</button>";
				if (index > 0) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_ann4_up(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">U</button>";
				}
				if (index < array.length - 1) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_ann4_down(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">D</button>";
				}
				rowHtml += "    </span>";
			}
			rowHtml += "  </td>";
			rowHtml += "  <td class='info'>문구</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type4_annText" + index + "' class='annText' onblur=\"javascript:fn_ann4_inputBlur(" + index + ",'annText',this.value);\" style='width:700px;' value='" + value.annText + "' maxlength='36' placeholder='(문자수 최대 36, 띄어쓰기포함)' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>정렬</td>";
			rowHtml += "  <td colspan='2'>";
			//rowHtml += "    <input name='annFixed" + index + "' onclick=\"javascript:fn_ann4_radioClick(" + index + ",'annFixed','left'  );\" type='radio' value='left' /> 좌측정렬 &nbsp;&nbsp;&nbsp;";
			rowHtml += "    <input name='annFixed" + index + "' onclick=\"javascript:fn_ann4_radioClick(" + index + ",'annFixed','center');\" type='radio' value='center' checked /> 중앙정렬 &nbsp;&nbsp;&nbsp;";
			//rowHtml += "    <input name='annFixed" + index + "' onclick=\"javascript:fn_ann4_radioClick(" + index + ",'annFixed','right' );\" type='radio' value='right' /> 우측정렬 &nbsp;&nbsp;&nbsp;";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			$("#ann4_table > tbody:last").append(rowHtml);
			$('input[name=annFixed' + index + ']').val([value.annFixed]);
		});
	}
	function fn_ann4_del(idx) {
		if (!true) alert("fn_img_del(" + idx + ")");
		arrAnn4.splice(idx, 1);
		fn_ann4_appendTableTr();
		$("#ann4_addItem").attr("disabled", false);
	}
	function fn_ann4_up(idx) {
		if (!true) alert("fn_img_up(" + idx + ")");
		var temp = arrAnn4[idx-1];
		arrAnn4[idx-1] = arrAnn4[idx];
		arrAnn4[idx] = temp;
		fn_ann4_appendTableTr();
	}
	function fn_ann4_down(idx) {
		if (!true) alert("fn_img_down(" + idx + ")");
		var temp = arrAnn4[idx+1];
		arrAnn4[idx+1] = arrAnn4[idx];
		arrAnn4[idx] = temp;
		fn_ann4_appendTableTr();
	}
	/////////////////////////////////////////////////
	// KANG-20190326: type-4 script END
	/////////////////////////////////////////////////
</script>




<script>
	/////////////////////////////////////////////////
	// KANG-20190326: type-5 script BEGIN
	/////////////////////////////////////////////////
	var maxArrPrd5 = 10;
	$("prd5_addItem").tooltip();
	//
	//
	//
	function fn_prd5_addItem_click() {
		if (arrPrd5.length >= maxArrPrd5) {
			if (true) alert("이미지는 " + maxArrPrd5 + "개까지만 등록 가능합니다.");
			return;
		}
		if (!true) alert("fn_prd5_addItem_click()");
		var idx = arrPrd5.length + 1;
		arrPrd5.push({ prdUrl: "", prdName: "", prdPrice: "", prdUnit: "", prdMblUrl: "", prdWebUrl: "" });
		fn_prd5_appendTableTr();
		if (idx >= maxArrPrd5) {
			$("#prd5_addItem").attr("disabled", true);
		}
	}
	function fn_prd5_inputBlur(idx, cls, value) {
		if (true) console.log(idx + ": " + cls + ": " + value);
		arrPrd5[idx][cls] = value;
	}
	function fn_prd5_appendTableTr() {
		// clear
		$("#prd5_table > tbody").empty();
		// value print
		arrPrd5.forEach(function(value, index, array) {
			if (true) console.log("fn_prd5_appendTableTr(): (" + index + "/" + array.length + ") : " + value.prdName + ", " + value.prdUnit);
			var rowHtml = "";
			rowHtml += "<tr>";
			rowHtml += "  <td class=\"info\" rowspan='6'>";
			rowHtml += "    상품 " + (index+1) + " ";
			if (array.length > 1) {
				rowHtml += "    <span class=\"float-right\">";
				rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_prd5_del(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">R</button>";
				if (index > 0) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_prd5_up(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">U</button>";
				}
				if (index < array.length - 1) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_prd5_down(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">D</button>";
				}
				rowHtml += "    </span>";
			}
			rowHtml += "  </td>";
			rowHtml += "  <td class='info'>이미지 URL</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type5_prdUrl" + index + "' class='prdUrl' onblur=\"javascript:fn_prd5_inputBlur(" + index + ",'prdUrl',this.value);\" style='width:600px;' value='" + value.prdUrl + "' maxlength='100' placeholder='188*188 사이즈 이미지 경로 입력' />";
			rowHtml += "    &nbsp;&nbsp;&nbsp; <button type='button' class='btn btn-success btn-sm' onclick=\"fn_pre_view_img('type5_prdUrl" + index +"');\"><i class='fa fa-eye' aria-hidden='true'></i> 미리보기</button>";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>상품명</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type5_prdName" + index + "' class='prdName' onblur=\"javascript:fn_prd5_inputBlur(" + index + ",'prdName',this.value);\" style='width:700px;' value='" + value.prdName + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>가격</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type5_prdPrice" + index + "' class='prdPrice' onblur=\"javascript:fn_prd5_inputBlur(" + index + ",'prdPrice',this.value);\" style='width:700px;' value='" + value.prdPrice + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>표시단위</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type5_prdUnit" + index + "' class='prdUnit' onblur=\"javascript:fn_prd5_inputBlur(" + index + ",'prdUnit',this.value);\" style='width:700px;' value='" + value.prdUnit + "' maxlength='10' placeholder='원~' />";
			/*
			rowHtml += "    <input name='prdUnit5" + index + "' onclick=\"javascript:fn_prd5_radioClick(" + index + ",'prdUnit','KRW');\" type='radio' " + checkedKRW + " /> 원화(KRW) &nbsp;&nbsp;&nbsp;";
			rowHtml += "    <input name='prdUnit5" + index + "' onclick=\"javascript:fn_prd5_radioClick(" + index + ",'prdUnit','USD');\" type='radio' " + checkedUSD + " /> 달러화(USD) &nbsp;&nbsp;&nbsp;";
			rowHtml += "    <input name='prdUnit5" + index + "' onclick=\"javascript:fn_prd5_radioClick(" + index + ",'prdUnit','EUR');\" type='radio' " + checkedEUR + " /> 유로화(EUR) &nbsp;&nbsp;&nbsp;";
			rowHtml += "    <input name='prdUnit5" + index + "' onclick=\"javascript:fn_prd5_radioClick(" + index + ",'prdUnit','CNY');\" type='radio' " + checkedCNY + " /> 위완화(CNY) &nbsp;&nbsp;&nbsp;";
			rowHtml += "    <input name='prdUnit5" + index + "' onclick=\"javascript:fn_prd5_radioClick(" + index + ",'prdUnit','JPY');\" type='radio' " + checkedJPY + " /> 엔화(JPY) &nbsp;&nbsp;&nbsp;";
			*/
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>보기(Mobile URL)</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type5_prdMblUrl" + index + "' class='prdMblUrl' onblur=\"javascript:fn_prd5_inputBlur(" + index + ",'prdMblUrl',this.value);\" style='width:700px;' value='" + value.prdMblUrl + "' maxlength='256' placeholder='http://' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>보기(Web URL)</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type5_prdWebUrl" + index + "' class='prdWebUrl' onblur=\"javascript:fn_prd5_inputBlur(" + index + ",'prdWebUrl',this.value);\" style='width:700px;' value='" + value.prdWebUrl + "' maxlength='256' placeholder='모바일 URL 입력' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			$("#prd5_table > tbody:last").append(rowHtml);
		});
	}
	function fn_prd5_del(idx) {
		if (!true) alert("fn_img_del(" + idx + ")");
		arrPrd5.splice(idx, 1);
		fn_prd5_appendTableTr();
		$("#prd5_addItem").attr("disabled", false);
	}
	function fn_prd5_up(idx) {
		if (!true) alert("fn_img_up(" + idx + ")");
		var temp = arrPrd5[idx-1];
		arrPrd5[idx-1] = arrPrd5[idx];
		arrPrd5[idx] = temp;
		fn_prd5_appendTableTr();
	}
	function fn_prd5_down(idx) {
		if (!true) alert("fn_img_down(" + idx + ")");
		var temp = arrPrd5[idx+1];
		arrPrd5[idx+1] = arrPrd5[idx];
		arrPrd5[idx] = temp;
		fn_prd5_appendTableTr();
	}
	/////////////////////////////////////////////////
	// KANG-20190326: type-5 script END
	/////////////////////////////////////////////////
</script>




<script>
	/////////////////////////////////////////////////
	// KANG-20190326: type-6 script BEGIN
	/////////////////////////////////////////////////
	var maxArrCpn6 = 3;
	$("cpn6_addItem").tooltip();
	//
	//
	//
	function fn_cpn6_addItem_click() {
		if (arrCpn6.length >= maxArrCpn6) {
			if (true) alert("이미지는 " + maxArrCpn6 + "개까지만 등록 가능합니다.");
			return;
		}
		if (!true) alert("fn_cpn6_addItem_click()");
		var idx = arrCpn6.length + 1;
		arrCpn6.push({ cpnText1: "", cpnText2: "", cpnText3: "", cpnText4: "", cpnNumber: "", cpnVisible: "hide" });
		fn_cpn6_appendTableTr();
		if (idx >= maxArrCpn6) {
			$("#cpn6_addItem").attr("disabled", true);
		}
	}
	function fn_cpn6_inputBlur(idx, cls, value) {
		if (true) console.log(idx + ": " + cls + ": " + value);
		arrCpn6[idx][cls] = value;
	}
	function fn_cpn6_radioClick(idx, cls, value) {
		if (true) console.log(idx + ": " + cls + ": " + value);
		arrCpn6[idx][cls] = value;
	}
	function fn_cpn6_appendTableTr() {
		// clear
		$("#cpn6_table > tbody").empty();
		// value print
		arrCpn6.forEach(function(value, index, array) {
			if (true) console.log("fn_cpn6_appendTableTr(): (" + index + "/" + array.length + ") : " + value.cpnText1 + ", " + value.cpnVisible);
			var rowHtml = "";
			rowHtml += "<tr>";
			rowHtml += "  <td class=\"info\" rowspan='6'>";
			rowHtml += "    쿠폰 " + (index+1) + " ";
			if (array.length > 1) {
				rowHtml += "    <span class=\"float-right\">";
				rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_cpn6_del(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">R</button>";
				if (index > 0) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_cpn6_up(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">U</button>";
				}
				if (index < array.length - 1) {
					rowHtml += "      <button type=\"button\" onclick=\"javascript:fn_cpn6_down(" + index + ")\" class=\"btn btn-primary\" style=\"background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;\">D</button>";
				}
				rowHtml += "    </span>";
			}
			rowHtml += "  </td>";
			rowHtml += "  <td class='info'>쿠폰할인정보</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type6_cpnText1" + index + "' class='cpnText1' onblur=\"javascript:fn_cpn6_inputBlur(" + index + ",'cpnText1',this.value);\" style='width:700px;' value='" + value.cpnText1 + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>쿠폰명</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type6_cpnText2" + index + "' class='cpnText2' onblur=\"javascript:fn_cpn6_inputBlur(" + index + ",'cpnText2',this.value);\" style='width:700px;' value='" + value.cpnText2 + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>쿠폰사용조건</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type6_cpnText3" + index + "' class='cpnText3' onblur=\"javascript:fn_cpn6_inputBlur(" + index + ",'cpnText3',this.value);\" style='width:700px;' value='" + value.cpnText3 + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>쿠폰사용기간</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type6_cpnText4" + index + "' class='cpnText4' onblur=\"javascript:fn_cpn6_inputBlur(" + index + ",'cpnText4',this.value);\" style='width:700px;' value='" + value.cpnText4 + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>쿠폰번호</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input type='text' id='type6_cpnNumber" + index + "' class='cpnNumber' onblur=\"javascript:fn_cpn6_inputBlur(" + index + ",'cpnNumber',this.value);\" style='width:700px;' value='" + value.cpnNumber + "' maxlength='100' placeholder='' />";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			rowHtml += "<tr>";
			rowHtml += "  <td class='info'>다운받기 노출</td>";
			rowHtml += "  <td colspan='2'>";
			rowHtml += "    <input name='cpnVisible6" + index + "' onclick=\"javascript:fn_cpn6_radioClick(" + index + ",'cpnVisible','show');\" type='radio' value='show' /> 쿠폰 노출 &nbsp;&nbsp;&nbsp;";
			rowHtml += "    <input name='cpnVisible6" + index + "' onclick=\"javascript:fn_cpn6_radioClick(" + index + ",'cpnVisible','hide');\" type='radio' value='hide' /> 쿠폰 미노출 &nbsp;&nbsp;&nbsp;";
			rowHtml += "  </td>";
			rowHtml += "</tr>";
			$("#cpn6_table > tbody:last").append(rowHtml);
			$('input[name=cpnVisible6' + index + ']').val([value.cpnVisible]);
		});
	}
	function fn_cpn6_del(idx) {
		if (!true) alert("fn_img_del(" + idx + ")");
		arrCpn6.splice(idx, 1);
		fn_cpn6_appendTableTr();
		$("#cpn6_addItem").attr("disabled", false);
	}
	function fn_cpn6_up(idx) {
		if (!true) alert("fn_img_up(" + idx + ")");
		var temp = arrCpn6[idx-1];
		arrCpn6[idx-1] = arrCpn6[idx];
		arrCpn6[idx] = temp;
		fn_cpn6_appendTableTr();
	}
	function fn_cpn6_down(idx) {
		if (!true) alert("fn_img_down(" + idx + ")");
		var temp = arrCpn6[idx+1];
		arrCpn6[idx+1] = arrCpn6[idx];
		arrCpn6[idx] = temp;
		fn_cpn6_appendTableTr();
	}
	/////////////////////////////////////////////////
	// KANG-20190326: type-6 script END
	/////////////////////////////////////////////////
</script>








<script>
	// 알리미 테스트 발송
	function fn_alimiTestSend() {
		if (true) console.log("KANG.fn_alimiTestSend: 알리미 테스트 발송");
		
		if (true) {
			var alimiShow = $('input[name=alimiShow]:checked').val();
			if (true) console.log("fn_get_alimi_json(): " + alimiShow);  // hide/show
			if (alimiShow == "hide") {
				alert("'(신)알리미 등록창'에서 '알림톡 노출'을 선택하고 자료를 입력하세요.");
				document.getElementById("nav-tabs-new").click();  // (신)알리미로 이동
				return;
			}
		}

		if (true) {
			var json = fn_get_alimi_json();
			if (!true) console.log("> " + json);
			if (json == false) {
				return false;
			}
			var txtTest = "(테스트)";
			$('#IOS_MSG').val(txtTest + $('#MOBILE_DISP_TITLE').val() + "\n" + $('#MOBILE_CONTENT').val());
			$('#AND_TOP_MSG').val(txtTest + $('#MOBILE_DISP_TITLE').val());
			$('#AND_BTM_MSG').val(txtTest + $('#MOBILE_CONTENT').val());
			$('#DETAIL_URL').val($('#MOBILE_LNK_PAGE_URL').val());
			$('#BANNER_URL').val($('#BNNR_IMG_URL').val());
			$('#TALK_SUMMARY_MSG').val(txtTest + $('#alimiText').val());
			$('#ALIMI_MESSAGE').val(json);
		}

		var pop = window.open('', 'POP_ALIMITESTSEND', 'top=50,left=80, location=no,status=no,toolbar=no,scrollbars=yes');

		var frmAlimiTestSend = document.frmAlimiTestSend;
		frmAlimiTestSend.target = "POP_ALIMITESTSEND";
		frmAlimiTestSend.action = "${staticPATH }/channel/channelAlimiTestSend.do";
		frmAlimiTestSend.method = "POST";
		frmAlimiTestSend.submit();
		pop.focus();
	}
	
</script>

<form name="frmAlimiTestSend" id="frmAlimiTestSend">
	<input type="hidden" id="SERVER_TYPE" name="SERVER_TYPE" value="real" />
	<input type="hidden" id="TALK_MSG_TEMP_NO" name="TALK_MSG_TEMP_NO" value="001" />
	<input type="hidden" id="TALK_DISP_YN" name="TALK_DISP_YN" value="Y" />
	<input type="hidden" id="IOS_MSG" name="IOS_MSG" value="" />
	<input type="hidden" id="AND_TOP_MSG" name="AND_TOP_MSG" value="" />
	<input type="hidden" id="AND_BTM_MSG" name="AND_BTM_MSG" value="" />
	<input type="hidden" id="DETAIL_URL" name="DETAIL_URL" value="" />
	<input type="hidden" id="BANNER_URL" name="BANNER_URL" value="" />
	<input type="hidden" id="ETC_DATA" name="ETC_DATA" value="{'CAMPAIGNCODE':'CAMP00000'}" />
	<input type="hidden" id="TALK_SUMMARY_MSG" name="TALK_SUMMARY_MSG" value="" />
	<input type="hidden" id="ALIMI_MESSAGE" name="ALIMI_MESSAGE" value="" />
	<input type="hidden" id="SEND_DATETIME" name="SEND_DATETIME" value="즉시" />
</form>



<script>
	// KANG-20200413: 채널 복사
	function fn_copyChannel() {
		//alert("KANG-20200413: fn_copyChannel()");
		//window.open("${staticPATH }/campaign/property.do?CampaignId="+campaign_id, "propertyPop", "width=1100, height=450, status=1");
		//window.open("${staticPATH }/campaign/campaignList.do", "propertyPop", "width=1100, height=450, status=1");
		var disp_dt = $('#MOBILE_DISP_DT').val();  // 노출일
		if (!true) alert(">>>>> KANG-20200418: fn_copyChannel: ." + disp_dt + ".");
		popup_campaignChannel = window.open("${staticPATH }/campaign/campaignChannelList.do?"
				+ "CampaignId=${bo.campaignid}"
				+ "&CELLID=${bo.cellid}"
				+ "&CHANNEL_CD=MOBILE"
				+ "&disp_dt=" + disp_dt
				+ "&MANUAL_TRANS_YN=" + "${bo.manual_trans_yn}"            // KANG-20200606: create
				+ "&DISP_TIME=" + $("#MOBILE_DISP_TIME").val()             // KANG-20200606: create
				+ "&SEND_PREFER_CD=" + $("#MOBILE_SEND_PREFER_CD").val()   // KANG-20200606: create
				, "propertyPop", "width=1100, height=450, status=1");
	}
</script>












<!--PAGE CONTENT -->
<div id="content" style="width: 100%;">
	<!--BLOCK SECTION -->
	<div class="row" style="width: 100%;">
		<div class="col-lg-1"></div>
		<div class="col-lg-10">
			<div class="col-md-12 page-header" style="margin-top: 0px;">
				<h3>채널 상세 정보.</h3>
			</div>
			<form name="form" id="form">
				<input type="hidden" id="CampaignId"   name="CampaignId"   value="${bo.campaignid}" />
				<input type="hidden" id="CAMPAIGNCODE" name="CAMPAIGNCODE" value="${bo.campaigncode}" />
				<input type="hidden" id="FLOWCHARTID"  name="FLOWCHARTID"  value="${bo.flowchartid}" />
				<input type="hidden" id="CELLID"       name="CELLID"       value="${bo.cellid}" />
				<input type="hidden" id="TO_DATE"      name="TO_DATE"      value="" />
				<input type="hidden" id="TO_DATE_P1"   name="TO_DATE_P1"   value="" />
				<input type="hidden" id="TO_DATE_P2"   name="TO_DATE_P2"   value="" />
				<input type="hidden" id="ALIMI_PARAMS" name="ALIMI_PARAMS" value="" />
				<!-- Nav tabs -->
				<ul class="nav nav-tabs">
					<li class="nav-item"><a id="nav-tabs-old" class="nav-link active" data-toggle="tab" href="#oldAlimi">(구)알리미등록창</a> </li>
					<li class="nav-item"><a id="nav-tabs-new" class="nav-link" data-toggle="tab" href="#newAlimi">(신)알리미등록창</a></li>
				</ul>

				<!-- Tab panes -->
				<div class="tab-content" style="margin: 0; padding: 0;">
					<!-- ############# -->
					<!-- (구)알리미 등록창 -->
					<!-- ############# -->
					<div id="oldAlimi" class="container-fluid tab-pane active"
						style="margin: 0 0 0 0;">
						<br>
						<div>
							<h6>* 캠페인 기본</h6>
						</div>
						<div class="col-lg-12" id="table">
							<table
								class="table table-striped table-hover table-condensed table-bordered my_table"
								style="width: 100%;">
								<colgroup>
									<col width="15%" />
									<col width="35%" />
									<col width="15%" />
									<col width="35%" />
								</colgroup>
								<tr>
									<td class="info">캠페인 코드/명</td>
									<td class="tbtd_content" colspan="3">[${bo.campaigncode}]${bo.campaignname}</td>
									<%-- <td class="info">플로차트 이름</td>
											<td class="tbtd_content" colspan="3">${bo.flowchartname}</td> --%>
								</tr>
								<tr>
									<td class="info">채널</td>
									<td class="tbtd_content"><select id="CHANNEL_CD"
										name="CHANNEL_CD" style="width: 125px;"
										<c:if test="${DISABLED == 'Y'}">disabled="disabled"</c:if>>
											<c:forEach var="val" items="${channel_list}">
												<option value="${val.code_id}"
													<c:if test="${val.code_id eq CHANNEL_CD}">selected="selected"</c:if>>
													${val.code_name}</option>
											</c:forEach>
									</select></td>
									<td class="info">고객세그먼트</td>
									<td class="tbtd_content" colspan="3">${bo.cellname}</td>
								</tr>
							</table>
						</div>
						<div>
							<h6>* 캠페인 내용</h6>
						</div>
						<div class="col-lg-12" style="padding-top: 5px;">
							<table
								class="table table-striped table-hover table-condensed table-bordered my_table"
								style="width: 100%;">
								<colgroup>
									<col width="15%" />
									<col width="35%" />
									<col width="15%" />
									<col width="35%" />
								</colgroup>

								<tr>
									<td class="info">앱구분</td>
									<td class="tbtd_content"><select id="MOBILE_APP_KD_CD"
										name="MOBILE_APP_KD_CD" style="width: 90px;">
											<c:forEach var="val" items="${mobileApp_list}">
												<option value="${val.code_id}"
													<c:if test="${val.code_id eq bo.mobile_app_kd_cd}">selected="selected"</c:if>>
													${val.code_name}</option>
											</c:forEach>
									</select></td>
									<td class="info">발송시간</td>
									<td class="tbtd_content">
										<!-- KANG-20200606: 발송시간 유지 -->
										<select id="MOBILE_DISP_TIME" name="MOBILE_DISP_TIME" style="width: 80px;"></select> 
										<select id="MOBILE_SEND_PREFER_CD" name="MOBILE_SEND_PREFER_CD">
											<c:forEach var="val" items="${mobileSendPreferCd}">
												<option value="${val.code_id}" <c:if test="${val.code_id eq bo.mobile_send_prefer_cd}">selected="selected"</c:if>> ${val.code_name}</option>
											</c:forEach>
										</select>
									</td>
								</tr>

								<tr>
									<td class="info">연결페이지</td>
									<td class="tbtd_content" colspan="3"><select
										id="MOBILE_LNK_PAGE_TYP" name="MOBILE_LNK_PAGE_TYP"
										style="width: 115px;">
											<option value="01"
												<c:if test="${bo.mobile_lnk_page_typ eq '01' or bo.mobile_lnk_page_typ == null or bo.mobile_lnk_page_typ == ''}">selected</c:if>>모바일+URL</option>
											<option value="02"
												<c:if test="${bo.mobile_lnk_page_typ eq '02'}">selected</c:if>>URL</option>
									</select>&nbsp; <c:if test="${bo.mobile_lnk_page_typ eq '01' or bo.mobile_lnk_page_typ == null or bo.mobile_lnk_page_typ == ''}">
											<c:set var="mobile_lnk_page_url" value="http://m.11st.co.kr" />
										</c:if> <c:if test="${bo.mobile_lnk_page_typ eq '02'}">
											<c:set var="mobile_lnk_page_url"
												value="${bo.mobile_lnk_page_url }" />
										</c:if> <input name="MOBILE_LNK_PAGE_URL" class="txt"
										id="MOBILE_LNK_PAGE_URL" style="width: 400px;" type="text"
										maxlength="150" readonly="readonly"
										value="${mobile_lnk_page_url}"></td>
								</tr>

								<tr>
									<td class="info">노출일</td>
									<td class="tbtd_content"><input type="text" id="MOBILE_DISP_DT" name="MOBILE_DISP_DT" class="txt" style="width: 95px;"
										<c:if test="${bo.mobile_disp_dt != null}">value="${bo.mobile_disp_dt}"</c:if>
										<c:if test="${bo.mobile_disp_dt == null && bo.camp_term_cd eq '01'}">value="${bo.camp_bgn_dt}"</c:if>
										readonly="readonly" />
										<c:if test="${bo.camp_term_cd eq '02'}">(전송일 +1일)</c:if>
									</td>
									<td class="info">우선순위</td>
									<td class="tbtd_content"><select id="MOBILE_PRIORITY_RNK"
										name="MOBILE_PRIORITY_RNK" style="width: 60px;">
											<c:forEach var="val" items="${priority_rank}">
												<!-- 캠페인의 채널우선순위 적용여부 체크 -->
												<c:if
													test="${bo.channel_priority_yn == 'N' && bo.channel_priority_yn == val.code_id}">"
															<option value="${val.code_id}">${val.code_name}
													</option>
												</c:if>
												<c:if
													test="${bo.channel_priority_yn == 'Y' && val.code_id != 'N' }">
													<!-- 사용자의 권한체크(user.title) 우선순위 권한에 따라 보여준다 -->
													<%-- <c:if test="${user.title =='N' || user.title <= val.code_id  }"> --%>
													<option value="${val.code_id}"
														<c:if test="${val.code_id eq bo.mobile_priority_rnk}">selected="selected"</c:if>>
														${val.code_name}</option>
													<%-- </c:if> --%>
												</c:if>
											</c:forEach>
									</select></td>
								</tr>

								<tr>
									<td class="info">푸시알림제목</td><!-- KANG-20200406 -->
									<td class="tbtd_content" colspan="3"><input type="text"
										id="MOBILE_DISP_TITLE" name="MOBILE_DISP_TITLE"
										style="width: 350px;" value="${bo.mobile_disp_title}"
										class="txt" maxlength="22" placeholder='(문자수 최대 22) '/>
										</td>
								</tr>

								<!-- 광고 -->
								<c:set var="subjectVal" value="${bo.mobile_content}" />
								<c:if
									test="${bo.mobile_content == '' || bo.mobile_content eq null}">
									<c:set var="subjectVal" value="(광고)" />
								</c:if>

								<tr>
									<td class="info">푸시알림내용</td><!-- KANG-20200406 -->
									<td class="tbtd_content" colspan="3"><input type="text"
										id="MOBILE_CONTENT" name="MOBILE_CONTENT"
										style="width: 550px;" value="${subjectVal}" class="txt"
										maxlength="22" placeholder='(문자수 최대 22) '/></td>
								</tr>

								<tr>
									<td class="info">알리미타임라인에노출</td>
									<td class="tbtd_content"><c:forEach var="val"
											items="${timeline_disp_yn}" varStatus="status">
											<input type="radio" name="TIMELINE_DISP_YN" class="txt"
												value="${val.code_id}"
												<c:if test="${status.first}">checked="checked"</c:if>
												<c:if test="${val.code_id eq bo.timeline_disp_yn}">checked="checked"</c:if> /> ${val.code_name}
											</c:forEach></td>
									<td class="info">썸네일이미지URL</td>
									<td class="tbtd_content" colspan="3">
										<div id="search2">
											<input type="text" id="THUM_IMG_URL" name="THUM_IMG_URL"
												style="width: 250px;" value="${bo.thum_img_url}" class="txt"
												maxlength="100" />
											<button type="button" class="btn btn-success btn-sm"
												onclick="fn_pre_view_img('THUM_IMG_URL');">
												<i class="fa fa-eye" aria-hidden="true"></i> 미리보기
											</button>
										</div>
									</td>
								</tr>

								<tr>
									<td class="info">알림표시방법</td>
									<td class="tbtd_content"><c:forEach var="val"
											items="${push_msg_popup_indc_yn}" varStatus="status">
											<input type="radio" name="PUSH_MSG_POPUP_INDC_YN" class="txt"
												value="${val.code_id}"
												<c:if test="${status.first}">checked="checked"</c:if>
												<c:if test="${val.code_id eq bo.push_msg_popup_indc_yn}">checked="checked"</c:if> /> ${val.code_name}
											</c:forEach></td>
									<td class="info">스테이터스바<br />배너이미지URL
									</td>
									<td class="tbtd_content" colspan="3">
										<div id="search2">
											<input type="text" id="BNNR_IMG_URL" name="BNNR_IMG_URL"
												style="width: 250px;" value="${bo.bnnr_img_url}" class="txt"
												maxlength="100" />
											<button type="button" class="btn btn-success btn-sm"
												onclick="fn_pre_view_img('BNNR_IMG_URL');">
												<i class="fa fa-eye" aria-hidden="true"></i> 미리보기
											</button>
											<br>
											<input type="text" id="BNNR_STR_IMG_URL" name="BNNR_STR_IMG_URL"
												style="width: 250px;" value="${bo.bnnr_str_img_url}" class="txt"
												maxlength="500" readonly/>
											<button type="button" class="btn btn-success btn-sm" id="BNNR_STR_IMG_URL_BUTTON"
												onclick="fn_pre_view_str_img();">
												<i class="fa fa-eye" aria-hidden="true"></i> 적용 &amp; 보기
											</button>
										</div>
									</td>
								</tr>

								<tr>
									<td class="info">추가텍스트</td>
									<td class="tbtd_content" colspan="3">
										<table>
											<tr>
												<td><textarea name="MOBILE_ADD_TEXT"
														id="MOBILE_ADD_TEXT" rows="12" cols="100">${bo.mobile_add_text}</textarea>
												</td>
												<td width="10px"></td>
												<td valign="top">
													<!-- label for="useIndiL"></label --> 
													<input type="radio" name="useIndi" value="N" id="useIndia" <c:if test="${bo.mobile_person_msg_yn eq 'N'}"> checked</c:if>> 개인별 적용(안함)<br /> 
													<input type="radio" name="useIndi" value="Y" id="useIndib" <c:if test="${bo.mobile_person_msg_yn eq 'Y'}"> checked</c:if>> 개인별 적용(DB방식)<br /> 
													<input type="radio" name="useIndi" value="P" id="useIndic" <c:if test="${bo.mobile_person_msg_yn eq 'P'}"> checked</c:if>> 개인별 적용(API방식)<br /> 
													<select style="width: 150px; height: 123px" size="4" id="VAL_LIST" name="VAL_LIST" disabled>
														<c:forEach var="val" items="${vri_list}">
															<option value="${val.vari_name}"> ${val.vari_name}</option>
														</c:forEach>
													</select><br />
													<button type="button" class="btn btn-success btn-sm" onclick="fn_pre_view();"> <i class="fa fa-eye" aria-hidden="true"></i> 미리보기 </button>
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
					<div id="newAlimi" class="container-fluid tab-pane fade">
						<br>
						<div id="base">
							<div>
								<h6>* 기본내용(Base)</h6>
							</div>
							<div>
								<table
									class="table table-striped table-hover table-condensed table-bordered my_table"
									style="width: 100%;">
									<colgroup>
										<col width="15%" />
										<col width="35%" />
										<col width="15%" />
										<col width="35%" />
									</colgroup>
									<tr>
										<td class="info">알림톡 노출여부</td>
										<td class="tbtd_content" colspan="3"><input
											id='alimiShow_show' class="alimiShow" type='radio'
											name='alimiShow' value="show" /> 알림톡 노출 &nbsp;&nbsp;&nbsp; <input
											id='alimiShow_hide' class="alimiShow" type='radio'
											name='alimiShow' value="hide" /> 알림톡 미노출 &nbsp;&nbsp;&nbsp;
										</td>
									</tr>
									<tr>
										<td class="info">알림톡 방목록 텍스트</td>
										<td class="tbtd_content" colspan="3"><input
											id='alimiText' type="text" style="width: 700px;"
											name="alimiText" value="" maxlength="100" /></td>
									</tr>
									<tr>
										<td class="info">알림톡 타입</td>
										<td class="tbtd_content" colspan="3"><input
											id='alimiType_type1' class='alimiType' type='radio'
											name='alimiType' value="type1" /> 타입-1 &nbsp;&nbsp;&nbsp; <input
											id='alimiType_type2' class='alimiType' type='radio'
											name='alimiType' value="type2" /> 타입-2 &nbsp;&nbsp;&nbsp; <input
											id='alimiType_type3' class='alimiType' type='radio'
											name='alimiType' value="type3" /> 타입-3 &nbsp;&nbsp;&nbsp; <input
											id='alimiType_type4' class='alimiType' type='radio'
											name='alimiType' value="type4" /> 타입-4 &nbsp;&nbsp;&nbsp; <input
											id='alimiType_type5' class='alimiType' type='radio'
											name='alimiType' value="type5" /> 타입-5 &nbsp;&nbsp;&nbsp; <input
											id='alimiType_type6' class='alimiType' type='radio'
											name='alimiType' value="type6" /> 타입-6 &nbsp;&nbsp;&nbsp;</td>
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
									<table
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tr>
											<td class="info">소타이틀</td>
											<td colspan="3"><input type="text" id="type1_title1"
												class="type1" style="width: 700px;" name="title1" value=""
												maxlength="8" placeholder='(문자수 최대 8)' /></td>
										</tr>
										<tr>
											<td class="info">광고 표시 문구</td>
											<td colspan="3"><input type="text" id="type1_advText"
												class="type1" style="width: 700px;" name="advText" value=""
												maxlength="100" readonly /></td>
										</tr>
										<tr>
											<td class="info">메인문구</td>
											<td colspan="3"><input type="text" id="type1_title2"
												class="type1" style="width: 700px;" name="title2" value=""
												maxlength="16" placeholder='(문자수 최대 16)' /></td>
										</tr>
										<tr>
											<td class="info">서브문구 (선택입력)</td>
											<td colspan="3"><input type="text" id="type1_title3"
												class="type1" style="width: 700px;" name="title3" value=""
												maxlength="20" placeholder='(문자수 최대 20) '/></td>
										</tr>
									</table>
								</div>
							</div>
							<div id="_images-1">
								<div>
									<h6>
										* 이미지내용(Images)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<button id="img1_addItem" type="button"
											class="btn btn-primary"
											style="height: 20px; width: 50px; padding: 2px; font-size: 12px;"
											title="이미지는 최대 5개까지 등록 가능합니다.">항목추가</button>
									</h6>
									<div></div>
									<table id="img1_table"
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tbody>
											<!-- dynamic tr elements -->
										</tbody>
									</table>
								</div>
							</div>
							<div id="_footer-1">
								<div>
									<h6>* 하단내용(Footer)</h6>
								</div>
								<div>
									<table
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tr>
											<td class="info" colspan="2">하단 문구</td>
											<td colspan="2"><input type="text" id="type1_ftrText"
												class="type1" style="width: 700px;" name="ftrText" value=""
												maxlength="6" placeholder='(문자수 최대 6)' /></td>
										</tr>
										<tr>
											<td class="info" rowspan="2">상세보기</td>
											<td class="info">Mobile URL</td>
											<td colspan="2"><input type="text" id="type1_ftrMblUrl"
												class="type1" style="width: 700px;" name="ftrMblUrl"
												value="" maxlength="256" placeholder='http://' /></td>
										</tr>
										<tr>
											<td class="info">Web URL</td>
											<td colspan="2"><input type="text" id="type1_ftrWebUrl"
												class="type1" style="width: 700px;" name="ftrWebUrl"
												value="" maxlength="256" placeholder='모바일 URL 입력' /></td>
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
									<table
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tr>
											<td class="info">소타이틀</td>
											<td colspan="3"><input type="text" id="type2_title1"
												class="type2" style="width: 700px;" name="title1" value=""
												maxlength="8" placeholder='(문자수 최대 8)' /></td>
										</tr>
										<tr>
											<td class="info">광고 표시 문구</td>
											<td colspan="3"><input type="text" id="type2_advText"
												class="type2" style="width: 700px;" name="advText" value=""
												maxlength="100" readonly /></td>
										</tr>
										<tr>
											<td class="info">메인문구</td>
											<td colspan="3"><input type="text" id="type2_title2"
												class="type2" style="width: 700px;" name="title2" value=""
												maxlength="16" placeholder='(문자수 최대 16)' /></td>
										</tr>
										<tr>
											<td class="info">서브문구 (선택입력)</td>
											<td colspan="3"><input type="text" id="type2_title3"
												class="type2" style="width: 700px;" name="title3" value=""
												maxlength="20" placeholder='(문자수 최대 20)' /></td>
										</tr>
									</table>
								</div>
							</div>
							<div id="_images-2">
								<div>
									<h6>
										* 이미지내용(Images)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<!--
										<button id="img2_addItem" type="button"
											class="btn btn-primary"
											style="height: 20px; width: 50px; padding: 2px; font-size: 12px;"
											title="이미지는 최대 1개까지 등록 가능합니다.">항목추가</button>
										-->
									</h6>
								</div>
								<div>
									<table id="img2_table"
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tbody>
											<!-- dynamic tr elements -->
										</tbody>
									</table>
								</div>
							</div>
							<div id="_goods-2">
								<div>
									<h6>
										* 상품내용(Goods)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<button id="prd2_addItem" type="button"
											class="btn btn-primary"
											style="height: 20px; width: 50px; padding: 2px; font-size: 12px;"
											title="이미지는 최대 10개까지 등록 가능합니다.">항목추가</button>
									</h6>
								</div>
								<div>
									<table id="prd2_table"
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tbody>
											<!-- dynamic tr elements -->
										</tbody>
									</table>
								</div>
							</div>
							<div id="_footer-2">
								<div>
									<h6>* 하단내용(Footer)</h6>
								</div>
								<div>
									<table
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tr>
											<td class="info" colspan="2">하단 문구</td>
											<td colspan="2"><input type="text" id="type2_ftrText"
												class="type2" style="width: 700px;" name="ftrText" value=""
												maxlength="6" placeholder='(문자수 최대 6)' /></td>
										</tr>
										<tr>
											<td class="info" rowspan="2">상세보기</td>
											<td class="info">Mobile URL</td>
											<td colspan="2"><input type="text" id="type2_ftrMblUrl"
												class="type2" style="width: 700px;" name="ftrMblUrl"
												value="" maxlength="256" placeholder='http://' /></td>
										</tr>
										<tr>
											<td class="info">Web URL</td>
											<td colspan="2"><input type="text" id="type2_ftrWebUrl"
												class="type2" style="width: 700px;" name="ftrWebUrl"
												value="" maxlength="256" placeholder='모바일 URL 입력' /></td>
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
									<table
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tr>
											<td class="info">소타이틀</td>
											<td colspan="3"><input type="text" id="type3_title1"
												class="type3" style="width: 700px;" name="title1" value=""
												maxlength="8" placeholder='(문자수 최대 8)' /></td>
										</tr>
										<tr>
											<td class="info">광고 표시 문구</td>
											<td colspan="3"><input type="text" id="type3_advText"
												class="type3" style="width: 700px;" name="advText" value=""
												maxlength="100" readonly /></td>
										</tr>
										<tr>
											<td class="info">메인문구</td>
											<td colspan="3"><input type="text" id="type3_title2"
												class="type3" style="width: 700px;" name="title2" value=""
												maxlength="16" placeholder='(문자수 최대 16)' /></td>
										</tr>
										<tr>
											<td class="info">서브문구 (선택입력)</td>
											<td colspan="3"><input type="text" id="type3_title3"
												class="type3" style="width: 700px;" name="title3" value=""
												maxlength="20" placeholder='(문자수 최대 20)' /></td>
										</tr>
									</table>
								</div>
							</div>
							<div id="_images-3">
								<div>
									<h6>
										* 이미지내용(Images)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<!--
										<button id="img3_addItem" type="button"
											class="btn btn-primary"
											style="height: 20px; width: 50px; padding: 2px; font-size: 12px;"
											title="이미지는 최대 5개까지 등록 가능합니다.">항목추가</button>
										-->
									</h6>
									<div></div>
									<table id="img3_table"
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tbody>
											<!-- dynamic tr elements -->
										</tbody>
									</table>
								</div>
							</div>
							<div id="_coupons-3">
								<div>
									<h6>
										* 쿠폰내용(Coupons)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<button id="cpn3_addItem" type="button"
											class="btn btn-primary"
											style="height: 20px; width: 50px; padding: 2px; font-size: 12px;">항목추가</button>
									</h6>
								</div>
								<div>
									<table id="cpn3_table"
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tbody>
											<!-- dynamic tr elements -->
										</tbody>
									</table>
								</div>
							</div>
							<div id="_footer-3">
								<div>
									<h6>* 하단내용(Footer)</h6>
								</div>
								<div>
									<table
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tr>
											<td class="info" colspan="2">하단 문구</td>
											<td colspan="2"><input type="text" id="type3_ftrText"
												class="type3" style="width: 700px;" name="ftrText" value=""
												maxlength="6" placeholder='(문자수 최대 6)' /></td>
										</tr>
										<tr>
											<td class="info" rowspan="2">상세보기</td>
											<td class="info">Mobile URL</td>
											<td colspan="2"><input type="text" id="type3_ftrMblUrl"
												class="type3" style="width: 700px;" name="ftrMblUrl"
												value="" maxlength="256" placeholder='http://' /></td>
										</tr>
										<tr>
											<td class="info">Web URL</td>
											<td colspan="2"><input type="text" id="type3_ftrWebUrl"
												class="type3" style="width: 700px;" name="ftrWebUrl"
												value="" maxlength="256" placeholder='모바일 URL 입력' /></td>
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
									<table
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tr>
											<td class="info">소타이틀</td>
											<td colspan="3"><input type="text" id="type4_title1"
												class="type4" style="width: 700px;" name="title1" value=""
												maxlength="8" placeholder='(문자수 최대 8)' /></td>
										</tr>
										<tr>
											<td class="info">광고 표시 문구</td>
											<td colspan="3"><input type="text" id="type4_advText"
												class="type4" style="width: 700px;" name="advText" value=""
												maxlength="100" readonly /></td>
										</tr>
										<tr>
											<td class="info">메인문구</td>
											<td colspan="3"><input type="text" id="type4_title2"
												class="type4" style="width: 700px;" name="title2" value=""
												maxlength="16" placeholder='(문자수 최대 16)' /></td>
										</tr>
										<tr>
											<td class="info">서브문구 (선택입력)</td>
											<td colspan="3"><input type="text" id="type4_title3"
												class="type4" style="width: 700px;" name="title3" value=""
												maxlength="20" placeholder='(문자수 최대 20)' /></td>
										</tr>
									</table>
								</div>
							</div>
							<div id="_announce-4">
								<div>
									<h6>
										* 안내내용(Announce)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<!--
										<button id="ann4_addItem" type="button"
											class="btn btn-primary"
											style="height: 20px; width: 50px; padding: 2px; font-size: 12px;"
											title="이미지는 최대 5개까지 등록 가능합니다.">항목추가</button>
										-->
									</h6>
								</div>
								<div>
									<table id="ann4_table"
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tbody>
											<!-- dynamic tr elements -->
										</tbody>
									</table>
								</div>
							</div>
							<div id="_footer-4">
								<div>
									<h6>* 하단내용(Footer)</h6>
								</div>
								<div>
									<table
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tr>
											<td class="info" colspan="2">하단 문구</td>
											<td colspan="2"><input type="text" id="type4_ftrText"
												class="type4" style="width: 700px;" name="ftrText" value=""
												maxlength="6" placeholder='(문자수 최대 6)' /></td>
										</tr>
										<tr>
											<td class="info" rowspan="2">상세보기</td>
											<td class="info">Mobile URL</td>
											<td colspan="2"><input type="text" id="type4_ftrMblUrl"
												class="type4" style="width: 700px;" name="ftrMblUrl"
												value="" maxlength="256" placeholder='http://' /></td>
										</tr>
										<tr>
											<td class="info">Web URL</td>
											<td colspan="2"><input type="text" id="type4_ftrWebUrl"
												class="type4" style="width: 700px;" name="ftrWebUrl"
												value="" maxlength="256" placeholder='모바일 URL 입력' /></td>
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
									<table
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tr>
											<td class="info">소타이틀</td>
											<td colspan="3"><input type="text" id="type5_title1"
												class="type5" style="width: 700px;" name="title1" value=""
												maxlength="8" placeholder='(문자수 최대 8)' /></td>
										</tr>
										<tr>
											<td class="info">광고 표시 문구</td>
											<td colspan="3"><input type="text" id="type5_advText"
												class="type5" style="width: 700px;" name="advText" value=""
												maxlength="100" readonly /></td>
										</tr>
										<tr>
											<td class="info">메인문구</td>
											<td colspan="3"><input type="text" id="type5_title2"
												class="type5" style="width: 700px;" name="title2" value=""
												maxlength="16" placeholder='(문자수 최대 16)' /></td>
										</tr>
										<tr>
											<td class="info">서브문구 (선택입력)</td>
											<td colspan="3"><input type="text" id="type5_title3"
												class="type5" style="width: 700px;" name="title3" value=""
												maxlength="20" placeholder='(문자수 최대 20)' /></td>
										</tr>
									</table>
								</div>
							</div>
							<div id="_goods-5">
								<div>
									<h6>
										* 상품내용(Goods)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<button id="prd5_addItem" type="button"
											class="btn btn-primary"
											style="height: 20px; width: 50px; padding: 2px; font-size: 12px;">항목추가</button>
									</h6>
								</div>
								<div>
									<table id="prd5_table"
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tbody>
											<!-- dynamic tr elements -->
										</tbody>
									</table>
								</div>
							</div>
							<div id="_footer-5">
								<div>
									<h6>* 하단내용(Footer)</h6>
								</div>
								<div>
									<table
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tr>
											<td class="info" colspan="2">하단 문구</td>
											<td colspan="2"><input type="text" id="type5_ftrText"
												class="type5" style="width: 700px;" name="ftrText" value=""
												maxlength="6" placeholder='(문자수 최대 6)' /></td>
										</tr>
										<tr>
											<td class="info" rowspan="2">상세보기</td>
											<td class="info">Mobile URL</td>
											<td colspan="2"><input type="text" id="type5_ftrMblUrl"
												class="type5" style="width: 700px;" name="ftrMblUrl"
												value="" maxlength="256" placeholder='http://' /></td>
										</tr>
										<tr>
											<td class="info">Web URL</td>
											<td colspan="2"><input type="text" id="type5_ftrWebUrl"
												class="type5" style="width: 700px;" name="ftrWebUrl"
												value="" maxlength="256" placeholder='모바일 URL 입력' /></td>
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
									<table
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tr>
											<td class="info">소타이틀</td>
											<td colspan="3"><input type="text" id="type6_title1"
												class="type6" style="width: 700px;" name="title1" value=""
												maxlength="8" placeholder='(문자수 최대 8)' /></td>
										</tr>
										<tr>
											<td class="info">광고 표시 문구</td>
											<td colspan="3"><input type="text" id="type6_advText"
												class="type6" style="width: 700px;" name="advText" value=""
												maxlength="100" readonly /></td>
										</tr>
										<tr>
											<td class="info">메인문구</td>
											<td colspan="3"><input type="text" id="type6_title2"
												class="type6" style="width: 700px;" name="title2" value=""
												maxlength="16" placeholder='(문자수 최대 16)' /></td>
										</tr>
										<tr>
											<td class="info">서브문구 (선택입력)</td>
											<td colspan="3"><input type="text" id="type6_title3"
												class="type6" style="width: 700px;" name="title3" value=""
												maxlength="20" placeholder='(문자수 최대 20)' /></td>
										</tr>
									</table>
								</div>
							</div>
							<div id="_coupons-6">
								<div>
									<h6>
										* 쿠폰내용(Coupons)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<button id="cpn6_addItem" type="button"
											class="btn btn-primary"
											style="height: 20px; width: 50px; padding: 2px; font-size: 12px;">항목추가</button>
									</h6>
								</div>
								<div>
									<table id="cpn6_table"
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tbody>
											<!-- dynamic tr elements -->
										</tbody>
									</table>
								</div>
							</div>
							<div id="_footer-6">
								<div>
									<h6>* 하단내용(Footer)</h6>
								</div>
								<div>
									<table
										class="table table-striped table-hover table-condensed table-bordered my_table"
										style="width: 100%;">
										<colgroup>
											<col width="15%" />
											<col width="15%" />
											<col width="15%" />
											<col width="55%" />
										</colgroup>
										<tr>
											<td class="info" colspan="2">하단 문구</td>
											<td colspan="2"><input type="text" id="type6_ftrText"
												class="type6" style="width: 700px;" name="ftrText" value=""
												maxlength="6" placeholder='(문자수 최대 6)' /></td>
										</tr>
										<tr>
											<td class="info" rowspan="2">상세보기</td>
											<td class="info">Mobile URL</td>
											<td colspan="2"><input type="text" id="type6_ftrMblUrl"
												class="type6" style="width: 700px;" name="ftrMblUrl"
												value="" maxlength="256" placeholder='http://' /></td>
										</tr>
										<tr>
											<td class="info">Web URL</td>
											<td colspan="2"><input type="text" id="type6_ftrWebUrl"
												class="type6" style="width: 700px;" name="ftrWebUrl"
												value="" maxlength="256" placeholder='모바일 URL 입력' /></td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>








				<div id="sysbtn" class="col-md-12"
					style="text-align: right; margin: 10px 10px 0px 0px;">
					<!--
					<button type="button" class="btn btn-success btn-sm" onclick="fn_pre_view();"><i class="fa fa-eye" aria-hidden="true"></i> 미리보기 </button>
					-->
					<button type="button" id='copyChannel' class="btn btn-success btn-sm" onclick="fn_copyChannel();"><i class="fa fa-copy" aria-hidden="true"></i> 채널복사 </button> <!-- KANG-20200413 -->
					<button type="button" id='alimiTestSend' class="btn btn-success btn-sm" onclick="fn_alimiTestSend();"><i class="fa fa-eye" aria-hidden="true"></i> 알리미 테스트 발송 </button>
					<button type="button" class="btn btn-danger btn-sm" onclick="fn_save();"> <i class="fa fa-floppy-o" aria-hidden="true"></i> 저장 </button>
					<button type="button" class="btn btn-default btn-sm" onclick="fn_close();"> <i class="fa fa-times" aria-hidden="true"></i> 닫기 </button>
				</div>
				<p/><p/><p/>







				<div id="wrapA"
					style="position: fixed; display: none; left: 25%; top: 100px; width: 563px; background-color: #ffffff;">
					<div style="background-color: #CDCDCD; border: 1px solid #ffffff;">
						<a href="javascript:fn_pre_viewClose();" class="bt"> <img
							width="30" height="30"
							style="padding: 0px; border: 0px; margin-left: 95%;" alt="닫기"
							src="<c:url value='/image/btn/x_button.png'/>">
						</a>
					</div>
					<!-- contents -->
					<section id="cts">
						<h1 class="top_tit">
							<a href="#">알리미</a>
						</h1>
						<ul id="myAlimi" class="my_alimi">
							<li class="app">
								<div class="al_title btn_oc">
									<!-- 제목 -->
									<h2 class="tit">
										<span id="mo_title"></span>
									</h2>
								</div>
								<div class="alimi_con"
									style="background-color: #ffffff; height: 470px;">
									<div class="al_html"
										style="background-color: #ffffff; width: 100%; height: 470px; overflow-y: scroll; float: left; font-size: 12px; line-height: 15px; white-space: nowrap;">
										<!-- 알림내용 -->
										<span id="mo_content"></span>
										<!-- 추가텍스트 -->
										<span id="mo_addText"></span>
									</div>
								</div> <a href="#" class="btn_amore btn_oc">더보기</a>
							</li>
						</ul>
					</section>
				</div>




			</form>
		</div>
	</div>
</div>
<!--PAGE CONTENT END -->

<div style="visibility: hidden; background-color: #e00; height: 10px;"></div>
<!-- visibility: hidden/visible -->
