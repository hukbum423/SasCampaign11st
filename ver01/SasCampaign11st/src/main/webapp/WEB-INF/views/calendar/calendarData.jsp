<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
[
<c:forEach items="${boList }" var="list"  varStatus="status">
  {
    "title": "${list.title}",
    "start": "${list.start}",
    "end": "${list.end}",
    "url": "${list.url}",
    "color": "${list.color}"
  }
  <c:if test="${fn:length(boList) ne status.count}">
  ,
  </c:if>
</c:forEach>
]