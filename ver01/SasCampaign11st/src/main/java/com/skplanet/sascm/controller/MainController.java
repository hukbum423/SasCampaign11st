package com.skplanet.sascm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.skplanet.sascm.object.CampaignRptPtCrmMonthBO;
import com.skplanet.sascm.object.CampaignRptRsltCrmMonthBO;
import com.skplanet.sascm.object.CampaignRptSumSalesBO;
import com.skplanet.sascm.service.CampaignInfoService;

/**
 * <pre>
 * com.skplanet.sascm.main.controller
 * MainController.java
 * </pre>
 *
 * @Author 		: dev
 * @Date		: 2015. 9. 21.
 * @Version	:
 */
@Controller
public class MainController {

	@Resource(name = "campaignInfoService")
	private CampaignInfoService campaignInfoService;

	/**
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/")
	public String home(HttpServletRequest request, Model model) {
		return "redirect:/main.do";
	}

	/**
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/main.do")
	public String main(HttpServletRequest request, Model model) {
		return "main2";
	}

	/**
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/main2.do")
	public String main2(HttpServletRequest request, Model model) {
		return "main2";
	}

	/**
	 * 목표대비 달성율
	 *
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_top_chart.do")
	public String main_top_chart(HttpServletRequest request, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("temp", "");

		List<CampaignRptRsltCrmMonthBO> crmMonthList = this.campaignInfoService.getCampaignRptRsltCrmMonth(map);
		modelMap.addAttribute("crmMonthList", crmMonthList);

		return "main_top_chart";
	}

	/**
	 * 11번가 침투율
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/main_right_chart.do")
	public String main_right_chart(HttpServletRequest request, Model model) {
		return "main_right_chart";
	}

	/**
	 *
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_right_chart_bullets.do")
	public String main_right_chart_bullets(HttpServletRequest request, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("temp", "");
		CampaignRptPtCrmMonthBO ptCrmMonth = this.campaignInfoService.getCampaignRptPtCrmMonth(map);
		modelMap.addAttribute("ptCrmMonth", ptCrmMonth);

		return "main_right_chart_bullets";
	}

	/**
	 * 캠페인 결제 거래액 추이
	 *
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/main_left_chart.do")
	public String main_left_chart(HttpServletRequest request, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("temp", "");
		// 공통코드 목록 조회
		List<CampaignRptSumSalesBO> saleList = this.campaignInfoService.getCampaignRptSumSales(map);

		modelMap.addAttribute("saleList", saleList);

		return "main_left_chart";
	}
}
