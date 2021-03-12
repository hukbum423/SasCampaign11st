<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>

<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!--> <html lang="en"> <!--<![endif]-->

<!-- BEGIN HEAD -->
<head>
     <meta charset="UTF-8" />
    <title>11st Campaign </title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
	<meta content="" name="description" />
	<meta content="" name="author" />
     <!--[if IE]>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <![endif]-->
    <!-- GLOBAL STYLES -->
     <!-- PAGE LEVEL STYLES -->
     <link rel="stylesheet" href="${staticURL }/assets/plugins/bootstrap/css/bootstrap.css" />
    <link rel="stylesheet" href="${staticURL }/assets/css/login.css" />
    <link rel="stylesheet" href="${staticURL }/assets/plugins/magic/magic.css" />
     <!-- END PAGE LEVEL STYLES -->
   <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
    
      <!-- PAGE LEVEL SCRIPTS -->
		<script src="${staticURL }/assets/plugins/jquery-2.0.3.min.js"></script>
		<script src="${staticURL }/assets/plugins/bootstrap/js/bootstrap.js"></script>
		<script src="${staticURL }/assets/js/login.js"></script>
      <!--END PAGE LEVEL SCRIPTS -->
    
</head>
    <!-- END HEAD -->

    <!-- BEGIN BODY -->
<body >

   <!-- PAGE CONTENT --> 
    <div class="container">
    <div class="text-center">
    </div>
    <div class="tab-content">
        <div id="login" class="tab-pane active">
            <div class="form-signin">
                <p class="text-muted text-center btn-block btn btn-primary btn-rect">
                    11st Campaign Administrator Login
                </p>
                <br/>
                <br/>
                <div class="col-md-12 text-center">
                	관리자 접근권한이 없습니다.
                <br/>
                <br/>
                <a href="/login.do">Login</a>
                </div>
            </div>
        </div>
    </div>

</div>

	  <!--END PAGE CONTENT -->     
	      
</body>
    <!-- END BODY -->
</html>
