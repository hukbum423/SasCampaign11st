<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">


<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Campaign</title>

<link rel="stylesheet" type="text/css" href="${staticPATH }/UnicaExt/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${staticPATH }/UnicaExt/css/ui-lightness/jquery-ui.css">
<script src="${staticPATH }/UnicaExt/js/common/jquery.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${staticPATH }/UnicaExt/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/UnicaExt/js/common/jquery.min.js"></script>
<script type="text/javascript" src="${staticPATH }/UnicaExt/js/common/common.js"></script>

<script language="JavaScript">

	/* ready */
	$(document).ready(function(){

// 		=================================================
		// 화면타이틀값 : 메뉴명칭
		if(window.location != window.parent.location){ //iframe일경우에만
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
// 		=================================================
	
	
		//조회
		fn_search();
	});
	

	/* 조회 */
	function fn_search() {
		

		jQuery.ajax({
			url           : '/UnicaExt/getVariableList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : { SVARI_NAME   : $("#SVARI_NAME").val(),
	        	              SKEY_COLUMN  : $("#SKEY_COLUMN").val()
	        },
	        success: function(result, option) {
	        	if(option=="success"){
		        	var list = result.VariableList;
		        	
		        	var txt ="";
		        	txt += "<table width='100%' border='0' cellpadding='0' cellspacing='0'>";
		        	if(list.length>0){
						txt += "<colgroup>";
						txt += "<col width='40'/>";
						txt += "<col width='100'/>";
						txt += "<col width='100'/>";
						txt += "<col width=''/>";
						txt += "<col width='100'/>";
						txt += "<col width='100'/>";
						txt += "<col width='100'/>";
						txt += "<col width='80'/>";
						txt += "<col width='100'/>";
						txt += "<col width='140'/>";
						txt += "</colgroup>";

						var num = 1;
						$.each(list, function(key){
			        		var data = list[key];
			        		txt += "<tr>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+num+++"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_getTestTargetDtl('"+data.vari_name+"');\" class='link'>"+nvl(data.vari_name,'')+"</a></td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.key_column,'')+"</a></td>";
							txt += "<td align=\"left\"   class=\"listtd\">"+nvl(data.ref_table,'')+"</a></td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.ref_column,'')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.if_null,'')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.max_byte,'')+"</td>";
			        		txt += "<td align=\"center\"   class=\"listtd\">"+nvl(data.use_yn,'')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_nm,'')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_dt,'')+"</td>";
							txt += "</tr>";
			        	}); 
		        	}else{
		        		txt += "<td align=\"center\" class=\"listtd\" colspn=\"10\">데이터가 없습니다.</td>";	
		        	}
		        	//빈 row 채우기
		        	if(list.length > 0 && list.length < result.rowRange ){
		        		for(var i=list.length; i<result.rowRange; i++){
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


	/* 매개변수 상세보기 */
	function fn_getTestTargetDtl(vari_name){
		$("#VARI_NAME").val(vari_name);
		$("#TYPE").val("U");
		
		var frm = document.form;
		
		frm.action = "/UnicaExt/variableDetail.do";
	    frm.submit();
	}
	
	
	/* 등록페이지 이동 */
	function fn_new() {
		var frm = document.form;
		
		$("#TYPE").val("I");
		
    	frm.action = "/UnicaExt/variableDetail.do";
        frm.submit();
	};

	
	/* 조회버튼 클릭 */
	function fn_clcik_search(){	
		fn_search();		
	}
	
</script>
	
</head>

<body>
<form name="form" id="form">
<input type="hidden" id="VARI_NAME" name="VARI_NAME" value="" />
<input type="hidden" id="TYPE" name="TYPE" value="" />
<div id="content_pop">

	<!-- 타이틀 -->
	<div id="title">
		<ul>
			<li><img src="<c:url value='/img/btn/title_dot.gif'/>"> 매개변수 목록 </li>
		</ul>
	</div>
	<!-- // 타이틀 -->

	<div id="search">
		<ul>
			<li><span class="btn_blue_l"><a href="javascript:fn_clcik_search();" class="bt">조회</a><img src="<c:url value='/img/btn/btn_bg_r.gif'/>" style="margin-left:6px;"></span></li>
			<c:if test="${USER.admin_yn eq 'Y' }">
				<li><span class="btn_blue_l"><a href="javascript:fn_new();" class="bt">등록</a><img src="<c:url value='/img/btn/btn_bg_r.gif'/>" style="margin-left:6px;"></span></li>
			</c:if>
		</ul>	
	</div>
	
	<div id="table">
		<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#D3E2EC" bordercolordark="#FFFFFF" style="BORDER-TOP:#C2D0DB 2px solid; BORDER-LEFT:#ffffff 1px solid; BORDER-RIGHT:#ffffff 1px solid; BORDER-BOTTOM:#C2D0DB 1px solid; border-collapse: collapse;">
			<colgroup>
				<col width="150"/>
				<col width=""/>
				<col width="150"/>
				<col width=""/>
			</colgroup>
			<tr>
				<td class="tbtd_caption">변수명</td>
				<td class="tbtd_content">
					<input type="text" id="SVARI_NAME" name="SVARI_NAME" value="${SVARI_NAME}" style="width:120px;" class="txt"/>
				</td>
				<td class="tbtd_caption">키컬럼</td>
				<td class="tbtd_content">
					<input type="text" id="SKEY_COLUMN" name="SKEY_COLUMN" value="${SKEY_COLUMN}" style="width:120px;" class="txt"/>
				</td>
			</tr>
		</table>
	</div>
	
	<!-- List -->
	<div id="table">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="40"/>	<!-- No         -->			
				<col width="100"/>  <!-- 매개변수명 -->
				<col width="100"/>  <!-- 키컬럼     -->
				<col width=""/>     <!-- 참조테이블 -->
				<col width="100"/>  <!-- 참조컬럼   -->
				<col width="100"/>  <!-- NULL대체값 -->
				<col width="100"/>  <!-- 최대Byte -->
				<col width="80"/>   <!-- 사용여부   -->
				<col width="100"/>  <!-- 등록자     -->
				<col width="140"/>  <!-- 등록일시   -->
			</colgroup>	
			<tr>
				<th align="center">No</th>
				<th align="center">매개변수명</th>
				<th align="center">키컬럼</th>
				<th align="center">참조테이블</th>
				<th align="center">참조컬럼</th>
				<th align="center">NULL대체값</th>
				<th align="center">최대Byte</th>
				<th align="center">사용여부</th>
				<th align="center">등록자</th>
				<th align="center">등록일시</th>
			</tr>				  
		</table>
	</div>
	<div id="search_layer"></div>
	<!-- /List -->
		
</div>
</form>

</body>
</html>
