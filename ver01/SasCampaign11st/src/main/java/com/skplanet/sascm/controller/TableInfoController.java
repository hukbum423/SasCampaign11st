package com.skplanet.sascm.controller;

import java.util.ArrayList;
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
import com.skplanet.sascm.object.UaextTableInfoDtlBO;
import com.skplanet.sascm.object.UaextTableInfoMstBO;
import com.skplanet.sascm.object.UsmUserBO;
import com.skplanet.sascm.service.TableInfoService;
import com.skplanet.sascm.util.Common;

/**
 * TableInfoController
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Controller
public class TableInfoController {

	private final Log log = LogFactory.getLog(getClass());

	@Resource(name = "tableInfoService")
	private TableInfoService tableInfoService;

	//AJAX
	@Autowired
	private MappingJacksonJsonView jsonView;

	/**
	 * 테이블 정보 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/tableInfo/tableInfoList.do")
	public String pageTableInfoList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//paramter
		log.info("=============================================");
		log.info("STABLE_NAME     : " + request.getParameter("STABLE_NAME"));
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		modelMap.addAttribute("STABLE_NAME", Common.nvl(request.getParameter("STABLE_NAME"), ""));
		modelMap.addAttribute("selectPageNo", Common.nvl(request.getParameter("selectPageNo"), ""));
		modelMap.addAttribute("USER", (UsmUserBO) session.getAttribute("ACCOUNT"));

		return "tableInfo/tableInfoList";
	}

	/**
	 * 테이블 정보 마스터 목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getTableInfoList.do")
	public void getTableInfoList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, UaextCodeMstBO bo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("STABLE_NAME     : " + request.getParameter("STABLE_NAME"));
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		//조회조건
		map.put("STABLE_NAME", request.getParameter("STABLE_NAME"));

		//paging
		String selectPageNo = (String) request.getParameter("selectPageNo");
		if (selectPageNo == null || selectPageNo.equals("")) {
			selectPageNo = "1";
		}

		int pageRange = 10;
		int rowRange = 10;
		int selectPage = Integer.parseInt(selectPageNo);
		int rowTotalCnt = Integer.parseInt(tableInfoService.getTableInfoListCnt(map));
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

		//테이블 정보 마스터 목록 조회
		List<UaextTableInfoMstBO> list = tableInfoService.getTableInfoList(map);

		log.info("=============================================");
		log.info("list   : " + list.size());
		log.info("=============================================");

		map.put("TableInfoList", list);

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
	 * 테이블 정보관리 마스터 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/tableInfo/tableInfoMaster.do")
	public String pageTableInfoMaster(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//paramter
		log.info("=============================================");
		log.info("TABLE_NAME      : " + request.getParameter("TABLE_NAME"));
		log.info("STABLE_NAME     : " + request.getParameter("STABLE_NAME"));
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("TABLE_NAME", Common.nvl(request.getParameter("TABLE_NAME"), ""));

		//테이블 정보관리 마스터 상세조회
		if (request.getParameter("TABLE_NAME") != null && !request.getParameter("TABLE_NAME").equals("")) {
			UaextTableInfoMstBO bo = tableInfoService.getTableInfoMaster(map);
			modelMap.addAttribute("bo", bo);
		}

		modelMap.addAttribute("STABLE_NAME", Common.nvl(request.getParameter("STABLE_NAME"), ""));
		modelMap.addAttribute("selectPageNo", Common.nvl(request.getParameter("selectPageNo"), ""));
		modelMap.addAttribute("USER", (UsmUserBO) session.getAttribute("ACCOUNT"));

		return "tableInfo/tableInfoMaster";
	}

	/**
	 * 테이블 정보관리 마스터 등록
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setTableInfoMst.do")
	public void setTableInfoMst(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("TYPE           : " + request.getParameter("TYPE")); // I : 신규등록, U : 수정
		log.info("TABLE_NAME     : " + request.getParameter("TABLE_NAME"));
		log.info("CREATE_DATE    : " + request.getParameter("CREATE_DATE"));
		log.info("UPDATE_DATE    : " + request.getParameter("UPDATE_DATE"));
		log.info("RECYCLE_PERIOD : " + request.getParameter("RECYCLE_PERIOD"));
		log.info("TABLE_DESC     : " + request.getParameter("TABLE_DESC"));
		log.info("user_id        : " + user.getId());
		log.info("user_nmae      : " + user.getName());
		log.info("=============================================");

		map.put("TABLE_NAME", Common.nvl(request.getParameter("TABLE_NAME"), ""));
		map.put("CREATE_DATE", Common.nvl(request.getParameter("CREATE_DATE"), ""));
		map.put("UPDATE_DATE", Common.nvl(request.getParameter("UPDATE_DATE"), ""));
		map.put("RECYCLE_PERIOD", Common.nvl(request.getParameter("RECYCLE_PERIOD"), ""));
		map.put("TABLE_DESC", Common.nvl(request.getParameter("TABLE_DESC"), ""));
		map.put("CREATE_ID", Common.nvl(user.getId(), ""));
		map.put("UPDATE_ID", Common.nvl(user.getId(), ""));

		//신규일때만 중복체크
		String dupChk = "";
		String type = request.getParameter("TYPE");
		if (type.equals("I")) {
			dupChk = tableInfoService.getTableInfoMstDupCnt(map);
		}

		//중복이 아닐경우 INSERT한다
		if (dupChk.equals("N") && type.equals("I")) {
			tableInfoService.setTableInfoMst(map);
		} else if (type.equals("U")) {
			tableInfoService.updateTableInfoMst(map);
		}

		map.put("dup", dupChk);

		jsonView.render(map, request, response);
	}

	/**
	 * 테이블 정보관리 마스터 삭제
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/deleteTableInfoMst.do")
	public void deleteTableInfoMst(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("TABLE_NAME     : " + request.getParameter("TABLE_NAME"));
		log.info("=============================================");

		map.put("TABLE_NAME", Common.nvl(request.getParameter("TABLE_NAME"), ""));

		tableInfoService.deleteTableInfoMst(map);

		jsonView.render(map, request, response);
	}

	/**
	 * 테이블 상세 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/tableInfo/tableInfoDetail.do")
	public String pageTableInfoDetail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("TABLE_NAME      : " + request.getParameter("TABLE_NAME"));
		log.info("=============================================");

		map.put("TABLE_NAME", Common.nvl(request.getParameter("TABLE_NAME"), ""));
		if (request.getParameter("TABLE_NAME") != null && !request.getParameter("TABLE_NAME").equals("")) {
		List<UaextTableInfoDtlBO> list = tableInfoService.getTableInfoDetail(map);

		modelMap.addAttribute("TableInfoDtlList", list);
		}
		modelMap.addAttribute("TABLE_NAME", Common.nvl(request.getParameter("TABLE_NAME"), ""));
		modelMap.addAttribute("USER", (UsmUserBO) session.getAttribute("ACCOUNT"));

		return "tableInfo/tableInfoDetail";
	}

	/**
	 * 테이블 정보관리 상세 등록
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setTableInfoDetail.do")
	public void setTableInfoDetail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("TABLE_NAME     : " + request.getParameter("TABLE_NAME"));
		log.info("COLUMN_NAME    : " + request.getParameterValues("COLUMN_NAME"));
		log.info("COLUMN_TYPE    : " + request.getParameterValues("COLUMN_TYPE"));
		log.info("COLUMN_DESC    : " + request.getParameterValues("COLUMN_DESC"));
		log.info("SORT_SEQ       : " + request.getParameterValues("SORT_SEQ"));
		log.info("user_id        : " + user.getId());
		log.info("user_nmae      : " + user.getName());
		log.info("=============================================");

		String COLUMN_NAME[] = request.getParameterValues("COLUMN_NAME");
		String COLUMN_TYPE[] = request.getParameterValues("COLUMN_TYPE");
		String COLUMN_DESC[] = request.getParameterValues("COLUMN_DESC");
		String SORT_SEQ[] = request.getParameterValues("SORT_SEQ");

		List<UaextTableInfoDtlBO> list = new ArrayList<UaextTableInfoDtlBO>();

		if (COLUMN_NAME != null) {
			for (int i = 0; i < COLUMN_NAME.length; i++) {
				UaextTableInfoDtlBO bo = new UaextTableInfoDtlBO();
				bo.setColumn_name(COLUMN_NAME[i]);
				bo.setColumn_type(COLUMN_TYPE[i]);
				bo.setColumn_desc(COLUMN_DESC[i]);
				bo.setSort_seq(SORT_SEQ[i]);

				list.add(bo);
			}
		}

		map.put("TABLE_NAME", Common.nvl(request.getParameter("TABLE_NAME"), ""));
		map.put("list", list);
		map.put("CREATE_ID", Common.nvl(user.getId(), ""));
		map.put("UPDATE_ID", Common.nvl(user.getId(), ""));

		//기존데이터 삭제
		tableInfoService.deleteTableInfoDetailAll(map);

		//데이터 저장
		if (list.size() > 0) {
			tableInfoService.setTableInfoDetail(map);
		}

		jsonView.render(map, request, response);
	}
}
