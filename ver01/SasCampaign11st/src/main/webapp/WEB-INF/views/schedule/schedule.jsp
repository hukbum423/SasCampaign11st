<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_modal.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>

<link href="${staticPATH }/css/jquery_1.9.2/base/jquery-ui-1.9.2.custom.css" rel="stylesheet">
<script src="${staticPATH }/js/jquery_1.9.2/jquery-1.8.3.js"></script>
<script src="${staticPATH }/js/jquery_1.9.2/jquery-ui-1.9.2.custom.js"></script>

<script language="JavaScript">
		
	$(document).ready(function(){
		
//		=================================================
		// 화면타이틀값 : 메뉴명칭
		if(window.location != window.parent.location){ //iframe일경우에만
			parent.setPageTitle("${bo.campaignname} - 대상고객 추출일정 등록",null);
		
			// Tab 메뉴
			// Step1 메뉴에 url 생성 후 변경 필요함.
			var tablist = "<li><a target=content href='/Campaign/campaignDetails.do?id=${bo.campaignid}'>요약</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/campaignInfo.do?CampaignId=${CAMPAIGNID}'>STEP1.캠페인 속성 등록</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/campaignInfoList.do?CampaignId=${CAMPAIGNID}'>STEP2.오퍼  속성 및 채널 등록</a></li>";
			tablist += "<li class=selected><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/scheduleDetail.do?CampaignId=${CAMPAIGNID}'>STEP3.대상고객 추출일정 등록</a></li>";
			top.setNewTabList(tablist);
			
			parent.document.getElementById('gwt-uid-2').innerHTML='<a href="/Campaign/logout.do"><font color="#E8DB6B" bold style={text-decoration:none;}>로그아웃</a>';
		}
//		=================================================

		//달력 설정
		$("#RSRV_START_DT").datepicker({
      showOn: "button",
      buttonImage: "${staticPATH }/image/calendar.gif",
      buttonImageOnly: true,
      buttonText: "Select date"
    });
		$("#RSRV_END_DT").datepicker({
      showOn: "button",
      buttonImage: "${staticPATH }/image/calendar.gif",
      buttonImageOnly: true,
      buttonText: "Select date"
    });
		$("#RSRV_DAY_05").datepicker({
      showOn: "button",
      buttonImage: "${staticPATH }/image/calendar.gif",
      buttonImageOnly: true,
      buttonText: "Select date"
    });;
		
		$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; margin-bottom:-2px; vertical-align:middle;");
		
		
		
		//오늘날짜 가져오기
		getToday();
		
		//최초 tr숨기기
		$('#tr_00, #tr_01, #tr_02, #tr_03, #tr_04, #tr_05').css('display', 'none');
		fn_selectGubuCode();
		
		//일정구분 SELECTBOX 이벤트 추가
		$("#RSRV_GUBUN_CODE").bind("change",fn_selectGubuCode);
		/*
		if("${flowChartCnt}" != "Y"){
			if("${flowChartCnt}" == "E"){
				alert("플로차트가 존재하지 않습니다");
			}else if("${flowChartCnt}" == "N"){
				alert("플로차트가 2개이상 존재합니다");
			}else{
				
			}
			var frm = document.form;
			
	    	frm.action = "${staticPATH }/campaignInfo.do";
	    	frm.target = "_self";
	        frm.submit();
	        return;
		}*/
		
		var d = new Date();

		var hour = d.getHours();
		var min = d.getMinutes();
		if(hour<8){
			hour = 8;
		}
		if(hour>20){
			hour=20;
		}
		
		//현재시간 SELECT 해주기
		if("${bo.rsrv_gubun_code}" ==""){
						
			$("#RSRV_HOUR_01").val(hour);
			$("#RSRV_MINUTE_01").val(min);
			$("#RSRV_HOUR_02").val(hour);
			$("#RSRV_MINUTE_02").val(min);
			$("#RSRV_HOUR_03").val(hour);
			$("#RSRV_MINUTE_03").val(min);
			$("#RSRV_HOUR_04").val(hour);
			$("#RSRV_MINUTE_04").val(min);
			$("#RSRV_HOUR_05").val(hour);
			$("#RSRV_MINUTE_05").val(min);
		}else{
			$("#RSRV_HOUR_05").val(hour);
			$("#RSRV_MINUTE_05").val(min);
		}
		
		// 매시간 select 박스
		$("#EVERYTIME").bind("change",disEveryTimeSelect);
		
		if ( $("input:checkbox[name='EVERYTIME']").is(":checked") == false ){
			$("#RSRV_HOUR_07").attr("disabled",true);
		}
		
	});
		
	
	/* 구분코드 선택시 이벤트 */
	function fn_selectGubuCode(){
	  var rsrvGubunCode = $("#RSRV_GUBUN_CODE").val();
	  
	  if(rsrvGubunCode == "01"){
	    window.resizeTo('1100', '470');
    }else if(rsrvGubunCode == "02"){
      window.resizeTo('1100', '470');
    }else if(rsrvGubunCode == "03"){
      window.resizeTo('1100', '470');
    }else if(rsrvGubunCode == "05"){
      window.resizeTo('1100', '520');
    }else if(rsrvGubunCode == "06"){
      window.resizeTo('1100', '590');
    }	  
		$('#tr_00, #tr_01, #tr_02, #tr_03, #tr_04, #tr_05, #tr_07, #SPANEVERYTIME').hide();
		//console.log('$("#RSRV_GUBUN_CODE").val() : ' + rsrvGubunCode);
		$('#tr_' + rsrvGubunCode).show();

		if(rsrvGubunCode =="05"){
			$('#tr_00').hide();
		}else{
			$('#tr_00').show();	
		}
		
		if(rsrvGubunCode =="06"){
			$('#tr_07').show();
			$('#SPANEVERYTIME').show();
		}
	}
	

	/* 등록 */
	function fn_save() {

		//유효성 체크
		if(!fn_validation()){
			return;
		}
		
		
		if(!confirm("저장 하시겠습니까?")){
			return;
		}

		
		$("#RUN_RESV_LIST option").each(function(){
			$(this).attr("selected","selected");
		});
		
		$("#RUN_RESV_LIST_06 option").each(function(){
			$(this).attr("selected","selected");
		});
		
		jQuery.ajax({
			url           : '${staticPATH }/setScheduleDetail.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){

	        		var retrun_cd  = result.return_code;
	        		var return_msg = result.return_msg;
	        		
	        		if(retrun_cd == "ERR_01"){
	        			alert("잘못된 일정구분 코드입니다");
	        		}else if(retrun_cd == "ERR_02"){
	        			alert("플로차트가 존재하지 않습니다");
	        		}else if(retrun_cd == "ERR_03"){
	        			alert("플로차트가 2개이상 존재합니다");
	        		}else if(retrun_cd == "ERR_04"){
	        			alert("캠페인 오퍼정보가 일치하지 않습니다");
	        		// 체크하지 않음
	        		//}else if(retrun_cd == "ERR_05"){ 
	        		//	alert("플로차트가 수정중입니다 플로차트를 닫고 진행하십시오");
	        		}else if(retrun_cd == "ERR_06"){
	        			alert("대상수준이 PCID에 오퍼나, 토스트배너 아닌 채널 정보가 입력되어있습니다");
	        		}else if(retrun_cd == "ERR_07_1"){
	        			alert("오퍼 템플릿 쿠폰번호 사용여부가 'Y'이고 도서쿠폰 포인트일경우 캠페인 기간이 쿠폰 발급기간에 포함되어야 합니다");
	        		}else if(retrun_cd == "ERR_07_2"){
	        			alert("오퍼 템플릿 쿠폰번호 사용여부가 'Y'일경우에는 캠페인 기간과 쿠폰 발급기간이 동일해야 합니다");
	        		}else if(retrun_cd == "ERR_08"){
	        			alert("오퍼 템플릿 쿠폰번호 사용여부가 'N'일경우에는 캠페인 기간이 쿠폰 발급기간에 포함되어야 합니다");
	        		}else if(retrun_cd == "ERR_09"){
	        			alert("캠페인 기간이 From~To 일 경우에는 채널노출일이 캠페인 기간에 포함되어야 합니다");
	        		}else if(retrun_cd == "ERR_10"){
	        			alert("대상수준이 DEVICEID에 오퍼나, 모바일 알리미 이외의 채널 정보가 입력되어있습니다.");
	        		}else if(retrun_cd == "ERR_11"){
	        			alert(return_msg);
	        		}else{
	        			
	        			if($("#START_FLAG").val() == "Y"){ //저장 및 실행
	        				//실행하기
	        				fn_setStart();
	        				
	        			}else{ //그냥 저장
	        				alert("저장되었습니다");
		        			
		        			//var frm = document.form;
	        				//frm.action = "${staticPATH }/schedule/schedule.do";
	        				//frm.target = "_self";
	        				//frm.submit();
	        				
	        				window.opener.fn_searchScheduleList($("#CampaignId").val());
	        				
	        				window.close();
	        			}
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
		

		//입력값 체크
		var gubunCode = $("#RSRV_GUBUN_CODE").val();
		
		//추출일 시작일, 종료일 체크
		if(gubunCode == "01" || gubunCode == "02" || gubunCode == "03" || gubunCode == "04" || gubunCode == "06"){
			if($("#RSRV_START_DT").val() ==""){
				alert("추출기간 시작일을 등록하십시오");
				$("#RUN_RESV_LIST").focus();
				return false;				
			}
			if($("#RSRV_END_DT").val() ==""){
				alert("추출기간 종료일을 등록하십시오");
				$("#RUN_RESV_LIST").focus();
				return false;				
			}
			
			if($("#TO_DATE").val() > $("#RSRV_START_DT").val()){
				alert("추출기간 시작일은 오늘보다 커야합니다");
				$("#RSRV_START_DT").focus();
				return false;
			}
			
			if($("#RSRV_START_DT").val() > $("#RSRV_END_DT").val()){
				alert("추출기간 종료일은 추출기간 시작일 보다 커야합니다");
				$("#RSRV_END_DT").focus();
				return false;				
			}
			
		}
		
		
		
		if(gubunCode == "02"){ //매주
			
			var rsrv_week_day = "";
			$("input:checkbox[name='CRSRV_WEEK_DAY']").each(function(){
				if(this.checked){
					rsrv_week_day += this.value;
				}else{
					rsrv_week_day += "0";
				}
			});
			
			if(Number(rsrv_week_day) == 0){
				alert("요일을 선택하십시오");
				return false;				
			}else{
				$("#RSRV_WEEK_DAY").val(rsrv_week_day);
			}

		}else if(gubunCode == "05"){ //사용자 지정
			
			if($("#RUN_RESV_LIST option").size() == 0){
				alert("사용자 지정 일정을 등록하십시오");
				$("#RUN_RESV_LIST").focus();
				return false;
			}
			
		}
		
		return true;
	}

	
	//오늘 날짜 가져오기
 	function getToday(){
 		jQuery.ajax({
 	    url           : '${staticPATH }/getToday.do',
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
	
	
	//사용자 지정 일정추가
	function fn_add(){
		
		if($("#RSRV_DAY_05").val() ==""){
			alert("사용자 지정일을 입력하세요");
			$("#RSRV_DAY_05").focus();
			return;
		}
		
		//캠페인 기간구분코드(CAMP_TERM_CD)가 01 일경우 일정은 1개만 등록가능하다 
		if("${bo.camp_term_cd}" == "01" && $("#RUN_RESV_LIST option").size() > 0 ){
			
			var cnt = 0;
			//진행된것 있는지 체크
			$("#RUN_RESV_LIST option").each(function(){
				if($(this).text().trim().indexOf("실패") > -1){ //실패건수는 진행으로 안본다
					cnt ++;
				}
			});
			
			if($("#RUN_RESV_LIST option").size() != cnt){ //실패건수와 목록건수가 동일할때가 아니면 이미 등록되어있기때문에 등록이 불가능하다
				alert("캠페인 기간이 From~To일경우에는 일정을 1개만 입력하실수 있습니다");
				$("#RUN_RESV_LIST").focus();
				return;
			}
			
		}

		if("${bo.camp_term_cd}" == "01"){
			if( $("#RSRV_DAY_05").val() > "${bo.camp_end_dt}"){
				alert("추출기간 종료일은 캠페인 종료일(${bo.camp_end_dt})보다 보다 작아야합니다");
				$("#RSRV_DAY_05").focus();
				return;
			}
		}
		
		var date   = $("#RSRV_DAY_05").val();
		var hour   = $("#RSRV_HOUR_05").val();
		var minute = $("#RSRV_MINUTE_05").val();
		
		
		//입력일은 오늘보다 커야한다
		if($("#TO_DATE").val() > date){
			alert("캠페인 실행일은 오늘보다 커야합니다");
			$("#RSRV_DAY_05").focus();
			return;
		}
		
		//최초 채널 노출일 체크
		if( "${bo.camp_term_cd}" == "01" && "${bo.channel_priority_yn}" == "Y" && "${bo.minDispDt}" != "" && date > "${bo.minDispDt}" ){
			alert("캠페인 실행일은 노출일 -1일 (${bo.minDispDt}) 이전이여야 합니다");
			$("#RSRV_DAY_05").focus();
			return;
		}

		
		if(Number(hour)<10){
			hour = "0"+hour;	
		}
		if(Number(minute)<10){
			minute = "0"+minute;	
		}
		
		var rsrv_date =  date+" "+hour+":"+minute;
		
		//일정이 중복되는경우 입력하지 않는다.
		for(var i=0; i<$("#RUN_RESV_LIST option").size(); i++){
			if(rsrv_date == $("#RUN_RESV_LIST option:eq("+i+")").val()){
				alert("이미 등록된 일정입니다");
				$("#RUN_RESV_LIST").focus();
				return;				
			}
		}
		
		$("#RUN_RESV_LIST").append("<option value='"+rsrv_date+"'>"+rsrv_date+"</option>");
		
	}

	
	/* 사용자 지정 일정 삭제*/
	function fn_delete(){

		var exit = false;
		//진행된것 있는지 체크
		$("#RUN_RESV_LIST option:selected").each(function(){
			if($(this).text().trim().length != 16){
				alert("진행된 일정("+$(this).text()+")은 삭제할수 없습니다");
				exit = true;
				return false;
			}
		});
		
		if(exit){
			return;
		}
		
		$("#RUN_RESV_LIST option:selected").each(function(){
			$(this).remove();
		});
		
	}
	
	/* 저장 및 실행 버튼 클릭 */
	function fn_saveAndStart(){
		
		$("#START_FLAG").val("Y");
		
		fn_save();
		
	}
	
	

	/* 실행 (상태를 START로 바꾸고 플로차트 파일권한 변경한다) */
	function fn_setStart() {

		jQuery.ajax({
			url           : '/UnicaExt/setCampaignStart.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
        		
        			alert("저장 및 실행 되었습니다");
       			
        			var frm = document.form;
       				frm.action = "/UnicaExt/scheduleDetail.do";
       				frm.target = "_self";
       				frm.submit();	        				
	        		
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
		
	};	
	
	/* 상태는 실행이지만 아직 미실행되었을경우에는 취소가능  */
	function fn_campaignCancel(){
		
		if(!confirm("캠페인을 취소하겠습니까?")){
			return;
		}
		
		jQuery.ajax({
			url           : '/UnicaExt/setCampaignCancel.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
        		
        			alert("캠페인이 취소 되었습니다");
       			
        			var frm = document.form;
       				frm.action = "/UnicaExt/scheduleDetail.do";
       				frm.target = "_self";
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
	
	
	/* 일정 목록 보기 */
	function fn_showSchedulel(){
		
		var frm = document.form;
		pop = window.open('', 'SCHEDULE_LIST', 'top=50,left=80, location=no,status=no,toolbar=no,scrollbars=yes');
	    
		frm.target = "SCHEDULE_LIST";
	    frm.method = "POST";
		frm.action = "/UnicaExt/scheduleList.do";
		frm.submit();
		pop.focus();
		
	}
	
	
	/* 캠페인 테스트 실행 */
	function fn_campaignTest(){
		
		var frm = document.form;
		pop = window.open('', 'CAMPAIGN_TEST', 'top=50,left=80, location=no,status=no,toolbar=no,scrollbars=yes');
	    
		frm.target = "CAMPAIGN_TEST";
	    frm.method = "POST";
		frm.action = "${staticPATH }/schedule/campaignTest.do";
		frm.submit();
		pop.focus();
		
	}
	
	/* 날짜형식 yyyy-mm-dd Date 오브젝트 구하기 */
	function getDateObj(value){
		
		var adata = value.split('-');
        var mm = parseInt(adata[1],10); // was gg (giorno / day)
        var dd = parseInt(adata[2],10); // was mm (mese / month)
        var yyyy = parseInt(adata[0],10); // was aaaa (anno / year)
        var xdata = new Date(yyyy,mm-1,dd);
        
        return xdata;
        
	}
	
	/* 날짜형식 유효성 체크 */
	function dateValiChk(value) {
		
		var re = /^\d{4}\-\d{1,2}\-\d{1,2}$/;
        
        return re.test(value);
        
        if( re.test(chkdate)){
            var adata = chkdate.split('-');
            var mm = parseInt(adata[1],10); // was gg (giorno / day)
            var dd = parseInt(adata[2],10); // was mm (mese / month)
            var yyyy = parseInt(adata[0],10); // was aaaa (anno / year)
            var xdata = new Date(yyyy,mm-1,dd);
            if ( ( xdata.getFullYear() == yyyy ) && ( xdata.getMonth () == mm - 1 ) && ( xdata.getDate() == dd ) )
                check = true;
            else
                check = false;
        } else
            check = false;
        return check;
    }
	
	/* 지정시간 일정구분 방식 일정 추가 */
	function fn_addTime(){
		
		var startDate = $("#RSRV_START_DT").val();
		var endDate = $("#RSRV_END_DT").val();
		var startHour = $("#RSRV_HOUR_07").val();
		var startHourTo = $("#RSRV_HOUR_07_TO").val();
		var startMin = $("#RSRV_MINUTE_07").val();
		
		var everyTime = $("input:checkbox[name='EVERYTIME']").is(":checked") == true;
		
		var startDateObj, endDateObj,tempDateObj;
		
		if ( dateValiChk(startDate) ){
			startDateObj = getDateObj(startDate);
		} 
        
		if ( dateValiChk(endDate) ){
			endDateObj = getDateObj(endDate);
		}
		
		// 날짜형식 기본 유효성 체크
		if ( fn_validation() ){
			
			var msg = '';
			// From To 날짜 체크 ( 년도 또는 달 )
			while ( startDateObj <= endDateObj ){
				
				// 설정 시간 확인
				var year   = startDateObj.getFullYear();
				var month  = startDateObj.getMonth() +1;
				if ( month < 10 ){
					month = '0' + month;
				}
				
				var day    = startDateObj.getDate();
				if ( day < 10 ){
					day = '0' + day;
				}
				
				var date   = year + '-' + month + '-' + day;

				var hour   = $("#RSRV_HOUR_07").val();
				var hourTo = $("#RSRV_HOUR_07_TO").val();
				var minute = $("#RSRV_MINUTE_07").val();
				
				if(Number(minute)<10){
					minute = "0"+minute;	
				}
				
				// 매시간 체크 여부 
				if ( everyTime ){
					
					var temp;
					var rsrv_date;
					var instFlag;
					
					var timeListSize = $("#RUN_RESV_LIST_06 option").size();
					
					var i;
					for(i=Number(hour); i<=Number(hourTo); i++){
						
						temp = null;
						
						if ( Number(i)<10 ){
							temp = '0' + i;
						}else{
							temp = i;
						}
						
						rsrv_date = date +" "+temp+":"+minute;
						instFlag = true;
						
						//일정이 중복되는경우 입력하지 않는다.
						for(var j=0; j<timeListSize; j++){
							if(rsrv_date == $("#RUN_RESV_LIST_06 option:eq("+j+")").val()){
								msg += rsrv_date + '\n';
								instFlag = false;
							}
						}
						
						if ( instFlag ){
							$("#RUN_RESV_LIST_06").append("<option value='"+rsrv_date+"'>"+rsrv_date+"</option>");	
						}
					}
					
					startDateObj.setDate(startDateObj.getDate() + 1 );

				}else{
					
					if(Number(hour)<10){
						hour = "0"+hour;	
					}
					if(Number(hourTo)<10){
						hourTo = "0"+hourTo;	
					}
					
					var rsrv_date = date +" "+hourTo+":"+minute;
					var instFlag = true;
					
					//일정이 중복되는경우 입력하지 않는다.
					for(var i=0; i<$("#RUN_RESV_LIST_06 option").size(); i++){
						if(rsrv_date == $("#RUN_RESV_LIST_06 option:eq("+i+")").val()){
							msg += rsrv_date + '\n';
							instFlag = false;
						}
					}
					
					if ( instFlag ){
						$("#RUN_RESV_LIST_06").append("<option value='"+rsrv_date+"'>"+rsrv_date+"</option>");	
					}
					
					startDateObj.setDate(startDateObj.getDate() + 1 );

				}
			}
			
			if ( msg != '' ){
				alert("중복된 다음일정은 입력되지 않았습니다.\n" + msg);
			}
		}
		
	}
	
	/* 사용자 지정 일정 삭제*/
	function fn_deleteTime(){

		var exit = false;
		//진행된것 있는지 체크
		$("#RUN_RESV_LIST_06 option:selected").each(function(){
			if($(this).text().trim().length != 16){
				alert("진행된 일정("+$(this).text()+")은 삭제할수 없습니다");
				exit = true;
				return false;
			}
		});
		
		if(exit){
			return;
		}
		
		$("#RUN_RESV_LIST_06 option:selected").each(function(){
			$(this).remove();
		});
		
	}
	
	/* 지정시간 선택 후 매시간 선택시 select 시간 설정 disable 처리 */
	function disEveryTimeSelect(){
		
		$("input:checkbox[name='EVERYTIME']").each(function(){
			if(this.checked){
				$("#RSRV_HOUR_07").attr("disabled",false);
			}else{
				$("#RSRV_HOUR_07").attr("disabled",true);
			}
		});
		
	}

	/* 상태는 실행이고 진행한 캠페인이 있을 경우에 편집 모드 가능  */
	function fn_campaignCancel(){
		
		if(!confirm("실행된 캠페인 플로차트가 있습니다.\n캠페인을 편집하겠습니까?")){
			return;
		}
		
		jQuery.ajax({
			url           : '/UnicaExt/setCampaignPause.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : $("#form").serialize(),
	        success: function(result, option) {

	        	if(option=="success"){
        		
        			alert("캠페인 편집모드가 완료 되었습니다");
       			
        			var frm = document.form;
       				frm.action = "/UnicaExt/scheduleDetail.do";
       				frm.target = "_self";
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
	
	</script>
	 <!--PAGE CONTENT -->
	        <div id="content" style="width:100%; height100%;">
	           <!--BLOCK SECTION -->
	           <div class="row" style="width:100%; height100%;">
	              <div class="col-md-1"></div>
	              <div class="col-md-10">

	              <div class="col-md-12 page-header" style="margin-top:0px;">
                  <h3>캠페인 일정</h3>
               </div>
<form name="form" id="form">
<input type="hidden" id="TO_DATE" name="TO_DATE" value="" />
<input type="hidden" id="TO_DATE_P1" name="TO_DATE_P1" value="" />
<input type="hidden" id="TO_DATE_P2" name="TO_DATE_P2" value="" />
<input type="hidden" id="CAMPAIGNCODE" name="CAMPAIGNCODE" value="${bo.campaigncode}" />
<input type="hidden" id="CampaignId" name="CampaignId" value="${CAMPAIGNID}" />
<input type="hidden" id="RSRV_WEEK_DAY" name="RSRV_WEEK_DAY" value="" />
<input type="hidden" id="START_FLAG" name="START_FLAG" value="" />	<div id="table">
		<table class='table table-striped table-hover table-condensed table-bordered' width='100%' border='0' cellpadding='0' cellspacing='0'>
			<colgroup>
				<col width="15%"/>
				<col width="35%"/>
				<col width="15%"/>
				<col width="35%"/>
			</colgroup>
			<tr>
				<td class="info">캠페인 코드/명</td>
				<td class="tbtd_content" colspan="3"]>[${bo.campaigncode}]${bo.campaignname}</td>
				<%-- <td class=""></td>
				<td class="">${bo.flowchartname}</td> --%>
			</tr>
			<tr>
				<td class="info">일정구분</td>
				<td class="tbtd_content" colspan="3">
					<select style="width: 110px;" id="RSRV_GUBUN_CODE" name="RSRV_GUBUN_CODE" >
						<c:forEach var="val" items="${runResvType_list}">
<!-- 							<script>
							 console.log("val.code_id : ${val.code_id} ++++ bo.manual_trans_yn : ${bo.manual_trans_yn} ++++ bo.camp_term_cd : ${bo.camp_term_cd}} ");
							</script>
 -->							
							<c:if test="${val.code_id eq '01' && bo.manual_trans_yn eq 'N' && bo.camp_term_cd eq '02' }">
								<option value="${val.code_id}" 
									<c:if test="${val.code_id eq bo.rsrv_gubun_code}">selected="selected"</c:if>>
									${val.code_name}
								</option>
							</c:if>
							
							<c:if test="${val.code_id eq '02' && bo.manual_trans_yn eq 'N' && bo.camp_term_cd eq '02' }">
								<option value="${val.code_id}"
									<c:if test="${val.code_id eq bo.rsrv_gubun_code}">selected="selected"</c:if>>
									${val.code_name}
								</option>
							</c:if>
							
							<c:if test="${val.code_id eq '03' && bo.manual_trans_yn eq 'N' && bo.camp_term_cd eq '02' }">
								<option value="${val.code_id}"
									<c:if test="${val.code_id eq bo.rsrv_gubun_code}">selected="selected"</c:if>>
									${val.code_name}
								</option>
							</c:if>
							
							<c:if test="${val.code_id eq '06' && bo.manual_trans_yn eq 'N' && bo.camp_term_cd eq '02' }">
								<option value="${val.code_id}"
									<c:if test="${val.code_id eq bo.rsrv_gubun_code}">selected="selected"</c:if>>
									${val.code_name}
								</option>
							</c:if>
							
							<c:if test="${val.code_id eq '06' && bo.manual_trans_yn eq 'T' && bo.camp_term_cd eq '02' }">
								<option value="${val.code_id}"
									<c:if test="${val.code_id eq bo.rsrv_gubun_code}">selected="selected"</c:if>>
									${val.code_name}
								</option>
							</c:if>
							
							<c:if test="${val.code_id eq '05'}">
								<option value="${val.code_id}"
									<c:if test="${val.code_id eq bo.rsrv_gubun_code}">selected="selected"</c:if>
									<c:if test="${val.code_id eq '05' && bo.rsrv_gubun_code == null}">selected="selected"</c:if>>
									${val.code_name}
								</option>
							</c:if>
							
						</c:forEach>
					</select>
					<span id="SPANEVERYTIME" name="SPANEVERYTIME">
						<input type="checkbox" id="EVERYTIME" name="EVERYTIME" value="Y" <c:if test="${bo.rsrv_gubun_code eq '06' && bo.rsrv_everytime eq 'Y' }">checked="checked"</c:if> /><b>매시간</b>
					</span>
				</td>
			</tr>			
			<tr id="tr_00" >
				<td class="info">추출기간</td>
				<td class="tbtd_content" colspan="3">
					<input type="text" id="RSRV_START_DT" name="RSRV_START_DT" class="txt" style="width:82px;" value="${bo.rsrv_start_dt}" readonly="readonly"/>
					~
					<input type="text" id="RSRV_END_DT" name="RSRV_END_DT" class="txt" style="width:82px;" value="${bo.rsrv_end_dt}" readonly="readonly"/>
				</td>
			</tr>
			<tr id="tr_01" style="height:; vertical-align: top;">
				<td class="info">
					매일
				</td>
				<td class="tbtd_content" colspan="3">
					<select style="width: 45px;" id="RSRV_HOUR_01" name="RSRV_HOUR_01" >
						<c:forEach var="val" varStatus="i" begin="08" end="20" step="1">
							<option value="${val}"
								<c:if test="${bo.rsrv_gubun_code eq '01' && bo.rsrv_hour eq val}">selected="selected"</c:if>
							>
							<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
							</option>
						</c:forEach>
					</select>
					시
					<select style="width: 45px;" id="RSRV_MINUTE_01" name="RSRV_MINUTE_01">
						<c:forEach var="val" varStatus="i" begin="00" end="59" step="1">
							<option value="${val}"
								<c:if test="${bo.rsrv_gubun_code eq '01' && bo.rsrv_minute eq val}">selected="selected"</c:if>
							>
							<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
							</option>
						</c:forEach>
					</select>
					분
				</td>
			</tr>
			<tr id="tr_02" style="height:; vertical-align: top;">
				<td class="info">
					매주
				</td>
				<td class="tbtd_content" colspan="3">
					<input type="checkbox" name="CRSRV_WEEK_DAY" <c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '2') != '-1'   }">checked="checked"</c:if> value="2"/>월
					<input type="checkbox" name="CRSRV_WEEK_DAY" <c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '3') != '-1'   }">checked="checked"</c:if> value="3"/>화
					<input type="checkbox" name="CRSRV_WEEK_DAY" <c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '4') != '-1'   }">checked="checked"</c:if> value="4"/>수
					<input type="checkbox" name="CRSRV_WEEK_DAY" <c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '5') != '-1'   }">checked="checked"</c:if> value="5"/>목
					<input type="checkbox" name="CRSRV_WEEK_DAY" <c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '6') != '-1'   }">checked="checked"</c:if> value="6"/>금
					<input type="checkbox" name="CRSRV_WEEK_DAY" <c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '7') != '-1'   }">checked="checked"</c:if> value="7"/>토
					<input type="checkbox" name="CRSRV_WEEK_DAY" <c:if test="${bo.rsrv_gubun_code eq '02' && fn:indexOf(bo.rsrv_week_day, '1') != '-1'   }">checked="checked"</c:if> value="1"/>일
					<select style="width: 45px;" id="RSRV_HOUR_02" name="RSRV_HOUR_02">
						<c:forEach var="val" varStatus="i" begin="08" end="20" step="1">
							<option value="${val}"
								<c:if test="${bo.rsrv_gubun_code eq '02' && bo.rsrv_hour eq val}">selected="selected"</c:if>
							>
							<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
							</option>
						</c:forEach>
					</select>
					시
					<select style="width: 45px;" id="RSRV_MINUTE_02" name="RSRV_MINUTE_02">
						<c:forEach var="val" varStatus="i" begin="00" end="59" step="1">
							<option value="${val}"
								<c:if test="${bo.rsrv_gubun_code eq '02' && bo.rsrv_minute eq val}">selected="selected"</c:if>
							>
							<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
							</option>
						</c:forEach>
					</select>
					분
				</td>
			</tr>
			<tr id="tr_03" style="height:; vertical-align: top;">
				<td class="info">
					매월
				</td>			
				<td class="tbtd_content" colspan="3">
					<select style="width: 45px;" id="RSRV_DAY_03" name="RSRV_DAY_03">
						<c:forEach var="val" varStatus="i" begin="01" end="31" step="1">
							<option value="${val}"
								<c:if test="${bo.rsrv_gubun_code eq '03' && bo.rsrv_day eq val}">selected="selected"</c:if>
							>
							<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
							</option>
						</c:forEach>
					</select>
					일
					<select style="width: 45px;" id="RSRV_HOUR_03" name="RSRV_HOUR_03">
						<c:forEach var="val" varStatus="i" begin="08" end="20" step="1">
							<option value="${val}"
								<c:if test="${bo.rsrv_gubun_code eq '03' && bo.rsrv_hour eq val}">selected="selected"</c:if>
							>
							<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
							</option>
						</c:forEach>
					</select>
					시
					<select style="width: 45px;" id="RSRV_MINUTE_03" name="RSRV_MINUTE_03">
						<c:forEach var="val" varStatus="i" begin="00" end="59" step="1">
							<option value="${val}"
								<c:if test="${bo.rsrv_gubun_code eq '03' && bo.rsrv_minute eq val}">selected="selected"</c:if>
							>
							<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
							</option>
						</c:forEach>
					</select>
					분
				</td>			
			</tr>
			
			<tr id="tr_04" style="height:; vertical-align: top;">
				<td class="info">
					추출시간
				</td>
				<td class="tbtd_content" colspan="3">
					<select style="width: 45px;" id="RSRV_HOUR_01" name="RSRV_HOUR_01" >
						<c:forEach var="val" varStatus="i" begin="08" end="20" step="1">
							<option value="${val}"
								<c:if test="${bo.rsrv_gubun_code eq '01' && bo.rsrv_hour eq val}">selected="selected"</c:if>
							>
							<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
							</option>
						</c:forEach>
					</select>
					시
					<select style="width: 45px;" id="RSRV_MINUTE_01" name="RSRV_MINUTE_01">
						<c:forEach var="val" varStatus="i" begin="00" end="59" step="1">
							<option value="${val}"
								<c:if test="${bo.rsrv_gubun_code eq '01' && bo.rsrv_minute eq val}">selected="selected"</c:if>
							>
							<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
							</option>
						</c:forEach>
					</select>
					분
				</td>
			</tr>
			<tr id="tr_07" style="height:; vertical-align: top;">
				<td class="info">
					지정시간
				</td>			
				<td class="tbtd_content"  colspan="3">
					<div id="sysbtn_l2">		
								<span id="sysbtn_l">
									<select style="width: 45px;" id="RSRV_HOUR_07" name="RSRV_HOUR_07">
										<c:forEach var="val" varStatus="i" begin="08" end="20" step="1">
											<option value="${val}" <c:if test="${bo.rsrv_gubun_code eq '06' && bo.rsrv_timehourfrom eq val}">selected="selected"</c:if>>
											<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
											</option>
										</c:forEach>
									</select>
									시 ~
									
									<select style="width: 45px;" id="RSRV_HOUR_07_TO" name="RSRV_HOUR_07_TO">
										<c:forEach var="val" varStatus="i" begin="08" end="20" step="1">
											<option value="${val}" <c:if test="${bo.rsrv_gubun_code eq '06' && bo.rsrv_timehourto eq val}">selected="selected"</c:if>>
											<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
											</option>
										</c:forEach>
									</select>
									시
									
									<select style="width: 45px;" id="RSRV_MINUTE_07" name="RSRV_MINUTE_07">
										<c:forEach var="val" varStatus="i" begin="00" end="59" step="1">
											<option value="${val}" <c:if test="${bo.rsrv_gubun_code eq '06' && bo.rsrv_timemin eq val}">selected="selected"</c:if>>
											<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
											</option>
										</c:forEach>
									</select>
									분
								</span>
								<span id="sysbtn_l">
									<button type="button" class="btn btn-success btn-sm" onclick="fn_addTime();"><i class="fa fa-plus" aria-hidden="true"></i> 추가</button>
									<button type="button" class="btn btn-success btn-sm" onclick="fn_deleteTime();"><i class="fa fa-trash-o" aria-hidden="true"></i> 삭제</button>
								</span>
						
					</div>
					<br/>
					<div >
						<select multiple="multiple" style="width:160px; height:100px" size="5" id="RUN_RESV_LIST_06" name="RUN_RESV_LIST_06[]">
							<c:if test="${bo.rsrv_gubun_code eq '06'}">
								<c:forEach var="val" items="${list}">
<option value="${val.rsrv_dt}">${val.rsrv_dt}<c:if test="${val.run_start_dt != null and val.run_end_dt == null}">(진행중)</c:if><c:if test="${val.run_start_dt != null and val.run_end_dt != null}"><c:if test="${val.run_success_yn eq 'Y'}">(성공)</c:if><c:if test="${val.run_success_yn eq 'N'}">(실패)</c:if></c:if></option>
								</c:forEach>
							</c:if>
						</select>
					</div>
				</td>
			</tr>
			
			<tr id="tr_05" style="height: 150px; vertical-align: top;">
				<td class="info">
					사용자 지정
				</td>			
				<td class="tbtd_content" colspan="3">
					<div id="sysbtn_l2" class="solid ">
						
							<span id="sysbtn_l" class="col-md-5">
							<input type="text" id="RSRV_DAY_05" name="RSRV_DAY_05" class="txt" style="width:80px;" readonly="readonly"/>
								<select style="width: 45px;" id="RSRV_HOUR_05" name="RSRV_HOUR_05">
									<c:forEach var="val" varStatus="i" begin="08" end="20" step="1">
										<option value="${val}">
										<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
										</option>
									</c:forEach>
								</select>
								시
								<select style="width: 45px;" id="RSRV_MINUTE_05" name="RSRV_MINUTE_05">
									<c:forEach var="val" varStatus="i" begin="00" end="59" step="1">
										<option value="${val}">
										<c:if test="${val < 10}">0</c:if><c:out value="${val}" />
										</option>
									</c:forEach>
								</select>
								분
							</span>
							<span id="sysbtn_l" class="col-md-7">
								<button type="button" class="btn btn-success btn-sm" onclick="fn_add();"><i class="fa fa-plus" aria-hidden="true"></i> 추가</button>
								<button type="button" class="btn btn-success btn-sm" onclick="fn_delete();"><i class="fa fa-times" aria-hidden="true"></i> 삭제</button>
								</ul>
							</span>
							
					</div>
					<br/>
					<br/>
					<div >
						<select multiple="multiple" style="width:160px; height:100px" size="5" id="RUN_RESV_LIST" name="RUN_RESV_LIST[]">
							<c:if test="${bo.rsrv_gubun_code eq '05'}">
								<c:forEach var="val" items="${list}">
<option value="${val.rsrv_dt}">${val.rsrv_dt}<c:if test="${val.run_start_dt != null and val.run_end_dt == null}">(진행중)</c:if><c:if test="${val.run_start_dt != null and val.run_end_dt != null}"><c:if test="${val.run_success_yn eq 'Y'}">(성공)</c:if><c:if test="${val.run_success_yn eq 'N'}">(실패)</c:if></c:if></option>
								</c:forEach>
							</c:if>
						</select>
					</div>
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
		</table>
	</div>		

	<div id="sysbtn" class="col-md-12" style="text-align:right;margin-bottom:10px;">
      <button type="button" class="btn btn-default btn-sm" onclick="window.close();"><i class="fa fa-times" aria-hidden="true"></i> 닫기</button>&nbsp;&nbsp;
			<button type="button" class="btn btn-danger btn-sm" onclick="fn_save();"><i class="fa fa-save" aria-hidden="true"></i> 저장</button>&nbsp;&nbsp;
			<c:if test="${bo.scheduleCnt != '0'}">
				<!-- <button type="button" class="btn btn-success btn-sm" onclick="fn_showSchedulel();"><i class="fa fa-calendar-check-o" aria-hidden="true"></i> 일정보기</button> -->
			</c:if>
 			<button type="button" class="btn btn-success btn-sm" onclick="fn_campaignTest();"><i class="fa fa-exclamation" aria-hidden="true"></i> 테스트실행</button>
			<c:if test="${bo.camp_status_cd eq 'EDIT'}">
				<!-- <button type="button" class="btn btn-success btn-sm" onclick="fn_saveAndStart();"><i class="fa fa-floppy-o" aria-hidden="true"></i> 저장 및 시작</button> -->
			</c:if>	
			<c:if test="${bo.camp_status_cd eq 'START' && bo.schedulePlayCnt eq '0' }">
				<button type="button" class="btn btn-success btn-sm" onclick="fn_campaignCancel();"><i class="fa fa-ban" aria-hidden="true"></i> 캠페인 취소</button>
			</c:if>	
			<c:if test="${bo.camp_status_cd eq 'START' && bo.schedulePlayCnt ne '0' }">
				<!-- <button type="button" class="btn btn-success btn-sm" onclick="fn_campaignCancel();"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> 편집모드</button> -->
			</c:if>
	</div>
	
</div>
</form>
                            <div class="col-md-1"></div>
                            
                            </div>
                        </div>
                        <!--END BLOCK SECTION -->
                        <div class="col-lg-3"></div>
              
                      </div>
                      <!--END PAGE CONTENT -->
                      
                      
        
        



