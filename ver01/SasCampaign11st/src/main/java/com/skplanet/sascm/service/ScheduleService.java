package com.skplanet.sascm.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.CampaignListBO;
import com.skplanet.sascm.object.CampaignRunResvBO;
import com.skplanet.sascm.object.CampaignRunScheduleBO;

/**
 * ScheduleService
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface ScheduleService {

	/**
	 * 일정정보 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public CampaignRunResvBO getScheduleDetail(Map<String, Object> param) throws Exception;

	/**
	 * 플로차트 갯수 체크
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getFlowChartCnt(Map<String, Object> param) throws Exception;

	/**
	 * 가비지 데이터 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int deleteGarbageData(Map<String, Object> param) throws Exception;

	/**
	 * 유효성 체크1(대상수준이 PCID인데 오퍼가 있거나 채널이 토스트 배너가 아닌지 체크)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCampaignValiChk01(Map<String, Object> param) throws Exception;

	/**
	 * 유효성 체크2(오퍼 템플릿 쿠폰번호 사용여부가 'Y'이고 도서쿠폰 포인트일경우 캠페인 기간이 쿠폰 발급기간에 포함되는지 체크)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCampaignValiChk02(Map<String, Object> param) throws Exception;

	/**
	 * 유효성 체크3(오퍼 템플릿 쿠폰번호 사용여부가 'Y'이고 도서쿠폰 포인트일경우 캠페인 기간이 쿠폰 발급기간에 포함되는지 체크)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCampaignValiChk03(Map<String, Object> param) throws Exception;

	/**
	 * 유효성 체크4(캠페인 기간이 From~To 일 경우에는 채널노출일이 캠페인 기간에 포함되는지 체크)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCampaignValiChk04(Map<String, Object> param) throws Exception;

	/**
	 * 더미오퍼 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignDummyOffer(Map<String, Object> param) throws Exception;

	/**
	 * 캠페인 오퍼 목록 건수 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCampaignOfferCnt(Map<String, Object> param) throws Exception;

	/**
	 * 플로차트 오픈되어있는 건수
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getFlowchartOpenChk(Map<String, Object> param) throws Exception;

	/**
	 * 일정 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignRunResv(Map<String, Object> param) throws Exception;

	/**
	 * 일정 정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int deleteCampaignRunSchedule(Map<String, Object> param) throws Exception;

	/**
	 * 매일 일정 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignRunSchedule01(Map<String, Object> param) throws Exception;

	/**
	 * 매주 일정 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignRunSchedule02(Map<String, Object> param) throws Exception;

	/**
	 * 매월 일정 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignRunSchedule03(Map<String, Object> param) throws Exception;

	/**
	 * 매월 말일 일정 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignRunSchedule04(Map<String, Object> param) throws Exception;

	/**
	 * 사용자 지정 일정 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignRunSchedule05(Map<String, Object> param) throws Exception;

	/**
	 * 지정시간 일정 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignRunSchedule06(Map<String, Object> param) throws Exception;
	
	/**
	 * 캠페인 실행
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignStart(Map<String, Object> param) throws Exception;

	/**
	 * 캠페인 실행 취소
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignCancel(Map<String, Object> param) throws Exception;

	/**
	 * 플로차트 이름 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getFlowchartName(Map<String, Object> param) throws Exception;

	/**
	 * 플로차트 일정 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<CampaignRunScheduleBO> getScheduleList(Map<String, Object> param) throws Exception;

	/**
	 * 일정 목록 건수 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getScheduleListCnt(Map<String, Object> param) throws Exception;

	/**
	 * 일정 목록 성공 체크
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getRunSucessYnChk(Map<String, Object> param) throws Exception;

	/**
	 * 일정 목록 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int deleteScheduleList(Map<String, Object> param) throws Exception;

	/**
	 * 스케쥴이 없으면 오퍼,채널 수정가능함: KANG-20200409
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int updateToEditIfNoSchedule(Map<String, Object> param) throws Exception;

	/**
	 * 일정 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setScheduleList(Map<String, Object> param) throws Exception;

	/**
	 * 테스트 채널 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignTestChannel(Map<String, Object> param) throws Exception;

	/**
	 * 테스트 대상 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignTestTarget(Map<String, Object> param) throws Exception;

	/**
	 * 캠페인 테스트 실행정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCampaignTest(Map<String, Object> param) throws Exception;

	/**
	 * 유효성 체크10(대상수준이 DEVICEID 일때 오퍼를 사용하거나 모바일 알리미 이외 채널 사용여부 체크)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCampaignValiChk10(Map<String, Object> param) throws Exception;
	
	/**
	 * 유효성 체크11(캠페인 전송방식이 Batch 일 경우 각 채널에 대해 노출시간 정보 유무 체크)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCampaignValiChk11(Map<String, Object> param) throws Exception;
	
	public int getRunScheduleCnt(Map<String, Object> param) throws Exception;

	public int campaignStop(Map<String, Object> param) throws Exception;

	/*
	 * KANG-20200508s
	 * (non-Javadoc)
	 * @see com.skplanet.sascm.dao.ScheduleDAO#getCampaignStatusList(java.util.Map)
	 */
	public List<CampaignListBO>  getCampaignStatusList(Map<String, Object> param) throws SQLException;
	public List<CampaignRunScheduleBO>  getScheduleStatusList(Map<String, Object> param) throws SQLException;
	public int updateScheduleStatusList(Map<String, Object> param) throws SQLException;
}
