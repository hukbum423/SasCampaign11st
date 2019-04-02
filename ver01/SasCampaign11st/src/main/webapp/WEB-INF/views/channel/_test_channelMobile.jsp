<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script type="text/javascript">
	window.resizeTo(1180,910);
	// Global Var
	var _IMG_PATH_  = "http://bo.11st.co.kr";
	var _UPLOAD_IMG_PATH_  = "http://image.11st.co.kr";
	var _ACTION_CONTEXT_  = "";
	var _FILE_UPLOAD_PATH_ = "/upload";
	var _ACTION_CONTEXT_URL_ = "http://bo.11st.co.kr";
	
	var _TOWN_URL_				= "http://town.11st.co.kr";
	var _TOWN_SHOP_DELV_URL_ 	= "http://town.11st.co.kr/town/TownShopDetail.tmall?method=getTownDeliveryShopDetail&shopNo=";

	var _CSS_PATH_ = "http://bo.11st.co.kr";
	var _CSS_URL_ = "http://c.011st.com";
	var _UPLOAD_URL_ = "http://i.011st.com";
	var _IMG_URL_ = "http://s.011st.com";
</script>


<script language="JavaScript" src="/js/weblog/xtractor_cookie.js"></script>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>푸시 알림 등록/수정</title>
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="/js/lib/ext/resources/css/ext-all.css" />
	<link rel="stylesheet" type="text/css" href="/js/lib/ext/css/basic-dialog.css" />
	<link rel="stylesheet" href="/css/back_com.css" type="text/css">
	<link rel="stylesheet" href="/css/back.css" type="text/css">
	<link rel="stylesheet" href="/css/widget.css" type="text/css">
	<link rel="stylesheet" href="/css/yui.css" type="text/css">
	<link rel="stylesheet" href="/css/btn.css" type="text/css">

	<script type="text/javascript" src="/js/common/jquery-1.7.2.js"></script>
	<!-- LIBS -->
    <script type="text/javascript" src="/js/browsing/browsing_common.js"></script>
	<script type="text/javascript" src="/js/top.js" type="text/javascript"></script>

    <script type="text/javascript" src="/js/lib/ext/adapter/yui/yui-utilities.js"></script>
    <script type="text/javascript" src="/js/lib/ext/adapter/yui/ext-yui-adapter.js"></script>
 	<script type="text/javascript" src="/js/lib/ext/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="/js/lib/ext/ext-all.js"></script>

    <!-- COMMON JS -->
	<script src="/js/common/common.js" type="text/javascript"></script>
	<script src="/js/common/type_check.js" type="text/javascript"></script>
	<script src="/js/common/util.js" type="text/javascript"></script>

	<!-- BROWSING COMMON -->
	<script type="text/javascript" src="/js/browsing/browsing_common.js"></script>
	<script type="text/javascript" src="/js/browsing/display_corner.js"></script>
	<script type="text/javascript" src="/js/browsing/corner_location.js"></script>


<script>
var datePicker;

/**
 * DATE PICKER 초기화
 */
function initDatePicker(showDivTag)
{
	if(datePicker == null)
	{
		createDatePicker();
		datePicker.render(Ext.fly(showDivTag));
	}
	 else
	{
		if(datePicker.isVisible)
		{
			datePicker.isVisible = false;
			datePicker.hide();
			return false;
		}
		else {
			createDatePicker();
			datePicker.render(Ext.fly(showDivTag));
		}
	}
	datePicker.div_id = showDivTag;
	return true;
}

/**
 * DATE PICKER 생성
 */

/**
* format 변경 예제
format('Y-m-d'));                         //2007-01-10
format('F j, Y, g:i a'));                 //January 10, 2007, 3:05 pm
format('l, \\t\\he dS of F Y h:i:s A'));  //Wednesday, the 10th of January 2007 03:05:01 PM
*/
function createDatePicker(datePickerConfig)
{
	if(datePickerConfig != null)
	{
		datePicker = new Ext.DatePicker(datePickerConfig);
	}
	 else
	{
		datePicker = new Ext.DatePicker({
			dayNames : ['일','월','화','수','목','금','토'],
			monthNames : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			format : "Ymd",
			todayText : "오늘",
			nextText : "다음(Control+Right)",
			prevText : "이전(Control+Left)",
		    monthYearText: '년도선택 (Control+Up/Down to move years)',
			okText : "선택",
			cancelText : "취소"
		});
	}

}

/**
 * DATE PICKER 화면에 출력
 */
function showDatePicker(showDivTag, inputObj, dateFormat)
{

	if(!initDatePicker(showDivTag))
		return;

	// 초기 날짜 셋팅
    datePicker.format = dateFormat;
	setInitDate(inputObj.value)

	datePicker.on('select', function (dpObj, selDate) {
								inputObj.value = selDate.format(datePicker.format);
								dpObj.isVisible = false;
								dpObj.hide();
							}, this, {single: true, delay: 100, forumId: 4 });
	datePicker.on('close', function (dpObj, val) {
								dpObj.isVisible = false;
								dpObj.hide();
							}, this, {single: true, delay: 100, forumId: 4 });
	datePicker.on('blank', function (dpObj, val) {
								inputObj.value = val;
								dpObj.isVisible = false;
								dpObj.hide();
							}, this, {single: true, delay: 100, forumId: 4 });
	datePicker.isVisible = true;
	datePicker.show();

}

/**
 * DATE PICKER 화면에 출력 (Callback 포함)
 */
function showDatePickerCB(showDivTag, cbFunc, initDate)
{
	if(!initDatePicker(showDivTag))
		return;

	datePicker.on('select', cbFunc, this, {single: true, delay: 100, forumId: 4	});
	setInitDate(initDate);
	datePicker.show();
}

/**
 * DATE PICKER 초기 날짜 셋팅
 **/
