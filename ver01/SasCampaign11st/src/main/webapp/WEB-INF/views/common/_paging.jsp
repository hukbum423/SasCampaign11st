<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<fmt:formatNumber var="tp" value="${(pageVo.totalData / pageVo.numPerPage) }" type="number"/>
<fmt:formatNumber var="totalPage" value="${tp+(1-(tp%1))%1}" type="number"/>

<c:set var="pl" value="${(pageVo.page / pageVo.pagePerList) -1 }" />
<fmt:formatNumber var="pageList" value="${pl+(1-(pl%1))%1}" type="number"/>

<!-- 페이지 리스트의 첫번째가 아닌경우 [1] ... [이전] 버튼을 생성한다. -->
<c:if test="${pageList > 0}">
	<a href="${reqUri }?page=1&${query}">[1]</a> ...
	<fmt:formatNumber var="prevPage" value="${(pageList + 1) * pagePerList + 1 }" type="number"/>
	<a href="${reqUri }?page=${prevPage }&${query }">[이전]</a>
</c:if>

<!-- 페이지 목록 가운데 부분 출력 -->
<fmt:formatNumber var="pageEnd" value="${(pageList + 1) * pageVo.pagePerList }" type="number"/>
<c:if test="${pageEnd+0 > totalPage+0}">
	<fmt:formatNumber var="pageEnd" value="${totalPage }" type="number"/>
</c:if>

<fmt:formatNumber var="setPage" value="${pageList * pageVo.pagePerList +1 }" type="number"/>

<c:forEach begin="${setPage }" end="${pageEnd }" step="1" varStatus="status">
    <c:if test="${status.index == pageVo.page }">
    	<b>[${status.index }]</b>
    </c:if>
    <c:if test="${status.index != pageVo.page }">
    	<a href="${reqUri }?page=${status.index }&${query }">[${status.index }]</a>
    </c:if>
</c:forEach>

<!-- 페이지 목록 맨끝이 totalPage 보다 작을경우에만, [다음] ... [totalPage] 버튼을 생성한다.-->
<c:if test="${pageEnd < totalPage }">
	<c:set var="nextPage" value="${(pageList + 1) * pageVo.pagePerList + 1 }" />
	<a href="${reqUri }?page=${nextPage }&${query }">[다음]</a>
	... <a href="${reqUri }?page=${totalPage }&${query }">[${totalPage }]</a>
</c:if>