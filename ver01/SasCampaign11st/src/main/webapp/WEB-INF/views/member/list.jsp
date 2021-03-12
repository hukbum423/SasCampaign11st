<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>
<%@ include file="/WEB-INF/views/common/_left.jsp"%>

<script type="text/javascript">
	$(document)
		.ready(
			function() {
				$('button[id^=user_auth_]')
					.click(
						function(event) {
							var str = event.target.id;
							var user_num = str.split('_');

							var user_id = $(
									"#user_id_" + user_num[2])
									.text();

							$("#user_id").val(user_id);
							$("#span_user_id").text(user_id);

							$
							.ajax({
								type : "POST",
								data : {
									'user_id' : user_id,
								},
								dataType : "json",
								url : '/member/ajax_user_type.do',
								success : function(data) {
									
									if (data.code == '0') {
										if (data.result['userType'] != '') {
											var user_type = data.result['userType']
													.split(',');

											for (i = 0; i < user_type.length; i++) {
												$("input:checkbox[name='user_type']:checkbox[value='" + user_type[i] + "']").prop("checked", true);
											}
										}
									} else {
										alert(data.msg);
									}
								},
								beforeSend : function() {
								},
								complete : function() {
								}
							});

						});

		$('#memberTypeSave').click(function(event) {
			$('#frmUserType').attr('method', 'post');
			$('#frmUserType').attr('action', '/member/user_type_proc.do').submit();
		});
	});
</script>

<!--PAGE CONTENT -->
<div id="content">
	<div class="inner">
		<div class="row">
			<div class="col-lg-12">
				<h3>공통코드 관리</h3>
			</div>
		</div>
		<hr />
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default">
					<div class="panel-body">
						<div>
							<div class="col-lg-6">
								<!-- <a href="/member/write"
									class="btn btn-danger btn-sm btn-line">등록</a> -->
							</div>
							<div class="col-lg-6" align="right">
								<span class='text-danger'> <i class="icon-star"> </i> 관리자
								</span> &nbsp;/&nbsp; <span> <i class="icon-user-md"> </i> 기획사
								</span> &nbsp;/&nbsp; <span> <i class="icon-music"> </i> 뮤지션
								</span>
							</div>
						</div>
						<div class="table-responsive">
							<table class="table table-hover" id="">
								<thead>
									<tr>
										<th>no</th>
										<th>ID</th>
										<th>닉네임</th>
										<th>이름</th>
										<th>Email</th>
										<th>등록일</th>
										<th>설정</th>
									</tr>
								</thead>
								<tbody>

									<c:forEach var="memberList" items="${list}" varStatus="status">

										<tr>
											<td>${memberList.userNum}</td>
											<td id="user_id_${memberList.userNum}"><a
												href="/member/view.do?num=${memberList.userNum}">${memberList.userId}</a></td>
											<td>${memberList.userNick}
												<c:if test="${memberList.userType != null }">
													<c:set var="userTypeData" value="${memberList.userType }" />
													<c:set var="userTypeSplit" value="${fn:split(userTypeData, ',') }"/>
													<c:forEach var="userType" items="${userTypeSplit}" varStatus="i">
														<c:if test="${userType == 'USER000099' }"><span class=text-danger><i class=icon-star> </i></span></c:if>
														<c:if test="${userType == 'USER000020' }"><i class='icon-user-md'> </i></c:if>
														<c:if test="${userType == 'USER000010' }"><i class='icon-music'> </i></c:if>
													</c:forEach>
												</c:if>
											</td>
											<td>${memberList.userName}</td>
											<td>${memberList.userEmail}</td>
											<td>${memberList.regDt}</td>
											<td><button type="button" class="btn btn-xs btn-success"
													id="user_auth_${memberList.userNum}" data-toggle="modal"
													data-target="#myModal">권한</button></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<div class="text-center">
						<%@ include file="/WEB-INF/views/common/_paging.jsp"%>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>
</div>
<!--END PAGE CONTENT -->

<!-- Modal -->
<form name="frmUserType" id="frmUserType">
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<input type="hidden" name="user_id" id="user_id">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">
						<span id="span_user_id"></span>권한설정
					</h4>
				</div>
				<div class="modal-body">

					<label><input type="checkbox" name="user_type"
						value="USER000099"> 관리자</label>&nbsp;&nbsp;&nbsp; <label><input
						type="checkbox" name="user_type" value="USER000020"> 기획사</label>&nbsp;&nbsp;&nbsp;
					<label><input type="checkbox" name="user_type"
						value="USER000010"> 뮤지션</label>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal"><i class="fa fa-times" aria-hidden="true"></i> Close</button>
					<button type="button" class="btn btn-primary" id="memberTypeSave"><i class="fa fa-floppy-o" aria-hidden="true"></i> 저장</button>
				</div>
			</div>
		</div>
	</div>
</form>

<%@ include file="/WEB-INF/views/common/_footer.jsp"%>