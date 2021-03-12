<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>
<%@ include file="/WEB-INF/views/common/_left.jsp"%>

<script>
		$(document).ready(function () {

			$("#moveList").click(function(){
				history.go(-1);
			});

		});
</script>

<!--PAGE CONTENT -->
<div id="content">
	<div class="inner">
		<div class="row">
			<div class="col-lg-12">
				<h3>회원 관리</h3>
			</div>
		</div>
		<hr />
		<div class="row">
			<div class="col-lg-12">
				<div class="box">
					<div id="collapseOne" class="accordion-body collapse in body">
						<form name="memberForm" class="form-horizontal"
							id="member-validate" method="post"
							action="/member/write" >
							
							<input type="hidden" name="user_num" id="user_num" value="<?=$list['user_num']?>" >

							<div class="form-group">
								<label class="control-label col-lg-4">아이디</label>
								<div class="col-lg-4">
									<label class="control-label">${view.userId}</label>
								</div>
							</div>
							<div class="form-group">
								<label class="control-label col-lg-4">이름</label>
								<div class="col-lg-4">
									<label class="control-label">${view.userName}</label>
								</div>
							</div>
							<div class="form-group">
								<label class="control-label col-lg-4">닉네임</label>
								<div class="col-lg-4">
									<label class="control-label">${view.userNick}</label>
								</div>
							</div>
							<div class="form-group">
								<label class="control-label col-lg-4">E-mail</label>
								<div class="col-lg-4">
									<label class="control-label">${view.userEmail}</label>
								</div>
							</div>
							<div class="form-group">
								<label class="control-label col-lg-4">핸드폰</label>
								<div class="col-lg-4">
									<label class="control-label">${view.userPhone}</label>
								</div>
							</div>

							<div class="form-group">
								<label class="control-label col-lg-4">프로필 사진</label>
								<div class="col-lg-8">
								<c:if test="${view.profileImg != '' && view.profileImg ne null}">
		                            <div class="fileupload fileupload-new"
										data-provides="fileupload">
										<input type="hidden">
										<div class="fileupload-preview thumbnail"
											style="width: 200px; height: 150px; line-height: 150px;">

											<img src="/data/member/${fn:substring(view.userId,0,2) }/${view.profileImg}">
										</div>
									</div>
								</c:if>
                            
		                        </div>
							</div>

							<div class="form-group">
								<label class="control-label col-lg-4">소개글</label>

								<div class="col-lg-4">
									<label class="control-label">${view.profileMemo}</label>
								</div>
							</div>

							<div class="form-actions no-margin-bottom">
								<div class="form-group">
									<div class="col-lg-12 text-center">
										<!-- <input type="submit" value="수정"
											class="btn btn-danger btn-line" />&nbsp;&nbsp; -->
										<input type="button" value="목록" id="moveList"
											class="btn btn-primary btn-line" />
									</div>
								</div>
							</div>
					</div>
					</form>
				</div>
			</div>
		</div>

	</div>
</div>
<!--END PAGE CONTENT -->
<%@ include file="/WEB-INF/views/common/_footer.jsp"%>