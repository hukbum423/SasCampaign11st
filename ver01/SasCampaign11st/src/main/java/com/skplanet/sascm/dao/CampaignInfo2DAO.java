package com.skplanet.sascm.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.CampaignChannelBO;
import com.skplanet.sascm.object.CampaignInfoBO;
import com.skplanet.sascm.object.CampaignListBO;
import com.skplanet.sascm.object.CampaignOfferBO;

/**
 * CampaignInfoDAO
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface CampaignInfo2DAO {

	/**
	 * 캠페인 정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public CampaignInfoBO getCampaignInfo(Map<String, Object> param) throws SQLException;

	/**
	 * 캠페인 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignInfo(Map<String, Object> param) throws SQLException;

	/**
	 * 채널 우선순위 수정
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setChannelPriority(Map<String, Object> param) throws SQLException;

	/**
	 * 오퍼 목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<CampaignOfferBO> getCampaignOfferList(Map<String, Object> param) throws SQLException;

	/**
	 * 채널 목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<CampaignChannelBO> getCampaignChannelList(Map<String, Object> param) throws SQLException;

	/**
	 * 오퍼 사용여부 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCampaignOfferUseChk(Map<String, Object> param) throws SQLException;

	/**
	 * 토스트 배너 여부 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCampaignChannelValiChk(Map<String, Object> param) throws SQLException;

	/**
	 * 더미오퍼의 사용여부 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCampaignChannelValiChk2(Map<String, Object> param) throws SQLException;

	/**
	 * 채널정보 삭제
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int delChannelInfo(Map<String, Object> param) throws SQLException;

	/**
	 * DEVICEID 대상수준일 경우 더미오퍼의 사용여부 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCampaignChannelValiChkforDeviceId(Map<String, Object> param) throws SQLException;

	/**
	 * DEVICEID 대상수준일 경우 Mobile 채널 사용 여부 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCampaignChannelValiChkforMobile(Map<String, Object> param) throws SQLException;

	/**
	 * 채널 발송시간 수정
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setChannelDispTime(Map<String, Object> param) throws SQLException;
	/**
	 * 켐페인 폴더 리스트 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<CampaignListBO> getCampaignFolderList(Map<String, Object> param) throws SQLException;
	/**
	 * 켐페인  리스트 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<CampaignListBO> getCampaignList(Map<String, Object> param) throws SQLException;
}
