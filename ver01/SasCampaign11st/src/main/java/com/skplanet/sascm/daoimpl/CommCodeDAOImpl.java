package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.CommCodeDAO;
import com.skplanet.sascm.object.UaextCodeDtlBO;
import com.skplanet.sascm.object.UaextCodeMstBO;

/**
 * CommCodeDAOImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("commCodeDAO")
public class CommCodeDAOImpl extends AbstractDAO implements CommCodeDAO {

	/**
	 * 공통코드 마스터 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<UaextCodeMstBO> getCommCodeList(Map<String, Object> param) throws SQLException {
		return (List<UaextCodeMstBO>) selectList("CommCode.getCommCodeList", param);
	}

	/**
	 * 공통코드 마스터 목록 건수 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCommCodeListCnt(Map<String, Object> param) throws SQLException {
		return (String) selectOne("CommCode.getCommCodeListCnt", param);
	}

	/**
	 * 공통코드 상세 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<UaextCodeDtlBO> getCommCodeDtlList(Map<String, Object> param) throws SQLException {
		return (List<UaextCodeDtlBO>) selectList("CommCode.getCommCodeDtlList", param);
	}

	/**
	 * 공통코드 상세 목록 조회 2  // KANG-20200415: add
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<UaextCodeDtlBO> getCommCodeDtlList2(Map<String, Object> param) throws SQLException {
		return (List<UaextCodeDtlBO>) selectList("CommCode.getCommCodeDtlList2", param);   // KANG-20200415: add
	}

	/**
	 * 공통코드 마스터 중복 여부 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCommCodeDupCnt(Map<String, Object> param) throws SQLException {
		return (String) selectOne("CommCode.getCommCodeDupCnt", param);
	}

	/**
	 * 공통코드 상세 중복 여부 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCommCodeDtlDupCnt(Map<String, Object> param) throws SQLException {
		return (String) selectOne("CommCode.getCommCodeDtlDupCnt", param);
	}

	/**
	 * 공통코드 마스터 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCommCodeMst(Map<String, Object> param) throws SQLException {
		return (int) insert("CommCode.setCommCodeMst", param);
	}

	/**
	 * 공통코드 마스터 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int updateCommCodeMst(Map<String, Object> param) throws SQLException {
		return (int) insert("CommCode.updateCommCodeMst", param);
	}

	/**
	 * 공통코드 마스터 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public UaextCodeMstBO getCommCodeMst(Map<String, Object> param) throws SQLException {
		return (UaextCodeMstBO) selectOne("CommCode.getCommCodeMst", param);
	}

	/**
	 * 공통코드 상세 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCommCodeDtl(Map<String, Object> param) throws SQLException {
		return (int) insert("CommCode.setCommCodeDtl", param);
	}

	/**
	 * 공통코드 상세 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int updateCommCodeDtl(Map<String, Object> param) throws SQLException {
		return (int) insert("CommCode.updateCommCodeDtl", param);
	}

	/**
	 * 공통코드 상세코드 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public UaextCodeDtlBO getCommCodeDtl(Map<String, Object> param) throws SQLException {
		return (UaextCodeDtlBO) selectOne("CommCode.getCommCodeDtl", param);
	}
}
