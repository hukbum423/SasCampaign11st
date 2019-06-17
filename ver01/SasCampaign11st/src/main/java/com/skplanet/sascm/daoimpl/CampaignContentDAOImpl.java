package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.CampaignContentDAO;
import com.skplanet.sascm.object.CampaignContentBO;
import com.skplanet.sascm.object.CampaignContentChannelBO;
import com.skplanet.sascm.object.CampaignContentOfferCuBO;
import com.skplanet.sascm.object.CampaignContentOfferPnBO;



@Repository("campaignContentDAO")
public class CampaignContentDAOImpl extends AbstractDAO implements CampaignContentDAO {
	/**
	 * 캠페인컨텐츠 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignContentBO> getCampaignContentList(Map<String, Object> param) throws SQLException {
		return (List<CampaignContentBO>) selectList("CampaignContent.getCampaignContentList", param);
	}
	
	@Override
    public String getCampaignContentListCnt(Map<String, Object> param) throws SQLException {
        return (String) selectOne("CampaignContent.getCampaignContentListCnt", param);
    }
	
	/**
	 * 캠페인컨텐츠 정보 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int updateCampaignContent(Map<String, Object> param) throws SQLException {
		return (int) update("CampaignContent.updateCampaignContent", param);
	}
	/**
	 * 캠페인컨텐츠아이디 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getOfferContentId(Map<String, Object> param) throws SQLException {
		return (String) selectOne("CampaignContent.getOfferContentId", param);
	}
	/**
	 * 캠페인컨텐츠 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignContentBO> getCampaignContentsOfferlist(Map<String, Object> param) throws SQLException {
		return (List<CampaignContentBO>) selectList("CampaignContent.getCampaignContentsOfferlist", param);
	}
	/**
	 * 캠페인컨텐츠 오퍼정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignContentsOffer(Map<String, Object> param) throws SQLException {
		return (int) insert("CampaignContent.setCampaignContentsOffer", param);
	}
	/**
	 * 캠페인컨텐츠 오퍼정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int delCampaignContentsOffer(Map<String, Object> param) throws SQLException {
		return (int) delete("CampaignContent.delCampaignContentsOffer", param);
	}
	/**
	 * 캠페인컨텐츠 오퍼정보 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int updateCampaignContentOffer(Map<String, Object> param) throws SQLException {
		return (int) update("CampaignContent.updateCampaignContentOffer", param);
	}
	/**
	 * 채널 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public CampaignContentBO getChannelInfo(Map<String, Object> param) throws SQLException {
		return (CampaignContentBO) selectOne("CampaignContent.getChannelInfo", param);
	}
	/**
	 * 채널 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignContentChannelBO> getContentChannelList(Map<String, Object> param) throws SQLException {
		return (List<CampaignContentChannelBO>) selectList("CampaignContent.getContentChannelList", param);
	}
	/**
	 * 채널 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public CampaignContentChannelBO getChannelDtlInfo(Map<String, Object> param) throws SQLException {
		return (CampaignContentChannelBO) selectOne("CampaignContent.getChannelDtlInfo", param);
	}
	/**
	 * 캠페인컨텐츠 채널 sms 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setContentsChannelSms(Map<String, Object> param) throws SQLException {
		return (int) insert("CampaignContent.setContentsChannelSms", param);
	}
	/**
	 * 캠페인컨텐츠 채널 이메일 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setContentsChannelEmail(Map<String, Object> param) throws SQLException {
		return (int) insert("CampaignContent.setContentsChannelEmail", param);
	}
    @Override
    public int setContentsChannelEmail2(Map<String, Object> param) throws SQLException {
        return (int) insert("CampaignContent.setContentsChannelEmail2", param);
    }
	/**
	 * 캠페인컨텐츠 채널 토스트 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setContentsChannelToast(Map<String, Object> param) throws SQLException {
		return (int) insert("CampaignContent.setContentsChannelToast", param);
	}
	/**
	 * 캠페인컨텐츠 채널 모바일 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setContentsChannelMobile(Map<String, Object> param) throws SQLException {
		return (int) insert("CampaignContent.setContentsChannelMobile", param);
	}

   @Override
    public int setContentsChannelMobile2(Map<String, Object> param) throws SQLException {
        return (int) update("CampaignContent.setContentsChannelMobile2", param);
    }

	/**
	 * 캠페인컨텐츠 채널 lms 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setContentsChannelLms(Map<String, Object> param) throws SQLException {
		return (int) insert("CampaignContent.setContentsChannelLms", param);
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
	public CampaignContentOfferCuBO getOfferCuInfo(Map<String, Object> param) throws SQLException {
		return (CampaignContentOfferCuBO) selectOne("CampaignContent.getOfferCuInfo", param);
	}
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
	public CampaignContentOfferPnBO getOfferPnInfo(Map<String, Object> param) throws SQLException {
		return (CampaignContentOfferPnBO) selectOne("CampaignContent.getOfferPnInfo", param);
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
		return (int) update("CampaignContent.setOfferPn", param);
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
		return (int) update("CampaignContent.setOfferCu", param);
	}
	/**
	 * 캠페인컨텐츠 오퍼정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int delCampaignOffer(Map<String, Object> param) throws SQLException {
		return (int) delete("CampaignContent.delCampaignOffer", param);
	}
	/**
	 * 캠페인컨텐츠 채널정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int delChannelInfo(Map<String, Object> param) throws SQLException {
		return (int) delete("CampaignContent.delChannelInfo", param);
	}
}
