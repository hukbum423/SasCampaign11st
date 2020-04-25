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
	/* ready */
	$(document).ready(function() {
		// 화면타이틀값 : 메뉴명칭
		if (window.location != window.parent.location) { //iframe일경우에만
			parent.setPageTitle("매개변수 관리",null);

			// Tab 메뉴
			// Step1 메뉴에 url 생성 후 변경 필요함.
			var tablist = "";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/toastList.do'>토스트 배너 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/testTargetList.do'>테스트 대상 관리</a></li>";
			tablist += "<li class=selected><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/variableList.do'>매개변수 관리</a></li>";
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
	// 조회
	function fn_search() {
		if (true) console.log(">>>>> KANG-20200421: fn_search: ");
		jQuery.ajax({
			url           : '${staticPATH }/getVariableList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
			data          : {
				SVARI_NAME   : $("#SVARI_NAME").val(),
				SKEY_COLUMN  : $("#SKEY_COLUMN").val()
			},
			success: function(result, option) {
				if (option == "success") {
					var list = result.VariableList;
					var txt ="";
					txt += "<table class='table table-striped table-hover table-condensed table-bordered'>";
					if (list.length > 0) {
						txt += "<colgroup>";
						txt +='<col width="3%"/>';
						txt +='<col width="8%"/>';
						txt +='<col width="7%"/>';
						txt +='<col width="22%"/>';
						txt +='<col width="6%"/>';
						txt +='<col width="6%"/>';
						txt +='<col width="6%"/>';
						txt +='<col width="5%"/>';
						txt +='<col width="7%"/>';
						txt +='<col width="10%"/>';
						txt += "</colgroup>";
						var num = 1;
						$.each(list, function(key) {
							var data = list[key];
							txt += "<tr>";
							txt += "<td align=\"center\" class=\"listtd\">"+ num++ +"</td>";
							txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_getTestTargetDtl('"+ data.vari_name +"');\" class='link'>"+ nvl(data.vari_name,'') +"</a></td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.key_column,'') +"</a></td>";
							txt += "<td align=\"left\"   class=\"listtd\">"+ nvl(data.ref_table,'') +"</a></td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.ref_column,'') +"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.if_null,'') +"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.max_byte,'') +"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.use_yn,'') +"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.create_nm,'') +"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+ nvl(data.create_dt,'') +"</td>";
							txt += "</tr>";
						});
					} else {
						txt += "<td align=\"center\" class=\"listtd\" colspn=\"10\">데이터가 없습니다.</td>";
					}
					//빈 row 채우기
					if (list.length > 0 && list.length < result.rowRange ) {
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
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="</tr>";
						}
					}
					txt += "</table>";
					$("#search_layer").html(txt);
				}else{
					alert("에러가 발생하였습니다.");
				}
			},
			error: function(result, option) {
				alert("에러가 발생하였습니다.");
			}
		});
	};


	// =================================================
	// 매개변수 상세보기
	function fn_getTestTargetDtl(vari_name){
		$("#VARI_NAME").val(vari_name);
		$("#TYPE").val("U");
		var frm = document.form;
		frm.action = "${staticPATH }/variable/variableDetail.do";
		frm.submit();
	}


	//=================================================
	// 등록페이지 이동
	function fn_new() {
		var frm = document.form;
		$("#TYPE").val("I");
		frm.action = "${staticPATH }/variable/variableDetail.do";
		frm.submit();
	};


	//=================================================
	// 조회버튼 클릭
	function fn_clcik_search(){
		fn_search();
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
								<li role="presentation" class="active">
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
<input type="hidden" id="VARI_NAME" name="VARI_NAME" value="" />
<input type="hidden" id="TYPE" name="TYPE" value="" />

						<div id="table">
							<table class="table table-striped table-hover table-condensed table-bordered">
								<colgroup>
									<col width="10%"/>
									<col width="25%"/>
									<col width="10%"/>
									<col width="25%"/>
									<col width="40%"/>
								</colgroup>
								<tr>
									<td class="info">변수명</td>
									<td>
										<input type="text" id="SVARI_NAME" name="SVARI_NAME" value="${SVARI_NAME}" style="width:120px;" class="txt"/>
									</td>
									<td class="info">키컬럼</td>
									<td>
										<input type="text" id="SKEY_COLUMN" name="SKEY_COLUMN" value="${SKEY_COLUMN}" style="width:120px;" class="txt"/>
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
						<div id="col-lg-12 table">
							<table class="table table-striped" width="100%">
								<colgroup>
									<col width="3%"/> <!-- No         -->
									<col width="8%"/>  <!-- 매개변수명 -->
									<col width="7%"/>  <!-- 키컬럼     -->
									<col width="22%"/>     <!-- 참조테이블 -->
									<col width="6%"/>  <!-- 참조컬럼   -->
									<col width="6%"/>  <!-- NULL대체값 -->
									<col width="6%"/>  <!-- 최대Byte -->
									<col width="5%"/>   <!-- 사용여부   -->
									<col width="7%"/>  <!-- 등록자     -->
									<col width="10%"/>  <!-- 등록일시   -->
								</colgroup>
								<tr class="info">
									<th class="text-center">No</th>
									<th class="text-center">매개변수명</th>
									<th class="text-center">키컬럼</th>
									<th class="text-center">참조테이블</th>
									<th class="text-center">참조컬럼</th>
									<th class="text-center">NULL대체값</th>
									<th class="text-center">최대Byte</th>
									<th class="text-center">사용여부</th>
									<th class="text-center">등록자</th>
									<th class="text-center">등록일시</th>
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

