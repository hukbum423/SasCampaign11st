<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_pop.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<link rel="stylesheet" href="${staticPATH }/css/default_h5.css" />


<!-- END PAGE LEVEL  STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>
<script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script>

<script language="JavaScript">
	
	var msg1 = '';
	msg1 += '<span class="ADtxt_banner_wrap">';
	msg1 += '<span class="adtxtW">';
	msg1 += '<span class="userW">';
	msg1 += '';
	
	var msg2 = '';
	msg2 += '</span>';
	msg2 += '</span>';
	msg2 += '<a href="';
	msg2 += '';
	
	var msg3 = '';
	msg3 += '" target="_blank" class="bnr">';
	msg3 += '<img src="';
	msg3 += '';
	
	var msg4 = '';
	msg4 += '">';
	msg4 += '</a>';
	msg4 += '</span>';
	msg4 += '';
	
	$(document).ready(function(){
	
	  window.resizeTo(1080,820);
		
		$("#downBtn, #closeToday, #closeBtn ").bind("click",fn_pre_viewClose);
/*
		if("${bo.channel_priority_yn}" == "N" && "${user.title}" != "N"){
			alert("해당캠페인은 채널우선순위적용이 [N]입니다\n사용자는 권한이 없으므로 채널정보를 입력할수 없습니다");			
		}
*/
		
    $("#VAL_LIST").dblclick(function(){
      $("#TOAST_INPUT_MSG").focus();
      
      if(document.selection){
        cRange = document.selection.createRange();
        cRange.text = "{" + $("#VAL_LIST").val() + "}";
      }else{
        $("#TOAST_INPUT_MSG").val($("#TOAST_INPUT_MSG").val() + "{" + $("#VAL_LIST").val() + "}");
      }
    });
		
		//채널선택시 페이지 이동
		$("#CHANNEL_CD").bind("change",fn_selectChannel);
		
		//이벤트 타입 선택시 링크URL 변경 (토스트 배너일때는 고정값으로 변경[김태욱 매너저 2013-11-22])
// 		$("#TOAST_EVNT_TYP_CD").bind("change",fn_selectLinkUlr);
		
		//대상수준이 PCID일 경우 이벤트 타입에 따른 링크URL 값 변경
		if ("${bo.audience_cd}" == "PCID"){
			$("#TOAST_EVNT_TYP_CD").bind("change",fn_chg_linkUrl);			
		}
		
		if ("${bo.audience_cd}" == "PCID" && "${bo.toast_link_url}" == '' ){
			fn_chg_linkUrl();
		}
		
		opener.setIFrameHeight('channel'); 
    
	});

	
	/* 링크 URL변경 */
// 	function fn_selectLinkUlr(){

// 		var TOAST_EVNT_TYP_CD = $("#TOAST_EVNT_TYP_CD").val();
		
// 		<c:forEach var="val" items="${evt_type}">
// 			if(TOAST_EVNT_TYP_CD == "${val.code_id}"){
// 				$("#TOAST_LINK_URL").val("${val.code_desc}");
// 			}
// 		</c:forEach>
		
