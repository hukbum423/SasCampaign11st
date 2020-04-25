<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>



<script>
	// =================================================
	// ready
	$(document).ready(function() {
		// 화면타이틀값 : 메뉴명칭
		if (window.location != window.parent.location) { //iframe일경우에만
			parent.setPageTitle("공통코드 관리",null);
			// Tab 메뉴
			// Step1 메뉴에 url 생성 후 변경 필요함.
			var tablist = "";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/toastList.do'>토스트 배너 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/testTargetList.do'>테스트 대상 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/variableList.do'>매개변수 관리</a></li>";
			tablist += "<li class=selected><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/commCodeList.do'>공통코드 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/tableInfoList.do'>테이블 정보 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/noticeList.do'>공지사항 관리</a></li>";
			top.setNewTabList(tablist);

			parent.document.getElementById('gwt-uid-2').innerHTML='<a href="/Campaign/logout.do"><font color="#E8DB6B" bold style={text-decoration:none;}>로그아웃</a>';
		}
		//조회
		fn_search();
		//부모코드가 있을경우 상세목록을 조회한다
		if ("${CCOMM_CODE_ID}" != "") {
			fn_getDetailList("${CCOMM_CODE_ID}");
		}
	});

	// =================================================
	// 조회
	function fn_search() {
		//dtl 정보 초기화
		$("#CCOMM_CODE_ID").val("");
		$("#save").hide();
		$("#search_layer2").html("");
		jQuery.ajax({
			url           : '${staticPATH }/getCommCodeList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
			data          : {
				SCOMM_CODE_ID   : $("#SCOMM_CODE_ID").val(),
				SCOMM_CODE_NAME : $("#SCOMM_CODE_NAME").val(),
				selectPageNo    : $("#selectPageNo").val()
			},
			success: function(result, option) {
				if (option == "success") {
					var list = result.CommCodeList;
					var txt ="";
					txt += "<table class='table table-striped table-hover table-condensed' width='100%' border='0' cellpadding='0' cellspacing='0'>";
					if (list.length > 0) {
						txt += "<colgroup>";
						txt += '<col width="4%"/>';
						txt += '<col width="8%"/>';
						txt += '<col width=""/>';
						txt += '<col width="6%"/>';
						txt += '<col width="6%"/>';
						txt += '<col width="12%"/>';
						txt += '<col width="13%"/>';
						txt += '<col width="12%"/>';
						txt += '<col width="15%"/>';
						txt += "</colgroup>";
						$.each(list, function(key) {
							var data = list[key];
							txt += "<tr>";
							txt += "<td align=\"center\" class=\"listtd\">"+data.num+"</td>";
							txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_getCodeMstDtl('"+data.comm_code_id+"');\" class='link'>"+nvl(data.comm_code_id,'')+"</a></td>";
							txt += "<td align=\"left\"   class=\"listtd\"><a href=\"javascript:fn_getDetailList('"+data.comm_code_id+"');\" class='link'>"+nvl(data.comm_code_name,'')+"</a></td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.sort_seq,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.use_yn,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_nm,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_dt,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.update_nm,'&nbsp;')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.update_dt,'&nbsp;')+"</td>";
							txt += "</tr>";
						});
					} else {
						txt += "<td align=\"center\" class=\"listtd\" colspn=\"\9\">데이터가 없습니다.</td>";
					}
					//빈 row 채우기
					if (list.length > 0 && list.length < result.rowRange) {
						for (var i=list.length; i < result.rowRange; i++) {
							txt +="<tr>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="</tr>";
						}
					}
					txt += "</table>";
					$("#search_layer").html(txt);
					//페이징 처리 시작!!
					//var page = pagingNavi(result.selectPage, result.pageRange, result.pageStart, result.pageEnd, result.totalPage);
					var page = pagingNavi2(result.selectPage, result.pageRange, result.pageStart, result.pageEnd, result.totalPage, "fn_pageMove");
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
	// 조회버튼 클릭
	function fn_clcik_search() {
		$("#selectPageNo").val("1");
		fn_search();
	}


	// =================================================
	// KANG-20190425: for pagination
	function pagingNavi2(selectPage, pageRange, pageStart, pageEnd, totalPage, pageMove){
		if (true) {
			var msg = " => ";
			msg += "selectPage=" + selectPage;
			msg += ", pageRange=" + pageRange;
			msg += ", pageStart=" + pageStart;
			msg += ", pageEnd=" + pageEnd;
			msg += ", totalPage=" + totalPage;
			msg += ", pageMove=" + pageMove;
			console.log("KANG.pagingMavi2:" + msg);
		}
		var page = "";
		//이전페이지 만들기
		if (selectPage > pageRange) {
			// page +="<a href=\"javascript:fn_pageMove("+ (Number(result.pageStart) - Number(result.pageRange)) +" );\" ><img src=\"<c:url value='/img/btn_left.gif'/>\" width='13px;' height='13px;' /></a>&nbsp;";
			page += "<li><a href=\"javascript:" + pageMove + "(" + (Number(pageStart) - Number(pageRange)) + ");\" aria-label='Previous'><span aria-hidden='true'>&laquo;</span></a></li>";
		}
		//페이지 숫자
		for (var i = pageStart; i <= pageEnd; i++) {
			var tmpActive = "";
			if (selectPage == i)	{
				tmpActive = "style='background-color:#EEEEEE'";
			}
			// page += "<li ><a href=\"javascript:fn_pageMove(" + i + ");\" " + tmpActive + ">" + i + "</a></li>";
			page += "<li ><a href=\"javascript:" + pageMove + "(" + i + ");\" " + tmpActive + ">" + i + "</a></li>";
		}
		//다음페이지 만들기
		if (totalPage != pageEnd) {
			// page +="&nbsp;<a href=\"javascript:fn_pageMove("+ (Number(result.pageStart) + Number(result.pageRange)) +" );\" ><img src=\"<c:url value='/img/btn_right.gif'/>\" width='13px;' height='13px;' /></a>";
			page += "<li><a href=\"javascript:" + pageMove + "(" + (Number(pageStart) + Number(pageRange)) + ");\" aria-label='Next'><span aria-hidden='true'>&raquo;</span></a></li>";
		}
		return page;
	}


	// =================================================
	// 페이지 이동
	function fn_pageMove(selectPageNo) {
		$("#selectPageNo").val(selectPageNo);
		fn_search();
	}


	// =================================================
	// 코드 마스터 상세 조회
	function fn_getCodeMstDtl(codeId) {
		var frm = document.form;
		$("#COMM_CODE_ID").val(codeId);
		frm.action = "${staticPATH }/commCode/commCodeMaster.do";
		frm.submit();
	}


	// =================================================
	// 코드 슬레이브 상세 조회
	function fn_getCodeDtlDtl(codeId) {
		var frm = document.form;
		$("#CODE_ID").val(codeId);
		frm.action = "${staticPATH }/commCode/commCodeSlave.do";
		frm.submit();
	}


	// =================================================
	// 상세 목록 조회
	function fn_getDetailList(codeId) {
		//dtl정보 설정
		$("#CCOMM_CODE_ID").val(codeId);
		$("#save").show();
		jQuery.ajax({
			url           : '${staticPATH }/getCommCodeDtlList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
			data          : {
				codeId   : codeId
			},
			success: function(result, option) {
				if (option == "success") {
					var list = result.CommCodeDtlList;
					var txt ="";
					txt += '<table class="table table-striped table-hover table-condensed" width="100%" border="0" cellpadding="0" cellspacing="0">';
					if (list.length > 0) {
						txt += "<colgroup>";
						txt += '<col width="4%"/>';
						txt += '<col width="8%"/>';
						txt += '<col width=""/>';
						txt += '<col width="6%"/>';
						txt += '<col width="6%"/>';
						txt += '<col width="12%"/>';
						txt += '<col width="13%"/>';
						txt += '<col width="12%"/>';
						txt += '<col width="15%"/>';
						txt += "</colgroup>";
						$.each(list, function(key) {
							var data = list[key];
							txt += "<tr>";
							txt += "<td align=\"center\" class=\"listtd\">"+data.num+"</td>";
							txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_getCodeDtlDtl('"+data.code_id+"');\" class='link'>"+nvl(data.code_id,'')+"</a></td>";
							txt += "<td align=\"left\"   class=\"listtd\">"+nvl(data.code_name,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.sort_seq,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.use_yn,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_nm,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_dt,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.update_nm,'&nbsp;')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.update_dt,'&nbsp;')+"</td>";
							txt += "</tr>";
						});
					} else {
						txt += "<td align=\"center\" class=\"listtd\" colspn=\"9\">데이터가 없습니다.</td>";
					}
					txt += "</table>";
					$("#search_layer2").html(txt);
				} else {
					alert("에러가 발생하였습니다.");
				}
			},
			error: function(result, option) {
				alert("에러가 발생하였습니다.");
			}
		});
	}


	// =================================================
	// 마스터 등록페이지 이동
	function fn_new_master() {
		var frm = document.form;
		frm.action = "${staticPATH }/commCode/commCodeMaster.do";
		frm.submit();
	};


	// =================================================
	// 슬레이브 등록페이지 이동
	function fn_new_slave() {
		var frm = document.form;
		if ($("#CCOMM_CODE_ID").val() == "") {
			alert("상세코드를 입력하기 위해서 마스터 코드ID를 선택하세요.");
			return;
		}
		frm.action = "${staticPATH }/commCode/commCodeSlave.do";
		frm.submit();
	};
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
								<li role="presentation" class="">
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
								<li role="presentation" class="active">
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

<form name="form" id="form">
<input type="hidden" id="selectPageNo" name="selectPageNo"  value="${selectPageNo}" /> <!-- 페이징 처리용 -->
<input type="hidden" id="COMM_CODE_ID" name="COMM_CODE_ID"  value="" /><!-- 마스터 상세보기용 -->
<input type="hidden" id="CCOMM_CODE_ID" name="CCOMM_CODE_ID"  value="" /><!-- 디테일 상세보기용 -->
<input type="hidden" id="CODE_ID" name="CODE_ID"  value="" /><!-- 디테일 상세보기용 -->

						<div id="table">
							<table class="table table-striped" width="100%" border="0" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="10%"/>
									<col width="20%"/>
									<col width="10%"/>
									<col width="20%"/>
									<col width="40%"/>
								</colgroup>
								<tr>
									<th class="info">코드ID</th>
									<td class="tbtd_content">
										<input type="text" id="SCOMM_CODE_ID" name="SCOMM_CODE_ID" value="${SCOMM_CODE_ID}" style="width:150px;" class="txt"/>
									</td>
									<th class="info">코드명</th>
									<td class="tbtd_content">
										<input type="text" id="SCOMM_CODE_NAME" name="SCOMM_CODE_NAME" value="${SCOMM_CODE_NAME}"  style="width:250px;" class="txt"/>
									</td>
									<td style="text-align:right;">
										<button type="button" class="btn btn-success btn-sm" onclick="fn_clcik_search();"> <i class="fa fa-search" aria-hidden="true"></i> 조 회 </button>
										<button type="button" class="btn btn-info btn-sm" onclick="fn_new_master();"> <i class="fa fa-pencil"></i> 등 록 </button>
									</td>
								</tr>
							</table>
						</div>

						<!-- List Header -->
						<div id="table">
							<table class="table table-striped" width="100%" border="0" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="4%"/> <!-- No       -->
									<col width="8%"/>  <!-- 코드ID   -->
									<col width=""/>     <!-- 코드명   -->
									<col width="6%"/>   <!-- 정렬순서 -->
									<col width="6%"/>   <!-- 사용여부 -->
									<col width="12%"/>  <!-- 등록자   -->
									<col width="13%"/>  <!-- 등록일시 -->
									<col width="12%"/>  <!-- 수정자   -->
									<col width="15%"/>  <!-- 수정일시 -->
								</colgroup>
								<tr class="info">
									<th style="text-align:center;">No</th>
									<th style="text-align:center;">코드ID</th>
									<th style="text-align:center;">코드명</th>
									<th style="text-align:center;">정렬순서</th>
									<th style="text-align:center;">사용여부</th>
									<th style="text-align:center;">등록자</th>
									<th style="text-align:center;">등록일시</th>
									<th style="text-align:center;">수정자</th>
									<th style="text-align:center;">수정일시</th>
								</tr>
							</table>
						</div>
						<!-- /List Header -->

						<!-- List -->
						<div id="search_layer"></div>
						<nav><ul class="pager" id="paging_layer"></ul></nav>
						<div id="save" class="col-md-12" style="text-align:right;margin-bottom:10px;" >
							<button type="button" class="btn btn-info btn-sm" onclick="fn_new_slave();"> <i class="fa fa-pencil"></i> 등 록 </button>
						</div>
						<!-- /List -->

						<!-- List -->
						<div id="table">
							<table class="table table-striped table-hover" width="100%" border="0" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="4%"/>   <!-- No      -->
									<col width="8%"/>   <!-- 코드ID   -->
									<col width=""/>     <!-- 코드명   -->
									<col width="6%"/>   <!-- 정렬순서 -->
									<col width="6%"/>   <!-- 사용여부 -->
									<col width="12%"/>  <!-- 등록자   -->
									<col width="13%"/>  <!-- 등록일시 -->
									<col width="12%"/>  <!-- 수정자   -->
									<col width="15%"/>  <!-- 수정일시 -->
								</colgroup>
								<tr class="info">
									<th style="text-align:center;">No</th>
									<th style="text-align:center;">코드ID</th>
									<th style="text-align:center;">코드명</th>
									<th style="text-align:center;">정렬순서</th>
									<th style="text-align:center;">사용여부</th>
									<th style="text-align:center;">등록자</th>
									<th style="text-align:center;">등록일시</th>
									<th style="text-align:center;">수정자</th>
									<th style="text-align:center;">수정일시</th>
								</tr>
							</table>
						</div>
						<div id="search_layer2"></div>
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

