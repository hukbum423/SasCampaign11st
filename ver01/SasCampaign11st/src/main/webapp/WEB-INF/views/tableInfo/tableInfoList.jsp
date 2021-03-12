<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

    <!-- PAGE LEVEL STYLES -->
    <link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
    <link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="${staticPATH }/css/ui-lightness/jquery-ui.css">
    <link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
    <!-- END PAGE LEVEL  STYLES -->

  <script type="text/javascript" src="${staticPATH }/js/common/jquery-ui-1.10.2.custom.js"></script>
  <script type="text/javascript" src="${staticPATH }/js/datepicker/dateOption.js"></script>
  <script type="text/javascript" src="${staticPATH }/js/common/common.js"></script>


<script language="JavaScript">

	/* ready */
	$(document).ready(function(){

// 		=================================================
		// 화면타이틀값 : 메뉴명칭
		if(window.location != window.parent.location){ //iframe일경우에만
			parent.setPageTitle("테이블 정보 관리",null);
	
			// Tab 메뉴
			// Step1 메뉴에 url 생성 후 변경 필요함.
			var tablist = "";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/toastList.do'>토스트 배너 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/testTargetList.do'>테스트 대상 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/variableList.do'>매개변수 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/commCodeList.do'>공통코드 관리</a></li>";
			tablist += "<li class=selected><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/tableInfoList.do'>테이블 정보 관리</a></li>";
			tablist += "<li><a target=content href='/unica/suiteSignOn?target=http://220.103.232.56:9080/UnicaExt/login.do?url=/noticeList.do'>공지사항 관리</a></li>";
			top.setNewTabList(tablist);
			
			parent.document.getElementById('gwt-uid-2').innerHTML='<a href="/Campaign/logout.do"><font color="#E8DB6B" bold style={text-decoration:none;}>로그아웃</a>';
		}
// 		=================================================
	
		//조회
		//fn_search();
		
	});
	

	/* 조회 */
	function fn_search() {
		
		jQuery.ajax({
			url           : '/UnicaExt/getTableInfoList.do',
			dataType      : "JSON",
			scriptCharset : "UTF-8",
			type          : "POST",
	        data          : {STABLE_NAME     : $("#STABLE_NAME").val(),
	        	             selectPageNo    : $("#selectPageNo").val()
	        },
	        success: function(result, option) {
	        	if(option=="success"){
		        	var list = result.TableInfoList;
		        	
		        	var txt ="";
		        	txt += "<table width='100%' border='0' cellpadding='0' cellspacing='0'>";
		        	if(list.length>0){
						txt += "<colgroup>";
						txt += "<col width='40'/>";
						txt += "<col width='150'/>";
						txt += "<col width='80'/>";
						txt += "<col width='80'/>";
						txt += "<col width='120'/>";
						txt += "<col width=''/>";
						txt += "<col width='100'/>";
						txt += "<col width='100'/>";
						txt += "<col width='150'/>";
						txt += "</colgroup>";

			        	$.each(list, function(key){
			        		var data = list[key];
			        		txt += "<tr>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+data.num+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_getTableInfoMstDtl('"+data.table_name+"');\" class='link'>"+nvl(data.table_name,'')+"</a></td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_date,'&nbsp;')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.update_date,'&nbsp;')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.recycle_period,'&nbsp;')+"</td>";
			        		txt += "<td align=\"left\" class=\"listtd\">&nbsp;"+nvl(data.table_desc,'')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\"><a href=\"javascript:fn_getTableInfoDetail('"+data.table_name+"');\" class='link' >[상세보기]</a></td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_nm,'&nbsp;')+"</td>";
			        		txt += "<td align=\"center\" class=\"listtd\">"+nvl(data.create_dt,'&nbsp;')+"</td>";
							txt += "</tr>";
			        	}); 
		        	}else{
		        		txt += "<td align=\"center\" class=\"listtd\" colspn=\"\9\">데이터가 없습니다.</td>";	
		        	}		        	

		        	//빈 row 채우기
		        	if(list.length > 0 && list.length < result.rowRange ){
		        		for(var i=list.length; i<result.rowRange; i++){
		        			txt +="<tr>";
		        			txt +="<td align=\"center\" class=\"listtd\" style=\"height:20px;\">&nbsp;</td>";
		        			txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
		        			txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
		        			txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
		        			txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
		        			txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
		        			txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
		        			txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
		        			txt +="<td align=\"center\" class=\"listtd\">&nbsp;</td>";
		        			txt +="</tr>";
		        		}
		        	}
		        	
		        	txt += "</table>";
		        	
		        	$("#search_layer").html(txt);

		        	//페이징 처리 시작!!
		        	var page = "";
		        	//이전페이지 만들기
		    		if( result.selectPage > result.pageRange){
		    			page +="<a href=\"javascript:fn_pageMove("+ (Number(result.pageStart) - Number(result.pageRange)) +" );\" ><img src=\"<c:url value='/img/btn_left.gif'/>\" width='13px;' height='13px;' /></a>&nbsp;";
		    		}
		    		
		        	//페이지 숫자
		        	for(var i=result.pageStart;  i<=result.pageEnd; i++){
						if(result.selectPage == i)	{	
							page +="<strong>" + i + "</strong>";
						}else{ 
							page +="<a href=\"javascript:fn_pageMove("+i+");\">" + i + "</a>";
						};
		        	};
		        	
		        	//다음페이지 만들기
					if(result.totalPage != result.pageEnd )	{
						page +="&nbsp;<a href=\"javascript:fn_pageMove("+ (Number(result.pageStart) + Number(result.pageRange)) +" );\" ><img src=\"<c:url value='/img/btn_right.gif'/>\" width='13px;' height='13px;' /></a>";
					}
					$("#paging_layer").html(page);
					//페이징 처리 종료
					
	        	}else{
	        		alert("에러가 발생하였습니다.");	
	        	}
	        },
	        error: function(result, option) {
	        	alert("에러가 발생하였습니다.");
	        }
		});
	};

	
	/* 조회버튼 클릭 */
	function fn_clcik_search()
	{	
		$("#selectPageNo").val("1");
		fn_search();		
	}
	

	
	/* 페이지 이동 */
	function fn_pageMove(selectPageNo)
	{	
		$("#selectPageNo").val(selectPageNo);
		fn_search();		
	}
	

	/* 테이블 정보 상세 조회 */
	function fn_getTableInfoMstDtl(tableName)
	{	
		var frm = document.form;
		
		$("#TABLE_NAME").val(tableName);
		
    	frm.action = "/UnicaExt/tableInfoMaster.do";
		frm.target = "_self";
    	frm.submit();
	}

	
	/* 테이블 정보 입력페이지 이동 */
	function fn_new_master() {
		var frm = document.form;
		
    	frm.action = "/UnicaExt/tableInfoMaster.do";
    	frm.target = "_self";
        frm.submit();
	};
	
	
	/* 테이블 정보 상세 팝업 출력 */
	function fn_getTableInfoDetail(tableName) {
		var frm = document.form;
		
		$("#TABLE_NAME").val(tableName);
		
		pop = window.open('', 'POP_TABLE_INFO', 'top=150,left=100, location=no,status=no,toolbar=no,scrollbars=yes');
        frm.action = "/UnicaExt/tableInfoDetail.do";
        frm.target = "POP_TABLE_INFO";
        frm.method = "POST";
        frm.submit();
        pop.focus();
	};
	
