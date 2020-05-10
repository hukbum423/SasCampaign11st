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

<script>
	///////////////////////////////////////////////////////////////
	// 창열리고 처리
	$(document).ready(function(){
		// KANG-20200510: reset the size of this popup window
		window.resizeTo(1000, 950);
		if (!true) alert(">>>>> campaignChangeStatusList.jsp = .${campaignid}.${cellid}.${channel_cd}.${disp_dt}.${ENABLE_PROCESS}.");  // KANG-20200413
		
		// KANG-20200510: get the campaign list
		fn_campaignList();
	});

	///////////////////////////////////////////////////////////////
	//창닫기
	function fn_close(){
		window.close();
	}

	///////////////////////////////////////////////////////////////
	// 캠페인 리스트 for some campaign, and pagination
	function fn_campaignList() {       // KANG-20190410: analyzing for pagination
		if (!true) console.log(">>>>> fn_campaignList: 캠페인 목록 조회");
		jQuery.ajax({
			url           : '${staticPATH }/getCampaignStatusList.do?serverType=${staticServerType }',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			async         : true,
			type          : "POST",
			data          : {
				treeValue     : $("#TREE_VALUE").val(),
				selectPageNo  : $("#selectPageNo").val()
			},
			success: function(result, option) {
				if (option == "success"){
					var list = result.CampaignList;
					$("#campaignList > tbody tr").remove();
					var txt ="";
					if (list.length > 0){
						$.each(list, function(key){
							var data = list[key];
							txt = "<tr>";
							txt += "<td align=\"center\" class=\"listtd\">"+data.campaigncd+"</td>";
							txt += "<td align=\"left\"   class=\"listtd\"><a href=\"javascript:fn_getCampaignDtl('"+data.campaignid+"');\" class='link'>"+data.campaignnm+"</td>";
							//txt += "<td align=\"left\"   class=\"listtd\">"+nvl(data.campaign_desc,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+data.campaign_owner_nm+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.run_dttm,'')+"</td>";
							txt += "</tr>";
							$("#campaignList > tbody:last").append(txt);
						});
						//페이징 처리 시작!!
						//var page = _pagingNavi(result.selectPage, result.pageRange, result.pageStart, result.pageEnd, result.totalPage, "fn_pageMove");
						//$("#paging_layer").html(page);
						//페이징 처리 종료
					} else {
						txt += "<tr><td align=\"center\" class=\"listtd\" colspn=\"\9\">데이터가 없습니다.</td></tr>";
						$("#campaignList > tbody:last").append(txt);
					}
					//빈 row 채우기
					if (list.length > 0 && list.length < result.rowRange ){
						for(var i=list.length; i<result.rowRange; i++){
							txt +="<tr>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
							txt +="</tr>";
						}
					}
				} else {
					alert("에러가 발생하였습니다.");
				}
			},
			error: function(result, option) {
				alert("에러가 발생하였습니다.");
			}
		});
	};

	///////////////////////////////////////////////////////////////
	// get details of some campaign
	function fn_getCampaignDtl(campaignid) {
		if (!true) alert("KANG.fn_getCampaignDtl: campaignid = " + campaignid);
		$("#optionDiv").hide();
		var reTurnDivView = fn_campaignInfoAll(campaignid);
		if (reTurnDivView != "ERROR") {
			$("#optionDiv").show();
		}
	}

	///////////////////////////////////////////////////////////////
	// 캠페인에 대한 정보를 모두 불러온다.
	function fn_campaignInfoAll(campaignid) {    // KANG-20190410: analyzing. load all
		if (!true) console.log("KANG.fn_campaignInfoAll: 캠페인에 대한 정보를 모두 불러온다.");
		jQuery.ajax({
			url           : '${staticPATH }/getCampaignInfoAll.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			async         : true,
			type          : "POST",
			data          : {
				campaignid   : campaignid
			},
			beforeSend:function(){
				//wrapWindowByMask();
			},
			success: function(result, option) {
				if (option == "success") {
					if (true) console.log("KANG-fn_campaignInfoAll: result.runScheduleCnt=" + result.runScheduleCnt);
					if (true) console.log("KANG-fn_campaignInfoAll: result.batchDtCheck=" + result.batchDtCheck);
					if (true) console.log("KANG-fn_campaignInfoAll: result.scheduleBo.rsrv_gubun_code_name=" + result.scheduleBo.rsrv_gubun_code_name);
					if (result.batchDtCheck == "ERROR") {
						alert("데이터 전송 방식이 Batch일 경우 \n\n캠페인 시작일을 내일부터 지정 할 수 있습니다.")
						return "ERROR";
					} else {
						// 캠페인 요약/속성 정보 START #####################################
						if (true) {
							console.log("KANG.fn_campaignInfoAll: 캠페인 요약/속성 정보");
							console.log("KANG.fn_campaignInfoAll: result.bo.campaignname = " + result.bo.campaignname);
						}
						$('#summary').css('display', '');
						$('#CAMPAIGNNAME').html(result.bo.campaignname);
						$('#CAMPAIGNCODE').html(result.bo.campaigncode);
						$('#CAMP_BGN_DT1').html(result.bo.camp_bgn_dt1);
						$('#CAMP_BGN_DT2').html(result.bo.camp_bgn_dt2);
						$('#CAMP_BGN_DT3').html(result.bo.camp_bgn_dt3);
						$('#CAMP_END_DT1').html(result.bo.camp_end_dt1);
						$('#CAMP_END_DT2').html(result.bo.camp_end_dt2);
						$('#CAMP_END_DT3').html(result.bo.camp_end_dt3);
						$('#CAMP_TERM_DAY').html(result.bo.camp_term_day);
						if (result.bo.camp_term_day == null){
							$("#cmpgnDtType1").show();
							$("#cmpgnDtType2").hide();
						} else if (result.bo.camp_term_day != null){
							$("#cmpgnDtType1").hide();
							$("#cmpgnDtType2").show();
						}
						if (true) {
							console.log("KANG.fn_campaignInfoAll: result.bo.camp_status_cd : " + result.bo.camp_status_cd);
							console.log("KANG.fn_campaignInfoAll: result.runScheduleCnt : " + result.runScheduleCnt);
						}
						//if (result.bo.camp_status_cd == "START" && parseInt(result.runScheduleCnt) > 0){
						if (true){
							$("#campaignStopDiv").show();   // [캠페인 중지]
						} else {
							$("#campaignStopDiv").hide();
						}
						$('#AUDIENCE_NM').html(result.bo.audience_nm);
						$('#MANUAL_TRANS_NM').html(result.bo.manual_trans_nm);
						$('#OFFER_DIRECT_YN').html(result.bo.offer_direct_yn);
						$('#CHANNEL_PRIORITY_YN').html(result.bo.channel_priority_yn);
						$('#CREATE_NM').html(result.bo.create_nm);
						$('#CREATE_DT').html(result.bo.create_dt);
						$('#UPDATE_NM').html(result.bo.update_nm);
						$('#UPDATE_DT').html(result.bo.update_dt);
						$('#CAMPAIGNID').val(result.bo.campaignid);
						$('#CAMPAIGNNAME_SUMMARY').text(result.boSummary.campaignname);
						$('#CAMPAIGNCODE_SUMMARY').text(result.boSummary.campaigncode);
						var tmpCampaignDetail = "";
						if (result.boSummary.campaign_detail == "11"){
							tmpCampaignDetail = "전사";
						} else if (result.boSummary.campaign_detail == "12"){
							tmpCampaignDetail = "카테고리";
						} else if (result.boSummary.campaign_detail == "13"){
							tmpCampaignDetail = "쇼킹딜";
						} else if (result.boSummary.campaign_detail == "14"){
							tmpCampaignDetail = "개인화";
						} else if (result.boSummary.campaign_detail == "15"){
							tmpCampaignDetail = "실시간";
						} else if (result.boSummary.campaign_detail == "16"){
							tmpCampaignDetail = "내부기타";
						} else if (result.boSummary.campaign_detail == "121"){
							tmpCampaignDetail = "카드사";
						} else if (result.boSummary.campaign_detail == "122"){
							tmpCampaignDetail = "제휴사";
						} else if (result.boSummary.campaign_detail == "123"){
							tmpCampaignDetail = "외부기타";
						}
						$('#CAMPAIGN_DETAIL').text(tmpCampaignDetail);
						var tmpCampaignOfferCostGubun = "";
						if (result.boSummary.campaign_offer_cost_gubun == "1"){
							tmpCampaignOfferCostGubun = "활성";
						} else if (result.boSummary.campaign_offer_cost_gubun == "2"){
							tmpCampaignOfferCostGubun = "홍보";
						} else if (result.boSummary.campaign_offer_cost_gubun == "3"){
							tmpCampaignOfferCostGubun = "휴면";
						} else if (result.boSummary.campaign_offer_cost_gubun == "4"){
							tmpCampaignOfferCostGubun = "신규";
						}
						$('#CAMPAIGN_OFFER_COST_GUBUN').text(tmpCampaignOfferCostGubun);
						// Schedule 값세팅
						$('#scheduleCampaignCode').text("[" + result.boSummary.campaigncode+"] " + result.boSummary.campaignname);
						$('#scheduleCAMPAIGNCODE').val(result.boSummary.campaigncode);
						$('#scheduleCampaignId').val(result.bo.campaignid);
						var tmpGubun = "";
						if (result.boSummary.campaigngubun == "1"){
							tmpGubun = "내부";
						} else if (result.boSummary.campaigngubun == "2"){
							tmpGubun = "외부";
						}
						$("#scheduleDel").show();
						$("#scheduleEdit").show();
						$("#scheduleAdd").show();
						$("#viewMultiDiv").hide();
						$("#scheduleAddTr").show();
						var tmpType = "";
						if (result.boSummary.campaigntype == "1"){
							tmpType = "일반캠페인";
						} else if (result.boSummary.campaigntype == "2"){
							tmpType = "A|B캠페인";
						} else if (result.boSummary.campaigntype == "3"){
							tmpType = "멀티캠페인";
							$("#scheduleDel").hide();
							$("#scheduleEdit").hide();
							$("#scheduleAdd").hide();
							$("#viewMultiDiv").show();
							$("#scheduleAddTr").hide();
						}
						if (!true) {   // KANG-20190410: to rm
							$("#scheduleDel").show();
							$("#scheduleEdit").show();
							$("#scheduleAdd").show();
							$("#viewMultiDiv").hide();
						}
						result.boSummary.campaigntype
						$('#CAMPAIGNGUBUN').text(tmpGubun);
						$('#CAMPAIGNTYPE').text(tmpType);
						$('#SENDDATETYPE').text(result.boSummary.senddatetype);
						// 캠페인 요약/속성 정보 END ##################################### ///

						// 캠페인 오퍼 정보 START #####################################
						if (true) {
							console.log("KANG.fn_campaignInfoAll: 캠페인 오퍼 정보");
							console.log("KANG.fn_campaignInfoAll.result.offer_list : " + result.offer_list);
							console.log("KANG.fn_campaignInfoAll.result.offerUseChk : " + result.offerUseChk);
							console.log("KANG.fn_campaignInfoAll.result.dummyOfferChk : " + result.dummyOfferChk);
							console.log("KANG.fn_campaignInfoAll.result.dummyOfferChk : " + result.dummyOfferChk);
						}
						var list = result.offer_list;
						var txt;
						txt  = '<table class="table table-striped table-hover table-condensed table-bordered" >';
						txt += '<colgroup>';
						txt += '<col width="30%"/>';
						txt += '<col width="25%"/>';
						txt += '<col width="45%"/>';
						txt += '</colgroup>     ';
						txt += '<tr class="info">';
						txt += '<th align="center">고객 세그먼트</th>';
						txt += '<th align="center">오퍼종류</th>';
						txt += '<th align="center">노출명</th>';
						txt += '</tr>';
						$.each(list, function(key){
							var data = list[key];
							//console.log(data.campaignid + " / " + data.campaignname);
							txt += "<tr>";
							txt += "<td>" + data.cellname + "</td>";
							if (data.offer_sys_cd == 'ZZ'){
								txt += "<td>" + data.offername + "</td>";
							} else {
								txt += "<td>";
								// txt += "<a href=\"javascript:fn_clickOffer('" + data.offer_type_cd + "', '" + data.offer_sys_cd + "' , '" + data.cellid + "' , '" + data.offerid + "', '" + data.campaignid + "')\" class=\"link\">" + data.offername + "&nbsp; </a>";
								txt += data.offername;
								txt += "</td>";
							}
							txt += "<td>" + nvl(data.disp_name,'') + "</td>";
							txt += "</tr>";
						});
						txt += "</table>";
						$("#offerList").html(txt);
						// 캠페인 오퍼 정보 END ##################################### ///

						// 캠페인 채널 정보 START #####################################
						if (true) {
							console.log("KANG.fn_campaignInfoAll: 캠페인 채널 정보");
							console.log("KANG.fn_campaignInfoAll.result.channel_list : " + result.channel_list);
						}
						var list = result.channel_list;
						var txt;
						txt  = "<table class='table table-striped table-hover table-condensed table-bordered' width='100%' border='0' cellpadding='0' cellspacing='0'>";
						if (list.length>0) {
							if (result.channelValiChk == "N"){
								alert("대상수준이 PCID일경우에는 토스트배너만 사용이 가능합니다");
								return;
							} else if (result.channelValChkforMobile != "Y"){
								alert("대상수준이 DEVICEID일 경우에는 모바일 알리미 채널만 사용이 가능합니다.");
								return;
							} else {
								var old_celid2 = "";
								var old_cellname2 = "";
								txt += "<colgroup>";
								txt += "<col width='15%'/>";
								txt += "<col width='15%'/>";
								txt += "<col width=''/>";
								//txt += "<col width='10%'/>";
								//txt += "<col width='10%'/>";
								txt += "</colgroup>";
								$.each(list, function(key){
									var data = list[key];
									txt += "<tr>";
									if (data.cellname != old_cellname2){
										txt += "<td align=\"left\" class=\"listtd\"rowspan="+ data.cellrow +">"+ data.cellname +"</td>";
									}
									if (data.channel_nm != null){
										//txt += "<td align=\"left\" class=\"listtd\"><a href=\"javascript:fn_clickChannel('"+data.cellid+"','"+data.channel_cd+"');\" class='link'>"+data.channel_nm+"</a></td>";
										txt += "<td align=\"left\" class=\"listtd\">"+ data.channel_nm +"</td>";
									} else {
										txt += "<td align=\"left\" class=\"listtd\"></td>";
									}
									txt += "<td align=\"left\" class=\"listtd\"";
									if (data.channel_cd =='TOAST'){
										txt += "title ='"+data.toast_title+"'";
									}
									if (data.channel_cd =='SMS'){
										txt += "title ='"+data.sms_msg+"'";
									}
									if (data.channel_cd =='EMAIL'){
										txt += "title ='"+ data.email_name+"'";
									}
									if (data.channel_cd =='MOBILE'){
										txt += "title ='"+  data.mobile_disp_title+"'";
									}
									if (data.channel_cd =='LMS'){
										txt += "title ='"+  data.lms_title+"'";
									}
									txt +=">";
									if (data.channel_cd == 'TOAST'){
										txt +=(data.toast_title).substring(0,45);
										if ((data.toast_title).substring(0,45).length>=18){
											txt +='...';
										}
									}
									if (data.channel_cd == 'SMS'){
										txt +=(data.sms_msg).substring(0,45);
										if ((data.sms_msg).substring(0,45).length>=18){
											txt +='...';
										}
									}
									if (data.channel_cd == 'EMAIL'){
										txt +=(data.email_name).substring(0,45);
										if ((data.email_name).substring(0,45).length>=18){
											txt +='...';
										}
									}
									if (data.channel_cd == 'MOBILE'){
										txt +=(data.mobile_disp_title).substring(0,45);
										if ((data.mobile_disp_title).substring(0,45).length>=18){
											txt +='...';
										}
									}
									if (data.channel_cd == 'LMS'){
										txt +=(data.lms_title).substring(0,45);
										if ((data.lms_title).substring(0,45).length>=18){
											txt +='...';
										}
									}
									txt +="</td>";
									/*
									if (data.channel_cd != null && data.camp_status_cd =='EDIT'){
										txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_delChannel('"+data.cellid+"','"+data.channel_cd+"');\" class='link'>"+'삭제'+"</a></td>";
									} else {
										txt += '<td></td>';
									}
									if (data.cellid !=old_celid2){
										if (data.camp_status_cd =='EDIT'){
											txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_addChannel('"+data.cellid+"','"+data.campaignid+"');\" class='link' rowspan="+data.cellrow+">"+'추가'+"</a></td>";
											//txt += '<td></td>';
										} else {
											txt += '<td></td>';
										}
									} else {
										txt += '<td></td>';
									}
									*/
									old_celid2 = data.cellid;
									old_cellname2 =  data.cellname;
									txt += "</tr>";
								});
							}
						} else {
							txt += "<td align=\"center\" class=\"listtd\" colspn=\"5\">데이터가 없습니다.</td>";
						}
						txt += "</table>";
						$("#search_channel").html(txt);
						// 캠페인 채널 정보 END ##################################### ///

						// 캠페인 일정 정보 START #####################################
						if (true) {
							console.log("KANG.fn_campaignInfoAll: 캠페인 일정 정보");
							console.log("KANG.fn_campaignInfoAll.result.scheduleBo.rsrv_gubun_code_name : " + result.scheduleBo.rsrv_gubun_code_name);
						}
						if (false && (result.scheduleBo.rsrv_gubun_code_name == null || result.scheduleBo.rsrv_gubun_code_name == "null")) {   // KANG-20200508
							$("#scheduleTable").hide();
							$("#scheduleListDiv").hide();
							$('#paging_layer2').hide();
						} else {
							$("#scheduleTable").show();
							$("#scheduleListDiv").show();
							$("#selectPageNo2").val("1");
							$('#paging_layer2').show();
							fn_searchSchedule();
							if (option == "success"){
								var scheduleScheduler = "";
								var scheduleRsrvDate = "";
								// 일정
								scheduleScheduler += result.scheduleBo.rsrv_gubun_code_name;
								if (result.scheduleBo.rsrv_gubun_code == '03'){
									scheduleScheduler += result.scheduleBo.rsrv_day + "일";
								}
								if (result.scheduleBo.rsrv_gubun_code == '02' && result.scheduleBo.rsrv_week_day.indexOf('2') != '-1'){
									scheduleScheduler += "월";
								}
								if (result.scheduleBo.rsrv_gubun_code == '02' && result.scheduleBo.rsrv_week_day.indexOf('3') != '-1'){
									scheduleScheduler += "화";
								}
								if (result.scheduleBo.rsrv_gubun_code == '02' && result.scheduleBo.rsrv_week_day.indexOf('4') != '-1'){
									scheduleScheduler += "수";
								}
								if (result.scheduleBo.rsrv_gubun_code == '02' && result.scheduleBo.rsrv_week_day.indexOf('5') != '-1'){
									scheduleScheduler += "목";
								}
								if (result.scheduleBo.rsrv_gubun_code == '02' && result.scheduleBo.rsrv_week_day.indexOf('6') != '-1'){
									scheduleScheduler += "금";
								}
								if (result.scheduleBo.rsrv_gubun_code == '02' && result.scheduleBo.rsrv_week_day.indexOf('7') != '-1'){
									scheduleScheduler += "토";
								}
								if (result.scheduleBo.rsrv_gubun_code == '02' && result.scheduleBo.rsrv_week_day.indexOf('1') != '-1'){
									scheduleScheduler += "일";
								}
								if (result.scheduleBo.rsrv_gubun_code == '01'
										|| result.scheduleBo.rsrv_gubun_code == '02'
										|| result.scheduleBo.rsrv_gubun_code == '03'
										|| result.scheduleBo.rsrv_gubun_code == '04'){
									scheduleScheduler += result.scheduleBo.rsrv_hour + "시 " + result.scheduleBo.rsrv_minute + "분";
								}
								if (result.scheduleBo.rsrv_gubun_code == '06'){
									if (result.scheduleBo.rsrv_everytime == 'Y'){
										scheduleScheduler += "매시간 " + result.scheduleBo.rsrv_timehourfrom + "시 ~";
									}
									scheduleScheduler += result.scheduleBo.rsrv_timehourto + "시 " + result.scheduleBo.rsrv_timemin + "분";
								}
								// 추출기간
								scheduleRsrvDate += "";
								if (result.scheduleBo.rsrv_gubun_code != '05'){
									scheduleRsrvDate += result.scheduleBo.rsrv_start_dt + " ~ " + result.scheduleBo.rsrv_end_dt;
								}
								if (true) console.log("KANG-fn_campaignInfoAll: scheduleScheduler.length = " + scheduleScheduler.length);
								if (true) console.log("KANG-fn_campaignInfoAll: ", scheduleScheduler);
								$("#scheduleScheduler").text((scheduleScheduler == "" || scheduleScheduler == null || scheduleScheduler == "null") ? "" : scheduleScheduler);
								$("#scheduleRsrvDate").text((scheduleRsrvDate == "null ~ null" || scheduleRsrvDate == " ~ ")?"":scheduleRsrvDate);
								$("#camp_term_cd").val(result.scheduleBo.camp_term_cd);
								$("#camp_end_dt").val(result.scheduleBo.camp_end_dt);
								$("#channel_priority_yn").val(result.scheduleBo.channel_priority_yn);
								$("#minDispDt").val(result.scheduleBo.minDispDt);
							} else {
								alert("에러가 발생하였습니다.");
							}
						}
						//console.log("result.scheduleBo.camp_status_cd : " + result.scheduleBo.camp_status_cd);
						if (result.scheduleBo.camp_status_cd != 'START'){
							$("#multiSaveBtn").show();
						} else {
							$("#multiSaveBtn").hide();
						}
						// 캠페인 일정 정보 END ##################################### ///
						return "SUCC";
					}
				} else {
					alert("에러가 발생하였습니다.");
				}
			},
			complete:function() {
				// closeWindowByMask();
			},
			error: function(result, option) {
				alert("에러가 발생하였습니다.");
			}
		});
	}
	
	///////////////////////////////////////////////////////////////
	// 일정 목록 조회
	function fn_searchSchedule() {   // KANG-20190410: analyzing
		if (true) console.log("KANG.fn_searchSchedule: 일정 목록 조회 >> " + $("#scheduleCampaignId").val() + ", " + $("#scheduleCAMPAIGNCODE").val());
		jQuery.ajax({
			url           : '${staticPATH }/getScheduleStatusList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			async         : true,
			type          : "POST",
			data          : { 
				CampaignId      : $("#scheduleCampaignId").val(),
				CAMPAIGNCODE    : $("#scheduleCAMPAIGNCODE").val(),
				selectPageNo2   : $("#selectPageNo2").val(),
				SEARCH_TYPE     : $("#SEARCH_TYPE").val()
			},
			success: function(result, option) {
				if (option == "success"){
					var list = result.ScheduleList;
					$("#LIST_LENGTH").val(list.length);
					$("#scheduleListTable > tbody tr").remove();
					var txt ="";
					if (list.length > 0) {
						$.each(list, function(key){
							var data = list[key];
							txt += "<tr>";
							txt += "<td align=\"center\" class=\"listtd\">" + data.num + "</td>";
							if (true || data.run_start_dt == null) {  // KANG-20200508
								txt += "<td align=\"center\" class=\"listtd\"><input type='checkbox' name='CHK_DATE' value='"+ data.rsrv_dt +"' style='margin:-13px 5px -5px 0px;' /></td>";
							} else {
								txt += "<td align=\"center\" class=\"listtd\"><input type='checkbox' disabled='disabled' style='margin:-13px 5px -5px 0px;' /></td>";
							}
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.rsrv_dt,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.run_start_dt,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.run_end_dt,'')+"</td>";
							var tmpStatVal = data.run_status;
							if (tmpStatVal != "")
							var tmpStatArr = tmpStatVal.split("(");
							//console.log(tmpStatArr.length);
							//console.dir(tmpStatArr);
							if (tmpStatArr.length == 2){
								txt += "<td align=\"center\" class=\"listtd\">"+nvl(tmpStatArr[0],'')+"</td>";
								txt += "<td align=\"center\" class=\"listtd\">"+nvl(tmpStatArr[1].replace(')', ''),'')+"</td>";
							} else {
								txt += "<td align=\"center\" class=\"listtd\">"+nvl(tmpStatArr[0],'')+"</td>";
								txt += "<td align=\"center\" class=\"listtd\"></td>";
							}
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_nm,'')+"</td>";
							txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_dt,'')+"</td>";
							txt += "</tr>";
						});
					} else {
						txt += "<tr><td align=\"center\" class=\"listtd\" colspan=\"\9\">데이터가 없습니다.</td></tr>";
						for (var i=1; i<result.rowRange; i++) {
							/* 
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
							*/
						}
					}
					//빈 row 채우기
					if (list.length > 0 && list.length < result.rowRange) {
						for (var i=list.length; i<result.rowRange; i++) {
							/* 
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
							*/
						}
					}
					//txt += "</table>";
					$("#scheduleListTable > tbody:last").append(txt);
					//페이징 처리 시작!!
					//var page = _pagingNavi(result.selectPage2, result.pageRange, result.pageStart, result.pageEnd, result.totalPage, "fn_pageMove2");
					//$("#paging_layer2").html(page);
					//페이징 처리 종료
					if (true) $('#chkParent').removeAttr('checked');
				} else {
					alert("에러가 발생하였습니다.");
				}
			},
			beforeSend:function(){
			},
			complete:function(){
			},
			error: function(result, option) {
			  alert("에러가 발생하였습니다.");
			}
		});
	};

	///////////////////////////////////////////////////////////////
	// 일정 선택 변경
	function fn_changeStatus() {
		if (true) console.log(">>>>> fn_changeStatus: 일정 선택 상태변경");
		var cntChecked = $("input:checkbox[name='CHK_DATE']:checked").length;
		if (cntChecked == 0) {
			alert("상태변경 할 일정을 선택하세요");
			return;
		} else if (cntChecked != 1) {
			alert("상태변경 할 일정은 1개만 선택하세요.");
			return;
		}
		if (!confirm($("input:checkbox[name='CHK_DATE']:checked").length + "건을 상태변경 하시겠습니까?")){
			return;
		}
		
		if (true) { // KANG-20190410: to rm
			/*
			$("#formSchedule").serialize()
				TO_DATE=
				&TO_DATE_P1=
				&TO_DATE_P2=
				&CAMPAIGNCODE=CAMP718
				&CampaignId=718
				&selectPageNo=
				&LIST_LENGTH=15
				&camp_term_cd=01
				&camp_end_dt=2018-01-01
				&channel_priority_yn=Y
				&minDispDt=
				&SEARCH_TYPE=%EC%A0%84%EC%B2%B4
				&RSRV_DT=
				&RSRV_HOUR=8
				&RSRV_MINUTE=0
				&CHK_DATE=2018-01-09+16%3A10
				&CHK_DATE=2018-01-11+22%3A00
				&CHK_DATE=2018-01-17+14%3A00
				&CHK_DATE=2018-01-21+10%3A55
				&CHK_DATE=2018-01-21+15%3A38
				&CHK_DATE=2018-01-23+16%3A03
				&CHK_DATE=2018-01-23+18%3A45
				&CHK_DATE=2018-01-23+22%3A09
			*/
			console.log("KANG.fn_changeStatus(): " + $("#formSchedule").serialize());
		}
		jQuery.ajax({
			url           : '${staticPATH }/updateScheduleStatusList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			async         : true,
			type          : "POST",
			data          : $("#formSchedule").serialize(),
			success: function(result, option) {
				if (option == "success"){
					alert("일정상태가 변경 되었습니다");
					// fn_selectSearchType();
				} else {
					alert("에러가 발생하였습니다.");
				}
			},
			beforeSend:function(){
			},
			complete:function(){
				fn_searchSchedule();
			},
			error: function(result, option) {
				alert("에러가 발생하였습니다.");
			}
		});
	}

	///////////////////////////////////////////////////////////////
	// KANG-20190411: for pagination
	/*
	function _pagingNavi(selectPage, pageRange, pageStart, pageEnd, totalPage, pageMove){
		if (true) {
			var msg = " => ";
			msg += "selectPage=" + selectPage;
			msg += ", pageRange=" + pageRange;
			msg += ", pageStart=" + pageStart;
			msg += ", pageEnd=" + pageEnd;
			msg += ", totalPage=" + totalPage;
			msg += ", pageMove=" + pageMove;
			console.log("KANG._pagingMavi:" + msg);
		}
		var page = "";
		//이전페이지 만들기
		if (selectPage > pageRange) {
			// page +="<a href=\"javascript:fn_pageMove("+ (Number(result.pageStart) - Number(result.pageRange)) +" );\" ><img src=\"<c:url value='/img/btn_left.gif'/>\" width='13px;' height='13px;' /></a>&nbsp;";
			page += "<li><a href=\"javascript:" + pageMove + "(" + (Number(pageStart) - Number(pageRange)) + ");\" aria-label='Previous'><span aria-hidden='true'>&laquo;</span></a></li>";
		}
		//페이지 숫자
		for (var i = pageStart; i <= pageEnd; i++) {
			var tmpActive = "";
			if(selectPage == i)	{
				tmpActive = "style='background-color:#EEEEEE'";
			}

			page += "<li ><a href=\"javascript:" + pageMove + "(" + i + ");\" " + tmpActive + ">" + i + "</a></li>";
		}
		//다음페이지 만들기
		if (totalPage != pageEnd) {
			// page +="&nbsp;<a href=\"javascript:fn_pageMove("+ (Number(result.pageStart) + Number(result.pageRange)) +" );\" ><img src=\"<c:url value='/img/btn_right.gif'/>\" width='13px;' height='13px;' /></a>";
			page += "<li><a href=\"javascript:" + pageMove + "(" + (Number(pageStart) + Number(pageRange)) + ");\" aria-label='Next'><span aria-hidden='true'>&raquo;</span></a></li>";
		}
		return page;
	}
	*/
