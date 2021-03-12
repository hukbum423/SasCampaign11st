<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>

<script language="JavaScript">

	window.resizeTo(1080,720);

	$(document).ready(function(){
		
		
		//오늘날짜 가져오기
		//getToday();
		
		$( "#RSRV_DT" ).datepicker(dateOption);
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; margin-bottom:-2px; vertical-align:middle;");

		
		//조회조건 선택시 이벤트 추가
		$("#SEARCH_TYPE").bind("change",fn_selectSearchType);
		
		
		//조회
		//fn_search();
		
	});
	
	/* 조회조건 선택시 재조회 */
	function fn_selectSearchType(){
		fn_search();	
	}


	/* 조회 */
	function fn_search() {
		
		jQuery.ajax({
			url           : '/UnicaExt/getScheduleList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : { CampaignId     : $("#CampaignId").val(),
	        	             CAMPAIGNCODE    : $("#CAMPAIGNCODE").val(),
	        	             selectPageNo    : $("#selectPageNo").val(),
	        	             SEARCH_TYPE     : $("#SEARCH_TYPE").val()
	        },
	        success: function(result, option) {
	        	if(option=="success"){
		        	var list = result.ScheduleList;
		        	
		        	$("#LIST_LENGTH").val(list.length);
		        	
		        	var txt ="";
		        	txt += "<table width='100%' border='0' cellpadding='0' cellspacing='0'>";

		        	if(list.length>0){
						txt += "<colgroup>";
						txt += "<col width='40'/>";
						txt += "<col width='50'/>";
						txt += "<col width='180'/>";
						txt += "<col width='180'/>";
						txt += "<col width='180'/>";
						txt += "<col width='180'/>";
						txt += "<col width=''/>";
						txt += "<col width='160'/>";
						txt += "</colgroup>";
						
			        	$.each(list, function(key){
			        		var data = list[key];
			        		txt += "<tr>";
			        		txt += "<td align=\"center\" class=\"listtd\">" + data.num + "</td>";
			        		if(data.run_start_dt == null){
			        			txt += "<td align=\"center\" class=\"listtd\"><input type='checkbox' name='CHK_DATE' value='"+ data.rsrv_dt +"' style='margin:-13px 5px -5px 0px;' /></td>";	
			        		}else{
			        			txt += "<td align=\"center\" class=\"listtd\"><input type='checkbox' disabled='disabled' style='margin:-13px 5px -5px 0px;' /></td>";
			        		}
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.rsrv_dt,'')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.run_start_dt,'')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.run_end_dt,'')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.run_status,'')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_nm,'')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_dt,'')+"</td>";
							txt += "</tr>";
			        	}); 
		        	}else{
		        		txt += "<tr><td align=\"center\" class=\"listtd\" colspan=\"\8\">데이터가 없습니다.</td></tr>";
		        		for(var i=1; i<result.rowRange; i++){
		        			txt +="<tr'>";
		        			txt +="<td align=\"center\" class=\"listtd\" >&nbsp;</td>";
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

		        	//빈 row 채우기
		        	if(list.length > 0 && list.length < result.rowRange ){
		        		for(var i=list.length; i<result.rowRange; i++){
		        			txt +="<tr'>";
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
		        	

		        	//페이징 처리 시작!!
		        	var page = "";
		        	//이전페이지 만들기
		    		if( result.selectPage > result.pageRange){
		    			page +="<a href=\"javascript:fn_pageMove("+ (Number(result.pageStart) - Number(result.pageRange)) +" );\" ><img src=\"<c:url value='/img/btn_left.gif'/>\" width='13px;' height='13px;' /></a>&nbsp;";
		    		}
		    		
		        	//페이지 숫자
		        	for(var i=result.pageStart;  i<=result.pageEnd; i++){
						if(result.selectPage == i)	{	
							page +="<strong>" + i + "</strong>";
						}else{ 
							page +="<a href=\"javascript:fn_pageMove("+i+");\">" + i + "</a>";
						};
		        	};
		        	
		        	//다음페이지 만들기
					if(result.totalPage != result.pageEnd )	{
						page +="&nbsp;<a href=\"javascript:fn_pageMove("+ (Number(result.pageStart) + Number(result.pageRange)) +" );\" ><img src=\"<c:url value='/img/btn_right.gif'/>\" width='13px;' height='13px;' /></a>";
					}
					$("#paging_layer").html(page);
					//페이징 처리 종료
		        	
	        	}else{
	        		alert("에러가 발생하였습니다.");
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
		
	};

	
	/* 페이지 이동 */
	function fn_pageMove(selectPageNo)
	{	
		$("#selectPageNo").val(selectPageNo);
		fn_search();		
	}
	
	
	/* 선택 삭제 */
	function fn_delete(){
		
		if($("input:checkbox[name='CHK_DATE']:checked").length == 0){
			alert("삭제할 일정을 선택하세요");
			return;
		}

		if(!confirm($("input:checkbox[name='CHK_DATE']:checked").length + "건을 삭제 하시겠습니까?")){
			return;
		}
		 
		jQuery.ajax({
			url           : '/UnicaExt/deleteScheduleList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
        		
        			alert("일정이 삭제 되었습니다");
       			
        			fn_search();
	        		
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
	}
	
	/* 전체 삭제 */
	function fn_deleteAll(){
		
		if(!confirm("전체 삭제 하시겠습니까?\n(이미 실행된 일정은 삭제되지 않습니다)")){
			return;
		}
		
		jQuery.ajax({
			url           : '/UnicaExt/deleteScheduleListAll.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
        		
        			alert("전체 일정이 삭제 되었습니다");
       			
        			fn_search();
	        		
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
		
	}

	
	//창닫기
	function fn_close(){
		
		//창닫기
		window.close();
		
	}
	

	/* 유효성 체크 */
	function fn_validation() {
		
		if("${bo.camp_term_cd}" == "01" && Number($("#LIST_LENGTH").val()) > 0 ){
			//모두 실패건일경우에는 등록 가능
			jQuery.ajax({
				url           : '/UnicaExt/getRunSucessYnChk.do',
				dataType      : "JSON",
				scriptCharset : "UTF-8",
				type          : "POST",
		        data          : $("#form").serialize(),
		        success: function(result, option) {
	
		        	if(option=="success"){
	        		
		        		if(result.ALL_FAIL !="Y"){
			    			alert("캠페인 기간이 From~To일경우에는 일정을 1개만 입력하실수 있습니다");
			    			return false;		
		        		}else{
		        			fn_add();
		        		}
		    			
		        	}else{
		        		alert("에러가 발생하였습니다.");	
		        	}
		        },
		        error: function(result, option) {
		        	alert("에러가 발생하였습니다.");
		        }
			});
		}else{
			fn_add();
		}
		
	}
	
	/* 일정 추가 */
	function fn_add(){

		
		if("${bo.camp_term_cd}" == "01"){
			if( $("#RSRV_DT").val() > "${bo.camp_end_dt}"){
				alert("추출일자는 캠페인 종료일(${bo.camp_end_dt})보다 보다 작아야합니다");
				$("#RSRV_DT").focus();
				return;
			}
		}

		//캠페인 기간이 from~to일고(camp_term_cd == 01) 채널우선순위적용여부가[Y]일경우 추출일자가 노출일 MIN(SMS노출일, EMAIL노출일, 모바일 노출일) -2일 (minDispDt) 보다 클경우 경고창 출력
		//"채널 노출일 2일전에 대상추출이 되어야 합니다."
		var startDt = $("#RSRV_DT").val();
		
		if( "${bo.camp_term_cd}" == "01" && "${bo.channel_priority_yn}" == "Y" && "${bo.minDispDt}" != "" && startDt > "${bo.minDispDt}" ){
			alert("캠페인 실행일정은 노출일 -2일 (${bo.minDispDt}) 이전이여야 합니다");
			$("#RSRV_DT").focus();
			return;
		}

		if($("#RSRV_DT").val() == ""){
			alert("일정을 입력하세요");
			$("#RSRV_DT").focus();
			return;
		}
		
		if($("#TO_DATE").val() > $("#RSRV_DT").val()){
			alert("캠페인 실행일은 오늘보다 커야합니다");
			$("#RSRV_DT").focus();
			return;
		}
		
		if(!confirm("일정을 추가하시겠습니까?")){
			return;
		}
		
		jQuery.ajax({
			url           : '/UnicaExt/setScheduleList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
        		
        			alert("일정이 등록 되었습니다");
       			
        			fn_search();
	        		
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
		
	}
	
	//오늘 날짜 가져오기
	function getToday(){
		jQuery.ajax({
			url           : '/UnicaExt/getToday.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : {},
	        success: function(result, option) {

	        	if(option=="success"){
	        		
	        		$("#TO_DATE").val(result.TO_DATE) ;
	        		$("#TO_DATE_P1").val(result.TO_DATE_P1) ;
	        		$("#TO_DATE_P2").val(result.TO_DATE_P2) ;
	        		
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

              <div class="col-md-6 page-header">
                <h3>플로차트 일정 목록</h3>
              </div>
<form name="form" id="form">
<input type="hidden" id="TO_DATE" name="TO_DATE" value="" />
<input type="hidden" id="TO_DATE_P1" name="TO_DATE_P1" value="" />
<input type="hidden" id="TO_DATE_P2" name="TO_DATE_P2" value="" />
<input type="hidden" id="CAMPAIGNCODE" name="CAMPAIGNCODE" value="${bo.campaigncode}" />
<input type="hidden" id="CampaignId" name="CampaignId" value="${bo.campaignid}" />
<input type="hidden" id="selectPageNo" name="selectPageNo"  value="${selectPageNo}" />
<input type="hidden" id="LIST_LENGTH" name="LIST_LENGTH"  value="0" />

	<div id="sysbtn" class="col-md-12" style="text-align:right;margin-bottom:10px;">
		<button type="button" class="btn btn-success btn-sm" onclick="fn_delete();"><i class="fa fa-trash" aria-hidden="true"></i> 삭제</button>
		<button type="button" class="btn btn-success btn-sm" onclick="fn_deleteAll();"><i class="fa fa-trash" aria-hidden="true"></i> 전체삭제</button>
	</div>
	
	<div id="table">
		<table class="table table-striped table-hover table-condensed" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="130"/>
				<col width="250"/>
				<col width="130"/>
				<col width=""/>
			</colgroup>
			<tr>
				<td class="info">캠페인 코드/명</td>
				<td class="tbtd_content">[${bo.campaigncode}]${bo.campaignname}</td>
				<td class="info">플로차트 이름</td>
				<td class="tbtd_content">${bo.flowchartname}</td>
			</tr>
			<tr>
				<td class="info">추출기간</td>
				<td class="tbtd_content">
					<c:if test="${bo.rsrv_gubun_code != '05'}">
						${bo.rsrv_start_dt} ~ ${bo.rsrv_end_dt}
					</c:if>
				</td>
				<td class="info">일정</td>
				<td class="tbtd_content">
					${bo.rsrv_gubun_code_name}
					<c:if test="${bo.rsrv_gubun_code eq '03'}">
						${bo.rsrv_day}일 
					</c:if>
					<c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '2') != '-1'}">월</c:if>
					<c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '3') != '-1'}">화</c:if>
					<c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '4') != '-1'}">수</c:if>
					<c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '5') != '-1'}">목</c:if>
					<c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '6') != '-1'}">금</c:if>
					<c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '7') != '-1'}">토</c:if>
					<c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '1') != '-1'}">일</c:if>
					<c:if test="${bo.rsrv_gubun_code eq '01' || bo.rsrv_gubun_code eq '02' || bo.rsrv_gubun_code eq '03' || bo.rsrv_gubun_code eq '04'}">
						${bo.rsrv_hour}시 ${bo.rsrv_minute}분
					</c:if>
					<c:if test="${bo.rsrv_gubun_code eq '06'}">
					<c:if test="${bo.rsrv_everytime eq 'Y'}">매시간&nbsp;${bo.rsrv_timehourfrom}시 ~ </c:if>
						${bo.rsrv_timehourto}시 ${bo.rsrv_timemin}분 
					</c:if>
					
				</td>
			</tr>
			<tr>
				<td class="info">실행상태</td>
				<td class="tbtd_content" colspan="3">
					<select style="width: 70px;" id="SEARCH_TYPE" name="SEARCH_TYPE" >
						<option >전체</option>
						<option value="NULL">미실행</option>
						<option value="NOTNULL">실행</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="info">일정추가</td>
				<td class="tbtd_content" colspan="3">
					<div id="search2">
						
								<input type="text" id="RSRV_DT" name="RSRV_DT" class="txt" style="width:68px;" value="" readonly="readonly"/>
								<select style="width: 45px;" id="RSRV_HOUR" name="RSRV_HOUR" >
									<c:forEach var="val" varStatus="i" begin="08" end="20" step="1">
										<option value="${val}">
										<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
										</option>
									</c:forEach>
								</select>
								시
								<select style="width: 45px;" id="RSRV_MINUTE" name="RSRV_MINUTE">
									<c:forEach var="val" varStatus="i" begin="00" end="59" step="1">
										<option value="${val}">
										<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
										</option>
									</c:forEach>
								</select>
								분
								<button type="button" class="btn btn-success btn-sm" onclick="fn_validation();"><i class="fa fa-plus" aria-hidden="true"></i> 추가</button>
					</div>				
				</td>
			</tr>
		</table>
	</div>



	<!-- List -->
	<div id="table">
		<table class="table table-striped table-hover" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="40"/>				
				<col width="50"/>
				<col width="180"/>
				<col width="180"/>
				<col width="180"/>
				<col width="180"/>
				<col width=""/>
				<col width="160"/>
			</colgroup>		  
			<tr class="info">
				<th style="text-align:center;" >No</th>
				<th style="text-align:center;">선택</th>
				<th style="text-align:center;">실행예정일시</th>
				<th style="text-align:center;">실행시작일시</th>
				<th style="text-align:center;">실행종료일시</th>
				<th style="text-align:center;">실행상태</th>
				<th style="text-align:center;">등록자ID</th>
				<th style="text-align:center;">등록일시</th>
			</tr>
		</table>
	</div>
	<div id="search_layer"></div>
	<div id="paging_layer" class="s_paging"></div>	
	<!-- /List -->
	
	<div id="sysbtn" class="col-md-12" style="text-align:right;margin-bottom:10px;">
    	<button type="button" class="btn btn-success btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i> 닫기</button>
	</div>

</form>
                            </div>
                            <div class="col-lg-1"></div>
                        </div>
                        <!--END BLOCK SECTION -->
                        <div class="col-lg-3"></div>
              
                      </div>
                      <!--END PAGE CONTENT -->
                      
                      
        
        

<%@ include file="/WEB-INF/views/common/_footer.jsp"%>
