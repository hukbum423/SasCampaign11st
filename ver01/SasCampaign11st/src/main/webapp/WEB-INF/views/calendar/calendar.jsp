<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/common.jsp"%>
<%@ include file="/WEB-INF/views/common/_head.jsp"%>

    <!-- PAGE LEVEL STYLES -->
    <link href="${staticPATH }/assets/css/layout2.css" rel="stylesheet" />
    <link href="${staticPATH }/assets/plugins/flot/examples/examples.css" rel="stylesheet" />
    <link rel="stylesheet" href="${staticPATH }/assets/plugins/timeline/timeline.css" />
    <!-- END PAGE LEVEL  STYLES -->


<link href='${staticPATH }/fullcalendar/fullcalendar.min.css' rel='stylesheet' />
<link href='${staticPATH }/fullcalendar/fullcalendar.print.min.css' rel='stylesheet' media='print' />
<script src='${staticPATH }/fullcalendar/lib/moment.min.js'></script>
<script src='${staticPATH }/fullcalendar/lib/jquery.min.js'></script>
<script src='${staticPATH }/fullcalendar/fullcalendar.min.js'></script>
<script src='${staticPATH }/fullcalendar/locale-all.js'></script>
<script>

/* [<c:forEach items="${boList }" var="list" >
{
  "title": "${list.title}",
  "start": "${list.start}",
  "end": "${list.end}",
  "url": "${list.url}"
},
</c:forEach>
] */

  $(document).ready(function() {

    $('#calendar').fullCalendar({
      locale: 'ko',
      //defaultDate: '2017-10',
      editable: false,
      eventLimit: true, // allow "more" link when too many events
      events: {
        url: '${staticPATH }/calendar/ajaxCalendarList.do',
        //url: '${staticPATH }/fullcalendar/demos/json/events.json',
        error: function() {
          $('#script-warning').show();
        }
      },
      loading: function(bool) {
        //console.log(bool)
        $('#loading').toggle(bool);
      }
      
    });
    
  });

  // 왼쪽 버튼을 클릭하였을 경우
  jQuery("button.fc-prev-button").click(function() {
      var date = jQuery("#calendar").fullCalendar("getDate");
      alert(convertDate(date));
  });

  // 오른쪽 버튼을 클릭하였을 경우
  jQuery("button.fc-next-button").click(function() {
      var date = jQuery("#calendar").fullCalendar("getDate");
      alert(convertDate(date));
  });
</script>



        <!--PAGE CONTENT -->
        <div id="content" style="width:100%; height:100%;">
           <!--BLOCK SECTION -->
           <div class="row" style="width:100%; height:100%;">
              <div class="col-lg-1"></div>
              <div class="col-lg-10">

              <div class="col-md-12 page-header" style="margin-top:0px;">
                <h3>캠페인 달력</h3>
              </div>






  <div id='calendar' style="height:100%;"></div>









              
              </div>
              <div class="col-lg-1"></div>
          </div>
          <!--END BLOCK SECTION -->
          <div class="col-lg-3"></div>

        </div>
        <!--END PAGE CONTENT -->
                      
                      
        
        

<%@ include file="/WEB-INF/views/common/_footer.jsp"%>
