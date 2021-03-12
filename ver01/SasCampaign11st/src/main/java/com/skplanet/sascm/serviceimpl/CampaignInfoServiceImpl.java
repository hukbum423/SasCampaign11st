package com.skplanet.sascm.serviceimpl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.CampaignInfo2DAO;
import com.skplanet.sascm.dao.CampaignInfoDAO;
import com.skplanet.sascm.object.CampaignInfoBO;
import com.skplanet.sascm.object.CampaignListBO;
import com.skplanet.sascm.object.CampaignOfferBO;
import com.skplanet.sascm.object.CampaignRptPtCrmMonthBO;
import com.skplanet.sascm.object.CampaignRptRsltCrmMonthBO;
import com.skplanet.sascm.object.CampaignRptSumSalesBO;
import com.skplanet.sascm.service.CampaignInfoService;

/**
 * CampaignInfoServiceImpl
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Service("campaignInfoService")
public class CampaignInfoServiceImpl implements CampaignInfoService {

	@Resource(name = "campaignInfoDAO")
	private CampaignInfoDAO campaignInfoDAO;

	@Resource(name = "campaignInfo2DAO")
	private CampaignInfo2DAO campaignInfo2DAO;

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
	public CampaignInfoBO getCampaignInfo(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.getCampaignInfo(param);
	}

	@Override
	public CampaignInfoBO getCICampaignProperty(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.getCICampaignProperty(param);
	}

	@Override
	public CampaignInfoBO getCampaignInfoSummary(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.getCampaignInfoSummary(param);
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
	public int setCampaignInfo(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.setCampaignInfo(param);
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
	public int setChannelPriority(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.setChannelPriority(param);
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
	@Override
	public List<CampaignOfferBO> getCampaignOfferList(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.getCampaignOfferList(param);
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
	public String getCampaignOfferUseChk(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.getCampaignOfferUseChk(param);
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
	public String getCampaignChannelValiChk2(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.getCampaignChannelValiChk2(param);
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
	public String getCampaignChannelValiChkforDeviceId(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.getCampaignChannelValiChkforDeviceId(param);
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
	public int setChannelDispTime(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.setChannelDispTime(param);
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
	@Override
	public List<CampaignListBO> getCampaignFolderList(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.getCampaignFolderList(param);
	}

	/**
	 * 캠페인  리스트 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignListCnt(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.getCampaignListCnt(param);
	}

	@Override
	public List<CampaignListBO> getCampaignList(Map<String, Object> param) throws Exception {
		return this.campaignInfoDAO.getCampaignList(param);
	}

	@Override
	public List<CampaignListBO> getCICampaignProperyList(Map<String, Object> param) throws Exception {
		return (List<CampaignListBO>)this.campaignInfoDAO.getCICampaignProperyList(param);
	}

	@Override
	public List<CampaignListBO> getCampaignList2(Map<String, Object> param) throws Exception {
		return this.campaignInfo2DAO.getCampaignList(param);
	}

	public int insertOfferData(Map<String, Object> param) throws Exception{
	return this.campaignInfoDAO.insertOfferData(param);
	}

	@Override
	public int updateOfferData(Map<String, Object> param) throws Exception{
		return this.campaignInfoDAO.updateOfferData(param);
	}

	@Override
	public int updateChannelData(Map<String, Object> param) throws Exception{
		return this.campaignInfoDAO.updateChannelData(param);
	}

	@Override
	public int updateChannelData2(Map<String, Object> param) throws Exception{
		return this.campaignInfoDAO.updateChannelData2(param);
	}
	
	@Override
	public int updateChannelData3(Map<String, Object> param) throws Exception{
		return this.campaignInfoDAO.updateChannelData3(param);
	}

	@Override
	public List<CampaignRptRsltCrmMonthBO> getCampaignRptRsltCrmMonth(Map<String, Object> param) throws Exception {
		return (List<CampaignRptRsltCrmMonthBO>) this.campaignInfoDAO.getCampaignRptRsltCrmMonth(param);
	}

	@Override
	public CampaignRptPtCrmMonthBO getCampaignRptPtCrmMonth(Map<String, Object> param) throws Exception{
		return (CampaignRptPtCrmMonthBO) this.campaignInfoDAO.getCampaignRptPtCrmMonth(param);
	}

	@Override
	public List<CampaignRptSumSalesBO> getCampaignRptSumSales(Map<String, Object> param) throws Exception {
		return (List<CampaignRptSumSalesBO>) this.campaignInfoDAO.getCampaignRptSumSales(param);
	}
}

