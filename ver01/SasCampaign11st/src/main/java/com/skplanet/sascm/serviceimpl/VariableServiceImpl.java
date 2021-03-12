package com.skplanet.sascm.serviceimpl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.VariableDAO;
import com.skplanet.sascm.object.UaextVariableBO;
import com.skplanet.sascm.service.VariableService;

/**
 * VariableServiceImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Service("variableService")
public class VariableServiceImpl implements VariableService {

	@Resource(name = "variableDAO")
	private VariableDAO variableDAO;

	/**
	 * 매개변수 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<UaextVariableBO> getVariableList(Map<String, Object> param) throws Exception {
		return variableDAO.getVariableList(param);
	}

	/**
	 * 매개변수 목록 전체 건수
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getVariableChk(Map<String, Object> param) throws Exception {
		return variableDAO.getVariableChk(param);
	}

	/**
	 * 매개변수 중복 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getVariableDup(Map<String, Object> param) throws Exception {
		return variableDAO.getVariableDup(param);
	}

	/**
	 * 매개변수 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setVariable(Map<String, Object> param) throws Exception {
		return variableDAO.setVariable(param);
	}

	/**
	 * 매개변수 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int updateVariable(Map<String, Object> param) throws Exception {
		return variableDAO.updateVariable(param);
	}

	/**
	 * 매개변수 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int deleteVariable(Map<String, Object> param) throws Exception {
		return variableDAO.deleteVariable(param);
	}

	/**
	 * 매개변수 상세정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public UaextVariableBO getVariableDetail(Map<String, Object> param) throws Exception {
		return variableDAO.getVariableDetail(param);
	}

	/**
	 * 매개변수 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getVariablePreVal(Map<String, Object> param) throws Exception {
		return variableDAO.getVariablePreVal(param);
	}

	/**
	 * 매개변수 SMS조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getVariablePreValSMS(Map<String, Object> param) throws Exception {
		return variableDAO.getVariablePreValSMS(param);
	}

}
