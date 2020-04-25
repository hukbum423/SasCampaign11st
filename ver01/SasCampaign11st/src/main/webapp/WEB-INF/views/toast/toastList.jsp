<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="${staticPATH }/css/ui-lightness/jquery-ui.css">
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>



<script>
	// =================================================
	// ready
	$(document).ready(function() {
		// 화면타이틀값 : 메뉴명칭
		if (window.location != window.parent.location) { //iframe일경우에만
			parent.setPageTitle("토스트 배너 관리",null);

			// Tab 메뉴
			// Step1 메뉴에 url 생성 후 변경 필요함.
			var tablist = "";
			tablist += "<li class=selected><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/toastList.do'>토스트 배너 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/testTargetList.do'>테스트 대상 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/variableList.do'>매개변수 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/commCodeList.do'>공통코드 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/tableInfoList.do'>테이블 정보 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/noticeList.do'>공지사항 관리</a></li>";
			top.setNewTabList(tablist);

			parent.document.getElementById('gwt-uid-2').innerHTML='<a href="/Campaign/logout.do"><font color="#E8DB6B" bold style={text-decoration:none;}>로그아웃</a>';
		}
		$( "#SDISP_BGN_DY" ).datepicker(dateOption);
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; margin-bottom:-2px; vertical-align:middle;");
		//조회
		fn_search();
	});


	// =================================================
	// 유효성 체크
	function fn_validation() {
		if ("${bo.channel_priority_yn}" == "N" && "${user.title}" != "N") {
			alert("해당캠페인은 채널우선순위적용이 [N]입니다\n사용자는 권한이 없으므로 채널정보를 입력할수 없습니다");
			return false;
		}
		if ($("#TOAST_TITLE").val() == "") {
			alert("토스트배너 타이틀을 입력하세요");
			$("#TOAST_TITLE").focus();
			return false;
		}
		if ($("#TOAST_INPUT_MSG").val() == "") {
			alert("메세지를 입력하세요");
			$("#TOAST_INPUT_MSG").focus();
			return false;
		}
		if ($("#TOAST_LINK_URL").val() == "") {
			alert("링크URL을 입력하세요");
			$("#TOAST_LINK_URL").focus();
			return false;
		}
		return true;
	}


	// =================================================
	// 조회
	function fn_search() {
		if (true) console.log(">>>>> KANG-20200421: fn_search: ");
		jQuery.ajax({
			url           : '${staticPATH }/toast/getToastList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
			data          : {
				SCAMPAIGNCODE     : $("#SCAMPAIGNCODE").val(),
				SDISP_BGN_DY      : $("#SDISP_BGN_DY").val(),
				selectPageNo      : $("#selectPageNo").val()
			},
			success: function(result, option) {
				if (option == "success") {
					var list = result.ToastList;
					$("#LIST_LENGTH").val(list.length);
					var txt ="";
					txt += '<table class="table table-striped table-hover table-condensed table-bordered" width="100%">';
					if (list.length > 0) {
						txt += "<colgroup>";
						txt += '<col width="5%">';
						txt += '<col width="25%">';
						txt += '<col width="11%">';
						txt += '<col width="15%">';
						txt += '<col width="10%">';
						txt += '<col width="22%">';
						txt += '<col width="6%">';
						txt += '<col width="6%">';
						txt += "</colgroup>";

						txt += '<tr class="info">';
						txt += '<th class="text-center">No</th>';
						txt += '<th class="text-center">캠페인 명</th>';
						txt += '<th class="text-center">TR코드</th>';
						txt += '<th class="text-center">노출일</th>';
						txt += '<th class="text-center">세그먼트</th>';
						txt += '<th class="text-center">타이틀</th>';
						txt += '<th class="text-center">사용여부</th>';
						txt += '<th class="text-center">반영여부</th>';
						txt += '</tr>';

						$.each(list, function(key) {
							var data = list[key];
							var campaigncode = "(" + nvl(data.campaigncode,'') + ") " + nvl(data.campaignname,'');

							txt += "<tr>";
							txt += "<td align=\"center\" >" + data.num + "</td>";
							if (campaigncode.length>30) {
								txt += "<td align=\"left\"  title=\""+campaigncode+"\">"+campaigncode.substr(0,30)+"...</td>";
							} else {
								txt += "<td align=\"left\"  title=\""+campaigncode+"\">"+campaigncode+"</td>";
							}
							txt += "<td align=\"center\" ><a href=\"javascript:fn_getDetail('"+data.campaign_mang_code+"');\" class=\"link\">"+nvl(data.campaign_mang_code,'')+"</a></td>";
							txt += "<td align=\"center\" >"+nvl(data.disp_bgn_dy,'')+" ~ " +nvl(data.disp_end_dy,'')+ "</td>";
							txt += "<td align=\"left\"  title='"+nvl(data.cellnm,'')+"'>"+nvl(data.cellnm,'').cut(20)+"</td>";
							txt += "<td align=\"left\" >"+nvl(data.title,'').cut(30)+"</td>";
							txt += "<td align=\"center\" >"+nvl(data.use_yn,'')+"</td>";
							txt += "<td align=\"center\" >"+nvl(data.sync_yn,'')+"</td>";
							txt += "</tr>";
						});
					} else {
						txt += "<tr><td align=\"center\" colspan=\"\8\">데이터가 없습니다.</td></tr>";
						for (var i=1; i < result.rowRange; i++) {
							txt +="<tr'>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							// txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							// txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="</tr>";
						}
					}
					//빈 row 채우기
					if (list.length > 0 && list.length < result.rowRange ) {
						for (var i=list.length; i < result.rowRange; i++) {
							txt +="<tr'>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							// txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							// txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="</tr>";
						}
					}
					txt += "</table>";
					if (true) console.log(txt);
					$("#search_layer").html(txt);

					//페이징 처리 시작!!
					var page = pagingNavi(result.selectPage, result.pageRange, result.pageStart, result.pageEnd, result.totalPage);
					$("#paging_layer").html(page);
					//페이징 처리 종료
				} else {
					alert("에러가 발생하였습니다.");
				}
			},
			error: function(result, option) {
				alert("에러가 발생하였습니다.");
			}
		});
	};


	// =================================================
	// 페이지 이동
	function fn_pageMove(selectPageNo) {
		$("#selectPageNo").val(selectPageNo);
		fn_search();
	}


	// =================================================
	// 토스트 배너 상세보기
	function fn_getDetail(campaign_mang_code) {
		var frm = document.form;
		$("#CAMPAIGN_MANG_CODE").val(campaign_mang_code);
		frm.action = "${staticPATH }/toast/toastDetail.do";
		frm.submit();
	}
