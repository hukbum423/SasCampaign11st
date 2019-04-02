package com.skplanet.sascm.controller;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.view.json.MappingJacksonJsonView;

import com.skplanet.sascm.object.CalendarBO;
import com.skplanet.sascm.service.CalendarService;

@Controller
public class CalendarController {

	@Resource(name = "calendarService")
	private CalendarService calendarService;

	// AJAX
	@SuppressWarnings("unused")
	@Autowired
	private MappingJacksonJsonView jsonView;

	/**
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/calendar/calendar.do")
	public String main(HttpServletRequest request, Model model) {
		return "calendar/calendar";
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/calendar/ajaxCalendarList.do")
	public String getCalendarList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		@SuppressWarnings("unused")
		Map<String, Object> map1 = new HashMap<String, Object>();

		String nowMonth = request.getParameter("start");
		String[] tmpArr = nowMonth.split("-");
		Calendar date = Calendar.getInstance();

		date.set(Integer.parseInt(tmpArr[0]), Integer.parseInt(tmpArr[1]), Integer.parseInt(tmpArr[2]));
		String tmpDate = "";

		if(Integer.parseInt(tmpArr[2]) > 1){
			int tmp = (date.get(Calendar.MONTH) + 1);
			String tmpStr = "";
			if(Integer.toString(tmp).length() == 1){
				tmpStr = "0"+tmp;
			}else{
				tmpStr = Integer.toString(tmp);
			}
			tmpDate = date.get(Calendar.YEAR) + "-" + tmpStr;
		}

		map.put("nowMonth", tmpDate);

		List<CalendarBO> boList = calendarService.getCalendarList(map);
		modelMap.put("boList", boList);
		modelMap.put("nowMonth", nowMonth);

		return "calendar/calendarData";
	}
}
