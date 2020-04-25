<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>
<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->
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
  
    frm.action = "${staticPATH }/variable/variableList.do";
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
    url           : '${staticPATH }/setVariable.do',
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
    url           : '${staticPATH }/deleteVariable.do',
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
                   <li role="presentation" class="active">
                      <a href="${staticPATH }/variable/variableList.do">
                        <i class="fa fa-filter"></i> 매개변수 관리
                      </a>
                   </li>
                   <li role="presentation" class="">
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

	  <form name="form" id="form" method="post">
		<input type="hidden" id="TYPE" name="TYPE" value="${TYPE}" />
		<input type="hidden" id="SVARI_NAME" name="SVARI_NAME" value="${SVARI_NAME}" />
		<input type="hidden" id="SKEY_COLUMN" name="SKEY_COLUMN" value="${SKEY_COLUMN}" />  
        <div id="table">
          <table class="table table-striped table-hover table-condensed table-bordered">
		    <colgroup>
		      <col width="15%"/>
		      <col width="35%"/>
		      <col width="15%"/>
		      <col width="35%"/>
		    </colgroup>
            <tr>
	          <td class="info">매개변수명</td>
	          <td colspan="3">
	            <input type="text" id="VARI_NAME" name="VARI_NAME" style="width:120px;" value="${bo.vari_name}" maxlength="50"  class="txt"/>
	          </td>
            </tr>
            <tr>
		      <td class="info">키컬럼</td>
		      <td colspan="3">
		        <input type="text" id="KEY_COLUMN" name="KEY_COLUMN" style="width:160px;" value="${bo.key_column}" maxlength="50" class="txt"/>
		      </td>
		    </tr>
            <tr>
		      <td class="info">참조테이블</td>
		      <td colspan="3">
		        <input type="text" id="REF_TABLE" name="REF_TABLE" style="width:230px;" value="${bo.ref_table}" maxlength="50" class="txt"/>
		      </td>
            </tr>
	        <tr>
	          <td class="info">참조컬럼</td>
	          <td colspan="3">
	            <input type="text" id="REF_COLUMN" name="REF_COLUMN" style="width:160px;" value="${bo.ref_column}" maxlength="50" class="txt"/>
	          </td>
	        </tr>
	        <tr>
	          <td class="info">NULL대체값</td>
	          <td colspan="3">
	            <input type="text" id="IF_NULL" name="IF_NULL" style="width:160px;" value="${bo.if_null}" maxlength="50" class="txt"/>
	          </td>
	        </tr>
	        <tr>
	          <td class="info">최대Byte</td>
	          <td colspan="3">
	            <input type="text" id="MAX_BYTE" name="MAX_BYTE" style="width:100px;" value="${bo.max_byte}" maxlength="3" class="txt"/>
	          </td>
	        </tr>
	        <tr>
	          <td class="info">사용여부</td>
	          <td colspan="3">
	            <select id="USE_YN" name="USE_YN"  style="width: 50px;">
	              <option value="Y" <c:if test="${bo.use_yn eq 'Y' }">selected="selected"</c:if>>Y</option>
	              <option value="N" <c:if test="${bo.use_yn eq 'N' }">selected="selected"</c:if>>N</option>
	            </select>
	          </td>
	        </tr>     
	        <tr>
	          <td class="info">등록자</td>
	          <td>${bo.create_nm}</td>
	          <td class="info">등록일시</td>
	          <td>${bo.create_dt}</td>
	        </tr>
	        <tr>
	          <td class="info">수정자</td>
	          <td>${bo.update_nm}</td>
	          <td class="info">수정일시</td>
	          <td>${bo.update_dt}</td>
	        </tr>       
	      </table>
	    </div>
	    <div class="col-md-12" id="search" style="text-align:right;margin-bottom:10px;">
	      <%-- <c:if test="${USER.admin_yn eq 'Y' }">--%>
	        <button type="button" class="btn btn-danger btn-sm" id="btn_delete" onclick="fn_delete();">
            <i class="fa fa-trash-o" aria-hidden="true"></i> 삭 제
          </button>
	       <%-- </c:if> --%>
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
