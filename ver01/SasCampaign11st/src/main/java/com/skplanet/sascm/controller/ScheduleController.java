package com.skplanet.sascm.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.view.json.MappingJacksonJsonView;

import com.skplanet.sascm.object.CampaignChannelBO;
import com.skplanet.sascm.object.CampaignInfoBO;
import com.skplanet.sascm.object.CampaignRunResvBO;
import com.skplanet.sascm.object.CampaignRunScheduleBO;
import com.skplanet.sascm.object.OfferCouponInfoBO;
import com.skplanet.sascm.object.OfferCuBO;
import com.skplanet.sascm.object.UaextCampaignTesterBO;
import com.skplanet.sascm.object.UaextCodeDtlBO;
import com.skplanet.sascm.object.UsmUserBO;
import com.skplanet.sascm.service.CampaignInfoService;
import com.skplanet.sascm.service.ChannelService;
import com.skplanet.sascm.service.CommCodeService;
import com.skplanet.sascm.service.OfferService;
import com.skplanet.sascm.service.ScheduleService;
import com.skplanet.sascm.service.TestTargetService;
import com.skplanet.sascm.util.Common;
import com.skplanet.sascm.util.Flag;

@Controller
public class ScheduleController {

	private final Log log = LogFactory.getLog(getClass());

	@Resource(name = "commCodeService")
	private CommCodeService commCodeService;

	@Resource(name = "scheduleService")
	private ScheduleService scheduleService;

	@Resource(name = "campaignInfoService")
	private CampaignInfoService campaignInfoService;

	@Resource(name = "testTargetService")
	private TestTargetService testTargetService;

	@Resource(name = "offerService")
	private OfferService offerService;

	@Resource(name = "channelService")
	private ChannelService channelService;

	@Autowired
	private MappingJacksonJsonView jsonView;

	@Value("#{contextProperties['server.static.url.sasurl']}")
	private String staticPATHSasurl;

