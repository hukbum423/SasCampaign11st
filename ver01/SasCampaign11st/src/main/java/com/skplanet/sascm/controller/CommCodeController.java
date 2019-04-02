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

import com.skplanet.sascm.object.UaextCodeDtlBO;
import com.skplanet.sascm.object.UaextCodeMstBO;
import com.skplanet.sascm.object.UsmUserBO;
import com.skplanet.sascm.service.CommCodeService;
import com.skplanet.sascm.util.Common;

@Controller
public class CommCodeController {
	private final Log log = LogFactory.getLog(getClass());

	@Resource(name = "commCodeService")
	private CommCodeService commCodeService;

	//AJAX
	@Autowired
	private MappingJacksonJsonView jsonView;

	/**
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/commCode/commCodeList.do")
	public String pageCommCodeList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		// paramter
		log.info("=============================================");
		log.info("SCOMM_CODE_ID   : " + request.getParameter("SCOMM_CODE_ID"));
		log.info("SCOMM_CODE_NAME : " + request.getParameter("SCOMM_CODE_NAME"));
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("CCOMM_CODE_ID   : " + request.getParameter("CCOMM_CODE_ID"));
		log.info("=============================================");

		modelMap.addAttribute("SCOMM_CODE_ID", Common.nvl(request.getParameter("SCOMM_CODE_ID"), ""));
		modelMap.addAttribute("SCOMM_CODE_NAME", Common.nvl(request.getParameter("SCOMM_CODE_NAME"), ""));
		modelMap.addAttribute("selectPageNo", Common.nvl(request.getParameter("selectPageNo"), ""));
		modelMap.addAttribute("CCOMM_CODE_ID", Common.nvl(request.getParameter("CCOMM_CODE_ID"), ""));
		modelMap.addAttribute("USER", (UsmUserBO) session.getAttribute("ACCOUNT"));

		return "commCode/commCodeList";
	}

	/**
	 * 공통코드 - 마스터 목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getCommCodeList.do")
	public void getCommCodeList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("SCOMM_CODE_ID   : " + request.getParameter("SCOMM_CODE_ID"));
		log.info("SCOMM_CODE_NAME : " + request.getParameter("SCOMM_CODE_NAME"));
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		//조회조건
		map.put("SCOMM_CODE_ID", request.getParameter("SCOMM_CODE_ID"));
		map.put("SCOMM_CODE_NAME", request.getParameter("SCOMM_CODE_NAME"));

		//paging
		String selectPageNo = (String) request.getParameter("selectPageNo");
		if (selectPageNo == null || selectPageNo.equals("")) {
			selectPageNo = "1";
		}

		int pageRange = 10;
		int rowRange = 10;
		int selectPage = Integer.parseInt(selectPageNo);
		int rowTotalCnt = Integer.parseInt(commCodeService.getCommCodeListCnt(map));
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

		//공통코드 목록 조회
		List<UaextCodeMstBO> list = commCodeService.getCommCodeList(map);

		log.info("=============================================");
		log.info("list   : " + list.size());
		log.info("=============================================");

		map.put("CommCodeList", list);

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
	 * 공통코드 - 마스터 목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getCommCodeDtlList.do")
	public void getCommCodeDtlList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, UaextCodeDtlBO bo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("codeId    : " + request.getParameter("codeId"));
		log.info("=============================================");

		//조회조건
		map.put("codeId", Common.nvl(request.getParameter("codeId"), ""));
		map.put("USE_YN", Common.nvl(request.getParameter("USE_YN"), ""));

		//공통코드 상세 목록 조회
		List<UaextCodeDtlBO> list = commCodeService.getCommCodeDtlList(map);

		log.info("=============================================");
		log.info("list   : " + list.size());
		log.info("=============================================");

		map.put("CommCodeDtlList", list);

		jsonView.render(map, request, response);
	}

	/**
	 * 공통코드 마스터 상세 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/commCode/commCodeMaster.do")
	public String pageCommCodeMaster(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//paramter
		log.info("=============================================");
		log.info("COMM_CODE_ID    : " + request.getParameter("COMM_CODE_ID"));
		log.info("SCOMM_CODE_ID   : " + request.getParameter("SCOMM_CODE_ID"));
		log.info("SCOMM_CODE_NAME : " + request.getParameter("SCOMM_CODE_NAME"));
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		modelMap.addAttribute("SCOMM_CODE_ID", Common.nvl(request.getParameter("SCOMM_CODE_ID"), ""));
		modelMap.addAttribute("SCOMM_CODE_NAME", Common.nvl(request.getParameter("SCOMM_CODE_NAME"), ""));
		modelMap.addAttribute("selectPageNo", Common.nvl(request.getParameter("selectPageNo"), ""));

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("COMM_CODE_ID", Common.nvl(request.getParameter("COMM_CODE_ID"), ""));

		//공통코드 마스터 상세조회
		if (request.getParameter("COMM_CODE_ID") != null && !request.getParameter("COMM_CODE_ID").equals("")) {
			UaextCodeMstBO bo = commCodeService.getCommCodeMst(map);
			modelMap.addAttribute("bo", bo);
		}

		modelMap.addAttribute("USER", (UsmUserBO) session.getAttribute("ACCOUNT"));

		return "commCode/commCodeMaster";
	}

	/**
	 * 공통코드 - 마스터 등록
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setCommCodeMst.do")
	public void setCommCodeMst(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, UaextCodeMstBO bo, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("TYPE           : " + request.getParameter("TYPE")); // I : 신규등록, U : 수정
		log.info("COMM_CODE_ID   : " + request.getParameter("COMM_CODE_ID"));
		log.info("COMM_CODE_NAME : " + request.getParameter("COMM_CODE_NAME"));
		log.info("CODE_DESC      : " + request.getParameter("CODE_DESC"));
		log.info("SORT_SEQ       : " + request.getParameter("SORT_SEQ"));
		log.info("USE_YN         : " + request.getParameter("USE_YN"));
		log.info("user_id        : " + user.getId());
		//미네 log.info("user_nmae      : " + user.getName());
		log.info("=============================================");

		map.put("COMM_CODE_ID", Common.nvl(request.getParameter("COMM_CODE_ID"), ""));
		map.put("COMM_CODE_NAME", Common.nvl(request.getParameter("COMM_CODE_NAME"), ""));
		map.put("CODE_DESC", Common.nvl(request.getParameter("CODE_DESC"), ""));
		map.put("SORT_SEQ", Common.nvl(request.getParameter("SORT_SEQ"), ""));
		map.put("USE_YN", Common.nvl(request.getParameter("USE_YN"), ""));
		map.put("CREATE_ID", user.getId());
		map.put("UPDATE_ID", user.getId());

		//신규일때만 중복체크
		String dupChk = "";
		String type = request.getParameter("TYPE");
		if (type.equals("I")) {
			dupChk = commCodeService.getCommCodeDupCnt(map);
		}

		//중복이 아닐경우 INSERT한다
		if (dupChk.equals("N") && type.equals("I")) {
			commCodeService.setCommCodeMst(map);
		} else if (type.equals("U")) {
			commCodeService.updateCommCodeMst(map);
		}

		map.put("dup", dupChk);

		jsonView.render(map, request, response);
	}

	/**
	 * 공통코드 슬레이브 상세 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/commCode/commCodeSlave.do")
	public String pageCommCodeSlave(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//paramter
		log.info("=============================================");
		log.info("SCOMM_CODE_ID   : " + request.getParameter("SCOMM_CODE_ID"));
		log.info("SCOMM_CODE_NAME : " + request.getParameter("SCOMM_CODE_NAME"));
		log.info("selectPageNo    : " + request.getParameter("selectPageNo"));
		log.info("CCOMM_CODE_ID   : " + request.getParameter("CCOMM_CODE_ID"));
		log.info("CODE_ID         : " + request.getParameter("CODE_ID"));
		log.info("=============================================");

		modelMap.addAttribute("SCOMM_CODE_ID", Common.nvl(request.getParameter("SCOMM_CODE_ID"), ""));
		modelMap.addAttribute("SCOMM_CODE_NAME", Common.nvl(request.getParameter("SCOMM_CODE_NAME"), ""));
		modelMap.addAttribute("selectPageNo", Common.nvl(request.getParameter("selectPageNo"), ""));
		modelMap.addAttribute("CCOMM_CODE_ID", Common.nvl(request.getParameter("CCOMM_CODE_ID"), ""));
		modelMap.addAttribute("CODE_ID", Common.nvl(request.getParameter("CODE_ID"), ""));

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("COMM_CODE_ID", Common.nvl(request.getParameter("CCOMM_CODE_ID"), ""));
		map.put("CODE_ID", Common.nvl(request.getParameter("CODE_ID"), ""));

		//부모 정보 상세조회
		UaextCodeMstBO bo = commCodeService.getCommCodeMst(map);

		//자식 정보 상세조회
		UaextCodeDtlBO bo_dtl = commCodeService.getCommCodeDtl(map);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("bo_dtl", bo_dtl);

		modelMap.addAttribute("USER", (UsmUserBO) session.getAttribute("ACCOUNT"));

		return "commCode/commCodeSlave";
	}

	/**
	 * 공통코드 - 슬레이브 등록
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setCommCodeSlave.do")
	public void setCommCodeSlave(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, UaextCodeDtlBO bo, HttpSession session) throws Exception {
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("TYPE           : " + request.getParameter("TYPE")); // I : 신규등록, U : 수정
		log.info("COMM_CODE_ID   : " + request.getParameter("COMM_CODE_ID"));
		log.info("CODE_ID        : " + request.getParameter("CODE_ID"));
		log.info("CODE_NAME      : " + request.getParameter("CODE_NAME"));
		log.info("CODE_DESC      : " + request.getParameter("CODE_DESC"));
		log.info("SORT_SEQ       : " + request.getParameter("SORT_SEQ"));
		log.info("USE_YN         : " + request.getParameter("USE_YN"));
		log.info("ETC1           : " + request.getParameter("ETC1"));
		log.info("ETC2           : " + request.getParameter("ETC2"));
		log.info("ETC2           : " + request.getParameter("ETC2"));
		log.info("user_id        : " + user.getId());
		//미네log.info("user_nmae      : " + user.getName());
		log.info("=============================================");

		map.put("COMM_CODE_ID", Common.nvl(request.getParameter("COMM_CODE_ID"), ""));
		map.put("CODE_ID", Common.nvl(request.getParameter("CODE_ID"), ""));
		map.put("CODE_NAME", Common.nvl(request.getParameter("CODE_NAME"), ""));
		map.put("CODE_DESC", Common.nvl(request.getParameter("CODE_DESC"), ""));
		map.put("SORT_SEQ", Common.nvl(request.getParameter("SORT_SEQ"), ""));
		map.put("USE_YN", Common.nvl(request.getParameter("USE_YN"), ""));
		map.put("ETC1", Common.nvl(request.getParameter("ETC1"), ""));
		map.put("ETC2", Common.nvl(request.getParameter("ETC2"), ""));
		map.put("CREATE_ID", user.getId());
		map.put("UPDATE_ID", user.getId());

		//신규일때만 중복체크
		String dupChk = "";
		String type = request.getParameter("TYPE");
		if (type.equals("I")) {
			dupChk = commCodeService.getCommCodeDtlDupCnt(map);
		}

		//중복이 아닐경우 INSERT한다
		if (dupChk.equals("N") && type.equals("I")) {
			commCodeService.setCommCodeDtl(map);
		} else if (type.equals("U")) {
			commCodeService.updateCommCodeDtl(map);
		}

		map.put("dup", dupChk);

		jsonView.render(map, request, response);
	}
}
