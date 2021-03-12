<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>

<script language="JavaScript">
	
	/* ready */
	$(document).ready(function(){
		
		$( "#CREATE_DATE" ).datepicker(dateOption);
		$( "#UPDATE_DATE" ).datepicker(dateOption);
		
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; margin-bottom:-2px; vertical-align:middle;");
		
		var table_name = "${bo.table_name}";
		
		//상세 조회일경우 TABLE_NAME 수정 불가
		if(table_name != null && table_name !="" ){
			$("#TABLE_NAME").addClass("essentiality");
			$("#TABLE_NAME").attr("readonly",true);
			$("#TYPE").val("U");
		}else{
			$("#TYPE").val("I");
		}
	});


	/* 목록보기 */
	function fn_list() {
		var frm = document.form;
		
		frm.action = "/UnicaExt/tableInfoList.do";
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
			url           : '/UnicaExt/setTableInfoMst.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {
	        	if(option=="success"){
	        		if(result.dup =="Y"){
	        			alert("중복된 테이블명입니다");
	        			$("#TABLE_NAME").focus();
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
	
	
	/* 삭제 */
	function fn_delete() {
		
		if(!confirm("삭제 하시겠습니까?")){
			return;
		}
		
		jQuery.ajax({
			url           : '/UnicaExt/deleteTableInfoMst.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {
	        	if(option=="success"){
	        		
        			alert("삭제 되었습니다");
        			fn_list();
        			
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
		
		if($("#TABLE_NAME").val()==""){
			alert("테이블 명을 입력하세요");
			$("#TABLE_NAME").focus();
			return false;
		}

		return true;
	}

</script>
<!--PAGE CONTENT -->
<div id="content" style="width:100%; height100%;">
   <!--BLOCK SECTION -->
   <div class="row" style="width:100%; height100%;">
      <div class="col-lg-1"></div>
      <div class="col-lg-10">

         <div id="optionDiv" class="col-md-12" style="margin-top:15px;margin-right:0px;padding-right:0px;">
            <div style="display:flex">
              <div style="flex-basis: 100%;">
                <ul id="myTab" class="nav nav-tabs" role="tablist">
                   <li role="presentation" class="">
                      <a href="${staticPATH }/toast/toastList.do">
                        <i class="fa fa-info"></i> 토스트배너 관리 
                      </a>
                   </li>
                   <li role="presentation" class="">
                      <a href="${staticPATH }/testTarget/testTargetList.do" >
                        <i class="fa fa-cog" aria-hidden="true"></i> 테스트대상 관리
                      </a>
                   </li>
                   <li role="presentation" class="">
                      <a href="${staticPATH }/variable/variableList.do">
                        <i class="fa fa-filter"></i> 매개변수 관리
                      </a>
                   </li>
                   <li role="presentation" class="">
                      <a href="${staticPATH }/commCode/commCodeList.do">
                        <i class="fa fa-comments-o"></i> 공통코드 관리
                      </a>
                   </li>
                   <%-- <li role="presentation" class="active">
                      <a href="${staticPATH }/tableInfo/tableInfoList.do">
                        <i class="fa fa-calendar"></i> 테이블정보 관리
                      </a>
                   </li> --%>
                   <li role="presentation" class="">
                      <a href="${staticPATH }/notice/noticeList.do">
                        <i class="fa fa-calendar"></i> 공지사항 관리
                      </a>
                   </li>
                </ul>
              </div>
              <div class="push-right" style="flex-basis: 400px;"></div>
            </div>
            <div id="myTabContent" class="tab-content">
            
      <div class="col-md-12 page-header">
        <h3>테이블정보 마스터 등록 </h3>
      </div>
      
<form name="form" id="form">
<input type="hidden" id="TYPE" name="TYPE" value="" />
<input type="hidden" id="STABLE_NAME" name="STABLE_NAME" value="${STABLE_NAME}" />
<input type="hidden" id="selectPageNo"  name="selectPageNo" value="${selectPageNo}" />

	<div id="table">
		<table width="100%" class="table"  border="1" cellpadding="0" cellspacing="0" bordercolor="#D3E2EC" bordercolordark="#FFFFFF">
			<colgroup>
				<col width="130"/>
				<col width="250"/>
				<col width="130"/>
				<col width=""/>
			</colgroup>
			<tr>
				<th class="info">테이블명</th>
				<td class="tbtd_content" colspan="3">
					<input type="text" id="TABLE_NAME" name="TABLE_NAME" style="width:250px;" value="${bo.table_name}"  class="txt" maxlength="50"/>
				</td>
			</tr>
			<tr>
				<th class="info">생성일시</th>
				<td class="tbtd_content" colspan="3">
					<input type="text" id="CREATE_DATE" name="CREATE_DATE" style="width:65px;" value="${bo.create_date}" class="txt" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<th class="info">최종갱신일시</th>
				<td class="tbtd_content" colspan="3">
					<input type="text" id="UPDATE_DATE" name=UPDATE_DATE style="width:65px;" value="${bo.update_date}" class="txt" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<th class="info">갱신주기</th>
				<td class="tbtd_content" colspan="3">
					<input type="text" id="RECYCLE_PERIOD" name=RECYCLE_PERIOD style="width:120px;" value="${bo.recycle_period}" class="txt" maxlength="25"/>
				</td>
			</tr>			
			<tr>
				<th class="info">테이블 정보</th>
				<td class="tbtd_content" colspan="3">
					<textarea id="TABLE_DESC" name="TABLE_DESC" cols="50" rows="3">${bo.table_desc}</textarea>
				</td>
			</tr>
			<tr>
				<th class="info">등록자</th>
				<td class="tbtd_content">${bo.create_nm}</td>
				<th class="info">등록일시</th>
				<td class="tbtd_content">${bo.create_dt}</td>
			</tr>
			<tr>
				<th class="info">수정자</th>
				<td class="tbtd_content">${bo.update_nm}</td>
				<th class="info">수정일시</th>
				<td class="tbtd_content">${bo.update_dt}</td>
			</tr>
		</table>
	</div>	
	

	<div id="sysbtn">
			<c:if test="${USER.admin_yn eq 'Y' && bo.table_name != null }">
			    <button type="button" class="btn btn-success btn-sm" onclick="fn_delete();"><i class="fa fa-trash" aria-hidden="true"></i> 삭제</button>
			</c:if>
			<button type="button" class="btn btn-success btn-sm" onclick="fn_list();"><i class="fa fa-list" aria-hidden="true"></i> List</button>
			<c:if test="${USER.admin_yn eq 'Y' }">
				<button type="button" class="btn btn-success btn-sm" onclick="fn_save();"><i class="fa fa-floppy" aria-hidden="true"></i> 저장</button>
			</c:if>
	</div>
</div>
</form>
</div></div>
      </div>
              <div class="col-lg-1"></div>
          </div>
          <!--END BLOCK SECTION -->
          <div class="col-lg-3"></div>

        </div>
        <!--END PAGE CONTENT -->

<%@ include file="/WEB-INF/views/common/_footer.jsp"%>
