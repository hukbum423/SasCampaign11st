<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head lang="en">
	<meta charset="UTF-8">
	<title></title>
	<script src="http://d3js.org/d3.v3.min.js" language="JavaScript"></script>
	<script src="${staticPATH }/js/liquidFillGauge.js" language="JavaScript"></script>
	<style>
		.liquidFillGaugeText { font-family: Helvetica; font-weight: bold; }
	</style>
</head>


<body>
<table border="0" cellpadding="0" cellspacing="0" width="93%" height="90%">
	<tr>
		<td align="center"><svg id="fillgauge1" width="100px" height="100px"></svg><br/> 반응고객</td>
		<td align="center"><svg id="fillgauge2" width="100px" height="100px"></svg><br/>거래액</td>
	</tr>
	<tr height="20"><td></td>&nbsp;<td></td></tr>
	<tr>
		<td align="center"><svg id="fillgauge3" width="100px" height="100px"></svg><br/>비용</td>
		<td align="center"><svg id="fillgauge4" width="100px" height="100px"></svg><br/>순매출</td>
	</tr>
</table>

<!-- onclick="gauge4.update(NewValue());" -->
<script language="JavaScript">
	<c:forEach items="${crmMonthList }" var="list">
		<c:set var="fill1" value="${list.cust_goal}"/>
		<c:set var="fill2" value="${list.amt_goal}"/>
		<c:set var="fill3" value="${list.dis_goal}"/>
		<c:set var="fill4" value="${list.pure_amt_goal}"/>
	</c:forEach>

	var gauge1 = loadLiquidFillGauge("fillgauge1", <c:out value='${fill1}'/>);
	var config1 = liquidFillGaugeDefaultSettings();
	config1.circleColor = "#FF0000";
	config1.textColor = "#FF4444";
	config1.waveTextColor = "#222222";
	config1.waveColor = "#FFDDDD";
	config1.circleThickness = 0.2;
	config1.textVertPosition = 0.2;
	config1.waveAnimateTime = 1000;
	
	var gauge2= loadLiquidFillGauge("fillgauge2", <c:out value='${fill2}'/>);
	var config2 = liquidFillGaugeDefaultSettings();
	config2.circleColor = "#FF7777";
	config2.textColor = "#FF4444";
	config2.waveTextColor = "#FFAAAA";
	config2.waveColor = "#FFDDDD";
	config2.circleThickness = 0.2;
	config2.textVertPosition = 0.2;
	config2.waveAnimateTime = 1000;
	
	var gauge3 = loadLiquidFillGauge("fillgauge3", <c:out value='${fill3}'/>);
	var config3 = liquidFillGaugeDefaultSettings();
	config3.circleColor = "#FF7777";
	config3.textColor = "#FF4444";
	config3.waveTextColor = "#FFAAAA";
	config3.waveColor = "#FFDDDD";
	config3.circleThickness = 0.2;
	config3.textVertPosition = 0.2;
	config3.waveAnimateTime = 1000;
	
	var gauge4 = loadLiquidFillGauge("fillgauge4", <c:out value='${fill4}'/>);
	var config4 = liquidFillGaugeDefaultSettings();
	config4.circleColor = "#FF7777";
	config4.textColor = "#FF4444";
	config4.waveTextColor = "#FFAAAA";
	config4.waveColor = "#FFDDDD";
	config4.circleThickness = 0.2;
	config4.textVertPosition = 0.2;
	config4.waveAnimateTime = 1000;

	function NewValue(){
		/* 
		if (Math.random() > .5) {
			return Math.round(Math.random()*100);
		} else {
			return (Math.random()*100).toFixed(1);
		} 
		*/
	}
</script>
</body>
</html>
