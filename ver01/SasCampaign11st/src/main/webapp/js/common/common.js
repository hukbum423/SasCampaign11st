
/**
 * String.trim()
 * - 공백제거
 */
String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, "");
}

/**
 * String.replaceAll(strSearch, strReplace)
 * - 문자열치환
 */
String.prototype.replaceAll = function(strSearch, strReplace) {
    var returnValue = this;
    while (returnValue.indexOf(strSearch) != -1) {
        returnValue = returnValue.replace(strSearch, strReplace);
    }
    return returnValue;
}

/**
 * keypressNumber()
 * - onkeypress 이벤트(숫자만입력)
 *
 * @return
 */
function keypressNumber() {
    if ( !( (event.keyCode >= 37 && event.keyCode<=57) 
    		|| (event.keyCode >= 96 && event.keyCode <= 105)
            || event.keyCode == 8  
            || event.keyCode == 9)  ){
    	event.returnValue = false;
    }
}
/**
 * keypressNumber()
 * - onkeypress 이벤트(숫자만입력) + 컨트롤 V가능
 *
 * @return
 */
function keypressNumber2() {
	if ( !( (event.keyCode >= 37 && event.keyCode<=57) 
			|| (event.keyCode >= 96 && event.keyCode <= 105)
			|| event.keyCode == 8  
			|| event.keyCode == 9
			|| (event.ctrlKey && event.keyCode == 86))  ){
		event.returnValue = false;
	}
}

/**
 * keypressDotNumber()
 * - onkeypress 이벤트(숫자/dot만입력)
 *
 * @return
 */
function keypressDotNumber() {
    if (((event.keyCode < 48) || (57 < event.keyCode)) && (46 != event.keyCode)) event.returnValue=false;
}
/**
 * keyupNextTab(input, next, inputlen)
 * - onkeyup 이벤트(입력값체크후다음입력필드로이동)
 *
 * @param input
 * @param next
 * @param inputlen
 * @return
 */
function keyupNextTab(input, next, inputlen) {
    if (input.value.length == inputlen) {
        next.focus();
        return;
    }
}

/**
 * isNumeric(str)
 * - 숫자체크
 *
 * @param str
 * @return
 */
function isNumeric(str) {
    var regExp = /\D/i;
    if (regExp.test(str)) return false;
    else return true;
}

/**
 * isAlpha(str)
 * - 영문체크
 *
 * @param str
 * @return
 */
function isAlpha(str) {
    var regExp = /[^a-z]/i;
    if (regExp.test(str)) return false;
    else return true;
}
/**
 * isAlphaNumeric(str)
 * - 영문/숫자체크
 *
 * @param str
 * @return
 */
function isAlphaNumeric(str) {
    var regExp = /[^a-z0-9]/i;
    if (regExp.test(str)) return false;
    else return true;
}
/**
 * isHangul(str)
 * - 한글체크(문자열에한글이외의값이있다면:false)
 *
 * @param str
 * @return
 */
function isHangul(str) {
    if (str.length > 0 ) {
        for (var i = 0; i < str.length; i++)
            if (str.charCodeAt(i) < 128 )
                return false;
    }
    return true;
}
/**
 * isHangulNumeric(str)
 * - 한글/숫자체크
 * 
 * @param str
 * @return
 */
function isHangulNumeric(str) {
    for (var i = 0; i < str.length; i++) {
        var chr = str.substr(i, 1);
        if (!(chr < '0' || chr > '9')) continue; // 숫자
        chr = escape(chr);
        if (chr.charAt(1) == 'u') {
            chr = chr.substr(2, (chr.length - 1));
            if((chr < 'AC00') || (chr > 'D7A3'))
                return false;
        } else return false;
    }
    return true;
}
/**
 * isBlank(str)
 * - 공백문자체크(공백으로만된경우:false)
 *
 * @param str
 * @return
 */
function isBlank(str) {
    var regExp = /^[\s]+$/i;
    if (regExp.test(str) || str.length == 0) return false;
    else return true;
}
/**
 * isWithBlank(str)
 * - 공백포함체크(문자열에공백이포함된경우 :false)
 *
 * @param str
 * @return
 */
function isWithBlank(str) {
    var regExp = /\s/i;
    if (regExp.test(str)) return false;
    else return true;
}
/**
 * nvl(str1,str2)
 * - 공백문자 치환
 *
 * @param str
 * @return
 */
function nvl(str1,str2) {
    var regExp = /^[\s]+$/i;
    if ( str1 == "" || str1==null) return str2;
    else return str1;
}
/**
 * 숫자콤마표시
 *
 * @param nu
 * @param allowDot
 * @return
 */
