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
	var tgtCampaignId;
	var tgtCellId;
	var tgtChannelCd;
	
	// 창열리고 처리
	$(document).ready(function(){
		window.resizeTo(1000,800);
		if (!true) alert(">>>>> campaignChannel.jsp = .${campaignid}.${cellid}.${channel_cd}.${disp_dt}.");  // KANG-20200413
		tgtCampaignId = "${campaignid}";
		tgtCellId = "${cellid}";
		tgtChannelCd = "${channel_cd}";
		tgtDispDt = "${disp_dt}";
		
		//채널선택시 페이지 이동
		//$("#CHANNEL_CD").bind("change",fn_selectChannel);
	});

	//창닫기
	function fn_close(){
		window.close();
	}

	//채널 선택
	/*
	function fn_selectChannel(){
		var form = document.form;

		if($("#CHANNEL_CD").val() == "SMS"){
			form.action = "${staticPATH }/channel/channelSms.do";
			form.submit();
		}

		if($("#CHANNEL_CD").val() == "EMAIL"){
			form.action = "${staticPATH }/channel/channelEmail.do";
			form.submit();
		}

		if($("#CHANNEL_CD").val() == "TOAST"){
			form.action = "${staticPATH }/channel/channelToast.do";
			form.submit();
		}

		if($("#CHANNEL_CD").val() == "MOBILE"){
			form.action = "${staticPATH }/channel/channelMobile.do";
			form.submit();
		}
		if($("#CHANNEL_CD").val() == "LMS"){
			form.action = "${staticPATH }/channel/channelLms.do";
			form.submit();
		}
	}
	*/

	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////
	// loading function
	$(function() {
		fn_campaignList();
	});

	// 캠페인 리스트 for some campaign, and pagination
	function fn_campaignList() {       // KANG-20190410: analyzing for pagination
		if (true) console.log("KANG.fn_campaignList: 캠페인 목록 조회");
		//${staticServerType }
		jQuery.ajax({
			url           : '${staticPATH }/campaignList.do?serverType=${staticServerType }',
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
						var page = _pagingNavi(result.selectPage, result.pageRange, result.pageStart, result.pageEnd, result.totalPage, "fn_pageMove");
						$("#paging_layer").html(page);
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

	// get details of some campaign
	function fn_getCampaignDtl(campaignid) {
		if (!true) alert("KANG.fn_getCampaignDtl: campaignid = " + campaignid);
		//$("#optionDiv").hide();
		//var reTurnDivView = fn_campaignInfoAll(campaignid);
		var ret = fn_channel(campaignid);
		//if (reTurnDivView == "ERROR"){
		//} else {
		//	$("#optionDiv").show();
		//}
		/*
		  wrapWindowByMask();
		  $("#optionDiv").hide();
		  chkTime(campaignid);
		  $("#optionDiv").show();
		  closeWindowByMask();
		*/
	}

	// 캠페인에 대한 정보를 모두 불러온다.
	/*
	function fn_campaignInfoAll(campaignid) {    // KANG-20190410: analyzing. load all
		if (true) console.log("KANG.fn_campaignInfoAll: 캠페인에 대한 정보를 모두 불러온다.");
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
				wrapWindowByMask();
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
						if (result.bo.camp_status_cd == "START" && parseInt(result.runScheduleCnt) > 0){
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
								txt += "<a href=\"javascript:fn_clickOffer('" + data.offer_type_cd + "', '" + data.offer_sys_cd + "' , '" + data.cellid + "' , '" + data.offerid + "', '" + data.campaignid + "')\" class=\"link\">" + data.offername + "&nbsp; </a>";
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
								txt += "<col width='10%'/>";
								txt += "<col width='10%'/>";
								txt += "</colgroup>";
								$.each(list, function(key){
									var data = list[key];
									txt += "<tr>";
									if (data.cellname != old_cellname2){
										txt += "<td align=\"left\" class=\"listtd\"rowspan="+data.cellrow+">"+data.cellname+"</td>";
									}
									if (data.channel_nm != null){
										txt += "<td align=\"left\" class=\"listtd\"><a href=\"javascript:fn_clickChannel('"+data.cellid+"','"+data.channel_cd+"');\" class='link'>"+data.channel_nm+"</a></td>";
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
						if (result.scheduleBo.rsrv_gubun_code_name == null || result.scheduleBo.rsrv_gubun_code_name == "null"){
							$("#scheduleTable").hide();
							$("#scheduleListDiv").hide();
							$('#paging_layer2').hide();
						} else {
							$("#scheduleTable").show();
							$("#scheduleListDiv").show();
							$("#selectPageNo2").val("1");
							$('#paging_layer2').show();
							fn_searchSchedule();
							if (option=="success"){
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
				closeWindowByMask();
			},
			error: function(result, option) {
				alert("에러가 발생하였습니다.");
			}
		});
	}
	*/

	// 켐패인 요약/속성 조회
	/*
	function fn_property(campaignid) {
		if (true) console.log("KANG.fn_property: 켐패인 요약/속성 조회");
		jQuery.ajax({
			url           : '${staticPATH }/getCampaignInfo.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			async         : true,
			type          : "POST",
			data          : {
				campaignid   : campaignid
			},
			success: function(result, option) {
				if (option=="success"){
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
					var tmpType = "";
					if (result.boSummary.campaigntype == "1"){
						tmpType = "일반캠페인";
					} else if (result.boSummary.campaigntype == "2"){
						tmpType = "A|B캠페인";
					} else if (result.boSummary.campaigntype == "3"){
						tmpType = "멀티캠페인";
						$("#scheduleDel").hide();
						$("#scheduleEdit").hide();
					}
					result.boSummary.campaigntype
					$('#CAMPAIGNGUBUN').text(tmpGubun);
					$('#CAMPAIGNTYPE').text(tmpType);
					$('#SENDDATETYPE').text(result.boSummary.senddatetype);
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
	}
	*/

	// 켐패인 오퍼 리스트  조회
	/*
	function fn_offer(campaignid) {
		if (true) console.log("KANG.fn_offer: 켐패인 오퍼 리스트 조회");
		jQuery.ajax({
			url           : '${staticPATH }/getOfferInfoList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			async         : true,
			type          : "POST",
			data          : {
				campaignid   : campaignid
			},
			success: function(result, option) {
				if (option=="success"){
					var list = result.offer_list;
					//console.log("offer_list : " + result.offer_list);
					//console.log("offerUseChk : " + result.offerUseChk);
					//console.log("dummyOfferChk : " + result.dummyOfferChk);
					//console.log("dummyOfferChk : " + result.dummyOfferChk);
					var txt = '<table class="table table-striped table-hover table-condensed table-bordered" >';
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
						txt += "<td>"+data.cellname+"</td>";
						if (data.offer_sys_cd == 'ZZ'){
							txt += "<td>"+data.offername+"</td>";
						} else {
							txt += "<td>";
							txt += "<a href=\"javascript:fn_clickOffer('"+data.offer_type_cd+"', '"+data.offer_sys_cd+"' , '"+data.cellid+"' , '"+data.offerid+"', '"+data.campaignid+"')\" class=\"link\">"+data.offername +"&nbsp; </a>";
							txt += "</td>";
						}
						txt += "<td>"+nvl(data.disp_name, '')+"</td>";
						txt += "</tr>";
					});
					txt += "</table>";
					$("#offerList").html(txt);
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
	}
	*/
	
	// 켐패인 채널 리스트  조회
	function fn_channel(campaignid) {
		if (true) console.log("KANG.fn_channel: 켐패인 채널 리스트 조회");
		jQuery.ajax({
			url           : '${staticPATH }/getChannelInfoList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			async         : true,
			type          : "POST",
			data          : {
				campaignid   : campaignid
			},
			success: function(result, option) {
				if (option=="success"){
					//$('#channel').css('display', '');
					var list = result.channel_list;
					var txt ="";
					txt += "<table class='table table-striped table-hover table-condensed table-bordered' width='100%' border='0' cellpadding='0' cellspacing='0'>";
					if (list.length>0) {
						if (result.channelValiChk =="N"){
							alert("대상수준이 PCID일경우에는 토스트배너만 사용이 가능합니다");
							return;
						} else if (result.channelValChkforMobile != "Y"){
							alert("대상수준이 DEVICEID일 경우에는 모바일 알리미 채널만 사용이 가능합니다.");
							return;
						} else {
							var old_celid2 = "";
							var old_cellname2 = "";
							txt += "<colgroup>";
							txt += "<col width='20%'/>";
							txt += "<col width='20%'/>";
							txt += "<col width=''/>";
							//txt += "<col width='10%'/>";
							//txt += "<col width='10%'/>";
							txt += "</colgroup>";
							$.each(list, function(key){
								var data = list[key];
								txt += "<tr>";
								if (data.cellname != old_cellname2){
									txt += "<td align=\"left\" class=\"listtd\"rowspan="+data.cellrow+">"+data.cellname+"</td>";
								}
								if (data.channel_nm != null){
									if (tgtChannelCd == data.channel_cd) {
										txt += "<td align=\"left\" class=\"listtd\"><a href=\"javascript:fn_clickChannel('"+data.cellid+"','"+data.channel_cd+"');\" class='link'>"+data.channel_nm+"</a></td>";
									} else {
										txt += "<td align=\"left\" class=\"listtd\">"+data.channel_nm+"</td>";
									}
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
								if (data.channel_cd =='TOAST'){
									txt +=(data.toast_title).substring(0,45);
									if ((data.toast_title).substring(0,45).length>=18){
										txt +='...';
									}
								}
								if (data.channel_cd =='SMS'){
									txt +=(data.sms_msg).substring(0,45);
									if ((data.sms_msg).substring(0,45).length>=18){
										txt +='...';
									}
								}
								if (data.channel_cd =='EMAIL'){
									txt +=(data.email_name).substring(0,45);
									if ((data.email_name).substring(0,45).length>=18){
										txt +='...';
									}
								}
								if (data.channel_cd =='MOBILE'){
									txt +=(data.mobile_disp_title).substring(0,45);
									if ((data.mobile_disp_title).substring(0,45).length>=18){
										txt +='...';
									}
								}
								if (data.channel_cd =='LMS'){
									txt +=(data.lms_title).substring(0,45);
									if ((data.lms_title).substring(0,45).length>=18){
										txt +='...';
									}
								}
								txt +="</td>";
								//if (data.channel_cd != null && data.camp_status_cd =='EDIT'){
								//	txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_delChannel('"+data.cellid+"','"+data.channel_cd+"');\" class='link'>"+'삭제'+"</a></td>";
								//} else {
								//	txt += '<td></td>';
								//}
								//if (data.cellid !=old_celid2){
								//	if (data.camp_status_cd =='EDIT'){
								//		txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_addChannel('"+data.cellid+"','"+data.campaignid+"');\" class='link' rowspan="+data.cellrow+">"+'추가'+"</a></td>";
								//	} else {
								//		txt += '<td></td>';
								//	}
								//} else {
								//	txt += '<td></td>';
								//}
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
				} else {
					alert("에러가 발생하였습니다.");
					closeWindowByMask();
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
	}

	// 채널정보 상세보기(수정화면)   // KANG-20200415
	function fn_clickChannel(cellid, channel_cd) {
		if (true) console.log("KANG.fn_clickChannel: 채널정보 상세보기(수정화면)");
		var srcCellId = cellid;
		var srcChannelCd = channel_cd;
		
		if (!true) {
			// KANG-20200415
			alert("KANG.fn_clickChannel("+cellid+", "+channel_cd+")\n"
				+ "src: ." + srcCellId + "." + srcChannelCd + ".\n"
				+ "tgt: ." + tgtCampaignId + "." + tgtCellId + "." + tgtChannelCd + ".\n");
			return;
		}

		// KANG-20200415
		$("#srcCellId"    ).val(srcCellId    );
		$("#srcChannelCd" ).val(srcChannelCd );
		$("#tgtCampaignId").val(tgtCampaignId);
		$("#tgtCellId"    ).val(tgtCellId    );
		$("#tgtChannelCd" ).val(tgtChannelCd );
		$("#tgtDispDt"    ).val(tgtDispDt    );

		var frmChannel = document.frmChannel;
		$("#ChannelCELLID").val(cellid);
		$("#CHANNEL_CD").val(channel_cd);
		pop = window.open('', 'POP_CHANNEL', 'top=50,left=80, location=no,status=no,toolbar=no,scrollbars=yes');
		if (channel_cd == "TOAST"){
			frmChannel.action = "${staticPATH }/channel/copyChannelToast.do";   // KANG-20200417
		}
		if (channel_cd == "SMS"){
			frmChannel.action = "${staticPATH }/channel/copyChannelSms.do";   // KANG-20200417
		}
		if (channel_cd == "EMAIL"){
			frmChannel.action = "${staticPATH }/channel/copyChannelEmail.do";   // KANG-20200417
		}
		if (channel_cd == "MOBILE"){
			frmChannel.action = "${staticPATH }/channel/copyChannelMobile.do";   // KANG-20200415
		}
		if (channel_cd == "LMS"){
			frmChannel.action = "${staticPATH }/channel/copyChannelLms.do";   // KANG-20200417
		}
		frmChannel.target = "POP_CHANNEL";
		frmChannel.method = "POST";
		frmChannel.submit();
		if (!true) pop.focus();
		if (true) window.close();
	}

	// KANG-20190411: for pagination
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

</script>



<!--PAGE CONTENT -->
<div id="content" style="width:100%; height100%;">
	<!--BLOCK SECTION -->
	<div class="row" style="width:100%; height100%;">
		<div class="col-sm-1"></div>
		<div class="col-sm-10">
			<!-- 1 block -->
			<div>
				<!-- title -->
				<div class="col-sm-12 page-header" style="margin-top:0px;">
					<h3>캠페인목록 / 채널 정보</h3>
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

			<!-- 2 block -->
			<div>
				<!-- zTree -->
				<!--
				<div class="col-md-3" style="height:380px">
					<button type="button" class="btn btn-warning btn-xs" id="expandAllBtn" onclick="return false;" style="margin-bottom:3px;" >
						<i class="fa fa-plus" aria-hidden="true"></i> 모두열기
					</button>
					<button type="button" class="btn btn-warning btn-xs pull-right" id="collapseAllBtn" onclick="return false;" style="margin-bottom:3px;" >
						<i class="fa fa-minus" aria-hidden="true"></i> 모두닫기
					</button>
					<ul id="tree" class="ztree"></ul>
				</div>
				-->
				<!-- campaign list -->
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
						<!-- KANG-20200523: remove pager
						<nav><ul class="pager" id="paging_layer" style="display:show;"></ul></nav>
						-->
					</div>
				</div>
			</div>

			<!-- 3 block -->
			<div class="col-sm-12"></div>
			<div class="col-sm-12" style="text-align:left;">
				<h5>:: 채널 정보 :: (아래의 복사하고자 하는 채널을 선택하세요.)</h5>
			</div>

			<!-- 4 block -->
			<div>
				<div class="col-sm-12" style="border: 1px solid #DDDDDD;margin:0px;padding:0px;">
					<div role="tabpanel" class="tab-pane show" id="channel" aria-labelledby="profile-tab">
<form name="frmChannel" id="frmChannel">
<input type="hidden" id="ChannelCampaignId" name="CampaignId" value="" />
<input type="hidden" id="ChannelCELLID" name="CELLID" value="" />
<input type="hidden" id="CHANNEL_CD" name="CHANNEL_CD" value="" />
<input type="hidden" id="DISABLED" name="DISABLED" value="Y" />
<input type="hidden" id="COPYCHANNEL"   name="COPYCHANNEL"   value="YES" />
<input type="hidden" id="srcCellId"     name="srcCellId"     value="" />
<input type="hidden" id="srcChannelCd"  name="srcChannelCd"  value="" />
<input type="hidden" id="tgtCampaignId" name="tgtCampaignId" value="" />
<input type="hidden" id="tgtCellId"     name="tgtCellId"     value="" />
<input type="hidden" id="tgtChannelCd"  name="tgtChannelCd"  value="" />
<input type="hidden" id="tgtDispDt"     name="tgtDispDt"     value="" />
<input type="hidden" id="MANUAL_TRANS_YN"  name="MANUAL_TRANS_YN"  value="${MANUAL_TRANS_YN}" />  <!-- KANG-20200606 -->
<input type="hidden" id="DISP_TIME"        name="DISP_TIME"        value="${DISP_TIME}" />        <!-- KANG-20200606 -->
<input type="hidden" id="SEND_PREFER_CD"   name="SEND_PREFER_CD"   value="${SEND_PREFER_CD}" />   <!-- KANG-20200606 -->
						<div id="table">
							<table class="table table-striped table-hover table-condensed table-bordered">
								<colgroup>
									<col width="20%"/>
									<col width="20%"/>
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
				</div>
			</div>
		</div>
		<div class="col-sm-1"></div>
	</div>
	<!-- END BLOCK SECTION -->
	<div class="row" style="width:100%; height100%;">
		<div class="col-sm-1"></div>
		<div id="sysbtn" class="col-sm-10" style="text-align: right; margin: 10px 10px 0px 0px;">
			<button type="button" class="btn btn-default btn-sm" onclick="fn_close();"> <i class="fa fa-times" aria-hidden="true"></i> 닫기 </button>
		</div>
		<div class="col-sm-1"></div>
	</div>

</div>
<!-- END PAGE CONTENT -->

<!-- %@ include file="/WEB-INF/views/common/_footer.jsp"% -->