	/**
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/schedule/scheduler.do")
	public String scheduler(HttpServletRequest request, Model model) {
		return "schedule/scheduler.jsp";
	}

	/**
	 *
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/schedule/schedule.do")
	public String pageScheduleDetail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//실행일정 구분 목록 조회
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("codeId", "C014");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> runResvType_list = commCodeService.getCommCodeDtlList(map);

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("=============================================");

		//실행예약 정보 조회
		map.put("CAMPAIGNID",request.getParameter("CampaignId"));;

		CampaignRunResvBO bo = null;

		//플로차트 갯수가 1개인지 체크
		//String flowChartCnt = scheduleService.getFlowChartCnt(map);
		//log.info("flowChartCnt(Y : 플로차트 1개 : " + flowChartCnt);

		//if (flowChartCnt.equals("Y")) {
		bo = scheduleService.getScheduleDetail(map);
		//}

		//일정 목록 조회
		map.put("SEARCH_TYPE", "");
		String total = scheduleService.getScheduleListCnt(map);
		map.put("searchRangeStart", "1");
		map.put("searchRangeEnd", total);
		List<CampaignRunScheduleBO> list = scheduleService.getScheduleList(map);

		modelMap.addAttribute("runResvType_list", runResvType_list);
		//modelMap.addAttribute("flowChartCnt", flowChartCnt);
		modelMap.addAttribute("list", list);

		log.debug("bo.manual_trans_yn : " + bo.getManual_trans_yn());

		modelMap.addAttribute("user", user);
		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("CAMPAIGNID", request.getParameter("CampaignId"));

		return "schedule/schedule";
	}

	/**
	 * 스케줄 목록
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/schedule/scheduleList.do")
	public void pageScheduleList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("=============================================");

		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));

		CampaignRunResvBO bo = this.scheduleService.getScheduleDetail(map);

		modelMap.addAttribute("user", user);
		modelMap.addAttribute("bo", bo);

		map.put("user", user);
		map.put("bo", bo);

		jsonView.render(map, request, response);
	}

	/**
	 * 캠페인일정 등록하기전에 실행된 일정이 실패인지 아닌지 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getRunSucessYnChk.do")
	public void getRunSucessYnChk(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId        : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE      : " + request.getParameter("CAMPAIGNCODE"));
		log.info("=============================================");

		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));

		String ALL_FAIL = scheduleService.getRunSucessYnChk(map);

		map.put("ALL_FAIL", ALL_FAIL);

		jsonView.render(map, request, response);
	}

	/**
	 * 캠페인 테스트 실행 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/schedule/campaignTest.do")
	public String campaignTest(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//채널 목록 조회
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("SMEM_ID   : " + request.getParameter("SMEM_ID"));
		log.info("=============================================");

		//실행예약 정보 조회
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("SMEM_ID", Common.nvl(request.getParameter("SMEM_ID"), ""));

		//채널정보
		List<CampaignChannelBO> channel_list = channelService.getCampaignChannelList(map);

		//테스트 대상 목록 조회
		List<UaextCampaignTesterBO> list = testTargetService.getTestTargetList(map);

		//캠페인 정보 조회
		CampaignRunResvBO bo = scheduleService.getScheduleDetail(map);

		modelMap.addAttribute("channel_list", channel_list);
		modelMap.addAttribute("TestTargetList", list);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("bo", bo);

		return "schedule/campaignTest";
	}

	/**
	 * 일정상세 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setScheduleDetail.do")
	public void setScheduleDetail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("CampaignId        : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE      : " + request.getParameter("CAMPAIGNCODE"));

		log.info("RSRV_GUBUN_CODE   : " + request.getParameter("RSRV_GUBUN_CODE"));
		log.info("=============================================");

		String return_code = "";
		String return_msg  = "";

		//일정상세 저장
		String RSRV_GUBUN_CODE = Common.nvl(request.getParameter("RSRV_GUBUN_CODE"), ""); //일정구분 (01 : 매일, 02 : 매주, 03 : 매월, 04 : 매월 말일, 05 : 사용자 지정, 06 : 지정시간)

		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("CREATE_ID", Common.nvl(user.getId(), ""));
		map.put("UPDATE_ID", Common.nvl(user.getId(), ""));

		log.info("=============================================");
		log.info("캠페인 일정등록 유효성 체크");

		//플로차트 갯수가 1개인지 체크
		String flowChartCnt = scheduleService.getFlowChartCnt(map);
		log.info("[Step1] flowChartCnt(Y 진행가능) : " + flowChartCnt);

		if (flowChartCnt.equals("E")) {
			return_code = "ERR_02"; //플로차트가 없음
			log.info("[Step1_ERR] 플로차트 미존재 ");
		} else if (flowChartCnt.equals("N")) {
			return_code = "ERR_03"; //플로차트가 2개이상
			log.info("[Step1_ERR] 플로차트 2개이상 존재 ");
		}

		//대상수준이 PCID인데 오퍼가 있거나 채널이 토스트 배너가 아닌게 있으면 에러처리
		if (return_code.equals("")) {
			String valiChk = scheduleService.getCampaignValiChk01(map);
			log.info("[Step2] valiChk1(Y 진행가능) : " + valiChk);
			if (valiChk.equals("N")) {
				return_code = "ERR_06";
				log.info("[Step2_ERR] 대상수준이 PCID에 오퍼나, 토스트배너 아닌 채널 정보가 입력되어있습니다. ");
			}
		}

		//오퍼 템플릿 쿠폰번호사용이 Y일 경우 캠페인 기간과 쿠폰유효기간이 동일한지 체크
		if (return_code.equals("")) {   // KANG-20200407 KANG-20200508
			List<OfferCuBO> list = offerService.getOfferCuInfoList(map);

			for (int i = 0; i < list.size(); i++) {
				OfferCuBO list_bo = (OfferCuBO) list.get(i);

				if (list_bo.getTmpl_cupn_no_use_yn().equals("Y")) { //오퍼 템플릿 쿠폰 사용여부가

					//템플릿 쿠폰번호 조회
					map.put("S_TMPL_CUPN_NO", list_bo.getTmpl_cupn_no());
					map.put("OFFER_TYPE_CD", list_bo.getOffer_type_cd());
					OfferCouponInfoBO bo = new OfferCouponInfoBO();

					if (list_bo.getOffer_sys_cd().equals("OM")) { //OM쿠폰정보 조회
						bo = offerService.getOfferTmplCupnInfoOM(map);
					} else if (list_bo.getOffer_sys_cd().equals("MM")) { //MM쿠폰정보 조회
						bo = offerService.getOfferTmplCupnInfoMM(map);
					}

					map.put("ISS_CN_BGN_DT", bo.getIss_cn_bgn_dt2());
					map.put("ISS_CN_END_DT", bo.getIss_cn_end_dt2());

					String valiChk = "";

					if (list_bo.getOffer_type_cd().equals("PN")) {
						valiChk = scheduleService.getCampaignValiChk03(map);

						log.info("[Step3] valiChk2(Y 진행가능) : " + valiChk);

						if (valiChk.equals("N")) {
							return_code = "ERR_07_1";
							log.info("[Step3_ERR] 오퍼 템플릿 쿠폰번호 사용여부가 'Y'이고 도서쿠폰 포인트일경우 캠페인 기간이 쿠폰 발급기간에 포함되어야 합니다");
						}

					} else {
						valiChk = scheduleService.getCampaignValiChk02(map);

						log.info("[Step3] valiChk2(Y 진행가능) : " + valiChk);

						if (valiChk.equals("N")) {
							return_code = "ERR_07_2";
							log.info("[Step3_ERR] 오퍼 템플릿 쿠폰번호 사용여부가 'Y'일경우에는 캠페인 기간과 쿠폰 발급기간이 동일해야 합니다");
						}
					}

					if (!return_code.equals("")) {
						break;
					}
				}
			}
		}

		//오퍼 템플릿 쿠폰번호 사용이 N일 경우 캠페인 기간이 쿠폰유효기간에 포함되는 체크
		if (return_code.equals("")) {   // KANG-20200407 KANG-20200508
			List<OfferCuBO> list = offerService.getOfferCuInfoList(map);

			for (int i = 0; i < list.size(); i++) {
				OfferCuBO list_bo = list.get(i);

				if (list_bo.getTmpl_cupn_no_use_yn().equals("N")) { //오퍼 템플릿 쿠폰 사용여부가 'N'

					//템플릿 쿠폰번호 조회
					map.put("S_TMPL_CUPN_NO", list_bo.getTmpl_cupn_no());
					map.put("OFFER_TYPE_CD", list_bo.getOffer_type_cd());

					OfferCouponInfoBO bo = new OfferCouponInfoBO();

					if (list_bo.getOffer_sys_cd().equals("OM")) { //OM쿠폰정보 조회
						bo = offerService.getOfferTmplCupnInfoOM(map);
					} else if (list_bo.getOffer_sys_cd().equals("MM")) { //MM쿠폰정보 조회
						bo = offerService.getOfferTmplCupnInfoMM(map);
					}

					map.put("ISS_CN_BGN_DT", bo.getIss_cn_bgn_dt2());
					map.put("ISS_CN_END_DT", bo.getIss_cn_end_dt2());

					String valiChk = scheduleService.getCampaignValiChk03(map);
					log.info("[Step4] valiChk3(Y 진행가능) : " + valiChk);

					if (valiChk.equals("N")) {
						return_code = "ERR_08";
						log.info("[Step4_ERR] 오퍼 템플릿 쿠폰번호 사용여부가 'N'일경우에는 캠페인 기간이 쿠폰 발급기간에 포함되어야 합니다");
					}
				}
			}
		}

		//캠페인 가긴 타입이 FROM~TO일경우 채널 노출일이 캠페인 기간에 포함되는지 체크
		if (return_code.equals("")) {
			String valiChk = scheduleService.getCampaignValiChk04(map);
			log.info("[Step5] valiChk4(Y 진행가능) : " + valiChk);

			if (valiChk.equals("N")) {
				return_code = "ERR_09";
				log.info("[Step5_ERR] 캠페인 기간이 From~To 일 경우에는 채널노출일이 캠페인 기간에 포함되어야 합니다");
			}
		}

		if (return_code.equals("")) {

			//캠페인 채널, 캠페인 오퍼 가비지 데이터 삭제(플로차트 변경으로 가비지된데이터 삭제)
			scheduleService.deleteGarbageData(map);
			log.info("캠페인 채널, 캠페인 오퍼 가비지 데이터 삭제 완료");

			//더미오퍼값 캠페인 오퍼 테이블에 입력해주기
			scheduleService.setCampaignDummyOffer(map);

			//시스템테이블의 세그먼트 수와 AddOn테이블의 오퍼갯수가 일치한지 체크
			String offerCnt = scheduleService.getCampaignOfferCnt(map);
			log.info("[Step6] offerCnt(Y 진행가능) : " + offerCnt);

			if (offerCnt.equals("N")) {
				return_code = "ERR_04"; //세그먼트갯수와 오퍼갯수가 동일하지 않음
				log.info("[Step6_ERR] 오퍼정보가 입력되지 않았습니다 ");
			}

			//플로차트 열고있는지 체크
			//          String flowchartOpenChk = scheduleService.getFlowchartOpenChk(map);
			//          if(flowchartOpenChk.equals("Y")){
			//              return_code = "ERR_05"; //플로차트가 수정중이라서 파일 권한변경이 안됨(에러처리)
			//              log.info("[Step3_ERR] 플로차트를 닫고 진행하십시오");
			//          }

		}

		//대상수준이 DEVICE_ID 인데 오퍼가 있거나 채널이 모바일 알리미가 아닌게 있으면 에러처리
		if (return_code.equals("")){
			String valiChk = scheduleService.getCampaignValiChk10(map);
			log.info("[Step10] valiChk1(Y 진행가능) : " + valiChk);
			if (valiChk.equals("N")) {
				return_code = "ERR_10";
				log.info("[Step10_ERR] 대상수준이 DEVICEID 에 오퍼나, 모바일 알리미 아닌 채널 정보가 입력되어있습니다. ");
			}
		}

		//캠페인 데이터전송방식이 Batch인 경우 채널 정보에 발송시간이 null 인 데이터가 있을 경우 에러처리
		if (return_code.equals("")){
			String valiChk = scheduleService.getCampaignValiChk11(map);
			log.info("[Step11] valiChk1(Y 진행가능) : " + valiChk);
			if (!valiChk.equals("Y")) {
				return_code = "ERR_11";
				return_msg  = valiChk + " 노출시간이 입력되지 않았습니다.";

				log.info("[Step11_ERR] " + valiChk + " 노출시간이 입력되지 않았습니다.");
			}
		}

		//캠페인 데이터전송방식이 Manual 또는 Time 일 경우 채널 정보 발송시간 null 설정
		if (return_code.equals("")){

			CampaignInfoBO cbo = campaignInfoService.getCampaignInfo(map);

			if ( cbo.getManual_trans_yn().equals("T") || cbo.getManual_trans_yn().equals("Y") ){
				campaignInfoService.setChannelDispTime(map);
				log.info("[Step12] 캠페인 전송상태가 Manual 또는 Time 이므로 각 채널 발송시간 정보 null 로 update");
			}
		}

		log.info("=============================================");

		//테스트용으로 Validation체크 주석처리
		//return_code = ""; //테스트용

		if (return_code.equals("")) { //리턴코드가 "" 이면 정상 진행가능

			map.put("RSRV_START_DT", Common.nvl(request.getParameter("RSRV_START_DT"), ""));
			map.put("RSRV_END_DT", Common.nvl(request.getParameter("RSRV_END_DT"), ""));
			map.put("RSRV_GUBUN_CODE", RSRV_GUBUN_CODE);

			//기존 스케쥴은 삭제
			scheduleService.deleteCampaignRunSchedule(map);

			if (RSRV_GUBUN_CODE.equals("01")) { //01 : 매일

				map.put("RSRV_YEAR", "");
				map.put("RSRV_MONTH", "");
				map.put("RSRV_DAY", "");
				map.put("RSRV_HOUR", Common.nvl(request.getParameter("RSRV_HOUR_01"), ""));
				map.put("RSRV_MINUTE", Common.nvl(request.getParameter("RSRV_MINUTE_01"), ""));
				map.put("RSRV_WEEK_DAY", "");
				map.put("RSRV_TIMEHOURFROM", "");
				map.put("RSRV_TIMEHOURTO", "");
				map.put("RSRV_TIMEMIN", "");
				map.put("RSRV_EVERYTIME", "");

				//일정 마스터 저장
				scheduleService.setCampaignRunResv(map);

				//일정 스케쥴 저장
				scheduleService.setCampaignRunSchedule01(map);

			} else if (RSRV_GUBUN_CODE.equals("02")) { //02 : 매주

				map.put("RSRV_YEAR", "");
				map.put("RSRV_MONTH", "");
				map.put("RSRV_DAY", "");
				map.put("RSRV_HOUR", Common.nvl(request.getParameter("RSRV_HOUR_02"), ""));
				map.put("RSRV_MINUTE", Common.nvl(request.getParameter("RSRV_MINUTE_02"), ""));
				map.put("RSRV_WEEK_DAY", Common.nvl(request.getParameter("RSRV_WEEK_DAY"), ""));
				map.put("RSRV_TIMEHOURFROM", "");
				map.put("RSRV_TIMEHOURTO", "");
				map.put("RSRV_TIMEMIN", "");
				map.put("RSRV_EVERYTIME", "");

				//일정 마스터 저장
				scheduleService.setCampaignRunResv(map);

				//일정 스케쥴 저장
				scheduleService.setCampaignRunSchedule02(map);

			} else if (RSRV_GUBUN_CODE.equals("03")) { //03 : 매월

				map.put("RSRV_YEAR", "");
				map.put("RSRV_MONTH", "");
				map.put("RSRV_DAY", Common.nvl(request.getParameter("RSRV_DAY_03"), ""));
				map.put("RSRV_HOUR", Common.nvl(request.getParameter("RSRV_HOUR_03"), ""));
				map.put("RSRV_MINUTE", Common.nvl(request.getParameter("RSRV_MINUTE_03"), ""));
				map.put("RSRV_WEEK_DAY", "");
				map.put("RSRV_TIMEHOURFROM", "");
				map.put("RSRV_TIMEHOURTO", "");
				map.put("RSRV_TIMEMIN", "");
				map.put("RSRV_EVERYTIME", "");

				//일정 마스터 저장
				scheduleService.setCampaignRunResv(map);

				//일정 스케쥴 저장
				scheduleService.setCampaignRunSchedule03(map);

			} else if (RSRV_GUBUN_CODE.equals("04")) { //04 : 매월 말일

				map.put("RSRV_YEAR", "");
				map.put("RSRV_MONTH", "");
				map.put("RSRV_DAY", "");
				map.put("RSRV_HOUR", Common.nvl(request.getParameter("RSRV_HOUR_04"), ""));
				map.put("RSRV_MINUTE", Common.nvl(request.getParameter("RSRV_MINUTE_04"), ""));
				map.put("RSRV_WEEK_DAY", "");
				map.put("RSRV_TIMEHOURFROM", "");
				map.put("RSRV_TIMEHOURTO", "");
				map.put("RSRV_TIMEMIN", "");
				map.put("RSRV_EVERYTIME", "");

				//일정 마스터 저장
				scheduleService.setCampaignRunResv(map);

				//일정 스케쥴 저장
				scheduleService.setCampaignRunSchedule04(map);

			} else if (RSRV_GUBUN_CODE.equals("05")) { //05 : 사용자 지정
				//사용자 지정 캠페인 실행 예약 등록
				log.info("RUN_RESV_LIST " + request.getParameterValues("RUN_RESV_LIST[]"));
				String[] RUN_RESV_LIST = request.getParameterValues("RUN_RESV_LIST[]");

				map.put("RSRV_START_DT", "");
				map.put("RSRV_END_DT", "");
				map.put("RSRV_YEAR", "");
				map.put("RSRV_MONTH", "");
				map.put("RSRV_DAY", "");
				map.put("RSRV_HOUR", "");
				map.put("RSRV_MINUTE", "");
				map.put("RSRV_WEEK_DAY", "");
				map.put("RSRV_TIMEHOURFROM", "");
				map.put("RSRV_TIMEHOURTO", "");
				map.put("RSRV_TIMEMIN", "");
				map.put("RSRV_EVERYTIME", "");

				//일정 마스터 저장
				scheduleService.setCampaignRunResv(map);

				//일정 스케쥴 저장
				map.put("array", RUN_RESV_LIST);
				scheduleService.setCampaignRunSchedule05(map);

			} else if (RSRV_GUBUN_CODE.equals("06")) { //06 : 지정시간

				//사용자 지정 캠페인 실행 예약 등록
				log.info("RUN_RESV_LIST " + request.getParameterValues("RUN_RESV_LIST_06[]"));
				String[] RUN_RESV_LIST = request.getParameterValues("RUN_RESV_LIST_06[]");

				map.put("RSRV_YEAR", "");
				map.put("RSRV_START_DT", Common.nvl(request.getParameter("RSRV_START_DT"), ""));
				map.put("RSRV_END_DT", Common.nvl(request.getParameter("RSRV_END_DT"), ""));
				map.put("RSRV_MONTH", "");
				map.put("RSRV_DAY", "");
				map.put("RSRV_HOUR", "");
				map.put("RSRV_MINUTE", "");
				map.put("RSRV_TIMEHOURFROM", Common.nvl(request.getParameter("RSRV_HOUR_07"), ""));
				map.put("RSRV_TIMEHOURTO", Common.nvl(request.getParameter("RSRV_HOUR_07_TO"), ""));
				map.put("RSRV_TIMEMIN", Common.nvl(request.getParameter("RSRV_MINUTE_07"), ""));
				map.put("RSRV_WEEK_DAY", "");
				map.put("RSRV_EVERYTIME", Common.nvl(request.getParameter("EVERYTIME"), ""));

				//일정 마스터 저장
				scheduleService.setCampaignRunResv(map);

				//일정 스케쥴 저장
				map.put("array", RUN_RESV_LIST);
				scheduleService.setCampaignRunSchedule06(map);

			} else {
				log.info("잘못된 일정구분 코드입니다");
				return_code = "ERR_01";
			}


			if(return_code.equals("")){
				// 캠페인 상태 START로 변경하기
				scheduleService.setCampaignStart(map);
			}

		}

		map.put("return_code", return_code); //응답코드
		map.put("return_msg", return_msg);   //응답메세지

		jsonView.render(map, request, response);
	}

	/**
	 * 캠페인 일정 건별 등록
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setScheduleList.do")
	public void setScheduleList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("CampaignId        : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE      : " + request.getParameter("CAMPAIGNCODE"));
		log.info("RSRV_DT           : " + request.getParameter("RSRV_DT"));
		log.info("RSRV_HOUR         : " + request.getParameter("RSRV_HOUR"));
		log.info("RSRV_MINUTE       : " + request.getParameter("RSRV_MINUTE"));
		log.info("=============================================");

		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("RSRV_DT", Common.nvl(request.getParameter("RSRV_DT"), ""));
		map.put("RSRV_HOUR", Common.nvl(request.getParameter("RSRV_HOUR"), ""));
		map.put("RSRV_MINUTE", Common.nvl(request.getParameter("RSRV_MINUTE"), ""));
		map.put("CREATE_ID", Common.nvl(user.getId(), ""));
		map.put("UPDATE_ID", Common.nvl(user.getId(), ""));

		//일정 건별 등록
		scheduleService.setScheduleList(map);

		jsonView.render(map, request, response);
	}

	/**
	 * 캠페인 일정 목록 조회
	 * 
	 * KANG-20190410: analyzing
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getScheduleList.do")
	public void getScheduleList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId        : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE      : " + request.getParameter("CAMPAIGNCODE"));
		log.info("selectPageNo2     : " + request.getParameter("selectPageNo2"));
		log.info("SEARCH_TYPE       : " + request.getParameter("SEARCH_TYPE"));
		log.info("=============================================");

		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("SEARCH_TYPE", Common.nvl(request.getParameter("SEARCH_TYPE"), ""));

		//paging
		String selectPageNo2 = (String) request.getParameter("selectPageNo2");
		if (selectPageNo2 == null || selectPageNo2.equals("")) {
			selectPageNo2 = "1";
		}

		// KANG-20190410: for understanding of pagination
		int selectPage2 = Integer.parseInt(selectPageNo2);
		int pageRange = 10;     // page block
		int rowRange = 10;    // row block  origin: 1000
		int rowTotalCnt = Integer.parseInt(this.scheduleService.getScheduleListCnt(map));
		int totalPage = rowTotalCnt / rowRange + ((rowTotalCnt % rowRange > 0) ? 1 : 0);
		int pageStart = ((selectPage2 - 1) / pageRange) * pageRange + 1;
		int pageEnd = (totalPage <= (pageStart + pageRange - 1)) ? totalPage : (pageStart + pageRange - 1);

		//int searchRangeStart = (rowRange * (selectPage - 1)) + 1;   // num >=  #{searchRangeStart} 
		int searchRangeStart = (rowRange * (selectPage2 - 1));   // num >  #{searchRangeStart}
		int searchRangeEnd   = rowRange * selectPage2;           // num <=  #{searchRangeEnd}
		map.put("searchRangeStart", searchRangeStart);
		map.put("searchRangeEnd", searchRangeEnd);
		if (Flag.flag) {
			log.info("=============================================");
			log.info("selectPage2      : " + selectPage2);
			log.info("pageRange        : " + pageRange);
			log.info("rowRange         : " + rowRange);
			log.info("rowTotalCnt      : " + rowTotalCnt);
			log.info("totalPage        : " + totalPage);
			log.info("pageStart        : " + pageStart);
			log.info("pageEnd          : " + pageEnd);
			log.info("searchRangeStart : " + searchRangeStart);
			log.info("searchRangeEnd   : " + searchRangeEnd);
			log.info("=============================================");
		}

		// 일정 목록 조회
		List<CampaignRunScheduleBO> list = this.scheduleService.getScheduleList(map);

		map.put("ScheduleList", list);
		map.put("selectPage2", selectPage2);
		map.put("pageRange", pageRange);
		map.put("rowRange", rowRange);
		map.put("rowTotalCnt", rowTotalCnt);
		map.put("totalPage", totalPage);
		map.put("pageStart", pageStart);
		map.put("pageEnd", pageEnd);

		jsonView.render(map, request, response);
	}

	/**
	 * 캠페인 일정 선택 삭제
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/deleteScheduleList.do")
	public void deleteScheduleList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId        : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE      : " + request.getParameter("CAMPAIGNCODE"));
		log.info("CHK_DATE          : " + request.getParameterValues("CHK_DATE"));
		log.info("=============================================");

		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));

		String[] CHK_DATE = request.getParameterValues("CHK_DATE");
		map.put("array", CHK_DATE);

		// 일정 목록 삭제
		scheduleService.deleteScheduleList(map);
		
		// 스케쥴이 없으면 오퍼,채널 수정가능함 KANG-20200409
		scheduleService.updateToEditIfNoSchedule(map);

		jsonView.render(map, request, response);
	}

	/**
	 * 캠페인 일정 전체 삭제
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/deleteScheduleListAll.do")
	public void deleteScheduleListAll(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId        : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE      : " + request.getParameter("CAMPAIGNCODE"));
		log.info("=============================================");

		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));

		//스케쥴 삭제
		scheduleService.deleteCampaignRunSchedule(map);

		jsonView.render(map, request, response);
	}

	@RequestMapping("/campaignStop.do")
	public void campaignStop(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CAMPAIGNCODE      : " + request.getParameter("CAMPAIGNCODE"));
		log.info("=============================================");

		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));

		//스케쥴 삭제
		scheduleService.campaignStop(map);

		jsonView.render(map, request, response);
	}

	/**
	 * 멀티캠페인 일정 저장시
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/multiCistudioSave.do")
	public void multiCistudioSave(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("==============================================");
		log.info("##### Multi Campaign CI Studio Log Start #####");
		log.info("CampaignId        : " + request.getParameter("scheduleCampaignId"));
		log.info("CAMPAIGNCODE      : " + request.getParameter("CAMPAIGNCODE"));
		log.info("==============================================");

		map.put("CAMPAIGNID", Common.nvl(request.getParameter("scheduleCampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("UPDATE_ID", Common.nvl(user.getId(), ""));

		map.put("rtnVal", "0000");
		scheduleService.setCampaignStart(map);

		jsonView.render(map, request, response);
	}

	/**
	 * 캠페인 테스트 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setCampaignTest.do")
	public void setCampaignTest(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Date today = new Date();
		SimpleDateFormat dateprint = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String RUN_DT = dateprint.format(today.getTime());

		//paramter
		log.info("=============================================");
		log.info("CampaignId        : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE      : " + request.getParameter("CAMPAIGNCODE"));
		log.info("CELL_CHANNEL      : " + request.getParameterValues("CELL_CHANNEL"));
		log.info("TEST_MEM_ID       : " + request.getParameterValues("TEST_MEM_ID"));
		log.info("RUN_DT            : " + RUN_DT);
		log.info("=============================================");

		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		String[] CELL_CHANNEL = request.getParameterValues("CELL_CHANNEL");
		String[] TEST_MEM_ID = request.getParameterValues("TEST_MEM_ID");
		map.put("RUN_DT", RUN_DT);
		map.put("CREATE_ID", Common.nvl(user.getId(), ""));
		map.put("UPDATE_ID", Common.nvl(user.getId(), ""));

		map.put("array", CELL_CHANNEL);
		scheduleService.setCampaignTestChannel(map);

		//테스트 타겟 저장
		map.put("array", TEST_MEM_ID);
		scheduleService.setCampaignTestTarget(map);

		//캠페인 테스트 실행 저장
		scheduleService.setCampaignTest(map);

		jsonView.render(map, request, response);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	/**
	 * 캠페인 일정 목록
	 * 
	 * KANG-20200508
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getScheduleStatusList.do")
	public void getScheduleStatusList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId        : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE      : " + request.getParameter("CAMPAIGNCODE"));
		log.info("selectPageNo2     : " + request.getParameter("selectPageNo2"));
		log.info("SEARCH_TYPE       : " + request.getParameter("SEARCH_TYPE"));
		log.info("=============================================");

		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("SEARCH_TYPE", Common.nvl(request.getParameter("SEARCH_TYPE"), ""));
		
		// 일정 목록 조회
		List<CampaignRunScheduleBO> list = this.scheduleService.getScheduleStatusList(map);
		map.put("ScheduleList", list);

		jsonView.render(map, request, response);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	/**
	 * 캠페인 일정 상태 변경
	 * 
	 * KANG-20200508
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updateScheduleStatusList.do")
	public void updateScheduleStatusList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");
		map.put("UPDATE_ID", user.getId());

		//paramter
		log.info("=============================================");
		log.info("CampaignId        : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE      : " + request.getParameter("CAMPAIGNCODE"));
		log.info("CHK_DATE          : " + request.getParameterValues("CHK_DATE"));
		log.info("=============================================");

		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));

		String[] CHK_DATE = request.getParameterValues("CHK_DATE");
		map.put("array", CHK_DATE);
		
		// 일정 목록
		log.info("=============================================");
		log.info("map  : " + map);
		if (!Flag.flag) {
			String[] arr = (String[]) map.get("array");
			for (int i=0; i < arr.length; i++) {
				System.out.println(">>>>> " + arr[i]);
			}
		}
		log.info("=============================================");
		this.scheduleService.updateScheduleStatusList(map);
		
		jsonView.render(map, request, response);
	}
}




