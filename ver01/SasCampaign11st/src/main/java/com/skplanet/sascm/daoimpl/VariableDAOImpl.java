package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.VariableDAO;
import com.skplanet.sascm.object.UaextVariableBO;

/**
 * VariableDAOImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("variableDAO")
public class VariableDAOImpl extends AbstractDAO implements VariableDAO {

	/**
	 * 매개변수 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<UaextVariableBO> getVariableList(Map<String, Object> param) throws SQLException {
		return (List<UaextVariableBO>) selectList("Variable.getVariableList", param);
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
	public String getVariableChk(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Variable.getVariableChk", param);
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
	public String getVariableDup(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Variable.getVariableDup", param);
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
	public int setVariable(Map<String, Object> param) throws SQLException {
		return (int) insert("Variable.setVariable", param);
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
	public int updateVariable(Map<String, Object> param) throws SQLException {
		return (int) update("Variable.updateVariable", param);
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
	public int deleteVariable(Map<String, Object> param) throws SQLException {
		return (int) delete("Variable.deleteVariable", param);
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
	public UaextVariableBO getVariableDetail(Map<String, Object> param) throws SQLException {
		return (UaextVariableBO) selectOne("Variable.getVariableDetail", param);
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
	public String getVariablePreVal(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Variable.getVariablePreVal", param);
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
	public String getVariablePreValSMS(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Variable.getVariablePreValSMS", param);
	}
}
