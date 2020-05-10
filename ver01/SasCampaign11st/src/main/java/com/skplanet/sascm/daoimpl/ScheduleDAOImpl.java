package com.skplanet.sascm.daoimpl;


import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.ScheduleDAO;
import com.skplanet.sascm.object.CampaignListBO;
import com.skplanet.sascm.object.CampaignRunResvBO;
import com.skplanet.sascm.object.CampaignRunScheduleBO;
/**
 * ScheduleDAOImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("scheduleDAO")
public class ScheduleDAOImpl extends AbstractDAO implements ScheduleDAO {

	/**
	 * 일정정보 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public CampaignRunResvBO getScheduleDetail(Map<String, Object> param) throws SQLException {
		return (CampaignRunResvBO) selectOne("Schedule.getScheduleDetail", param);
	}

	/**
	 * 플로차트 갯수 체크
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getFlowChartCnt(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Schedule.getFlowChartCnt", param);
	}

	/**
	 * 가비지 데이터 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */	
	@Override
	public int deleteGarbageData(Map<String, Object> param) throws SQLException {
		 delete("Schedule.deleteGarbageData1", param);
		return (int) delete("Schedule.deleteGarbageData2", param);
	}

	/**
	 * 유효성 체크1(대상수준이 PCID인데 오퍼가 있거나 채널이 토스트 배너가 아닌지 체크)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignValiChk01(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Schedule.getCampaignValiChk01", param);
	}

	/**
	 * 유효성 체크2(오퍼 템플릿 쿠폰번호 사용여부가 'Y'이고 도서쿠폰 포인트일경우 캠페인 기간이 쿠폰 발급기간에 포함되는지 체크)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignValiChk02(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Schedule.getCampaignValiChk02", param);
	}

	/**
	 * 유효성 체크3(오퍼 템플릿 쿠폰번호 사용여부가 'Y'이고 도서쿠폰 포인트일경우 캠페인 기간이 쿠폰 발급기간에 포함되는지 체크)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignValiChk03(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Schedule.getCampaignValiChk03", param);
	}

	/**
	 * 유효성 체크4(캠페인 기간이 From~To 일 경우에는 채널노출일이 캠페인 기간에 포함되는지 체크)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignValiChk04(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Schedule.getCampaignValiChk04", param);
	}

	/**
	 * 더미오퍼 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignDummyOffer(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignDummyOffer", param);
	}

	/**
	 * 캠페인 오퍼 목록 건수 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignOfferCnt(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Schedule.getCampaignOfferCnt", param);
	}

	/**
	 * 플로차트 오픈되어있는 건수
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getFlowchartOpenChk(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Schedule.getFlowchartOpenChk", param);
	}

	/**
	 * 일정 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignRunResv(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignRunResv", param);
	}

	/**
	 * 일정 정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int deleteCampaignRunSchedule(Map<String, Object> param) throws SQLException {
		return (int) delete("Schedule.deleteCampaignRunSchedule", param);
	}

	/**
	 * 매일 일정 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignRunSchedule01(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignRunSchedule01", param);
	}

	/**
	 * 매주 일정 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignRunSchedule02(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignRunSchedule02", param);
	}

	/**
	 * 매월 일정 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignRunSchedule03(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignRunSchedule03", param);
	}

	/**
	 * 매월 말일 일정 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignRunSchedule04(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignRunSchedule04", param);
	}

	/**
	 * 사용자 지정 일정 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignRunSchedule05(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignRunSchedule05", param);
	}
	
	/**
	 * 지정시간 일정 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignRunSchedule06(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignRunSchedule06", param);
	}

	/**
	 * 캠페인 실행
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignStart(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignStart", param);
	}

	/**
	 * 캠페인 실행 취소
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignCancel(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignCancel", param);
	}

	/**
	 * 플로차트 이름 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getFlowchartName(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Schedule.getFlowchartName", param);
	}

	/**
	 * 플로차트 일정 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignRunScheduleBO> getScheduleList(Map<String, Object> param) throws SQLException {
		return (List<CampaignRunScheduleBO>) selectList("Schedule.getScheduleList", param);
	}

	/**
	 * 일정 목록 건수 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getScheduleListCnt(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Schedule.getScheduleListCnt", param);
	}

	/**
	 * 일정 목록 성공 체크
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getRunSucessYnChk(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Schedule.getRunSucessYnChk", param);
	}

	/**
	 * 일정 목록 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int deleteScheduleList(Map<String, Object> param) throws SQLException {
		return (int) delete("Schedule.deleteScheduleList", param);
	}

	/**
	 * 스케쥴이 없으면 오퍼,채널 수정가능함: KANG-20200409
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int updateToEditIfNoSchedule(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.updateToEditIfNoSchedule", param);
	}

	/**
	 * 일정 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setScheduleList(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setScheduleList", param);
	}

	/**
	 * 테스트 채널 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignTestChannel(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignTestChannel", param);
	}

	/**
	 * 테스트 대상 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignTestTarget(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignTestTarget", param);
	}

	/**
	 * 캠페인 테스트 실행정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCampaignTest(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.setCampaignTest", param);
	}

	/**
	 * 유효성 체크10(대상수준이 DEVICEID 일때 오퍼를 사용하거나 모바일 알리미 이외 채널 사용여부 체크)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignValiChk10(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Schedule.getCampaignValiChk10", param);
	}
	
	/**
	 * 유효성 체크11(캠페인 전송방식이 Batch 일 경우 각 채널에 대해 노출시간 정보 유무 체크)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCampaignValiChk11(Map<String, Object> param) throws SQLException {
		return (String)selectOne("Schedule.getCampaignValiChk11", param);
	}

	@Override
	public int getRunScheduleCnt(Map<String, Object> param) throws SQLException {
		return (int) selectOne("Schedule.getRunScheduleCnt", param);
	}
	
	@Override
	public int campaignStop(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.campaignStop", param);
	}

	/*
	 * KANG-20200508s
	 * (non-Javadoc)
	 * @see com.skplanet.sascm.dao.ScheduleDAO#getCampaignStatusList(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignListBO> getCampaignStatusList(Map<String, Object> param) throws SQLException {
		return (List<CampaignListBO>) selectList("Schedule.getCampaignStatusList", param);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<CampaignRunScheduleBO> getScheduleStatusList(Map<String, Object> param) throws SQLException {
		return (List<CampaignRunScheduleBO>) selectList("Schedule.getScheduleStatusList", param);
	}

	@Override
	public int updateScheduleStatusList(Map<String, Object> param) throws SQLException {
		return (int) update("Schedule.updateScheduleStatusList", param);
	}
}
