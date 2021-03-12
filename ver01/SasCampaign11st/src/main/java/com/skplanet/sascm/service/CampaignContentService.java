package com.skplanet.sascm.service;

import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.CampaignContentBO;
import com.skplanet.sascm.object.CampaignContentChannelBO;
import com.skplanet.sascm.object.CampaignContentOfferCuBO;
import com.skplanet.sascm.object.CampaignContentOfferPnBO;


public interface CampaignContentService {
	/**
	 * 캠페인컨텐츠 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<CampaignContentBO> getCampaignContentList(Map<String, Object> param) throws Exception;

    public String getCampaignContentListCnt(Map<String, Object> param) throws Exception;

	/**
	 * 캠페인컨텐츠 정보 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int updateCampaignContent(Map<String, Object> param) throws Exception;
	/**
	 * 캠페인컨텐츠아이디정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getOfferContentId(Map<String, Object> param) throws Exception;
	/**
	 * 캠페인컨텐츠 오퍼리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<CampaignContentBO> getCampaignContentsOfferlist(Map<String, Object> param) throws Exception;
	/**
	 * 캠페인컨텐츠 오퍼 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignContentsOffer(Map<String, Object> param) throws Exception;
	/**
	 * 캠페인컨텐츠 오퍼 정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int delCampaignContentsOffer(Map<String, Object> param) throws Exception;
	/**
	 * 캠페인컨텐츠 오퍼 정보 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int updateCampaignContentOffer(Map<String, Object> param) throws Exception;
	/**
	 * 채널 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public CampaignContentBO getChannelInfo(Map<String, Object> param) throws Exception;
	/**
	 * 채널목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<CampaignContentChannelBO> getContentChannelList(Map<String, Object> param) throws Exception;
	/**
	 * 채널정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public CampaignContentChannelBO getChannelDtlInfo(Map<String, Object> param) throws Exception;
	/**
	 * 캠페인컨텐츠 채널 sms 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setContentsChannelSms(Map<String, Object> param) throws Exception;
	/**
	 * 캠페인컨텐츠 채널 email 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setContentsChannelEmail(Map<String, Object> param) throws Exception;
	/**
	 * 캠페인컨텐츠 채널 토스트 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setContentsChannelToast(Map<String, Object> param) throws Exception;
	/**
	 * 캠페인컨텐츠 채널 모바일  정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setContentsChannelMobile(Map<String, Object> param) throws Exception;
	/**
	 * 캠페인컨텐츠 채널 lms  정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setContentsChannelLms(Map<String, Object> param) throws Exception;
	/**
	 * 오퍼 쿠폰 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public CampaignContentOfferCuBO getOfferCuInfo(Map<String, Object> param) throws Exception;
	/**
	 * 오퍼 포인트 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public CampaignContentOfferPnBO getOfferPnInfo(Map<String, Object> param) throws Exception;
	/**
	 * 오퍼 포인트 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setOfferPn(Map<String, Object> param) throws Exception;
	/**
	 * 오퍼 쿠폰정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setOfferCu(Map<String, Object> param) throws Exception;
	/**
	 * 캠페인 오퍼 정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int delCampaignOffer(Map<String, Object> param) throws Exception;
	/**
	 * 캠페인 채널 정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int delChannelInfo(Map<String, Object> param) throws Exception;
}