function numericComma(nu, allowDot) {
    var sign = "";

    nu = new String(nu);
    nu = nu.replace(/,/gi,"");

    if (allowDot == undefined || allowDot == 0) {
        nu = nu.replace(/\./gi,"");
    }

    nu = new Number(nu);

    if (isNaN(nu)) {
        alert("숫자만 입력할 수 있습니다.");
        return 0;
    }
    if (nu == 0) {
        return nu;
    }
    if (nu < 0) {
        //nu = nu * (-1);
        //sign = "-";
        return 0;
    } else {
        nu = nu * 1;
    }

    nu = new String(nu);
    var temp = "";
    var pos = 3;

    nu_len = nu.length;
    while (nu_len>0) {
        nu_len = nu_len - pos;
        if (nu_len < 0) {
            pos = nu_len + pos;
            nu_len = 0;
        }
        temp = "," + nu.substr(nu_len,pos) + temp;
    }

    return sign + temp.substr(1);
}

/**
 * 오른쪽채움
 *
 * @param str
 * @param lengthN
 * @param padChar
 * @return
 */
function rightPad(str, lengthN, padChar) {
    var addStr = "";
    var count = lengthN - ("" + str).length;
    if (count > 0) {
        var strPad = (padChar != undefined) ? padChar : "0";
        for (var i = 0; i < count; i++)
            addStr += strPad;
    }

    return addStr.concat(str);
}
/**
 * 좌측채움
 *
 * @param str
 * @param lengthN
 * @param padChar
 * @return
 */
function leftPad(str, lengthN, padChar) {
    var addStr = "";
    var count = lengthN - ("" + str).length;
    if (count > 0) {
        var strPad = (padChar != undefined) ? padChar : "0";
        for (var i = 0; i < count; i++)
            addStr += strPad;
    }

    return addStr.concat(str);
}
/************************* DATE *************************/
/**
 * chkDate(year, month, day)
 * - 날짜유효체크
 *
 * @param inYear
 * @param inMonth
 * @param inDay
 * @return
 */
function chkDate(inYear, inMonth, inDay) {
    var year, month, day;

    if (new String(inYear).length == 8 && inMonth == undefined && inDay == undefined) {
        year = new String(inYear).substr(0, 4);
        month = new String(inYear).substr(4, 2);
        day = new String(inYear).substr(6, 2);
    } else {
        year = inYear;
        month = inMonth;
        day = inDay;
    }

    var inDate = Math.abs(month) + "/" + Math.abs(day) + "/" + Math.abs(year);
    var objDate = new Date(Date.parse(inDate));
    var cmpDate = (objDate.getMonth() + 1) + "/" + objDate.getDate() + "/" + objDate.getFullYear();

    if (cmpDate == "NaN/NaN/NaN") return 0;
    else if (inDate == cmpDate) return 1;
    else return -1;
}


/**
Javascript에서 문자열 자르기
string String::cut(int len) * 한글도 고려하여 길이 리턴 */

String.prototype.cut = function(len) {
	var str = this;
	var s = 0;
	for (var i=0; i<str.length; i++) {
	s += (str.charCodeAt(i) > 128) ? 2 : 1;
	if (s > len) return str.substring(0,i) + "...";
	} 
	return str;
} 

String.prototype.cut2 = function(len) {
	var str = this;
	var s = 0;
	for (var i=0; i<str.length; i++) {
		s += (str.charCodeAt(i) > 128) ? 2 : 1;
		if (s > len) return str.substring(0,i);
	} 
	return str;
}

// KANG-20190411: for pagination
function pagingNavi(selectPage, pageRange, pageStart, pageEnd, totalPage){
	if (true) {
		var msg = " => ";
		msg += "selectPage=" + selectPage;
		msg += ", pageRange=" + pageRange;
		msg += ", pageStart=" + pageStart;
		msg += ", pageEnd=" + pageEnd;
		msg += ", totalPage=" + totalPage;
		//msg += ", pageMove=" + pageMove;
		console.log("KANG.pagingMavi:" + msg);
	}
	var page = "";
	//이전페이지 만들기
	if (selectPage > pageRange) {
		page +="<a href=\"javascript:fn_pageMove("+ (Number(result.pageStart) - Number(result.pageRange)) +" );\" ><img src=\"<c:url value='/img/btn_left.gif'/>\" width='13px;' height='13px;' /></a>&nbsp;";
	}
	//페이지 숫자
	for (var i = pageStart; i <= pageEnd; i++) {
		var tmpActive = "";
		if(selectPage == i)	{ 
			tmpActive = "style='background-color:#EEEEEE'";
		}
		
		page += "<li ><a href=\"javascript:fn_pageMove(" + i + ");\" " + tmpActive + ">" + i + "</a></li>";
	}
	//다음페이지 만들기
	if (totalPage != pageEnd) {
		page +="&nbsp;<a href=\"javascript:fn_pageMove("+ (Number(result.pageStart) + Number(result.pageRange)) +" );\" ><img src=\"<c:url value='/img/btn_right.gif'/>\" width='13px;' height='13px;' /></a>";
	}
	return page;
}


function nvl(str, defaultVal) {
  var defaultValue = "";
   
  if (typeof defaultVal != 'undefined') {
      defaultValue = defaultVal;
  }
   
  if (typeof str == "undefined" || str == null || str == '' || str == "undefined") {
      return defaultValue;
  }
   
  return str;
}
