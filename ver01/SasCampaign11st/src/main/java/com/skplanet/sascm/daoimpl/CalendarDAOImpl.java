package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.CalendarDAO;
import com.skplanet.sascm.object.CalendarBO;

/**
 * CalendarDAOImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("calendarDAO")
public class CalendarDAOImpl extends AbstractDAO implements CalendarDAO {

	/**
	 * 캠페인 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CalendarBO> getCalendarList(Map<String, Object> param) throws SQLException {
		return (List<CalendarBO>) selectList("Calendar.getCalendarList", param);
	}
}
