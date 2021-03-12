package com.skplanet.sascm.service;

import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.UaextCampaignTesterBO;

/**
 * TestTargetService
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface TestTargetService {

	/**
	 * 테스트 대상자 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<UaextCampaignTesterBO> getTestTargetList(Map<String, Object> param) throws Exception;

	/**
	 * 테스트 대상자 ID 유효성 체크
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getTestTargetMemIdChk(Map<String, Object> param) throws Exception;

	/**
	 * 테스트 대상자 ID 중복 체크
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getTestTargetMemIdDup(Map<String, Object> param) throws Exception;

	/**
	 * 테스트 대상자 상세정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public UaextCampaignTesterBO getTestTargetMemIdDtl(Map<String, Object> param) throws Exception;

	/**
	 * 테스트 대상자 PCID 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<UaextCampaignTesterBO> getTestTargetMemIdPcList(Map<String, Object> param) throws Exception;

	/**
	 * 테스트 대상자 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setTestTargetMemId(Map<String, Object> param) throws Exception;

	/**
	 * 테스트 대상자 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int updateTestTargetMemId(Map<String, Object> param) throws Exception;

	/**
	 * 테스트 대상자 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int deleteTestTargetMemId(Map<String, Object> param) throws Exception;

}
