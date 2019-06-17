package com.skplanet.sascm.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.CalendarBO;

/**
 * CalendarDAO
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface CalendarDAO {

	/**
	 * 캠페인 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<CalendarBO> getCalendarList(Map<String, Object> param) throws SQLException;
}