function setInitDate(initDate)
{
	try {
		datePicker.setValue(Date.parseDate(initDate, datePicker.format));
	}
	 catch(e) {
	 	datePicker.setValue(new Date());
	}
}
</script>
<script type="text/javascript">
	window.onload = function(){
        var formObj = document.formTalk;
		//
		setDate();
		//

        $('.icon_question').click(function(){
            $(".layer_def_a").removeClass('selected');
            $(this).next('.layer_def_a').toggleClass('selected');
            return false;
        });

        $('.btn_layclose').click(function(){
            $(this).closest('.layer_def_a').removeClass('selected');
            return false;
        });



        $('#blockTable').on('click', 'a[href]', function(){

            if( $(this).attr("id") == 'remove' ){
                $(this).closest("tr").remove();
                return false;
            }

            if( $(".blockProductPriceChecker").html() != null ){
                if( $(this).attr("id") == 'add' ){
                    if( $(".blockProductPriceChecker").length >= 10  ){
                        alert('no add');
                        return false;
                    }
                    $(this).parents('.blockProductPriceChecker').after(func_Block_Product_Price_add());
                }
                return false;
            }

            if( $(".blockCouponTextChecker").html() != null ){
                if( $(this).attr("id") == 'add' ){
                    if( $(".blockCouponTextChecker").length >= 5  ){
                        alert('no add');
                        return false;
                    }
                    $(this).parents('.blockCouponTextChecker').after(func_Block_Coupon_Text_add());
                }
                return false;
            }

        });


        funcTalkDisp();
        blockSetting( $("input:radio[name=talkMsgTmpltNo]:checked").val() );
	};

	function blockSetting(no){
        $("#blockTable").html('');
        $("#talkImgSample").html('');
	    if( no == '001' ){
            $("#blockTable").append(func_Block_Top_Cap($("#block_1").val()));
            $("#blockTable").append(func_Block_Bold_Text($("#block_2").val()));
            $("#blockTable").append(func_Block_Img_500($("#block_3").val()));
            $("#blockTable").append(func_Block_Btn_View($("#block_4").val()));
            blockSampleType01();
        }

        if( no == '002' ){
            $("#blockTable").append(func_Block_Top_Cap($("#block_1").val()));
            $("#blockTable").append(func_Block_Bold_Text($("#block_2").val()));
            $("#blockTable").append(func_Block_Img_240($("#block_3").val()));
            $("#blockTable").append(func_Block_Product_Price($("#block_4").val()));
            $("#blockTable").append(func_Block_Btn_View($("#block_5").val()));
            blockSampleType02();
        }

        if( no == '003' ){
            $("#blockTable").append(func_Block_Top_Cap($("#block_1").val()));
            $("#blockTable").append(func_Block_Bold_Text($("#block_2").val()));
            $("#blockTable").append(func_Block_Img_240($("#block_3").val()));
            $("#blockTable").append(func_Block_Coupon_Text($("#block_4").val()));
            $("#blockTable").append(func_Block_Btn_View($("#block_5").val()));
            blockSampleType03();
        }

        if( no == '004' ){
            $("#blockTable").append(func_Block_Top_Cap($("#block_1").val()));
            $("#blockTable").append(func_Block_Bold_Text($("#block_2").val()));
            $("#blockTable").append(func_Block_Sub_Text($("#block_3").val()));
            $("#blockTable").append(func_Block_Btn_View($("#block_4").val()));
            blockSampleType04();
        }

        if( no == '005' ){
            $("#blockTable").append(func_Block_Top_Cap($("#block_1").val()));
            $("#blockTable").append(func_Block_Bold_Text($("#block_2").val()));
            $("#blockTable").append(func_Block_Product_Price($("#block_3").val()));
            $("#blockTable").append(func_Block_Btn_View($("#block_4").val()));
            blockSampleType05();
        }

        if( no == '006' ){
            $("#blockTable").append(func_Block_Top_Cap($("#block_1").val()));
            $("#blockTable").append(func_Block_Bold_Text($("#block_2").val()));
            $("#blockTable").append(func_Block_Coupon_Text($("#block_3").val()));
            $("#blockTable").append(func_Block_Btn_View($("#block_4").val()));
            blockSampleType06();
        }

    }

	function setDate() {

        var dateStr = $("input[name=sendStartDtStr]").val();
		var currYY1 = dateStr.substring(0,4);
		var currMM1 = dateStr.substring(4,6);
		var currDD1 = dateStr.substring(6,8);
		var currHH1 = dateStr.substring(8,10);
		var currMI1 = dateStr.substring(10,12);

		var formObj = document.formTalk;
		formObj.sYY.value = currYY1;
		formObj.sMM.value = currMM1;
		formObj.sDD.value = currDD1;
		formObj.sHH.value = currHH1;
		formObj.sMI.value = currMI1;

	}

	function launchCenter(url, name, width,height, scroll, url)
	{
		var str = "height=" + height + ",innerHeight=" + height;
		str += ",width=" + width + ",innerWidth=" + width;
		str += ",status=no,scrollbars=" + scroll;

		if (window.screen)
		{
			var ah = screen.availHeight - 30;
			var aw = screen.availWidth - 10;

			var xc = (aw - width) / 2;
			var yc = (ah - height) / 2;

			str += ",left=" + xc + ",screenX=" + xc;
			str += ",top=" + yc + ",screenY=" + yc;
		}

		return window.open(url, name, str);
	}

</script>
<script>

function changeTmplType(tmplTypeNo)
{
	var obj;
	if(tmplTypeNo > 0) obj = document.getElementById('tmplType'+tmplTypeNo);

	for(var i=1; i <= 2; i++){
		document.getElementById('tmplType0'+i).style.display = 'none';
	}
	
	if( obj != null && tmplTypeNo > 0) obj.style.display = 'block';

    if( tmplTypeNo == '04' ){
        $("input:radio[name=talkMsgDispYn]")[1].checked = true
        funcTalkDisp();
    }
}

function dispArea(id, val)
{
	var obj = document.getElementById(id);
	
	if(val)
		obj.style.display = 'block';
	else 
		obj.style.display = 'none';
}

// 기본 배경 이미지 파일찾기
function funcBasicBannerOpen(a,b,c)	{
    var formObj  	= document.formTalk;
	var file 		= document.getElementById(a);
	var name		= eval("formObj." + b );
	var thumbImg	= eval("formObj." + c );

	var orgImgPath = setThumbImg(file, thumbImg, c);
	name.value = orgImgPath;
}

function setImgUploadFile(area, img) {
    var a = document.getElementById(area);
    var i =  document.getElementById(img);

    a.value = i.value;
}

function setThumbImg(sc, thumbImg, id)	{
	var ua = window.navigator.userAgent;
	var orgImgPath = sc.value;

	try{
		if ( ua.indexOf("MSIE 8") > -1 || orgImgPath.indexOf("\\fakepath\\") > -1  || ua.indexOf("MSIE 7") > -1  )	{
			if ( orgImgPath.indexOf("\\fakepath\\") > -1  )	{
				sc.select();
				var selectionRange = document.selection.createRange();
				orgImgPath = selectionRange.text.toString();
			}

			var newImg = document.getElementById(id + "_thumb");
			if ( !newImg )	{
				newImg = document.createElement("span");
				newImg.id = id + "_thumb";
				newImg.style.width = "60px";
				newImg.style.height = "60px";
				thumbImg.parentNode.appendChild(newImg);
			}
			newImg.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+ orgImgPath +"',sizingMethod=scale)";

			thumbImg.width = 0;
			thumbImg.height = 0;

			sc.blur();	
		} else	{
			orgImgPath = roopfunc(orgImgPath, "\\", "/");
			thumbImg.src = orgImgPath;
		}
	}catch(e){ }

	return orgImgPath;

}

function roopfunc (s, findStr, newStr){
    var tmpStr = s;
    while(tmpStr.indexOf(findStr) != -1) tmpStr = tmpStr.replace(findStr, newStr);
    return tmpStr;
}

function funcUpdateProcCd(procCd)
{
    var talkMsgNo =  document.formTalk.talkMsgNo.value;
    var param = '&talkMsgNo='+talkMsgNo+'&talkMsgProcCd=' + procCd ;
    var res = callAjax("/talk/talkBenefitMsg.tmall?method=updateProcCd",param,"");

    if(res == "SUCCESS"){
        alert("요청 완료");
        document.location.reload();
    } else {
        alert("요청 실패");
        return;
    }
}

function funcUpdateDuplicatTalkMsgNo(){
    var f = document.formTalk;
    var talkMsgNo =  document.formTalk.talkMsgNo.value;
    var param = '&talkMsgNo='+talkMsgNo;
    if(f.exTalkMsgNoList.value.replace(/ /gi,"") != ""){
        var pattern = /[^\d]/igm;
        if(isNaN( pattern.test(f.exTalkMsgNoList.value) )){
            Ext.MessageBox.alert('알림', '혜택톡관리메시지번호는 숫자만 가능합니다.');
            return;
        }
        param += "&exTalkMsgNoList=" + f.exTalkMsgNoList.value;
    }else{
        alert("메시지번호를 입력해주세요.");
        return;
	}

    var res = callAjax("/talk/talkBenefitMsg.tmall?method=addExTalkMsgNo",param,"");

    if(res == "SUCCESS"){
        alert("요청 완료");
        document.location.reload();
    } else {
        alert("요청 실패");
        return;
    }
}

// 테스트발송
function funcSendTestMsg()
{
    var talkMsgNo =  document.formTalk.talkMsgNo.value;
    var param = '&talkMsgTmpltNo='+$("#targetTalkMsgTmpltNo").val();
    param = param + '&talkMsgNo='+talkMsgNo;
	var url = '/talk/talkBenefitMsg.tmall?method=getTestTargetList'+param;
	launchCenter("", "_upd_disp_obj_bnr_pop", 480, 600, "", url);
}

