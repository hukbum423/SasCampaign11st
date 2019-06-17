package com.skplanet.sascm.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.CupnStatBO;
import com.skplanet.sascm.object.OfferCuBO;
import com.skplanet.sascm.object.OfferPnBO;
import com.skplanet.sascm.object.OfferCouponInfoBO;
/**
 * OfferDAO
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface OfferDAO {

	/**
	 * 오퍼 포인트 정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public OfferPnBO getOfferPnInfo(Map<String, Object> param) throws SQLException;

	/**
	 * 오퍼 포인트 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setOfferPn(Map<String, Object> param) throws SQLException;

	/**
	 * 오퍼 쿠폰목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<OfferCuBO> getOfferCuInfoList(Map<String, Object> param) throws SQLException;

	/**
	 * 오퍼 쿠폰 정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public OfferCuBO getOfferCuInfo(Map<String, Object> param) throws SQLException;

	/**
	 * 오퍼 쿠폰 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setOfferCu(Map<String, Object> param) throws SQLException;
	/**
	 * OM 임시쿠폰정보를 얻는다.
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public OfferCouponInfoBO getOfferTmplCupnInfoOM(Map<String, Object> param) throws SQLException;
	/**
	 * MM 임시쿠폰정보를 얻는다.
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public OfferCouponInfoBO getOfferTmplCupnInfoMM(Map<String, Object> param) throws SQLException;


	public CupnStatBO getCampaignStat(Map<String, Object> param) throws Exception;
}
