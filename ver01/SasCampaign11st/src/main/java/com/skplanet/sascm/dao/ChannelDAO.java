package com.skplanet.sascm.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.CampaignChannelBO;
import com.skplanet.sascm.object.ChannelAlimiBO;
import com.skplanet.sascm.object.ChannelBO;

/**
 * ChannelDAO
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface ChannelDAO {

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
	 * 채널 정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public ChannelBO getChannelInfo(Map<String, Object> param) throws SQLException;

	/**
	 * 채널 상세 정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public ChannelBO getChannelDtlInfo(Map<String, Object> param) throws SQLException;

	/**
	 * 토스트 채널 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setChannelToast(Map<String, Object> param) throws SQLException;

	/**
	 * SMS 채널 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setChannelSms(Map<String, Object> param) throws SQLException;

	/**
	 * EMAIL 채널 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setChannelEmail(Map<String, Object> param) throws SQLException;

	/**
	 * EMAIL 채널 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setChannelEmail2(Map<String, Object> param) throws SQLException;

	/**
	 * MOBILE 채널 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setChannelMobile(Map<String, Object> param) throws SQLException;

	/**
	 * MOBILE 채널 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setChannelMobile2(Map<String, Object> param) throws SQLException;

	/**
	 * Toast LinkUrl 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getChannelToastLinkUrl(Map<String, Object> param) throws SQLException;
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
	 * LMS 채널 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setChannelLms(Map<String, Object> param) throws SQLException;
	///////////////////////////////////////////
	/**
	 * MOBILE-ALIMI 채널 정보 삭제: KANG-20190328: add by Kiea Seok Kang
	 *
	 * @param param
	 * @return
	 * @throws SQLException
	 */
	public int delChannelMobileAlimi(Map<String, Object> param);
	/**
	 * MOBILE-ALIMI 채널 정보 검색: KANG-20190328: add by Kiea Seok Kang
	 *
	 * @param param
	 * @return
	 * @throws SQLException
	 */
	public ChannelAlimiBO getChannelMobileAlimi(Map<String, Object> param);
	/**
	 * MOBILE-ALIMI 채널 정보 저장: KANG-20190328: add by Kiea Seok Kang
	 *
	 * @param param
	 * @return
	 * @throws SQLException
	 */
	public int setChannelMobileAlimi(Map<String, Object> param) throws SQLException;
	public int insertChannelMobileAlimi(Map<String, Object> param) throws SQLException;
	public int updateChannelMobileAlimi(Map<String, Object> param) throws SQLException;
}