// 	}
	
	
	//채널 선택
	function fn_selectChannel(){
		
		var frm = document.form;
		
		if($("#CHANNEL_CD").val() == "SMS"){
			frm.action = "${staticPATH }/contents/channelSms.do";
			frm.submit();
		}
		
		if($("#CHANNEL_CD").val() == "EMAIL"){
			frm.action = "${staticPATH }/contents/channelEmail.do";
			frm.submit();
		}
		
		if($("#CHANNEL_CD").val() == "TOAST"){
			frm.action = "${staticPATH }/contents/channelToast.do";
			frm.submit();
		}
		
		if($("#CHANNEL_CD").val() == "MOBILE"){
			frm.action = "${staticPATH }/contents/channelMobile.do";
			frm.submit();
		}
		if($("#CHANNEL_CD").val() == "LMS"){
			frm.action = "${staticPATH }/contents/channelLms.do";
			frm.submit();
		}
	}
	
	
	/* 등록 */
	function fn_save() {
		
		var offerContentId = $("#OFFER_CONTENT_ID").val();
		
		//유효성 체크
		if(!fn_validation()){
			return;
		}
		
		if(!confirm("저장 하시겠습니까?")){
			return;
		}
		
		$("#TOAST_MSG").val(
			//'<div class="toast_inner">'+
			'<div>'+
			$("#TOAST_INPUT_MSG").val()+ 
			'</div>'+
			'<a href="'+ $("#TOAST_LINK_URL").val() + '">'+
			'<img src="'+ $("#TOAST_IMG_URL").val() +'" alt="">'+
			'</a>'+
			//'</div>'+
			''
		);
		
		
		jQuery.ajax({
			url           : '${staticPATH }/setContentsChannelToast.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
	        		
	        		if(result.CMP_STATUS == "START"){
	        			alert("진행중인 캠페인은 수정할수 없습니다.");
	        		}else{
	        			alert("저장되었습니다");
	        			
	        			//부모창 재조회
	        			opener.fn_getDetailList(offerContentId); 
	        			
	        			//창닫기
	        			fn_close();
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
		
		if("${bo.camp_status_cd}" == "START"){
			$("#btn_save").hide();
			alert("진행중인 캠페인은 수정할수 없습니다.");
			return false;
		}
/*
		if("${bo.channel_priority_yn}" == "N" && "${user.title}" != "N"){
			alert("해당캠페인은 채널우선순위적용이 [N]입니다\n사용자는 권한이 없으므로 채널정보를 입력할수 없습니다");
			return false;			
		}
*/
		
		if($("#TOAST_TITLE").val() ==""){
			alert("토스트배너 타이틀을 입력하세요");
			$("#TOAST_TITLE").focus();
			return false;
		}
		
		if($("#TOAST_INPUT_MSG").val() ==""){
			alert("메세지를 입력하세요");
			$("#TOAST_INPUT_MSG").focus();
			return false;
		}
		
		if($("#TOAST_LINK_URL").val() ==""){
			alert("링크URL을 입력하세요");
			$("#TOAST_LINK_URL").focus();
			return false;
		}

		return true;
	}
	
	
	//창닫기
	function fn_close(){
		
		//창닫기
	  //top.closeChannelAddFrame();
		window.close();
	}
	
	
	//미리보기
	function fn_pre_view(){
		
		if($("#TOAST_TITLE").val() ==""){
			alert("토스트배너 타이틀을 입력하세요");
			$("#TOAST_TITLE").focus();
			return;
		}
		
		if($("#TOAST_INPUT_MSG").val() ==""){
			alert("메세지를 입력하세요");
			$("#TOAST_INPUT_MSG").focus();
			return;
		}
		
		jQuery.ajax({
			url           : '${staticPATH }/contents/channelToastPreview.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
	        		
	        		//사용자변수 적용된 미리보기
	        		$("#to_title").html("<strong style='font-size:15px;'>" + $("#TOAST_TITLE").val() + "</strong>"); 
/*	        		
	        		$("#toastContWrap").html(
	        				'<span class="ADtxt_banner_wrap">'+
	        				'<span class="adtxtW">'+
	        				'<span class="userW">'+
	        				result.TOAST_INPUT_MSG +
							'</span>'+
							'</span>'+
							'<a href="'+ $("#TOAST_LINK_URL").val() + '" target="_blank" class="bnr">'+
							'<img src='+ $("#TOAST_IMG_URL").val() +">" +
							'</a>'+
							'</span>'+
							''
	        		);
*/
					$("#toastContWrap").html(
							//'<div class="toast_inner">'+
							'<div>'+
							result.TOAST_INPUT_MSG+ 
							'</div>'+
							'<a href="'+ $("#TOAST_LINK_URL").val() + '" target="_blank">'+
							'<img src="'+ $("#TOAST_IMG_URL").val() +'" alt="">'+
							'</a>'+
							//'</div>'+
							''
					);
	        		//$("#toastBannerWrap").slideToggle(1);
	        		$(".txtW").width(262);
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
	
	/* 이벤트 타입 선택시 링크URL 값 변경 */
	function fn_chg_linkUrl(){
		
		// 대상수준 PCID 체크 로직 추가
		if ("${bo.audience_cd}" == "PCID"){
			
			jQuery.ajax({
				url           : '${staticPATH }/contentsChannelToastLinkUrl.do',
				dataType      : "JSON",
				scriptCharset : "UTF-8",
				type          : "POST",
		        data          : $("#form").serialize(),
		        success: function(result, option) {

		        	if(option=="success"){
		        		
		        		$("#TOAST_LINK_URL").html("<option value='" + result.TOAST_LINK_URL + "' selected='selected'>" + result.TOAST_LINK_URL + "</option>");
			        	
		        	}else{
		        		alert("에러가 발생하였습니다.");	
		        	}
		        },
		        error: function(result, option) {
		        	alert("에러가 발생하였습니다.");
		        }
			});
			
		}
	}
	
</script>
<!--PAGE CONTENT -->
        <div id="content" style="width:100%; height100%;">
           <!--BLOCK SECTION -->
           <div class="row" style="width:100%; height100%;">
              <div class="col-lg-1"></div>
              <div class="col-lg-10">

              <div class="col-md-12 page-header" style="margin-top:0px;">
                <h3>채널 상세 정보</h3>
              </div>
<form name="form" id="form">
<input type="hidden" id="CAMPAIGNCODE" name="CAMPAIGNCODE" value="${bo.campaigncode}" />
<input type="hidden" id="OFFER_CONTENT_ID" name="OFFER_CONTENT_ID" value="${bo.offer_content_id}" />
<input type="hidden" id="TOAST_MSG" name="TOAST_MSG" value="" />

  <div class="col-lg-12" id="table">
    <table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%"/>
				<col width="35%"/>
				<col width="15%"/>
				<col width="35%"/>
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
					<select id="CHANNEL_CD" name="CHANNEL_CD"  style="width:125px;"<c:if test="${DISABLED == 'Y'}"> disabled="disabled"</c:if>>
						<c:forEach var="val" items="${channel_list}">

							<!-- 대상수준이 PCID일경우TOAST채널만 사용가능 -->
							<c:if test="${bo.audience_cd == 'PCID' && val.code_id == 'TOAST'}">
								<option value="${val.code_id}">
									${val.code_name}
								</option>							
							</c:if>
							
							<c:if test="${bo.audience_cd != 'PCID'}">
								<option value="${val.code_id}" <c:if test="${val.code_id eq CHANNEL_CD}">selected="selected"</c:if>>
									${val.code_name}
								</option>
							</c:if>
														
						</c:forEach>					
					</select>				
				</td>
				<td class="info">고객세그먼트</td>
				<td class="tbtd_content">${bo.cellname}</td>
			</tr>
		</table>
		
		<!-- 토스트 배너 -->
		<div>
			<table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
				<colgroup>
        <col width="15%"/>
        <col width="35%"/>
        <col width="15%"/>
        <col width="35%"/>
				</colgroup>
				<tr>
					<td class="info">토스트배너 타이틀</td>
					<td class="tbtd_content" colspan="3">
						<input type="text" id="TOAST_TITLE" name="TOAST_TITLE" style="width: 450px;" maxlength="500" value="${bo.toast_title}" class="txt"/>
					</td>
				</tr>
				<tr>
					<td class="info">메세지</td>
					<td class="tbtd_content" colspan="3">
<!--  
						 <textarea name="TOAST_INPUT_MSG" id="TOAST_INPUT_MSG" rows="8" cols="110"><c:if test="${bo.channel_cd ==null}">
<strong><c:if test="${bo.audience_cd eq 'MEM_NO'}">{회원명}</c:if><c:if test="${bo.audience_cd eq 'PCID'}">고객</c:if></strong>님!
</span><span class="txtW">

<strong>★★</strong>
<br>[다운받기]</c:if><c:if test="${bo.channel_cd !=''}">${bo.toast_input_msg}</c:if></textarea>
-->
						<textarea name="TOAST_INPUT_MSG" id="TOAST_INPUT_MSG" rows="8" cols="90"><c:if test="${bo.channel_cd ==null}">
<span><b>{회원명}</b>님!</span> 
<p><em></em>
<br>
</p>		
</c:if><c:if test="${bo.channel_cd !=''}">${bo.toast_input_msg}</c:if></textarea>

						<select style="width:150px; height:105px" size="4" id="VAL_LIST" name="VAL_LIST" <%-- <c:if test="${bo.audience_cd != 'MEM_NO'}">disabled="disabled"</c:if> --%>>
							<c:forEach var="val" items="${vri_list}">
								<option value="${val.vari_name}">
									${val.vari_name}
								</option>
							</c:forEach>
						</select>
					</td>				
				</tr>
				<tr>
					<td class="info">링크URL</td>
					<td class="tbtd_content" colspan="3">
						<select id="TOAST_LINK_URL" name="TOAST_LINK_URL"  style="width:570px;">
							
							<!-- 대상수준이 MEM_NO 일때 -->
<%-- 							<c:if test="${bo.audience_cd eq 'MEM_NO'}"> --%>
								<c:forEach var="val" items="${linkUrl}">
									<option value="${val.code_name}"  <c:if test="${val.code_name eq bo.toast_link_url}">selected="selected"</c:if>>
										${val.code_name}
									</option>
								</c:forEach>
<%-- 							</c:if> --%>
							
							<!-- 대상수준이 PCID 일때 -->
<%-- 
							<c:if test="${bo.audience_cd eq 'PCID'}">
								
										<option value="${bo.toast_link_url}" selected="selected">
											${bo.toast_link_url}
										</option>
									
							</c:if>
 --%>							
						</select>
					</td>
				</tr>
				<tr>
					<td class="info">이미지URL</td>
					<td class="tbtd_content" colspan="3"><input type="text" id="TOAST_IMG_URL" name="TOAST_IMG_URL" style="width: 550px;" value="${bo.toast_img_url}" maxlength="250" class="txt"/></td>
				</tr>
				<tr>
					<td class="info">메세지설명</td>
					<td class="tbtd_content" colspan="3"><input type="text" id="TOAST_MSG_DESC" name="TOAST_MSG_DESC" style="width: 550px;" value="${bo.toast_msg_desc}" maxlength="50" class="txt"/></td>				
				</tr>			
				<tr>
					<td class="info">노출순위</td>
					<td class="tbtd_content" colspan="3">
						<select id="TOAST_PRIORITY_RNK" name="TOAST_PRIORITY_RNK"  style="width:60px;">
							<c:forEach var="val" items="${priority_rank}">
								
								<!-- 캠페인의 채널우선순위 적용여부 체크 -->
								<c:if test="${bo.channel_priority_yn == 'N' && bo.channel_priority_yn == val.code_id}">"
									<option value="${val.code_id}">
										${val.code_name}
									</option>
								</c:if>
								<c:if test="${bo.channel_priority_yn == 'Y' && val.code_id != 'N' }">
									
									<!-- 사용자의 권한체크(user.title) 우선순위 권한에 따라 보여준다 -->
									<%-- <c:if test="${user.title =='N' || user.title <= val.code_id  }"> --%>	
										<option value="${val.code_id}" <c:if test="${val.code_id eq bo.toast_priority_rnk}">selected="selected"</c:if>>
											${val.code_name}
										</option>
									<%-- </c:if>								 --%>
								</c:if>
								
							</c:forEach>					
						</select>
					</td>				
				</tr>
				<tr>
					<td class="info">이벤트타입</td>
					<td class="tbtd_content" colspan="3">
						<select id="TOAST_EVNT_TYP_CD" name="TOAST_EVNT_TYP_CD"  style="width:90px;"  <c:if test="${bo.audience_cd == 'MEM_NO'}">disabled="disabled"</c:if>>
							<c:forEach var="val" items="${evt_type}">
								<option value="${val.code_id}"  <c:if test="${val.code_id eq bo.toast_evnt_typ_cd}">selected="selected"</c:if>>
									${val.code_name}
								</option>
							</c:forEach>
						</select>
					</td>				
				</tr>
				<tr>
					<td class="info">등록자</td>
					<td class="tbtd_content">${bo.create_nm}</td>
					<td class="info">등록일시</td>
					<td class="tbtd_content">${bo.create_dt}</td>
				</tr>
				<tr>
					<td class="info">수정자</td>
					<td class="tbtd_content">${bo.update_nm}</td>
					<td class="info">수정일시</td>
					<td class="tbtd_content">${bo.update_dt}</td>
				</tr>
			</table>
		</div>
	</div>		

	<div id="sysbtn" class="col-md-12" style="text-align:right;margin-bottom:10px;">
		<button type="button" class="btn btn-success btn-sm" onclick="fn_pre_view();"><i class="fa fa-eye" aria-hidden="true"></i> 미리보기</button>
		<button type="button" class="btn btn-success btn-sm" onclick="fn_save();"><i class="fa fa-floppy-o" aria-hidden="true"></i> 저장</button>	
		<button type="button" class="btn btn-success btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i> 닫기</button>
	</div>	

<!--
<div class="html_ToastNone2" id="toastBannerWrap" style="display: none; bottom: 0px;">
	<div class="toastbanner_bar2" id="toastTitle">
		<div class="tit">

			<span id="to_title"></span>

		</div>
		<a class="btn_down" id="downBtn"><em>내리기</em></a>
	</div>
	<div class="toastbanner_wrap2">
		<div class="toast_cnt" id="toastContWrap" style="padding-left: 11px; padding-top: 12px;">


		</div>
		<div class="toast_today2" style="margin-top: -13px;">
			<a class="btn_today" id="closeToday"><em>오늘 다시 열지 않기</em></a>
			<a class="btn_close" id="closeBtn" href="#"><em>닫기</em></a>
		</div>
	</div>
</div>
position: relative; float: left; width: 140px; height: 70px; margin-right: 3px;
-->
<div class="toastbnr_wrap" id="toastBannerWrap" style="display: none;left:45%;">
<h3><button type="button" id="to_title"></button></h3>
<div class="toast_inner" id="toastContWrap"></div>
<div class="close_wrap">
<label for="tClose" id="closeToday"><input type="checkbox" id="tClose" checked="">오늘 다시 열지 않기</label>
<button type="button" id="closeBtn"><i class="fa fa-times" aria-hidden="true"></i> 닫기</button>
</div>
</div>

</form>

</body>
</html>
