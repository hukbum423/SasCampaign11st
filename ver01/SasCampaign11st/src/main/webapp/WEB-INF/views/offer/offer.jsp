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
	
		if("${offerUseChk}" !="N"){
			alert("대상수준이 PCID일경우 오퍼를 사용할수 없습니다\n플로차트 정보를 확인하십시오");
			
			var frm = document.form;
			
	    	frm.action = "/UnicaExt/campaignInfo.do";
	        frm.submit();
	        return;
		};
	
		if("${dummyOfferChk}" !="Y"){
			alert("더미오퍼는 'N'권한 소지자만 사용할수 있습니다\n플로차트 정보를 확인하십시오");
			
			var frm = document.form;
			
	    	frm.action = "/UnicaExt/campaignInfo.do";
	        frm.submit();
	        return;
		};
		
		if("${dummyOfferChkDeviceId}" != "N"){
			alert("대상수준이 DEVICEID일 경우에는 오퍼를 사용할 수 없습니다\n플로차트 정보를 확인하십시오");
			
			var frm = document.form;
			
	    	frm.action = "/UnicaExt/campaignInfo.do";
	        frm.submit();
	        return;
		}
		
	});
	
	
	/* 오퍼 종류 선택시 오퍼정보 입력할수 있는 팝업창 출력 */
	function fn_clickOffer(offer_type_cd, offer_sys_cd, cellid, offerid){
		var type = offer_sys_cd + offer_type_cd;
		
		var frm = document.form;
		
		$("#CELLID").val(cellid);
		$("#OFFERID").val(offerid);
		
		if(type == "OMCU" || type == "MMCU" || type == "MMPN" ){ //일반 쿠폰(OMCU), 도서쿠폰(MMCU), 도서포인트(MMPN)
			pop = window.open('', 'POP_OFFER', 'top=150,left=100, location=no,status=no,toolbar=no,scrollbars=yes');
	        frm.action = "/UnicaExt/offerCoupon.do";
	        frm.target = "POP_OFFER";
	        frm.method = "POST";
	        frm.submit();
	        pop.focus();
		}else if(type == "OMPN" || type == "OMMI" || type == "OMOC" ){//일반포인트(OMPN), 일반마일리지(OMMI), 일반OKCashBack(OMOC)
			pop = window.open('', 'POP_OFFER', 'top=150,left=100, location=no,status=no,toolbar=no,scrollbars=yes');
	        frm.action = "/UnicaExt/offerPoint.do";
	        frm.target = "POP_OFFER";
	        frm.method = "POST";
	        frm.submit();
	        pop.focus();

		}else{
			alert("오퍼 정보가 유효하지 않습니다.");
		}
	}

</script>
 <!--PAGE CONTENT -->
        <div id="content" style="width:100%; height100%;">
           <!--BLOCK SECTION -->
           <div class="row" style="width:100%; height100%;">
              <div class="col-lg-1"></div>
              <div class="col-lg-10">

              <div class="col-md-12 page-header">
                <h3>오퍼 리스트</h3>
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
				<col width="200"/>
				<col width="400"/>
			</colgroup>		  
			<tr class="info">
				<th align="center">플로차트 이름</th>
				<th align="center">고객 세그먼트</th>
				<th align="center">오퍼종류</th>
				<th align="center">노출명</th>
			</tr>
			
			<c:forEach var="bo" items="${offer_list}">
				<tr>
					<c:if test="${bo.flowchartid != old_flowchartid }">
						<td align="center" class="listtd" rowspan="${bo.flowchartrow}" >${bo.flowchartname}&nbsp;</td>
					</c:if>
					<c:if test="${bo.cellid != old_cellid }">
						<td align="left" class="listtd" rowspan="${bo.cellrow}" >${bo.cellname}&nbsp;</td>
					</c:if>
					<td align="left" class="listtd">
						
						<!-- 더미오퍼인경우 -->
						<c:if test="${bo.offer_sys_cd == 'ZZ' }">
							${bo.offername}&nbsp;	
						</c:if>
						
						<!-- 더미오퍼가 아닌경우 오퍼정보를 입력할수 있다 -->
						<c:if test="${bo.offer_sys_cd != 'ZZ' }">
							<a href="javascript:fn_clickOffer('${bo.offer_type_cd}', '${bo.offer_sys_cd}' , '${bo.cellid}' , '${bo.offerid}')" class="link">${bo.offername}&nbsp;	</a>
						</c:if>					
					</td>
					<td align="left" class="listtd">${bo.disp_name}&nbsp;</td>
				</tr>
				
				<c:set var="old_flowchartid" value="${bo.flowchartid}"/>
				<c:set var="old_cellid"      value="${bo.cellid}"/>
			</c:forEach>
			
			<c:set var="offerSize" value="${fn:length(offer_list)}"/>
			<c:if test="${offerSize eq 0 }">
				<tr>
					<td align="center" class="listtd" colspan="4">플로우차트가 작성되지 않았습니다.</td>
				</tr>
			</c:if>
			
			
		</table>
	</div>
	<!-- /List -->

	<!-- 타이틀 -->
		
</form>
                            
                            </div>
                            <div class="col-lg-1"></div>
                        </div>
                        <!--END BLOCK SECTION -->
                        <div class="col-lg-3"></div>
              
                      </div>
                      <!--END PAGE CONTENT -->
                      
                      
        
        


	

