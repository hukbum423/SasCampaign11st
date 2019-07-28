<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

<!-- BEG PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL STYLES -->
<script>
	// 캠페인 설계 popup
	function fnCistudio(){
		window.open("${staticPATHSasurl }/SASCIStudio/", "CIStudio", "width=1600, height=1050, toolbar=no, menubar=no, scrollbars=no, resizable=yes" );
	}

	// 캠페인 분석 popup
	function fnAnal(){
		var tmpUrl = encodeURI("${staticPATHSvaurl }/SASVisualAnalyticsViewer/VisualAnalyticsViewer.jsp?reportViewOnly=true&reportName=03.캠페인 실적 분석&reportPath=/CM_META/61.보고서/611.캠페인모니터링");
		window.open(tmpUrl, "Anal", "width=1600, height=1050, toolbar=no, menubar=no, scrollbars=no, resizable=yes" );
	}

	// 캠페인 모니터 popup
	function fnMonitering(){
		var tmpUrl = encodeURI("${staticPATHSvaurl }/SASVisualAnalyticsViewer/VisualAnalyticsViewer.jsp?reportViewOnly=true&reportName=01.현황모니터링&reportPath=/CM_META/61.보고서/611.캠페인모니터링");
		window.open(tmpUrl, "Monitering", "width=1600, height=1050, toolbar=no, menubar=no, scrollbars=no, resizable=yes" );
	}

	// 캠페인 관리
	function fnManage(){
		location.href = "${staticPATH }/notice/noticeList.do";
	}
</script>

	<!--PAGE CONTENT -->
	<div id="content" style="width:100%; height100%;">
		<!--BLOCK SECTION -->
		<div class="row" style="width:100%; height100%;">
			<div class="col-lg-1"></div>
			<div class="col-lg-10" style="margin:0px 0px 0px -18px;">
				<div class="col-md-2" style="text-align: center;">
					<button type="button" class="btn btn_default" style="width:180px;height:45px;margin:10px 30px 15px 20px;" onclick="location.href='${staticPATH }/calendar/calendar.do';">
						<h5><b><i class="fa fa-calendar"></i> 캠페인 달력</b></h5>
						<!-- <span class="label label-danger">2</span> -->
					</button>
				</div>
				<div class="col-md-2" style="text-align: center;">
					<button type="button" class="btn btn_warning" style="width:180px;height:45px;margin:10px 30px 15px 20px;" onclick="location.href='${staticPATH }/campaign/campaignList.do';">
						<h5><b><i class="fa fa-list-alt"></i> 캠페인리스트</b></h5>
						<!-- <span class="label label-danger">2</span> -->
					</button>
				</div>
				<div class="col-md-2" style="text-align: center;">
					<button type="button" class="btn btn_default" style="width:180px;height:45px;margin:10px 30px 15px 20px;" onclick="fnCistudio();">
						<h5><b><i class="fa fa-cogs"></i> 캠페인설계</b></h5>
						<!-- <span class="label label-danger">2</span> -->
					</button>
				</div>
				<div class="col-md-2" style="text-align: center;">
					<button type="button" class="btn btn_default" style="width:180px;height:45px;margin:10px 30px 15px 20px;" onclick="fnAnal();">
						<h5><b><i class="fa fa-line-chart"></i> 실적분석</b></h5>
						<!-- <span class="label label-danger">2</span> -->
					</button>
				</div>
				<div class="col-md-2" style="text-align: center;">
					<button type="button" class="btn btn_default" style="width:180px;height:45px;margin:10px 30px 15px 20px;" onclick="fnMonitering();">
						<h5><b><i class="fa fa-desktop"></i> 현황모니터링</b></h5>
					</button>
				</div>
				<div class="col-md-2" style="text-align: center;">
					<div class="btn-group">
						<!-- <button type="button" class="btn btn_default dropdown-toggle" style="width:180px;height:45px;margin:10px 30px 15px 20px;" data-toggle="dropdown" aria-expanded="false" data-hover="dropdown-menu"> -->
						<button type="button" class="btn btn_default" style="width:180px;height:45px;margin:10px 30px 15px 20px;" onclick="fnManage();">
							<h5><b><i class="fa fa-wrench"></i> 캠페인 관리</b></h5>
							<!-- <span class="label label-danger">2</span> -->
							<!-- <br/>&nbsp; -->
						</button>
<%--
						<ul class="dropdown-menu" role="menu" style="margin:-20px 0px 0px 22px;">
							<li><a href="${staticPATH }/toast/toastList.do">토스트배너 관리</a></li>
							<li><a href="${staticPATH }/testTarget/testTargetList.do">테스트 대상 관리</a></li>
							<li><a href="${staticPATH }/variable/variableList.do">매개변수 관리</a></li>
							<li><a href="${staticPATH }/commCode/commCodeList.do">공통코드 관리</a></li>
							<li><a href="${staticPATH }/tableInfo/tableInfoList.do">테이블 정보 관리</a></li>
							<li><a href="${staticPATH }/notice/noticeList.do">공지사항 관리</a></li>
							<!--
							<li class="divider"></li>
							<li><a href="#">Separated link</a></li>
							-->
						</ul>
--%>
					</div>
				</div>
			</div>
			<div class="col-lg-1"></div>
		</div>
		<!--END BLOCK SECTION -->

		<!-- 상단 좌우 그래프 -->
		<div class="row" style="width:93%;">
			<div class="col-lg-1"></div>
			<div class="col-lg-5 align-center" style="width:35%;height:360px;border: 1px solid ;border-color:#DDDDDD; margin:0px 10px 10px 10px;padding:0px 20px 5px 20px;">
				<h4><b><i class="fa fa-pie-chart" aria-hidden="true"></i> 목표대비 달성율</b></h4>
				<iframe name="" id="topChart" src="${staticPATH }/main_top_chart.do" style="border:0px;" height="340" width="100%"></iframe>
			</div>
			<div class="col-lg-5 align-center" style="width:53%;height:360px;border: 1px solid ;border-color:#DDDDDD; margin:0px 10px 10px 3px;padding:0px 20px 5px 20px;">
				<h4><b><i class="fa fa-bar-chart" aria-hidden="true"></i> 11번가 침투율</b></h4>
				<iframe name="" id="topChart" src="${staticPATH }/main_right_chart.do" style="border:0px;" height="340" width="100%"></iframe>
			</div>
			<div class="col-lg-1"></div>
		</div>

		<!-- 하단 그래프 -->
		<div class="row">
			<div class="col-lg-1"></div>
			<div class="col-lg-10"  style="width:81%;height:415px;border: 1px solid ;border-color:#DDDDDD; margin:0px 10px 10px 0px;padding:0px 10px 5px 20px;">
				<h4><b><i class="fa fa-line-chart" aria-hidden="true"></i> 캠페인 결제 거래액 추이</b></h4>
				<iframe name="" id="leftChart" src="${staticPATH }/main_left_chart.do" style="border:0px;" height="390" width="100%"></iframe>
			</div>
			<div class="col-lg-1"></div>
		</div>
	</br></br>

	</div>
	<!--END PAGE CONTENT -->

<script>
	$(document).ready(function(){
		// $("#topChart").load("${staticPATH }/main_top_chart.do");
		// $("#leftChart").load("${staticPATH }/main_left_chart.do");
		// $("#rightChart").load("${staticPATH }/main_right_chart.do");
	});
</script>

<%@ include file="/WEB-INF/views/common/_footer.jsp"%>