</script>

    <!--PAGE CONTENT -->
        <div id="content" style="width:100%; height100%;">
           <!--BLOCK SECTION -->
           <div class="row" style="width:100%; height100%;">
              <div class="col-lg-1"></div>
              <div class="col-lg-10">

         <div id="optionDiv" class="col-md-12" style="margin-top:15px;margin-right:0px;padding-right:0px;">
            <div style="display:flex">
              <div style="flex-basis: 100%;">
                <ul id="myTab" class="nav nav-tabs" role="tablist">
                   <li role="presentation" class="">
                      <a href="${staticPATH }/toast/toastList.do">
                        <i class="fa fa-info"></i> 토스트배너 관리 
                      </a>
                   </li>
                   <li role="presentation" class="">
                      <a href="${staticPATH }/testTarget/testTargetList.do" >
                        <i class="fa fa-cog" aria-hidden="true"></i> 테스트대상 관리
                      </a>
                   </li>
                   <li role="presentation" class="">
                      <a href="${staticPATH }/variable/variableList.do">
                        <i class="fa fa-filter"></i> 매개변수 관리
                      </a>
                   </li>
                   <li role="presentation" class="">
                      <a href="${staticPATH }/commCode/commCodeList.do">
                        <i class="fa fa-comments-o"></i> 공통코드 관리
                      </a>
                   </li>
                   <%-- <li role="presentation" class="active">
                      <a href="${staticPATH }/tableInfo/tableInfoList.do">
                        <i class="fa fa-calendar"></i> 테이블정보 관리
                      </a>
                   </li> --%>
                   <li role="presentation" class="">
                      <a href="${staticPATH }/notice/noticeList.do">
                        <i class="fa fa-calendar"></i> 공지사항 관리
                      </a>
                   </li>
                </ul>
              </div>
              <div class="push-right" style="flex-basis: 400px;"></div>
            </div>
            <div id="myTabContent" class="tab-content">

<form name="form" id="form">
<input type="hidden" id="selectPageNo" name="selectPageNo"  value="${selectPageNo}" />
<input type="hidden" id="TABLE_NAME" name="TABLE_NAME"  value="" />

<div id="search" style="text-align:right;margin-bottom:10px;">
    <button type="button" class="btn btn-success btn-sm" onclick="fn_clcik_search();"><i class="fa fa-search" aria-hidden="true"></i> 조회</button>
    <c:if test="${USER.admin_yn eq 'Y' }">
	  <button type="button" class="btn btn-success btn-sm" onclick="fn_new_master();"><i class="fa fa-plus" aria-hidden="true"></i> 등록 </button>
	</c:if>
