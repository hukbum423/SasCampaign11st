package com.skplanet.sascm.serviceimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.KangDAO;
import com.skplanet.sascm.service.KangService;

@Service("kangService")
public class KangServiceImpl implements KangService {

	@Resource(name = "kangDAO")
	private KangDAO kangDAO;

	@Override
	public String getMessage(Map<String, Object> param) throws Exception {
		return this.kangDAO.getMessage(param);
	}

	@Override
	public List<Map<String, Object>> selectCommCodeListOnMap(Map<String, Object> param) throws SQLException {
		return this.kangDAO.selectCommCodeListOnMap(param);
	}
}
