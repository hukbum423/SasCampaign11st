<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<!-- BEGIN HEAD -->
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" /> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>11st Campaign </title>
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<meta content="" name="description" />
<meta content="" name="author" />
<!--[if IE]>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<![endif]-->
<!-- GLOBAL STYLES -->
<link rel="stylesheet"
	href="${staticPATH }/assets/plugins/bootstrap/css/bootstrap.css" />
<link rel="stylesheet" href="${staticPATH }/assets/css/main.css" />
<link rel="stylesheet" href="${staticPATH }/assets/css/theme.css" />
<link rel="stylesheet" href="${staticPATH }/assets/css/MoneAdmin.css" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/Font-Awesome/css/font-awesome.css" />

<link rel="stylesheet" href="${staticPATH }/css/common.css" />

<!--END GLOBAL STYLES -->

<!-- GLOBAL SCRIPTS -->
<script src="${staticPATH }/assets/plugins/jquery-2.0.3.min.js"></script>
<script
	src="${staticPATH }/assets/plugins/bootstrap/js/bootstrap.min.js"></script>
<script
	src="${staticPATH }/assets/plugins/modernizr-2.6.2-respond-1.1.0.min.js"></script>
<!-- END GLOBAL SCRIPTS -->

<script src="${staticPATH }/js/common/common.js"></script>

<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
	  <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
	  <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
	<![endif]-->
  
<script language="javascript">
function logout(){
  location.href="${staticPATH }/logout.do";
}

function wrapWindowByMask() {
  //화면의 높이와 너비를 구한다.
  var maskHeight = $(document).height(); 
//var maskWidth = $(document).width();
  var maskWidth = window.document.body.clientWidth;
   
  var mask = "<div id='mask' style='position:absolute; z-index:9000; background-color:#000000; display:none; left:0; top:0;'></div>";
  var loadingImg = '';
   
  loadingImg += "<div id='loadingImg' style='position:absolute; left:50%; top:40%; display:none; z-index:10000;'>";
  loadingImg += " <img src='${staticPATH }/image/loading.gif'/>";
  loadingImg += "</div>";  

  //화면에 레이어 추가
  $('body')
      .append(mask)
      .append(loadingImg)
     
  //마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채운다.
  $('#mask').css({
          'width' : maskWidth
          , 'height': maskHeight
          , 'opacity' : '0.3'
  }); 

  //마스크 표시
  $('#mask').show();   

  //로딩중 이미지 표시
  $('#loadingImg').show();
}

function closeWindowByMask() {
  $('#mask, #loadingImg').hide();
  $('#mask, #loadingImg').remove();  
}
</script>


</head>

<!-- END HEAD -->

<!-- BEGIN BODY -->
<body class="padTop53 " >

	<!-- MAIN WRAPPER -->
	<div id="wrap">


		<!-- HEADER SECTION -->
		<div id="top">

			<nav class="navbar navbar-inverse navbar-fixed-top " style="padding-top: 10px;">
				
				<!-- LOGO SECTION -->
				<a href="${staticPATH }/main.do">
          <img src="${staticPATH }/image/logo_sub.png" style="padding-left:20px;" > <span style="margin-left:20px;font-size:24px;position: absolute;bottom:0;font-weight:200;">Campaign</span></a>
						
				<!-- 	<header class="navbar-header">

					<a href="index.html" class="navbar-brand">
					<img src="/assets/img/logo.png" alt="" />
						
						</a>
				</header>	 -->
				<!-- END LOGO SECTION -->
				<ul class="nav navbar-top-links navbar-right" style="padding-right:30px;">
          ${sessionScope.sessionVo.userId}님이 로그인 하셨습니다.&nbsp;&nbsp;&nbsp;
         <button class="btn btn-sm text-muted text-danger btn-danger pull-right" onclick="logout();"><b><i class="glyphicon glyphicon-log-out"></i> SignOut</b></button>
				</ul>

			</nav>

		</div>
		<!-- END HEADER SECTION -->