</div>	
	
<div id="table">
		 <table class="table table-bordered" width="100%" >
			<colgroup>
				<col width="150"/>
				<col width=""/>
			</colgroup>
			<tr >
				<td class="info">테이블명</td>
				<td class="tbtd_content">
					<input type="text" id="STABLE_NAME" name="STABLE_NAME" value="${STABLE_NAME}" style="width:150px;" class="txt"/>
				</td>
			</tr>
		</table>
	</div>

	
	<!-- List -->
	<div id="table">
		 <table class="table table-bordered table-striped table-hover" width="100%">
			<colgroup>
				<col width="40"/>	<!-- No         -->			
				<col width="150"/>  <!-- 테이블명   -->
				<col width="100"/>   <!-- 생성일     -->
				<col width="100"/>   <!-- 최종갱신일 -->
				<col width="100"/>  <!-- 갱신주기   -->
				<col width=""/>     <!-- 테이블정보 -->
				<col width="150"/>  <!-- 세부정보   -->
				<col width="80"/>  <!-- 등록자     -->
				<col width="100"/>  <!-- 등록일시   -->
			</colgroup>
			<tr class="info">
				<th style="text-align:center;">No</th>
				<th style="text-align:center;">테이블명</th>
				<th style="text-align:center;">생성일</th>
				<th style="text-align:center;">최종갱신일</th>
				<th style="text-align:center;">갱신주기</th>
				<th style="text-align:center;">테이블정보</th>
				<th style="text-align:center;">세부정보</th>
				<th style="text-align:center;">등록자</th>
				<th style="text-align:center;">등록일시</th>
			</tr>
			<tbody>
               <tr>
                 <td style="text-align:center;">1</td>
                 <td>TABLE NAME</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">1</td>
                 <td style="text-align:center;">TABLE INFO</td>
                 <td style="text-align:center;">TABLE DETAIL INFO</td>
                 <td style="text-align:center;">ADMIN</td>
                 <td style="text-align:center;">2017-10-27</td>
               </tr>
               <tr>
                 <td style="text-align:center;">1</td>
                 <td>TABLE NAME</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">1</td>
                 <td style="text-align:center;">TABLE INFO</td>
                 <td style="text-align:center;">TABLE DETAIL INFO</td>
                 <td style="text-align:center;">ADMIN</td>
                 <td style="text-align:center;">2017-10-27</td>
               </tr>
               <tr>
                 <td style="text-align:center;">1</td>
                 <td>TABLE NAME</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">1</td>
                 <td style="text-align:center;">TABLE INFO</td>
                 <td style="text-align:center;">TABLE DETAIL INFO</td>
                 <td style="text-align:center;">ADMIN</td>
                 <td style="text-align:center;">2017-10-27</td>
               </tr>
               <tr>
                 <td style="text-align:center;">1</td>
                 <td>TABLE NAME</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">1</td>
                 <td style="text-align:center;">TABLE INFO</td>
                 <td style="text-align:center;">TABLE DETAIL INFO</td>
                 <td style="text-align:center;">ADMIN</td>
                 <td style="text-align:center;">2017-10-27</td>
               </tr>
               <tr>
                 <td style="text-align:center;">1</td>
                 <td>TABLE NAME</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">1</td>
                 <td style="text-align:center;">TABLE INFO</td>
                 <td style="text-align:center;">TABLE DETAIL INFO</td>
                 <td style="text-align:center;">ADMIN</td>
                 <td style="text-align:center;">2017-10-27</td>
               </tr>
               <tr>
                 <td style="text-align:center;">1</td>
                 <td>TABLE NAME</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">1</td>
                 <td style="text-align:center;">TABLE INFO</td>
                 <td style="text-align:center;">TABLE DETAIL INFO</td>
                 <td style="text-align:center;">ADMIN</td>
                 <td style="text-align:center;">2017-10-27</td>
               </tr>
               <tr>
                 <td style="text-align:center;">1</td>
                 <td>TABLE NAME</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">2017-10-27</td>
                 <td style="text-align:center;">1</td>
                 <td style="text-align:center;">TABLE INFO</td>
                 <td style="text-align:center;">TABLE DETAIL INFO</td>
                 <td style="text-align:center;">ADMIN</td>
                 <td style="text-align:center;">2017-10-27</td>
               </tr>
            </tbody>
		</table>
	</div>
	<div id="search_layer"></div>
	<div id="paging_layer" class="s_paging"></div>
	<!-- /List -->
	
</div>
</form>
</div></div>
              </div>
              <div class="col-lg-1"></div>
          </div>
          <!--END BLOCK SECTION -->
          <div class="col-lg-3"></div>

        </div>
        <!--END PAGE CONTENT -->
                      
                      
        
        

<%@ include file="/WEB-INF/views/common/_footer.jsp"%>
