Sas Campaign for 11st
=====================

```
- C:\Windows\System32\drivers\etc\hosts


# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#

# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost





```

server.xml

```
<Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster" channelSendOptions="8">

	<!-- -->
	<Manager className="org.apache.catalina.ha.session.DeltaManager"
		expireSessionsOnShutdown="false"
		notifyListenersOnReplication="true"/>

	<!-- 멀티캐스트 포트(45564) 필요에 따라 변경 -->
	<Channel className="org.apache.catalina.tribes.group.GroupChannel">

		<!-- -->
		<Membership className="org.apache.catalina.tribes.membership.McastService"
			address="228.0.0.4"
			port="45564"
			frequency="500"
			dropTime="3000"/>
	
		<!-- replication 메시지 수신 포트는 4000 - 4100 사이 -->
		<Receiver className="org.apache.catalina.tribes.transport.nio.NioReceiver"
			address="auto"
			port="4000"
			autoBind="100"
			selectorTimeout="5000"
			maxThreads="6"/>

		<!-- -->
		<Sender className="org.apache.catalina.tribes.transport.ReplicationTransmitter">
			<Transport className="org.apache.catalina.tribes.transport.nio.PooledParallelSender"/>
		</Sender>

		<!-- -->
		<Interceptor className="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector"/>
		<Interceptor className="org.apache.catalina.tribes.group.interceptors.MessageDispatch15Interceptor"/>
		
	</Channel>

	<!-- -->
	<Valve className="org.apache.catalina.ha.tcp.ReplicationValve" filter="" />
	<Valve className="org.apache.catalina.ha.session.JvmRouteBinderValve" />

	<!-- war 를 하나에 반영하면 클러스터에 자동으로 배포되는 FarmWarDeployer 기능시에만 
	<Deployer className="org.apache.catalina.ha.deploy.FarmWarDeployer"
		tempDir="/tmp/war-temp/"
		deployDir="/tmp/war-deploy/"
		watchDir="/tmp/war-listen/"
		watchEnabled="false"/>
	-->

	<!-- -->
	<ClusterListener className="org.apache.catalina.ha.session.ClusterSessionListener"/>
</Cluster>

```

webapps/ROOT/WEB-INF/web.xml

```
	<distributable/>
```

webapps/ROOT/test.jsp

```
<%
	session.setAttribute("a", "a");
%>
<html>
<head>
	<title>TEST JSP</title>
</head>
<body>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr bgcolor="#cccccc">
			<td width="20%">Tomcat Machine</td>
			<td width="80%">&nbsp;</td>
		</tr>
		<tr>
			<td>Session ID:</td>
			<td><%=session.getId() %></td>
		</tr>
	</table>
</body>
</html>

```



webapps/ROOT/session.jsp

```
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
 
<%@page import="java.util.List"%>
<%@page import="java.net.InetAddress"%>

<html>
<head>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
</head>
<title>JSP Session Page</title>
<body>
<div class="panel panel-default">
    <div class="panel-heading">Instance</div>  
  <div class="panel-body">
      <% InetAddress IP=InetAddress.getLocalHost(); %>  
      <%= IP.toString() %> : <%=request.getLocalPort()%>
  </div>
</div>
<div class="panel panel-default">
    <div class="panel-heading">Session Info</div>  
  <div class="panel-body">
    <ul "list-group">
    <li class="list-group-item">Session Id : <%=request.getSession().getId()%> </li>
    <li class="list-group-item">Is it New Session : <%=request.getSession().isNew()%> </li>
    <li class="list-group-item">Session Creation Date : <%=new Date(request.getSession().getCreationTime())%> </li>
    <li class="list-group-item">Session Access Date : <%=new Date(request.getSession().getLastAccessedTime())%> </li>
    </ul>
  </div>
</div>

<div class="panel panel-default">
    <div class="panel-heading">Cart List </div>  
  <div class="panel-body">
    <ul class="list-group">
    <%
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            request.getSession().setAttribute("Books", null);
        }
        else {
            String bookName = request.getParameter("bookName");
            List<String> listOfBooks = (List<String>) request.getSession().getAttribute("Books");

            if (listOfBooks == null) {
                listOfBooks = new ArrayList<String>();
                request.getSession().setAttribute("Books", listOfBooks);
            }
            if (bookName != null) {
                listOfBooks.add(bookName);
                request.getSession().setAttribute("Books", listOfBooks);
            }
            for (String book : listOfBooks) {
                out.println("<li class=\"list-group-item\">"+book + "</li>");
            }
        }
    %>
    </ul>
  </div>
</div>

<!-- modify this URL -->
<form action="session_test.jsp" method="post">
  <div class="form-group">
    <label for="bookName">Book Name :</label>
    <input type="text" class="form-control" id="bookName" name="bookName">
  </div>
  <button type="submit" class="btn btn-default">Add to Cart</button>
</form>

<br/>
<form action="session_test.jsp" method="GET">
    <input type="hidden" name="action" value="delete" />
     <div class="form-group">
        <label for="bookName">Clear :</label>
     </div>
  <button type="submit" class="btn btn-default">Clear All data in the Cart</button>
</form>

</body>
</html>

```




References
----------
- []( ""):
- []( ""):
- []( ""):
- []( ""):
- []( ""):
- []( ""):

.....

