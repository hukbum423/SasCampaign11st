<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_pop.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>

<script language="JavaScript">


	window.resizeTo(1220,850);

	$(document).ready(function(){
		
		
	});

	
	/* 테스트 실행 */
	function fn_testStart(){
		
		//유효성 체크
		if(!fn_validation()){
			return;
		}
		
		if(!confirm("테스트 실행 하시겠습니까?")){
			return;
		}
		
		jQuery.ajax({
			url           : '${staticPATH }/setCampaignTest.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
	        		
       				alert("저장되었습니다");
       				
       				//창 닫기
       				fn_close();
	        		
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
	
		if(!$("input:checkbox[name='CELL_CHANNEL']").is(":checked")){
			alert("테스트할 채널을 선택 하십시오");
			return false;
		}
	
		if(!$("input:checkbox[name='TEST_MEM_ID']").is(":checked")){
			alert("테스트할 대상자를 선택 하십시오");
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

	              <div class="col-md-6 ">
	                <h3>캠페인 테스트 실행</h3>
	              </div>
<form name="form" id="form">
<input type="hidden" id="CAMPAIGNCODE" name="CAMPAIGNCODE" value="${bo.campaigncode}" />
<input type="hidden" id="CampaignId" name="CampaignId" value="${bo.campaignid}" />

		<table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%"/>
				<col width="85%"/>
			</colgroup>
			<tr>
				<td class="info">캠페인 코드/명</td>
				<td class="tbtd_content">[${bo.campaigncode}]${bo.campaignname}</td>
<%-- 				<td class="info">플로차트 이름</td>
				<td class="tbtd_content">${bo.flowchartname}</td> --%>
			</tr>
		</table>

	<div id="title" class="" >
		<h3>채널선택</h3>
	</div>

	<!-- List -->
	<div id="table">
		<table class='table table-striped table-hover table-condensed table-bordered' width='100%' border='0' cellpadding='0' cellspacing='0'>
      <colgroup>
        <col width="5%"/>
        <col width="20%"/>        
        <col width="20%"/>
        <col width="55%/"/>
      </colgroup> 	  
			<tr class="info">
				<th style="text-align:center;">선택</th>
				<th style="text-align:center;">고객 세그먼트</th>
				<th style="text-align:center;">채널</th>
				<th style="text-align:center;">내용</th>
			</tr>
		</table>
	</div>
	<div width="100%" style="height: 210px; overflow-y:scroll;">
		<table class='table table-striped table-hover table-condensed ' width='100%' border='0' cellpadding='0' cellspacing='0'> 
			<colgroup>
				<col width="5%"/>
				<col width="20%"/>				
				<col width="20%"/>
				<col width="55%/"/>
			</colgroup>		 			
			<c:forEach var="bo" items="${channel_list}">
				<c:if test="${bo.channel_cd != null }">
					<tr >
						<td align="center" class="listtd"  ><input type="checkbox" name="CELL_CHANNEL" style="overflow: hidden; margin:-13px 0px -5px 0px;" value="${bo.channel_cd}#@#${bo.cellid}"/></td> <!-- #@# KYE 구분값 (채널구분 + #@# + CELLID)  -->
						<c:if test="${bo.cellname != old_cellname2 }">
							<td align="left" class="listtd" rowspan="${bo.cellrow}" >${bo.cellname}</td>
						</c:if>
						<td align="left" class="listtd">${bo.channel_nm}</td>
						<td align="left" class="listtd"
							<c:if test="${bo.channel_cd == 'TOAST' }">
								title ="${bo.toast_title}"
							</c:if>
							<c:if test="${bo.channel_cd == 'SMS' }">
								title ="${bo.sms_msg}"
							</c:if>
							<c:if test="${bo.channel_cd == 'EMAIL' }">
								title ="${bo.email_name}"
							</c:if>
							<c:if test="${bo.channel_cd == 'MOBILE' }">
								title ="${bo.mobile_disp_title}"
							</c:if>
						>
							<c:if test="${bo.channel_cd == 'TOAST' }">
								${fn:substring(bo.toast_title,0,50)}
								<c:if test="${fn:length(bo.toast_title) >= 50 }">...</c:if>
							</c:if>
							<c:if test="${bo.channel_cd == 'SMS' }">
								${fn:substring(bo.sms_msg,0,50)}
								<c:if test="${fn:length(bo.sms_msg) >= 50 }">...</c:if>
							</c:if>
							<c:if test="${bo.channel_cd == 'EMAIL' }">
								${fn:substring(bo.email_name,0,50)}
								<c:if test="${fn:length(bo.email_name) >= 50 }">...</c:if>
							</c:if>
							<c:if test="${bo.channel_cd == 'MOBILE' }">
								${fn:substring(bo.mobile_disp_title,0,50)}
								<c:if test="${fn:length(bo.mobile_disp_title) >= 50 }">...</c:if>
							</c:if>
						</td>
					</tr>
					<c:set var="old_cellname2"      value="${bo.cellname}"/>
				</c:if>
			</c:forEach>
			
			<c:set var="channelSize" value="${fn:length(channel_list)}"/>
			<c:if test="${channelSize eq 0 }">
				<tr>
					<td align="center" class="listtd" colspan="4">데이터가 없습니다.</td>
				</tr>
			</c:if>	
		</table>
	</div>
	<!-- List -->
	
	<div id="title" class="" >
		<h3>대상자 선택</h3>
	</div>
	
	<!-- List -->
	<div id="table">
		<table class='table table-striped table-hover table-condensed table-bordered' width='100%' border='0' cellpadding='0' cellspacing='0'>
			<colgroup>
				<col width="5%"/>
				<col width="15%"/>				
				<col width="15%"/>				
				<col width="20%"/>				
				<col width="20%"/>				
				<col width="25%"/>
			</colgroup>		  
			<tr class="info">
				<th style="text-align:center;">선택</th>
				<th style="text-align:center;">회원ID</th>
				<th style="text-align:center;">이름</th>
				<th style="text-align:center;">휴대폰번호</th>
				<th style="text-align:center;">이메일주소</th>
				<th style="text-align:center;">PCID</th>
			</tr>
		</table>
	</div>
	
	<div id="table" style="height: 150px; overflow-y:scroll;"> 
		<table class='table table-striped table-hover table-condensed ' width="100%" border="0" cellpadding="0" cellspacing="0" >
			<colgroup>
        <col width="5%"/>
        <col width="15%"/>        
        <col width="15%"/>        
        <col width="20%"/>        
        <col width="20%"/>        
        <col width="25%"/>
			</colgroup>				
			<c:forEach var="bo" items="${TestTargetList}">
				<tr >
					<td align="center" class="listtd"  ><input type="checkbox" name="TEST_MEM_ID"  style="overflow: hidden; margin:-13px 0px -5px 0px;" value="${bo.mem_id}"  /></td>
					<td align="center" class="listtd">${bo.mem_id}</td>
					<td align="center" class="listtd">${bo.name}</td>
					<td align="center" class="listtd">${bo.tel}</td>
					<td align="center" class="listtd">${bo.email}</td>
					<td align="center" class="listtd">${bo.pcid}</td>
				</tr>
			</c:forEach>
			
			<c:set var="testTargetSize" value="${fn:length(TestTargetList)}"/>
			
			<c:if test="${testTargetSize eq 0 }">
				<tr>
					<td align="center" class="listtd" colspan="6">테스트 대상자가 없습니다</td>
				</tr>
			</c:if>		
		</table>
	</div>	
	
	<!-- List -->
	
	
 <div class="col-md-12" id="sysbtn" style="text-align:right;margin-bottom:10px;">
        <button type="button" class="btn btn-success btn-sm" onclick="fn_testStart();"><i class="fa fa-exclamation" aria-hidden="true"></i> 테스트 실행 </button>
        <button type="button" class="btn btn-success btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i> 닫기 </button>
       
 </div> 
</form>
                            <div class="col-md-1"></div>
                            
                            </div>
                        </div>
                        <!--END BLOCK SECTION -->
                        <div class="col-lg-3"></div>
              
                      </div>
                      
        
        



