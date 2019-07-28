<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->

<!-- BEGIN HEAD -->
<head>
<meta charset="UTF-8" />
<title>11st Campaign </title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<meta content="" name="description" />
<meta content="" name="author" />
<!--[if IE]>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<![endif]-->

<!-- GLOBAL STYLES -->
<link rel="stylesheet" href="${staticPATH }/assets/plugins/bootstrap/css/bootstrap.css" />
<link rel="stylesheet" href="${staticPATH }/assets/css/main.css" />
<link rel="stylesheet" href="${staticPATH }/assets/css/theme.css" />
<link rel="stylesheet" href="${staticPATH }/assets/css/MoneAdmin.css" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/Font-Awesome/css/font-awesome.css" />
<link rel="stylesheet" href="${staticPATH }/assets/css/layout2.css"  />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/flot/examples/examples.css" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />

<!--END GLOBAL STYLES -->

<!-- GLOBAL SCRIPTS -->
<script src="${staticPATH }/assets/plugins/jquery-2.0.3.min.js"></script>
<script src="${staticPATH }/assets/plugins/bootstrap/js/bootstrap.min.js"></script>
<script src="${staticPATH }/assets/plugins/modernizr-2.6.2-respond-1.1.0.min.js"></script>
<!-- END GLOBAL SCRIPTS -->

<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	<script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
<![endif]-->

<script src="${staticPATH }/assets/js/login.js"></script>
<script src="${staticPATH }/js/common/common.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		var loginYn = getParameterByName('login_yn');
		var userid = getParameterByName('userid');
		if (!true) {
			console.log("KANG: loginYn: " + loginYn);
			console.log("KANG: userid: " + userid);
			console.log("KANG: userInputId: " + getCookie("userInputId"));
			console.log("KANG: id: " + $("#id").val());
			alert("pause");
		}
		
		if (loginYn == "True" && userid != "") {
			//console.log("true");
			$("#id").val(userid);
			//console.log(userid);
			ajax_login();
		}

		$('#id').focus();

		$('body').keypress(function(e){
			if(e.keyCode!=13) return;
			checkinput();
		}); // body keypress close

		$('#loginBtn').click(function(event){
			checkinput();
		});

		var checkinput = function(){
			if (!$('input[name="id"]').val()) {
				alert("ID 를 입력 해주세요.");
				$('input[name="id"]').focus();
				return false;
			} else if (!$('input[name="pw"]').val()) {
				alert("Password 를 입력 해주세요.");
				$('input[name="pw"]').focus();
				return false;
			} else {
				setCookie("_username", $("#id").val(), 1);
				ajax_login(); return true;// KANG-20190313: comment -> auto login
			}  // if/else close

			//location.href="http://11campb-operwb-alp01:7980/SASStoredProcess/do?_program=/CM_META/41.STP/ci_check&_username=sasdemo&_password=qhdks1@30";

			//http://11campb-operwb-alp01:7980/SASStoredProcess/do?_program=/CM_META/41.STP/ci_check&_username=sasdemo&_password=qhdks1@30&param=http://localhost/SASCampaign/login.do

			//ajax_login();
			//console.log($("#frameLogin").contents().html());

			$("#_username").val($("#id").val());
			$("#_password").val($("#pw").val());

			console.log("userid : "+ $("#_username").val() );
			//console.log("passwd : "+ $("#_password").val() );
			
			setCookie("_username", $("#_username").val(), 1);

			var f = document.frm;
			//f.target = "_self";  // http://11campb-operwb-alp01:7980
			f.action="${staticPATHSasurl }/SASStoredProcess/do?_program=/CM_META/41.STP/ci_check&param=${staticURL }/SASCampaign/login.do";
			f.submit();
		}

		// 공지사항 조회
		fn_search();

		// 저장된 쿠키값을 가져와서 ID 칸에 넣어준다. 없으면 공백으로 들어감.
		var userInputId = getCookie("userInputId");
		$("input[name='id']").val(userInputId);

		if($("input[name='id']").val() != ""){ // 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
			$("#idSaveCheck").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
		}

		$("#idSaveCheck").change(function(){ // 체크박스에 변화가 있다면,
			if ($("#idSaveCheck").is(":checked")){ // ID 저장하기 체크했을 때,
				var userInputId = $("input[name='id']").val();
				setCookie("userInputId", userInputId, 7); // 7일 동안 쿠키 보관
			} else { // ID 저장하기 체크 해제 시,
				deleteCookie("userInputId");
			}
		});

		// ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
		$("input[name='id']").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
			if($("#idSaveCheck").is(":checked")){ // ID 저장하기를 체크한 상태라면,
				var userInputId = $("input[name='id']").val();
				setCookie("userInputId", userInputId, 7); // 7일 동안 쿠키 보관
			}
		});
	}); // ready close





	// ajax_login
	var ajax_login = function(){
		console.log("ajax_login call: _username = " + getCookie("_username"));
		try {
			$.ajax({
				type : "POST",
				data :{
					"id"  : getCookie("_username"),
					"pw"  : $("#pw").val(),
				},
				dataType: "json",
				async: false,
				jsonp: 'callback',
				url : '${staticPATH }/ajax_login_proc.do',
				//url : 'http://11campb-operwb-alp01:7980/SASStoredProcess/do?_program=/CM_META/41.STP/ci_check&_username=sasdemo&_password=qhdks1@30',
				success : function(data, status) {
					console.log("data.code : " + data.code);
					console.log("getParameterByName('login_yn') : " + getParameterByName('login_yn'));
					if (data.code == '0') {
						location.href="${staticPATH }/main.do";
					} else {
						//$("#pw").val('');
						alert("오류가 발생했습니다.");
					}
				}
				,beforeSend:function(){
				}
				,complete:function(data){
					console.log("complete : " + data);
				}
				,callback:function(data){
					console.log("callback : " + data);
				}
				, error:function(xhr, status, error, data){
					console.log("xhr : " + xhr);
					console.log("data : " + data);
					console.log("status : " + status);
					console.log("error : " + error);
				}
			});
		} catch(e) {
			console.log("catch ----------------------");
			console.log(e);
		}
	}

	/* 공지사항 조회 */
	function fn_search() {
		jQuery.ajax({
			url           : '${staticPATH}/notice/getNoticeList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
			data          : {
				selectPageNo : "1"
			},
			success: function(result, option) {
				if (option=="success") {
					var list = result.NoticeList;
					var txt = "";
					var tmpi = 1;

					if (list.length > 0) {
						$.each(list, function(key) {
							var data = list[key];
							if (tmpi <= 5) {
								txt += '<div class="panel panel-default">';
								txt += '    <div class="panel-heading">';
								txt += '<h4 class="panel-title">';
								txt += '<a data-toggle="collapse" data-parent="#accordion" href="#collapse'+data.notice_no+'">'+nvl(data.title,'')+'</a>';
								txt += '</h4>';
								txt += '</div>';
								txt += '<div id="collapse'+data.notice_no+'" class="panel-collapse collapse">';
								txt += '<div class="panel-body">';
								txt += ''+nvl(data.content,'')+'<br/><br/>'+nvl(data.create_nm,'')+" | "+nvl(data.create_dt,'');
								txt += '</div>';
								txt += '</div>';
								txt += '</div>';
							}
							tmpi++;
						});
					} else {
						txt += '<div class="panel panel-default">데이터가 없습니다.</div>';
					}
					$("#accordion").html(txt);
				} else {
					alert("에러가 발생하였습니다.");
				}
			},
			error: function(result, option) {
				alert("에러가 발생하였습니다.");
			}
		});
	};


	// URL Parameter의 키(name)에 해당하는 값을 얻는다.
	function getParameterByName(name) {
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
		results = regex.exec(location.search);
		return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	}

	// 쿠키 생성
	function setCookie(cName, cValue, cDay){
		var expire = new Date();
		expire.setDate(expire.getDate() + cDay);
		cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
		if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
		document.cookie = cookies;
	}

	// 쿠키 가져오기. the same of the below
	/*
	function getCookie(cName) {
		cName = cName + '=';
		var cookieData = document.cookie;
		var start = cookieData.indexOf(cName);
		var cValue = '';
		if (start != -1) {
			start += cName.length;
			var end = cookieData.indexOf(';', start);
			if(end == -1)end = cookieData.length;
			cValue = cookieData.substring(start, end);
		}
		return unescape(cValue);
	}
	*/

	// 쿠키 값을 얻는다.
	function getCookie(cookieName) {
		cookieName = cookieName + '=';
		var cookieData = document.cookie;
		var start = cookieData.indexOf(cookieName);
		var cookieValue = '';
		if (start != -1) {
			start += cookieName.length;
			var end = cookieData.indexOf(';', start);
			if(end == -1)end = cookieData.length;
			cookieValue = cookieData.substring(start, end);
		}
		return unescape(cookieValue);
	}

	// 쿠키 값을 삭제한다.
	function deleteCookie(cookieName){
		var expireDate = new Date();
		expireDate.setDate(expireDate.getDate() - 1);
		document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
	}

