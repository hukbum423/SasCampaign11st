package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.ChannelDAO;
import com.skplanet.sascm.object.CampaignChannelBO;
import com.skplanet.sascm.object.ChannelAlimiBO;
import com.skplanet.sascm.object.ChannelBO;

/**
 * SqlSessionDaoSupport
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("channelDAO")
public class ChannelDAOImpl extends AbstractDAO implements ChannelDAO {
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
	public List<CampaignChannelBO> getCampaignChannelList(Map<String, Object> param) throws SQLException {
		return (List<CampaignChannelBO>) selectList("Channel.getCampaignChannelList", param);
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
	public ChannelBO getChannelInfo(Map<String, Object> param) throws SQLException {
		return (ChannelBO) selectOne("Channel.getChannelInfo", param);
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
	public ChannelBO getChannelDtlInfo(Map<String, Object> param) throws SQLException {
		return (ChannelBO) selectOne("Channel.getChannelDtlInfo", param);
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
	public int setChannelToast(Map<String, Object> param) throws SQLException {
		return (int) update("Channel.setChannelToast", param);
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
	public int setChannelSms(Map<String, Object> param) throws SQLException {
		return (int) update("Channel.setChannelSms", param);
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
	public int setChannelEmail(Map<String, Object> param) throws SQLException {
		return (int) update("Channel.setChannelEmail", param);
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
	public int setChannelEmail2(Map<String, Object> param) throws SQLException {
		return (int) update("Channel.setChannelEmail2", param);
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
	public int setChannelMobile(Map<String, Object> param) throws SQLException {
		return (int) update("Channel.setChannelMobile", param);
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
	public int setChannelMobile2(Map<String, Object> param) throws SQLException {
		return (int) update("Channel.setChannelMobile2", param);
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
	public String getChannelToastLinkUrl(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Channel.getChannelToastLinkUrl", param);
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
	public String getCampaignChannelValiChk(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Channel.getCampaignChannelValiChk", param);
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
	public String getCampaignChannelValiChkforMobile(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Channel.getCampaignChannelValiChkforMobile", param);
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
	public int delChannelInfo(Map<String, Object> param) throws SQLException {
		return (int) delete("Channel.delChannelInfo", param);
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
	public int setChannelLms(Map<String, Object> param) throws SQLException {
		return (int) update("Channel.setChannelLms", param);
	}

	///////////////////////////////////////////
	/**
	 * MOBILE-ALIMI 채널 정보 삭제: KANG-20190328: add by Kiea Seok Kang
	 *
	 * @param param
	 * @return
	 * @throws SQLException
	 */
	@Override
	public int delChannelMobileAlimi(Map<String, Object> param) {
		return (int) delete("Channel.delChannelMobileAlimi", param);
	}

	/**
	 * MOBILE-ALIMI 채널 정보 검색: KANG-20190328: add by Kiea Seok Kang
	 *
	 * @param param
	 * @return
	 * @throws SQLException
	 */
	@Override
	public ChannelAlimiBO getChannelMobileAlimi(Map<String, Object> param) {
		return (ChannelAlimiBO) selectOne("Channel.getChannelMobileAlimi", param);
	}

	/**
	 * MOBILE-ALIMI 채널 정보 저장: KANG-20190328: add by Kiea Seok Kang
	 *
	 * @param param
	 * @return
	 * @throws SQLException
	 */
	@Override
	public int setChannelMobileAlimi(Map<String, Object> param) throws SQLException {
		return (int) update("Channel.setChannelMobileAlimi", param);
	}

	@Override
	public int insertChannelMobileAlimi(Map<String, Object> param) throws SQLException {
		return (int) insert("Channel.insertChannelMobileAlimi", param);
	}

	@Override
	public int updateChannelMobileAlimi(Map<String, Object> param) throws SQLException {
		return (int) update("Channel.updateChannelMobileAlimi", param);
	}
}
