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
		var type = "${TYPE}";
		
		if(type != null && type =="U" ){ //수정
			$("#MEM_ID").addClass("essentiality");
			$("#MEM_ID").attr("readonly",true);
			if("${USER.admin_yn}" =="Y"){
				$("#btn_delete").show();
			}
		}
	});
	

	/* 목록보기 */
	function fn_list() {
		var frm = document.form;
		
		frm.action = "${staticPATH }/testTarget/testTargetList.do";
	    frm.submit();
	};	
	
	
	/* 등록 */
	function fn_save() {

		if($("#MEM_ID").val() == ""){
			alert("등록할 고객ID를 입력하세요.");
			$("#MEM_ID").focus();
			return;
		}
		
		if(!confirm("저장 하시겠습니까?")){
			return;
		}
		
		jQuery.ajax({
			url           : '${staticPATH }/setTestTargetMemId.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {
	        	if(option=="success"){
	        		
	        		if(result.chk=="N"){
	        			alert("유효하지 않은 고객ID입니다.");
	        		}else if(result.dup=="Y"){
	        			alert("이미 등록된 테스트 대상 고객ID입니다.");
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
	

	/* 고객ID 유효성 조회 */
	function fn_search()
	{	
		
		if($("#MEM_ID").val() == ""){
			alert("조회할 고객ID를 입력하세요.");
			$("#MEM_ID").focus();
			return;
		}
		
		jQuery.ajax({
			url           : '${staticPATH }/getTestTargetMemId.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : {MEM_ID    : $("#MEM_ID").val()
	        },
	        success: function(result, option) {
	        	if(option=="success"){

	        		var chk = result.chk;
	        		
	        		if(chk=="N"){
	        			alert("유효하지 않은 고객ID입니다.");
	        		}else if(chk=="D"){
	        			alert("이미 등록된 테스트 대상 고객ID입니다.");
	        		}else{
	        			var frm = document.form;
	        			
	        			frm.action = "${staticPATH }/testTarget/testTargetDetail.do";
	        		    frm.submit();
	        		}
		        	
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
		
	}
	
	/* 테스트 고객ID 삭제 */
	function fn_delete(){
		
		if(!confirm("삭제 하시겠습니까?")){
			return;
		}
		
		jQuery.ajax({
			url           : '${staticPATH }/deleteTestTargetMemId.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : {MEM_ID    : $("#MEM_ID").val()
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
                   <li role="presentation" class="active">
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
            <div id="myTabContent" class="tab-content" style="padding-bottom:60px;">

      <form name="form" id="form">
        <input type="hidden" id="TYPE" name="TYPE" value="${TYPE}" />
        <input type="hidden" id="SMEM_ID" name="SMEM_ID" value="${SMEM_ID}" />
		<div id="table">
		  <table width="100%"  class="table table-striped table-hover table-condensed table-bordered">
		    <colgroup>
			  <col width="130"/>
			  <col width="250"/>
			  <col width="130"/>
			  <col width=""/>
			</colgroup>
			<tr>
			  <th class="info">고객ID</th>
			  <td class="tbtd_content" colspan="3">
			    <div id="sysbtn_l">
				  <input type="text" id="MEM_ID" name="MEM_ID" style="width:100px;" value="${bo.mem_id}" maxlength="20" class="txt"/>
				  <c:if test="${TYPE != 'U'}">
				    <button type="button" class="btn btn-success btn-sm" onclick="fn_search();"><i class="fa fa-search" aria-hidden="true"></i> 조 회 </button>
				  </c:if>
			    </div>
			  </td>
			</tr>
		    <tr>
			  <th class="info">고객번호</th>
			  <td class="tbtd_content" colspan="3">
				  ${bo.mem_no}
			  </td>
		    </tr>
		    <tr>
			  <th class="info">PCID</th>
			  <td class="tbtd_content" colspan="3">
				<c:forEach items="${list}" var="list">
					 ${list.pcid}<br/>
				</c:forEach>
			  </td>
		    </tr>
			<tr>
			  <th class="info">이름</th>
			  <td class="tbtd_content" colspan="3">
			    	${bo.name}
			  </td>
			</tr>
			<tr>
			  <th class="info">전화번호</th>
		      <td class="tbtd_content" colspan="3">
					${bo.tel}
			  </td>
			</tr>
			<tr>
			  <th class="info">이메일</th>
			  <td class="tbtd_content" colspan="3">
					${bo.email}
			  </td>
			</tr>
		    <tr>
			  <th class="info">사용여부</th>
			  <td class="tbtd_content" colspan="3">
			    <select id="USE_YN" name="USE_YN"  style="width: 50px;">
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
		  <button type="button" class="btn btn-danger btn-sm" onclick="fn_delete();"><i class="fa fa-trash-o" aria-hidden="true"></i> 삭 제 </button>
		  <button type="button" class="btn btn-success btn-sm" onclick="fn_list();"><i class="fa fa-list" aria-hidden="true"></i> 목 록</button>
		  <button type="button" class="btn btn-info btn-sm" onclick="document.form.reset();"><i class="fa fa-undo" aria-hidden="true"></i> 초기화</button>
		  <button type="button" class="btn btn-danger btn-sm" onclick="fn_save();"><i class="fa fa-floppy-o" aria-hidden="true"></i> 저 장</button><br/><br/>
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
