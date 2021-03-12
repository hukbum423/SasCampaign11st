<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_modal.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>

<script language="JavaScript">


	$(document).ready(function(){
		
// 		=================================================
		// 화면타이틀값 : 메뉴명칭
		if(window.location != window.parent.location){ //iframe일경우에만
			parent.setPageTitle("${bo.campaignname} - 오퍼 속성 및 채널 등록",null);
	
			// Tab 메뉴
			// Step1 메뉴에 url 생성 후 변경 필요함.
			var tablist = "<li><a target=content href='/Campaign/campaignDetails.do?id=${CAMPAIGNID}'>요약</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/campaignInfo.do?CampaignId=${CAMPAIGNID}'>STEP1.캠페인 속성 등록</a></li>";
			tablist += "<li class=selected><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/campaignInfoList.do?CampaignId=${CAMPAIGNID}'>STEP2.오퍼  속성 및 채널 등록</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/scheduleDetail.do?CampaignId=${CAMPAIGNID}'>STEP3.대상고객 추출일정 등록</a></li>";
			top.setNewTabList(tablist);
			
			parent.document.getElementById('gwt-uid-2').innerHTML='<a href="/Campaign/logout.do"><font color="#E8DB6B" bold style={text-decoration:none;}>로그아웃</a>';
		}
// 		=================================================
	
		
		if("${channelValiChk}" =="N"){
			alert("대상수준이 PCID일경우에는 토스트배너만 사용이 가능합니다");
			return;
		};
	
		
		if("${channelValChkforMobile}" != "Y"){
			alert("대상수준이 DEVICEID일 경우에는 모바일 알리미 채널만 사용이 가능합니다.");
	        return;
		}
	});

	
	
	/* 채널 정보 추가입력 */
	function fn_addChannel(cellid){

		$("#CELLID").val(cellid);
		
		var frm = document.form;
		pop = window.open('', 'POP_CHANNEL', 'top=50,left=80, location=no,status=no,toolbar=no,scrollbars=yes,width=1070,height=500');
        frm.action = "/UnicaExt/channelInfo.do";
        frm.target = "POP_CHANNEL";
        frm.method = "POST";
        frm.submit();
        pop.focus();

	}
	
	
	/* 채널 정보 삭제 */
	function fn_delChannel(cellid, channel_cd){

		if(!confirm("삭제 하시겠습니까?")){
			return;
		}

		$("#CELLID").val(cellid);
		$("#CHANNEL_CD").val(channel_cd);
		
		jQuery.ajax({
			url           : '${staticPATH }/delChannelInfo.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
	        		
        			alert("삭제되었습니다");
        			
        			//부모창 재조회
        			location.reload(); 
        			
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});

	}
	
	
	/* 채널정보 상세보기(수정화면)*/
	function fn_clickChannel(cellid, channel_cd){
		
		var frm = document.form;
		
		$("#CELLID").val(cellid);
		$("#CHANNEL_CD").val(channel_cd);

		pop = window.open('', 'POP_CHANNEL', 'top=50,left=80, location=no,status=no,toolbar=no,scrollbars=yes');
		if(channel_cd == "TOAST"){
        	frm.action = "/UnicaExt/channelToast.do";
		}
		if(channel_cd == "SMS"){
        	frm.action = "/UnicaExt/channelSms.do";
		}
		if(channel_cd == "EMAIL"){
        	frm.action = "/UnicaExt/channelEmail.do";
		}
		if(channel_cd == "MOBILE"){
        	frm.action = "/UnicaExt/channelMobile.do";
		}
        frm.target = "POP_CHANNEL";
        frm.method = "POST";
        frm.submit();
        pop.focus();
		
	}
	
</script>
 <!--PAGE CONTENT -->
        <div id="content" style="width:100%; height100%;">
           <!--BLOCK SECTION -->
           <div class="row" style="width:100%; height100%;">
              <div class="col-lg-1"></div>
              <div class="col-lg-10">

              <div class="col-md-12 page-header">
                <h3>채널 리스트</h3>
              </div>
