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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.view.json.MappingJacksonJsonView;

import com.skplanet.sascm.object.CampaignChannelBO;
import com.skplanet.sascm.object.CampaignInfoBO;
import com.skplanet.sascm.object.CampaignListBO;
import com.skplanet.sascm.object.CampaignOfferBO;
import com.skplanet.sascm.object.CampaignRunResvBO;
import com.skplanet.sascm.object.UaextCodeDtlBO;
import com.skplanet.sascm.object.UsmUserBO;
import com.skplanet.sascm.service.CampaignInfoService;
import com.skplanet.sascm.service.ChannelService;
import com.skplanet.sascm.service.CommCodeService;
import com.skplanet.sascm.service.ScheduleService;
import com.skplanet.sascm.util.CheckCopyCouponNo;
import com.skplanet.sascm.util.Common;
import com.skplanet.sascm.util.Flag;

@Controller
public class CampaignController {

	private final Log log = LogFactory.getLog(getClass());

	@Resource(name = "campaignInfoService")
	private CampaignInfoService campaignInfoService;

	@Resource(name = "commCodeService")
	private CommCodeService commCodeService;

	@Resource(name = "channelService")
	private ChannelService channelService;

	@Resource(name = "scheduleService")
	private ScheduleService scheduleService;

	@Value("#{contextProperties['dbconn.url']}")
	private String dbconnUrl;
	@Value("#{contextProperties['dbconn.user']}")
	private String dbconnUser;
	@Value("#{contextProperties['dbconn.pass']}")
	private String dbconnPass;

	@Value("#{contextProperties['dbconn.urlBo']}")
	private String dbconnBoUrl;
	@Value("#{contextProperties['dbconn.userBo']}")
	private String dbconnBoUser;
	@Value("#{contextProperties['dbconn.passBo']}")
	private String dbconnBoPass;

	//AJAX
	@Autowired
	private MappingJacksonJsonView jsonView;


	/**
	 * KANG-20200508:
	 *
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/campaign/campaignList.do")
	public String main(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("COMM_CODE_ID", "C050");
		map.put("CODE_ID", user.getName());
		log.info("=============================================");
		log.info("map : " + map);
		log.info("=============================================");

		UaextCodeDtlBO manager = commCodeService.getCommCodeDtl(map);
		String isChangeStatus = "NO";
		if (manager != null  && manager.getUse_yn().equals("Y")) {
			isChangeStatus = "YES";
		}
		log.info("=============================================");
		log.info("ENABLE_PROCESS: " + isChangeStatus);
		log.info("=============================================");

		modelMap.addAttribute("ENABLE_PROCESS", isChangeStatus);
		request.setAttribute("cal", request.getParameter("cal"));
		
		return "campaign/campaignList";
	}

	/**
	 * KANG-20200413: 채널복사를 위한 캠페인 리스트
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/campaign/campaignChannelList.do")
	public String pageCampaignChannelList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) {
		//request.setAttribute("cal", request.getParameter("cal"));
		//paramter
		log.info("=============================================");
		log.info("campaignid <- CampaignId  : " + request.getParameter("CampaignId"));
		log.info("cellid     <- CELLID      : " + request.getParameter("CELLID"));
		log.info("channel_cd <- CHANNEL_CD  : " + request.getParameter("CHANNEL_CD"));
		log.info("disp_dt                   : " + request.getParameter("disp_dt"));   // KANG-20200418
		log.info("MANUAL_TRANS_YN           : " + request.getParameter("MANUAL_TRANS_YN"));   // KANG-20200606: create
		log.info("DISP_TIME                 : " + request.getParameter("DISP_TIME"));         // KANG-20200606: create
		log.info("SEND_PREFER_CD            : " + request.getParameter("SEND_PREFER_CD"));    // KANG-20200606: create
		log.info("=============================================");

		modelMap.addAttribute("campaignid", request.getParameter("CampaignId"));
		modelMap.addAttribute("cellid", request.getParameter("CELLID"));
		modelMap.addAttribute("channel_cd", request.getParameter("CHANNEL_CD"));
		modelMap.addAttribute("disp_dt", request.getParameter("disp_dt"));   // KANG-20200418
		modelMap.addAttribute("MANUAL_TRANS_YN", request.getParameter("MANUAL_TRANS_YN"));  // KANG-20200606: create
		modelMap.addAttribute("DISP_TIME", request.getParameter("DISP_TIME"));              // KANG-20200606: create
		modelMap.addAttribute("SEND_PREFER_CD", request.getParameter("SEND_PREFER_CD"));    // KANG-20200606: create
		
		return "campaign/campaignChannelList";
	}

	/**
	 * KANG-20200425: 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/campaign/campaignChangeStatusList.do")
	public String pageCampaignChangeStatusList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		/*
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("COMM_CODE_ID", "C050");
		map.put("CODE_ID", user.getName());
		log.info("=============================================");
		log.info("map : " + map);
		log.info("=============================================");

		UaextCodeDtlBO manager = commCodeService.getCommCodeDtl(map);
		String isChangeStatus = "NO";
		if (manager != null  && manager.getUse_yn().equals("Y")) {
			isChangeStatus = "YES";
		}
		log.info("=============================================");
		log.info("ENABLE_PROCESS: " + isChangeStatus);
		log.info("=============================================");

		modelMap.addAttribute("ENABLE_PROCESS", isChangeStatus);
		*/
		
