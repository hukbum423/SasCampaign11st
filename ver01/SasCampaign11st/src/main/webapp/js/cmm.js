
		var submitchk = function() { 

			if ($.trim($("#grp_id").val()) == "") {  
				alert("그룹ID를 입력해주세요.");  
				$("#grp_id").focus();  
				return false;  
			}

			if ($.trim($("#grp_nm").val()) == "") {  
				alert("그룹명을 입력해주세요.");  
				$("#grp_nm").focus();  
				return false;  
			}
			
			if ($.trim($("#cd_length").val()) == "") {  
				alert("공통 코드길이를 입력해주세요.");  
				$("#cd_length").focus();  
				return false;  
			}
			
			grpAddAjaxProc();
			
		};

		var cmmsubmitchk = function(){
			if ($.trim($("#cmm_id").val()) == "") {  
				alert("공통코드ID를 입력해주세요.");  
				$("#cmm_id").focus();  
				return false;  
			}

			if ($.trim($("#cmm_nm").val()) == "") {  
				alert("공통코드명을 입력해주세요.");  
				$("#cmm_nm").focus();  
				return false;  
			}
			
			cmmAddAjaxProc();
		};

		$(
			function(){
				// 초기화 등록폼 변경
				$('#formreset').click(function(){
					$('#mode').val('add');
					$('#frmGrp').each(function() {  
			            this.reset(); 
					});

					$('#grpaddbtn').text('그룹 등록');
					$('#grptitle').text('그룹 등록');
					
					$('#grp_id').attr("readonly",false);

					$('#del').remove();
				});
			}
		);

		// 그룹ID 수정
		var grpcmmmodi = function(grp_id, grp_nm, cd_length, grp_flag){
			$('#grp_id').val(grp_id);
			$('#grp_nm').val(grp_nm);
			$('#cd_length').val(cd_length);
			if(grp_flag == 'Y'){
				$('input:radio[name="grp_flag"][value="Y"]').prop('checked', true);
			}else{
				$('input:radio[name="grp_flag"][value="N"]').prop('checked', true);
			}
			$('#mode').val('modi');
			$('#grpaddbtn').text('수정');
			$('#grptitle').text('그룹 수정');

			$('#grp_id').attr("readonly",true);
			if ( $("#del").length == 0 ) {
				$('#tdbtn').append(' <button type="button" class="btn btn-xs btn-danger btn-line" id="del">삭제</button>');
				
				// 그룹 삭제 클릭
				$('#del').click(function(){
					if(confirm('\n그룹코드를 삭제하면 하위 공통코드가 모두 삭제되며'
							+'\n복구가 불가능 하게됩니다.\n\n삭제하시겠습니까?')){
						removeAjaxProc();
					}
				});
			}

			selCmmlist(); //클릭한 그룹 공통코드리스트

			$("#cmmDiv").hide();

		};

		var cmmFormReset = function(cd_length){
			$("#cmm_grp_id").val($("#grp_id").val());
			$("#cmm_id").attr('maxlength', cd_length);
			$("#modecmm").val('add');
			$('#cmmId').removeClass('has-error')
			$("#cmmDiv").show();
		}

		var cmmFormSubReset = function(cd_length){
			$("#cmm_grp_id").val($("#grp_id").val());
			$("#cmm_id").attr('maxlength', cd_length);
			$("#modecmm").val('add');
			$('#cmmId').removeClass('has-error')
			$("#cmmDiv").show();
		}
		
		// 공통코드 목록
		var selCmmlist = function(){
	  		$.ajax({
	  			type : "POST",
	  			data : 
	  			{
	  				"grp_id" 	: $("#grp_id").val(),
	  			},
	  			dataType: "json",
	  			url : '/cmm/ajax_cmm_list.do',
	  			success : function(data)
	  			{
	  				$("#tree").html(data.msg);
	  			}
	  			,beforeSend:function(){
	  			}
	  			,complete:function(){

		  			// 공통코드 + 클릭시
	  				$('button[id^=cmmsubadd]').click(function(event){
	  					var str = event.target.id;
	  					var cmm_id = str.split('_');

	  					getCmmResult(cmm_id[1], cmm_id[2], 'add');
					});
		  			// 공통코드 ↑ 클릭시
	  				$('button[id^=cmmsubup]').click(function(event){
	  					var str = event.target.id;
	  					var cmm = str.split('_');
	  					if(cmm[3] == '0' || cmm[2] == '2'){
	  						alert('최상위 항목은 이동이 불가능 합니다.');
	  					}else{
		  					cmmsubup(cmm[1], cmm[2], cmm[3], cmm[4]);
	  					}
					});
		  			// 공통코드 ↓ 클릭시  
	  				$('button[id^=cmmsubdown]').click(function(event){
	  					var str = event.target.id;
	  					var cmm = str.split('_');
	  					
	  					cmmsubdown(cmm[1], cmm[2], cmm[3], cmm[4]);
					});
					
		  			// 공통코드 수정시
	  				$('span[id^=cmm_li_]').click(function(event){
	  					var str = event.target.id;
	  					var cmm_id = str.split('_');

	  					getCmmResult(cmm_id[2], cmm_id[3], 'modi');
					});

		  			// 공통코드 - 클릭시
	  				$('button[id^=cmmsubdel]').click(function(event){
	  					var str = event.target.id;
	  					var cmm_id = str.split('_');

	  					if(confirm("삭제하시겠습니까?")){
	  						delCmmCode(cmm_id[1], cmm_id[2]);
	  					}
					});

	  				// 공통코드 정렬 Up
	  				var cmmsubup = function(cmm_id, cmm_ord, cmm_lev, grp_id){
	  			  		$.ajax({
	  			  			type : "POST",
	  			  			data : 
	  			  			{
	  			  				"cmm_id" 	: cmm_id,
	  			  				"cmm_lev" 	: cmm_lev,
	  			  				"cmm_ord" 	: cmm_ord,
	  			  				"grp_id" 	: grp_id
	  			  			},
	  			  			dataType: "json",
	  			  			url : '/cmm/ajax_cmm_subup_proc.do',
	  			  			success : function(data)
	  			  			{
	  			  				if(data.code == '0'){
		  			  				alert(data.msg);
		  			  				selCmmlist();
	  			  				}else if(data.code == '99'){
	  			  					alert(data.msg);
	  			  				}else{
	  			  					alert("error_code : " + data.code + "\n" +
	  		  			  					"error msg : " +  data.msg);
	  			  				}
	  			  			}
	  			  			,beforeSend:function(){
	  			  			}
	  			  			,complete:function(){
	  			  			}
	  			  		})
	  			  	};
	  			  	
	  				// 공통코드 정렬 Down
	  				var cmmsubdown = function(cmm_id, cmm_ord, cmm_lev, grp_id){
	  			  		$.ajax({
	  			  			type : "POST",
	  			  			data : 
	  			  			{
	  			  				"cmm_id" 	: cmm_id,
	  			  				"cmm_lev" 	: cmm_lev,
	  			  				"cmm_ord" 	: cmm_ord,
	  			  				"grp_id" 	: grp_id
	  			  			},
	  			  			dataType: "json",
	  			  			url : '/cmm/ajax_cmm_subdown_proc.do',
	  			  			success : function(data)
	  			  			{
	  			  				if(data.code == '0'){
		  			  				alert(data.msg);
		  			  				selCmmlist();
	  			  				}else if(data.code == '99'){
	  			  				alert(data.msg);
	  			  				}else{
	  			  					alert("error_code : " + data.code + "\n" +
	  		  			  					"error msg : " +  data.msg);
	  			  				}
	  			  			}
	  			  			,beforeSend:function(){
	  			  			}
	  			  			,complete:function(){
	  			  			}
	  			  		})
	  			  	};
	  			  	
	  				// 공통코드ID로 공통코드 데이터 가져옴
	  				var getCmmResult = function($cmm_id, $grp_id, $mode){
	  			  		$.ajax({
	  			  			type : "POST",
	  			  			data : 
	  			  			{
	  			  				"cmm_id" 	: $cmm_id,
	  			  				"grp_id" 	: $grp_id,
	  			  				"mode" 		: $mode,
	  			  			},
	  			  			dataType: "json",
	  			  			url : '/cmm/ajax_cmm_view.do',
	  			  			success : function(data)
	  			  			{
	  			  				cmmsubadd(data, $mode);
	  			  			}
	  			  			,beforeSend:function(){
	  			  			}
	  			  			,complete:function(){
	  			  			}
	  			  		})
	  			  	};

	  				// 공통코드ID로 해당 공통코드 삭제처리
	  				var delCmmCode = function($cmm_id, $grp_id){
	  			  		$.ajax({
	  			  			type : "POST",
	  			  			data : 
	  			  			{
	  			  				"cmm_id" 	: $cmm_id,
	  			  				"grp_id" 	: $grp_id,
	  			  			},
	  			  			dataType: "json",
	  			  			url : '/cmm/ajax_cmm_del_proc.do',
	  			  			success : function(data)
	  			  			{
	  			  				if(data.code == '0'){
		  			  				alert(data.msg);
		  			  				selCmmlist();
	  			  				}else{
	  			  					alert("error_code : " + data.code + "\n" +
	  		  			  					"error msg : " +  data.msg);
	  			  				}
	  			  			}
	  			  			,beforeSend:function(){
	  			  			}
	  			  			,complete:function(){
	  			  			}
	  			  		})
	  			  	};
	  			}
	  		})
	  	};

	  	// 공통코드 서브 등록시
	  	var cmmsubadd = function(data, mode){
		  	if(mode == 'add'){
			  	$("#cmmtitle").html("<strong>공통코드 등록</strong>");
		  		$("#cmmDiv").show();
		  		
		  		$("#cmm_grp_id").val(data.grp_id);
		  		$("#pa_cmm_id").val(data.cmm_id);
		  		$("#cmm_id").val('');
		  		$("#cmm_id").attr("readonly", false);
		  		$("#cmm_nm").val('');
		  		$("#modeCmm").val('subadd');
		  		$("#cmm_lev").val(data.cmm_lev);
		  		$("#cmm_ord").val(data.cmm_ord);
		  		$("#child_cnt").val(data.child_cnt);
		  		$("#cmm_id").attr('maxlength', $('#cd_length').val());
		  		$("#var1").val('');
		  		$("#var2").val('');
		  	}else if(mode == 'modi'){
			  	$("#cmmtitle").html("<strong>공통코드 수정</strong>");
		  		$("#cmmDiv").show();
		  		$("#cmm_grp_id").val(data.grp_id);
		  		$("#cmm_id").val(data.cmm_id);
		  		$("#cmm_id").attr("readonly", true);
		  		$("#cmm_nm").val(data.cmm_nm);

		  		pa_cmm_hist = data.pa_cmm_hist;
		  		pa_cmm_ids = pa_cmm_hist.split('|');
		  		
		  		$("#pa_cmm_id").val(pa_cmm_ids[(pa_cmm_ids.length-1)]);
		  		$("#modeCmm").val('submodi');
		  		$("#cmm_id").attr('maxlength', $('#cd_length').val());

				if(data.cmm_flag == 'Y'){
					$('input:radio[name="cmm_flag"][value="Y"]').prop('checked', true);
				}else{
					$('input:radio[name="cmm_flag"][value="N"]').prop('checked', true);
				}

				$("#cmmaddbtn").text('코드수정');
				
				$("#var1").val(data.var1);
				$("#var2").val(data.var2);
		  	}
	  	};

		// 그룹ID로 그룹 데이터 가져옴
		var getGrpResult = function($grp_id){
	  		$.ajax({
	  			type : "POST",
	  			data : 
	  			{
	  				"grp_id" 	: $grp_id,
	  			},
	  			dataType: "json",
	  			url : '/cmm/get_grp_result_ajax_proc',
	  			success : function(data)
	  			{
		  			grpcmmmodi(data.grp_id, data.grp_nm, data.cd_length, data.grp_flag);
	  			}
	  			,beforeSend:function(){
	  			}
	  			,complete:function(){
	  			}
	  		})
	  	};

		// 그룹ID 삭제
		var removeAjaxProc = function(){
	  		$.ajax({
	  			type : "POST",
	  			data : 
	  			{
	  				"grp_id" 	: $("#grp_id").val(),
	  			},
	  			dataType: "html",
	  			url : '/cmm/ajax_grp_cmm_del_proc.do',
	  			success : function(data)
	  			{
	  				alert(data.msg);
	  				location.href='/cmm/main.do'
	  			}
	  			,beforeSend:function(){
	  			}
	  			,complete:function(){
	  			}
	  		})
	  	};

	  	// 그룹ID 등록 / 수정
		var grpAddAjaxProc = function(){
	  		$.ajax({
	  			type : "POST",
	  			data : 
	  			{
	  				"grp_id" 	: $("#grp_id").val(),
	  				"grp_nm" 	: $("#grp_nm").val(),
	  				"cd_length"	: $("#cd_length").val(),
	  				"grp_flag" 	: $("input[name=grp_flag]:checked").val(),
	  				"mode" 		: $("#mode").val(),
	  			},
	  			dataType: "json",
	  			url : '/cmm/ajax_grp_cmm_proc.do',
	  			success : function(data)
	  			{
  					if(data.code == '0'){
		  				alert("그룹코드가 "+data.msg);
		  				location.href='/cmm/main.do?grp_id='+data.grp_id;
		  			}else if(data.code == '1062'){
		  				alert("그룹코드가 존재합니다.");
		  				
		  				$("#grp_id").addClass('has-error'); 
		  				$("#grp_id").focus();
		  			}else{
			  			alert("error Code : " + data.code +
					  			"error Message : " + data.msg);
		  			}
	  			}
	  			,beforeSend:function(){
	  			}
	  			,complete:function(){
	  			}
	  		})
	  	};

	  	// 공통코드 등록 / 수정
		var cmmAddAjaxProc = function(){

	  		$.ajax({
	  			type : "POST",
	  			data : 
	  			{
	  				"cmm_grp_id"	: $("#cmm_grp_id").val(),
	  				"cmm_id" 		: $("#cmm_id").val(),
	  				"cmm_nm" 		: $("#cmm_nm").val(),
	  				"pa_cmm_id"		: $("#pa_cmm_id").val(),
	  				"cmm_ord"		: $("#cmm_ord").val(),
	  				"cmm_lev"		: $("#cmm_lev").val(),
	  				"cmm_flag" 		: $("input[name=cmm_flag]:checked").val(),
	  				"child_cnt"		: $("#child_cnt").val(),
	  				"var1"			: $("#var1").val(),
	  				"var2"			: $("#var2").val(),
	  				"modeCmm" 		: $("#modeCmm").val(),
	  			},
	  			dataType: "json",
	  			url : '/cmm/ajax_cmm_proc.do',
	  			success : function(data)
	  			{
		  			if(data.code == '0'){
		  				alert("공통코드가 "+data.msg);
		  				selCmmlist();
		  			}else if(data.error_code == '1062'){
		  				alert("공통코드ID가 존재합니다.");
		  				
		  				$("#cmmId").addClass('has-error'); 
		  				$("#cmm_id").focus();
		  			}else{
			  			alert("error Code : " + data.error_code +
					  			"error Message : " + data.message);
		  			}
				  			
	  			}
	  			,beforeSend:function(){
	  			}
	  			,complete:function(){
	  			}
	  		})
	  	};