<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_pop.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>

<script type="text/javascript">
	// execute first on this jsp
	window.resizeTo(1060,450);
	/* ready */
	$(document).ready(function() {
		if (true) console.log("/offer/offerPTPoint.jsp: document.ready();");
		//document.body.scrollIntoView(true);
		//parent.document.all.offerAddFrame.height = document.body.scrollHeight;
		//opener.fn_setIFrameHeight('offer');
	});


	/* 등록 */
	function fn_save() {
		//유효성 체크
		if (!fn_validation()) {
			return;
		}
		if (!confirm("저장 하시겠습니까?")) {
			return;
		}
		var campaignid = $("#CampaignId").val();
		jQuery.ajax({
			url           : '${staticPATH }/setOfferPn.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
			data          : $("#form").serialize(),
			success: function(result, option) {
				if (option == "success") {
					if (result.CMP_STATUS == "START") {
						alert("진행중인 캠페인은 수정할수 없습니다.");
					} else {
						alert("저장되었습니다");
						//부모창 재조회
						//opener.location.reload();
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
		if ("${bo.camp_status_cd}" == "START") {
			$("#btn_save").hide();
			alert("진행중인 캠페인은 수정할수 없습니다.");
			return false;
		}
		if ($("#DISP_NAME").val() == "") {
			alert("노출명을 입력하세요");
			$("#DISP_NAME").focus();
			return false;
		}
		if ($("#OFFER_AMT").val() == "") {
			if ("${bo.offer_type_cd}" == "PN" || "${bo.offer_type_cd}" == "PT" || "${bo.offer_type_cd}" == "OC" ) {
				alert("포인트를 입력하세요");
				$("#OFFER_AMT").focus();
			} else if ("${bo.offer_type_cd}" == "MI") {
				alert("마일리지를 입력하세요");
				$("#OFFER_AMT").focus();
			} else if ("${bo.offer_type_cd}" == "DP") {
				alert("할인금액을 입력하세요");
				$("#OFFER_AMT").focus();
			}
			return false;
		}
		return true;
	}


	//창닫기
	function fn_close() {
		//창닫기
		window.close();
	}

</script>







<!--PAGE CONTENT -->
<div id="content" style="width:100%; height100%;">
	<!--BLOCK SECTION -->
	<div class="row" style="width:100%; height100%;">
		<div class="col-lg-1"></div>
		<div class="col-lg-10">
			<div class="col-md-6">
				<h3>오퍼 상세 정보(${bo.offer_sys_cd} ${bo.offer_type_cd})..</h3>
			</div>
			<form name="form" id="form">
				<input type="hidden" id="CampaignId" name="CampaignId" value="${CAMPAIGNID}" />
				<input type="hidden" id="CELLID" name="CELLID" value="${bo.cellid}" />
				<input type="hidden" id="OFFERID" name="OFFERID" value="${bo.offerlistid}" />
				<input type="hidden" id="OFFER_TYPE_CD" name="OFFER_TYPE_CD" value="${bo.offer_type_cd}" />
				<input type="hidden" id="OFFER_SYS_CD" name="OFFER_SYS_CD" value="${bo.offer_sys_cd}" />
				<input type="hidden" id="CAMPAIGNCODE" name="CAMPAIGNCODE" value="${bo.campaigncode}" />
				<input type="hidden" id="FLOWCHARTID" name="FLOWCHARTID" value="${bo.flowchartid}" />
				<div class="col-lg-12" id="table">
					<table class="table table-striped table-hover table-condensed table-bordered" style="width:100%; border-spacing:0px; border-collapse:collapse;">
						<colgroup>
							<col width="130"/>
							<col width="250"/>
							<col width="130"/>
							<col width=""/>
						</colgroup>
						<tr>
							<td class="info">캠페인 코드/명</td>
							<td class="tbtd_content" colspan="3">[${bo.campaigncode}] ${bo.campaignname}</td>
							<%-- <td class="info">플로차트 이름</td
							<td class="tbtd_content">${bo.flowchartname}</td> --%>
						</tr>
						<tr>
							<td class="info">오퍼 종류</td>
							<td class="tbtd_content">${bo.offername}</td>
							<td class="info">고객 세그먼트</td>
							<td class="tbtd_content">${bo.cellname}</td>
						</tr>
						<tr>
							<td class="info">노출명</td>
							<td class="tbtd_content" colspan="3"><input type="text" id="DISP_NAME" name="DISP_NAME" style="width: 400px;" value="${bo.disp_name}" maxlength="30" class="txt"/></td>
						</tr>
						<tr>
							<td class="info">
								<c:if test="${bo.offer_type_cd eq 'OC' }">
									캐쉬백
								</c:if>
								<c:if test="${bo.offer_type_cd eq 'PN' }">
									포인트
								</c:if>
								<c:if test="${bo.offer_type_cd eq 'PT' }">
									11페이포인트
								</c:if>
								<c:if test="${bo.offer_type_cd eq 'MI' }">
									금액
								</c:if>
								<c:if test="${bo.offer_type_cd eq 'DP' }">
									즉시할인
								</c:if>
							</td>
							<td class="tbtd_content" colspan="3">
								<input type="text" id="OFFER_AMT" name="OFFER_AMT"	onkeydown="javascript:keypressNumber();" style="width: 65px;" value="${bo.offer_amt}" maxlength="10" class="txt"/>
								<c:if test="${bo.offer_type_cd eq 'PN' }">
									P
								</c:if>
								<c:if test="${bo.offer_type_cd eq 'PT' }">
									P
								</c:if>
								<c:if test="${bo.offer_type_cd eq 'MI' }">
									M
								</c:if>
								<c:if test="${bo.offer_type_cd eq 'OC' }">
									C
								</c:if>
								<c:if test="${bo.offer_type_cd eq 'DP' }">
									원
								</c:if>
							</td>
						</tr>
						<c:if test="${bo.offer_type_cd eq 'DP' }">
							<tr>
								<td class="info">
									개인별 오퍼적용
								</td>
								<td class="tbtd_content">
									<select id="OFFER_APLY_CD" name="OFFER_APLY_CD">
										<c:forEach var="val" items="${offerAplyCdList}">
											<option value="${val.code_id}" <c:if test="${val.code_id eq bo.offer_aply_cd}">selected="selected"</c:if>>
												${val.code_name}
											</option>
										</c:forEach>
									</select>
								</td>
								<td class="info">
									추천상품정보
								</td>
								<td class="tbtd_content">
									<select id="PROD_RECOM_CD" name="PROD_RECOM_CD">
										<option value=""> :: 선택 하세요 :: </option>
										<c:forEach var="val" items="${prodRecomCdList}">
											<option value="${val.code_id}" <c:if test="${val.code_id eq bo.prod_recom_cd}">selected="selected"</c:if>>
												${val.code_name}
											</option>
										</c:forEach>
									</select>
								</td>
							</tr>
						</c:if>
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
					<button type="button" class="btn btn-danger btn-sm" onclick="fn_save();"><i class="fa fa-floppy-o" aria-hidden="true"></i> 저장</button>
					<button type="button" class="btn btn-success btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i> 닫기</button>
				</div>
				<div class="col-lg-1"></div>
			</form>
		</div>
		<!--END BLOCK SECTION -->
		<div class="col-lg-3"></div>
	</div>
<!--END PAGE CONTENT -->
</div>


