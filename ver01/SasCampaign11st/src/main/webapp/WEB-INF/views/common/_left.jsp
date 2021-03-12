<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- MENU SECTION -->
<div id="left">
	<div class="media user-media well-small">
		<div class="media-body">
			<h5 class="media-heading"> ${sessionScope.sessionVo.userId}</h5>
			<ul class="list-unstyled user-info">

				<li><a class="btn btn-success btn-xs btn-circle"
					style="width: 10px; height: 12px;"></a> Online</li>

			</ul>
		</div>
		<br />
	</div>

	<ul id="menu" class="collapse">


		<li class="panel active"><a href="/home"> <i class="icon-table"></i>
				Dashboard
		</a></li>

		<li class="panel "><a href="/member/list.do" data-parent="#menu"
			data-toggle="collapse" class="accordion-toggle"
			data-target="#admin-nav"> <i class="icon-user"> </i> 회원관리 관리
		</a></li>

		<li class="panel "><a href="/cmm/main.do" data-parent="#menu"
			data-toggle="collapse" class="accordion-toggle"
			data-target="#admin-nav"> <i class="icon-cog"> </i> 공통코드 관리
		</a></li>
		<li class="panel active"><a href="#" data-parent="#menu"
			data-toggle="collapse" class="accordion-toggle collapsed"
			data-target="#component-nav"> <i class="icon-list"> </i> 게시판

				<span class="pull-right"> <i class="icon-angle-left"></i>
			</span> &nbsp; <span class="label label-default">2</span>&nbsp;
		</a>
			<ul class="collapse" id="component-nav" style="height: 11px;">

				<li class=""><a href="/board/group.do"><i class="icon-angle-right"></i>
						그룹 관리 </a></li>
				<li class=""><a href="/board/boardlist.do"><i class="icon-angle-right"></i>
						게시판 관리 </a></li>
			</ul></li>
	</ul>

</div>
<!--END MENU SECTION -->