<form name="form" id="form">
<input type="hidden" id="CampaignId" name="CampaignId" value="${CAMPAIGNID}" />
<input type="hidden" id="CELLID" name="CELLID" value="" />
<input type="hidden" id="OFFERID" name="OFFERID" value="" />
<input type="hidden" id="CHANNEL_CD" name="CHANNEL_CD" value="" />
<input type="hidden" id="DISABLED" name="DISABLED" value="Y" />


	<!-- List -->
	<div id="table">
		<table class="table table-striped table-hover table-condensed" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="/"/>
				<col width="200"/>				
				<col width="150"/>
				<col width="200"/>
				<col width="125"/>
				<col width="125"/>
			</colgroup>		  
			<tr class="info">
				<th align="center">플로차트 이름</th>
				<th align="center">고객 세그먼트</th>
				<th align="center">채널</th>
				<th align="center">내용</th>
				<th align="center">삭제</th>
				<th align="center">추가</th>
			</tr>
			
			<c:forEach var="bo" items="${channel_list}">
				<tr>
					<c:if test="${bo.flowchartname != old_flowchartname2 }">
						<td align="center" class="listtd" rowspan="${bo.flowchartrow}" >${bo.flowchartname}</td>
					</c:if>
					<c:if test="${bo.cellname != old_cellname2 }">
						<td align="left" class="listtd" rowspan="${bo.cellrow}" >${bo.cellname}</td>
					</c:if>
					<td align="left" class="listtd"><a href="javascript:fn_clickChannel('${bo.cellid}','${bo.channel_cd}')" class="link">${bo.channel_nm}</a></td>
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
							${fn:substring(bo.toast_title,0,18)}
							<c:if test="${fn:length(bo.toast_title) >= 18 }">...</c:if>
						</c:if>
						<c:if test="${bo.channel_cd == 'SMS' }">
							${fn:substring(bo.sms_msg,0,18)}
							<c:if test="${fn:length(bo.sms_msg) >= 18 }">...</c:if>
						</c:if>
						<c:if test="${bo.channel_cd == 'EMAIL' }">
							${fn:substring(bo.email_name,0,18)}
							<c:if test="${fn:length(bo.email_name) >= 18 }">...</c:if>
						</c:if>
						<c:if test="${bo.channel_cd == 'MOBILE' }">
							${fn:substring(bo.mobile_disp_title,0,18)}
							<c:if test="${fn:length(bo.mobile_disp_title) >= 18 }">...</c:if>
						</c:if>&nbsp;
					</td>
					<td align="center" class="listtd">
						<c:if test="${bo.channel_cd != null && bo.camp_status_cd eq 'EDIT'}">
							<a href="javascript:fn_delChannel('${bo.cellid}','${bo.channel_cd}')" class="link">삭제</a>
						</c:if>&nbsp;
					</td>
					<c:if test="${bo.cellid != old_celid2 }">
						<td align="center" class="listtd" rowspan="${bo.cellrow}">
							<c:if test="${bo.camp_status_cd eq 'EDIT'}">
								<a href="javascript:fn_addChannel('${bo.cellid}')" class="link">추가</a>
							</c:if>
						</td>
					</c:if>
					
					<c:set var="old_celid2"      value="${bo.cellid}"/>
				</tr>
				
				<c:set var="old_flowchartname2" value="${bo.flowchartname}"/>
				<c:set var="old_cellname2"      value="${bo.cellname}"/>
			</c:forEach>
			
			<c:set var="channelSize" value="${fn:length(channel_list)}"/>
			<c:if test="${channelSize eq 0 }">
				<tr>
					<td align="center" class="listtd" colspan="6">플로우차트가 작성되지 않았습니다.</td>
				</tr>
			</c:if>
			
			
		</table>
	</div>
	<!-- /List -->		
</form>
                            
                            </div>
                            <div class="col-lg-1"></div>
                        </div>
                        <!--END BLOCK SECTION -->
                        <div class="col-lg-3"></div>
              
                      </div>
                      <!--END PAGE CONTENT -->
                      
                      
        
        

	

