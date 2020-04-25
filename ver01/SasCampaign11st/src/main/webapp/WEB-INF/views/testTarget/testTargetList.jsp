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
			parent.setPageTitle("테스트 대상 관리",null);

			// Tab 메뉴
			// Step1 메뉴에 url 생성 후 변경 필요함.
			var tablist = "";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/toastList.do'>토스트 배너 관리</a></li>";
			tablist += "<li class=selected><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/testTargetList.do'>테스트 대상 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/variableList.do'>매개변수 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/commCodeList.do'>공통코드 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/tableInfoList.do'>테이블 정보 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/noticeList.do'>공지사항 관리</a></li>";
			top.setNewTabList(tablist);

			parent.document.getElementById('gwt-uid-2').innerHTML='<a href="/Campaign/logout.do"><font color="#E8DB6B" bold style={text-decoration:none;}>로그아웃</a>';
		}
		//조회
		fn_search();
	});


	// =================================================
	/* 조회 */
	function fn_search() {
		if (true) console.log(">>>>> KANG-20200421: fn_search: ");
		jQuery.ajax({
			url           : '${staticPATH }/getTestTargetList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
			data          : {
				SMEM_ID   : $("#SMEM_ID").val()
			},
			success: function(result, option) {
				if (option == "success") {
					var list = result.TestTargetList;
					var txt ="";
					txt += "<table class='table table-striped table-hover table-condensed table-bordered'>";
					if (list.length > 0) {
						txt += "<colgroup>";
						txt += "<col width='40'/>";
						txt += "<col width='90'/>";
						txt += "<col width='90'/>";
						txt += "<col width='165'/>";
						txt += "<col width=''/>";
						txt += "<col width='120'/>";
						txt += "<col width='120'/>";
						txt += "<col width='100'/>";
						txt += "<col width='160'/>";
						txt += "</colgroup>";
						var num = 1;
						$.each(list, function(key) {
							var data = list[key];
							txt += "<tr>";
							txt += "<td align=\"center\" class=\"listtd\">"+ num++ +"</td>";
							txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_getTestTargetDtl('"+ data.mem_id +"');\" class='link'>"+ nvl(data.mem_id,'') +"</a></td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.mem_no,'') +"</a></td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.pcid,'') +"</a></td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.name,'') +"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.tel,'') +"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.email,'') +"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.create_nm,'') +"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.create_dt,'') +"</td>";
							txt += "</tr>";
						});
					} else {
						txt += "<td align=\"center\" class=\"listtd\" colspn=\"9\">데이터가 없습니다.</td>";
					}
					//빈 row 채우기
					if (list.length > 0 && list.length < result.rowRange) {
						for (var i=list.length; i<result.rowRange; i++) {
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
	function fn_clcik_search(){
		fn_search();
	}


	// =================================================
	// 테스트 대상자 상세보기
	function fn_getTestTargetDtl(mem_id){
		$("#MEM_ID").val(mem_id);
		$("#TYPE").val("U");
		var frm = document.form;
		frm.action = "${staticPATH }/testTarget/testTargetDetail.do";
		frm.submit();
	}


	// =================================================
	// 등록페이지 이동
	function fn_new() {
		var frm = document.form;
		$("#TYPE").val("I");
		frm.action = "${staticPATH }/testTarget/testTargetDetail.do";
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
								<li role="presentation" class="active">
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

<form name="form" id="form">
<input type="hidden" id="MEM_ID" name="MEM_ID" value="" />
<input type="hidden" id="TYPE" name="TYPE" value="" />

						<div id="table">
							<table class="table table-striped table-hover table-condensed table-bordered">
								<colgroup>
									<col width="10%"/>
									<col width="25%"/>
									<col width="75%%"/>
								</colgroup>
								<tr>
									<td class="info">고객ID</td>
									<td class="tbtd_content">
										<input type="text" id="SMEM_ID" name="SMEM_ID" value="${SMEM_ID}" style="width:120px;" class="txt"/>
									</td>
									<td style="text-align:right;">
										<button type="button" class="btn btn-success btn-sm" onclick="fn_clcik_search();">
											<i class="fa fa-search" aria-hidden="true"></i> 조 회
										</button>
										<button type="button" class="btn btn-info btn-sm" onclick="fn_new();">
											<i class="fa fa-pencil"></i> 등 록
										</button>
									</td>
								</tr>
							</table>
						</div>

						<!-- List -->
						<div id="table">
							<table class="table table-striped table-hover" width="100%" border="0" cellpadding="0" cellspacing="0">
								<colgroup>
									<col width="40"/>  <!-- No      -->
									<col width="90"/>  <!-- 고객ID   -->
									<col width="90"/>  <!-- 고객번호  -->
									<col width="165"/> <!-- PCID    -->
									<col width=""/>    <!-- 이름     -->
									<col width="120"/> <!-- 전화번호  -->
									<col width="120"/> <!-- 이메일   -->
									<col width="100"/> <!-- 등록자   -->
									<col width="160"/> <!-- 등록일시 -->
								</colgroup>
								<tr class="info">
									<th style="text-align:center;">No</th>
									<th style="text-align:center;">고객ID</th>
									<th style="text-align:center;">고객번호</th>
									<th style="text-align:center;">PCID</th>
									<th style="text-align:center;">이름</th>
									<th style="text-align:center;">전화번호</th>
									<th style="text-align:center;">이메일</th>
									<th style="text-align:center;">등록자</th>
									<th style="text-align:center;">등록일시</th>
								</tr>
							</table>
						</div>
						<div id="search_layer"></div>
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

