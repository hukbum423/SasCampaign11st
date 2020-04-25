<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

    <!-- PAGE LEVEL STYLES -->
    <link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
    <link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
    <link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
    <!-- END PAGE LEVEL  STYLES -->

<script  type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>
<script type="text/javascript" src="${staticPATH }/smartEdit/js/HuskyEZCreator.js" charset="utf-8"></script><!-- smartEdit2.0 -->

<script language="JavaScript">
var oEditors = [];

/* ready */
$(document).ready(function(){
  
  $( "#TOP_START_DT" ).datepicker(dateOption);
  $( "#TOP_END_DT" ).datepicker(dateOption);
  
  $("img.ui-datepicker-trigger").attr("style", "margin-left:3px; margin-bottom:-2px; vertical-align:middle;");

  
  //SMARTEDITOR 설정
  nhn.husky.EZCreator.createInIFrame({
    oAppRef: oEditors,
    elPlaceHolder: "CONTENT",
    sSkinURI: "${staticPATH }/smartEdit/SmartEditor2Skin.html",  
    htParams : {
      bUseToolbar : true,
      bUseVerticalResizer : false,
      bUseModeChanger : false,
      fOnBeforeUnload : function(){
      }
    },
    fOnAppLoad : function(){
    
    },
    fCreator: "createSEditor2"
  });

});


/* 목록보기 */
function fn_list() {
  var frm = document.form;
  
  frm.action = "${staticPATH }/notice/noticeList.do";
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
    url           : '${staticPATH }/notice/setNoticeDetail.do',
    dataType      : "JSON",
    scriptCharset : "UTF-8",
    type          : "POST",
        data          : $("#form").serialize(),
        success: function(result, option) {
          if(option=="success"){
            
            alert("저장 되었습니다");
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
  
  if($("#TITLE").val()==""){
    alert("제목을 입력하세요");
    $("#TITLE").focus();
    return false;
  }
  
  oEditors.getById["CONTENT"].exec("UPDATE_CONTENTS_FIELD", []);
  if($("#CONTENT").val()==""){
    alert("내용을 입력하세요");
    $("#CONTENT").focus();
    return false;
  }

  return true;
}


/* 공지사항 삭제 */
function fn_delete(){
  
  if(!confirm("삭제 하시겠습니까?")){
    return;
  }
  
  jQuery.ajax({
    url           : '/notice/delteNoticeDetail.do',
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
                   <%-- <li role="presentation" class="">
                      <a href="${staticPATH }/tableInfo/tableInfoList.do">
                        <i class="fa fa-calendar"></i> 테이블정보 관리
                      </a>
                   </li> --%>
                   <li role="presentation" class="active">
                      <a href="${staticPATH }/notice/noticeList.do">
                        <i class="fa fa-calendar"></i> 공지사항 관리
                      </a>
                   </li>
                </ul>
              </div>
              <div class="push-right" style="flex-basis: 400px;"></div>
            </div>
            <div id="myTabContent" class="tab-content" style="padding-bottom:60px;">

<form name="form" id="form">
<input type="hidden" id="selectPageNo"  name="selectPageNo" value="${selectPageNo}" />
<input type="hidden" id="NOTICE_NO"  name="NOTICE_NO" value="${bo.notice_no}" />


  <div id="table">
    <table width="100%" class="table table-bordered">
      <colgroup>
        <col width="15%"/>
        <col width="25%"/>
        <col width="15%"/>
        <col width="35%"/>
      </colgroup>
      <tr>
        <td class="info">제목</td>
        <td class="tbtd_content" colspan="3">
          <input type="text" id="TITLE" name="TITLE" style="width:450px;" value="${bo.title}"  class="txt" maxlength="125"/>
        </td>
      </tr>
      <tr>
        <td class="info">내용</td>
        <td class="tbtd_content" colspan="3">
          <textarea name="CONTENT" id="CONTENT" style="display:none;">${bo.content}</textarea>
        </td>
      </tr>
      <!-- 
      <tr>
        <td>상위노출 일자</td>
        <td class="tbtd_content" colspan="3">
          <input type="text" id="TOP_START_DT" name=TOP_START_DT style="width:65px;" value="${bo.top_start_dt}" class="txt" readonly="readonly"/> ~
          <input type="text" id="TOP_END_DT" name=TOP_END_DT style="width:65px;" value="${bo.top_end_dt}" class="txt" readonly="readonly"/>
        </td>
      </tr>
      <tr>
        <td>노출여부</td>
        <td class="tbtd_content" colspan="3">
          <select name="DISP_YN" id="DISP_YN" style="width: 50px;">
            <option value="Y" <c:if test="${bo.disp_yn eq 'Y'}">selected="selected"</c:if>>Y</option>
            <option value="N" <c:if test="${bo.disp_yn eq 'N'}">selected="selected"</c:if>>N</option>
          </select>
        </td>
      </tr>
      -->
      <tr>
        <td class="info">등록자</td>
        <td class="tbtd_content">${bo.create_nm}</td>
        <td class="info">등록일시</td>
        <td class="tbtd_content">${bo.create_dt}</td>
      </tr>
      <!-- 
      <tr>
        <td>수정자</td>
        <td class="tbtd_content">${bo.update_nm}</td>
        <td>수정일시</td>
        <td class="tbtd_content">${bo.update_dt}</td>
      </tr>
      -->
    </table>
  </div>  


  <div class="col-md-12" id="search" style="text-align:right;margin-bottom:10px;">
    <button type="button" class="btn btn-success btn-sm" onclick="fn_list();"><i class="fa fa-list-alt"></i> 목 록 </button>
  <c:if test="${bo.notice_no != null && bo.create_id eq getId}">
    <button type="button" class="btn btn-success btn-sm" onclick="fn_delete();"><i class="fa fa-trash-o" aria-hidden="true"></i> 삭 제 </button>
    <button type="button" class="btn btn-danger btn-sm" onclick="fn_save();"><i class="fa fa-save" aria-hidden="true"></i> 저 장 </button>
  </c:if>
  <c:if test="${bo.notice_no == null}">
    <button type="button" class="btn btn-danger btn-sm" onclick="fn_save();"><i class="fa fa-save"></i> 저 장 </button>
  </c:if>
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
