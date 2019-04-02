package com.skplanet.sascm.serviceimpl;

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

}
