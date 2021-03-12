package com.skplanet.sascm.common.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("commonDAO")
public class CommonDAO extends AbstractDAO {

	public Map<String, Object> selectFileInfo(Map<String, Object> map) throws Exception {
		return null;//(Map<String, Object>) selectOne("common.selectFileInfo", map);
	}
}