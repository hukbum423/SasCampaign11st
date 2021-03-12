package com.skplanet.sascm.service;

import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.CalendarBO;

/**
 * CalendarService
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface CalendarService {

	/**
	 * 캠페인 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<CalendarBO> getCalendarList(Map<String, Object> param) throws Exception;
}