// 테스트발송 확인
function funcChkSendTestMsg()
{
    var talkMsgNo =  document.formTalk.talkMsgNo.value;
    var param = '&talkMsgNo='+talkMsgNo+'&talkMsgTestProcCd=02' ;
    var res = callAjax("/talk/talkBenefitMsg.tmall?method=updateTestProcCd",param,"");
    if(res == "SUCCESS"){
        alert("요청 완료");
        document.location.reload();
    } else {
        alert("요청 실패");
        return;
    }
}

function funcProc(){
	var talkMsgNo =  document.formTalk.talkMsgNo.value;
//	if( pushMsgNo != '0' ){
//		if( !confirm("푸시 알림내용을 변경 및 저장하시려면 '테스트 발송 확인'을 다시 진행하셔야 합니다.") ){
//			return false;
//		}
//	}
	var f = document.formTalk;
    var memNoListArea = "";
	// 데이터 체크
	if(f.talkMsgTitle.value == '')
	{
		alert("제목을 입력해주세요.");
		return false;
	}

    if(f.ardTopPushMsgCont.value.trim() == '')
    {
        alert("푸시 상단 메시지(안드로이드 버전)을 입력해주세요.");
        return false;
    }
	if(f.ardBtmPushMsgCont.value.trim() == '')
	{
		alert("푸시 하단 메시지(안드로이드 버전)을 입력해주세요.");
		return false;
	}
	else if(f.ardBtmPushMsgCont.value.trim().length > 50)
	{
		alert("푸시 하단 메시지(안드로이드 버전)을 50자 이내로 입력해주세요.");
		return false;
	}
	else if(f.iosPushMsgCont.value.trim() == '')
	{
		alert("푸시 IOS용 푸시 알림 내용을 입력해주세요.");
		return false;
	} 
	else if(f.iosPushMsgCont.value.trim().length > 50)
	{
		alert("푸시 알림 내용(IOS 버전) 내용을50자 이내로 입력해주세요.");
		return false;
	}
    var target = document.getElementById('messageDtlCont');
    if(f.appKdCd.value == "01" && target && target.value == "") {
        alert("추가 텍스트를 입력해주세요.");
        return false;
    }

    var tempLnkPageTyp = document.getElementById('lnkPageTyp');
    var tempLnkPageUrl = document.getElementById('lnkPageUrl');
    if(tempLnkPageTyp.value =="02" && tempLnkPageUrl && tempLnkPageUrl.value == "") {
        alert("연결 페이지를 입력해주세요.");
        return false;
    }

	if(f.targetExtrClfCd.value == "")
	{
		alert("대상 등록 조건을 선택해주세요.");
		return false;
	}

	if(f.targetExtrOpenCd.value == "" )
	{
		alert("푸시 오픈 여부를 선택해주세요.");
		return false;
	}

	if(f.targetExtrClfCd.value=="02")	// 회원번호 직접 입력 일 경우
	{
		if(f.memNoListArea.value.replace("/ /gi","") != ""){ // 다량의 상품번호를 입력하는 란에 상품번호가 있는 경우
			memNoListArea = f.memNoListArea.value + "{END}";
			memNoListArea = memNoListArea.replace("/\r\n\r\n/gi","\r\n");
			memNoListArea = memNoListArea.replace("/\r\n{END}/gi","");
			memNoListArea = memNoListArea.replace("/{END}/gi","");
		}
		if((memNoListArea == null || memNoListArea == "") ){
			alert("회원번호를 입력하세요.");
			return false;
		}
	}

	debugger;
	if($("input:radio[name=sendTyp]:checked").val() == '02'){
		f.sendStartDtStr.value = f.sYY.value + f.sMM.value + f.sDD.value + f.sHH.value + f.sMI.value;
	}


	f.action = "/talk/talkBenefitMsg.tmall?method=updateTalkPushMsg";
	f.target = "exec_frame";
	f.method = "post";
	f.submit();
}

function funcCancel(){
	if(confirm("이 창을 닫겠습니까?")==true){
		window.self.close();
	}
}


function blockSampleType01(){
    $("#talkImgSample_1").html('');
    $("#talkImgSample_2").html('');
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/block_top_cap(ad).png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/composite_text_02.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/img_500_500_sample1.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/detail_view_.png\" width=\"200px;\"/><br>");

    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/block_top_cap(ad)_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/composite_text_02_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/img_500_500_sample1.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/detail_view_f.png\" width=\"200px;\"/><br>");
}

function blockSampleType02(){
    $("#talkImgSample_1").html('');
    $("#talkImgSample_2").html('');
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/block_top_cap(ad).png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/composite_text_02.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/img_500_240_sample1.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/block_product_price_01.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/detail_view_.png\" width=\"200px;\"/><br>");

    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/block_top_cap(ad)_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/composite_text_02_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/img_500_240_sample1.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/block_product_price_01_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/detail_view_f.png\" width=\"200px;\"/><br>");
}

function blockSampleType03(){
    $("#talkImgSample_1").html('');
    $("#talkImgSample_2").html('');
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/block_top_cap(ad).png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/composite_text_02.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/img_500_240_sample1.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/block_coupon_text_01.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/detail_view_.png\" width=\"200px;\"/><br>");

    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/block_top_cap(ad)_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/composite_text_02_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/img_500_240_sample1.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/block_coupon_text_01_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/detail_view_f.png\" width=\"200px;\"/><br>");
}

function blockSampleType04(){
    $("#talkImgSample_1").html('');
    $("#talkImgSample_2").html('');
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/block_top_cap(ad).png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/composite_text_02.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/block_sub_text.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/detail_view_.png\" width=\"200px;\"/><br>");

    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/block_top_cap(ad)_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/composite_text_02_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/block_sub_text_s.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/detail_view_f.png\" width=\"200px;\"/><br>");
}

function blockSampleType05(){
    $("#talkImgSample_1").html('');
    $("#talkImgSample_2").html('');
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/block_top_cap(ad).png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/composite_text_02.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/block_product_price_01.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/detail_view_.png\" width=\"200px;\"/><br>");

    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/block_top_cap(ad)_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/composite_text_02_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/block_product_price_01_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/detail_view_f.png\" width=\"200px;\"/><br>");
}

function blockSampleType06(){
    $("#talkImgSample_1").html('');
    $("#talkImgSample_2").html('');
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/block_top_cap(ad).png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/composite_text_02.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/block_coupon_text_01.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_1").append("<img src=\"http://i.011st.com/ui_img/11talk/detail_view_.png\" width=\"200px;\"/><br>");

    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/block_top_cap(ad)_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/composite_text_02_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/block_coupon_text_01_f.png\" width=\"200px;\"/><br>");
    $("#talkImgSample_2").append("<img src=\"http://i.011st.com/ui_img/11talk/detail_view_f.png\" width=\"200px;\"/><br>");
}