</script>



<!--PAGE CONTENT: START -->
<div id="content" style="width:100%; height100%;">
	<!--BLOCK SECTION: START -->
	<div class="row" style="width:100%; height100%;">
		<div class="col-sm-1"></div>
		<div class="col-sm-10">
			<!-- 1 block: START -->
			<div>
				<!-- title -->
				<div class="col-sm-12 page-header" style="margin-top:0px;">
					<h3>캠페인상태 변경처리</h3>
				</div>
				<!-- button -->
				<!--
				<div class="col-md-2 page-header" style="margin-top:31px;">
					<button type="button" class="btn btn-success btn-xs pull-right" onclick="window.open('/SASCampaign/contents/CampaignContent.do?offercode=ALL&channelcode=ALL','contentsmapping','');" style="margin-bottom:3px;" >
						<i class="fa fa-plus" aria-hidden="true"></i> 컨텐츠 매핑
					</button>
				</div>
				-->
			</div>
			<!-- 1 block: END -->

			<!-- 2 block: START -->
			<div>
				<!-- campaign list: START -->
				<div class="col-sm-12" style="border: 1px solid #DDDDDD;margin:0px;padding:0px;">
					<table class="table table-striped table-hover table-condensed" border="0" cellpadding="0" cellspacing="0" style="margin:0px;padding:0px;">
						<colgroup>
							<col width="13%"/>
							<col width=""/>
							<!-- <col width=""/> -->
							<col width="13%"/>
							<col width="18%"/>
						</colgroup>
						<thead>
							<tr class="info">
								<th style="text-align:center;">캠페인코드</th>
								<th style="text-align:center;">캠페인 명</th>
								<!-- <th style="text-align:center;">설명</th> -->
								<th style="text-align:center;">소유자</th>
								<th style="text-align:center;">최근실행</th>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
					<div id="table" style="overflow-x: hidden; overflow-y: auto; width:100%; height:371px;margin-top:0px;">
						<table id="campaignList" class="table table-striped table-hover table-condensed" width="100%" border="0" cellpadding="0" cellspacing="0">
							<colgroup>
								<col width="13%"/>
								<col width=""/>
								<!-- <col width=""/> -->
								<col width="13%"/>
								<col width="18%"/>
							</colgroup>
							<tbody></tbody>
						</table>
						<div id="search_layer"></div>
						<nav><ul class="pager" id="paging_layer" style="display:show;"></ul></nav>
					</div>
				</div>
				<!-- campaign list: END -->

				<!-- TAB: START -->
				<div id="optionDiv" class="col-md-12" style="display:none;margin-top:15px;margin-right:0px;padding-right:0px;">
					<!-- TAB: 요약 / 속성 / 오퍼 / 채널 / 일정 : START -->
					<div style="display:flex">
						<div class="col-md-7" >
							<ul id="myTab" class="nav nav-tabs" role="tablist">
								<li role="presentation" class="">
									<a data-target="#summary" id="home-tab" role="tab" data-toggle="tab" aria-controls="summary" aria-expanded="true">
										<i class="fa fa-info"></i> 요 약
									</a>
								</li>
								<li role="presentation" class="">
									<a data-target="#property" id="home-tab" role="tab" data-toggle="tab" aria-controls="property" aria-expanded="true">
										<i class="fa fa-cog" aria-hidden="true"></i> 속 성
									</a>
								</li>
								<li role="presentation" class="">
									<a data-target="#offer" role="tab" id="profile-tab" data-toggle="tab" aria-controls="offer" aria-expanded="false">
										<i class="fa fa-filter"></i> 오 퍼
									</a>
								</li>
								<li role="presentation" class="">
									<a data-target="#channel" role="tab" id="profile-tab" data-toggle="tab" aria-controls="channel" aria-expanded="false">
										<i class="fa fa-comments-o"></i> 채 널 <!-- button onclick="_test_channelMobile()">BTN</button -->
									</a>
								</li>
								<li role="presentation" class="active">
									<a data-target="#schedule" role="tab" id="profile-tab" data-toggle="tab" aria-controls="schedule" aria-expanded="false">
										<i class="fa fa-calendar"></i> 일 정
									</a>
								</li>
							</ul>
						</div>
						<!-- <div class="push-right" style="flex-basis: 400px;"></div> -->
					</div>
					<!-- TAB: 요약 / 속성 / 오퍼 / 채널 / 일정 : END -->

					<!-- TAB CONTENTS: START -->
					<div id="myTabContent" class="tab-content">
						<!-- 요약 탭: START -->
						<div role="tabpanel" class="tab-pane fade" id="summary" aria-labelledby="profile-tab">
							<div id="table">
								<table class="table table-striped table-hover table-condensed table-bordered">
									<colgroup>
										<col width="20%" />
										<col width="80%" />
									</colgroup>
									<tr>
										<td class="info">캠페인명</td>
										<td class="tbtd_content">
											<span id="CAMPAIGNNAME_SUMMARY"></span>
										</td>
									</tr>
									<tr>
										<td class="info">캠페인코드</td>
										<td class="tbtd_content">
											<span id="CAMPAIGNCODE_SUMMARY"></span>
										</td>
									</tr>
									<tr>
										<td class="info">캠페인구분</td>
										<td class="tbtd_content">
											<span id="CAMPAIGNGUBUN"></span>
										</td>
									</tr>
									<tr>
										<td class="info">캠페인상세</td>
										<td class="tbtd_content">
											<span id="CAMPAIGN_DETAIL"></span>
										</td>
									</tr>
									<tr>
										<td class="info">캠페인종류</td>
										<td class="tbtd_content">
											<span id="CAMPAIGNTYPE"></span>
										</td>
									</tr>
									<tr>
										<td class="info">캠페인목적</td>
										<td class="tbtd_content">
											<span id="CAMPAIGN_OFFER_COST_GUBUN"></span>
										</td>
									</tr>
									<tr>
										<td class="info">데이터전송방식</td>
										<td class="tbtd_content">
											<span id="SENDDATETYPE"></span>
										</td>
									</tr>
								</table>
							</div>
						</div>
						<!-- 요약 탭: END -->

						<!-- 속성 탭: START -->
						<div role="tabpanel" class="tab-pane fade" id="property" aria-labelledby="home-tab">
							<!--
							<div class="col-md-12" style="text-align:right;margin-bottom:10px;">
								<button type="button" class="btn btn-warning btn-sm" id="propertyEdit" >
								 <i class="fa fa-pencil" aria-hidden="true"></i> 편 집
								</button>
								< !--  data-toggle="modal" href="/campaign/property.do" data-target="#modal-testNew" -- >
							</div>
							-->
							<div id="table">
								<table class="table table-striped table-hover table-condensed table-bordered">
									<colgroup>
										<col width="15%"/>
										<col width="35%"/>
										<col width="15%"/>
										<col width="35%"/>
									</colgroup>
									<tr>
										<td class="info">캠페인명</td>
										<td class="tbtd_content">
											<span id = "CAMPAIGNNAME"></span>
										</td>
										<td class="info">캠페인코드</td>
										<td class="tbtd_content">
											<span id = "CAMPAIGNCODE"></span>
										</td>
									</tr>
									<tr>
										<td class="info">캠페인기간</td>
										<td class="tbtd_content" colspan="3">
											<div style="display:inline;" id="cmpgnDtType1" style="display:none;">
												<span id = "CAMP_BGN_DT1"></span>
												<span id = "CAMP_BGN_DT2"></span> 시
												<span id = "CAMP_BGN_DT3"></span> 분
												~
												<span id = "CAMP_END_DT1"></span>
												<span id = "CAMP_END_DT2"></span> 시
												<span id = "CAMP_END_DT3"></span> 분
											</div>
											<div style="margin-top: 5px;" id="cmpgnDtType2" style="display:none;">
												전송일로 부터<span id = "CAMP_TERM_DAY"></span> 일 까지
											</div>
										</td>
									</tr>
									<tr>
										<td class="info">대상수준</td>
										<td class="tbtd_content">
											<span id ="AUDIENCE_NM"></span>
										</td>
										<td class="info">데이터전송방식</td>
										<td class="tbtd_content">
											<span id ="MANUAL_TRANS_NM"></span>
										</td>
									</tr>
									<tr>
										<td class="info">오퍼자동<br/>적용여부</td>
										<td class="tbtd_content">
											<span id ="OFFER_DIRECT_YN"></span>
										</td>
										<td class="info">채널우선순위적용</td>
										<td class="tbtd_content">
											<span id ="CHANNEL_PRIORITY_YN"></span>
										</td>
									</tr>
									<tr>
										<td class="info">등록자</td>
										<td class="tbtd_content">
											<span id ="CREATE_NM"></span>
										</td>
										<td class="info">등록일시</td>
										<td class="tbtd_content">
											<span id ="CREATE_DT"></span>
										</td>
									</tr>
									<tr>
										<td class="info">수정자</td>
										<td class="tbtd_content">
											<span id ="UPDATE_NM"></span>
										</td>
										<td class="info">수정일시</td>
										<td class="tbtd_content">
											<span id ="UPDATE_DT"></span>
										</td>
									</tr>
								</table>
							</div>
						</div>
						<!-- 속성 탭: END -->

						<!-- 오퍼 탭: START -->
						<div role="tabpanel" class="tab-pane fade" id="offer" aria-labelledby="profile-tab">
							<!--
							<div class="col-md-12" style="text-align:right;margin-bottom:10px;">
								<button type="button" class="btn btn-warning btn-sm" id="offerEdit">
									<i class="fa fa-pencil" aria-hidden="true"></i> 편 집
								</button>
							</div>
							-->
							<div id="offerList" >
							</div>
						</div>
						<!-- 오퍼 탭: END -->

						<!-- 채널 탭: START -->
						<div role="tabpanel" class="tab-pane fade" id="channel" aria-labelledby="profile-tab">
							<form name="frmChannel" id="frmChannel">
								<input type="hidden" id="ChannelCampaignId" name="CampaignId" value="" />
								<input type="hidden" id="ChannelCELLID" name="CELLID" value="" />
								<input type="hidden" id="CHANNEL_CD" name="CHANNEL_CD" value="" />
								<input type="hidden" id="DISABLED" name="DISABLED" value="Y" />
								<div id="table">
									<table class="table table-striped table-hover table-condensed table-bordered">
										<colgroup>
											<col width="15%"/>
											<col width="15%"/>
											<col width=""/>
											<!-- 
											<col width="10%"/>
											<col width="10%"/>
											-->
										</colgroup>
										<tr class="info">
											<th style="text-align:center;">고객 세그먼트</th>
											<th style="text-align:center;">채널</th>
											<th style="text-align:center;">내용</th>
											<!--
											<th style="text-align:center;">삭제</th>
											<th style="text-align:center;">추가</th>
											-->
										</tr>
									</table>
								</div>
								<div id="search_channel"></div>
							</form>
						</div>
						<!-- 채널 탭: END -->

						<!-- 일정 탭: START -->
						<div role="tabpanel" class="tab-pane fade active in" id="schedule" aria-labelledby="profile-tab">
