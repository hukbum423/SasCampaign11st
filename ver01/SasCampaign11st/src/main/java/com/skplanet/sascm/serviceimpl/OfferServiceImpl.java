package com.skplanet.sascm.serviceimpl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.OfferDAO;
import com.skplanet.sascm.dao.OfferDAO2;
import com.skplanet.sascm.object.CupnStatBO;
import com.skplanet.sascm.object.OfferCouponInfoBO;
import com.skplanet.sascm.object.OfferCuBO;
import com.skplanet.sascm.object.OfferCuCtgrBO;
import com.skplanet.sascm.object.OfferPnBO;
import com.skplanet.sascm.service.OfferService;

/**
 * OfferServiceImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Service("offerService")
public class OfferServiceImpl implements OfferService {

	@Resource(name = "offerDAO")
	private OfferDAO offerDAO;
	
	@Resource(name = "offerDAO2")
    private OfferDAO2 offerDAO2;

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
	public OfferPnBO getOfferPnInfo(Map<String, Object> param) throws Exception {
		return offerDAO.getOfferPnInfo(param);
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
	public int setOfferPn(Map<String, Object> param) throws Exception {
		return offerDAO.setOfferPn(param);
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
	@Override
	public List<OfferCuBO> getOfferCuInfoList(Map<String, Object> param) throws Exception {
		return offerDAO.getOfferCuInfoList(param);
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
	public OfferCuBO getOfferCuInfo(Map<String, Object> param) throws Exception {
		return offerDAO.getOfferCuInfo(param);
	}

	/**
	 * OM쿠폰 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public OfferCouponInfoBO getOfferTmplCupnInfoOM(Map<String, Object> param) throws Exception {
		return offerDAO2.getOfferTmplCupnInfoOM(param);
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
	@Override
	public OfferCouponInfoBO getOfferTmplCupnInfoMM(Map<String, Object> param) throws Exception {
		return offerDAO2.getOfferTmplCupnInfoMM(param);
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
	public int setOfferCu(Map<String, Object> param) throws Exception {
		return offerDAO.setOfferCu(param);
	}

	   // BO 카테고리 조회
    public List<OfferCuCtgrBO> getBoCategory(Map<String, Object> param) throws Exception{
        return offerDAO2.getBoCategory(param);
    }

    public List<OfferCuCtgrBO> getBoCategoryList(Map<String, Object> param) throws Exception{
        return offerDAO2.getBoCategoryList(param);
    }
    // BO 하위 카테고리 조회
    public List<OfferCuCtgrBO> getBoSubCategory(Map<String, Object> param) throws Exception{
        return offerDAO2.getBoSubCategory(param);
    }

    public Map<String, Object> copyCoupon(Map<String, Object> param) throws Exception{
        return offerDAO2.copyCoupon(param);
    }
    
    public CupnStatBO getCampaignStat(Map<String, Object> param) throws Exception{
        return offerDAO.getCampaignStat(param);
    }
    
    public void deleteCoupon(Map<String, Object> param) throws Exception{
        offerDAO2.deleteCoupon(param);
    }

    public void copyCouponCtgr(Map<String, Object> param) throws Exception{
        offerDAO2.copyCouponCtgr(param);
    }
    
}
