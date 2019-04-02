package com.skplanet.sascm.controller;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.skplanet.sascm.service.KangService;

@Controller
//@RequestMapping(value = "/kang")
public class KangController {

	@Resource(name = "kangService")
	private KangService kangService;

	/**
	 * 
	 * @param locale
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/kang/kang.do", method = RequestMethod.GET)
	public String kang(Locale locale, Model model) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		String cnt = this.kangService.getMessage(map);
		
		model.addAttribute("serverTime", "Hello 강석!!!" + cnt);
		return "kang";
	}
}
