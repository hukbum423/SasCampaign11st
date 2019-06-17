package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.Abstract2DAO;
import com.skplanet.sascm.dao.CampaignInfo2DAO;
import com.skplanet.sascm.object.CampaignChannelBO;
import com.skplanet.sascm.object.CampaignInfoBO;
import com.skplanet.sascm.object.CampaignListBO;
import com.skplanet.sascm.object.CampaignOfferBO;

/**
 * CampaignInfoDAOImpl
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("campaignInfo2DAO")
public class CampaignInfo2DAOImpl extends Abstract2DAO implements CampaignInfo2DAO {

	/**
	 * 캠페인 정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public CampaignInfoBO getCampaignInfo(Map<String, Object> param) throws SQLException {
		return (CampaignInfoBO) selectOne("CampaignInfo2.getCampaignInfo", param);
	}

	/**
	 * 캠페인 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignInfo(Map<String, Object> param) throws SQLException {
		return (int) update("CampaignInfo2.setCampaignInfo", param);
	}

	/**
	 * 채널 우선순위 수정
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setChannelPriority(Map<String, Object> param) throws SQLException {
		return (int) update("CampaignInfo2.setChannelPriority", param);
	}

	/**
	 * 오퍼 목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignOfferBO> getCampaignOfferList(Map<String, Object> param) throws SQLException {
		return (List<CampaignOfferBO>) selectList("CampaignInfo2.getCampaignOfferList", param);
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
	public List<CampaignChannelBO> getCampaignChannelList(Map<String, Object> param) throws SQLException {
		return (List<CampaignChannelBO>) selectList("CampaignInfo2.getCampaignChannelList", param);
	}

	/**
	 * 오퍼 사용여부 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignOfferUseChk(Map<String, Object> param) throws SQLException {
		return (String) selectOne("CampaignInfo2.getCampaignOfferUseChk", param);
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
		return (String) selectOne("CampaignInfo2.getCampaignChannelValiChk", param);
	}

	/**
	 * 더미오퍼의 사용여부 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignChannelValiChk2(Map<String, Object> param) throws SQLException {
		return (String) selectOne("CampaignInfo2.getCampaignChannelValiChk2", param);
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
		return (int) delete("CampaignInfo2.delChannelInfo", param);
	}

	/**
	 * DEVICEID 대상수준일 경우 더미오퍼의 사용여부 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignChannelValiChkforDeviceId(Map<String, Object> param) throws SQLException {
		return (String) selectOne("CampaignInfo2.getCampaignChannelValiChkforDeviceId", param);
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
		return (String) selectOne("CampaignInfo2.getCampaignChannelValiChkforMobile", param);
	}

	/**
	 * 채널 발송시간 수정
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setChannelDispTime(Map<String, Object> param) throws SQLException {
		return (int) update("CampaignInfo2.setChannelDispTime", param);
	}

	/**
	 * 캠페인 폴더 리스트 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignListBO> getCampaignFolderList(Map<String, Object> param) throws SQLException {
		return (List<CampaignListBO>) selectList("CampaignInfo2.getCampaignFolderList", param);
	}

	/**
	 * 캠페인 리스트 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignListBO> getCampaignList(Map<String, Object> param) throws SQLException {
		return (List<CampaignListBO>) selectList("CampaignInfo2.getCampaignList", param);
	}
}
