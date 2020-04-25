<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->



<script>
	// =================================================
	// ready
	$(document).ready(function() {
		// 화면타이틀값 : 메뉴명칭
		if (window.location != window.parent.location) { //iframe일경우에만
			parent.setPageTitle("공지사항 관리",null);

			// Tab 메뉴
			// Step1 메뉴에 url 생성 후 변경 필요함.
			var tablist = "";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/toastList.do'>토스트 배너 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/testTargetList.do'>테스트 대상 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/variableList.do'>매개변수 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/commCodeList.do'>공통코드 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/tableInfoList.do'>테이블 정보 관리</a></li>";
			tablist += "<li class=selected><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/noticeList.do'>공지사항 관리</a></li>";
			top.setNewTabList(tablist);

			parent.document.getElementById('gwt-uid-2').innerHTML='<a href="/Campaign/logout.do"><font color="#E8DB6B" bold style={text-decoration:none;}>로그아웃</a>';
		}
		// 조회
		fn_search();
	});


	// =================================================
	// 조회
	function fn_search() {
		if (true) console.log(">>>>> KANG-20200421: fn_search: ");
		jQuery.ajax({
			url           : '${staticPATH }/notice/getNoticeList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
			data          : {
				selectPageNo: $("#selectPageNo").val()
			},
			success: function(result, option) {
				if (option == "success") {
					var list = result.NoticeList;
					var txt = "";
					txt += "<table class='table table-striped table-hover table-bordered' width='100%' border='0' cellpadding='0' cellspacing='0'>";
					if (list.length > 0) {
						txt += "<colgroup>";
						txt += "<col width='10%'/>";
						txt += "<col width='65%'/>";
						txt += "<col width='10%'/>";
						txt += "<col width='15%'/>";
						txt += "</colgroup>";

						txt += '<tr class="info">';
						txt += '<th style="text-align:center;">공지번호</th>';
						txt += '<th style="text-align:center;">제목</th>';
						txt += '<th style="text-align:center;">등록자</th>';
						txt += '<th style="text-align:center;">등록일시</th>';
						txt += '</tr>';
						txt += '<tbody>';

						$.each(list, function(key){
							var data = list[key];
							txt += "<tr>";
							txt += "<td align=\"center\">"+nvl(data.notice_no,'')+"</td>";
							txt += "<td ><a href=\"javascript:fn_getNoticeDetail('"+data.notice_no+"');\" class='link' >"+nvl(data.title,'')+"</a>";
							if(data.top_yn == "Y"){
								txt +=  "<!--<img src='/UnicaExt/img/btn/new.png' width='23' height='13' style='margin-left: 8px;' />--></td>";
							}else{
								txt +=  "</td>";
							}
							txt += "<td align=\"center\">"+nvl(data.create_nm,'')+"</td>";
							txt += "<td align=\"center\">"+nvl(data.create_dt,'')+"</td>";
							txt += "</tr>";
						});
					} else {
						txt += "<td align=\"center\" class=\"listtd\" colspn=\"\4\">데이터가 없습니다.</td>";
					}

					//빈 row 채우기
					if (list.length > 0 && list.length < result.rowRange ) {
						for (var i=list.length; i<result.rowRange; i++) {
							/*
							txt +="<tr>";
							txt +="<td align=\"center\" class=\"listtd\" style=\"height:20px;\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="</tr>";
							*/
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
	// KANG-20190425: for pagination
	function pagingNavi2(selectPage, pageRange, pageStart, pageEnd, totalPage, pageMove) {
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
			if(selectPage == i)	{
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
	// 공지사항 상세 조회
	function fn_getNoticeDetail(noticeNo) {
		var frm = document.form;
		$("#NOTICE_NO").val(noticeNo);
		frm.action = "${staticPATH }/notice/noticeDetail.do";
		frm.submit();
	}


	// =================================================
	// 공지사항 입력페이지 이동
	function fn_new() {
		var frm = document.form;
		frm.action = "${staticPATH }/notice/noticeDetail.do";
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
								<li role="presentation" class="active">
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
<input type="hidden" id="selectPageNo" name="selectPageNo"  value="${selectPageNo}" />
<input type="hidden" id="NOTICE_NO" name="NOTICE_NO"  value="" />

						<!-- List -->
						<div class="col-md-12" id="search" style="text-align:right;margin-bottom:10px;">
							<button type="button" class="btn btn-success btn-sm" onclick="fn_new();"><i class="fa fa-edit"></i> 등 록 </button>
						</div>
						<div id="search_layer"></div>
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

