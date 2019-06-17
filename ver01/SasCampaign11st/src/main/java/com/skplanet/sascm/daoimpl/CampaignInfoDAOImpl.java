package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.CampaignInfoDAO;
import com.skplanet.sascm.object.CampaignInfoBO;
import com.skplanet.sascm.object.CampaignListBO;
import com.skplanet.sascm.object.CampaignOfferBO;
import com.skplanet.sascm.object.CampaignRptPtCrmMonthBO;
import com.skplanet.sascm.object.CampaignRptRsltCrmMonthBO;
import com.skplanet.sascm.object.CampaignRptSumSalesBO;

/**
 * CampaignInfoDAOImpl
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("campaignInfoDAO")
public class CampaignInfoDAOImpl extends AbstractDAO implements CampaignInfoDAO {

	/**
	 * 캠페인 정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public CampaignInfoBO getCampaignInfo(Map<String, Object> param) throws SQLException {
		return (CampaignInfoBO) selectOne("CampaignInfo.getCampaignInfo", param);
	}

	@Override
	public CampaignInfoBO getCICampaignProperty(Map<String, Object> param) throws SQLException {
		return (CampaignInfoBO) selectOne("CampaignInfo.getCICampaignProperty", param);
	}

	@Override
	public CampaignInfoBO getCampaignInfoSummary(Map<String, Object> param) throws SQLException {
		return (CampaignInfoBO) selectOne("CampaignInfo.getCampaignInfoSummary", param);
	}

	/**
	 * 캠페인 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignInfo(Map<String, Object> param) throws SQLException {
		return (int) update("CampaignInfo.setCampaignInfo", param);
	}

	/**
	 * 채널 우선순위 수정
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setChannelPriority(Map<String, Object> param) throws SQLException {
		return (int) update("CampaignInfo.setChannelPriority", param);
	}

	/**
	 * 오퍼 목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignOfferBO> getCampaignOfferList(Map<String, Object> param) throws SQLException {
		return (List<CampaignOfferBO>) selectList("CampaignInfo.getCampaignOfferList", param);
	}

	/**
	 * 오퍼 사용여부 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignOfferUseChk(Map<String, Object> param) throws SQLException {
		return (String) selectOne("CampaignInfo.getCampaignOfferUseChk", param);
	}

	/**
	 * 더미오퍼의 사용여부 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignChannelValiChk2(Map<String, Object> param) throws SQLException {
		return (String) selectOne("CampaignInfo.getCampaignChannelValiChk2", param);
	}

	/**
	 * DEVICEID 대상수준일 경우 더미오퍼의 사용여부 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignChannelValiChkforDeviceId(Map<String, Object> param) throws SQLException {
		return (String) selectOne("CampaignInfo.getCampaignChannelValiChkforDeviceId", param);
	}

	/**
	 * 채널 발송시간 수정
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setChannelDispTime(Map<String, Object> param) throws SQLException {
		return (int) update("CampaignInfo.setChannelDispTime", param);
	}

	/**
	 * 캠페인 폴더 리스트 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignListBO> getCampaignFolderList(Map<String, Object> param) throws SQLException {
		return (List<CampaignListBO>) selectList("CampaignInfo.getCampaignFolderList", param);
	}

	/**
	 * 캠페인 리스트 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignListCnt(Map<String, Object> param) throws SQLException {
		return (String) selectOne("CampaignInfo.getCampaignListCnt", param);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignListBO> getCampaignList(Map<String, Object> param) throws SQLException {
		return (List<CampaignListBO>) selectList("CampaignInfo.getCampaignList", param);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignListBO> getCICampaignProperyList(Map<String, Object> param) throws SQLException {
		return (List<CampaignListBO>) selectList("CampaignInfo.getCICampaignProperyList", param);
	}

	@Override
	public int insertOfferData(Map<String, Object> param) throws Exception{
		return (int) insert("CampaignInfo.insertOfferData", param);
	}

	@Override
	public int updateOfferData(Map<String, Object> param) throws Exception{
		return (int) update("CampaignInfo.updateOfferData", param);
	}

	@Override
	public int updateChannelData(Map<String, Object> param) throws Exception{
		return (int) update("CampaignInfo.updateChannelData", param);
	}
	@Override
	public int updateChannelData2(Map<String, Object> param) throws Exception{
		return (int) update("CampaignInfo.updateChannelData2", param);
	}
	public int updateChannelData3(Map<String, Object> param) throws Exception{
		return (int) update("CampaignInfo.updateChannelData3", param);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignRptRsltCrmMonthBO> getCampaignRptRsltCrmMonth(Map<String, Object> param) throws SQLException{
		return (List<CampaignRptRsltCrmMonthBO>) selectList("CampaignInfo.getCampaignRptRsltCrmMonth", param);
	}

	@Override
	public CampaignRptPtCrmMonthBO getCampaignRptPtCrmMonth(Map<String, Object> param) throws SQLException{
		return (CampaignRptPtCrmMonthBO) selectOne("CampaignInfo.getCampaignRptPtCrmMonth", param);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignRptSumSalesBO> getCampaignRptSumSales(Map<String, Object> param) throws SQLException{
		return (List<CampaignRptSumSalesBO>) selectList("CampaignInfo.getCampaignRptSumSales", param);
	}
}
