package com.skplanet.sascm.dao;

import java.sql.SQLException;
import java.util.Map;

public interface KangDAO {

	public String getMessage(Map<String, Object> param) throws SQLException;
}
