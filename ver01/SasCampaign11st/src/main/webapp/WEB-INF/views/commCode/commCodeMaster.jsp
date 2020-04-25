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
		var code_id = "${bo.comm_code_id}";
		
		//상세 조회일경우 code_id 수정 불가
		if(code_id != null && code_id !="" ){
			$("#COMM_CODE_ID").addClass("essentiality");
			$("#COMM_CODE_ID").attr("readonly",true);
			$("#TYPE").val("U");
		}else{
			$("#TYPE").val("I");
		}
	});


	/* 목록보기 */
	function fn_list() {
		var frm = document.form;
		
		frm.action = "${staticPATH }/commCode/commCodeList.do";
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
			url           : '${staticPATH }/setCommCodeMst.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {
	        	if(option=="success"){
	        		if(result.dup =="Y"){
	        			alert("코드ID가 중복입니다.");
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
		
		if($("#COMM_CODE_ID").val()==""){
			alert("코드ID를 입력하세요");
			$("#COMM_CODE_ID").focus();
			return false;
		}
		
		if($("#COMM_CODE_NAME").val()==""){
			alert("코드명을 입력하세요");
			$("#COMM_CODE_NAME").focus();
			return false;
		}
		
		if($("#USE_YN").val()==""){
			alert("사용여부를 선택하세요");
			$("#USE_YN").focus();
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
                   <li role="presentation" class="active">
                      <a href="${staticPATH }/commCode/commCodeList.do">
                        <i class="fa fa-comments-o"></i> 공통코드 관리
                      </a>
                   </li>
                   <%-- <li role="presentation" class="">
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
            <div id="myTabContent" class="tab-content" style="padding-bottom:60px;">
            
      <div class="col-md-12 page-header" style="margin-top:0px;">
        <h3>공통코드 마스터 등록 </h3>
      </div>
      
	  <form name="form" id="form">
		<input type="hidden" id="TYPE" name="TYPE" value="" />
		<input type="hidden" id="SCOMM_CODE_ID" name="SCOMM_CODE_ID" value="${SCOMM_CODE_ID}" />
		<input type="hidden" id="SCOMM_CODE_NAME" name="SCOMM_CODE_NAME" value="${SCOMM_CODE_NAME}" />
		<input type="hidden" id="selectPageNo"  name="selectPageNo" value="${selectPageNo}" />
		<div id="table">
	      <table width="100%" class="table"  border="1" cellpadding="0" cellspacing="0" bordercolor="#D3E2EC" bordercolordark="#FFFFFF">
			<colgroup>
			  <col width="15%"/>
	          <col width="25%"/>
	          <col width="15%"/>
	          <col width="35%"/>
			</colgroup>
			<tr>
			  <th class="info">코드ID</th>
			  <td class="tbtd_content" colspan="3">
				<input type="text" id="COMM_CODE_ID" name="COMM_CODE_ID" style="width:100px;" value="${bo.comm_code_id}" maxlength="6" class="txt"/>
			 </td>
		    </tr>
			<tr>
			  <th class="info">코드명</th>
			  <td class="tbtd_content" colspan="3">
				<input type="text" id="COMM_CODE_NAME" name="COMM_CODE_NAME" style="width:250px;" value="${bo.comm_code_name}" maxlength="50" class="txt"/>
		      </td>
			</tr>
			<tr>
			  <th class="info">코드설명</th>
				<td class="tbtd_content" colspan="3">
					<textarea id="CODE_DESC" name="CODE_DESC" cols="50" rows="3">${bo.code_desc}</textarea>
				</td>
			</tr>
			<tr>
			  <th class="info">정렬순서</th>
			  <td class="tbtd_content" colspan="3">
				<input type="text" id="SORT_SEQ" name="SORT_SEQ" style="width:80px;" value="${bo.sort_seq}" onkeydown="javascript:keypressNumber();" maxlength="6" class="txt"/>
			  </td>
			</tr>			
		   <tr>
			 <th class="info">사용여부</th>
			 <td class="tbtd_content" colspan="3">
			   <select id="USE_YN" name="USE_YN" >
				 <option value="Y" <c:if test="${bo.use_yn eq 'Y' }">selected="selected"</c:if>>Y</option>
				 <option value="N" <c:if test="${bo.use_yn eq 'N' }">selected="selected"</c:if>>N</option>
		       </select>
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
		<div id="sysbtn" class="col-md-12" style="text-align:right;margin-bottom:10px;">
		  <button type="button" class="btn btn-success btn-sm" onclick="fn_list();">
        <i class="fa fa-list" aria-hidden="true"></i> 목 록
      </button>
			<button type="button" class="btn btn-info btn-sm" onclick="document.form.reset();">
        <i class="fa fa-undo" aria-hidden="true"></i> 초기화
      </button>
	    <button type="button" class="btn btn-danger btn-sm" onclick="fn_save();">
        <i class="fa fa-floppy-o" aria-hidden="true"></i> 저 장
      </button>
		</div>
      </form>
      
      </div>
      </div>
    </div>
    <div class="col-lg-1"></div>
  </div>
  <!--END BLOCK SECTION -->
  <div class="col-lg-3"></div>
</div>
<!--END PAGE CONTENT -->

<%@ include file="/WEB-INF/views/common/_footer.jsp"%>
