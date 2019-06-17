package com.skplanet.sascm.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.UaextVariableBO;

/**
 * VariableDAO
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface VariableDAO {

	/**
	 * 매개변수 목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<UaextVariableBO> getVariableList(Map<String, Object> param) throws SQLException;

	/**
	 * 매개변수 목록 전체 건수
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getVariableChk(Map<String, Object> param) throws SQLException;

	/**
	 * 매개변수 중복 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getVariableDup(Map<String, Object> param) throws SQLException;

	/**
	 * 매개변수 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setVariable(Map<String, Object> param) throws SQLException;

	/**
	 * 매개변수 수정
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int updateVariable(Map<String, Object> param) throws SQLException;

	/**
	 * 매개변수 삭제
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int deleteVariable(Map<String, Object> param) throws SQLException;

	/**
	 * 매개변수 상세정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public UaextVariableBO getVariableDetail(Map<String, Object> param) throws SQLException;

	/**
	 * 매개변수 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getVariablePreVal(Map<String, Object> param) throws SQLException;

	/**
	 * 매개변수 SMS조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getVariablePreValSMS(Map<String, Object> param) throws SQLException;

}
