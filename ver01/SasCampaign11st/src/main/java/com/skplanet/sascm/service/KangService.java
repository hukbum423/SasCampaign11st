package com.skplanet.sascm.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface KangService {

	public String getMessage(Map<String, Object> param) throws Exception;
	public List<Map<String,Object>> selectCommCodeListOnMap(Map<String, Object> param) throws SQLException;
}
