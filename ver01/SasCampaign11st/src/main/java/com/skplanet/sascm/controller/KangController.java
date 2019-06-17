package com.skplanet.sascm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.view.json.MappingJacksonJsonView;

import com.skplanet.sascm.object.CampaignListBO;
import com.skplanet.sascm.service.KangService;

@Controller
@RequestMapping(value = "/Kang")
public class KangController {

	private final Log log = LogFactory.getLog(getClass());

	@Resource(name = "kangService")
	private KangService kangService;

	//AJAX
	@Autowired
	private MappingJacksonJsonView jsonView;

	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////

	@RequestMapping(value="/kangJsp01.do", method=RequestMethod.GET)
	public String kangJsp01(Locale locale, Model model) throws Exception {
		model.addAttribute("serverMsg", "Hello, 강석!!! (/kangJsp01.do)");
		return "kang/kangJsp01";
	}

	@RequestMapping(value="/kangRestJsp01.do", method=RequestMethod.GET)
	public String kangRestJsp01(Locale locale, Model model) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("comm_code_id", "");
		param.put("arrKey", new String[] {"C001","C002","PN","PT","OC"});

		List<Map<String, Object>> list = this.kangService.selectCommCodeListOnMap(param);
		model.addAttribute("list", list);
		
		//log.info("=============================================");
		//log.info("list   : " + list);
		//log.info("=============================================");
		
		model.addAttribute("serverMsg", "Hello, 강석!!! (/kangRestJsp01.do)");
		return "kang/kangRestJsp01";
	}

	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////

	@RequestMapping(value = "/kangList.do", method = RequestMethod.GET)
	public void kangList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("serverType", request.getParameter("serverType"));


		//공통코드 목록 조회
		List<CampaignListBO> list = null; // campaignInfoService.getCampaignFolderList(map);

		log.info("=============================================");
		log.info("list   : " + list);
		log.info("=============================================");

		map.put("CampaignFolder", list);
		jsonView.render(map, request, response);
	}

	@RequestMapping(value = "/kang.do", method = RequestMethod.GET)
	public String kang(Locale locale, Model model) throws Exception {

		Map<String, Object> map = new HashMap<String, Object>();
		String msg = this.kangService.getMessage(map);

		model.addAttribute("serverTime", "Hello 강석!!!" + msg);
		return "kang/kang";
	}
}
