<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_pop.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>

<script language="JavaScript">
	
     
	$(document).ready(function(){
		window.resizeTo(1080,330);
		
		//채널선택시 페이지 이동
		if("${OFFERCODE}" =="NONE" && "${CHANNELCODE}" =="MOBILE" ){
			
			 $("#CHANNEL_CD").html("<option value="+""+">"+"선택"+"</option><option value="+"MOBILE"+">"+"모바일 알리미"+"</option>");
		}
		
			$("#CHANNEL_CD").bind("change",fn_selectChannel);
		
			parent.setIFrameHeight('channel');

	});
	//창닫기
	function fn_close(){
		//창닫기
		window.close();
	}
	
	
	//채널 선택
	function fn_selectChannel(){
		var form = document.form;
		
		if($("#CHANNEL_CD").val() == "SMS"){
			form.action = "${staticPATH }/contents/channelSms.do";
			form.submit();
		}
		
		if($("#CHANNEL_CD").val() == "EMAIL"){
			form.action = "${staticPATH }/contents/channelEmail.do";
			form.submit();
		}
		
		if($("#CHANNEL_CD").val() == "TOAST"){
			form.action = "${staticPATH }/contents/channelToast.do";
			form.submit();
		}
		
		if($("#CHANNEL_CD").val() == "MOBILE"){
			form.action = "${staticPATH }/contents/channelMobile.do";
			form.submit();
		}
		if($("#CHANNEL_CD").val() == "LMS"){
			form.action = "${staticPATH }/contents/channelLms.do";
			form.submit();
		}
	}
	
</script>
 <!--PAGE CONTENT -->
        <div id="content" style="width:100%; height100%;">
           <!--BLOCK SECTION -->
           <div class="row" style="width:100%; height100%;">
              <div class="col-lg-1"></div>
              <div class="col-lg-10">

              <div class="col-md-12" style="margin-top:0px;">
                <h3>채널 상세 정보</h3>
              </div>
<form name="form" id="form">
<input type="hidden" id="OFFER_CONTENT_ID" name="OFFER_CONTENT_ID" value="${bo.offer_content_id}" />

<input type="hidden" id="offerCode" name="offerCode" value="${OFFERCODE}" />
<input type="hidden" id="channelCode" name="channelCode" value="${CHANNELCODE}" />

	<div id="table">		
		<table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="130"/>
				<col width="250"/>
				<col width="130"/>
				<col width=""/>
			</colgroup>
			<tr>
				<td class="info">캠페인 코드/명</td>
				<td class="tbtd_content" colspan="3">[${bo.campaigncode}]${bo.campaignname}</td>
				<%-- <td class="info">플로차트 이름</td>
				<td class="tbtd_content">${bo.flowchartname}</td> --%>
			</tr>
			<tr>
				<td class="info">채널</td>
				<td class="tbtd_content">
					<select id="CHANNEL_CD" name="CHANNEL_CD"  style="width:125px;">
						<option value="">선택하세요</option>
						<c:forEach var="val" items="${channel_list}">
							
						
							<option value="${val.code_id}">
									${val.code_name}
								</option>
						</c:forEach>					
					</select>				
				</td>
				<td class="info">고객세그먼트</td>
				<td class="tbtd_content">${bo.cellname}</td>
			</tr>
		</table>
	</div>

	<div id="sysbtn" class="col-md-12" style="text-align:right;margin-bottom:10px;">
	  <button type="button" class="btn btn-default btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i>Close</button>
	</div>
</form>
                   </div>
                            <div class="col-lg-1"></div>
                        </div>
                        <!--END BLOCK SECTION -->
                        <div class="col-lg-3"></div>
              
                      </div>
                      <!--END PAGE CONTENT -->
                      
                      
        
 <!--END PAGE CONTENT -->


