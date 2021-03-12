<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">


<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Campaign</title>

<link rel="stylesheet" type="text/css" href="${staticPATH }${staticPATH }/UnicaExt/css/common.css"/>
<link rel="stylesheet" type="text/css" href="/UnicaExt/css/ui-lightness/jquery-ui.css">
<script src="${staticPATH }/UnicaExt/js/common/jquery.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${staticPATH }/UnicaExt/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/UnicaExt/js/common/jquery.min.js"></script>
<script type="text/javascript" src="${staticPATH }/UnicaExt/js/common/common.js"></script>

<script language="JavaScript">
		
	/* ready */
	$(document).ready(function(){
		var type = "${TYPE}";
		
		if(type != null && type =="U" ){ //수정
			$("#VARI_NAME").addClass("essentiality");
			$("#VARI_NAME").attr("readonly",true);
			if("${USER.admin_yn}" =="Y"){
				$("#btn_delete").show();
			}
		}
	});
	

	/* 목록보기 */
	function fn_list() {
		var frm = document.form;
		
    	frm.action = "/UnicaExt/variableList.do";
        frm.submit();
	};	
	
	
	/* 등록 */
	function fn_save() {
		
		//유효성 체크
		if(!fn_validation()){
			return;
		}
		
		if(!confirm("저장 하시겠습니까?")){
			return;
		}
		
		jQuery.ajax({
			url           : '/UnicaExt/setVariable.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
	        		
	        		if(result.valiChk !="Y"){
	        			alert(result.valiChk);	
	        		}else if(result.dup == "Y"){
	        			alert("이미 등록된 매개변수명입니다");
	        		}else{
	        			alert("저장되었습니다");
	        			fn_list();
	        		}
		        	
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
		
	};	
	
	
	
	/* 유효성 체크 */
	function fn_validation() {
		
		if($("#VARI_NAME").val()==""){
			alert("매개변수명을 입력하세요");
			$("#VARI_NAME").focus();
			return false;
		}
		
		if($("#KEY_COLUMN").val()==""){
			alert("키컬럼을 입력하세요");
			$("#KEY_COLUMN").focus();
			return false;
		}

		if(!isNaN($("#KEY_COLUMN").val())){
			alert("키컬럼은 숫자를 입력할수 없습니다");
			$("#KEY_COLUMN").focus();
			return false;
		}
		
		
		if($("#REF_TABLE").val()==""){
			alert("참조테이블을 입력하세요");
			$("#REF_TABLE").focus();
			return false;
		}
		
		if(!isNaN($("#REF_TABLE").val())){
			alert("참조테이블은 숫자를 입력할수 없습니다");
			$("#REF_TABLE").focus();
			return false;
		}
		
		if($("#REF_COLUMN").val()==""){
			alert("참조컬럼을 입력하세요");
			$("#REF_COLUMN").focus();
			return false;
		}

		if(!isNaN($("#REF_COLUMN").val())){
			alert("참조컬럼은 숫자를 입력할수 없습니다");
			$("#REF_COLUMN").focus();
			return false;
		}
		
		if($("#IF_NULL").val()==""){
			alert("NULL 대체값을 입력하세요");
			$("#IF_NULL").focus();
			return false;
		}

		if($("#MAX_BYTE").val()==""){
			alert("최대Byte를 입력하세요");
			$("#MAX_BYTE").focus();
			return false;
		}
		
		return true;
	}


	/* 테스트 고객ID 삭제 */
	function fn_delete(){
		
		if(!confirm("삭제 하시겠습니까?")){
			return;
		}
		
		jQuery.ajax({
			url           : '/UnicaExt/deleteVariable.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : {VARI_NAME    : $("#VARI_NAME").val()
	        },
	        success: function(result, option) {
	        	if(option=="success"){

        			alert("삭제되었습니다");
        			fn_list();
	        	
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
		
	}
	
</script>

</head>
<body>

<form name="form" id="form">
<input type="hidden" id="TYPE" name="TYPE" value="${TYPE}" />
<input type="hidden" id="SVARI_NAME" name="SVARI_NAME" value="${SVARI_NAME}" />
<input type="hidden" id="SKEY_COLUMN" name="SKEY_COLUMN" value="${SKEY_COLUMN}" />
<div id="content_pop">

	<!-- 타이틀 -->
	<div id="title">
		<ul>
			<li><img src="<c:url value='/img/btn/title_dot.gif'/>"> 매개변수 등록 </li>
		</ul>
	</div>
	<!-- // 타이틀 -->
	

	<div id="table">
		<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#D3E2EC" bordercolordark="#FFFFFF" style="BORDER-TOP:#C2D0DB 2px solid; BORDER-LEFT:#ffffff 1px solid; BORDER-RIGHT:#ffffff 1px solid; BORDER-BOTTOM:#C2D0DB 1px solid; border-collapse: collapse;">
			<colgroup>
				<col width="130"/>
				<col width="250"/>
				<col width="130"/>
				<col width=""/>
			</colgroup>
			<tr>
				<td class="tbtd_caption">매개변수명</td>
				<td class="tbtd_content" colspan="3">
					<input type="text" id="VARI_NAME" name="VARI_NAME" style="width:120px;" value="${bo.vari_name}" maxlength="50"  class="txt"/>
				</td>
			</tr>
			<tr>
				<td class="tbtd_caption">키컬럼</td>
				<td class="tbtd_content" colspan="3">
					<input type="text" id="KEY_COLUMN" name="KEY_COLUMN" style="width:160px;" value="${bo.key_column}" maxlength="50" class="txt"/>
				</td>
			</tr>
			<tr>
				<td class="tbtd_caption">참조테이블</td>
				<td class="tbtd_content" colspan="3">
					<input type="text" id="REF_TABLE" name="REF_TABLE" style="width:230px;" value="${bo.ref_table}" maxlength="50" class="txt"/>
				</td>
			</tr>
			<tr>
				<td class="tbtd_caption">참조컬럼</td>
				<td class="tbtd_content" colspan="3">
					<input type="text" id="REF_COLUMN" name="REF_COLUMN" style="width:160px;" value="${bo.ref_column}" maxlength="50" class="txt"/>
				</td>
			</tr>
			<tr>
				<td class="tbtd_caption">NULL대체값</td>
				<td class="tbtd_content" colspan="3">
					<input type="text" id="IF_NULL" name="IF_NULL" style="width:160px;" value="${bo.if_null}" maxlength="50" class="txt"/>
				</td>
			</tr>
			<tr>
				<td class="tbtd_caption">최대Byte</td>
				<td class="tbtd_content" colspan="3">
					<input type="text" id="MAX_BYTE" name="MAX_BYTE" style="width:100px;" value="${bo.max_byte}" maxlength="3" class="txt"/>
				</td>
			</tr>
			<tr>
				<td class="tbtd_caption">사용여부</td>
				<td class="tbtd_content" colspan="3">
					<select id="USE_YN" name="USE_YN"  style="width: 50px;">
						<option value="Y" <c:if test="${bo.use_yn eq 'Y' }">selected="selected"</c:if>>Y</option>
						<option value="N" <c:if test="${bo.use_yn eq 'N' }">selected="selected"</c:if>>N</option>
					</select>
				</td>
			</tr>			
			<tr>
				<td class="tbtd_caption">등록자</td>
				<td class="tbtd_content">${bo.create_nm}</td>
				<td class="tbtd_caption">등록일시</td>
				<td class="tbtd_content">${bo.create_dt}</td>
			</tr>
			<tr>
				<td class="tbtd_caption">수정자</td>
				<td class="tbtd_content">${bo.update_nm}</td>
				<td class="tbtd_caption">수정일시</td>
				<td class="tbtd_content">${bo.update_dt}</td>
			</tr>				
		</table>
	</div>	
	

	<div id="sysbtn">
		<ul>
			<c:if test="${USER.admin_yn eq 'Y' }">
				<li><span class="btn_blue_l" id="btn_delete" style="display: none;"><a href="javascript:fn_delete();" class="bt">삭제</a><img src="<c:url value='/img/btn/btn_bg_r.gif'/>" style="margin-left:6px;"></span></li>
			</c:if>
			<li><span class="btn_blue_l"><a href="javascript:fn_list();" class="bt">List</a><img src="<c:url value='/img/btn/btn_bg_r.gif'/>" style="margin-left:6px;"></span></li>
			<c:if test="${USER.admin_yn eq 'Y' }">
				<li><span class="btn_blue_l"><a href="javascript:document.form.reset();" class="bt">초기화</a><img src="<c:url value='/img/btn/btn_bg_r.gif'/>" style="margin-left:6px;"></span></li>
				<li><span class="btn_blue_l"><a href="javascript:fn_save();" class="bt">저장</a><img src="<c:url value='/img/btn/btn_bg_r.gif'/>" style="margin-left:6px;"></span></li>
			</c:if>
		</ul>
	</div>
		
</div>
</form>

</body>
</html>
