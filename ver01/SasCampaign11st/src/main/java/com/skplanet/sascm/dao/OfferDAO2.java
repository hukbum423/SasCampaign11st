package com.skplanet.sascm.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.OfferCouponInfoBO;
import com.skplanet.sascm.object.OfferCuCtgrBO;


/**
 * OfferDAO2
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface OfferDAO2 {

	/**
	 * OM쿠폰 정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public OfferCouponInfoBO getOfferTmplCupnInfoOM(Map<String, Object> param) throws SQLException;

	/**
	 * MM쿠폰 정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public OfferCouponInfoBO getOfferTmplCupnInfoMM(Map<String, Object> param) throws SQLException;

	public List<OfferCuCtgrBO> getBoCategory(Map<String, Object> param) throws Exception;

	public List<OfferCuCtgrBO> getBoCategoryList(Map<String, Object> param) throws Exception;

	public List<OfferCuCtgrBO> getBoSubCategory(Map<String, Object> param) throws Exception;

	public Map<String, Object> copyCoupon(Map<String, Object> param) throws Exception;

	public void deleteCoupon(Map<String, Object> param) throws Exception;

	public void copyCouponCtgr(Map<String, Object> param) throws Exception;
}
