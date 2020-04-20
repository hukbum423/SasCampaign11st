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

<script>
	// 창열리고 처리
	$(document).ready(function(){
		window.resizeTo(1080,330);
		//채널선택시 페이지 이동
		$("#CHANNEL_CD").bind("change", fn_selectChannel);
	});

	//창닫기
	function fn_close(){
		window.close();
	}

	//채널 선택
	function fn_selectChannel(){
		var form = document.form;

		if($("#CHANNEL_CD").val() == "SMS"){
			form.action = "${staticPATH }/channel/channelSms.do";
			form.submit();
		}

		if($("#CHANNEL_CD").val() == "EMAIL"){
			form.action = "${staticPATH }/channel/channelEmail.do";
			form.submit();
		}

		if($("#CHANNEL_CD").val() == "TOAST"){
			form.action = "${staticPATH }/channel/channelToast.do";
			form.submit();
		}

		if($("#CHANNEL_CD").val() == "MOBILE"){
			form.action = "${staticPATH }/channel/channelMobile.do";
			form.submit();
		}
		if($("#CHANNEL_CD").val() == "LMS"){
			form.action = "${staticPATH }/channel/channelLms.do";
			form.submit();
		}
	}
</script>


<form name="form" id="form">
<input type="hidden" id="CampaignId" name="CampaignId" value="${bo.campaignid}" />
<input type="hidden" id="CELLID" name="CELLID" value="${bo.cellid}" />
<input type="hidden" id="COPYCHANNEL" name="COPYCHANNEL" value="YES" />

 <!--PAGE CONTENT -->
		<div id="content" style="width:100%; height100%;">
			<!--BLOCK SECTION -->
			<div class="row" style="width:100%; height100%;">
				<div class="col-lg-1"></div>
				<div class="col-lg-10">
					<div class="col-md-12" style="margin-top:0px;">
						<h3>채널 상세 정보</h3>
					</div>
					<div id="table">
						<table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="130"/>
								<col width="250"/>
								<col width="130"/>
								<col width=""/>
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
									<select id="CHANNEL_CD" name="CHANNEL_CD"  style="width:125px;">
										<option value="">선택하세요</option>
										<c:forEach var="val" items="${channel_list}">

											<!--미네 주석 대상수준이 PCID일경우TOAST채널만 사용가능
											<c:if test="${bo.audience_cd == 'PCID' && val.code_id == 'TOAST'}">
												<option value="${val.code_id}">
													${val.code_name}
												</option>
											</c:if> -->

											<!--미네 주석 대상수준이 DEVICEID일경우 모바일 알리미 채널만 사용가능
											<c:if test="${bo.audience_cd == 'DEVICE_ID' && val.code_id == 'MOBILE'}">
												<option value="${val.code_id}">
													${val.code_name}
												</option>
											</c:if> -->

											<!--미네 주석 <c:if test="${bo.audience_cd == 'MEM_NO'}">
												<option value="${val.code_id}">
													${val.code_name}
												</option>
											</c:if>-->
											<option value="${val.code_id}">
													${val.code_name}
												</option>
										</c:forEach>
									</select>
								</td>
								<td class="info">고객세그먼트</td>
								<td class="tbtd_content">${bo.cellname}</td>
							</tr>
						</table>
					</div>
					<div id="sysbtn" class="col-md-12" style="text-align:right;margin-bottom:10px;">
						<button type="button" class="btn btn-default btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i>Close</button>
					</div>
				</div>
				<div class="col-lg-1"></div>
			</div>
			<!--END BLOCK SECTION -->
			<div class="col-lg-3"></div>
		</div>
		<!--END PAGE CONTENT -->

</form>

 <!--END PAGE CONTENT -->