</script>



	<!--PAGE CONTENT -->
	<div id="content" style="width:100%; height100%;">
		<!--BLOCK SECTION -->
		<div class="row" style="width:100%; height100%;">
			<div class="col-lg-1"></div>
			<div class="col-lg-10">
				<div id="optionDiv" class="col-md-12" style="margin-top:15px;margin-right:0px;padding-right:0px;">
					<div style="display:flex">
						<div style="flex-basis: 100%;">
							<ul id="myTab" class="nav nav-tabs" role="tablist">
								<li role="presentation" class="active">
									<a href="${staticPATH }/toast/toastList.do">
										<i class="fa fa-info"></i> 토스트배너 관리
									</a>
								</li>
								<li role="presentation" class="">
									<a href="${staticPATH }/testTarget/testTargetList.do" >
										<!-- i class="fa fa-cog" aria-hidden="true"></i> 테스트대상 관리 -->
										<i class="fa fa-cog"></i> 테스트대상 관리
									</a>
								</li>
								<li role="presentation" class="">
									<a href="${staticPATH }/variable/variableList.do">
										<i class="fa fa-filter"></i> 매개변수 관리
									</a>
								</li>
								<li role="presentation" class="">
									<a href="${staticPATH }/commCode/commCodeList.do">
										<i class="fa fa-comments-o"></i> 공통코드 관리
									</a>
								</li>
								<%--
								<li role="presentation" class="">
									<a href="${staticPATH }/tableInfo/tableInfoList.do">
										<i class="fa fa-calendar"></i> 테이블정보 관리
									</a>
								</li>
								--%>
								<li role="presentation" class="">
									<a href="${staticPATH }/notice/noticeList.do">
										<i class="fa fa-calendar"></i> 공지사항 관리
									</a>
								</li>
							</ul>
						</div>
						<div class="push-right" style="flex-basis: 400px;"></div>
					</div>
					<div id="myTabContent" class="tab-content">

<form name="form" id="form" method="post">
<input type="hidden" id="selectPageNo" name="selectPageNo"  value="${selectPageNo}" />
<input type="hidden" id="CAMPAIGN_MANG_CODE" name="CAMPAIGN_MANG_CODE"  value="" />

						<div class="col-lg-12" id="table">
							<table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="10%"/>
									<col width="25%"/>
									<col width="10%"/>
									<col width="25%"/>
									<col width="40%"/>
								</colgroup>
								<tr>
									<td class="info">캠페인 코드</td>
									<td>
										<input type="text" id="SCAMPAIGNCODE" name="SCAMPAIGNCODE" value="${SCAMPAIGNCODE}" style="width:220px;"/>
									</td>
									<td class="info">노출일</td>
									<td>
										<input type="text" id="SDISP_BGN_DY" name="SDISP_BGN_DY" value="${SDISP_BGN_DY}" style="width:80px;" value="" readonly="readonly" />
									</td>
									<td style="text-align:right;">
										<button type="button" class="btn btn-success btn-sm" onclick="fn_search();"><i class="fa fa-search" aria-hidden="true"></i> 조 회 </button>
									</td>
								</tr>
							</table>
						</div>

						<!-- List -->
						<div class="col-lg-12" id="search_layer">
						</div>
						<!-- <div id="search_layer"></div> -->
						<!-- <div id="paging_layer"></div> -->
						<nav><ul class="pager" id="paging_layer"></ul></nav>
						<!-- /List -->
</form>
					</div>
				</div>
			</div>
			<div class="col-lg-1"></div>
		</div>
		<!--END BLOCK SECTION -->
		<div class="col-lg-3"></div>
	</div>
	<!--END PAGE CONTENT -->


<%@ include file="/WEB-INF/views/common/_footer.jsp"%>

