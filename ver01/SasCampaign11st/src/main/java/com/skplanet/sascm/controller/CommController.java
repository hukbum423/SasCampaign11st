package com.skplanet.sascm.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.view.json.MappingJacksonJsonView;

/**
 * CommController
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Controller
public class CommController {

	private final Log log = LogFactory.getLog(getClass());

	//AJAX
	@Autowired
	private MappingJacksonJsonView jsonView;

	/**
	 * 현재 시간 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getToday.do")
	public void getToday(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		log.info("======== START getToday() ========");
		
		Map<String, Object> map = new HashMap<String, Object>();

		Date today = new Date();
		SimpleDateFormat dateprint = new SimpleDateFormat("yyyy-MM-dd");

		map.put("TO_DATE", dateprint.format(today.getTime())); //오늘
		map.put("TO_DATE_P1", dateprint.format(today.getTime() + 1000 * 60 * 60 * 24)); //오늘+1
		map.put("TO_DATE_P2", dateprint.format(today.getTime() + 1000 * 60 * 60 * 24 * 2)); //오늘+2

		log.info("=============================================");
		log.info("map   : " + map);
		log.info("=============================================");

		jsonView.render(map, request, response);
		
		log.info("======== END getToday() ========");
	}
}
