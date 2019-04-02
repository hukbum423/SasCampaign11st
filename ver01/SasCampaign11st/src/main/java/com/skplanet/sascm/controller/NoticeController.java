package com.skplanet.sascm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.view.json.MappingJacksonJsonView;

import com.skplanet.sascm.object.UaextCodeMstBO;
import com.skplanet.sascm.object.UaextNoticeBO;
import com.skplanet.sascm.object.UsmUserBO;
import com.skplanet.sascm.service.NoticeService;
import com.skplanet.sascm.util.Common;

@Controller
public class NoticeController {

	private final Log log = LogFactory.getLog(getClass());

	@Resource(name = "noticeService")
	private NoticeService noticeService;

	//AJAX
	@Autowired
	private MappingJacksonJsonView jsonView;

	/**
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "/notice/noticeList.do")
	public String main(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {
		//paramter
		log.info("=============================================");
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		modelMap.addAttribute("selectPageNo", Common.nvl(request.getParameter("selectPageNo"), ""));

		return "notice/noticeList";
	}

	/**
	 * 공지사항 목록  조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/notice/getNoticeList.do")
	public void getNoticeList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, UaextCodeMstBO bo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		//paging
		String selectPageNo = (String) request.getParameter("selectPageNo");
		if (selectPageNo == null || selectPageNo.equals("")) {
			selectPageNo = "1";
		}

		int pageRange = 10;
		int rowRange = 10;
		int selectPage = Integer.parseInt(selectPageNo);
		int rowTotalCnt = Integer.parseInt(noticeService.getNoticeListCnt(map));
		int pageStart = ((selectPage - 1) / pageRange) * pageRange + 1;
		int totalPage = rowTotalCnt / rowRange + ((rowTotalCnt % rowRange > 0) ? 1 : 0);
		int pageEnd = (totalPage <= (pageStart + pageRange - 1)) ? totalPage : (pageStart + pageRange - 1);

		int searchRangeStart = (rowRange * (selectPage - 1)) + 1;
		int searchRangeEnd = rowRange * selectPage;

		log.info("=============================================");
		log.info("rowTotalCnt      : " + rowTotalCnt);
		log.info("pageRange        : " + pageRange);
		log.info("rowRange         : " + rowRange);
		log.info("selectPage       : " + selectPage);
		log.info("pageStart        : " + pageStart);
		log.info("totalPage        : " + totalPage);
		log.info("pageEnd          : " + pageEnd);
		log.info("searchRangeStart : " + searchRangeStart);
		log.info("searchRangeEnd   : " + searchRangeEnd);
		log.info("=============================================");

		map.put("searchRangeStart", searchRangeStart);
		map.put("searchRangeEnd", searchRangeEnd);

		//공지사항 목록 조회
		List<UaextNoticeBO> list = noticeService.getNoticeList(map);

		log.info("=============================================");
		log.info("list   : " + list.size());
		log.info("=============================================");

		map.put("NoticeList", list);

		map.put("rowTotalCnt", rowTotalCnt);
		map.put("pageRange", pageRange);
		map.put("rowRange", rowRange);
		map.put("selectPage", selectPage);
		map.put("pageStart", pageStart);
		map.put("totalPage", totalPage);
		map.put("pageEnd", pageEnd);

		jsonView.render(map, request, response);
	}

	/**
	 * 공지사항 상세 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/notice/noticeDetail.do")
	public String pageNoticeDetail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		@SuppressWarnings("unused")
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("NOTICE_NO       : " + request.getParameter("NOTICE_NO"));
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("NOTICE_NO", Common.nvl(request.getParameter("NOTICE_NO"), ""));

		//테이블 정보관리 마스터 상세조회
		if (request.getParameter("NOTICE_NO") != null && !request.getParameter("NOTICE_NO").equals("")) {
			UaextNoticeBO bo = noticeService.getNoticeDetail(map);
			modelMap.addAttribute("bo", bo);
		}

		modelMap.addAttribute("selectPageNo", Common.nvl(request.getParameter("selectPageNo"), ""));
		//modelMap.addAttribute("getId", user.getId());

		return "notice/noticeDetail";
	}

	/**
	 * 공지사항 등록
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/notice/setNoticeDetail.do")
	public void setNoticeDetail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("NOTICE_NO      : " + request.getParameter("NOTICE_NO"));
		log.info("TITLE          : " + request.getParameter("TITLE"));
		log.info("CONTENT        : " + request.getParameter("CONTENT"));
		log.info("TOP_START_DT   : " + request.getParameter("TOP_START_DT"));
		log.info("TOP_END_DT     : " + request.getParameter("TOP_END_DT"));
		log.info("DISP_YN        : " + request.getParameter("DISP_YN"));
		log.info("user_id        : " + null/*user.getId()*/);
		log.info("user_nmae      : " + null/*user.getId()*/);
		log.info("=============================================");

		map.put("NOTICE_NO", Common.nvl(request.getParameter("NOTICE_NO"), ""));
		map.put("TITLE", Common.nvl(request.getParameter("TITLE"), ""));
		map.put("CONTENT", Common.nvl(request.getParameter("CONTENT"), ""));
		map.put("TOP_START_DT", Common.nvl(request.getParameter("TOP_START_DT"), ""));
		map.put("TOP_END_DT", Common.nvl(request.getParameter("TOP_END_DT"), ""));
		map.put("DISP_YN", Common.nvl(request.getParameter("DISP_YN"), ""));
		map.put("CREATE_ID", Common.nvl(null/*user.getId()*/, user.getId()));   // 일단 사용자 번호가 없는관계로 임시처리함  - 171031
		map.put("UPDATE_ID", Common.nvl(null/*user.getId()*/, user.getId()));

		noticeService.setNoticeDetail(map);

		jsonView.render(map, request, response);

	}

	/**
	 * 공지사항 등록
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delteNoticeDetail.do")
	public void delteNoticeDetail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("NOTICE_NO      : " + request.getParameter("NOTICE_NO"));
		log.info("=============================================");

		map.put("NOTICE_NO", Common.nvl(request.getParameter("NOTICE_NO"), ""));

		noticeService.delteNoticeDetail(map);

		jsonView.render(map, request, response);

	}

	/**
	 * 공지사항 목록 페이지 호출(대쉬보드용)
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/noticeList2.do")
	public String pageNoticeList2(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		//paramter
		log.info("=============================================");
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		modelMap.addAttribute("selectPageNo", Common.nvl(request.getParameter("selectPageNo"), ""));

		return "notice/noticeList2";
	}

	/**
	 * 공지사항 목록  조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getNoticeList2.do")
	public void getNoticeList2(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, UaextCodeMstBO bo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		//paging
		String selectPageNo = (String) request.getParameter("selectPageNo");
		if (selectPageNo == null || selectPageNo.equals("")) {
			selectPageNo = "1";
		}

		int pageRange = 10;
		int rowRange = 10;
		int selectPage = Integer.parseInt(selectPageNo);
		int rowTotalCnt = Integer.parseInt(noticeService.getNoticeListCnt2(map));
		int pageStart = ((selectPage - 1) / pageRange) * pageRange + 1;
		int totalPage = rowTotalCnt / rowRange + ((rowTotalCnt % rowRange > 0) ? 1 : 0);
		int pageEnd = (totalPage <= (pageStart + pageRange - 1)) ? totalPage : (pageStart + pageRange - 1);

		int searchRangeStart = (rowRange * (selectPage - 1)) + 1;
		int searchRangeEnd = rowRange * selectPage;

		log.info("=============================================");
		log.info("rowTotalCnt      : " + rowTotalCnt);
		log.info("pageRange        : " + pageRange);
		log.info("rowRange         : " + rowRange);
		log.info("selectPage       : " + selectPage);
		log.info("pageStart        : " + pageStart);
		log.info("totalPage        : " + totalPage);
		log.info("pageEnd          : " + pageEnd);
		log.info("searchRangeStart : " + searchRangeStart);
		log.info("searchRangeEnd   : " + searchRangeEnd);
		log.info("=============================================");

		map.put("searchRangeStart", searchRangeStart);
		map.put("searchRangeEnd", searchRangeEnd);

		//공지사항 목록 조회
		List<UaextNoticeBO> list = noticeService.getNoticeList2(map);

		log.info("=============================================");
		log.info("list   : " + list.size());
		log.info("=============================================");

		map.put("NoticeList", list);

		map.put("rowTotalCnt", rowTotalCnt);
		map.put("pageRange", pageRange);
		map.put("rowRange", rowRange);
		map.put("selectPage", selectPage);
		map.put("pageStart", pageStart);
		map.put("totalPage", totalPage);
		map.put("pageEnd", pageEnd);

		jsonView.render(map, request, response);
	}

	/**
	 * 공지사항 상세 페이지 호출(대쉬보드용)
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/noticeDetail2.do")
	public String pageNoticeDetail2(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("NOTICE_NO       : " + request.getParameter("NOTICE_NO"));
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("NOTICE_NO", Common.nvl(request.getParameter("NOTICE_NO"), ""));
		UaextNoticeBO bo = noticeService.getNoticeDetail(map);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("selectPageNo", Common.nvl(request.getParameter("selectPageNo"), ""));

		modelMap.addAttribute("getId", user.getId());

		return "notice/noticeDetail2";
	}
}
