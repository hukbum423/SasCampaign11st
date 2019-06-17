package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.OfferDAO;
import com.skplanet.sascm.object.CupnStatBO;
import com.skplanet.sascm.object.OfferCouponInfoBO;
import com.skplanet.sascm.object.OfferCuBO;
import com.skplanet.sascm.object.OfferPnBO;

/**
 * OfferDAOImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("offerDAO")
public class OfferDAOImpl extends AbstractDAO implements OfferDAO {

	/**
	 * 오퍼 포인트 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public OfferPnBO getOfferPnInfo(Map<String, Object> param) throws SQLException {
		return (OfferPnBO) selectOne("Offer.getOfferPnInfo", param);
	}

	/**
	 * 오퍼 포인트 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setOfferPn(Map<String, Object> param) throws SQLException {
		return (int) update("Offer.setOfferPn", param);
	}

	/**
	 * 오퍼 쿠폰목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<OfferCuBO> getOfferCuInfoList(Map<String, Object> param) throws SQLException {
		return (List<OfferCuBO>) selectList("Offer.getOfferCuInfoList", param);
	}

	/**
	 * 오퍼 쿠폰 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public OfferCuBO getOfferCuInfo(Map<String, Object> param) throws SQLException {
		return (OfferCuBO) selectOne("Offer.getOfferCuInfo", param);
	}

	/**
	 * 오퍼 쿠폰 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setOfferCu(Map<String, Object> param) throws SQLException {
		return (int) update("Offer.setOfferCu", param);
	}
	/**
	 * OM荑좏룿 �뺣낫 議고쉶
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public OfferCouponInfoBO getOfferTmplCupnInfoOM(Map<String, Object> param) throws SQLException {
		return (OfferCouponInfoBO) selectOne("Offer_om.getOfferTmplCupnInfoOM", param);
	}

	/**
	 * MM荑좏룿 �뺣낫 議고쉶
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public OfferCouponInfoBO getOfferTmplCupnInfoMM(Map<String, Object> param) throws SQLException {
		return (OfferCouponInfoBO) selectOne("Offer_om.getOfferTmplCupnInfoMM", param);
	}
	
	public CupnStatBO getCampaignStat(Map<String, Object> param) throws Exception{
		CupnStatBO getCampaignStat= (CupnStatBO) selectOne("Offer.getCampaignStat", param);
		return getCampaignStat;
	}
}
