package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.KangDAO;

@SuppressWarnings("unchecked")
@Repository("kangDAO")
public class KangDAOImpl extends AbstractDAO implements KangDAO {

	@Override
	public String getMessage(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Kang.selectMessage");
	}

	@Override
	public List<Map<String, Object>> selectCommCodeListOnMap(Map<String, Object> param) throws SQLException {
		return (List<Map<String,Object>>) selectList("Kang.selectCommCodeListOnMap", param);
	}
}
