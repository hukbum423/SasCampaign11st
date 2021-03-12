var dateOption ={
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월' ],
		dayNamesMin: ['일','월','화','수','목','금','토'],
		// 달력 아이콘
		showOn: "button",
		buttonImage: "/SASCampaign/image/calendar.gif",
		buttonImageOnly: true,
		buttonText:"달력",
		// 달력 하단의 종료와 오늘 버튼 Show
		showButtonPanel: true,
		// date 포멧
		dateFormat : "yy-mm-dd",
		// 달력 에니메이션 ( show(default),slideDown,fadeIn,blind,bounce,clip,drop,fold,slide,"")
		showAnim : "fadeIn",
		// 다른 달의 일 보이기, 클릭 가능
		showOtherMonths: true,
 		selectOtherMonths: true,
 		// 년도, 달 변경
 		changeMonth: true,
 		changeYear: true,
 		// 여러달 보이기
 		numberOfMonths: 1,
  		showButtonPanel: false,
  		// 달력 선택 제한 주기(min: 현재부터 -20일,max:현재부터 +1달+10일)
  		//minDate: -20,
  		//maxDate: "+1M +10D",
  		// 주차 보여주기
  		showWeek: false,
  		firstDay: 1
};