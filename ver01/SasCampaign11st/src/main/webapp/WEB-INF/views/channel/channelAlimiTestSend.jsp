<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_pop.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<link rel="stylesheet" href="${staticPATH }/css/default_h5.css" />


<!-- END PAGE LEVEL  STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>

<link href="${staticPATH }/css/jquery_1.9.2/base/jquery-ui-1.9.2.custom.css" rel="stylesheet">
<script src="${staticPATH }/js/jquery_1.9.2/jquery-1.8.3.js"></script>
<script src="${staticPATH }/js/jquery_1.9.2/jquery-ui-1.9.2.custom.js"></script>

<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>
<script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script>

<script>
	// POPUP 화면크기
	window.resizeTo(1000, 910);

	$(document).ready(function() {
		return;
		
		$("#downBtn, #closeToday, #closeBtn ").bind("click",fn_pre_viewClose);
		/*
		if ("${bo.channel_priority_yn}" == "N" && "${user.title}" != "N") {
			alert("해당캠페인은 채널우선순위적용이 [N]입니다\n사용자는 권한이 없으므로 채널정보를 입력할수 없습니다");
		}
		*/
		$("#VAL_LIST").dblclick(function() {
			$("#TOAST_INPUT_MSG").focus();
			if (document.selection) {
				Range = document.selection.createRange();
				Range.text = "{" + $("#VAL_LIST").val() + "}";
			} else {
				$("#TOAST_INPUT_MSG").val($("#TOAST_INPUT_MSG").val() + "{" + $("#VAL_LIST").val() + "}");
			}
		});
		//채널선택시 페이지 이동
		$("#CHANNEL_CD").bind("change",fn_selectChannel);
		//이벤트 타입 선택시 링크URL 변경 (토스트 배너일때는 고정값으로 변경[김태욱 매너저 2013-11-22])
		//$("#TOAST_EVNT_TYP_CD").bind("change",fn_selectLinkUlr);
		//대상수준이 PCID일 경우 이벤트 타입에 따른 링크URL 값 변경
		if ("${bo.audience_cd}" == "PCID") {
			$("#TOAST_EVNT_TYP_CD").bind("change",fn_chg_linkUrl);
		}
		if ("${bo.audience_cd}" == "PCID" && "${bo.toast_link_url}" == '' ) {
			fn_chg_linkUrl();
		}
	});




	/* 유효성 체크 */
	function fn_validation() {
		if ("${bo.camp_status_cd}" == "START") {
			$("#btn_save").hide();
			alert("진행중인 캠페인은 수정할수 없습니다.");
			return false;
		}
		/*
		if ("${bo.channel_priority_yn}" == "N" && "${user.title}" != "N") {
			alert("해당캠페인은 채널우선순위적용이 [N]입니다\n사용자는 권한이 없으므로 채널정보를 입력할수 없습니다");
			return false;
		}
		*/

		if ($("#TOAST_TITLE").val() =="") {
			alert("토스트배너 타이틀을 입력하세요");
			$("#TOAST_TITLE").focus();
			return false;
		}

		if ($("#TOAST_INPUT_MSG").val() =="") {
			alert("메세지를 입력하세요");
			$("#TOAST_INPUT_MSG").focus();
			return false;
		}

		if ($("#TOAST_LINK_URL").val() =="") {
			alert("링크URL을 입력하세요");
			$("#TOAST_LINK_URL").focus();
			return false;
		}

		return true;
	}


	//미리보기
	function fn_pre_view() {
		if ($("#TOAST_TITLE").val() =="") {
			alert("토스트배너 타이틀을 입력하세요");
			$("#TOAST_TITLE").focus();
			return;
		}

		if ($("#TOAST_INPUT_MSG").val() =="") {
			alert("메세지를 입력하세요");
			$("#TOAST_INPUT_MSG").focus();
			return;
		}

		jQuery.ajax({
			url           : '${staticPATH }/channel/channelToastPreview.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
			data          : $("#form").serialize(),
			success: function(result, option) {
				if (option == "success") {
					//사용자변수 적용된 미리보기
					$("#to_title").html("<strong style='font-size:15px;'>" + $("#TOAST_TITLE").val() + "</strong>");
					/*
						$("#toastContWrap").html(
								'<span class="ADtxt_banner_wrap">'+
								'<span class="adtxtW">'+
								'<span class="userW">'+
								result.TOAST_INPUT_MSG +
							'</span>'+
							'</span>'+
							'<a href="'+ $("#TOAST_LINK_URL").val() + '" target="_blank" class="bnr">'+
							'<img src='+ $("#TOAST_IMG_URL").val() +">" +
							'</a>'+
							'</span>'+
							''
						);
					*/
					$("#toastContWrap").html(
							//'<div class="toast_inner">'+
							'<div>'+
							result.TOAST_INPUT_MSG+
							'</div>'+
							'<a href="'+ $("#TOAST_LINK_URL").val() + '" target="_blank">'+
							'<img src="'+ $("#TOAST_IMG_URL").val() +'" alt="">'+
							'</a>'+
							//'</div>'+
							''
					);
					//$("#toastBannerWrap").slideToggle(1);
					$(".txtW").width(262);
					$("#toastBannerWrap").show();
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
			$('#DETAIL_URL').val("detail url(?)");
			$('#BANNER_URL').val("banner url(?)");
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


	//창닫기
	function fn_close() {
		//창닫기
		window.close();
	}


	/* 발송 */
	function fn_send() {
		if (true) console.log("KANG: fn_send():");

		if (!confirm("발송 하시겠습니까?")) {
			return;
		}

		if (true) {
			$("#_TARGET_LIST").val($("#TARGET_LIST").val());
			$("#_SERVER_TYPE").val($("#SERVER_TYPE").val());
			$("#_TALK_MSG_TEMP_NO").val($("#TALK_MSG_TEMP_NO").val());
			$("#_TALK_DISP_YN").val($("#TALK_DISP_YN").val());
			$("#_IOS_MSG").val($("#IOS_MSG").val());
			$("#_AND_TOP_MSG").val($("#AND_TOP_MSG").val());
			$("#_AND_BTM_MSG").val($("#AND_BTM_MSG").val());
			$("#_DETAIL_URL").val($("#DETAIL_URL").val());
			$("#_BANNER_URL").val($("#BANNER_URL").val());
			$("#_ETC_DATA").val($("#ETC_DATA").val());
			$("#_TALK_SUMMARY_MSG").val($("#TALK_SUMMARY_MSG").val());
			$("#_ALIMI_MESSAGE").val($("#ALIMI_MESSAGE").val());
			$("#_SEND_DATETIME").val($("#SEND_DATETIME").val());

			console.log("KANG.TARGET_LIST        : " + $("#_TARGET_LIST").val());
			console.log("KANG.SERVER_TYPE        : " + $("#_SERVER_TYPE").val());
			console.log("KANG.TALK_MSG_TEMP_NO   : " + $("#_TALK_MSG_TEMP_NO").val());
			console.log("KANG.TALK_DISP_YN       : " + $("#_TALK_DISP_YN").val());
			console.log("KANG.IOS_MSG            : " + $("#_IOS_MSG").val());
			console.log("KANG.AND_TOP_MSG        : " + $("#_AND_TOP_MSG").val());
			console.log("KANG.AND_BTM_MSG        : " + $("#_AND_BTM_MSG").val());
			console.log("KANG.DETAIL_URL         : " + $("#_DETAIL_URL").val());
			console.log("KANG.BANNER_URL         : " + $("#_BANNER_URL").val());
			console.log("KANG.ETC_DATA           : " + $("#_ETC_DATA").val());
			console.log("KANG.TALK_SUMMARY_MSG   : " + $("#_TALK_SUMMARY_MSG").val());
			console.log("KANG.ALIMI_MESSAGE      : " + $("#_ALIMI_MESSAGE").val());
			console.log("KANG.SEND_DATETIME      : " + $("#_SEND_DATETIME").val());
		}

		jQuery.ajax({
			url           : '${staticPATH }/sendChannelAlimiTest.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
			data          : $("#form").serialize(),
			success: function(result, option) {
				if (option == "success") {
					alert("발송하였습니다. RET=" + result.RET);
				} else {
					alert("에러가 발생하였습니다. RET=" + result.RET);
				}
				fn_close();
			},
			error: function(result, option) {
				alert("에러가 발생하였습니다.");
				fn_close();
			}
		});

		return;
	}
</script>
<form name="form" id="form">
	<input type="hidden" id="_TARGET_LIST" name="TARGET_LIST" value="" />
	<input type="hidden" id="_SERVER_TYPE" name="SERVER_TYPE" value="" />
	<input type="hidden" id="_TALK_MSG_TEMP_NO" name="TALK_MSG_TEMP_NO" value="" />
	<input type="hidden" id="_TALK_DISP_YN" name="TALK_DISP_YN" value="" />
	<input type="hidden" id="_IOS_MSG" name="IOS_MSG" value="" />
	<input type="hidden" id="_AND_TOP_MSG" name="AND_TOP_MSG" value="" />
	<input type="hidden" id="_AND_BTM_MSG" name="AND_BTM_MSG" value="" />
	<input type="hidden" id="_DETAIL_URL" name="DETAIL_URL" value="" />
	<input type="hidden" id="_BANNER_URL" name="BANNER_URL" value="" />
	<input type="hidden" id="_ETC_DATA" name="ETC_DATA" value="" />
	<input type="hidden" id="_TALK_SUMMARY_MSG" name="TALK_SUMMARY_MSG" value="" />
	<input type="hidden" id="_ALIMI_MESSAGE" name="ALIMI_MESSAGE" value="" />
	<input type="hidden" id="_SEND_DATETIME" name="SEND_DATETIME" value="" />
</form>








<!--PAGE CONTENT -->
<div id="content" style="width:100%; height100%;">
	<!--BLOCK SECTION -->
	<div class="row" style="width:100%; height100%;">
		<div class="col-lg-1"></div>
		<div class="col-lg-10">
			<div class="col-md-12 page-header" style="margin-top:0px;">
				<h3>알리미 테스트 발송</h3>
			</div>

			<div class="col-lg-12" id="table">
				<!-- 발송 대상 선정 -->
				<div>
					<h6>* 발송 대상 선정</h6>
				</div>
				<table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="20%"/>
						<col width="30%"/>
						<col width="50%"/>
					</colgroup>
					<tr>
						<td class="info">발송 대상 선정</td>
						<td class="tbtd_content">
							<select id="TARGET_LIST" name="TARGET_LIST" style="width: 200px;">
								<c:forEach var="val" items="${testTargetList}">
									<option value="${val.mem_no}">${val.name}(${val.mem_no}) </option>
								</c:forEach>
							</select>
						</td>
						<td class="tbtd_content">${bo.cellname}</td>
					</tr>
				</table>
				<!-- 알리미 전송 정보 -->
				<div>
					<h6>* 알리미 전송 정보(수정불가능. 확인용)</h6>
				</div>
				<div style="padding-top: 5px;">
					<table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
						<colgroup>
							<col width="20%"/>
							<col width="70%"/>
						</colgroup>
						<tr>
							<td class="info">Server Type</td>
							<td class="tbtd_content">
								<input type="text" class="txt" id="SERVER_TYPE" name="SERVER_TYPE" style="width: 200px;" maxlength="50" value="${SERVER_TYPE}" readonly />
							</td>
						</tr>
						<tr>
							<td class="info">Talk Msg Temp No</td>
							<td class="tbtd_content">
								<input type="text" class="txt" id="TALK_MSG_TEMP_NO" name="TALK_MSG_TEMP_NO" style="width: 200px;" maxlength="50" value="${TALK_MSG_TEMP_NO}" readonly />
							</td>
						</tr>
						<tr>
							<td class="info">Talk Disp YN</td>
							<td class="tbtd_content">
								<input type="text" class="txt" id="TALK_DISP_YN" name="TALK_DISP_YN" style="width: 200px;" maxlength="50" value="${TALK_DISP_YN}" readonly />
							</td>
						</tr>
						<tr>
							<td class="info">IOS MSG</td>
							<td class="tbtd_content">
								<textarea id="IOS_MSG" name="IOS_MSG"rows="2" cols="95" readonly>${IOS_MSG}</textarea>
							</td>
						</tr>
						<tr>
							<td class="info">AND TOP MSG</td>
							<td class="tbtd_content">
								<input type="text" class="txt" id="AND_TOP_MSG" name="AND_TOP_MSG" style="width: 700px;" maxlength="500" value="${AND_TOP_MSG}" readonly />
							</td>
						</tr>
						<tr>
							<td class="info">AND BTM MSG</td>
							<td class="tbtd_content">
								<input type="text" class="txt" id="AND_BTM_MSG" name="AND_BTM_MSG" style="width: 700px;" maxlength="500" value="${AND_BTM_MSG}" readonly />
							</td>
						</tr>
						<tr>
							<td class="info">Detail URL</td>
							<td class="tbtd_content">
								<input type="text" class="txt" id="DETAIL_URL" name="DETAIL_URL" style="width: 700px;" maxlength="500" value="${DETAIL_URL}" readonly />
							</td>
						</tr>
						<tr>
							<td class="info">Banner URL</td>
							<td class="tbtd_content">
								<input type="text" class="txt" id="BANNER_URL" name="BANNER_URL" style="width: 700px;" maxlength="500" value="${BANNER_URL}" readonly />
							</td>
						</tr>
						<tr>
							<td class="info">Etc Data</td>
							<td class="tbtd_content">
								<input type="text" class="txt" id="ETC_DATA" name="ETC_DATA" style="width: 700px;" maxlength="500" value="${ETC_DATA}" readonly />
							</td>
						</tr>
						<tr>
							<td class="info">Talk Summary Msg</td>
							<td class="tbtd_content">
								<input type="text" class="txt" id="TALK_SUMMARY_MSG" name="TALK_SUMMARY_MSG" style="width: 700px;" maxlength="500" value="${TALK_SUMMARY_MSG}" readonly />
							</td>
						</tr>
						<tr>
							<td class="info">Alimi Message</td>
							<td class="tbtd_content">
								<textarea id="ALIMI_MESSAGE" name="ALIMI_MESSAGE"rows="5" cols="95" readonly>${ALIMI_MESSAGE}</textarea>
							</td>
						</tr>
						<tr>
							<td class="info">Send DateTime</td>
							<td class="tbtd_content">
								<input type="text" class="txt" id="SEND_DATETIME" name="SEND_DATETIME" style="width: 200px;" maxlength="50" value="${SEND_DATETIME}" readonly />
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div id="sysbtn" class="col-md-12" style="text-align:right;margin-bottom:10px;">
				<button type="button" class="btn btn-danger btn-sm" onclick="fn_send();"><i class="fa fa-floppy-o" aria-hidden="true"></i> 발송 </button>
				<button type="button" class="btn btn-default btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i> 닫기 </button>
			</div>
		</div>
	</div>
	<!--/BLOCK SECTION -->
</div>
<!--/PAGE CONTENT -->



</body>
</html>
