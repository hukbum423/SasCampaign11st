package com.skplanet.sascm.serviceimpl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.CalendarDAO;
import com.skplanet.sascm.object.CalendarBO;
import com.skplanet.sascm.service.CalendarService;

/**
 * CalendarServiceImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Service("calendarService")
public class CalendarServiceImpl implements CalendarService {

	@Resource(name = "calendarDAO")
	private CalendarDAO calendarDAO;

	/**
	 * 캠페인 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<CalendarBO> getCalendarList(Map<String, Object> param) throws Exception {
		return calendarDAO.getCalendarList(param);
	}
}