<form name="formSchedule" id="formSchedule">
<input type="hidden" id="TO_DATE" name="TO_DATE" value="" />
<input type="hidden" id="TO_DATE_P1" name="TO_DATE_P1" value="" />
<input type="hidden" id="TO_DATE_P2" name="TO_DATE_P2" value="" />
<input type="hidden" id="scheduleCAMPAIGNCODE" name="CAMPAIGNCODE" value="${bo.campaigncode}" />
<input type="hidden" id="scheduleCampaignId" name="CampaignId" value="${bo.campaignid}" />
<input type="hidden" id="selectPageNo2" name="selectPageNo2"  value="${selectPageNo2}" />
<input type="hidden" id="LIST_LENGTH" name="LIST_LENGTH"  value="0" />
<input type="hidden" id="camp_term_cd" name="camp_term_cd"  value="" />
<input type="hidden" id="camp_end_dt" name="camp_end_dt"  value="" />
<input type="hidden" id="channel_priority_yn" name="channel_priority_yn"  value="" />
<input type="hidden" id="minDispDt" name="minDispDt"  value="" />
							<div class="col-md-12" style="text-align:right;margin-bottom:10px;">
								<button type="button" class="btn btn-danger btn-sm" onclick="fn_changeStatus();" id="campaignStopDiv"><i class="fa fa-plus" aria-hidden="true"></i> 캠페인 상태변경</button>
								<!--
								<button type="button" class="btn btn-success btn-sm" onclick="fn_delete();" id="scheduleDel"><i class="fa fa-trash" aria-hidden="true"></i> 삭제</button>
								<button type="button" class="btn btn-success btn-sm" onclick="fn_deleteAll();"><i class="fa fa-trash-o" aria-hidden="true"></i> 전체삭제</button>
								<button type="button" class="btn btn-warning btn-sm" id="scheduleEdit"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> 편집 </button>
								-->
								<!--
								<div id="viewMultiDiv" style="height:100px;">
									<div class="col-md-10 text-center">
										<h4>CI Studio 에서 스케쥴링 등록을 먼저 실행해주세요!</h4>
									</div>
									<div class="col-md-2">
										<button type="button" class="btn btn-warning btn-sm" id="multiSaveBtn" onclick="fn_multi_save();" style="margin-bottom:5px;"><i class="fa fa-trash" aria-hidden="true"></i> 저장</button>
									</div>
								</div>
								-->
							</div>
							<div id="scheduleTable">
								<table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
									<colgroup>
										<col width="15%"/>
										<col width="35%"/>
										<col width="15%"/>
										<col width="35%"/>
									</colgroup>
									<tr>
										<td class="info">캠페인 코드/명</td>
										<td class="tbtd_content" id="scheduleCampaignCode"></td>
										<td class="info">실행상태</td>
										<td class="tbtd_content">
											<select style="width: 70px;" id="SEARCH_TYPE" name="SEARCH_TYPE" >
												<option >전체</option>
												<!-- 
												<option value="NULL">미실행</option>
												<option value="NOTNULL">실행</option>
												-->
											</select>
										</td>
									</tr>
									<%--
									<tr>
										<td class="info">캠페인 코드/명</td>
										<td class="tbtd_content" id="scheduleCampaignCode"></td>
										<td class="info">일정구분</td>
										<td class="tbtd_content" id="scheduleScheduler"></td>
										<!--
										<td class="info">플로차트 이름</td>
										<td class="tbtd_content">${bo.flowchartname}</td> 
										-->
									</tr>
									<tr>
										<td class="info">추출기간</td>
										<td class="tbtd_content" id="scheduleRsrvDate"></td>
										<td class="info">실행상태</td>
										<td class="tbtd_content">
											<select style="width: 70px;" id="SEARCH_TYPE" name="SEARCH_TYPE" >
												<option >전체</option>
												<option value="NULL">미실행</option>
												<option value="NOTNULL">실행</option>
											</select>
										</td>
									</tr>
									--%>
									<%--
									<tr id="scheduleAddTr">
										<td class="info">일정추가</td>
										<td class="tbtd_content" colspan="3">
											<div id="search2">
												<input type="text" id="RSRV_DT" name="RSRV_DT" class="txt" style="width:86px;" value="" readonly="readonly"/>
												<select style="width: 45px;" id="RSRV_HOUR" name="RSRV_HOUR" >
													<c:forEach var="val" varStatus="i" begin="08" end="20" step="1">
														<option value="${val}">
														<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
														</option>
													</c:forEach>
												</select> 시
												<select style="width: 45px;" id="RSRV_MINUTE" name="RSRV_MINUTE">
													<c:forEach var="val" varStatus="i" begin="00" end="59" step="1">
														<option value="${val}">
														<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
														</option>
													</c:forEach>
												</select> 분
												<button type="button" class="btn btn-success btn-sm" onclick="fn_validation();" id="scheduleAdd"><i class="fa fa-plus" aria-hidden="true"></i> 추가</button>
											</div>
										</td>
									</tr>
									--%>
								</table>
							</div>
							<!-- List -->
							<div id="scheduleListDiv" style="overflow:scroll; width:100%; height:220px;margin-top:0px;">
								<table id="scheduleListTable" class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
									<colgroup>
										<col width="3%"/>
										<col width="5%"/>
										<col width="15%"/>
										<col width="15%"/>
										<col width="15%"/>
										<col width="10%"/>
										<col width="11%"/>
										<col width="13%"/>
										<col width="13%"/>
									</colgroup>
									<thead>
									<tr class="info">
										<th style="text-align:center;" >No</th>
										<th style="text-align:center;">
											<input type='checkbox' id="chkParent" style='margin:-13px 5px -5px 0px;' />
											<!--
											선택
											<button type='button' onclick='javascript:fn_toggleScheduleAllSelect();' class='btn btn-primary' style='background-color:#aaa; height:15px;width:15px;padding:0px; font-size:10px;'>A</button>
											-->
										</th>
										<th style="text-align:center;">실행예정일시</th>
										<th style="text-align:center;">실행시작일시</th>
										<th style="text-align:center;">실행종료일시</th>
										<th style="text-align:center;">실행상태</th>
										<th style="text-align:center;">상태상세</th>
										<th style="text-align:center;">등록자ID</th>
										<th style="text-align:center;">등록일시</th>
									</tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
							<!--
							<div id="search_layer_schedule"></div>
							-->
							<!--
							<nav><ul class="pager" id="paging_layer2" style="display:show;"></ul></nav>
							-->
							<!-- /List -->
							<table style="border-spacing:0px; border:0px;"><tr><td height="1"></td></tr></table>
</form>
						</div>
						<!-- 일정 탭: END -->

					</div>
					<!-- TAB CONTENTS: END -->
				</div>
				<!-- TAB: END -->
			</div>
			<!-- 2 block: END -->

		</div>
		<div class="col-sm-1"></div>
	</div>
	<!-- BLOCK SECTION: END -->
	<div class="row" style="width:100%; height100%;">
		<div class="col-sm-1"></div>
		<div id="sysbtn" class="col-sm-10" style="text-align: right; margin: 10px 10px 0px 0px;">
			<button type="button" class="btn btn-default btn-sm" onclick="fn_close();"> <i class="fa fa-times" aria-hidden="true"></i> 닫기 </button>
		</div>
		<div class="col-sm-1"></div>
	</div>

</div>
<!-- PAGE CONTENT: END -->

<!-- %@ include file="/WEB-INF/views/common/_footer.jsp"% -->

