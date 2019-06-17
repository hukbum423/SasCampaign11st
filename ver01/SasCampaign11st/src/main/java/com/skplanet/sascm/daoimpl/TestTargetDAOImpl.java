package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.TestTargetDAO;
import com.skplanet.sascm.object.UaextCampaignTesterBO;

/**
 * TestTargetDAOImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("testTargetDAO")
public class TestTargetDAOImpl extends AbstractDAO implements TestTargetDAO {
	
	/**
	 * 테스트 대상자 목록를 얻는다.
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<UaextCampaignTesterBO> getTestTargetList(Map<String, Object> param) throws SQLException {
		return (List<UaextCampaignTesterBO>) selectList("TestTarget.getTestTargetList", param);
	}
	/**
	 * 테스트 대상자 ID 유효성 체크
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getTestTargetMemIdChk(Map<String, Object> param) throws SQLException {
		return (String) selectOne("TestTarget.getTestTargetMemIdChk", param);
	}

	/**
	 * 테스트 대상자 ID 중복 체크
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getTestTargetMemIdDup(Map<String, Object> param) throws SQLException {
		return (String) selectOne("TestTarget.getTestTargetMemIdDup", param);
	}

	/**
	 * 테스트 대상자 상세정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public UaextCampaignTesterBO getTestTargetMemIdDtl(Map<String, Object> param) throws SQLException {
		return (UaextCampaignTesterBO) selectOne("TestTarget.getTestTargetMemIdDtl", param);
	}

	/**
	 * 테스트 대상자 PCID 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<UaextCampaignTesterBO> getTestTargetMemIdPcList(Map<String, Object> param) throws SQLException {
		return ( List<UaextCampaignTesterBO>) selectList("TestTarget.getTestTargetMemIdPcList", param);
	}

	/**
	 * 테스트 대상자 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setTestTargetMemId(Map<String, Object> param) throws SQLException {
		return (int) insert("TestTarget.setTestTargetMemId", param);
	}

	/**
	 * 테스트 대상자 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int updateTestTargetMemId(Map<String, Object> param) throws SQLException {
		return (int) update("TestTarget.updateTestTargetMemId", param);
	}

	/**
	 * 테스트 대상자 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int deleteTestTargetMemId(Map<String, Object> param) throws SQLException {
		return (int) delete("TestTarget.deleteTestTargetMemId", param);
	}
}
