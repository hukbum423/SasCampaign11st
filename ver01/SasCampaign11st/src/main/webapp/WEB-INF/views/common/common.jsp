<%--
    **********************************************
    * 기능 설명 : SD 공통영역
    **********************************************
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Date" %>
<%@ include file="/WEB-INF/views/common/taglib.jsp"%>

<%
	String 	userAgent 	= request.getHeader("user-agent");
	Date 	curDt 		= new Date();

	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Date", curDt.getTime());
	response.setDateHeader("Expires", -1);
%>
