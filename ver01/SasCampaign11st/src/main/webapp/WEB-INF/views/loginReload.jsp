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
		if (loginYn == "True") {
			//console.log("true");
			setTimeout("top.ajax_login('True')", 1000);
		} else {
			alert("오류가 발생했습니다.");
		}
	}); // ready close

	function getParameterByName(name) {
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
		results = regex.exec(location.search);
		return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	}
</script>

</head>
<!-- END HEAD -->

<!-- BEGIN BODY -->
<body class="padTop53 ">
</body>
</html>
