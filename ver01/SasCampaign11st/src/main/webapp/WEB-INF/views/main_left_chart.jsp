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
	<!-- Styles -->
	<style>
		html, body {
			width: 99%; height: 97%;
		}
		#chartdiv {
			width   : 100%;
			height    : 100%;
			font-size : 12px;
		}
	</style>

<!-- Resources -->
<script src="${staticPATH }/js/amcharts.js"></script>
<script src="${staticPATH }/js/serial.js"></script>
<script src="${staticPATH }/js/export.min.js"></script>
<link rel="stylesheet" href="${staticPATH }/css/export.css" type="text/css" media="all" />
<script src="${staticPATH }/js/light.js"></script>

<!-- Chart code -->
<script>
	var chartData = generatechartData();

	function generatechartData() {
		var chartData = [];
		var firstDate = new Date();
		firstDate.setDate(firstDate.getDate() - 150);
		var visits = 500;

		/*
		for (var i = 0; i < 150; i++) {
			// we create date objects here. In your data, you can have date strings
			// and then set format of your dates using chart.dataDateFormat property,
			// however when possible, use date objects, as this will speed up chart rendering.
			var newDate = new Date(firstDate);
			newDate.setDate(newDate.getDate() + i);

			visits += Math.round((Math.random()<0.5?1:-1)*Math.random()*10);

			console.log("newDate : " + newDate + " ::: visits : " + visits);
			chartData.push({
				date: newDate,
				visits: visits
			});
		}
		*/

		/*
		chartData.push({date:new Date("2017-07-23"),visits:"14"});
		chartData.push({date:new Date("2017-07-24"),visits:"24"});
		chartData.push({date:new Date("2017-07-25"),visits:"16"});
		chartData.push({date:new Date("2017-07-26"),visits:"12"});
		chartData.push({date:new Date("2017-07-27"),visits:"10"});
		chartData.push({date:new Date("2017-07-28"),visits:"16"});
		chartData.push({date:new Date("2017-07-29"),visits:"11"});
		chartData.push({date:new Date("2017-07-30"),visits:"12"});
		chartData.push({date:new Date("2017-07-31"),visits:"23"});
		chartData.push({date:new Date("2017-08-01"),visits:"27"});
		chartData.push({date:new Date("2017-08-02"),visits:"23"});
		chartData.push({date:new Date("2017-08-03"),visits:"28"});
		chartData.push({date:new Date("2017-08-04"),visits:"18"});
		chartData.push({date:new Date("2017-08-05"),visits:"6"});
		chartData.push({date:new Date("2017-08-06"),visits:"4"});
		chartData.push({date:new Date("2017-08-07"),visits:"11"});
		chartData.push({date:new Date("2017-08-08"),visits:"11"});
		chartData.push({date:new Date("2017-08-09"),visits:"19"});
		chartData.push({date:new Date("2017-08-10"),visits:"17"});
		chartData.push({date:new Date("2017-08-11"),visits:"20"});
		chartData.push({date:new Date("2017-08-12"),visits:"9"});
		chartData.push({date:new Date("2017-08-13"),visits:"8"});
		chartData.push({date:new Date("2017-08-14"),visits:"11"});
		chartData.push({date:new Date("2017-08-15"),visits:"9"});
		chartData.push({date:new Date("2017-08-16"),visits:"21"});
		chartData.push({date:new Date("2017-08-17"),visits:"21"});
		chartData.push({date:new Date("2017-08-18"),visits:"17"});
		chartData.push({date:new Date("2017-08-19"),visits:"12"});
		chartData.push({date:new Date("2017-08-20"),visits:"17"});
		chartData.push({date:new Date("2017-08-21"),visits:"26"});
		chartData.push({date:new Date("2017-08-22"),visits:"32"});
		chartData.push({date:new Date("2017-08-23"),visits:"22"});
		chartData.push({date:new Date("2017-08-24"),visits:"10"});
		chartData.push({date:new Date("2017-08-25"),visits:"5"});
		chartData.push({date:new Date("2017-08-26"),visits:"6"});
		chartData.push({date:new Date("2017-08-27"),visits:"7"});
		chartData.push({date:new Date("2017-08-28"),visits:"21"});
		chartData.push({date:new Date("2017-08-29"),visits:"20"});
		chartData.push({date:new Date("2017-08-30"),visits:"20"});
		chartData.push({date:new Date("2017-08-31"),visits:"21"});
		chartData.push({date:new Date("2017-09-01"),visits:"20"});
		chartData.push({date:new Date("2017-09-02"),visits:"11"});
		chartData.push({date:new Date("2017-09-03"),visits:"14"});
		chartData.push({date:new Date("2017-09-04"),visits:"23"});
		chartData.push({date:new Date("2017-09-05"),visits:"16"});
		chartData.push({date:new Date("2017-09-06"),visits:"12"});
		chartData.push({date:new Date("2017-09-07"),visits:"12"});
		chartData.push({date:new Date("2017-09-08"),visits:"16"});
		chartData.push({date:new Date("2017-09-09"),visits:"19"});
		chartData.push({date:new Date("2017-09-10"),visits:"13"});
		chartData.push({date:new Date("2017-09-11"),visits:"34"});
		chartData.push({date:new Date("2017-09-12"),visits:"30"});
		chartData.push({date:new Date("2017-09-13"),visits:"26"});
		chartData.push({date:new Date("2017-09-14"),visits:"34"});
		chartData.push({date:new Date("2017-09-15"),visits:"21"});
		chartData.push({date:new Date("2017-09-16"),visits:"6"});
		chartData.push({date:new Date("2017-09-17"),visits:"4"});
		chartData.push({date:new Date("2017-09-18"),visits:"13"});
		chartData.push({date:new Date("2017-09-19"),visits:"13"});
		chartData.push({date:new Date("2017-09-20"),visits:"22"});
		chartData.push({date:new Date("2017-09-21"),visits:"15"});
		chartData.push({date:new Date("2017-09-22"),visits:"18"});
		chartData.push({date:new Date("2017-09-23"),visits:"12"});
		chartData.push({date:new Date("2017-09-24"),visits:"15"});
		chartData.push({date:new Date("2017-09-25"),visits:"26"});
		chartData.push({date:new Date("2017-09-26"),visits:"15"});
		chartData.push({date:new Date("2017-09-27"),visits:"17"});
		chartData.push({date:new Date("2017-09-28"),visits:"12"});
		chartData.push({date:new Date("2017-09-29"),visits:"9"});
		chartData.push({date:new Date("2017-09-30"),visits:"6"});
		chartData.push({date:new Date("2017-10-01"),visits:"6"});
		chartData.push({date:new Date("2017-10-02"),visits:"6"});
		chartData.push({date:new Date("2017-10-03"),visits:"5"});
		chartData.push({date:new Date("2017-10-04"),visits:"5"});
		chartData.push({date:new Date("2017-10-05"),visits:"7"});
		chartData.push({date:new Date("2017-10-06"),visits:"8"});
		chartData.push({date:new Date("2017-10-07"),visits:"7"});
		chartData.push({date:new Date("2017-10-08"),visits:"6"});
		chartData.push({date:new Date("2017-10-09"),visits:"9"});
		chartData.push({date:new Date("2017-10-10"),visits:"22"});
		chartData.push({date:new Date("2017-10-11"),visits:"30"});
		chartData.push({date:new Date("2017-10-12"),visits:"21"});
		chartData.push({date:new Date("2017-10-13"),visits:"20"});
		chartData.push({date:new Date("2017-10-14"),visits:"14"});
		chartData.push({date:new Date("2017-10-15"),visits:"16"});
		chartData.push({date:new Date("2017-10-16"),visits:"39"});
		chartData.push({date:new Date("2017-10-17"),visits:"27"});
		chartData.push({date:new Date("2017-10-18"),visits:"12"});
		chartData.push({date:new Date("2017-10-19"),visits:"6"});
		chartData.push({date:new Date("2017-10-20"),visits:"9"});
		chartData.push({date:new Date("2017-10-21"),visits:"6"});
		chartData.push({date:new Date("2017-10-22"),visits:"14"});
		chartData.push({date:new Date("2017-10-23"),visits:"22"});
		chartData.push({date:new Date("2017-10-24"),visits:"21"});
		chartData.push({date:new Date("2017-10-25"),visits:"21"});
		chartData.push({date:new Date("2017-10-26"),visits:"19"});
		chartData.push({date:new Date("2017-10-27"),visits:"16"});
		chartData.push({date:new Date("2017-10-28"),visits:"11"});
		chartData.push({date:new Date("2017-10-29"),visits:"14"});
		chartData.push({date:new Date("2017-10-30"),visits:"25"});
		chartData.push({date:new Date("2017-10-31"),visits:"24"});
		chartData.push({date:new Date("2017-11-01"),visits:"36"});
		chartData.push({date:new Date("2017-11-02"),visits:"30"});
		chartData.push({date:new Date("2017-11-03"),visits:"26"});
		chartData.push({date:new Date("2017-11-04"),visits:"17"});
		chartData.push({date:new Date("2017-11-05"),visits:"20"});
		chartData.push({date:new Date("2017-11-06"),visits:"23"});
		chartData.push({date:new Date("2017-11-07"),visits:"17"});
		chartData.push({date:new Date("2017-11-08"),visits:"16"});
		chartData.push({date:new Date("2017-11-09"),visits:"26"});
		chartData.push({date:new Date("2017-11-10"),visits:"27"});
		chartData.push({date:new Date("2017-11-11"),visits:"45"});
		chartData.push({date:new Date("2017-11-12"),visits:"21"});
		chartData.push({date:new Date("2017-11-13"),visits:"37"});
		chartData.push({date:new Date("2017-11-14"),visits:"17"});
		chartData.push({date:new Date("2017-11-15"),visits:"35"});
		chartData.push({date:new Date("2017-11-16"),visits:"24"});
		chartData.push({date:new Date("2017-11-17"),visits:"11"});
		chartData.push({date:new Date("2017-11-18"),visits:"4"});
		chartData.push({date:new Date("2017-11-19"),visits:"8"});
		chartData.push({date:new Date("2017-11-20"),visits:"14"});
		chartData.push({date:new Date("2017-11-21"),visits:"24"});
		chartData.push({date:new Date("2017-11-22"),visits:"23"});
		chartData.push({date:new Date("2017-11-23"),visits:"23"});
		chartData.push({date:new Date("2017-11-24"),visits:"21"});
		chartData.push({date:new Date("2017-11-25"),visits:"14"});
		chartData.push({date:new Date("2017-11-26"),visits:"16"});
		chartData.push({date:new Date("2017-11-27"),visits:"25"});
		chartData.push({date:new Date("2017-11-28"),visits:"25"});
		chartData.push({date:new Date("2017-11-29"),visits:"22"});
		chartData.push({date:new Date("2017-11-30"),visits:"15"});
		chartData.push({date:new Date("2017-12-01"),visits:"13"});
		chartData.push({date:new Date("2017-12-02"),visits:"7"});
		chartData.push({date:new Date("2017-12-03"),visits:"15"});
		chartData.push({date:new Date("2017-12-04"),visits:"30"});
		chartData.push({date:new Date("2017-12-05"),visits:"27"});
		chartData.push({date:new Date("2017-12-06"),visits:"29"});
		chartData.push({date:new Date("2017-12-07"),visits:"31"});
		chartData.push({date:new Date("2017-12-08"),visits:"23"});
		chartData.push({date:new Date("2017-12-09"),visits:"20"});
		chartData.push({date:new Date("2017-12-10"),visits:"19"});
		chartData.push({date:new Date("2017-12-11"),visits:"22"});
		chartData.push({date:new Date("2017-12-12"),visits:"8"});
		chartData.push({date:new Date("2017-12-13"),visits:"13"});
		chartData.push({date:new Date("2017-12-14"),visits:"12"});
		chartData.push({date:new Date("2017-12-15"),visits:"19"});
		*/

		<c:forEach items="${saleList }" var="list">
			chartData.push({date:new Date("${list.camp_bgn_dt}"),visits:"${list.sale_amt}"});
		</c:forEach>

		/*
		chartData.push({date:new Date("2018-01-08"),visits:"5090,810"});
		chartData.push({date:new Date("2018-01-09"),visits:"614911250"});
		chartData.push({date:new Date("2018-01-10"),visits:"290699320"});
		chartData.push({date:new Date("2018-01-11"),visits:"895734910"});
		chartData.push({date:new Date("2018-01-12"),visits:"648161710"});
		chartData.push({date:new Date("2018-01-15"),visits:"25571630"});
		chartData.push({date:new Date("2018-01-16"),visits:"1173552940"});
		chartData.push({date:new Date("2018-01-17"),visits:"64669070"});
		chartData.push({date:new Date("2018-01-18"),visits:"61912320"});
		*/
		console.log(chartData);
		return chartData;
	}


	var chart = AmCharts.makeChart("chartdiv", {
		"theme": "light",
		"type": "serial",
		"marginRight": 80,
		"autoMarginOffset": 20,
		"marginTop":20,
		"dataProvider": chartData,
		"valueAxes": [{
			"id": "v1",
			"axisAlpha": 0.1
		}],
		"graphs": [{
			"useNegativeColorIfDown": true,
			"balloonText": "[[category]]<br><b>value: [[value]]</b>",
			"bullet": "round",
			"bulletBorderAlpha": 1,
			"bulletBorderColor": "#FFFFFF",
			"hideBulletsCount": 50,
			"lineThickness": 3,
			"lineColor": "#f30306",
			"negativeLineColor": "#0062e3",
			"valueField": "visits"
		}],
		"chartScrollbar": {
			"scrollbarHeight": 5,
			"backgroundAlpha": 0.1,
			"backgroundColor": "#868686",
			"selectedBackgroundColor": "#67b7dc",
			"selectedBackgroundAlpha": 1
		},
		"chartCursor": {
			"valueLineEnabled": true,
			"valueLineBalloonEnabled": true
		},
		"categoryField": "date",
		"categoryAxis": {
			"parseDates": true,
			"axisAlpha": 0,
			"minHorizontalGap": 60
		},
		"export": {
			"enabled": true
		}
	});

	chart.addListener("dataUpdated", zoomChart);
	//zoomChart();

	function zoomChart() {
		if (chart.zoomToIndexes) {
			// chart.zoomToIndexes(130, chartData.length - 1);
		}
	}
</script>
</head>
<body>

<!-- HTML -->
<div id="chartdiv"></div>

</body>
</html>
