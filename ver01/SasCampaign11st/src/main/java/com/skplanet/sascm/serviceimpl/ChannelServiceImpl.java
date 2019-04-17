package com.skplanet.sascm.serviceimpl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.ChannelDAO;
import com.skplanet.sascm.object.CampaignChannelBO;
import com.skplanet.sascm.object.ChannelAlimiBO;
import com.skplanet.sascm.object.ChannelBO;
import com.skplanet.sascm.service.ChannelService;

/**
 * ChannelServiceImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Service("channelService")
public class ChannelServiceImpl implements ChannelService {

	@Resource(name = "channelDAO")
	private ChannelDAO channelDAO;

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
	public List<CampaignChannelBO> getCampaignChannelList(Map<String, Object> param) throws Exception {
		return channelDAO.getCampaignChannelList(param);
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
	public ChannelBO getChannelInfo(Map<String, Object> param) throws Exception {
		return channelDAO.getChannelInfo(param);
	}

	/**
	 * 채널 상세 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public ChannelBO getChannelDtlInfo(Map<String, Object> param) throws Exception {
		return channelDAO.getChannelDtlInfo(param);
	}

	/**
	 * 토스트 채널 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setChannelToast(Map<String, Object> param) throws Exception {
		return channelDAO.setChannelToast(param);
	}

	/**
	 * SMS 채널 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setChannelSms(Map<String, Object> param) throws Exception {
		return channelDAO.setChannelSms(param);
	}

	/**
	 * EMAIL 채널 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setChannelEmail(Map<String, Object> param) throws Exception {
		channelDAO.setChannelEmail(param);

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

					channelDAO.setChannelEmail2(param);
				}
			}
		}

		return 1;
	}

	/**
	 * MOBILE 채널 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setChannelMobile(Map<String, Object> param) throws Exception {
		//기본정보 저장
		this.channelDAO.setChannelMobile(param);

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

				this.channelDAO.setChannelMobile2(param);
			}
		}

		return 1;
	}
	
	/**
	 * Toast LinkUrl 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getChannelToastLinkUrl(Map<String, Object> param) throws Exception {
		return channelDAO.getChannelToastLinkUrl(param);
	}
	/**
	 * 토스트 배너 여부 체크
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignChannelValiChk(Map<String, Object> param) throws Exception {
		return channelDAO.getCampaignChannelValiChk(param);
	}
	/**
	 * DEVICEID 대상수준일 경우 Mobile 채널 사용 여부 체크
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignChannelValiChkforMobile(Map<String, Object> param) throws Exception {
		return channelDAO.getCampaignChannelValiChkforMobile(param);
	}
	/**
	 * 채널정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int delChannelInfo(Map<String, Object> param) throws Exception {
		return channelDAO.delChannelInfo(param);
	}
	/**
	 * LMS 채널 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setChannelLms(Map<String, Object> param) throws Exception {
		return channelDAO.setChannelLms(param);
	}
	///////////////////////////////////////////
	/**
	 * MOBILE-ALIMI 채널 정보 삭제: KANG-20190328: add by Kiea Seok Kang
	 * 
	 * @param map
	 * @throws Exception
	 */
	@Override
	public int delChannelMobileAlimi(Map<String, Object> param) throws Exception {
		return this.channelDAO.delChannelMobileAlimi(param);
	}
	/**
	 * MOBILE-ALIMI 채널 정보 검색: KANG-20190328: add by Kiea Seok Kang
	 * 
	 * @param map
	 * @throws Exception
	 */
	@Override
	public ChannelAlimiBO getChannelMobileAlimi(Map<String, Object> param) throws Exception {
		return this.channelDAO.getChannelMobileAlimi(param);
	}
	/**
	 * MOBILE-ALIMI 채널 정보 저장: KANG-20190328: add by Kiea Seok Kang
	 * 
	 * @param map
	 * @throws Exception
	 */
	@Override
	public int setChannelMobileAlimi(Map<String, Object> param) throws Exception {
		return this.channelDAO.setChannelMobileAlimi(param);
	}
	@Override
	public int insertChannelMobileAlimi(Map<String, Object> param) throws Exception {
		return this.channelDAO.insertChannelMobileAlimi(param);
	}
	@Override
	public int updateChannelMobileAlimi(Map<String, Object> param) throws Exception {
		return this.channelDAO.updateChannelMobileAlimi(param);
	}
}
