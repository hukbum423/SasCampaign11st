package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.Abstract2DAO;
import com.skplanet.sascm.dao.OfferDAO2;
import com.skplanet.sascm.object.OfferCouponInfoBO;
import com.skplanet.sascm.object.OfferCuCtgrBO;

/**
 * OfferDAOImpl
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("offerDAO2")
public class OfferDAO2Impl extends Abstract2DAO implements OfferDAO2 {

	/**
	 * OM쿠폰 정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public OfferCouponInfoBO getOfferTmplCupnInfoOM(Map<String, Object> param) throws SQLException{
		return (OfferCouponInfoBO) selectOne("Offer_om.getOfferTmplCupnInfoOM", param);
	}

	/**
	 * MM쿠폰 정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public OfferCouponInfoBO getOfferTmplCupnInfoMM(Map<String, Object> param) throws SQLException{
		return (OfferCouponInfoBO) selectOne("Offer_om.getOfferTmplCupnInfoMM", param);
	}

	@SuppressWarnings("unchecked")
	public List<OfferCuCtgrBO> getBoCategory(Map<String, Object> param) throws Exception{
		return (List<OfferCuCtgrBO>) selectList("Offer_om.getBoCategory", param);
	}

	@SuppressWarnings("unchecked")
	public List<OfferCuCtgrBO> getBoCategoryList(Map<String, Object> param) throws Exception{
		return (List<OfferCuCtgrBO>) selectList("Offer_om.getBoCategoryList", param);
	}

	@SuppressWarnings("unchecked")
	public List<OfferCuCtgrBO> getBoSubCategory(Map<String, Object> param) throws Exception{
		return (List<OfferCuCtgrBO>) selectList("Offer_om.getBoSubCategory", param);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> copyCoupon(Map<String, Object> param) throws Exception{
		Map<String, Object> cpcoupon = (Map<String, Object>) selectOne("Offer_om.copyCoupon", param);
		return cpcoupon;
	}

	public void deleteCoupon(Map<String, Object> param) throws Exception{
		delete("Offer_om.deleteCoupon", param);
	}

	public void copyCouponCtgr(Map<String, Object> param) throws Exception{
		selectOne("Offer_om.copyCouponCtgr", param);
	}
}
