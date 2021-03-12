package com.skplanet.sascm.service;

import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.CupnStatBO;
import com.skplanet.sascm.object.OfferCouponInfoBO;
import com.skplanet.sascm.object.OfferCuBO;
import com.skplanet.sascm.object.OfferCuCtgrBO;
import com.skplanet.sascm.object.OfferPnBO;

/**
 * OfferService
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface OfferService {

	/**
	 * 오퍼 포인트 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public OfferPnBO getOfferPnInfo(Map<String, Object> param) throws Exception;

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
	 * 오퍼 쿠폰목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<OfferCuBO> getOfferCuInfoList(Map<String, Object> param) throws Exception;

	/**
	 * 오퍼 쿠폰 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public OfferCuBO getOfferCuInfo(Map<String, Object> param) throws Exception;

	/**
	 * OM쿠폰 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public OfferCouponInfoBO getOfferTmplCupnInfoOM(Map<String, Object> param) throws Exception;

	/**
	 * MM쿠폰 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public OfferCouponInfoBO getOfferTmplCupnInfoMM(Map<String, Object> param) throws Exception;

	/**
	 * 오퍼 쿠폰 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setOfferCu(Map<String, Object> param) throws Exception;

	// BO 카테고리 조회
	public List<OfferCuCtgrBO> getBoCategory(Map<String, Object> param) throws Exception;
	
	public List<OfferCuCtgrBO> getBoCategoryList(Map<String, Object> param) throws Exception;

    public List<OfferCuCtgrBO> getBoSubCategory(Map<String, Object> param) throws Exception;
    
    public Map<String, Object> copyCoupon(Map<String, Object> param) throws Exception;
    
    public CupnStatBO getCampaignStat(Map<String, Object> param) throws Exception;
    
    public void deleteCoupon(Map<String, Object> param) throws Exception;

    public void copyCouponCtgr(Map<String, Object> param) throws Exception;
}
