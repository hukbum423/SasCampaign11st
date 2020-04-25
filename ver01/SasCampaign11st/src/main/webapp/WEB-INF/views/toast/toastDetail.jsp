<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

    <!-- PAGE LEVEL STYLES -->
    <link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
    <link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="${staticPATH }/css/ui-lightness/jquery-ui.css">
    <link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
    <!-- END PAGE LEVEL  STYLES -->

    <!-- <link rel="stylesheet" href="http://c.011st.com/css/main/default_h5.css" type="text/css" > --><!-- 운영용 -->
    <link rel="stylesheet" href="${staticPATH }/css/default_h5.css" type="text/css" ><!-- 운영용에서 필요한 css 만 가져옴 -->

  <script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
  <script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script>
  <script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>


<script language="JavaScript">



$(document).ready(function(){
  
  $("#downBtn, #closeToday, #closeBtn ").bind("click",fn_pre_viewClose);
});




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
    url           : '${staticPATH }/toast/setToastDetail.do',
    dataType      : "JSON",
    scriptCharset : "UTF-8",
    type          : "POST",
        data          : $("#form").serialize(),
        success: function(result, option) {

          if(option=="success"){
            
            alert("저장되었습니다");
            
            //목록으로 가기
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

  if($("#TITLE").val() ==""){
    alert("토스트배너 타이틀을 입력하세요");
    $("#TITLE").focus();
    return false;
  }
  
  if($("#MSG").val() ==""){
    alert("메세지를 입력하세요");
    $("#MSG").focus();
    return false;
  }
  
  if($("#LINK_URL").val() ==""){
    alert("링크URL을 입력하세요");
    $("#LINK_URL").focus();
    return false;
  }

  return true;
}


/* 목록보기 */
function fn_list() {
  
  var frm = document.form;
  
  frm.action = "${staticPATH }/toast/toastList.do";
    frm.submit();
    
};  


//미리보기
function fn_pre_view(){
  
  if($("#TITLE").val() ==""){
    alert("토스트배너 타이틀을 입력하세요");
    $("#TITLE").focus();
    return;
  }
  
  if($("#MSG").val() ==""){
    alert("메세지를 입력하세요");
    $("#MSG").focus();
    return;
  }
  
  jQuery.ajax({
    url           : '${staticPATH }/channel/channelToastPreview.do',
    dataType      : "JSON",
    scriptCharset : "UTF-8",
    type          : "POST",
        data          : { TOAST_INPUT_MSG     : $("#MSG").val()  },
        success: function(result, option) {

          if(option=="success"){
            
            //사용자변수 적용된 미리보기
            $("#to_title").html("<strong>" + $("#TITLE").val() + "</strong>"); 
            
            $("#toastContWrap").html(
//                '<span class="txtbnr">' +
//                '<a href="#">'+
                result.TOAST_INPUT_MSG +
//            '</a>'+
//            '</span>'+
            ''
            );
            
            //$("#toastBannerWrap").slideToggle(1);
            $("#toastBannerWrap").show();

            
          }else{
            alert("에러가 발생하였습니다.");  
          }
        },
        error: function(result, option) {
          alert("에러가 발생하였습니다.");
        }
  });
  
}

/* 바로보기 닫기 */
function fn_pre_viewClose(){
  $("#toastBannerWrap").hide();
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
                   <li role="presentation" class="active">
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
              

<form name="form" id="form">
<input type="hidden" id="selectPageNo"  name="selectPageNo" value="${selectPageNo}" />
<input type="hidden" id="CAMPAIGN_MANG_CODE"  name="CAMPAIGN_MANG_CODE" value="${CAMPAIGN_MANG_CODE}" />
<input type="hidden" id="SCAMPAIGNCODE"  name="SCAMPAIGNCODE" value="${SCAMPAIGNCODE}" />
<input type="hidden" id="SDISP_BGN_DY"  name="SDISP_BGN_DY" value="${SDISP_BGN_DY}" />
  <div id="table">    
    <table width="100%" class="table table-striped table-hover table-condensed table-bordered">
      <colgroup>
          <col width="15%"/>
          <col width="35%"/>
          <col width="15%"/>
          <col width="35%"/>
      </colgroup>
      <tr>
        <td class="info">캠페인 코드/명</td>
        <td>[${bo.campaigncode}]${bo.campaignname}</td>
        <td class="info">고객 세그먼트</td>
        <td>${bo.cellnm}</td>
      </tr>
      <tr>
        <td class="info">노출기간</td>
        <td>${bo.disp_bgn_dy} ~ ${bo.disp_end_dy}</td>
        <td class="info">TR코드</td>
        <td>${bo.campaign_mang_code}</td>
      </tr>
    </table>
    

    <!-- 토스트 배너 -->
    <div style="padding-top: 5px;">
      <table width="100%"  class="table table-striped table-hover table-condensed table-bordered">
        <colgroup>
          <col width="15%"/>
          <col width="35%"/>
          <col width="15%"/>
          <col width="35%"/>
        </colgroup>
        <tr>
          <td class="info">토스트배너 타이틀</td>
          <td colspan="3">
            <input type="text" id="TITLE" name="TITLE" style="width: 450px;" maxlength="200" value="${bo.title}" class="txt" maxlength="500"/>
          </td>
        </tr>
        <tr>
          <td class="info">메세지</td>
          <td colspan="3">
            <textarea name="MSG" id="MSG" rows="10" cols="140">${bo.msg}</textarea>
          </td>       
        </tr>
        <tr>
          <td class="info">링크URL</td>
          <td colspan="3"><input type="text" id="LINK_URL" name="LINK_URL" style="width: 550px;" value="${bo.link_url}" maxlength="200" class="txt" maxlength="250"/></td>
        </tr>
        <tr>
          <td class="info">메세지설명</td>
          <td colspan="3"><input type="text" id="MSG_DESC" name="MSG_DESC" style="width: 550px;" value="${bo.msg_desc}" maxlength="300" class="txt" maxlength="50"/></td>        
        </tr>     
        <tr>
          <td class="info">노출순위</td>
          <td colspan="3">
            <select id="DISP_RNK" name="DISP_RNK"  style="width:60px;">
              <c:forEach var="val" items="${priority_rank}">
                <c:if test="${ val.code_id != 'N'  }">  
                  <option value="${val.code_id}" <c:if test="${val.code_id eq bo.disp_rnk}">selected="selected"</c:if>>
                    ${val.code_name}
                  </option>
                </c:if>
              </c:forEach>
            </select>
          </td>       
        </tr>
        <tr>
          <td class="info">이벤트타입</td>
          <td colspan="3">${bo.evnt_typ_cd}</td>
        </tr>
        <tr>
          <td class="info">사용여부</td>
          <td>
            <select id="USE_YN" name="USE_YN"  style="width:55px;">
              <option value="Y" <c:if test="${bo.use_yn eq 'Y' }">selected="selected"</c:if>>Y</option>
              <option value="N" <c:if test="${bo.use_yn eq 'N' }">selected="selected"</c:if>>N</option>
            </select>
          </td>
          <td class="info">반영여부</td>
          <td>${bo.sync_yn}</td>
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
  </div>    

  <div class="col-md-12" id="search" style="text-align:right;margin-bottom:10px;">
    <button type="button" class="btn btn-success btn-sm" onclick="fn_list();"><i class="fa fa-list" aria-hidden="true"></i>  목 록 </button>
      <button type="button" class="btn btn-warning btn-sm" onclick="fn_pre_view();"><i class="fa fa-eye" aria-hidden="true"></i> 미리보기 </button>
    <%-- <c:if test="${user.admin_yn eq 'Y' }"> --%>
      <button type="button" class="btn btn-danger btn-sm" onclick="fn_save();"><i class="fa fa-floppy-o" aria-hidden="true"></i> 저 장 </button>
    <%-- </c:if> --%>
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
                      
                      
        
        <div class="html_ToastNone2" id="toastBannerWrap" style="display: none; bottom: 0px;">
  <div class="toastbanner_bar2" id="toastTitle">
    <div class="tit">

      <!-- 토스트배너 타이틀 영역 -->
      <span id="to_title"></span>
      <!-- 토스트배너 타이틀 영역 -->

    </div>
    <a class="btn_down" id="downBtn"><em>내리기</em></a>
  </div>
  <div class="toastbanner_wrap2">
    <div class="toast_cnt" id="toastContWrap" style="padding-left: 11px; padding-top: 12px;">

      <!-- 토스트배너 메시지 영역 -->
      <!-- 토스트배너 메시지 영역 -->

    </div>
    <div class="toast_today2" style="margin-top: -13px;">
      <a class="btn_today" id="closeToday"><em>오늘 다시 열지 않기</em></a>
      <a class="btn_close" id="closeBtn" href="#"><em>닫기</em></a>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/_footer.jsp"%>
