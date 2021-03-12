package com.skplanet.sascm.serviceimpl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.TestTargetDAO;
import com.skplanet.sascm.object.UaextCampaignTesterBO;
import com.skplanet.sascm.service.TestTargetService;

/**
 * testTargetService
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Service("testTargetService")
public class TestTargetServiceImpl implements TestTargetService {

	@Resource(name = "testTargetDAO")
	private TestTargetDAO testTargetDAO;

	/**
	 * 테스트 대상자 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<UaextCampaignTesterBO> getTestTargetList(Map<String, Object> param) throws Exception {
		return testTargetDAO.getTestTargetList(param);
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
	public String getTestTargetMemIdChk(Map<String, Object> param) throws Exception {
		return testTargetDAO.getTestTargetMemIdChk(param);
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
	public String getTestTargetMemIdDup(Map<String, Object> param) throws Exception {
		return testTargetDAO.getTestTargetMemIdDup(param);
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
	public UaextCampaignTesterBO getTestTargetMemIdDtl(Map<String, Object> param) throws Exception {
		return testTargetDAO.getTestTargetMemIdDtl(param);
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
	@Override
	public List<UaextCampaignTesterBO> getTestTargetMemIdPcList(Map<String, Object> param) throws Exception {
		return testTargetDAO.getTestTargetMemIdPcList(param);
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
	public int setTestTargetMemId(Map<String, Object> param) throws Exception {
		return testTargetDAO.setTestTargetMemId(param);
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
	public int updateTestTargetMemId(Map<String, Object> param) throws Exception {
		return testTargetDAO.updateTestTargetMemId(param);
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
	public int deleteTestTargetMemId(Map<String, Object> param) throws Exception {
		return testTargetDAO.deleteTestTargetMemId(param);
	}
}
