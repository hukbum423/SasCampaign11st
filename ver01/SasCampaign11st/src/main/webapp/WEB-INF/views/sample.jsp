<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="/assets/css/layout2.css" rel="stylesheet" />
<link href="/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script language="JavaScript">
</script>



	<!--PAGE CONTENT -->
	<div id="content" style="width:100%; height100%;">
		<!--BLOCK SECTION -->
		<div class="row" style="width:100%; height100%;">
			<div class="col-lg-1"></div>
			<div class="col-lg-10">

				<div class="col-md-6 page-header">
					<h3>캠페인 관리 > 공지사항 관리</h3>
				</div>

				<form name="form" id="form">
					<input type="hidden" id="selectPageNo" name="selectPageNo"  value="${selectPageNo}" />
					<input type="hidden" id="NOTICE_NO" name="NOTICE_NO"  value="" />

					<!-- List -->
					<div id="table">
						<table class="table table-striped table-hover" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="10%"/> <!-- 공지번호   -->
								<col width="65%"/>  <!-- 제목       -->
								<col width="10%"/>  <!-- 등록자     -->
								<col width="15%"/>  <!-- 등록일시   -->
							</colgroup>
							<tr class="info">
								<th style="text-align:center;">공지번호</th>
								<th style="text-align:center;">제목</th>
								<th style="text-align:center;">등록자</th>
								<th style="text-align:center;">등록일시</th>
							</tr>
							<tbody>
								<tr>
									<td style="text-align:center;">1</td>
									<td>제목 제목 제목</td>
									<td style="text-align:center;">김개동</td>
									<td style="text-align:center;">2016-11-11</td>
								</tr>
								<tr>
									<td style="text-align:center;">1</td>
									<td>제목 제목 제목</td>
									<td style="text-align:center;">김개동</td>
									<td style="text-align:center;">2016-11-11</td>
								</tr>
								<tr>
									<td style="text-align:center;">1</td>
									<td>제목 제목 제목</td>
									<td style="text-align:center;">김개동</td>
									<td style="text-align:center;">2016-11-11</td>
								</tr>
								<tr>
									<td style="text-align:center;">1</td>
									<td>제목 제목 제목</td>
									<td style="text-align:center;">김개동</td>
									<td style="text-align:center;">2016-11-11</td>
								</tr>
								<tr>
									<td style="text-align:center;">1</td>
									<td>제목 제목 제목</td>
									<td style="text-align:center;">김개동</td>
									<td style="text-align:center;">2016-11-11</td>
								</tr>
								<tr>
									<td style="text-align:center;">1</td>
									<td>제목 제목 제목</td>
									<td style="text-align:center;">김개동</td>
									<td style="text-align:center;">2016-11-11</td>
								</tr>
								<tr>
									<td style="text-align:center;">1</td>
									<td>제목 제목 제목</td>
									<td style="text-align:center;">김개동</td>
									<td style="text-align:center;">2016-11-11</td>
								</tr>
								<tr>
									<td style="text-align:center;">1</td>
									<td>제목 제목 제목</td>
									<td style="text-align:center;">김개동</td>
									<td style="text-align:center;">2016-11-11</td>
								</tr>
								<tr>
									<td style="text-align:center;">1</td>
									<td>제목 제목 제목</td>
									<td style="text-align:center;">김개동</td>
									<td style="text-align:center;">2016-11-11</td>
								</tr>
								<tr>
									<td style="text-align:center;">1</td>
									<td>제목 제목 제목</td>
									<td style="text-align:center;">김개동</td>
									<td style="text-align:center;">2016-11-11</td>
								</tr>
								<tr>
									<td style="text-align:center;">1</td>
									<td>제목 제목 제목</td>
									<td style="text-align:center;">김개동</td>
									<td style="text-align:center;">2016-11-11</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="col-md-12" id="search" style="text-align:right;margin-bottom:10px;">
						<button type="button" class="btn btn-success btn-sm" onclick="fn_new();"> 등 록 </button>
					</div>

					<div id="search_layer"></div>
					<div id="paging_layer" class="s_paging"></div>
					<!-- /List -->
				</form>

			</div>
			<div class="col-lg-1"></div>
		</div>
		<!--END BLOCK SECTION -->
		<div class="col-lg-3"></div>

	</div>
	<!--END PAGE CONTENT -->





<%@ include file="/WEB-INF/views/common/_footer.jsp"%>