</script>


</head>
<!-- END HEAD -->



<!-- BEGIN BODY -->
<body class="padTop53 ">
<!-- MAIN WRAPPER -->
<div id="wrap">

	<!-- PAGE CONTENT -->
	<div class="container">
		<div class="text-center" style="padding:30px 0px 40px 0px">
			<img src="${staticPATH }/image/logo.jpg"><!-- <h1><b>캠페인 시스템</b></h1> -->
		</div>
		<!-- Hidden Form -->
		<form name="frm" id="frm" method="post">
			<input type="hidden" name="_username" id="_username"/>
			<input type="hidden" name="_password" id="_password"/>
		</form>
		
		<div class="row">
			<div class="col-md-8">
				<div class="panel panel-danger">
					<div class="panel-heading ">
						<h4><b><i class="fa fa-bell"></i> 공지사항</b></h4>
					</div>
					<div class="panel-body">
						<div class="panel-group" id="accordion"> </div>
					</div>
				</div>
			</div>
	
			<div class="col-md-4">
				<div class="panel panel-info">
					<div class="panel-heading ">
						<h4><b><i class="fa fa-user"></i> Login</b></h4>
					</div>
					<div class="panel-body">
						<!-- Input items -->
						<div class="col-md-8" style="padding:10px 5px 10px 0px">
							<input value="" type="text" id="id" name="id" placeholder="관리자 아이디" class="form-control" style="margin:5px 5px 5px 0px"/>
							<input value="" type="password" id="pw" name="pw" placeholder="관리자 패스워드" class="form-control" style="margin:5px 5px 5px 0px"/>
							<input type="checkbox" name="idSaveCheck" id="idSaveCheck"> ID저장
						</div>
						<div class="col-md-4" style="padding:13px 5px 10px 0px">
							<button class="btn text-muted text-center btn-success pull-right" style="height:75px;width:100px;" id="loginBtn"><i class="fa fa-sign-in" aria-hidden="true"></i> Sign in</button>
						</div>
					</div>
				</div>
			</div>
			&nbsp;&nbsp;&nbsp;&nbsp;SAS메타데이터 서버에 사용자 등록후 로그인하세요!
		</div>
	</div>


	<!--END PAGE CONTENT -->

<%@ include file="/WEB-INF/views/common/_footer.jsp"%>
