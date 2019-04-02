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

import com.skplanet.sascm.object.ToastMsgMstrSrcBO;
import com.skplanet.sascm.object.UaextCodeDtlBO;
import com.skplanet.sascm.object.UsmUserBO;
import com.skplanet.sascm.service.CommCodeService;
import com.skplanet.sascm.service.ToastService;
import com.skplanet.sascm.util.Common;

/**
 * ToastController
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Controller
public class ToastController {

	private final Log log = LogFactory.getLog(getClass());

	@Resource(name = "toastService")
	private ToastService toastService;

	@Resource(name = "commCodeService")
	private CommCodeService commCodeService;

	//AJAX
	@Autowired
	private MappingJacksonJsonView jsonView;

	/**
	 * 토스트배너 관리 목록 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/toast/toastList.do")
	public String pageToastList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		//paramter
		log.info("=============================================");
		log.info("SCAMPAIGNCODE       : " + request.getParameter("SCAMPAIGNCODE"));
		log.info("SDISP_BGN_DY        : " + request.getParameter("SDISP_BGN_DY"));
		log.info("selectPageNo        : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		modelMap.addAttribute("SCAMPAIGNCODE", Common.nvl(request.getParameter("SCAMPAIGNCODE"), ""));
		modelMap.addAttribute("SDISP_BGN_DY", Common.nvl(request.getParameter("SDISP_BGN_DY"), ""));
		modelMap.addAttribute("selectPageNo", Common.nvl(request.getParameter("selectPageNo"), ""));

		return "toast/toastList";
	}

	/**
	 * 토스트 배너 관리 목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/toast/getToastList.do")
	public void getToastList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("SCAMPAIGNCODE     : " + request.getParameter("SCAMPAIGNCODE"));
		log.info("SDISP_BGN_DY      : " + request.getParameter("SDISP_BGN_DY"));
		log.info("=============================================");

		map.put("SCAMPAIGNCODE", Common.nvl(request.getParameter("SCAMPAIGNCODE"), ""));
		map.put("SDISP_BGN_DY", Common.nvl(request.getParameter("SDISP_BGN_DY"), ""));

		//paging
		String selectPageNo = (String) request.getParameter("selectPageNo");
		if (selectPageNo == null || selectPageNo.equals("")) {
			selectPageNo = "1";
		}

		int pageRange = 10;
		int rowRange = 10;
		int selectPage = Integer.parseInt(selectPageNo);
		int rowTotalCnt = Integer.parseInt(toastService.getToastListCnt(map));
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

		//토스트 배너 목록 조회
		List<ToastMsgMstrSrcBO> list = toastService.getToastList(map);

		map.put("ToastList", list);

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
	 * 토스트배너 관리 상세 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/toast/toastDetail.do")
	public String pageToastDetail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("CAMPAIGN_MANG_CODE  : " + request.getParameter("CAMPAIGN_MANG_CODE"));
		log.info("SCAMPAIGNCODE       : " + request.getParameter("SCAMPAIGNCODE"));
		log.info("SDISP_BGN_DY        : " + request.getParameter("SDISP_BGN_DY"));
		log.info("selectPageNo        : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		modelMap.addAttribute("CAMPAIGN_MANG_CODE", Common.nvl(request.getParameter("CAMPAIGN_MANG_CODE"), ""));
		modelMap.addAttribute("SCAMPAIGNCODE", Common.nvl(request.getParameter("SCAMPAIGNCODE"), ""));
		modelMap.addAttribute("SDISP_BGN_DY", Common.nvl(request.getParameter("SDISP_BGN_DY"), ""));
		modelMap.addAttribute("selectPageNo", Common.nvl(request.getParameter("selectPageNo"), ""));

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("CAMPAIGN_MANG_CODE", Common.nvl(request.getParameter("CAMPAIGN_MANG_CODE"), ""));

		//토스트배너 관리 상세 조회
		ToastMsgMstrSrcBO bo = toastService.getToastDetail(map);

		int disp_rnk = (new Double(bo.getDisp_rnk())).intValue();
		bo.setDisp_rnk(disp_rnk);

		//우선순위
		map.put("codeId", "C006");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> priority_rank = commCodeService.getCommCodeDtlList(map);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("priority_rank", priority_rank);
		modelMap.addAttribute("user", user);

		return "toast/toastDetail";
	}

	/**
	 * 토스트 배너 상세 정보 수정
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/toast/setToastDetail.do")
	public void setToastDetail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CAMPAIGN_MANG_CODE     : " + request.getParameter("CAMPAIGN_MANG_CODE"));
		log.info("TITLE                  : " + request.getParameter("TITLE"));
		log.info("MSG                    : " + request.getParameter("MSG"));
		log.info("LINK_URL               : " + request.getParameter("LINK_URL"));
		log.info("MSG_DESC               : " + request.getParameter("MSG_DESC"));
		log.info("DISP_RNK               : " + request.getParameter("DISP_RNK"));
		log.info("USE_YN                 : " + request.getParameter("USE_YN"));
		log.info("=============================================");

		map.put("CAMPAIGN_MANG_CODE", Common.nvl(request.getParameter("CAMPAIGN_MANG_CODE"), ""));
		map.put("TITLE", Common.nvl(request.getParameter("TITLE"), ""));
		map.put("MSG", Common.nvl(request.getParameter("MSG"), ""));
		map.put("LINK_URL", Common.nvl(request.getParameter("LINK_URL"), ""));
		map.put("MSG_DESC", Common.nvl(request.getParameter("MSG_DESC"), ""));
		map.put("DISP_RNK", Common.nvl(request.getParameter("DISP_RNK"), ""));
		map.put("USE_YN", Common.nvl(request.getParameter("USE_YN"), ""));
		map.put("UPDATE_ID", user.getId());

		//토스트 배너 상세 정보 수정
		toastService.setToastDetail(map);

		jsonView.render(map, request, response);
	}
}