		/*
		modelMap.addAttribute("campaignid", request.getParameter("CampaignId"));
		modelMap.addAttribute("cellid", request.getParameter("CELLID"));
		modelMap.addAttribute("channel_cd", request.getParameter("CHANNEL_CD"));
		modelMap.addAttribute("disp_dt", request.getParameter("disp_dt"));   // KANG-20200418
		*/
		
		return "campaign/campaignChangeStatusList";
	}

	/**
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @throws Exception
	 */
	@RequestMapping("/campaignFolderList.do")
	public void campaignFolderList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("serverType", request.getParameter("serverType"));

		//공통코드 목록 조회
		List<CampaignListBO> list = campaignInfoService.getCampaignFolderList(map);

		log.info("=============================================");
		log.info("list   : " + list);
		log.info("=============================================");

		map.put("CampaignFolder", list);
		jsonView.render(map, request, response);
	}

	/**
	 * KANG-20190410: analyzing
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @throws Exception
	 */
	@RequestMapping("/campaignList.do")   // TODO KANG-20190410: 캠페인 리스트 > 캠페인 목록
	public void getCampaignList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("serverType        : " + request.getParameter("serverType"));
		log.info("treeValue         : " + request.getParameter("treeValue"));
		log.info("selectPageNo      : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		map.put("serverType", request.getParameter("serverType"));
		map.put("treeValue", Common.nvl(request.getParameter("treeValue"), ""));
		map.put("selectPageNo", Common.nvl(request.getParameter("selectPageNo"), "1"));

		//paging
		String selectPageNo = (String) request.getParameter("selectPageNo");
		if (selectPageNo == null || selectPageNo.equals("")) {
			selectPageNo = "1";
		}

		// KANG-20190410: for understanding of pagination
		int selectPage = Integer.parseInt(selectPageNo);
		int pageRange = 10;     // page block
		int rowRange = 1000;    // row block  KANG-20190414: 김창범 메니져의 요청에 의해서 변경이 가능함. KANG-20200531: 1000개
		int rowTotalCnt = Integer.parseInt(this.campaignInfoService.getCampaignListCnt(map));
		int totalPage = rowTotalCnt / rowRange + ((rowTotalCnt % rowRange > 0) ? 1 : 0);
		int pageStart = ((selectPage - 1) / pageRange) * pageRange + 1;
		int pageEnd = (totalPage <= (pageStart + pageRange - 1)) ? totalPage : (pageStart + pageRange - 1);

		//int searchRangeStart = (rowRange * (selectPage - 1)) + 1;   // num >=  #{searchRangeStart} 
		int searchRangeStart = (rowRange * (selectPage - 1));   // num >  #{searchRangeStart}
		int searchRangeEnd   = rowRange * selectPage;           // num <=  #{searchRangeEnd}
		map.put("searchRangeStart", searchRangeStart);
		map.put("searchRangeEnd", searchRangeEnd);
		if (Flag.flag) {
			log.info("=============================================");
			log.info("selectPage       : " + selectPage);
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

		//공통코드 목록 조회
		List<CampaignListBO> list = this.campaignInfoService.getCampaignList(map);
		if (Flag.flag) {
			log.info("=============================================");
			log.info("list   : " + list);
			log.info("=============================================");
		}

		map.put("CampaignList", list);
		map.put("selectPage", selectPage);
		map.put("pageRange", pageRange);
		map.put("rowRange", rowRange);
		map.put("rowTotalCnt", rowTotalCnt);
		map.put("totalPage", totalPage);
		map.put("pageStart", pageStart);
		map.put("pageEnd", pageEnd);

		jsonView.render(map, request, response);
	}

	/**
	 * 캠페인 정
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/campaign/property.do")
	public String pageCampaignInfo(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("codeId", "C004");
		map.put("USE_YN", "Y");

		List<UaextCodeDtlBO> audience_list = commCodeService.getCommCodeDtlList(map);
		modelMap.addAttribute("audience_list", audience_list);

		map.put("codeId", "G003");
		map.put("USE_YN", "Y");

		List<UaextCodeDtlBO> manual_trans_list = commCodeService.getCommCodeDtlList(map);
		modelMap.addAttribute("manual_trans_list", manual_trans_list);

		//paramter
		log.info("=============================================");
		log.info("CAMPAIGNID   : " + request.getParameter("CampaignId"));
		log.info("title        : " + "");
		log.info("=============================================");

		map.put("CAMPAIGNID", request.getParameter("CampaignId"));

		CampaignInfoBO bo = campaignInfoService.getCampaignInfo(map);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("user", user);

		return "campaign/property";
	}

	/**
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping("/getCampaignInfo.do")
	public void getCampaignInfo(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("CAMPAIGNID", Common.nvl(request.getParameter("campaignid"), ""));

		List<CampaignListBO> boPropertyList = campaignInfoService.getCICampaignProperyList(map);

		// CI 에서 캠페인 등록후 Property 관련(CM_CAMPAIGN_DTL 테이블에 데이터가 존재하지 않을경우 최초 INSERT 만 한다.
		// 최초 등록 이후 CI 에서 값을 수정 할경우 별도의 처리를 하지 않는다.2017.12.05
		if (boPropertyList.size() <= 0){
			CampaignInfoBO boProperty = campaignInfoService.getCICampaignProperty(map);

			map.put("codeId", "G003");
			map.put("USE_YN", "Y");

			List<UaextCodeDtlBO> manual_trans_list = commCodeService.getCommCodeDtlList(map);

			String tmpManualTransYn = "";
			for (int i = 0; i < manual_trans_list.size(); i++) {
				UaextCodeDtlBO bo = manual_trans_list.get(i);
				log.debug(bo.getCode_id());
				log.debug(bo.getCode_name());
				log.debug(bo.getComm_code_id());
				log.debug(boProperty.getSenddatetype());
				log.debug(bo.getCode_name());
				if (boProperty.getSenddatetype().equals(bo.getCode_name())){
				    tmpManualTransYn = bo.getCode_id();
				}
			}

			Map<String, Object> mapProperty = new HashMap<String, Object>();

			String tmpStr = boProperty.getCamp_from_dt();
			String tmpStr1 = boProperty.getCamp_to_dt();

			if (null != tmpStr && !tmpStr.equals("")){
				tmpStr = tmpStr.substring(0, 10);
			}

			if (null != tmpStr1 && !tmpStr1.equals("")){
				tmpStr1 = tmpStr1.substring(0, 10);
			}

			mapProperty.put("CAMPAIGNCODE",        Common.nvl((String) boProperty.getCampaigncode(), ""));
			mapProperty.put("CAMPAIGNID",          Common.nvl((String) request.getParameter("campaignid"), ""));
			mapProperty.put("CAMP_TERM_CD",        Common.nvl((String) boProperty.getCampaign_period().replace("그룹", "0"), ""));
			mapProperty.put("CAMP_BGN_DT1",        Common.nvl((String) tmpStr, ""));
			mapProperty.put("CAMP_BGN_DT2",        "00");
			mapProperty.put("CAMP_BGN_DT3",        "00");
			mapProperty.put("CAMP_END_DT1",        Common.nvl((String) tmpStr1, ""));
			mapProperty.put("CAMP_END_DT2",        "00");
			mapProperty.put("CAMP_END_DT3",        "00");
			mapProperty.put("CAMP_TERM_DAY",       Common.nvl((String) boProperty.getSend_day(), ""));
			mapProperty.put("AUDIENCE_CD",         Common.nvl((String) boProperty.getTarget_id(), ""));
			mapProperty.put("MANUAL_TRANS_YN",     Common.nvl((String) tmpManualTransYn, ""));
			mapProperty.put("OFFER_DIRECT_YN",     Common.nvl((String) boProperty.getOffer_auto_yn(), ""));
			mapProperty.put("CHANNEL_PRIORITY_YN", Common.nvl((String) boProperty.getChannel_batch_rank_yn(), ""));
			mapProperty.put("CREATE_ID", user.getId());
			mapProperty.put("UPDATE_ID", user.getId());

			campaignInfoService.setCampaignInfo(mapProperty);

			String CHANNEL_CMD = "";
			if (Common.nvl((String) mapProperty.get("channel_batch_rank_yn"), "").equals("Y")){
				CHANNEL_CMD = "NtoY";
			} else {
				CHANNEL_CMD = "YtoN";
			}

			// 데이터전송방식이 Batch 에서 Manual & Time 으로 변경될 경우 기존에 저장되어 있는 채널 노출시간은 null 로 저장
			String MANUAL_TRANS_YN = Common.nvl((String) mapProperty.get("senddate_type"), "");

			if (MANUAL_TRANS_YN.equals("Y") || MANUAL_TRANS_YN.equals("T")){
				campaignInfoService.setChannelDispTime(mapProperty);
			}

			if (CHANNEL_CMD.equals("YtoN")) { //모든우선 순위가 N으로 변경됨
				mapProperty.put("PRIORITY_RNK", "N");
				campaignInfoService.setChannelPriority(mapProperty);
			} else if (CHANNEL_CMD.equals("NtoY")) { //모든우선 순위가 5로 변경됨
				mapProperty.put("PRIORITY_RNK", "5");
				campaignInfoService.setChannelPriority(mapProperty);
			}

			// 최초 1회 Insert 완료.
		}

		CampaignInfoBO bo = campaignInfoService.getCampaignInfo(map);
		CampaignInfoBO boSummary = campaignInfoService.getCampaignInfoSummary(map);

		//오퍼정보
		//List<CampaignOfferBO> offer_list = campaignInfoService.getCampaignOfferList(map);

		map.put("bo", bo);
		map.put("boSummary", boSummary);

		jsonView.render(map, request, response);
	}

	/**
	 * 캠페인 속성 정보 등록, 수정
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setCampaignInfo.do")
	public void setCampaignInfo(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		log.info("=============================================");
		log.info("CAMPAIGNCODE         : " + request.getParameter("CAMPAIGNCODE"));
		log.info("CAMPAIGNID           : " + request.getParameter("CAMPAIGNID"));
		log.info("CAMP_TERM_CD         : " + request.getParameter("CAMP_TERM_CD"));
		log.info("CAMP_BGN_DT1         : " + request.getParameter("CAMP_BGN_DT_1"));
		log.info("CAMP_BGN_DT2         : " + request.getParameter("CAMP_BGN_DT2"));
		log.info("CAMP_BGN_DT3         : " + request.getParameter("CAMP_BGN_DT3"));
		log.info("CAMP_END_DT1         : " + request.getParameter("CAMP_END_DT_1"));
		log.info("CAMP_END_DT2         : " + request.getParameter("CAMP_END_DT2"));
		log.info("CAMP_END_DT3         : " + request.getParameter("CAMP_END_DT3"));
		log.info("CAMP_TERM_DAY        : " + request.getParameter("CAMP_TERM_DAY"));
		log.info("AUDIENCE_CD          : " + request.getParameter("AUDIENCE_CD"));
		log.info("MANUAL_TRANS_YN      : " + request.getParameter("MANUAL_TRANS_YN"));
		log.info("OFFER_DIRECT_YN      : " + request.getParameter("OFFER_DIRECT_YN"));
		log.info("CHANNEL_PRIORITY_YN  : " + request.getParameter("CHANNEL_PRIORITY_YN"));
		log.info("CHANNEL_CMD          : " + request.getParameter("CHANNEL_CMD"));
		log.info("=============================================");

		//입력 값
		map.put("CAMPAIGNCODE",        Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("CAMPAIGNID",          Common.nvl(request.getParameter("CAMPAIGNID"), ""));
		map.put("CAMP_TERM_CD",        Common.nvl(request.getParameter("CAMP_TERM_CD"), ""));
		map.put("CAMP_BGN_DT1",        Common.nvl(request.getParameter("CAMP_BGN_DT_1"), ""));
		map.put("CAMP_BGN_DT2",        Common.nvl(request.getParameter("CAMP_BGN_DT2"), ""));
		map.put("CAMP_BGN_DT3",        Common.nvl(request.getParameter("CAMP_BGN_DT3"), ""));
		map.put("CAMP_END_DT1",        Common.nvl(request.getParameter("CAMP_END_DT_1"), ""));
		map.put("CAMP_END_DT2",        Common.nvl(request.getParameter("CAMP_END_DT2"), ""));
		map.put("CAMP_END_DT3",        Common.nvl(request.getParameter("CAMP_END_DT3"), ""));
		map.put("CAMP_TERM_DAY",       Common.nvl(request.getParameter("CAMP_TERM_DAY1"), ""));
		map.put("AUDIENCE_CD",         Common.nvl(request.getParameter("AUDIENCE_CD"), ""));
		map.put("MANUAL_TRANS_YN",     Common.nvl(request.getParameter("MANUAL_TRANS_YN"), ""));
		map.put("OFFER_DIRECT_YN",     Common.nvl(request.getParameter("OFFER_DIRECT_YN_1"), ""));
		map.put("CHANNEL_PRIORITY_YN", Common.nvl(request.getParameter("CHANNEL_PRIORITY_YN_1"), ""));
		map.put("CREATE_ID", user.getId());
		map.put("UPDATE_ID", user.getId());

		//캠페인의 상태체크(START일경우에는 수정못함)
		CampaignInfoBO bo = campaignInfoService.getCampaignInfo(map);
		String CMP_STATUS = Common.nvl(bo.getCamp_status_cd(), "");

		if (!CMP_STATUS.equals("START")) {
			campaignInfoService.setCampaignInfo(map);

			String CHANNEL_CMD = Common.nvl(request.getParameter("CHANNEL_CMD"), "");

			// 데이터전송방식이 Batch 에서 Manual & Time 으로 변경될 경우 기존에 저장되어 있는 채널 노출시간은 null 로 저장
			String MANUAL_TRANS_YN = Common.nvl(request.getParameter("MANUAL_TRANS_YN"), "");

			if (MANUAL_TRANS_YN.equals("Y") || MANUAL_TRANS_YN.equals("T")){
				campaignInfoService.setChannelDispTime(map);
			}

			if (CHANNEL_CMD.equals("YtoN")) { //모든우선 순위가 N으로 변경됨
				map.put("PRIORITY_RNK", "N");
				campaignInfoService.setChannelPriority(map);
			} else if (CHANNEL_CMD.equals("NtoY")) { //모든우선 순위가 5로 변경됨
				map.put("PRIORITY_RNK", "5");
				campaignInfoService.setChannelPriority(map);
			}
		}

		//캠페인 상태 리턴
		map.put("CMP_STATUS", CMP_STATUS);

		jsonView.render(map, request, response);
	}

	/**
	 * KANG-20190410: analyzing
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @param session
	 * @throws Exception
	 */
	// 캠페인 클릭시 요약/속성/오퍼/채널/일정 항목 전체
	@RequestMapping("/getCampaignInfoAll.do")
	public void getCampaignInfoAll(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("campaignid"), ""));
		List<CampaignListBO> boPropertyList = this.campaignInfoService.getCICampaignProperyList(map);        // KANG-20190413: 01. CampaignInfo.getCICampaignProperyList

		// CI 에서 캠페인 등록후 Property 관련(CM_CAMPAIGN_DTL 테이블에 데이터가 존재하지 않을경우 최초 INSERT 만 한다.
		// 최초 등록 이후 CI 에서 값을 수정 할경우 별도의 처리를 하지 않는다.2017.12.05
		if (boPropertyList.size() <= 0){
			String batchDtCheck = this.chkInsertUpdate(map, user, request, "insert");                        // KANG-20190413: chkInsertUpdate(INSERT).
			if (batchDtCheck.equals("8888")){
				// 철수전 작업사항 데이터 전송방식 Batch 일경우 캠페인 시작일을 내일부터 지정 할 수 있습니다!!
				map.put("batchDtCheck", "ERROR");
			}
			// 최초 1회 Insert 완료.
		} else {
			// ############### 속성 / 요약 정보 (BGN)
			CampaignInfoBO bo = this.campaignInfoService.getCampaignInfo(map);                               // KANG-20190413: 02. CampaignInfo.getCampaignInfo
			CampaignInfoBO boSummary = this.campaignInfoService.getCampaignInfoSummary(map);                 // KANG-20190413: 03. CampaignInfo.getCampaignInfoSummary
			// ############### 속성 / 요약 정보 (END)

			// ############### 오퍼 정보 (BGN)
			Map<String, Object> map1 = new HashMap<String, Object>();
			// 캠페인 정보 상세 조회
			map1.put("CAMPAIGNID", Common.nvl(request.getParameter("campaignid"), ""));
			map1.put("USER_ID", user.getId());
			// 오퍼 목록
			List<CampaignOfferBO> offer_list = this.campaignInfoService.getCampaignOfferList(map1);          // KANG-20190413: 04. CampaignInfo.getCampaignOfferList
			// ############### 오퍼 정보 (END)

			String CMP_STATUS = Common.nvl(bo.getCamp_status_cd(), "");
			if (!CMP_STATUS.equals("START") && offer_list != null) {
				// Offer Update 매핑화면과 싱크를 위해 항상 업데이트
				this.campaignInfoService.updateOfferData(map);                                               // KANG-20190413: 05. CampaignInfo.updateOfferData
				
				if (Flag.flag) {  // KANG-20190414: add by Kiea
					for (int i = 0; i < offer_list.size(); i++) {
						CampaignOfferBO campaignOfferBo = new CampaignOfferBO();
						campaignOfferBo = offer_list.get(i);
						if (null != campaignOfferBo.getOffer_type_cd() && campaignOfferBo.getOffer_type_cd().equals("CU")) {
							if (Flag.flag) {
								log.debug("KANG-20190413: campaignid   = " + request.getParameter("campaignid"));
								log.debug("KANG-20190413: cellid       = " + campaignOfferBo.getCellid());
								log.debug("KANG-20190413: offerTypeCd  = " + campaignOfferBo.getOffer_type_cd());
							}
							try {// 443: campaign_sk // 1580 : rund id = cell_package_sk
								CheckCopyCouponNo.checkCouponNo(request.getParameter("campaignid"), campaignOfferBo.getCellid()
										, dbconnUrl, dbconnUser, dbconnPass
										, dbconnBoUrl, dbconnBoUser, dbconnBoPass
										, Integer.parseInt(campaignOfferBo.getOfferid()));
							} catch (Exception e) {
								log.debug("CheckCopyCouponNo.checkCouponNo ERROR !!!! ");
								e.printStackTrace();
							}
						}
					}
				}
				// DTL 만 Update 됨. // Offer 처리 안됨.
				this.chkInsertUpdate(map, user, request, "update");                                          // KANG-20190413: chkInsertUpdate(UPDATE).
				/* Channel Update  매핑화면과 싱크를 위해 항상 업데이트 */
				this.campaignInfoService.updateChannelData(map);                                             // KANG-20190413: 06. CampaignInfo.updateChannelData
				// 채널데이터 업데이트
				//campaignInfoService.updateChannelData2(map1);
				//campaignInfoService.updateChannelData3(map1);
			}

			// ############### 채널 정보 (BGN)
			List<CampaignChannelBO> channel_list = this.channelService.getCampaignChannelList(map1);         // KANG-20190413: 07. Channel.getCampaignChannelList
			// 2. 대상수준이 PCID일경우 채널이 토스트배너인지 체크
			String channelValiChk = this.channelService.getCampaignChannelValiChk(map1);                     // KANG-20190413: 08. Channel.getCampaignChannelValiChk
			// 5. 대상수준이 DEVICE_ID 일 경우 모바일 앱 채널만 사용가능
			String channelValChkforMobile = this.channelService.getCampaignChannelValiChkforMobile(map1);    // KANG-20190413: 09. Channel.getCampaignChannelValiChkforMobile
			// ############### 채널 정보 (END)

			// ############### 일정정보 (BGN)
			CampaignRunResvBO scheduleBo = this.scheduleService.getScheduleDetail(map1);                     // KANG-20190413: 10. Schedule.getScheduleDetail
			// ############### 일정정보 (END)

			if (Flag.flag) System.out.println("KANG-20190413: bo.getCampaigncode() :" + bo.getCampaigncode());
			map1.put("CAMPAIGNCODE", bo.getCampaigncode());
			int runScheduleCnt = this.scheduleService.getRunScheduleCnt(map1);                               // KANG-20190410: 11. Schedule.getRunScheduleCnt

			map.put("bo", bo);                        // 속성정보
			map.put("boSummary", boSummary);          // 요약정보
			map.put("offer_list", offer_list);        // 오퍼 정보
			map.put("channel_list", channel_list);    // 체널 목록
			map.put("channelValiChk", channelValiChk);
			map.put("channelValChkforMobile", channelValChkforMobile);
			map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
			map.put("user", user);                    // 일정정보
			map.put("scheduleBo", scheduleBo);
			map.put("runScheduleCnt", runScheduleCnt);
			map.put("batchDtCheck", "");
		}
		jsonView.render(map, request, response);
	}

	/**
	 * KANG-20190411: analyzing
	 * this method is called by SAS
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping("/callCopyCoupon.do")
	public void sasCallCopyCoupon(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		String campaignId = request.getParameter("campaignid");
		String cellId = request.getParameter("cellid");
		int offerId = Integer.parseInt(request.getParameter("offerid"));
		
		try {// 443: campaign_sk // 1580 : rund id = cell_package_sk
			CheckCopyCouponNo.checkCouponNo(
					campaignId, cellId
					, this.dbconnUrl,   this.dbconnUser,   this.dbconnPass
					, this.dbconnBoUrl, this.dbconnBoUser, this.dbconnBoPass
					, offerId);
		} catch (Exception e) {
			log.debug("CheckCopyCouponNo.checkCouponNo ERROR !!!! ");
			e.printStackTrace();
		}
	}

	/*
	 * KANG-20190413: Sub-insert/update: analyzing
	 *
	 */
	private String chkInsertUpdate(Map<String, Object> map, UsmUserBO user, HttpServletRequest request, String chkIn) throws Exception {
		
		CampaignInfoBO boProperty = this.campaignInfoService.getCICampaignProperty(map);                     // KANG-20190413: Sub-01. CampaignInfo.getCICampaignProperty
		map.put("codeId", "G003");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> manual_trans_list = this.commCodeService.getCommCodeDtlList(map);               // KANG-20190413: Sub-02. CommCode.getCommCodeDtlList
		String tmpManualTransYn = "";
		for (int i = 0; i < manual_trans_list.size(); i++) {
			UaextCodeDtlBO bo = manual_trans_list.get(i);
			if (Flag.flag) {
				String str = String.format("(%d) [Senddatatype=%s], [Comm_code_id=%s], [Code_id=%s], [Code_name=%s]"
						, i
						, boProperty.getSenddatetype()
						, bo.getComm_code_id()
						, bo.getCode_id()
						, bo.getCode_name()
						);
				log.debug(str);
			}
			if (boProperty.getSenddatetype().equals(bo.getCode_name())){
				tmpManualTransYn = bo.getCode_id();
			}
		}

		Map<String, Object> mapProperty = new HashMap<String, Object>();

		String tmpStr  = boProperty.getCamp_from_dt();
		String tmpStr1 = boProperty.getCamp_to_dt();
		if (null != tmpStr && !tmpStr.equals("")){
			tmpStr = tmpStr.substring(0, 10);
		}
		if (null != tmpStr1 && !tmpStr1.equals("")){
			tmpStr1 = tmpStr1.substring(0, 10);
		}
		log.debug("##### tmpStr : " + tmpStr);
		log.debug("##### tmpStr1 : " + tmpStr1);

		String tmpBgnTm = boProperty.getCamp_from_tm();
		String tmpEndtm = boProperty.getCamp_to_tm();
		log.debug("##### tmpBgnTm : " + tmpBgnTm);
		log.debug("##### tmpEndtm : " + tmpEndtm);

		String[] tmpBgn = tmpBgnTm.split(" ");
		String[] tmpBgnTime = tmpBgn[1].split(":");

		int intBgnTime = 0;
		int intBgnMin = 0;

		String resultBgnTime = "";
		String resultBgnMin = "";

		log.debug("tmpBgnTime[0] : " + tmpBgnTime[0]);
		if (tmpBgn[0].equals("PM")){
			log.debug("Bgn PM if");
			intBgnTime = Integer.parseInt(tmpBgnTime[0]) + 12;
			intBgnMin = Integer.parseInt(tmpBgnTime[1]);
		} else {
			log.debug("Bgn PM else");
			intBgnTime = Integer.parseInt(tmpBgnTime[0]);
			intBgnMin = Integer.parseInt(tmpBgnTime[1]);
		}

		log.debug("################################");
		log.debug("##### intBgnTime : " + intBgnTime);

		if (intBgnTime <= 9){
			resultBgnTime = "0" + Integer.toString(intBgnTime);
		} else {
			resultBgnTime = Integer.toString(intBgnTime);
		}
		if (intBgnMin <= 9){
			resultBgnMin = "0" + Integer.toString(intBgnMin);
		} else {
			resultBgnMin = Integer.toString(intBgnMin);
		}

		log.debug("################################");
		log.debug("##### resultBgnTime : " + resultBgnTime);

		String[] tmpEnd = tmpEndtm.split(" ");
		String[] tmpEndTime = tmpEnd[1].split(":");
		int intEndTime = 0;
		int intEndMin = 0;

		String resultEndTime = "";
		String resultEndMin = "";
		log.debug("tmpEndTime[0] : " + tmpEndTime[0]);
		if (tmpEnd[0].equals("PM")){
			log.debug("end PM if");
			intEndTime = Integer.parseInt(tmpEndTime[0]) + 12;
			intEndMin = Integer.parseInt(tmpEndTime[1]);
		} else {
			log.debug("end PM else");
			intEndTime = Integer.parseInt(tmpEndTime[0]);
			intEndMin = Integer.parseInt(tmpEndTime[1]);
		}

		log.debug("################################");
		log.debug("##### intEndTime : " + intEndTime);

		if (intEndTime <= 9){
			resultEndTime = "0" + Integer.toString(intEndTime);
		} else {
			resultEndTime = Integer.toString(intEndTime);
		}
		if (intEndMin <= 9){
			resultEndMin = "0" + Integer.toString(intEndMin);
		} else {
			resultEndMin = Integer.toString(intEndMin);
		}
		log.debug("################################");
		log.debug("##### resultEndTime : " + resultEndTime);

		mapProperty.put("CAMPAIGNCODE",        Common.nvl((String) boProperty.getCampaigncode(), ""));
		mapProperty.put("CAMPAIGNID",          Common.nvl((String) request.getParameter("campaignid"), ""));
		mapProperty.put("CAMP_TERM_CD",        Common.nvl((String) boProperty.getCampaign_period().replace("그룹", "0"), ""));
		mapProperty.put("CAMP_BGN_DT1",        Common.nvl((String) tmpStr, ""));
		mapProperty.put("CAMP_BGN_DT2",        resultBgnTime);
		mapProperty.put("CAMP_BGN_DT3",        resultBgnMin);
		mapProperty.put("CAMP_END_DT1",        Common.nvl((String) tmpStr1, ""));
		mapProperty.put("CAMP_END_DT2",        resultEndTime);
		mapProperty.put("CAMP_END_DT3",        resultEndMin);
		mapProperty.put("CAMP_TERM_DAY",       Common.nvl((String) boProperty.getSend_day(), ""));
		mapProperty.put("AUDIENCE_CD",         Common.nvl((String) boProperty.getTarget_id(), ""));
		mapProperty.put("MANUAL_TRANS_YN",     Common.nvl((String) tmpManualTransYn, ""));
		mapProperty.put("OFFER_DIRECT_YN",     Common.nvl((String) boProperty.getOffer_auto_yn(), ""));
		mapProperty.put("CHANNEL_PRIORITY_YN", Common.nvl((String) boProperty.getChannel_batch_rank_yn(), ""));
		mapProperty.put("CREATE_ID", user.getId());
		mapProperty.put("UPDATE_ID", user.getId());
		System.out.println(">>>>>>>>>> in chkInsertUpdate.. " + mapProperty);

		// 철수전 작업사항 데이터 전송방식 Batch 일경우 캠페인 시작일을 내일부터 지정 할 수 있습니다!!
		Date from = new Date();
		SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String to = transFormat.format(from);

		String chkCampTermCd = Common.nvl((String) boProperty.getCampaign_period().replace("그룹", "0"), "");
		String chkManualTransYn = Common.nvl((String) tmpManualTransYn, "");
		String chkCampBgnDt = Common.nvl((String) tmpStr, "");

		if (chkIn.equals("insert")
				&& chkCampTermCd.equals("01")
				&& chkManualTransYn.equals("N")
				// && chkCampBgnDt.equals(to.substring(0, 10))){    // 김영천-20180502: 강석과 같이 수정함
				&& chkCampBgnDt.compareTo(to.substring(0, 10)) <= 0){
			return "8888";

		}

		// 철수전 작업사항 데이터 전송방식 Batch 일경우 캠페인 시작일을 내일부터 지정 할 수 있습니다!!
		this.campaignInfoService.setCampaignInfo(mapProperty);             // KANG-20190413: Sub-03. CampaignInfo.setCampaignInfo
		if (chkIn.equals("insert")){
			chkInsertOffer(mapProperty, map);
		}

		return "0000";
	}


	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	/**
	 * 캠페인 상태변경처리 화면의 캠페인 목록
	 * 
	 * KANG-20190508:
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @throws Exception
	 */
	@RequestMapping("/getCampaignStatusList.do")
	public void getCampaignStatusList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("serverType        : " + request.getParameter("serverType"));
		log.info("treeValue         : " + request.getParameter("treeValue"));
		log.info("selectPageNo      : " + request.getParameter("selectPageNo"));
		log.info("=============================================");

		//공통코드 목록 조회
		List<CampaignListBO> list = this.scheduleService.getCampaignStatusList(map);
		map.put("CampaignList", list);
		if (!Flag.flag) {
			log.info("=============================================");
			log.info("list   : " + list);
			log.info("=============================================");
		}

		jsonView.render(map, request, response);
	}

	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	/*
	 * KANG-20190413: analyzing
	 *
	 */
	private void chkInsertOffer(Map<String, Object> mapProperty, Map<String, Object> map) throws Exception{
		String CHANNEL_CMD = "";
		if (Common.nvl((String) mapProperty.get("channel_batch_rank_yn"), "").equals("Y")){
			CHANNEL_CMD = "NtoY";
		} else {
			CHANNEL_CMD = "YtoN";
		}

		// 데이터전송방식이 Batch 에서 Manual & Time 으로 변경될 경우 기존에 저장되어 있는 채널 노출시간은 null 로 저장
		String MANUAL_TRANS_YN = Common.nvl((String) mapProperty.get("senddate_type"), "");

		if (MANUAL_TRANS_YN.equals("Y") || MANUAL_TRANS_YN.equals("T")){
			this.campaignInfoService.setChannelDispTime(mapProperty);
		}

		if (CHANNEL_CMD.equals("YtoN")) {
			// 모든우선 순위가 N으로 변경됨
			mapProperty.put("PRIORITY_RNK", "N");
			this.campaignInfoService.setChannelPriority(mapProperty);
		} else if (CHANNEL_CMD.equals("NtoY")) {
			// 모든우선 순위가 5로 변경됨
			mapProperty.put("PRIORITY_RNK", "5");
			this.campaignInfoService.setChannelPriority(mapProperty);
		}

		// Offer Insert
		this.campaignInfoService.insertOfferData(map);
	}
}
