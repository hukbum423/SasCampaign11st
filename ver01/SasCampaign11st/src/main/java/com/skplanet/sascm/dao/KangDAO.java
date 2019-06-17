package com.skplanet.sascm.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface KangDAO {

	public String getMessage(Map<String, Object> param) throws SQLException;
	public List<Map<String,Object>> selectCommCodeListOnMap(Map<String, Object> param) throws SQLException;
}
