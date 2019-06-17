package com.skplanet.sascm.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.CampaignInfoBO;
import com.skplanet.sascm.object.CampaignListBO;
import com.skplanet.sascm.object.CampaignOfferBO;
import com.skplanet.sascm.object.CampaignRptPtCrmMonthBO;
import com.skplanet.sascm.object.CampaignRptRsltCrmMonthBO;
import com.skplanet.sascm.object.CampaignRptSumSalesBO;

/**
 * CampaignInfoDAO
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface CampaignInfoDAO {

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

	public CampaignInfoBO getCICampaignProperty(Map<String, Object> param) throws SQLException;

	public CampaignInfoBO getCampaignInfoSummary(Map<String, Object> param) throws SQLException;

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
	public String getCampaignListCnt(Map<String, Object> param) throws SQLException;
	public List<CampaignListBO> getCampaignList(Map<String, Object> param) throws SQLException;

	public List<CampaignListBO> getCICampaignProperyList(Map<String, Object> param) throws SQLException;

	public int insertOfferData(Map<String, Object> param) throws Exception;

	public int updateOfferData(Map<String, Object> param) throws Exception;

	public int updateChannelData(Map<String, Object> param) throws Exception;

	public int updateChannelData2(Map<String, Object> param) throws Exception;

	public int updateChannelData3(Map<String, Object> param) throws Exception;

	public List<CampaignRptSumSalesBO> getCampaignRptSumSales(Map<String, Object> param) throws SQLException;

	public List<CampaignRptRsltCrmMonthBO> getCampaignRptRsltCrmMonth(Map<String, Object> param) throws SQLException;

	public CampaignRptPtCrmMonthBO getCampaignRptPtCrmMonth(Map<String, Object> param) throws SQLException;


}
