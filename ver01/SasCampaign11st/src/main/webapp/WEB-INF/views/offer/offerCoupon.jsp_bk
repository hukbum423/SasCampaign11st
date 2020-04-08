<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head_pop.jsp"%>

<!-- PAGE LEVEL STYLES -->
<link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
<link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
<link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
<!-- END PAGE LEVEL  STYLES -->

<link href="${staticPATH }/css/jquery_1.9.2/base/jquery-ui-1.9.2.custom.css" rel="stylesheet">
<script src="${staticPATH }/js/jquery_1.9.2/jquery-ui-1.9.2.custom.js"></script>
<script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script>
<script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>

<script language="JavaScript">
	
	window.resizeTo(1060,910);

	$(document).ready(function(){

		//쿠폰번호가 있을경우 쿠폰템플릿 정보 조회
		if($("#S_TMPL_CUPN_NO").val() != ""){
			fn_search();	
		}
		
    $("#disp_ctgr1").bind("change",fn_Category1);
    $("#disp_ctgr2").bind("change",fn_Category2);
    $("#disp_ctgr3").bind("change",fn_Category3);
    $("#disp_ctgr4").bind("change",fn_Category4);
    
    $("#addCtgr").bind("click",fn_addCtgr);
    
    ctgrSearch('1');
    
    $("#ISS_CN_BGN_DT2").datepicker({
      showOn: "button",
      buttonImage: "${staticPATH }/image/calendar.gif",
      buttonImageOnly: true,
      buttonText: "Select date"
    });
    $("#ISS_CN_END_DT2").datepicker({
      showOn: "button",
      buttonImage: "${staticPATH }/image/calendar.gif",
      buttonImageOnly: true,
      buttonText: "Select date"
    });
	});

	
	/* 등록 */
	function fn_save() {
		
		//유효성 체크
		if(!fn_validation()){
			return;
		}
		
		if(!confirm("저장 하시겠습니까?")){
			return;
		}
		
		var campaignid = $("#CampaignId").val();
		jQuery.ajax({
			url           : '${staticPATH }/setOfferCu.do',
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
	        			//opener.location.reload();
	        			window.opener.fn_getCampaignDtl(campaignid);
	        			
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
		
		if($("#TMPL_CUPN_NO").val() == ""){
			alert("템플릿 쿠폰 정보를 조회 후 저장할수 있습니다");
			$("#TMPL_CUPN_NO").focus();
			return false;
		}
		
		if($("#OFFER_SYS_CD").val() =="OM" ){
			if($("#APPROVE_YN").val() != "03"){
				alert("승인된 쿠폰이 아닙니다");
				return false;
			}
		}
		
		if($("#OFFER_SYS_CD").val() =="MM" ){
			if($("#APPROVE_YN").val() != "MT00602" && $("#APPROVE_YN").val() != "MT03202"){
				alert("승인된 쿠폰이 아닙니다");
				return false;
			}
		}
		
		if(Number($("#TITLE_LEN").val())>60){
			alert("쿠폰명은 60Byte를 초과할수 없습니다\n현재 길이 : " + $("#TITLE_LEN").val() + "Byte");
			return false;
		}
		
		
		if("${bo.camp_term_cd}" == "01"){ //FROM~TO
			if($("#TMPL_CUPN_NO_USE_YN").val() == "Y" && "${bo.offer_type_cd}" !="PN" ){ //복사 'Y' && MM 포인트가 아닐경우
				if("${bo.camp_bgn_dt}" != $("#ISS_CN_BGN_DT2").val()){
					alert("캠페인 시작일과 쿠폰 발급가능기간 시작일이 다릅니다");
					return false;
					
				}
				if("${bo.camp_end_dt}" != $("#ISS_CN_END_DT2").val()){
					alert("캠페인 종료일과 쿠폰 발급가능기간 종료일이 다릅니다");
					return false;
				}
			}else if($("#TMPL_CUPN_NO_USE_YN").val() == "Y" && "${bo.offer_type_cd}" =="PN"){ //복사 'Y' && MM 포인트일 경우
				if("${bo.camp_bgn_dt}" < $("#ISS_CN_BGN_DT2").val() || "${bo.camp_bgn_dt}" > $("#ISS_CN_END_DT2").val()){
					alert("캠페인 시작일이 쿠폰 발급가능기간 포함되지 않습니다");
					return false;
				}			
				if("${bo.camp_end_dt}" < $("#ISS_CN_BGN_DT2").val() || "${bo.camp_end_dt}" > $("#ISS_CN_END_DT2").val()){
					alert("캠페인 종료일이 쿠폰 발급가능기간 포함되지 않습니다");
					return false;
				}					
			}else if($("#TMPL_CUPN_NO_USE_YN").val() == "N"){
				if("${bo.camp_bgn_dt}" < $("#ISS_CN_BGN_DT2").val() || "${bo.camp_bgn_dt}" > $("#ISS_CN_END_DT2").val()){
					alert("캠페인 시작일이 쿠폰 발급가능기간 포함되지 않습니다");
					return false;
				}			
				if("${bo.camp_end_dt}" < $("#ISS_CN_BGN_DT2").val() || "${bo.camp_end_dt}" > $("#ISS_CN_END_DT2").val()){
					alert("캠페인 종료일이 쿠폰 발급가능기간 포함되지 않습니다");
					return false;
				}			
			}
		}
			
		return true;
	}
	
	
	//창닫기
	function fn_close(){
		//창닫기
		window.close();
	}
	
	
	//템플릿 쿠폰정보 조회
	function fn_search(){
		
		if($("#S_TMPL_CUPN_NO").val() == ""){
			alert("템플릿 쿠폰을 입력하세요");
			$("#S_TMPL_CUPN_NO").focus();
			return;
		}
		
		jQuery.ajax({
			url           : '${staticPATH }/offer/getOfferTmplCupnInfo.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
      data          : $("#form").serialize(),
      success: function(result, option) {

	        	if(option=="success"){
					
    					if(result.bo == null){
    						alert("쿠폰정보가 없습니다.\n템플릿 쿠폰번호를 확인하세요");	
    					}else{
    						$("#SP_TMPL_CUPN_NO").html(result.bo.cupn_no);
    						$("#SP_DISP_NAME").html(result.bo.cupn_nm);

    					// ############################################ 쿠폰할인 방식
    						var cpunDscMthdCd_HTML = "";
    						var cpunDscMthdCd_Selected01 = "";
    						var cpunDscMthdCd_Selected02 = "";

    					  //console.log(result.bo.cupn_dsc_mthd_cd);
                if(result.bo.cupn_dsc_mthd_cd == "정액"){
                  cpunDscMthdCd_Selected01 = "selected";
                }
                if(result.bo.cupn_dsc_mthd_cd == "정률"){
                  cpunDscMthdCd_Selected02 = "selected";
                }
                
    						cpunDscMthdCd_HTML += "<select name='p_cupn_dsc_mthd_cd' id='p_cupn_dsc_mthd_cd'>";
    						cpunDscMthdCd_HTML += "<option value='01' "+cpunDscMthdCd_Selected01+">정액</option>";
    						cpunDscMthdCd_HTML += "<option value='02' "+cpunDscMthdCd_Selected02+">정률</option>";
    						cpunDscMthdCd_HTML += "</select>";
    						$("#SP_CUPN_DSC_MTHD_CD").html(cpunDscMthdCd_HTML);
                // ############################################ 쿠폰할인 방식 ///
                
                // ############################################할인금액/할인율
                var dscRtAmtHTML = "";
    						if(result.bo.cupn_dsc_mthd_cd == "정액"){
    						  dscRtAmtHTML += "<input type='text' name='p_dsc_amt_rt' id='p_dsc_amt_rt' value='"+result.bo.dsc_rt_amt+"' style='width:90px'/>";
    						  dscRtAmtHTML += "<span id='dscAmpRtType'>원</span>";
                }
                if(result.bo.cupn_dsc_mthd_cd == "정률"){
                  dscRtAmtHTML += "<input type='text' name='p_dsc_amt_rt' id='p_dsc_amt_rt' value='"+result.bo.dsc_rt_amt+"' style='width:90px'/>";
                  dscRtAmtHTML += "<span id='dscAmpRtType'>%</span>";
                }
                $("#SP_DSC_RT_AMT").html(dscRtAmtHTML);
                // ############################################할인금액/할인율 ///
             
                // ############################################발급가능기간
                var splitBgnStr = result.bo.iss_cn_bgn_dt.split(" ");
                var splitEndStr = result.bo.iss_cn_end_dt.split(" ");
                var issCnBgnDtHTML = "";
                issCnBgnDtHTML += '<input type="text" id="p_iss_cn_bgn_dt" name="p_iss_cn_bgn_dt" class="txt" style="width:78px;" value="'+splitBgnStr[0]+'" readonly="readonly"/>'
                issCnBgnDtHTML += ' <input type="text" id="p_iss_cn_bgn_tm" name="p_iss_cn_bgn_tm" class="txt" style="width:41px;" value="'+splitBgnStr[1].substring(0,5)+'" />:00'
    						$("#SP_ISS_CN_BGN_DT").html(issCnBgnDtHTML + " ~ ");
                var issCnEndDtHTML = "";
                issCnEndDtHTML += '<input type="text" id="p_iss_cn_end_dt" name="p_iss_cn_end_dt" class="txt" style="width:78px;" value="'+splitEndStr[0]+'" readonly="readonly"/>'
                issCnEndDtHTML += ' <input type="text" id="p_iss_cn_end_tm" name="p_iss_cn_end_tm" class="txt" style="width:41px;" value="'+splitEndStr[1].substring(0,5)+'" />:59'
    						$("#SP_ISS_CN_END_DT").html(issCnEndDtHTML);
    					  // ############################################발급가능기간 ///
    					  
    					  // ############################################유효기간
    						if(result.bo.cupn_eftv_prd_basi_cd == "01" || result.bo.cupn_eftv_prd_basi_cd == "MT00402"){
    							$("#SP_CUPN_EFTV_PRD_BASI_NM").html(result.bo.cupn_eftv_prd_basi_nm + result.bo.iss_dt_basi_dd_qty);
    							$("#eftvView").hide();
    							$("#eftvPrdView").show();
    						}else{
    						  var splitEftvBgnStr = result.bo.eftv_bgn_dt.split(" ");
    						  var splitEftvEndStr = result.bo.eftv_end_dt.split(" ");
    						  var eftvBgnDtHTML = "";
    						  eftvBgnDtHTML += '<input type="text" id="p_eftv_bgn_dt" name="p_eftv_bgn_dt" class="txt" style="width:78px;" value="'+splitEftvBgnStr[0]+'" readonly="readonly"/>'
    						  //eftvBgnDtHTML += ' <input type="text" id="p_eftv_bgn_tm" name="p_eftv_bgn_tm" class="txt" style="width:41px;" value="'+splitEftvBgnStr[1].substring(0,5)+'" />:00'
    							$("#SP_EFTV_BGN_DT").html(eftvBgnDtHTML + " ~ ");
    						  var eftvEndDtHTML = "";
    						  eftvEndDtHTML += '<input type="text" id="p_eftv_end_dt" name="p_eftv_end_dt" class="txt" style="width:78px;" value="'+splitEftvEndStr[0]+'" readonly="readonly"/>'
    						  //eftvEndDtHTML += ' <input type="text" id="p_eftv_end_tm" name="p_eftv_end_tm" class="txt" style="width:41px;" value="'+splitEftvEndStr[1].substring(0,5)+'" />:59'
    							$("#SP_EFTV_END_DT").html(eftvEndDtHTML);
                  $("#eftvView").show();
                  $("#eftvPrdView").hide();
    						}
    					// ############################################유효기간 ///
    					  
    						// ############################################최소주문금액
    						var minOrdAmtHTML = "";
                minOrdAmtHTML += "<input type='text' name='p_min_ord_amt' id='p_min_ord_amt' value='"+result.bo.min_ord_amt+"' style='width:90px'/>";
                minOrdAmtHTML += " 원 이상 구매 시 사용 ";
    						$("#MIN_ORD_AMT").html(minOrdAmtHTML);
    					  // ############################################최소주문금액 ///
    					
    					  // ############################################최대할인금액
    					  var maxDscAmtHTML = "";
    					  var tmpMaxDscAmtStr = "";
                if(null != result.bo.max_dsc_amt){
                  tmpMaxDscAmtStr = result.bo.max_dsc_amt;
                }
                if(result.bo.cupn_dsc_mthd_cd == "정액"){
                  maxDscAmtHTML += "최대 ";
                  maxDscAmtHTML += "<input type='text' name='p_max_dsc_amt' id='p_max_dsc_amt' value='"+tmpMaxDscAmtStr+"' style='width:90px' readonly />";
                  maxDscAmtHTML += " 원까지 할인";
                }
                if(result.bo.cupn_dsc_mthd_cd == "정률"){
                  maxDscAmtHTML += "최대 ";
                  maxDscAmtHTML += "<input type='text' name='p_max_dsc_amt' id='p_max_dsc_amt' value='"+tmpMaxDscAmtStr+"' style='width:90px'/>";
                  maxDscAmtHTML += " 원까지 할인";
                }
    						$("#SP_MAX_DSC_AMT").html(maxDscAmtHTML);
    					  // ############################################최대할인금액 ///
    					
    						$("#SP_ISU_QTY").html("<input type='text' name='p_isu_qty' id='p_isu_qty' value='"+result.bo.isu_qty+"'  style='width:90px' onblur='onlyNumber2(this);'/>");
    						$("#SP_CUPN_ISS_STAT_NM").html(result.bo.cupn_iss_stat_nm);
    						
    						//저장정보
    						$("#DISP_NAME").val(result.bo.cupn_nm);
    						$("#TMPL_CUPN_NO").val(result.bo.cupn_no);
    						$("#APPROVE_YN").val(result.bo.cupn_iss_stat_cd);
    						$("#ISS_CN_BGN_DT2").val(result.bo.iss_cn_bgn_dt2);
    						$("#ISS_CN_END_DT2").val(result.bo.iss_cn_end_dt2);
    						
    						// ############################################적용사이트 제한
    						var chkWireCodeHTML = "";
    						var chkWireCodeChecked = "";
    						if(result.bo.wire_wiress_clf_cd == "03"){
    						  chkWireCodeChecked = "checked";
    						}
    						chkWireCodeHTML += "<label for='p_wire_wirelss_clf_cd'>";
    					  chkWireCodeHTML += "<input type='checkbox' id='p_wire_wirelss_clf_cd' name='p_wire_wirelss_clf_cd' value='03' "+chkWireCodeChecked+">";
    					  chkWireCodeHTML += " 모바일 (체크시 APP MW적용)";
    						chkWireCodeHTML += "</label>";
    						$("#CHK_WIRE_CODE").html(chkWireCodeHTML);
    					  // ############################################적용사이트 제한 ////
    						
    						//길이 체크
    						var strCharCounter = 0;
    						var strTemp        = "";
    						var txta = result.bo.cupn_nm;
    
				        for (var i = 0; i < txta.length; i++)
				        {
				            var strChar = txta.substring(i, i + 1); //입력값
				            var l = 0;
				                if (strChar == '\n') 
				                {
				                    strTemp += strChar;
				                    strCharCounter += 2;
				                }
				                else {
				                    strTemp += strChar;
				                    strCharCounter += (strTemp.charCodeAt(i) > 128) ? 2 : 1;
				                }

				        }
				        
				        $("#TITLE_LEN").val(strCharCounter);
    						
				        var ctgrCuList = result.ctgrList;
				        $("#ctgrListTbody").empty();
				        for (var i = 0; i< ctgrCuList.length; i++){

				          var ctgr1No = ctgrCuList[i].disp_ctgr1_no;
				          var ctgr2No = ctgrCuList[i].disp_ctgr2_no;
				          var ctgr3No = ctgrCuList[i].disp_ctgr3_no;
				          var ctgr4No = ctgrCuList[i].disp_ctgr4_no;
				          
				          var tmpChkVal = "";
				          
				          if(ctgr1No != null){
				            tmpChkVal += ctgrCuList[i].disp_ctgr1_no;
				          }
				          if(ctgr2No != null){
                    tmpChkVal += "_" + ctgrCuList[i].disp_ctgr2_no;
                  }
				          if(ctgr3No != null){
                    tmpChkVal += "_" + ctgrCuList[i].disp_ctgr3_no;
                  }
				          if(ctgr4No != null){
                    tmpChkVal += "_" + ctgrCuList[i].disp_ctgr4_no;
                  }
				          
				          var strTxt = "";
				          strTxt += "<tr id='tableTr_"+tmpChkVal+"'>";
				          strTxt += "<input type='hidden' id='trCtgr_"+tmpChkVal+"' name='trCtgr_"+tmpChkVal+"' value='"+tmpChkVal+"'/>"
				          if(null != ctgrCuList[i].disp_ctgr1_no && ctgrCuList[i].disp_ctgr1_no != ""){
				            strTxt += "<td>" + ctgrCuList[i].disp_ctgr1_nm + "</td>";
				          }
				          if(null != ctgrCuList[i].disp_ctgr2_no && ctgrCuList[i].disp_ctgr2_no != ""){
				            var tmpValue = $("#disp_ctgr2 option:selected").text();
				            strTxt += "<td>" + ctgrCuList[i].disp_ctgr2_nm + "</td>";
				          }else{
				            strTxt += "<td></td>";
				          }
				          if(null != ctgrCuList[i].disp_ctgr3_no && ctgrCuList[i].disp_ctgr3_no != ""){
				            var tmpValue = $("#disp_ctgr3 option:selected").text();
				            strTxt += "<td>" + ctgrCuList[i].disp_ctgr3_nm + "</td>";
				          }else{
				            strTxt += "<td></td>";
				          }
				          if(null != ctgrCuList[i].disp_ctgr4_no && ctgrCuList[i].disp_ctgr4_no != ""){
				            var tmpValue = $("#disp_ctgr4 option:selected").text();
				            strTxt += "<td>" + ctgrCuList[i].disp_ctgr4_nm + "</td>";
				          }else{
				            strTxt += "<td></td>";
				          }
				          strTxt += '<td><button type="button" onclick="deleteLine(this);" class="btn btn-warning btn-xs"><i class="fa fa-close" aria-hidden="true"></i></button></td>';
				          strTxt += "</tr>";
				          
				          $("#ctgrList > tbody:last").append(strTxt);
				          
				        }
    					}
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        	
	          //Function
	          $("#p_cupn_dsc_mthd_cd").change(function() {
	            if($("#p_cupn_dsc_mthd_cd").val() == "01"){
	              $("#dscAmpRtType").text("원");
	              $("#p_max_dsc_amt").val("");
	              $("#p_max_dsc_amt").attr("readonly",true);
	            }else{
	               $("#dscAmpRtType").text("%");
	               $("#p_max_dsc_amt").removeAttr("readonly");
	            }
	          });
	          
	          //datepicker
	          $("#p_iss_cn_bgn_dt").datepicker(dateOption);
	          $("#p_iss_cn_end_dt").datepicker(dateOption);
	          $("#p_eftv_bgn_dt").datepicker(dateOption);
	          $("#p_eftv_end_dt").datepicker(dateOption);
	          
	          if("${bo.camp_status_cd}" != "START"){
	            $("#cupnDelete").show();
	          }else{
	            $("#cupnDelete").hide();
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
	
	function totalCountCheck(obj){
	  
	}
	
  function onlyNumber(loc) {
    if(/[^0123456789]/g.test(loc.value)) {
      alert("숫자가 아닙니다.\n\n0-9의 정수만 허용합니다.");
      loc.value = "";
      loc.focus();
      return false;
    }
    return true;
  }
	
	function onlyNumber2(loc) {
	  if(/[^0123456789]/g.test(loc.value)) {
	    alert("발급갯수를 확인해주세요.\n0-9의 정수만 허용합니다.");
	    loc.value = "";
	    loc.focus();
	    return false;
	  }else if(parseInt(loc.value) >= 999999999){
	    alert("발급갯수는 최대 999,999,999개를 넘을수 없습니다");
	    loc.value = "";
      loc.focus();
      return false;
	  }
    return true;
	}

	
  function fn_Category1(){
    $("select[name='disp_ctgr2'] option").remove();
    $("select[name='disp_ctgr3'] option").remove();
    $("select[name='disp_ctgr4'] option").remove();
  
    $("#selectCategory1").val($("#disp_ctgr1 option:selected").val());
//    console.log("selectCategory1 : " + $("#selectCategory1").val());
    if($("#disp_ctgr1").val() != ""){
      ctgrSearch('2');
    }
  }
  
  function fn_Category2(){
    $("select[name='disp_ctgr3'] option").remove();
    $("select[name='disp_ctgr4'] option").remove();
  
    $("#selectCategory2").val($("#disp_ctgr2 option:selected").val());
//    console.log("selectCategory2 : " + $("#selectCategory2").val());
    $("#disp_ctgr3").val("");
    $("#disp_ctgr4").val("");
    if($("#disp_ctgr2").val() != ""){
      ctgrSearch('3');
    }
  }
  
  function fn_Category3(){
    $("select[name='disp_ctgr4'] option").remove();
  
    $("#selectCategory3").val($("#disp_ctgr3 option:selected").val());
//    console.log("selectCategory3 : " + $("#selectCategory3").val());
  
    $("#disp_ctgr4").val("");
    if($("#disp_ctgr3").val() != ""){
      ctgrSearch('4');
    }
  }
  
  function fn_Category4(){
    $("#selectCategory4").val($("#disp_ctgr4 option:selected").val());
//    console.log("selectCategory4 : " + $("#selectCategory4").val());
  }
  
  

  // 추가버튼 클릭시 선택항목 리스트에 추가 및 저장할 Json 값 생성
  function fn_addCtgr() {
/* 
    console.log($("#disp_ctgr1 option:selected").val());
    console.log($("#disp_ctgr2 option:selected").val());
    console.log($("#disp_ctgr3 option:selected").val());
    console.log($("#disp_ctgr4 option:selected").val());
 */
    var ctgr1 = $("#disp_ctgr1 option:selected").val();
    var ctgr2 = $("#disp_ctgr2 option:selected").val();
    var ctgr3 = $("#disp_ctgr3 option:selected").val();
    var ctgr4 = $("#disp_ctgr4 option:selected").val();

    var ctgr1Cnt = 0;
    var ctgr2Cnt = 0;
    var ctgr3Cnt = 0;
    var ctgr4Cnt = 0;
//    console.log("######");
    $.each($("#disp_ctgr1 option:selected"), function(key, value) {
//      console.log($(this).val());
      ctgr1Cnt++
    });
//    console.log("######");
    $.each($("#disp_ctgr2 option:selected"), function(key, value) {
//      console.log($(this).val());
      ctgr2Cnt++
    });
//    console.log("######");
    $.each($("#disp_ctgr3 option:selected"), function(key, value) {
//      console.log($(this).val());
      ctgr3Cnt++
    });
//    console.log("######");
    $.each($("#disp_ctgr4 option:selected"), function(key, value) {
//      console.log($(this).val());
      ctgr4Cnt++
    });

    if (ctgr1 == "") {
      alert("1개이상의 카테고리를 선택 하세요");
      $("#disp_ctgr1").focus();
      return false;
    } else if (ctgr4Cnt >= 1 && ctgr3Cnt > 1) {
      alert("다중 선택의 경우 상위 카테고리를 한개만 선택 해야 합니다!");
      $("#disp_ctgr3 option:selected").prop("selected", false);
      $("#disp_ctgr3").val($("#selectCategory3").val());
      return false;
    } else if (ctgr3Cnt >= 1 && ctgr2Cnt > 1) {
      alert("다중 선택의 경우 상위 카테고리를 한개만 선택 해야 합니다 .");
      $("#disp_ctgr2 option:selected").prop("selected", false);
      $("#disp_ctgr2").val($("#selectCategory2").val());
      return false;
    } else if (ctgr2Cnt >= 1 && ctgr1Cnt > 1) {
      alert("다중 선택의 경우 상위 카테고리를 한개만 선택 해야 합니다.");
      $("#disp_ctgr1 option:selected").prop("selected", false);
      $("#disp_ctgr1").val($("#selectCategory1").val());
      return false;
    } else {
      // 최종 선택된 데이터 체크
      var forCnt;
      var lastStep;
      if(ctgr4Cnt > 0){
        forCnt = ctgr4Cnt;
        lastStep = 4;
      }else if(ctgr3Cnt > 0){
        forCnt = ctgr3Cnt;
        lastStep = 3;
      }else if(ctgr2Cnt > 0){
        forCnt = ctgr2Cnt;
        lastStep = 2;
      }else if(ctgr1Cnt > 0){
        forCnt = ctgr1Cnt;
        lastStep = 1;
      }

      if($("#subcategory").prop("checked") == true && ctgr4Cnt >= 1){
        alert("하위카테고리 등록 선택시 4Depth 카테고리를 선택할수 없습니다.");
        return false;
      }
      
      if($("#subcategory").prop("checked") == true){    // 하위카테고리 등록 선택시
        
        var arr = new Array();
        $.each($("#disp_ctgr"+lastStep+" option:selected"), function(key, value) {
          //console.log($(this).val());
          //console.log($(this).text())
          arr[key] = $(this).val();
        });
      
        $("#arrKey").val(arr);
        $("#cateNoVal").val(lastStep);
        
        jQuery.ajax({
          url           : '${staticPATH }/offer/getSubCategory.do',
          dataType      : "JSON",
          scriptCharset : "UTF-8",
          type          : "POST",
          data          : $("#form").serialize(),
          success: function(result, option) {

            if(option=="success"){
          
              if(result.boList == null){
              }else{
                for (var i = 0; i< result.boList.length; i++){
                  var boList = result.boList[i];
                  //console.log("######" + eval("boList.disp_ctgr"+(lastStep+1)+"_nm"));
                  var subTitle = eval("boList.disp_ctgr"+(lastStep+1)+"_nm");
                  var ctgr1 = "";
                  var ctgr2 = "";
                  var ctgr3 = "";
                  var ctgr4 = "";
                  
                  for (var k = 0; k < lastStep+1; k++) {
                    eval("ctgr"+(k+1)+"=boList.disp_ctgr"+(k+1)+"_no");
                  }
/*                   
                  console.log(ctgr1);
                  console.log(ctgr2);
                  console.log(ctgr3);
                  console.log(ctgr4);
                  console.log(subTitle);
 */                  
                  createTr(ctgr1, ctgr2, ctgr3, ctgr4, subTitle, "Y", lastStep);
                }
              }
            }else{
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
        
      
      
      
         
      }else{    // 하위카테고리 등록 미선택시
      
//        console.log("forCnt : " + forCnt + " ::::: lastStep : " + lastStep);
        var tmpChkVal= "";
        $.each($("#disp_ctgr"+lastStep+" option:selected"), function(key, value) {
          tmpChkVal= "";
          var cateNo1 = "";
          var cateNo2 = "";
          var cateNo3 = "";
          var cateNo4 = "";
          for (var m = 1; m < lastStep; m++) {
            if(m > 1){
              tmpChkVal += "_";
            }
            tmpChkVal += $("#disp_ctgr"+m).val();
            eval("cateNo"+m+"="+$("#disp_ctgr"+m).val());
          }

          eval("cateNo"+lastStep+"="+$(this).val());
          tmpChkVal += "_" + $(this).val();
//          console.log("tmpChkVal : " + tmpChkVal + "_" + $(this).val());
//          console.log("key : " + key + " ::::: value : " + $(this).val() + " ::::: text : " + $(this).text());
//          console.log("############################### this val : " + $(this).val());
//          console.log("cateNo1 : " + cateNo1 + " :::::::: cateNo2 : " + cateNo2 + "::::::: cateNo3 : " + cateNo3 + " ::::::: cateNo4 : " + cateNo4);
          
          createTr(cateNo1, cateNo2, cateNo3, cateNo4, $(this).text(), "N", lastStep);
        });
      }// 하위카테고리 등록 미선택시 ///
      
    }
  }

  function createTr(ctgr1, ctgr2, ctgr3, ctgr4, subTitle, chkType, lastStep){
    var tmpChkVal = "";// = ctgr1 + "_" +  ctgr2 + "_" + ctgr3 + "_" + ctgr4;
    
//    console.log("ctgr1 : " + ctgr1 + " ::::::: ctgr2 : " + ctgr2 + " :::::: ctgr3 : " + ctgr3 + " :::::: ctgr4 : " + ctgr4);
//    console.log("-------------------------");
    
    if(ctgr1 != ""){
      tmpChkVal += ctgr1; 
    }
    if(ctgr2 != ""){
      tmpChkVal += "_"+ctgr2; 
    }
    if(ctgr3 != ""){
      tmpChkVal += "_"+ctgr3; 
    }
    if(ctgr4 != ""){
      tmpChkVal += "_"+ctgr4; 
    }
    
//    console.log("tmpChkVal : " + tmpChkVal);
//    console.log("subTitle : " + subTitle);
//    console.log("tmpChkVal.length : " + $('#trCtgr_' + tmpChkVal).length);
    
    if ($('#trCtgr_' + tmpChkVal).length > 0) {
      //alert("이미 등록된 카테고리가 있습니다.");
      return;
    }
    
    var strTxt = "";
    strTxt += "<tr id='tableTr_"+tmpChkVal+"'>";
    strTxt += "<input type='hidden' id='trCtgr_"+tmpChkVal+"' name='trCtgr_"+tmpChkVal+"' value='"+tmpChkVal+"'/>"
    
    if (ctgr1 != "") {
      strTxt += createTdLoop("1", ctgr1);
    }
    if (ctgr2 != "") {
      if(chkType == "Y" && (lastStep+1) == 2){
        strTxt += "<td>"+subTitle+"</td>";
      }else{
        strTxt += createTdLoop("2", ctgr2);
      }
      
    } else {
      strTxt += "<td></td>";
    }
    if (ctgr3 != "") {
      if(chkType == "Y" && (lastStep+1) == 3){
        strTxt += "<td>"+subTitle+"</td>";
      }else{
        strTxt += createTdLoop("3", ctgr3);        
      }
    } else {
      strTxt += "<td></td>";
    }
    if (ctgr4 != "") {
      if(chkType == "Y" && (lastStep+1) == 4){
        strTxt += "<td>"+subTitle+"</td>";
      }else{
        strTxt += createTdLoop("4", ctgr4);
      }
    } else {
      strTxt += "<td></td>";
    }
    
    strTxt += '<td>';
    strTxt += '<button type="button" onclick="deleteLine(this);" class="btn btn-warning btn-xs"><i class="fa fa-close" aria-hidden="true"></i></button></td>';
    strTxt += "</tr>";

//    console.log("########################## add tr");
    $("#ctgrList > tbody:last").append(strTxt);
  }

  // TD 생성
  function createTdLoop(str, ctgr){
    var strTxt = "";
    $.each($("#disp_ctgr"+str+" option:selected"), function(key, value) {
//      console.log("ctgr"+str+" loop ===== " + ctgr + " / " + $(this).val());
      if(ctgr == $(this).val()){
        strTxt += "<td>" + $(this).text() + "</td>";
      }
    });
    return strTxt;
  }
  
  function deleteLine(obj) {
    var tr = $(obj).parent().parent();

    //라인 삭제
    tr.remove();
  }

  function deleteLineAll() {
    $("#ctgrListTbody > tr").remove();    
    
//    var tr = $(obj).parent().parent();

    //라인 삭제
//    tr.remove();
    
//    $("#id").remove();
  }

  function ctgrSearch(strlevel) {
    $("select[name='disp_ctgr" + strlevel + "'] option").remove();
    // 항목 초기화
    jQuery.ajax({
    url : '${staticPATH }/offer/getBoCategory.do',
    dataType : "JSON",
    scriptCharset : "UTF-8",
    type : "POST",
    data : {
    level : strlevel,
    disp_ctgr1 : $("#disp_ctgr1 option:selected").val(),
    disp_ctgr2 : $("#disp_ctgr2 option:selected").val(),
    disp_ctgr3 : $("#disp_ctgr3 option:selected").val(),
    },
    success : function(result, option) {
      if (option == "success") {
        var list = result.boList;

        //$('#disp_ctgr' + strlevel + '').append('<option value="">카테고리 ' + strlevel + '</option>');

        if (list.length > 0) {
          $.each(list, function(key) {
            var data = list[key];
            //console.log(data.disp_ctgr_no);
            // 항목 추가
            $('#disp_ctgr' + strlevel + '').append('<option value="'+data.disp_ctgr_no+'">' + data.disp_ctgr_nm + '</option>');
          });
        }
      } else {
        alert("에러가 발생하였습니다.");
      }
    },
    beforeSend : function() {
    },
    complete : function() {
    },
    error : function(result, option) {
      alert("에러가 발생하였습니다.");
    }
    });
  }
  
  function fn_copy_cupn(){
    var today = new Date();
    var endDate = new Date($("#p_iss_cn_end_dt").val());
    if (today > endDate) {
        alert("발급가능기간 종료일은 현재일보다 커야합니다.");
        return;
    }

    var today1 = new Date();
    var endDate1 = new Date($("#p_eftv_end_dt").val());
    if (today1 > endDate1) {
        alert("유효기간 종료일은 현재일보다 커야합니다.");
        return;
    }
    
    if(parseInt($("#p_min_ord_amt").val()) < 0){
      alert("최소 주문금액은 0보다 커야 합니다.");
      $("#p_min_ord_amt").focus();
      return;
    }
    
    var isuQtyVal = $("#p_isu_qty").val();
    document.form.p_isu_qty.value=replaceAll(isuQtyVal, ",", "");
    if(!onlyNumber2(document.form.p_isu_qty)){
      return;
    }

    jQuery.ajax({
      url : '${staticPATH }/offer/copyCoupon.do',
      dataType : "JSON",
      scriptCharset : "UTF-8",
      type : "POST",
      data : $("#form").serialize(),
      success : function(result, option) {
        if (option == "success") {
//          console.log(result.r_cupn_no);
          alert("쿠폰복사가 완료되었습니다.");
          $("#S_TMPL_CUPN_NO").val(result.r_cupn_no);
          $("#SP_TMPL_CUPN_NO").html(result.r_cupn_no);
          $("#TMPL_CUPN_NO").val(result.r_cupn_no);
          fn_search();
        } else {
          alert("에러가 발생하였습니다!");
        }
      },
      beforeSend : function() {
      },
      complete : function() {
      },
      error : function(result, option) {
        alert("에러가 발생하였습니다.");
      }
    });
  }
  
  function fn_edit_cupn(){
    console.log($("input[id^='trCtgr_']").length);
    if($("input[id^='trCtgr_']").length <= 0 ){
      alert("한개이상의 카테고리를 선탱 해야합니다.");
      return;
    }
    
    jQuery.ajax({
      url : '${staticPATH }/offer/editCoupon.do',
      dataType : "JSON",
      scriptCharset : "UTF-8",
      type : "POST",
      data : $("#form").serialize(),
      success : function(result, option) {
        if (option == "success") {
//          console.log(result.r_cupn_no);
          alert("쿠폰 카테고리 수정이 완료되었습니다.");
          fn_search();
        } else {
          alert("에러가 발생하였습니다!");
        }
      },
      beforeSend : function() {
      },
      complete : function() {
      },
      error : function(result, option) {
        alert("에러가 발생하였습니다.");
      }
    });
  }
  
  function fn_delete_cupn(){
    if(confirm('쿠폰을 회수 하시겠습니까?')){
      jQuery.ajax({
        url : '${staticPATH }/offer/deleteCoupon.do',
        dataType : "JSON",
        scriptCharset : "UTF-8",
        type : "POST",
        data : $("#form").serialize(),
        success : function(result, option) {
          if (option == "success") {
            if(result.resultVal == "0000"){
              alert("쿠폰 회수가 완료되었습니다.");
            }else{
              alert("쿠폰 회수 진행중 오류가 발생 했습니다.");
            }
            fn_search();
          } else {
            alert("에러가 발생하였습니다!");
          }
        },
        beforeSend : function() {
        },
        complete : function() {
        },
        error : function(result, option) {
          alert("에러가 발생하였습니다.");
        }
      });
    }
  }
//쿠폰회수 처리 기능을 SAS STP 이용하는 것으로 변경 처리 (2018.5.3) 
  function fn_delete_cupn_new(){
    if(confirm("쿠폰을 회수 하시겠습니까??"))  {
      
      jQuery.ajax({
        url           : '/SASStoredProcess/do?_program=/CM_META/41.STP/412.STP/del_cupn&p_campcode='+$("#CAMPAIGNCODE").val()+'&p_cellid=' + $("#CELLID").val()+'&p_offerid='+$("#OFFERID").val(),
        dataType      : "JSON",
        scriptCharset : "UTF-8",
        type : "POST",

        success: function(result, option) {
          //alert("SUCCESS: 쿠폰 회수가 완료되었습니다..\n\n..");
          
          if(option=="success"){
            if(result.length > 0){
              // 성공
              alert("SUCCESS: 쿠폰 회수가 완료되었습니다..\n\n..");   // 수정 처리 (2018.5.3)
            }else{
              alert("쿠폰 회수 처리중 오류가 발생 했습니다.\n\n관리자에 문의 해주세요..");
            }
          }else{
            alert("에러가 발생하였습니다..");  
          }
        },

        beforeSend:function(){
        },

        complete:function(){
          //alert("COMPLETE: 쿠폰 회수가 완료되었습니다..\n\n..");
        },

        error: function(result, option) {
          alert("ERROR: 에러가 발생하였습니다..");
        }
      });
    }
    
    
  }
  
  function replaceAll(str, searchStr, replaceStr) {
    return str.split(searchStr).join(replaceStr);
  }

</script>
<!--PAGE CONTENT -->
        <div id="content" style="width:100%; height100%;">
           <!--BLOCK SECTION -->
           <div class="row" style="width:100%; height100%;">
              <div class="col-lg-1"></div>
              <div class="col-lg-10">

              <div class="col-md-6">
                <h3>오퍼 상세 정보(${bo.offer_sys_cd} ${bo.offer_type_cd})</h3>
              </div>
<form name="form" id="form">
<input type="hidden" id="CampaignId" name="CampaignId" value="${CAMPAIGNID}" />
<input type="hidden" id="CELLID" name="CELLID" value="${bo.cellid}" />
<input type="hidden" id="OFFERID" name="OFFERID" value="${bo.offerlistid}" />
<input type="hidden" id="OFFER_TYPE_CD" name="OFFER_TYPE_CD" value="${bo.offer_type_cd}" />
<input type="hidden" id="OFFER_SYS_CD" name="OFFER_SYS_CD" value="${bo.offer_sys_cd}" />
<input type="hidden" id="CAMPAIGNCODE" name="CAMPAIGNCODE" value="${bo.campaigncode}" />
<input type="hidden" id="FLOWCHARTID" name="FLOWCHARTID" value="${bo.flowchartid}" />

<input type="hidden" id="arrKey" name="arrKey" value="" />
<input type="hidden" id="cateNoVal" name="cateNoVal" value="" />

<%-- <input type="hidden" id="DISP_NAME" name="DISP_NAME" value="${bo.disp_name}" /> --%>
<%-- <input type="hidden" id="TMPL_CUPN_NO" name="TMPL_CUPN_NO" value="${bo.tmpl_cupn_no}" /> --%>

<input type="hidden" id="APPROVE_YN" name="APPROVE_YN" value="" />
<!-- <input type="hidden" ID="ISS_CN_BGN_DT2" name="ISS_CN_BGN_DT2" value="" /> -->
<!-- <input type="hidden" id="ISS_CN_END_DT2" name="ISS_CN_END_DT2" value="" /> -->

<input type="hidden" id="CELL_PACKAGE_SK" name="CELL_PACKAGE_SK" value="${bo.cellid}" />

<input type="hidden" id="TITLE_LEN" name="TITLE_LEN" value="" />
	<div class="col-lg-12" id="table">
		<table class="table table-striped table-hover table-condensed table-bordered" width="100%" border="0" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="14%"/>
				<col width="36%"/>
				<col width="14%"/>
				<col width="36%"/>
			</colgroup>		
			<tr>
				<td class="info">캠페인 코드/명</td>
				<td class="tbtd_content" colspan="3">[${bo.campaigncode}] ${bo.campaignname}</td>
				<%-- <td class="info">플로차트 이름</td>
				<td class="tbtd_content">${bo.flowchartname}</td> --%>
			</tr>
			<tr>
				<td class="info">오퍼 종류</td>
				<td class="tbtd_content">${bo.offername}</td>
				<td class="info">고객 세그먼트</td>
				<td class="tbtd_content">${bo.cellname}</td>
			</tr>
			<tr>
				<td class="info">템플릿 쿠폰번호</td>
				<td class="tbtd_content" colspan="3">
					<div id="search2">
						<input type="text" id="S_TMPL_CUPN_NO" name="S_TMPL_CUPN_NO" class="txt" maxlength="50" onkeydown="javascript:keypressNumber2();" style="width: 200px;" value="${bo.tmpl_cupn_no}"/>
						<button type="button" class="btn btn-success btn-sm" onclick="fn_search();"><i class="fa fa-search" aria-hidden="true"></i> BO 조회</button>
					
					</div>
				</td>
			</tr>
			<tr>
				<td class="info">템플릿 쿠폰번호</td>
				<td class="tbtd_content" colspan="3">
          <span id="SP_TMPL_CUPN_NO"></span>
          <input type="text" id="TMPL_CUPN_NO" name="TMPL_CUPN_NO" value="${bo.tmpl_cupn_no}" />
        </td>
			</tr>
			<tr>
				<td class="info">쿠폰명/노출명</td>
				<td class="tbtd_content" colspan="3">
          <!-- <span id="SP_DISP_NAME"></span> -->
          <input type="input" id="DISP_NAME" name="DISP_NAME" value="${bo.disp_name}" style="width:250px;"/>
        </td>
			</tr>
			<tr>
				<td class="info">쿠폰할인 방식</td>
				<td class="tbtd_content"><span id="SP_CUPN_DSC_MTHD_CD"></span></td>
				<td class="info">할인금액/할인율</td>
				<td class="tbtd_content"><span id="SP_DSC_RT_AMT"></span></td>
			</tr>
			<tr>
				<td class="info">최소주문금액</td>
				<td class="tbtd_content"><span id="MIN_ORD_AMT"></span></td>
				<td class="info">최대할인금액</td>
				<td class="tbtd_content"><span id="SP_MAX_DSC_AMT"></span></td>
			</tr>
			<tr>
				<td class="info">발급가능기간</td>
				<td class="tbtd_content">
          <span id="SP_ISS_CN_BGN_DT"></span><span id="SP_ISS_CN_END_DT"></span>
          <!-- <input type="text" ID="ISS_CN_BGN_DT2" name="ISS_CN_BGN_DT2" value=""  style="width:80px;"/>
          ~ <input type="text" id="ISS_CN_END_DT2" name="ISS_CN_END_DT2" value=""  style="width:80px;"/> -->
        </td>
				<td class="info">유효기간</td>
				<td class="tbtd_content">
        <!-- 
          <div id="eftvView" style="display:none;">
          <input type="text" ID="SP_EFTV_BGN_DT" name="SP_EFTV_BGN_DT" value=""  style="width:80px;"/> 
          ~ <input type="text" ID="SP_EFTV_END_DT" name="SP_EFTV_END_DT" value=""  style="width:80px;"/>
          </div>
          <div id="eftvPrdView" style="display:none;">
          <input type="text" ID="SP_CUPN_EFTV_PRD_BASI_NM" name="SP_CUPN_EFTV_PRD_BASI_NM" value=""  style="width:80px;"/> 일
          </div>
         -->  
          <span id="SP_EFTV_BGN_DT"></span>
          <span id="SP_EFTV_END_DT"></span>
          <span id="SP_CUPN_EFTV_PRD_BASI_NM"></span>
        </td>
			</tr>
			<tr>
				<td class="info">발급갯수</td>
				<td class="tbtd_content"><span id="SP_ISU_QTY"></span></td>
				<td class="info">승인여부</td>
				<td class="tbtd_content"><span id="SP_CUPN_ISS_STAT_NM"></span></td>
			</tr>
			<tr>
				<td class="info">템플릿 쿠폰번호<br/>사용여부</td>
				<td class="tbtd_content">
					<select style="width: 45px;" id="TMPL_CUPN_NO_USE_YN" name="TMPL_CUPN_NO_USE_YN">
						<c:if test="${bo.offer_type_cd != 'PN' }">
							<option value="N" <c:if test="${bo.tmpl_cupn_no_use_yn eq 'N' }">selected="selected"</c:if>>N</option>
						</c:if>
						<option value="Y" <c:if test="${bo.tmpl_cupn_no_use_yn eq 'Y' }">selected="selected"</c:if>>Y</option>
						
					</select>
				</td>
        <td class="info">적용사이트제한</td>
        <td class="tbtd_content"><span id="CHK_WIRE_CODE"></span></td>
			</tr>
      <tr>
        <td class="info">카테고리</td>
        <td class="tbtd_content" colspan="3" class="display:inline-block">
        <input type="hidden" id="selectCategory1" name="selectCategory1"/>
        <input type="hidden" id="selectCategory2" name="selectCategory2"/>
        <input type="hidden" id="selectCategory3" name="selectCategory3"/>
        <input type="hidden" id="selectCategory4" name="selectCategory4"/>
          <div class="col-md-10" style="padding:0px 0px 0px 0px;">
            <select id="disp_ctgr1" name="disp_ctgr1" multiple="multiple" style="width:165px;height:100px"></select>
            <select id="disp_ctgr2" name="disp_ctgr2" multiple="multiple" style="width:165px;height:100px"></select>
            <select id="disp_ctgr3" name="disp_ctgr3" multiple="multiple" style="width:165px;height:100px"></select>
            <select id="disp_ctgr4" name="disp_ctgr4" multiple="multiple" style="width:165px;height:100px"></select>
          </div>
          <div class="col-md-2" style="padding:0px 0px 0px 0px;">
            <input type="checkbox" name="subcategory" id="subcategory" value=""><label for="subcategory">하위카테고리 등록</label>
            <button type="button" id="addCtgr" class="btn btn-success btn-xs"><i class="fa fa-plus" aria-hidden="true"></i> ADD</button>
          </div>
          
  <div style="max-height:135px; overflow-y:scroll; width:100%; border: 1px solid #DDDDDD;margin-top:10px;">
  <table id="ctgrList" class="table table-striped table-hover table-condensed table-bordered" style="width:100%;">
      <colgroup>
        <col width="24%"/>
        <col width="24%"/>
        <col width="24%"/>
        <col width="24%"/>
        <col width="4%"/>
      </colgroup>
      <tr style='height:19px;'>
        <th class="info text-center">카테고리1</th>
        <th class="info text-center">카테고리2</th>
        <th class="info text-center">카테고리3</th>
        <th class="info text-center">카테고리4</th>
        <th class="info text-center"><button type="button" onclick="deleteLineAll();" class="btn btn-danger btn-xs" title="전체삭제"><i class="fa fa-close" aria-hidden="true"></i></button></td>
      </tr>
      <tbody id="ctgrListTbody"></tbody>
  </table>
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
	</div>	
	
  <div id="sysbtn" class="col-md-6" style="text-align:left;margin-bottom:10px;">
    <button type="button" class="btn btn-success btn-sm" onclick="fn_copy_cupn();"><i class="fa fa-copy" aria-hidden="true"></i> 쿠폰복사</button>
    <button type="button" class="btn btn-warning btn-sm" onclick="fn_edit_cupn();"><i class="fa fa-copy" aria-hidden="true"></i> 쿠폰카테고리수정</button>
    <button type="button" class="btn btn-danger btn-sm" onclick="fn_delete_cupn_new();" style="display:;" id="cupnDelete"><i class="fa fa-copy" aria-hidden="true"></i> 쿠폰회수</button>
  </div>
  <div id="sysbtn" class="col-md-6" style="text-align:right;margin-bottom:10px;">
    <button type="button" class="btn btn-danger btn-sm" onclick="fn_save();"><i class="fa fa-floppy-o" aria-hidden="true"></i> 저장</button>
    <button type="button" class="btn btn-default btn-sm" onclick="fn_close();"><i class="fa fa-times" aria-hidden="true"></i> 닫기</button>
  </div>
  
</form>
</div>
                            <div class="col-lg-1"></div>
                        </div>
                        <!--END BLOCK SECTION -->
                        <div class="col-lg-3"></div>
              
                      </div>
                      <!--END PAGE CONTENT -->
<%-- <%@ include file="/WEB-INF/views/common/_footer.jsp"%> --%>
 
 
 
 
 
 
 
 
 
 
 
 