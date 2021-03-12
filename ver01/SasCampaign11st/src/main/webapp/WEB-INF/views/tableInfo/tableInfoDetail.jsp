<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

    <!-- PAGE LEVEL STYLES -->
    <link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
    <link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="${staticPATH }/css/ui-lightness/jquery-ui.css">
    <link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
    <!-- END PAGE LEVEL  STYLES -->

  <script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
  <script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script>
  <script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>


<script language="JavaScript">

	window.resizeTo(1080,690);


	$(document).ready(function(){
		

		//일정구분 SELECTBOX 이벤트 추가
		$("#chkAll").bind("change",fn_selectAll);

		
	});
	
	
	/* 체크박스 전체 선택, 해제 */
	function fn_selectAll(){
		
		var chked = $("#chkAll").is(":checked");
		
		$("input:checkbox[name='chkBox']").each(function(){
			this.checked = chked;
		});
		
	}	

	
	/* tr 추가하기 */
	function fn_add(){
		var newrow = '';
		newrow += '<tr>';
		newrow += '<td align="left" class="listtd">';
		newrow += '<input type="checkbox" name="chkBox" style="margin:-13px 5px -5px 0px; " />';
		newrow += '<input type="text" name="COLUMN_NAME" value="" class="txt" style="width:150px;" maxlength="50"/>';
		newrow += '</td>';
		newrow += '<td align="center" class="listtd">';
		newrow += '<input type="text" name="COLUMN_TYPE" value="" class="txt" style="width:100px;" maxlength="25"/>';
		newrow += '</td>';
		newrow += '<td align="left" class="listtd">';
		newrow += '<input type="text" name="COLUMN_DESC" value="" class="txt" style="width:280px;" maxlength="100"/>';
		newrow += '</td>';
		newrow += '<td align="center" class="listtd">';
		newrow += '<input type="text" name="SORT_SEQ" onkeydown="javascript:keypressNumber();" value="" class="txt" style="width:50px;" maxlength="3"/>';
		newrow += '</td>';
		newrow += '<td align="center" class="listtd">';
		newrow += '</td>';
		newrow += '<td align="center" class="listtd">';
		newrow += '</td>';
		newrow += '</tr>';
		newrow += '';
		
		$("#tableInfoList").append(newrow);
	}
	
	
	/* tr 삭제하기 */
	function fn_delete(){

		if(!$("input:checkbox[name='chkBox']").is(":checked")){
			alert("삭제할 Row를 선택하세요");
			return;
		}

		$("#TYPE").val("D");
		
		if(!confirm("삭제 하시겠습니까?")){
			return;
		}

		$("input:checkbox[name='chkBox']").each(function(){
			if(this.checked){
				$(this).parent().parent().remove();
			}
		});
	
		//유효성 체크
		if(!fn_validation()){
			return;
		}

		jQuery.ajax({
			url           : '/UnicaExt/setTableInfoDetail.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
	        		
					alert("삭제되었습니다");
					
					var frm = document.form;
					
			    	frm.action = "/UnicaExt/tableInfoDetail.do";
			        frm.submit();
					
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
		
		
	}
	
	
	/* 저장하기 */
	function fn_save(){

		$("#TYPE").val("I");
		
		//유효성 체크
		if(!fn_validation()){
			return;
		}
		
		if(!confirm("저장 하시겠습니까?")){
			return;
		}

		jQuery.ajax({
			url           : '/UnicaExt/setTableInfoDetail.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
	        		
					alert("저장되었습니다");
					
					var frm = document.form;
					
			    	frm.action = "/UnicaExt/tableInfoDetail.do";
			        frm.submit();
					
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
		
	}
	
	
	/* 유효성 체크 */
	function fn_validation() {
		
		var exit = false;
		
		//저장할게 있는지 체크
		if($("input:text[name='COLUMN_NAME']").length == 0 && $("#TYPE").val() == 'I'){
			alert("저장할 데이터가 없습니다.");
			return false;
		}
		
		//입력값 체크
		$("input:text[name='COLUMN_NAME']").each(function(){
			if(this.value==""){
				alert("항목명을 입력하세요");
				exit = true;
				this.focus();
				return false;
			}
		});

		if(exit){
			return false;
		}
		
		//중복값 체크
		$("input:text[name='COLUMN_NAME']").each(function(){
			var cnt = 0;
			var thisVlue = this.value;
			
			$("input:text[name='COLUMN_NAME']").each(function(){
				if(thisVlue == this.value){
					cnt ++;
				}
			});
			if(cnt > 1){
				alert("항목명이 중복됩니다");
				exit = true;
				this.focus();
				return false;
			}
			
		});		
		
		if(exit){
			return false;
		}
		
		
		return true;
	}

	
	//창닫기
	function fn_close(){
		
		//창닫기
		window.close();
		
	}
	
	
</script>
  <!--PAGE CONTENT -->
        <div id="content" style="width:100%; height100%;">
           <!--BLOCK SECTION -->
           <div class="row" style="width:100%; height100%;">
              <div class="col-lg-1"></div>
              <div class="col-lg-10">

              <div class="col-md-12 page-header">
                <h3>캠페인 관리 > 테이블 정보 세부항목</h3>
              </div>
              
<form name="form" id="form">
<input type="hidden" id="TYPE" name="TYPE" value="" />
<input type="hidden" id="TABLE_NAME" name="TABLE_NAME" value="${TABLE_NAME}" />
	<div id="search">
		<ul>
			<c:if test="${USER.admin_yn eq 'Y' }">
				<li><span class="btn_blue_l"><a href="javascript:fn_add();" class="bt">추가</a><img src="<c:url value='/img/btn/btn_bg_r.gif'/>" style="margin-left:6px;"></span></li>	
				<li><span class="btn_blue_l"><a href="javascript:fn_save();" class="bt">저장</a><img src="<c:url value='/img/btn/btn_bg_r.gif'/>" style="margin-left:6px;"></span></li>	
				<li><span class="btn_blue_l"><a href="javascript:fn_delete();" class="bt">삭제</a><img src="<c:url value='/img/btn/btn_bg_r.gif'/>" style="margin-left:6px;"></span></li>
			</c:if>
		</ul>	
	</div>
	
	<!-- List -->
	<div id="table">
		<table class="table table-striped table-hover" width="100%" border="0" cellpadding="0" cellspacing="0" id="tableInfoList">
			<colgroup>
				<col width="200"/>				
				<col width="100"/>
				<col width="/"/>
				<col width="100"/>
				<col width="100"/>
				<col width="150"/>
			</colgroup>		  
			<tr class="info">
				<th style="text-align:center;"><input type="checkbox" name="chkAll" id="chkAll" style="margin:-2px 0px -4px 0px; " />항목명</th>
				<th style="text-align:center;">유형</th>
				<th style="text-align:center;">내용</th>
				<th style="text-align:center;">정렬순서</th>
				<th style="text-align:center;">등록자</th>
				<th style="text-align:center;">등록일시</th>
			</tr>
			
			<c:forEach var="bo" items="${TableInfoDtlList}">
				<tr>
					<td align="left"  class="listtd" >
						<input type="checkbox" name="chkBox" style="margin:-13px 0px -5px 0px; "/>
						<input type="text" name="COLUMN_NAME" value="${bo.column_name}" class="txt" style="width:150px;" maxlength="50"/>
					</td>
					<td align="center" class="listtd">
						<input type="text" name="COLUMN_TYPE" value="${bo.column_type}" class="txt" style="width:100px;" maxlength="25"/>
					</td>
					<td align="left" class="listtd">
						<input type="text" name="COLUMN_DESC" value="${bo.column_desc}" class="txt" style="width:280px;" maxlength="100"/>
					</td>
					<td align="center" class="listtd">
						<input type="text" name="SORT_SEQ" onkeydown="javascript:keypressNumber();" value="${bo.sort_seq}" class="txt" style="width:50px;" maxlength="3"/>
					</td>
					<td align="center" class="listtd">${bo.create_nm}</td>
					<td align="center" class="listtd">${bo.create_dt}</td>
				</tr>
			</c:forEach>
		
		</table>
	</div>
	<!-- /List -->		

	<div id="sysbtn">
	    <div class="col-md-12" id="search" style="text-align:right;margin-bottom:10px;">
	        <button type="button" class="btn btn-success btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i> 닫기 </button>
	    </div> 
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