function func_Block_Top_Cap(value){
    var json = value == undefined || value == '' ?
        {payload:{text1:'',sub_text1:''}} : JSON.parse(value.replace(/'/gi,"\""));

    var value1 = json.payload.text1 == undefined ? '' : json.payload.text1;
    var value2 = json.payload.sub_text1 == undefined ? '' : json.payload.sub_text1;
    return "<tr>\n" +
        "    <td>Block_Top_Cap</td>\n" +
        "    <td>\n" +
        "        <table class=\"border0table\">\n" +
        "            <tr><td>text1 : <input type=\"text\" name=\"block_Top_Cap_text1\" value=\""+value1+"\"></td></tr>\n" +
        "            <tr><td>sub_text1 : <input type=\"text\" name=\"block_Top_Cap_subtext1\" value=\""+value2+"\"></td></tr>\n" +
        "        </table>\n" +
        "    </td>\n" +
        "</tr>";
}

function func_Block_Bold_Text(value){
    var json = value == undefined || value == '' ?
        {payload:{text1:'',sub_text1:''}} : JSON.parse(value.replace(/'/gi,"\""));

    var value1 = json.payload.text1 == undefined ? '' : json.payload.text1;
    var value2 = json.payload.sub_text1 == undefined ? '' : json.payload.sub_text1;
    return "<tr>\n" +
        "    <td>Block_Bold_Text</td>\n" +
        "    <td>\n" +
        "        <table class=\"border0table\">\n" +
        "            <tr><td>text1 : <input type=\"text\" name=\"block_Bold_Text_text1\" value=\""+value1+"\"></td></tr>\n" +
        "            <tr><td>sub_text1 : <input type=\"text\" name=\"block_Bold_Text_sub_text1\" value=\""+value2+"\"></td></tr>\n" +
        "        </table>\n" +
        "    </td>\n" +
        "</tr>";
}

function func_Block_Img_500(value){
    var json = value == undefined || value == '' ?
        {payload:[{imgUrl1:''}]} : JSON.parse(value.replace(/'/gi,"\""));
    var arrays = json.payload;

    var values = ['','','','','',''];
    for( var i=0; i<arrays.length; i++ ){
        values[i] = arrays[i].imgUrl1;
    }
    return "<tr>\n" +
        "    <td>Block_Img_500</td>\n" +
        "    <td>\n" +
        "        <table class=\"border0table\">\n" +
        "            <tr><td>imgUrl1 : <input type=\"text\" name=\"block_Img_500_imgUrl1\" value=\""+values[0]+"\"></td></tr>\n" +
        "            <tr><td>imgUrl1 : <input type=\"text\" name=\"block_Img_500_imgUrl1\" value=\""+values[1]+"\"></td></tr>\n" +
        "            <tr><td>imgUrl1 : <input type=\"text\" name=\"block_Img_500_imgUrl1\" value=\""+values[2]+"\"></td></tr>\n" +
        "            <tr><td>imgUrl1 : <input type=\"text\" name=\"block_Img_500_imgUrl1\" value=\""+values[3]+"\"></td></tr>\n" +
        "            <tr><td>imgUrl1 : <input type=\"text\" name=\"block_Img_500_imgUrl1\" value=\""+values[4]+"\"></td></tr>\n" +
        "        </table>\n" +
        "    </td>\n" +
        "</tr>";
}

function func_Block_Img_240(value){
    var json = value == undefined || value == '' ?
        {payload:{imgUrl1:''}} : JSON.parse(value.replace(/'/gi,"\""));

    var value1 = json.payload.imgUrl1 == undefined ? '' : json.payload.imgUrl1;
    return "<tr>\n" +
        "    <td>Block_Img_240</td>\n" +
        "    <td>\n" +
        "        <table class=\"border0table\">\n" +
        "            <tr><td>imgUrl1 : <input type=\"text\" name=\"block_Img_240_imgUrl1\" value=\""+value1+"\"></td></tr>\n" +
        "        </table>\n" +
        "    </td>\n" +
        "</tr>";
}

function func_Block_Sub_Text(value){
    var json = value == undefined || value == '' ?
        {payload:{text1:'',sub_text1:''}} : JSON.parse(value.replace(/'/gi,"\""));

    var value1 = json.payload.text1 == undefined ? '' : json.payload.text1;
    var value2 = json.payload.sub_text1 == undefined ? '' : json.payload.sub_text1;

    var selected1 = value2 == 'left' ?  'selected' : '';
    var selected2 = value2 == 'center' ?  'selected' : '';
    return "<tr>\n" +
        "    <td>Block_Sub_Text</td>\n" +
        "    <td>\n" +
        "        <table class=\"border0table\">\n" +
        "            <tr><td>text1 : <input type=\"text\" name=\"block_Sub_Text_text1\" value=\""+value1+"\"></td></tr>\n" +
        "            <tr><td>align : <select name=\"block_Sub_Text_sub_text1\">\n" +
        "                                <option value=\"left\" "+selected1+">left</option>\n" +
        "                                <option value=\"center\" "+selected2+">center</option>\n" +
        "                            </select>\n" +
        "            </td></tr>\n" +
        "        </table>\n" +
        "    </td>\n" +
        "</tr>";
}

function func_Block_Btn_View(value){
    var json = value == undefined || value == '' ?
        {payload:{text1:'',linkUrl1:{mobile:'',web:''}}} : JSON.parse(value.replace(/'/gi,"\""));

    var value1 = json.payload.text1 == undefined ? '' : json.payload.text1;
    json.payload.linkUrl1 = json.payload.linkUrl1 == undefined ? {mobile:'',web:''} : json.payload.linkUrl1;
    var value2 = json.payload.linkUrl1.mobile == undefined ? '' : json.payload.linkUrl1.mobile;
    var value3 = json.payload.linkUrl1.web == undefined ? '' : json.payload.linkUrl1.web;
    return "<tr>\n" +
        "    <td>Block_Btn_View</td>\n" +
        "    <td>\n" +
        "        <table class=\"border0table\">\n" +
        "            <tr>\n" +
        "                <td>text1 : <input type=\"text\" name=\"block_Btn_View_text1\" value=\""+value1+"\"></td>\n" +
        "            </tr>\n" +
        "            <tr>\n" +
        "                <td>mobile : <input type=\"text\" name=\"block_Btn_View_linkUrl1_mobile\" value=\""+value2+"\"></td>\n" +
        "                <td>web : <input type=\"text\" name=\"block_Btn_View_linkUrl1_web\" value=\""+value3+"\"></td>\n" +
        "            </tr>\n" +
        "        </table>\n" +
        "    </td>\n" +
        "</tr>";
}

function func_Block_Product_Price(value){
    var json = value == undefined || value == '' ?
        {payload:[{imgUrl1:'',text1:'',price1:'',priceUnit1:'',linkUrl1:{mobile:'',web:''}}]}
        : JSON.parse(value.replace(/'/gi,"\""));

    var html = '';
    for( var i=0; i<json.payload.length; i++ ){
        var value1 = json.payload[i].imgUrl1 == undefined ? '' : json.payload[i].imgUrl1;
        var value2 = json.payload[i].text1 == undefined ? '' : json.payload[i].text1;
        var value3 = json.payload[i].price1 == undefined ? '' : json.payload[i].price1;
        var value4 = json.payload[i].priceUnit1 == undefined ? '' : json.payload[i].priceUnit1;
        var value5 = json.payload[i].linkUrl1.mobile == undefined ? '' : json.payload[i].linkUrl1.mobile;
        var value6 = json.payload[i].linkUrl1.web == undefined ? '' : json.payload[i].linkUrl1.web;

        if( i == 0 ){
            html = "<tr class=\"blockProductPriceChecker\">\n" +
                "    <td>\n" +
                "        Block_Product_Price\n" +
                "        <ul id=\"btnA\" class=\"float\">\n" +
                "            <li><a href=\"#\" id=\"add\">추가</a></li>\n" +
                "        </ul>\n" +
                "    </td>\n" +
                "    <td>\n" +
                "        <table class=\"border0table\">\n" +
                "            <tr><td>imgUrl1 : <input type=\"text\" name=\"block_Product_Price_imgUrl1\" value=\""+value1+"\"></td></tr>\n" +
                "            <tr><td>text1 : <input type=\"text\" name=\"block_Product_Price_text1\" value=\""+value2+"\"></td></tr>\n" +
                "            <tr><td>price1 : <input type=\"text\" name=\"block_Product_Price_price1\" value=\""+value3+"\"></td></tr>\n" +
                "            <tr><td>priceUnit1 : <input type=\"text\" name=\"block_Product_Price_priceUnit1\" value=\""+value4+"\"></td></tr>\n" +
                "            <tr>\n" +
                "                <td>mobile : <input type=\"text\" name=\"block_Product_Price_linkUrl1_mobile\" value=\""+value5+"\"></td>\n" +
                "                <td>web : <input type=\"text\" name=\"block_Product_Price_linkUrl1_web\" value=\""+value6+"\"></td>\n" +
                "            </tr>\n" +
                "        </table>\n" +
                "    </td>\n" +
                "</tr>";
        }else{
            html = html + func_Block_Product_Price_add(value1, value2, value3, value4, value5, value6);
        }

    }
    return html;
}

function func_Block_Product_Price_add(value1, value2, value3, value4, value5, value6){
    value1 = value1 == undefined ? '' : value1;
    value2 = value2 == undefined ? '' : value2;
    value3 = value3 == undefined ? '' : value3;
    value4 = value4 == undefined ? '' : value4;
    value5 = value5 == undefined ? '' : value5;
    value6 = value6 == undefined ? '' : value6;
    return "<tr class=\"blockProductPriceChecker\">\n" +
        "    <td>\n" +
        "        Block_Product_Price\n" +
        "        <ul id=\"btnA\" class=\"float\">\n" +
        "            <li><a href=\"#\" id=\"add\">추가</a></li>\n" +
        "            <li><a href=\"#\" id=\"remove\">삭제</a></li>\n" +
        "        </ul>\n" +
        "    </td>\n" +
        "    <td>\n" +
        "        <table class=\"border0table\">\n" +
        "            <tr><td>imgUrl1 : <input type=\"text\" name=\"block_Product_Price_imgUrl1\" value=\""+value1+"\"></td></tr>\n" +
        "            <tr><td>text1 : <input type=\"text\" name=\"block_Product_Price_text1\" value=\""+value2+"\"></td></tr>\n" +
        "            <tr><td>price1 : <input type=\"text\" name=\"block_Product_Price_price1\" value=\""+value3+"\"></td></tr>\n" +
        "            <tr><td>priceUnit1 : <input type=\"text\" name=\"block_Product_Price_priceUnit1\" value=\""+value4+"\"></td></tr>\n" +
        "            <tr>\n" +
        "                <td>mobile : <input type=\"text\" name=\"block_Product_Price_linkUrl1_mobile\" value=\""+value5+"\"></td>\n" +
        "                <td>web : <input type=\"text\" name=\"block_Product_Price_linkUrl1_web\" value=\""+value6+"\"></td>\n" +
        "            </tr>\n" +
        "        </table>\n" +
        "    </td>\n" +
        "</tr>";
}

function func_Block_Coupon_Text(value){
    var json = value == undefined || value == '' ?
        {payload:[{couponNo:'',couponText:'',title1:'',sub_text1:'',sub_text2:''}]}
        : JSON.parse(value.replace(/'/gi,"\""));

    var html = '';
    for( var i=0; i<json.payload.length; i++ ) {
        var value1 = json.payload[i].couponText == undefined ? '' : json.payload[i].couponText;
        var value2 = json.payload[i].title1 == undefined ? '' : json.payload[i].title1;
        var value3 = json.payload[i].sub_text1 == undefined ? '' : json.payload[i].sub_text1;
        var value4 = json.payload[i].sub_text2 == undefined ? '' : json.payload[i].sub_text2;
        var value5 = json.payload[i].couponNo == undefined ? '' : json.payload[i].couponNo;

        if (i == 0) {
            html = "<tr class=\"blockCouponTextChecker\">\n" +
                "    <td>\n" +
                "        Block_Coupon_Text\n" +
                "        <ul id=\"btnA\" class=\"float\">\n" +
                "            <li><a href=\"#\" id=\"add\">추가</a></li>\n" +
                "        </ul>\n" +
                "    </td>\n" +
                "    <td>\n" +
                "        <table class=\"border0table\">\n" +
                "            <tr><td>couponText : <input type=\"text\" name=\"block_Coupon_Text_couponText\" value=\"" + value1 + "\"></td></tr>\n" +
                "            <tr><td>title1 : <input type=\"text\" name=\"block_Coupon_Text_title1\" value=\"" + value2 + "\"></td></tr>\n" +
                "            <tr><td>sub_text1 : <input type=\"text\" name=\"block_Coupon_Text_sub_text1\" value=\"" + value3 + "\"></td></tr>\n" +
                "            <tr><td>sub_text2 : <input type=\"text\" name=\"block_Coupon_Text_sub_text2\" value=\"" + value4 + "\"></td></tr>\n" +
                "            <tr><td>couponNo : <input type=\"text\" name=\"block_Coupon_Text_couponNo\" value=\"" + value5 + "\"></td></tr>\n" +
                "        </table>\n" +
                "    </td>\n" +
                "</tr>";
        }else{
            func_Block_Coupon_Text_add(value1, value2, value3, value4, value5);
        }
    }
    return html;

}

function func_Block_Coupon_Text_add(value1, value2, value3, value4, value5){
    value1 = value1 == undefined ? '' : value1;
    value2 = value2 == undefined ? '' : value2;
    value3 = value3 == undefined ? '' : value3;
    value4 = value4 == undefined ? '' : value4;
    value5 = value5 == undefined ? '' : value5;
    return "<tr class=\"blockCouponTextChecker\">\n" +
        "    <td>\n" +
        "        Block_Coupon_Text\n" +
        "        <ul id=\"btnA\" class=\"float\">\n" +
        "            <li><a href=\"#\" id=\"add\">추가</a></li>\n" +
        "            <li><a href=\"#\" id=\"remove\">삭제</a></li>\n" +
        "        </ul>\n" +
        "    </td>\n" +
        "    <td>\n" +
        "        <table class=\"border0table\">\n" +
        "            <tr><td>couponText : <input type=\"text\" name=\"block_Coupon_Text_couponText\" value=\""+value1+"\"></td></tr>\n" +
        "            <tr><td>title1 : <input type=\"text\" name=\"block_Coupon_Text_title1\" value=\""+value2+"\"></td></tr>\n" +
        "            <tr><td>sub_text1 : <input type=\"text\" name=\"block_Coupon_Text_sub_text1\" value=\""+value3+"\"></td></tr>\n" +
        "            <tr><td>sub_text2 : <input type=\"text\" name=\"block_Coupon_Text_sub_text2\" value=\""+value4+"\"></td></tr>\n" +
        "            <tr><td>couponNo : <input type=\"text\" name=\"block_Coupon_Text_couponNo\" value=\""+value5+"\"></td></tr>\n" +
        "        </table>\n" +
        "    </td>\n" +
        "</tr>";
}

function funcTalkDisp(){
    var yn = $("input:radio[name=talkMsgDispYn]:checked").val();
    if( yn == undefined || yn == 'Y' ){
        $("#talkDisp1").show();
        $("#talkDisp2").show();
        $("#talkDisp3").show();
        $("#talkDisp4").show();
        return;
    }
    if( yn == 'N' ){
        $("#talkDisp1").hide();
        $("#talkDisp2").hide();
        $("#talkDisp3").hide();
        $("#talkDisp4").hide();
        return;
    }
}


</script>
</head>
<body>

<div id="width_fix" style="padding-left:20px">
	<form name="formTalk" method="post" enctype="multipart/form-data" action="PushTargetTmplt.tmall?method=updateTargetTmpl">
		<div id="Header_nav">
				<em>알림톡 등록/수정</em>
			<ul id="navi">
				<li><strong>Home&nbsp;</strong>&gt;&nbsp;모바일관리&nbsp;&gt;알림톡관리&nbsp;&gt;
					<label>알림톡 등록/수정</label>
				</li>
			</ul>
		</div>
		<div class="sMargin"></div>

		<div class="shadow">
            
            
            
			<h1>알림톡 등록</h1>
			<div class="ssMargin"></div>
				<table class="contain border1set width100">
				<colgroup id="tableContens_4c">
					<col id="tc1_4c">
					<col id="tc2_4c">
				</colgroup>

				<tr>
					<th>* 제목</th>
					<td>
						<div class="inputD">
							<input type="text" name="talkMsgTitle" style="width:400px" value=""  maxlength="100">
						</div>
					</td>
				</tr>
				<tr>
					<th>* 대상 APP 선택</th>
					<td>
						<select name="appKdCd" >
                            <option value="01"  >11번가앱</option>
                            <option value="02"  >도서1번가앱</option>
                            <option value="03"  >쇼킹딜앱</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>연결 페이지(*구 알림푸시*)</th>
					<td>
						<select name="lnkPageTyp" id="lnkPageTyp" >
                            <option value="01" >알리미함 + URL</option>
                            <option value="02" >URL</option>
                        </select>
						<input type="text" name="lnkPageUrl" id="lnkPageUrl" style="width:400px" value=""  maxlength="200">
					</td>
				</tr>
				<tr>
					<th>* 푸시 상단 메시지(안드로이드 버전)</th>
					<td>
						<div class="inputD">
							<input type="text" name="ardTopPushMsgCont" style="width:400px" value=""  maxlength="100" >
						</div>
					</td>
				</tr>
				<tr>
					<th>* 푸시 하단 메시지(안드로이드 버전)</th>
					<td>
						<input type="text" name="ardBtmPushMsgCont" style="width:400px" value="" maxlength="100" > <span>50자 이내 </span>
					</td>
				</tr>
				<tr>
					<th>* 푸시 알림 내용(IOS 버전)</th>
					<td>
						<textarea name="iosPushMsgCont" id="iosPushMsgCont" cols="50"  rows="2" style="width:400px" ></textarea>
						<span>50자 이내 </span>
					</td>
				</tr>
                <tr>
                    <th>추가 텍스트</th>
                    <td>
                        <textarea name="messageDtlCont" id="messageDtlCont" cols="45" rows="5" style="width:400px" ></textarea>
                    </td>
                </tr>
                </table>
				※ 아래 배너 기능은 쇼킹딜 및 도서11번가에서 적용 되지 않을 수 있습니다.
				<table class="contain border1set width100">
				<colgroup id="tableContens_4c">
					<col id="tc1_4c">
					<col id="tc2_4c">
				</colgroup>
                <tr>
                    <th>알리미 타임라인에 노출</th>
                    <td>
						<span style="width:130px">
                            <input type="radio" name="tmlnDispYn" value="Y"    >노출함
                        </span>
						<span style="width:130px">
                            <input type="radio" name="tmlnDispYn" value="N"  >노출 안함
                        </span>
                    </td>
                </tr>
				<tr>
					<th>알림톡 노출</th>
					<td>
						<span style="width:130px">
                            <input type="radio" name="talkMsgDispYn" onchange="funcTalkDisp()" value="Y"   >노출함
                        </span>
						<span style="width:130px">
                            <input type="radio" name="talkMsgDispYn" onchange="funcTalkDisp()" value="N"   >노출 안함
                        </span>
					</td>
				</tr>
                <tr id="talkDisp1">
                    <th>알림톡 방목록 텍스트</th>
                    <td>
                        <div class="inputD">
                            <input type="text" name="talkMsgSummary" style="width:400px" value=""  maxlength="100" >
                        </div>
                    </td>
                </tr>
				<tr id="talkDisp2">
					<th>알림톡 타입</th>
					<td>
						<span style="width:130px">
                            <input type="radio" name="talkMsgTmpltNo" value="001"  onchange="blockSetting('001')"
                                   checked >타입1
                        </span>
						<span style="width:130px">
                            <input type="radio" name="talkMsgTmpltNo" value="002"  onchange="blockSetting('002')" >타입2
                        </span>
						<span style="width:130px">
                            <input type="radio" name="talkMsgTmpltNo" value="003"  onchange="blockSetting('003')" >타입3
                        </span>
						<span style="width:130px">
                            <input type="radio" name="talkMsgTmpltNo" value="004"  onchange="blockSetting('004')" >타입4
                        </span>
						<span style="width:130px">
                            <input type="radio" name="talkMsgTmpltNo" value="005"  onchange="blockSetting('005')" >타입5
                        </span>
						<span style="width:130px">
                            <input type="radio" name="talkMsgTmpltNo" value="006"  onchange="blockSetting('006')" >타입6
                        </span>
					</td>
				</tr>
				<tr id="talkDisp3">
					<th>알림톡 샘플</th>
					<td>
                        <table style="border: 0px;">
                            <tr>
                                <td id="talkImgSample_1"></td>
                                <td id="talkImgSample_2"></td>
                            </tr>
                        </table>
					</td>
				</tr>
                <tr id="talkDisp4">
                    <th>알림톡 데이터</th>
                    <td>
                        <table class="border1table width100" id="blockTable">
                        </table>
                    </td>
                </tr>
				<tr style="height:80px">
					<th>배너 이미지</th>
					<td>
						<div class="inBox_TDZ">
							<input type="file" onchange="setImgUploadFile('bnnrImgUrl', 'bnnrImgUrlFile'); funcBasicBannerOpen('bnnrImgUrlFile', 'bnnrImgUrl', 'imgBnnrImgUrl');" hidefocus="this.blur()" name="bnnrImgUrlFile" id="bnnrImgUrlFile" class="File_SrhHideBtn" >
							<div class="File_SrhInput">
								<input type="text" style="width:200px;" name="bnnrImgUrl"  id="bnnrImgUrl" value="" class="InimgURL">
								<ul id="btnA">
									<li>
										<a>찾아보기</a>
									</li>
								</ul>※ 이미지 등록시 푸시알림 내용 및 썸네일 노출 안됨. <br/>(300KB이하 이미지만 등록 가능)
							</div>
							<div class="floatR" style="margin-right:10px;">
								<img name='imgBnnrImgUrl' id='imgBnnrImgUrl' height='60' width='60' src='' value=''></li>
								
							</div>
						</div>
					</td>
				</tr>
					<th>발송시간</th>
					<td>
						<span style="width:130px">
                            <input type="radio" name="sendTyp" value="02"  onclick="dispArea('sendDataArea', true);"
                                   checked
                            >예약발송
                        </span>
                        <span id="sendDataArea" >
                            <select name="sYY" >
                                <option value="2019" selected >2019 </option>
                                <option value="2020">2020 </option>
                            </select>년
                            <select name="sMM" >
                                
                                    
                                    <option value="01">01</option>
                                
                                    
                                    <option value="02">02</option>
                                
                                    
                                    <option value="03">03</option>
                                
                                    
                                    <option value="04">04</option>
                                
                                    
                                    <option value="05">05</option>
                                
                                    
                                    <option value="06">06</option>
                                
                                    
                                    <option value="07">07</option>
                                
                                    
                                    <option value="08">08</option>
                                
                                    
                                    <option value="09">09</option>
                                
                                    
                                    <option value="10">10</option>
                                
                                    
                                    <option value="11">11</option>
                                
                                    
                                    <option value="12">12</option>
                                
                            </select>월
                            <select name="sDD" >
                                
                                    
                                    <option value="01">01</option>
                                
                                    
                                    <option value="02">02</option>
                                
                                    
                                    <option value="03">03</option>
                                
                                    
                                    <option value="04">04</option>
                                
                                    
                                    <option value="05">05</option>
                                
                                    
                                    <option value="06">06</option>
                                
                                    
                                    <option value="07">07</option>
                                
                                    
                                    <option value="08">08</option>
                                
                                    
                                    <option value="09">09</option>
                                
                                    
                                    <option value="10">10</option>
                                
                                    
                                    <option value="11">11</option>
                                
                                    
                                    <option value="12">12</option>
                                
                                    
                                    <option value="13">13</option>
                                
                                    
                                    <option value="14">14</option>
                                
                                    
                                    <option value="15">15</option>
                                
                                    
                                    <option value="16">16</option>
                                
                                    
                                    <option value="17">17</option>
                                
                                    
                                    <option value="18">18</option>
                                
                                    
                                    <option value="19">19</option>
                                
                                    
                                    <option value="20">20</option>
                                
                                    
                                    <option value="21">21</option>
                                
                                    
                                    <option value="22">22</option>
                                
                                    
                                    <option value="23">23</option>
                                
                                    
                                    <option value="24">24</option>
                                
                                    
                                    <option value="25">25</option>
                                
                                    
                                    <option value="26">26</option>
                                
                                    
                                    <option value="27">27</option>
                                
                                    
                                    <option value="28">28</option>
                                
                                    
                                    <option value="29">29</option>
                                
                                    
                                    <option value="30">30</option>
                                
                                    
                                    <option value="31">31</option>
                                
                            </select>일
                            <select name="sHH" >
                                
                                    
                                    <option value="01">01</option>
                                
                                    
                                    <option value="02">02</option>
                                
                                    
                                    <option value="03">03</option>
                                
                                    
                                    <option value="04">04</option>
                                
                                    
                                    <option value="05">05</option>
                                
                                    
                                    <option value="06">06</option>
                                
                                    
                                    <option value="07">07</option>
                                
                                    
                                    <option value="08">08</option>
                                
                                    
                                    <option value="09">09</option>
                                
                                    
                                    <option value="10">10</option>
                                
                                    
                                    <option value="11">11</option>
                                
                                    
                                    <option value="12">12</option>
                                
                                    
                                    <option value="13">13</option>
                                
                                    
                                    <option value="14">14</option>
                                
                                    
                                    <option value="15">15</option>
                                
                                    
                                    <option value="16">16</option>
                                
                                    
                                    <option value="17">17</option>
                                
                                    
                                    <option value="18">18</option>
                                
                                    
                                    <option value="19">19</option>
                                
                                    
                                    <option value="20">20</option>
                                
                                    
                                    <option value="21">21</option>
                                
                                    
                                    <option value="22">22</option>
                                
                                    
                                    <option value="23">23</option>
                                
                            </select>시
                            <select name="sMI" >
                                
                                    
                                    <option value="00">00</option>
                                
                                    
                                    <option value="01">01</option>
                                
                                    
                                    <option value="02">02</option>
                                
                                    
                                    <option value="03">03</option>
                                
                                    
                                    <option value="04">04</option>
                                
                                    
                                    <option value="05">05</option>
                                
                                    
                                    <option value="06">06</option>
                                
                                    
                                    <option value="07">07</option>
                                
                                    
                                    <option value="08">08</option>
                                
                                    
                                    <option value="09">09</option>
                                
                                    
                                    <option value="10">10</option>
                                
                                    
                                    <option value="11">11</option>
                                
                                    
                                    <option value="12">12</option>
                                
                                    
                                    <option value="13">13</option>
                                
                                    
                                    <option value="14">14</option>
                                
                                    
                                    <option value="15">15</option>
                                
                                    
                                    <option value="16">16</option>
                                
                                    
                                    <option value="17">17</option>
                                
                                    
                                    <option value="18">18</option>
                                
                                    
                                    <option value="19">19</option>
                                
                                    
                                    <option value="20">20</option>
                                
                                    
                                    <option value="21">21</option>
                                
                                    
                                    <option value="22">22</option>
                                
                                    
                                    <option value="23">23</option>
                                
                                    
                                    <option value="24">24</option>
                                
                                    
                                    <option value="25">25</option>
                                
                                    
                                    <option value="26">26</option>
                                
                                    
                                    <option value="27">27</option>
                                
                                    
                                    <option value="28">28</option>
                                
                                    
                                    <option value="29">29</option>
                                
                                    
                                    <option value="30">30</option>
                                
                                    
                                    <option value="31">31</option>
                                
                                    
                                    <option value="32">32</option>
                                
                                    
                                    <option value="33">33</option>
                                
                                    
                                    <option value="34">34</option>
                                
                                    
                                    <option value="35">35</option>
                                
                                    
                                    <option value="36">36</option>
                                
                                    
                                    <option value="37">37</option>
                                
                                    
                                    <option value="38">38</option>
                                
                                    
                                    <option value="39">39</option>
                                
                                    
                                    <option value="40">40</option>
                                
                                    
                                    <option value="41">41</option>
                                
                                    
                                    <option value="42">42</option>
                                
                                    
                                    <option value="43">43</option>
                                
                                    
                                    <option value="44">44</option>
                                
                                    
                                    <option value="45">45</option>
                                
                                    
                                    <option value="46">46</option>
                                
                                    
                                    <option value="47">47</option>
                                
                                    
                                    <option value="48">48</option>
                                
                                    
                                    <option value="49">49</option>
                                
                                    
                                    <option value="50">50</option>
                                
                                    
                                    <option value="51">51</option>
                                
                                    
                                    <option value="52">52</option>
                                
                                    
                                    <option value="53">53</option>
                                
                                    
                                    <option value="54">54</option>
                                
                                    
                                    <option value="55">55</option>
                                
                                    
                                    <option value="56">56</option>
                                
                                    
                                    <option value="57">57</option>
                                
                                    
                                    <option value="58">58</option>
                                
                                    
                                    <option value="59">59</option>
                                
                            
                                
                            
                            </select>분
                        </span>
                        <span style="width:130px">
                            <input type="radio" name="sendTyp" value="01"  onclick="dispArea('sendDataArea', false);"
                                   >즉시발송
                        </span>
					</td>
				</tr>
			</table>
			<div class="ssMargin"></div>
		</div>
		<div class="sMargin"></div>

		<div class="shadow">
			<table class="contain border1set width100">
				<colgroup id="tableContens_4c">
					<col id="tc1_4c">
					<col id="tc2_4c">
				</colgroup>
				<tr>
					<th>* 푸시 오픈 여부(최근 6개월) </th><!-- MO026 -->
					<td>
                        <span style="width:130px"><input type="radio" name="targetExtrOpenCd" value="00"   >전체</span>
                        <span style="width:130px"><input type="radio" name="targetExtrOpenCd" value="06"   >오픈 단말</span>
                        <button type="button" class="icon_question iq1">더보기</button>
                        <div class="layer_def_a have_close" style="width:410px;"><!-- 레이어 열림 selected 클래스 추가 -->
                            <div class="layer_conts">
                                <p><b>최근 6개월 내 수신된 푸시를 터치하여 오픈한 이력이 있는 단말.</b></p>
                                <p><b>최근 1달 이내 11번가 앱을 설치한 단말.</b></p>
                                <button type="button" class="btn_layclose">레이어 닫기</button>
                            </div>
                        </div>
                        <span style="width:130px"><input type="radio" name="targetExtrOpenCd" value="07"   >미오픈 단말</span>
                        <button type="button" class="icon_question iq1">더보기</button>
                        <div class="layer_def_a have_close" style="width:410px;"><!-- 레이어 열림 selected 클래스 추가 -->
                            <div class="layer_conts">
                                <p><b>최근 6개월 내 수신된 푸시를 터치하여 오픈한 이력이 없는 단말.</b></p>
                                <p><b>최근 1달 이내 11번가 앱을 설치한 단말.</b></p>
                                <button type="button" class="btn_layclose">레이어 닫기</button>
                            </div>
                        </div>
					</td>
				</tr><span style="color: red"></span>
				<tr>
					<th>* 추가 조건</th><!-- MO012 -->
					<td>
						<span style="width:130px;height:30px">
							<input type="checkbox" name="targetExtrEtcCdList" value="01"  >활성단말
							<button type="button" class="icon_question iq1">활성단말</button>
							<div class="layer_def_a have_close" style="width:410px;"><!-- 레이어 열림 selected 클래스 추가 -->
							<div class="layer_conts">
								<p><b>최근 1개월 내 푸시 수신동의값 변경한 단말</b></p>
							</div>
							<button type="button" class="btn_layclose">레이어 닫기</button>
							</div>
						</span>
					</td>
				</tr>
				<tr>
					<th>* 대상 등록 조건 선택</th><!-- MO012 -->
					<td>
                        <span style="width:130px">
                            <input type="radio" name="targetExtrClfCd" value="03"  onclick="changeTmplType('03');"
                                   >자동로그인 회원
                            <input type="radio" name="targetExtrClfCd" value="04"  onclick="changeTmplType('04');"
                                   >비자동로그인 회원
                            <input type="radio" name="targetExtrClfCd" value="01"  onclick="changeTmplType('01');"
                                   >조건 등록
                            <input type="radio" name="targetExtrClfCd" value="02"  onclick="changeTmplType('02');"
                                   >회원번호 등록
                        </span>
					</td>
				</tr>
			</table>
		</div>

        <div class="shadow" id="tmplType01"
             
             style="display:none;"
        >
			<h1>조건등록</h1>
			<table class="contain border1set width100">
				<colgroup id="tableContens_4c">
					<col id="tc1_4c">
					<col id="tc2_4c">
				</colgroup>

				<tr>
					<th>단말 OS</th>
					<td>
						<span style="width:130px"><input type="radio" name="targetOsTypCd" value="00" 
                                                         checked>전체</span>
						<span style="width:130px"><input type="radio" name="targetOsTypCd" value="02" 
                                                         >Android</span>
						<span style="width:130px"><input type="radio" name="targetOsTypCd" value="01" 
                                                         >iOS</span>
					</td>
				</tr>
				<tr>
					<th>성별</th>
					<td>
						<span style="width:130px"><input type="radio" name="targetSexCd" value="A" 
                                                         checked>전체</span>
						<span style="width:130px"><input type="radio" name="targetSexCd" value="M" 
                                                         >남</span>
						<span style="width:130px"><input type="radio" name="targetSexCd" value="F" 
                                                         >여</span>
					</td>
				</tr>
				<tr style="height:50px">
					<th>나이</th>
					<td>
						<span style="width:130px">
                            <input type="radio" name="targetAge" value="A" onclick="dispArea('setAgeArea', false);" 
                                   checked>전체
                        </span>
						    <input type="radio" name="targetAge" value="" onclick="dispArea('setAgeArea', true);" 
                                >연령대 지정
						<span id="setAgeArea">
							<input type="text" name="targetBgnAge" style="width:50px"  value="" maxlength="3"> 세 ~
							<input type="text" name="targetEndAge" style="width:50px"  value="" maxlength="3"> 세 까지의 회원만을 발송대상에 포함합니다.
						</span>
					</td>
				</tr>
				<tr style="height:50px">
					<th>회원등급</th>
					<td>
                        
                            
                                
                            
                            
                        
						<span style="width:130px">
                            <input type="radio" name="tempTargetGrdCd" value="A" onclick="dispArea('memGrdArea', false);" 
                                   checked>전체
                        </span>
						<input type="radio" name="tempTargetGrdCd" value="part" onclick="dispArea('memGrdArea', true);" 
                               >설정
						<span id="memGrdArea">
							<span style="width:100px"><input type="checkbox" name="targetGrdCd1ChkYn" value="Y" 
                                                             >VVIP</span>
							<span style="width:100px"><input type="checkbox" name="targetGrdCd2ChkYn" value="Y" 
                                                             >VIP</span>
							<span style="width:100px"><input type="checkbox" name="targetGrdCd3ChkYn" value="Y" 
                                                             >FAMILY</span>
							<span style="width:100px"><input type="checkbox" name="targetGrdCd5ChkYn" value="Y" 
                                                             >WELCOME</span>
						</span>
					</td>
				</tr>
				<tr style="height:50px">
					<th>구매실적</th>
					<td>
						<span style="width:130px">
                            <input type="radio" name="targetBuyCustSvcCdSetYn" value="N" onclick="dispArea('buyInfoArea', false);" 
                                   checked>설정안함
                        </span>
						<input type="radio" name="targetBuyCustSvcCdSetYn" value="Y" onclick="dispArea('buyInfoArea', true);" 
                               >설정
						<span id="buyInfoArea">
							<select name="targetBuyCustSvcCd" stype="width:200px" >
                                <option value="00" >전체</option>
                                <option value="01" >PC웹</option>
                                <option value="02" >모바일웹</option>
							</select>
							에서
							<select name="targetBuyCustTerm" stype="width:200px" >
								<option value="3" >3개월내</option>	<!-- insType01 -->
								<option value="6" >6개월내</option><!-- insType02 -->
								<option value="12" >12개월내</option>	<!-- insType03 -->
							</select>
							구매고객을 발송 대상에 포함합니다.
						</span>
					</td>
				</tr>
				<tr style="height:50px">
					<th>휴면고객</th>
					<td>
						<span style="width:130px">
                            <input type="radio" name="targetDrmnCustSvcSetYn" value="N" onclick="dispArea('unBuyInfoArea', false);" 
                                   checked>설정안함
                        </span>
						<input type="radio" name="targetDrmnCustSvcSetYn" value="Y" onclick="dispArea('unBuyInfoArea', true);" 
                               >설정
						<span id="unBuyInfoArea">
							<select name="targetDrmnCustSvcCd" stype="width:200px" >
                                <option value="00" >전체</option>
                                <option value="01" >PC웹</option>
                                <option value="02" >모바일웹</option>
							</select>
							에서
							<select name="targetDrmnCustTerm" stype="width:200px" >
								<option value="3" >3개월내</option>	<!-- insType01 -->
								<option value="6" >6개월내</option><!-- insType02 -->
								<option value="12" >12개월내</option>	<!-- insType03 -->
							</select>
							구매 실적이 없는 고객을 발송 대상에 포함합니다.
						</span>
					</td>
				</tr>
				<tr>
					<th>SK임직원제외</th>
					<td>
						<input type="checkbox" name="skEmpYn" value="Y"  >임직원을 발송 대상에서 제외합니다.
					</td>
				</tr>
			</table>
			<div class="ssMargin"></div>
		</div>
		<div class="shadow" id="tmplType02" style="display:none;">
			<h1>회원번호등록</h1>
			<table class="contain border1set width100">
				<colgroup id="tableContens_4c">
					<col id="tc1_4c">
					<col id="tc2_4c">
				</colgroup>
				<tr>
					<th>직접입력</th>
					<td>
						<textarea name="memNoListArea" rows="50" cols="20" style="width:200px;height:100px"  ></textarea>
						회원번호의 구분은 "줄바꿈" 입니다.( 최초 저장시에만 입력가능 )
					</td>
				</tr>
			</table>
			<div class="ssMargin"></div>
		</div>


        









		<div class="sMargin"></div>
		<div style="position:relative; margin-left:45%;">
			<ul id="btnYui">
                
                    <li><a href="javascript:;" onClick="funcProc();">저장</a></li>
                
				<li><a href="javascript:;" onClick="funcCancel();">닫기</a></li>
			</ul>
		</div>

        <input type="hidden" name="talkMsgNo"  value=""/>
		<input type="hidden" name="sendStartDtStr"  value="201903181730"/>
		
		<input type="hidden" name="appXsiteCd"  value=""/>
        <input type="hidden" name="targetExtrClfCdHist" value=""/>

        <input type="hidden" id="block_1" value=""/>
        <input type="hidden" id="block_2" value=""/>
        <input type="hidden" id="block_3" value=""/>
        <input type="hidden" id="block_4" value=""/>
        <input type="hidden" id="block_5" value=""/>
	</form>
</div>
<!-- 풋터 수정:2008.02.12-->
<!-- Footer -->
<script type="text/javascript">

strFooter = '<div class="lMargin"></div><div id="layFooter_1th"><img src="'+_IMG_PATH_+'/img/layout/1th_footer.gif" alt=""></div>';
document.write(strFooter);

</script>
<!-- //Footer -->
<!-- 풋터 끝 -->

<iframe name="exec_frame" width="0" height="0"></iframe>
</body>
</html> 
