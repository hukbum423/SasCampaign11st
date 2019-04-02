package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.KangDAO;

@Repository("kangDAO")
public class KangDAOImpl extends AbstractDAO implements KangDAO {

	@Override
	public String getMessage(Map<String, Object> param) throws SQLException {
		System.out.println(">>>>> KANG !!!");
		return (String) selectOne("Kang.selectMessage");
	}
}
