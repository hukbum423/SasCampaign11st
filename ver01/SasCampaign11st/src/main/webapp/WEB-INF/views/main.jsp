<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script>
	function fnCistudio() {
		window.open("${staticPATHSasurl }/SASCIStudio/", "CIStudio", "width=1600, height=1050, toolbar=no, menubar=no, scrollbars=no, resizable=yes" );
	}

	function fnMonitering() {
		window.open("${staticPATHSvaurl }/SASVisualAnalyticsViewer/VisualAnalyticsViewer.jsp?reportViewOnly=true&reportName=01.현황모니터링&reportPath=%2FCM_META%2F61.보고서%2F611.캠페인모니터링", "Monitering", "width=1600, height=1050, toolbar=no, menubar=no, scrollbars=no, resizable=yes" );
	}

	function fnAnal() {
		window.open("${staticPATHSasurl }/SASVisualAnalyticsViewer/VisualAnalyticsViewer.jsp?reportViewOnly=true&reportName=03.캠페인%20현황%20요약&reportPath=%2FCM_META%2F61.보고서%2F611.캠페인모니터링", "Anal", "width=1600, height=1050, toolbar=no, menubar=no, scrollbars=no, resizable=yes" );
	}
</script>

	<!--PAGE CONTENT -->
	<div id="content" style="width:100%; height100%;">
		<!--BLOCK SECTION -->
		<div class="col-lg-12" style="height:30px;"></div>
		<div class="row" style="width:100%; height100%;">
			<div class="col-lg-3"></div>
			<div class="col-lg-6">
				<div class="col-md-4" style="text-align: center;">
					<button type="button" class="btn btn-warning" style="width:150px;height:130px;margin:20px 30px 20px 20px;" onclick="location.href='${staticPATH }/campaign/campaignList.do';">
						<h3><i class="fa fa-list-alt"></i></h3>
						<span><b>캠페인 리스트</b></span>
						<!-- <span class="label label-danger">2</span> -->
						<br/>&nbsp;
					</button>
				</div>
				<div class="col-md-4" style="text-align: center;">
					<button type="button" class="btn btn-info" style="width:150px;height:130px;margin:20px 30px 20px 20px;" onclick="fnCistudio();">
						<h3><i class="fa fa-cogs"></i></h3>
						<span><b>캠페인설계<br/>(CI Studio)</b></span>
						<!-- <span class="label label-danger">2</span> -->
					</button>
				</div>
				<div class="col-md-4" style="text-align: center;">
					<button type="button" class="btn btn-danger" style="width:150px;height:130px;margin:20px 30px 20px 20px;" onclick="fnMonitering();">
						<h3><i class="fa fa-desktop"></i><br/></h3>
						<span><b>캠페인현황<br/>모니터링</b></span>
						<span class="label label-danger">2</span>
					</button>
				</div>
				<div class="col-md-4" style="text-align: center;">
					<button type="button" class="btn btn-default" style="width:150px;height:130px;margin:20px 30px 20px 20px;" onclick="location.href='${staticPATH }/calendar/calendar.do';">
						<h3><i class="fa fa-calendar"></i></h3>
						<span><b>캠페인 달력</b></span>
						<!-- <span class="label label-danger">2</span> -->
						<br/>&nbsp;
					</button>
				</div>
				<div class="col-md-4" style="text-align: center;">
					<button type="button" class="btn btn-success" style="width:150px;height:130px;margin:20px 30px 20px 20px;" onclick="fnAnal();">
						<h3><i class="fa fa-line-chart"></i></h3>
						<span><b>캠페인<br/>성과분석</b></span>
						<!-- <span class="label label-danger">2</span> -->
					</button>
				</div>
				<div class="col-md-4" style="text-align: center;">
					<div class="btn-group">
						<button type="button" class="btn btn-warning dropdown-toggle" style="width:150px;height:130px;margin:20px 30px 20px 20px;" data-toggle="dropdown" aria-expanded="false" data-hover="dropdown-menu">
							<h3><i class="fa fa-wrench"></i></h3>
							<span><b>캠페인 관리</b></span>
							<!-- <span class="label label-danger">2</span> -->
							<br/>&nbsp;
						</button>
						<ul class="dropdown-menu" role="menu" style="margin:-20px 0px 0px 22px;">
							<li><a href="${staticPATH }/toast/toastList.do">토스트배너 관리</a></li>
							<li><a href="${staticPATH }/testTarget/testTargetList.do">테스트 대상 관리</a></li>
							<li><a href="${staticPATH }/variable/variableList.do">매개변수 관리</a></li>
							<li><a href="${staticPATH }/commCode/commCodeList.do">공통코드 관리</a></li>
							<%-- <li><a href="${staticPATH }/tableInfo/tableInfoList.do">테이블 정보 관리</a></li> --%>
							<li><a href="${staticPATH }/notice/noticeList.do">공지사항 관리</a></li>
							<!--
							<li class="divider"></li>
							<li><a href="#">Separated link</a></li>
							-->
						</ul>
					</div>
				</div>

			</div>
		</div>
		<!--END BLOCK SECTION -->
		<div class="col-lg-3"></div>

	</div>
	<!--END PAGE CONTENT -->

<%@ include file="/WEB-INF/views/common/_footer.jsp"%>
