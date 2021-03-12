package com.skplanet.sascm.serviceimpl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.CampaignContentDAO;
import com.skplanet.sascm.object.CampaignContentBO;
import com.skplanet.sascm.object.CampaignContentChannelBO;
import com.skplanet.sascm.object.CampaignContentOfferCuBO;
import com.skplanet.sascm.object.CampaignContentOfferPnBO;
import com.skplanet.sascm.service.CampaignContentService;

@Service("campaignContentService")
public class CampaignContentServiceImpl implements CampaignContentService{
	@Resource(name = "campaignContentDAO")
	private CampaignContentDAO campaignContentDAO;

	/**
	 * 캠페인컨텐츠 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<CampaignContentBO> getCampaignContentList(Map<String, Object> param) throws Exception {
		return campaignContentDAO.getCampaignContentList(param);
	}
    
	@Override
    public String getCampaignContentListCnt(Map<String, Object> param) throws Exception {
        return campaignContentDAO.getCampaignContentListCnt(param);
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
	public int updateCampaignContent(Map<String, Object> param) throws Exception {
		return campaignContentDAO.updateCampaignContent(param);
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
	public String getOfferContentId(Map<String, Object> param) throws Exception {
		return this.campaignContentDAO.getOfferContentId(param);
	}
	/**
	 * 캠페인컨텐츠 오퍼 리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<CampaignContentBO> getCampaignContentsOfferlist(Map<String, Object> param) throws Exception {
		return campaignContentDAO.getCampaignContentsOfferlist(param);
	}
	/**
	 * 캠페인컨텐츠 오퍼 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignContentsOffer(Map<String, Object> param) throws Exception {
		return campaignContentDAO.setCampaignContentsOffer(param);
	}
	/**
	 * 캠페인컨텐츠 오퍼 정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int delCampaignContentsOffer(Map<String, Object> param) throws Exception {
		return campaignContentDAO.delCampaignContentsOffer(param);
	}
	/**
	 * 캠페인컨텐츠 오퍼 정보 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int updateCampaignContentOffer(Map<String, Object> param) throws Exception {
		return campaignContentDAO.updateCampaignContentOffer(param);
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
	public CampaignContentBO getChannelInfo(Map<String, Object> param) throws Exception {
		return campaignContentDAO.getChannelInfo(param);
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
	@Override
	public List<CampaignContentChannelBO> getContentChannelList(Map<String, Object> param) throws Exception {
		return campaignContentDAO.getContentChannelList(param);
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
	public  CampaignContentChannelBO getChannelDtlInfo(Map<String, Object> param) throws Exception {
		return campaignContentDAO.getChannelDtlInfo(param);
	}
	/**
	 * 캠페인컨텐츠 채널 sms 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setContentsChannelSms(Map<String, Object> param) throws Exception {
		return campaignContentDAO.setContentsChannelSms(param);
	}
	/**
	 * 캠페인컨텐츠 채널 이메일 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setContentsChannelEmail(Map<String, Object> param) throws Exception {
	    
        //기본정보 저장
	    campaignContentDAO.setContentsChannelEmail(param);

        if (param.get("EMAIL_EDIT_YN").equals("Y")) {
            //content를 짤라서 update한다
            String content_text = (String) param.get("EMAIL_CONTENT");

            int len = content_text.length();

            if (len > 0) {
                int for_cnt = len / 2000; // 2000Byte 씩 자름
                if (len % 2000 != 0) { // 2000Byte 나머지가 0이 아니면 + 1
                    for_cnt++;
                }

                for (int i = 0; i < for_cnt; i++) {
                    int j = i + 1;
                    if (j * 2000 > len) {
                        j = len;
                    } else {
                        j = j * 2000;
                    }

                    param.put("EMAIL_CONTENT", content_text.substring(i * 2000, j));

                    campaignContentDAO.setContentsChannelEmail2(param);
                }
            }
        }
	    
		return 1;
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
	public int setContentsChannelToast(Map<String, Object> param) throws Exception {
		return campaignContentDAO.setContentsChannelToast(param);
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
	public int setContentsChannelMobile(Map<String, Object> param) throws Exception {
	    
        //기본정보 저장
	    campaignContentDAO.setContentsChannelMobile(param);

        //add_text를 짤라서 update한다
        String add_text = (String) param.get("MOBILE_ADD_TEXT");

        int len = add_text.length();

        if (len > 0) {
            int for_cnt = len / 2000; // 2000Byte 씩 자름
            if (len % 2000 != 0) { // 2000Byte 나머지가 0이 아니면 + 1
                for_cnt++;
            }

            for (int i = 0; i < for_cnt; i++) {
                int j = i + 1;
                if (j * 2000 > len) {
                    j = len;
                } else {
                    j = j * 2000;
                }

                param.put("MOBILE_ADD_TEXT", add_text.substring(i * 2000, j));

                campaignContentDAO.setContentsChannelMobile2(param);
            }
        }

        return 1;
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
	public int setContentsChannelLms(Map<String, Object> param) throws Exception {
		return campaignContentDAO.setContentsChannelLms(param);
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
	public CampaignContentOfferCuBO getOfferCuInfo(Map<String, Object> param) throws Exception {
		return campaignContentDAO.getOfferCuInfo(param);
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
	public CampaignContentOfferPnBO getOfferPnInfo(Map<String, Object> param) throws Exception {
		return campaignContentDAO.getOfferPnInfo(param);
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
		return campaignContentDAO.setOfferPn(param);
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
	public int setOfferCu(Map<String, Object> param) throws Exception {
		return campaignContentDAO.setOfferCu(param);
	}
	/**
	 * 캠페인 오퍼 정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int delCampaignOffer(Map<String, Object> param) throws Exception {
		return campaignContentDAO.delCampaignOffer(param);
	}
	/**
	 * 캠페인 채널 정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int delChannelInfo(Map<String, Object> param) throws Exception {
		return campaignContentDAO.delChannelInfo(param);
	}
}
