package com.skplanet.sascm.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.net.URLCodec;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.view.json.MappingJacksonJsonView;

import com.google.common.collect.Lists;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.reflect.TypeToken;
import com.skplanet.sascm.object.CampaignChannelBO;
import com.skplanet.sascm.object.CampaignInfoBO;
import com.skplanet.sascm.object.ChannelAlimiBO;
import com.skplanet.sascm.object.ChannelBO;
import com.skplanet.sascm.object.UaextCampaignTesterBO;
import com.skplanet.sascm.object.UaextCodeDtlBO;
import com.skplanet.sascm.object.UaextVariableBO;
import com.skplanet.sascm.object.UsmUserBO;
import com.skplanet.sascm.service.CampaignInfoService;
import com.skplanet.sascm.service.ChannelService;
import com.skplanet.sascm.service.CommCodeService;
import com.skplanet.sascm.service.TestTargetService;
import com.skplanet.sascm.service.VariableService;
import com.skplanet.sascm.util.Common;
import com.skplanet.sascm.util.Flag;

import skt.tmall.talk.dto.PushTalkParameter;
import skt.tmall.talk.dto.type.AppKdCdType;
import skt.tmall.talk.dto.type.Block;
import skt.tmall.talk.dto.type.BlockBoldText;
import skt.tmall.talk.dto.type.BlockBtnView;
import skt.tmall.talk.dto.type.BlockCouponText;
import skt.tmall.talk.dto.type.BlockImg240;
import skt.tmall.talk.dto.type.BlockImg500;
import skt.tmall.talk.dto.type.BlockLinkUrl;
import skt.tmall.talk.dto.type.BlockProductPrice;
import skt.tmall.talk.dto.type.BlockSubText;
import skt.tmall.talk.dto.type.BlockSubTextAlignType;
import skt.tmall.talk.dto.type.BlockTopCap;
import skt.tmall.talk.service.PushTalkSendService;

/**
 * ChannelController
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Controller
public class ChannelController {

	private final Log log = LogFactory.getLog(getClass());

	@Resource(name = "commCodeService")
	private CommCodeService commCodeService;

	@Resource(name = "channelService")
	private ChannelService channelService;

	@Resource(name = "variableService")
	private VariableService variableService;

	@Resource(name = "campaignInfoService")
	private CampaignInfoService campaignInfoService;

	//AJAX
	@Autowired
	private MappingJacksonJsonView jsonView;

	private ObjectMapper objectMapper = new ObjectMapper();

	/**
	 *
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getChannelInfoList.do")
	public void getChannelInfoList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("campaignid"));
		log.info("=============================================");

		//캠페인 정보 상세 조회
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("campaignid"), ""));
		map.put("USER_ID", user.getId());

		//채널정보
		List<CampaignChannelBO> channel_list = channelService.getCampaignChannelList(map);

		//2. 대상수준이 PCID일경우 채널이 토스트배너인지 체크
		String channelValiChk = channelService.getCampaignChannelValiChk(map);

		//5. 대상수준이 DEVICE_ID 일 경우 모바일 앱 채널만 사용가능
		String channelValChkforMobile = channelService.getCampaignChannelValiChkforMobile(map);

		map.put("channel_list", channel_list);
		map.put("channelValiChk", channelValiChk);
		map.put("channelValChkforMobile", channelValChkforMobile);
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));

		jsonView.render(map, request, response);
	}

	/**
	 * 채널 정보 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/channelInfo.do")
	public String pageChannelInfo(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//채널 목록 조회
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("codeId", "C011");
		map.put("USE_YN", "Y");
		map.put("CELLID", request.getParameter("CELLID"));  // KANG-20200415: add
		List<UaextCodeDtlBO> channel_list = commCodeService.getCommCodeDtlList2(map);  // KANG-20200415: add

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("CELLID       : " + request.getParameter("CELLID"));
		log.info("=============================================");

		//채널정보 조회
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));

		ChannelBO bo = channelService.getChannelInfo(map);

		modelMap.addAttribute("channel_list", channel_list);
		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("user", user);

		return "channel/channelInfo";
	}

	/**
	 * 채널 Toast배너 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/channelToast.do")
	public String pageChannelToast(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//채널 목록 조회
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("codeId", "C011");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> channel_list = commCodeService.getCommCodeDtlList(map);

		//우선순위
		map.put("codeId", "C006");
		List<UaextCodeDtlBO> priority_rank = commCodeService.getCommCodeDtlList(map);

		//이벤트 타입
		map.put("codeId", "C008");
		List<UaextCodeDtlBO> evt_type = commCodeService.getCommCodeDtlList(map);

		//linkUrl
		map.put("codeId", "C017"); //MEM_NO 일때의 LinkUrl
		List<UaextCodeDtlBO> linkUrl = commCodeService.getCommCodeDtlList(map);

		//linkUrl
		map.put("codeId", "C021"); //PCID 일때의 LinkUrl
		List<UaextCodeDtlBO> linkUrl2 = commCodeService.getCommCodeDtlList(map);

		//사용자 변수
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));
		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("CELLID       : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD   : " + request.getParameter("CHANNEL_CD"));
		log.info("COPYCHANNEL  : " + request.getParameter("COPYCHANNEL"));   // KANG-20200417
		log.info("=============================================");

		//채널정보 조회
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("CHANNEL_CD", Common.nvl(request.getParameter("CHANNEL_CD"), ""));

		ChannelBO bo = channelService.getChannelDtlInfo(map);

		modelMap.addAttribute("channel_list", channel_list);
		modelMap.addAttribute("priority_rank", priority_rank);
		modelMap.addAttribute("vri_list", vri_list);
		modelMap.addAttribute("evt_type", evt_type);
		modelMap.addAttribute("linkUrl", linkUrl);
		modelMap.addAttribute("linkUrl2", linkUrl2);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("CHANNEL_CD", request.getParameter("CHANNEL_CD"));
		modelMap.addAttribute("COPYCHANNEL", request.getParameter("COPYCHANNEL"));   // KANG-20200417
		modelMap.addAttribute("DISABLED", request.getParameter("DISABLED"));

		return "channel/channelToast";
	}

	/**
	 * 채널 Toast배너 페이지 호출     // KANG-20200417
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/copyChannelToast.do")
	public String pageCopyChannelToast(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		/////////////////////////////////////////
		// 채널 복사 KANG-20200415
		log.info("=============================================");
		log.info("srcCellId     : " + request.getParameter("srcCellId"));
		log.info("srcChannelCd  : " + request.getParameter("srcChannelCd"));
		log.info("tgtCampaignId : " + request.getParameter("tgtCampaignId"));
		log.info("tgtCellId     : " + request.getParameter("tgtCellId"));
		log.info("tgtChannelCd  : " + request.getParameter("tgtChannelCd"));
		log.info("tgtDispDt     : " + request.getParameter("tgtDispDt"));
		log.info("CampaignId    : " + request.getParameter("CampaignId"));
		log.info("CELLID        : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD    : " + request.getParameter("CHANNEL_CD"));
		log.info("COPYCHANNEL   : " + request.getParameter("COPYCHANNEL"));
		log.info("=============================================");
		map.clear();
		map.put("srcCellId"    , request.getParameter("srcCellId"    ));
		map.put("srcChannelCd" , request.getParameter("srcChannelCd" ));
		map.put("tgtCampaignId", request.getParameter("tgtCampaignId"));
		map.put("tgtCellId"    , request.getParameter("tgtCellId"    ));
		map.put("tgtChannelCd" , request.getParameter("tgtChannelCd" ));
		map.put("tgtDispDt"    , request.getParameter("tgtDispDt"    ));
		map.put("CampaignId"   , request.getParameter("CampaignId"   ));
		map.put("CELLID"       , request.getParameter("CELLID"       ));
		map.put("CHANNEL_CD"   , request.getParameter("CHANNEL_CD"   ));
		map.put("COPYCHANNEL"  , request.getParameter("COPYCHANNEL"  ));
		//ChannelBO bo = channelService.getChannelDtlInfo(map);

		//채널 목록 조회
		map.put("codeId", "C011");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> channel_list = commCodeService.getCommCodeDtlList(map);

		//우선순위
		map.put("codeId", "C006");
		List<UaextCodeDtlBO> priority_rank = commCodeService.getCommCodeDtlList(map);

		//이벤트 타입
		map.put("codeId", "C008");
		List<UaextCodeDtlBO> evt_type = commCodeService.getCommCodeDtlList(map);

		//linkUrl
		map.put("codeId", "C017"); //MEM_NO 일때의 LinkUrl
		List<UaextCodeDtlBO> linkUrl = commCodeService.getCommCodeDtlList(map);

		//linkUrl
		map.put("codeId", "C021"); //PCID 일때의 LinkUrl
		List<UaextCodeDtlBO> linkUrl2 = commCodeService.getCommCodeDtlList(map);

		//사용자 변수
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));
		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		// KANG-20200418: change logic
		ChannelBO tgtbo = null;
		ChannelBO bo = null;
		if (true) {
			//paramter
			log.info("=============================================");
			log.info("tgtCampaignId   : " + request.getParameter("tgtCampaignId"));
			log.info("tgtCellId       : " + request.getParameter("tgtCellId"));
			log.info("tgtChannelCd   : " + request.getParameter("tgtChannelCd"));
			log.info("=============================================");

			//채널정보 조회
			map.put("CAMPAIGNID", Common.nvl(request.getParameter("tgtCampaignId"), ""));
			map.put("CELLID", Common.nvl(request.getParameter("tgtCellId"), ""));
			map.put("CHANNEL_CD", Common.nvl(request.getParameter("tgtChannelCd"), ""));

			tgtbo = channelService.getChannelDtlInfo(map);
		}
		if (true) {
			//paramter
			log.info("=============================================");
			log.info("CampaignId   : " + request.getParameter("CampaignId"));
			log.info("CELLID       : " + request.getParameter("CELLID"));
			log.info("CHANNEL_CD   : " + request.getParameter("CHANNEL_CD"));
			log.info("=============================================");

			//채널정보 조회
			map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
			map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
			map.put("CHANNEL_CD", Common.nvl(request.getParameter("CHANNEL_CD"), ""));

			bo = channelService.getChannelDtlInfo(map);
		}
		
		// KANG-20200417: change values
		bo.setCampaigncode(tgtbo.getCampaigncode());
		bo.setCampaignname(tgtbo.getCampaignname());
		bo.setCampaignid(tgtbo.getCampaignid());
		bo.setCellid(tgtbo.getCellid());
		bo.setCellname(tgtbo.getCellname());
		bo.setChannel_cd(tgtbo.getChannel_cd());
		bo.setCamp_status_cd("EDIT");
		bo.setCamp_term_cd(tgtbo.getCamp_term_cd());
		bo.setCamp_bgn_dt(tgtbo.getCamp_bgn_dt());
		bo.setCamp_end_dt(tgtbo.getCamp_end_dt());
		bo.setCreate_id(tgtbo.getCreate_id());  // KANG-20200422: create upddate
		bo.setCreate_nm(tgtbo.getCreate_nm());
		bo.setCreate_dt(tgtbo.getCreate_dt());
		bo.setUpdate_id(tgtbo.getUpdate_id());
		bo.setUpdate_nm(tgtbo.getUpdate_nm());
		bo.setUpdate_dt(tgtbo.getUpdate_dt());

		modelMap.addAttribute("channel_list", channel_list);
		modelMap.addAttribute("priority_rank", priority_rank);
		modelMap.addAttribute("vri_list", vri_list);
		modelMap.addAttribute("evt_type", evt_type);
		modelMap.addAttribute("linkUrl", linkUrl);
		modelMap.addAttribute("linkUrl2", linkUrl2);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("CHANNEL_CD", request.getParameter("CHANNEL_CD"));
		modelMap.addAttribute("COPYCHANNEL", request.getParameter("COPYCHANNEL"));   // KANG-20200417
		modelMap.addAttribute("DISABLED", request.getParameter("DISABLED"));

		return "channel/channelToast";
	}

	/**
	 * 채널 Toast배너 미리보기
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/channelToastPreview.do")
	public void pageChannelToastPreview(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("TOAST_INPUT_MSG   : " + request.getParameter("TOAST_INPUT_MSG"));
		log.info("=============================================");

		String TOAST_MSG = Common.nvl(request.getParameter("TOAST_INPUT_MSG"), "");

		//사용자 변수 목록을 조회
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));

		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		for (int i = 0; i < vri_list.size(); i++) { //Toast 메세지에 사용자변수가 사용되었는지 체크
			UaextVariableBO bo = vri_list.get(i);

			log.info("=============================================");
			String vari_name = "{" + bo.getVari_name() + "}";
			log.info("getVari_name   : " + vari_name);

			if (TOAST_MSG.indexOf(vari_name) > -1) { //변수가 존재할경우
				log.info("변수 존재함!");

				String[] arr = bo.getRef_table().split("\\.");
				String tmpTbl = "";
				if(arr.length > 0){
					tmpTbl =  arr[1];
				}else{
					tmpTbl =  arr[0];
				}
				//테스트용 데이터 조회
				map.put("REF_TABLE", tmpTbl);
				map.put("REF_COLUMN", bo.getRef_column());
				map.put("KEY_COLUMN", bo.getKey_column());
				map.put("MAX_BYTE", bo.getMax_byte());

				String preval = variableService.getVariablePreVal(map);
				log.info("조회된 변수값   : " + preval);

				//변수값 변경하기
				TOAST_MSG = TOAST_MSG.replaceAll("\\" + vari_name, preval);
				log.info("변경된 값   : " + TOAST_MSG);
			} else {
				log.info("변수 미존재..");
			}
			log.info("=============================================");
		}

		map.put("TOAST_INPUT_MSG", TOAST_MSG);

		jsonView.render(map, request, response);
	}

	/**
	 * 채널 Toast배너 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setChannelToast.do")
	public void setChannelToast(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("CAMPAIGNID           : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE         : " + request.getParameter("CAMPAIGNCODE"));
		log.info("FLOWCHARTID          : " + request.getParameter("FLOWCHARTID"));
		log.info("CELLID               : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD           : " + request.getParameter("CHANNEL_CD"));

		log.info("TOAST_TITLE          : " + request.getParameter("TOAST_TITLE"));
		log.info("TOAST_MSG            : " + request.getParameter("TOAST_MSG"));
		log.info("TOAST_INPUT_MSG      : " + request.getParameter("TOAST_INPUT_MSG"));
		log.info("TOAST_IMG_URL        : " + request.getParameter("TOAST_IMG_URL"));
		log.info("TOAST_LINK_URL       : " + request.getParameter("TOAST_LINK_URL"));
		log.info("TOAST_MSG_DESC       : " + request.getParameter("TOAST_MSG_DESC"));
		log.info("TOAST_PRIORITY_RNK   : " + request.getParameter("TOAST_PRIORITY_RNK"));
		log.info("TOAST_EVNT_TYP_CD    : " + request.getParameter("TOAST_EVNT_TYP_CD"));
		log.info("=============================================");

		String TOAST_MSG = Common.nvl(request.getParameter("TOAST_MSG"), "");

		//사용자 변수 목록을 조회
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));

		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		int vai_cnt = 0;
		List<String> query_lsit0 = new ArrayList<String>();
		List<String> query_lsit1 = new ArrayList<String>();
		List<String> query_lsit2 = new ArrayList<String>();
		List<String> query_lsit3 = new ArrayList<String>();
		List<String> query_lsit4 = new ArrayList<String>();
		List<String> query_lsit5 = new ArrayList<String>(); //MAX BYTE

		for (int i = 0; i < vri_list.size(); i++) { //Toast 메세지에 사용자변수가 사용되었는지 체크
			UaextVariableBO bo = vri_list.get(i);

			log.info("=============================================");
			String vari_name = "{" + bo.getVari_name() + "}";
			log.info("getVari_name   : " + vari_name);

			if (TOAST_MSG.indexOf(vari_name) > -1) { //변수가 존재할경우 조회 쿼리를 만든다
				log.info("변수 존재함!");

				//테스트용 데이터 조회
				String VARI_NAME = bo.getVari_name();
				String REF_TABLE = bo.getRef_table();
				String REF_COLUMN = bo.getRef_column();
				String KEY_COLUMN = bo.getKey_column();
				String IF_NULL = bo.getIf_null();
				String MAX_LENGTH = bo.getMax_byte();

				query_lsit0.add(VARI_NAME);
				query_lsit1.add(REF_TABLE);
				query_lsit2.add(REF_COLUMN);
				query_lsit3.add(KEY_COLUMN);
				query_lsit4.add(IF_NULL);
				query_lsit5.add(MAX_LENGTH);

				vai_cnt++; //카운트 +1

				log.info("* VARI_NAME : " + VARI_NAME + " * REF_TABLE : " + REF_TABLE + " * REF_COLUMN : " + REF_COLUMN
						+ " * KEY_COLUMN : " + KEY_COLUMN + " * IF_NULL : " + IF_NULL + " * MAX_LENGTH : " + MAX_LENGTH);
			} else {
				log.info("변수 미존재..");
			}
			log.info("=============================================");
		}

		// 		조회쿼리를 생성하여 db에 저장한다(ex)
		//		SELECT T.MEM_NO, '이름=' || T1.NAME ||'#@#id=' || T2.CODE
		//		  FROM [TARGETTABLE] T0
		//		,(SELECT NAME FROM TABLE1) T1
		//		,(SELECT CODE FROM TABLE2) T2
		//		WHERE T0.MEM_NO = T1.KEY1(+)
		//		  AND T0.MEM_NO = T2.KEY2(+)

		String TOAST_MSG_QUERY = "";
		String TOAST_MSG_QUERY1 = ""; //SELECT T.MEM_NO,
		String TOAST_MSG_QUERY2 = ""; //[TARGETTABLE]
		String TOAST_MSG_QUERY3 = ""; //FROM
		String TOAST_MSG_QUERY4 = ""; //WHERE

		for (int i = 0; i < vai_cnt; i++) { //존재한 변수만큼 조회 쿼리를 만든다
			if (i == 0) { //최초
				TOAST_MSG_QUERY1 += "SELECT T.MEM_NO,";
				TOAST_MSG_QUERY1 += " '" + query_lsit0.get(i) + "=' || SUBSTRB(NVL(T" + i + "." + query_lsit2.get(i) + ", '"
						+ query_lsit4.get(i) + "'), 0," + query_lsit5.get(i) + ")";
				TOAST_MSG_QUERY2 += " FROM [TARGETTABLE] T";
				TOAST_MSG_QUERY3 += " , (SELECT * FROM " + query_lsit1.get(i) + ") T" + i;
				TOAST_MSG_QUERY4 += " WHERE T.MEM_NO = T" + i + "." + query_lsit3.get(i) + "(+)";
			} else {
				TOAST_MSG_QUERY1 += " ||'#@#" + query_lsit0.get(i) + "=' || SUBSTRB(NVL(T" + i + "." + query_lsit2.get(i) + ", '"
						+ query_lsit4.get(i) + "'), 0," + query_lsit5.get(i) + ")";
				TOAST_MSG_QUERY3 += " , (SELECT * FROM " + query_lsit1.get(i) + ") T" + i;
				TOAST_MSG_QUERY4 += " AND T.MEM_NO = T" + i + "." + query_lsit3.get(i) + "(+)";
			}
		}

		TOAST_MSG_QUERY = TOAST_MSG_QUERY1 + TOAST_MSG_QUERY2 + TOAST_MSG_QUERY3 + TOAST_MSG_QUERY4;

		log.info("=============================================");
		log.info("TOAST_MSG_QUERY ::: " + TOAST_MSG_QUERY);
		log.info("=============================================");

		//입력 값
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("FLOWCHARTID", Common.nvl(request.getParameter("FLOWCHARTID"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("CHANNEL_CD", "TOAST"); //TOAST 배너
		map.put("TOAST_TITLE", Common.nvl(request.getParameter("TOAST_TITLE"), ""));
		map.put("TOAST_MSG", Common.nvl(request.getParameter("TOAST_MSG"), ""));
		map.put("TOAST_INPUT_MSG", Common.nvl(request.getParameter("TOAST_INPUT_MSG"), ""));
		map.put("TOAST_IMG_URL", Common.nvl(request.getParameter("TOAST_IMG_URL"), ""));
		map.put("TOAST_MSG_QUERY", Common.nvl(TOAST_MSG_QUERY, ""));
		map.put("TOAST_LINK_URL", Common.nvl(request.getParameter("TOAST_LINK_URL"), ""));
		map.put("TOAST_MSG_DESC", Common.nvl(request.getParameter("TOAST_MSG_DESC"), ""));
		map.put("TOAST_PRIORITY_RNK", Common.nvl(request.getParameter("TOAST_PRIORITY_RNK"), ""));
		map.put("TOAST_EVNT_TYP_CD", Common.nvl(request.getParameter("TOAST_EVNT_TYP_CD"), ""));
		map.put("CREATE_ID", user.getId());
		map.put("UPDATE_ID", user.getId());

		//캠페인의 상태체크(START일경우에는 수정못함)
		CampaignInfoBO bo = campaignInfoService.getCampaignInfo(map);
		String CMP_STATUS = Common.nvl(bo.getCamp_status_cd(), "");

		if (!CMP_STATUS.equals("START")) {
			//토스트 배너 정보 저장
			channelService.setChannelToast(map);
		}

		//캠페인 상태 리턴
		map.put("CMP_STATUS", CMP_STATUS);

		jsonView.render(map, request, response);
	}

	/**
	 * 채널 SMS 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/channelSms.do")
	public String pageChannelSms(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		//채널 목록 조회
		map.put("codeId", "C011");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> channel_list = commCodeService.getCommCodeDtlList(map);

		//우선순위
		map.put("codeId", "C006");
		List<UaextCodeDtlBO> priority_rank = commCodeService.getCommCodeDtlList(map);

		//SMS우선순위별발송시간
		map.put("codeId", "C026");
		List<UaextCodeDtlBO> priority_rank_sendtime = commCodeService.getCommCodeDtlList(map);

		//완료시 전달번호
		map.put("codeId", "C012");
		List<UaextCodeDtlBO> comp_list = commCodeService.getCommCodeDtlList(map);

		//CALLBACK 번호
		map.put("codeId", "C023");
		List<UaextCodeDtlBO> callback_list = commCodeService.getCommCodeDtlList(map);

		//연결페이지 구분
		map.put("codeId", "G006");
		List<UaextCodeDtlBO> smsSendPreferCd = commCodeService.getCommCodeDtlList(map);


		//사용자 변수
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));
		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("CELLID       : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD   : " + request.getParameter("CHANNEL_CD"));
		log.info("COPYCHANNEL  : " + request.getParameter("COPYCHANNEL"));   // KANG-20200417
		log.info("=============================================");

		//채널정보 조회
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("CHANNEL_CD", Common.nvl(request.getParameter("CHANNEL_CD"), ""));

		ChannelBO bo = channelService.getChannelDtlInfo(map);

		modelMap.addAttribute("channel_list", channel_list);
		modelMap.addAttribute("priority_rank", priority_rank);
		modelMap.addAttribute("priority_rank_sendtime", priority_rank_sendtime);
		//modelMap.addAttribute("campScheduleTime", Common.campScheduleTime);
		modelMap.addAttribute("smsSendPreferCd", smsSendPreferCd);

		modelMap.addAttribute("vri_list", vri_list);
		modelMap.addAttribute("comp_list", comp_list);
		modelMap.addAttribute("callback_list", callback_list);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("CHANNEL_CD", request.getParameter("CHANNEL_CD"));
		modelMap.addAttribute("COPYCHANNEL", request.getParameter("COPYCHANNEL"));   // KANG-20200417
		modelMap.addAttribute("DISABLED", request.getParameter("DISABLED"));

		return "channel/channelSms";
	}

	/**
	 * 채널 SMS 페이지 호출   // KANG-20200417
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/copyChannelSms.do")
	public String pageCopyChannelSms(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		/////////////////////////////////////////
		// 채널 복사 KANG-20200415
		log.info("=============================================");
		log.info("srcCellId     : " + request.getParameter("srcCellId"));
		log.info("srcChannelCd  : " + request.getParameter("srcChannelCd"));
		log.info("tgtCampaignId : " + request.getParameter("tgtCampaignId"));
		log.info("tgtCellId     : " + request.getParameter("tgtCellId"));
		log.info("tgtChannelCd  : " + request.getParameter("tgtChannelCd"));
		log.info("tgtDispDt     : " + request.getParameter("tgtDispDt"));
		log.info("CampaignId    : " + request.getParameter("CampaignId"));
		log.info("CELLID        : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD    : " + request.getParameter("CHANNEL_CD"));
		log.info("COPYCHANNEL   : " + request.getParameter("COPYCHANNEL"));
		log.info("MANUAL_TRANS_YN  : " + request.getParameter("MANUAL_TRANS_YN"));   // KANG-20200606: create
		log.info("DISP_TIME        : " + request.getParameter("DISP_TIME"));         // KANG-20200606: create
		log.info("SEND_PREFER_CD   : " + request.getParameter("SEND_PREFER_CD"));    // KANG-20200606: create
		log.info("=============================================");
		map.clear();
		map.put("srcCellId"    , request.getParameter("srcCellId"    ));
		map.put("srcChannelCd" , request.getParameter("srcChannelCd" ));
		map.put("tgtCampaignId", request.getParameter("tgtCampaignId"));
		map.put("tgtCellId"    , request.getParameter("tgtCellId"    ));
		map.put("tgtChannelCd" , request.getParameter("tgtChannelCd" ));
		map.put("tgtDispDt"    , request.getParameter("tgtDispDt"    ));
		map.put("CampaignId"   , request.getParameter("CampaignId"   ));
		map.put("CELLID"       , request.getParameter("CELLID"       ));
		map.put("CHANNEL_CD"   , request.getParameter("CHANNEL_CD"   ));
		map.put("COPYCHANNEL"  , request.getParameter("COPYCHANNEL"  ));
		//ChannelBO bo = channelService.getChannelDtlInfo(map);


		//채널 목록 조회
		map.put("codeId", "C011");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> channel_list = commCodeService.getCommCodeDtlList(map);

		//우선순위
		map.put("codeId", "C006");
		List<UaextCodeDtlBO> priority_rank = commCodeService.getCommCodeDtlList(map);

		//SMS우선순위별발송시간
		map.put("codeId", "C026");
		List<UaextCodeDtlBO> priority_rank_sendtime = commCodeService.getCommCodeDtlList(map);

		//완료시 전달번호
		map.put("codeId", "C012");
		List<UaextCodeDtlBO> comp_list = commCodeService.getCommCodeDtlList(map);

		//CALLBACK 번호
		map.put("codeId", "C023");
		List<UaextCodeDtlBO> callback_list = commCodeService.getCommCodeDtlList(map);

		//연결페이지 구분
		map.put("codeId", "G006");
		List<UaextCodeDtlBO> smsSendPreferCd = commCodeService.getCommCodeDtlList(map);


		//사용자 변수
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));
		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		// KANG-20200418: change logic
		ChannelBO tgtbo = null;
		ChannelBO bo = null;
		if (true) {
			//paramter
			log.info("=============================================");
			log.info("tgtCampaignId   : " + request.getParameter("tgtCampaignId"));
			log.info("tgtCellId       : " + request.getParameter("tgtCellId"));
			log.info("tgtChannelCd   : " + request.getParameter("tgtChannelCd"));
			log.info("=============================================");

			//채널정보 조회
			map.put("CAMPAIGNID", Common.nvl(request.getParameter("tgtCampaignId"), ""));
			map.put("CELLID", Common.nvl(request.getParameter("tgtCellId"), ""));
			map.put("CHANNEL_CD", Common.nvl(request.getParameter("tgtChannelCd"), ""));

			tgtbo = channelService.getChannelDtlInfo(map);
		}
		if (true) {
			//paramter
			log.info("=============================================");
			log.info("CampaignId   : " + request.getParameter("CampaignId"));
			log.info("CELLID       : " + request.getParameter("CELLID"));
			log.info("CHANNEL_CD   : " + request.getParameter("CHANNEL_CD"));
			log.info("=============================================");

			//채널정보 조회
			map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
			map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
			map.put("CHANNEL_CD", Common.nvl(request.getParameter("CHANNEL_CD"), ""));

			bo = channelService.getChannelDtlInfo(map);
		}

		// KANG-20200417: change values
		bo.setCampaigncode(tgtbo.getCampaigncode());
		bo.setCampaignname(tgtbo.getCampaignname());
		bo.setCampaignid(tgtbo.getCampaignid());
		bo.setCellid(tgtbo.getCellid());
		bo.setCellname(tgtbo.getCellname());
		bo.setChannel_cd(tgtbo.getChannel_cd());
		bo.setSms_disp_dt(request.getParameter("tgtDispDt"));
		bo.setCamp_status_cd("EDIT");
		bo.setCamp_term_cd(tgtbo.getCamp_term_cd());
		bo.setSms_disp_dt(tgtbo.getSms_disp_dt());
		bo.setCamp_bgn_dt(tgtbo.getCamp_bgn_dt());
		bo.setCamp_end_dt(tgtbo.getCamp_end_dt());
		bo.setCreate_id(tgtbo.getCreate_id());  // KANG-20200422: create upddate
		bo.setCreate_nm(tgtbo.getCreate_nm());
		bo.setCreate_dt(tgtbo.getCreate_dt());
		bo.setUpdate_id(tgtbo.getUpdate_id());
		bo.setUpdate_nm(tgtbo.getUpdate_nm());
		bo.setUpdate_dt(tgtbo.getUpdate_dt());
		bo.setSms_returncall("");   // KANG-20200418

		if (true) {
			// KANG-20200622: condition: bo is manual and tgt is manual and tgt is SEND02
			log.info("============ KANG-20200622(org) =============");
			log.info("bo.manual_trans_yn     : " + bo.getManual_trans_yn());
			log.info("bo.sms_disp_time       : " + bo.getSms_disp_time());
			log.info("bo.sms_send_prefer_cd  : " + bo.getSms_send_prefer_cd());
			log.info("---------------------------------------------");
			log.info("tgtbo.manual_trans_yn     : " + tgtbo.getManual_trans_yn());
			log.info("tgtbo.sms_disp_time       : " + tgtbo.getSms_disp_time());
			log.info("tgtbo.sms_send_prefer_cd  : " + tgtbo.getSms_send_prefer_cd());
			log.info("=============================================");
			
			if (tgtbo.getManual_trans_yn().equals("N")
					&& bo.getManual_trans_yn().equals("N")
					&& bo.getSms_send_prefer_cd().equals("SEND02")) {
				// KANG-20200622: copy
				log.info("KANG-20200622 >>>>>> because of condition_OK!!, then COPY from tgt.....");
			} else {
				// KANG-20200622: no copy, original
				bo.setManual_trans_yn(request.getParameter("MANUAL_TRANS_YN"));         // KANG-20200606: create
				bo.setSms_disp_time(request.getParameter("DISP_TIME"));                 // KANG-20200606: create
				bo.setSms_send_prefer_cd(request.getParameter("SEND_PREFER_CD"));       // KANG-20200606: create
			}
		}
		
		modelMap.addAttribute("channel_list", channel_list);
		modelMap.addAttribute("priority_rank", priority_rank);
		modelMap.addAttribute("priority_rank_sendtime", priority_rank_sendtime);
		//modelMap.addAttribute("campScheduleTime", Common.campScheduleTime);
		modelMap.addAttribute("smsSendPreferCd", smsSendPreferCd);

		modelMap.addAttribute("vri_list", vri_list);
		modelMap.addAttribute("comp_list", comp_list);
		modelMap.addAttribute("callback_list", callback_list);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("CELLID", request.getParameter("CELLID"));
		modelMap.addAttribute("CHANNEL_CD", request.getParameter("CHANNEL_CD"));
		modelMap.addAttribute("COPYCHANNEL", request.getParameter("COPYCHANNEL"));   // KANG-20200417
		modelMap.addAttribute("DISABLED", request.getParameter("DISABLED"));

		return "channel/channelSms";
	}

	/**
	 * 채널 SMS 미리보기
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channelSmsPreview.do")
	public void channelSmsPreview(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("SMS_INPUT_MSG   : " + request.getParameter("SMS_INPUT_MSG"));
		log.info("=============================================");

		String SMS_MSG = Common.nvl(request.getParameter("SMS_INPUT_MSG"), "");

		//사용자 변수 목록을 조회
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));

		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		for (int i = 0; i < vri_list.size(); i++) { //Toast 메세지에 사용자변수가 사용되었는지 체크
			UaextVariableBO bo = vri_list.get(i);

			log.info("=============================================");
			String vari_name = "{" + bo.getVari_name() + "}";
			log.info("getVari_name   : " + vari_name);

			if (SMS_MSG.indexOf(vari_name) > -1) { //변수가 존재할경우
				log.info("변수 존재함!");

				//테스트용 데이터 조회
				map.put("REF_TABLE", bo.getRef_table());
				map.put("REF_COLUMN", bo.getRef_column());
				map.put("KEY_COLUMN", bo.getKey_column());
				map.put("MAX_BYTE", bo.getMax_byte());

				String preval = variableService.getVariablePreVal(map);
				log.info("조회된 변수값   : " + preval);

				//변수값 변경하기
				SMS_MSG = SMS_MSG.replaceAll("\\" + vari_name, preval);
				log.info("변경된 값   : " + SMS_MSG);
			} else {
				log.info("변수 미존재..");
			}
			log.info("=============================================");
		}

		map.put("SMS_INPUT_MSG", SMS_MSG);

		jsonView.render(map, request, response);
	}

	/**
	 * 채널 SMS ShortURL가져오기
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channelSmsShortUrl.do")
	public void channelSmsShortUrl(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("SMS_LONGURL   : " + request.getParameter("SMS_LONGURL"));

		String SMS_LONGURL = "http://bizapi.11st.co.kr/jsp/message/get_callback_url.jsp?domain=11st.kr&url="
				+ Common.nvl(request.getParameter("SMS_LONGURL"), "");

		log.info("SMS_LONGURL2   : " + SMS_LONGURL);
		log.info("=============================================");

		//url 가져오기
		URL url = null;
		String line = "";
		BufferedReader input = null;
		String ShortUrl = "";

		try {
			url = new URL(SMS_LONGURL);
			input = new BufferedReader(new InputStreamReader(url.openStream()));
			while ((line = input.readLine()) != null) {
				ShortUrl += line;
			}

			log.info("=============================================");
			log.info("SHORT_URL   : " + ShortUrl);
			log.info("=============================================");
		} catch (MalformedURLException mue) {
			log.info("잘못되 URL입니다. 사용법 : java URLConn http://hostname/path]");
		} catch (IOException ioe) {
			log.info("IOException " + ioe);
			ioe.printStackTrace();
		}

		map.put("SHORT_URL", ShortUrl);

		jsonView.render(map, request, response);
	}

	/**
	 * 채널 SMS 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("setChannelSms.do")
	public void setChannelSms(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("CAMPAIGNID           : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE         : " + request.getParameter("CAMPAIGNCODE"));
		log.info("FLOWCHARTID          : " + request.getParameter("FLOWCHARTID"));
		log.info("CELLID               : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD           : " + request.getParameter("CHANNEL_CD"));

		log.info("SMS_MSG              : " + request.getParameter("SMS_MSG"));
		log.info("SMS_PRIORITY_RNK     : " + request.getParameter("SMS_PRIORITY_RNK"));
		log.info("SMS_DISP_TIME        : " + request.getParameter("SMS_DISP_TIME"));
		log.info("SMS_LONGURL          : " + request.getParameter("SMS_LONGURL"));
		log.info("SMS_SHORTURL         : " + request.getParameter("SMS_SHORTURL"));
		log.info("SMS_DISP_DT          : " + request.getParameter("SMS_DISP_DT"));
		log.info("SMS_CALLBACK         : " + request.getParameter("SMS_CALLBACK"));
		log.info("SMS_RETURNCALL       : " + request.getParameterValues("SMS_RETURNCALL"));
		log.info("SMS_SEND_PREFER_CD       : " + request.getParameter("SMS_SEND_PREFER_CD"));
		log.info("=============================================");

		String SMS_MSG = Common.nvl(request.getParameter("SMS_MSG"), "");

		//사용자 변수 목록을 조회
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));

		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		int vai_cnt = 0;
		List<String> query_lsit0 = new ArrayList<String>(); //변수명
		List<String> query_lsit1 = new ArrayList<String>(); //참조테이블
		List<String> query_lsit2 = new ArrayList<String>(); //참조컬럼
		List<String> query_lsit3 = new ArrayList<String>(); //키컬럼
		List<String> query_lsit4 = new ArrayList<String>(); //널값일경우
		List<String> query_lsit5 = new ArrayList<String>(); //MAX BYTE

		for (int i = 0; i < vri_list.size(); i++) { //SMS 메세지에 사용자변수가 사용되었는지 체크
			UaextVariableBO bo = vri_list.get(i);

			log.info("=============================================");
			String vari_name = "{" + bo.getVari_name() + "}";
			log.info("getVari_name   : " + vari_name);

			if (SMS_MSG.indexOf(vari_name) > -1) { //변수가 존재할경우 조회 쿼리를 만든다
				log.info("변수 존재함!");

				//테스트용 데이터 조회
				String VARI_NAME = bo.getVari_name();
				String REF_TABLE = bo.getRef_table();
				String REF_COLUMN = bo.getRef_column();
				String KEY_COLUMN = bo.getKey_column();
				String IF_NULL = bo.getIf_null();
				String MAX_LENGTH = bo.getMax_byte();

				query_lsit0.add(VARI_NAME);
				query_lsit1.add(REF_TABLE);
				query_lsit2.add(REF_COLUMN);
				query_lsit3.add(KEY_COLUMN);
				query_lsit4.add(IF_NULL);
				query_lsit5.add(MAX_LENGTH);

				vai_cnt++; //카운트 +1

				log.info("* VARI_NAME : " + VARI_NAME + " * REF_TABLE : " + REF_TABLE + " * REF_COLUMN : " + REF_COLUMN
						+ " * KEY_COLUMN : " + KEY_COLUMN + " * IF_NULL : " + IF_NULL + " * MAX_LENGTH : " + MAX_LENGTH);
			} else {
				log.info("변수 미존재..");
			}
			log.info("=============================================");
		}

		// 		조회쿼리를 생성하여 db에 저장한다(ex)
		//		SELECT T.MEM_NO, T1.NAME || '님 반갑습니다 ' || T2.RANK || '등급이 되셨습니다'
		//		  FROM [TARGETTABLE] T
		//		,(SELECT NAME FROM TABLE1) T1
		//		,(SELECT CODE FROM TABLE2) T2
		//		WHERE T0.MEM_NO = T1.KEY1(+)
		//		  AND T0.MEM_NO = T2.KEY2(+)

		String SMS_MSG_QUERY = "";
		String SMS_MSG_QUERY1 = ""; //SELECT T.MEM_NO,
		String SMS_MSG_QUERY2 = ""; //[TARGETTABLE]
		String SMS_MSG_QUERY3 = ""; //FROM
		String SMS_MSG_QUERY4 = ""; //WHERE

		for (int i = 0; i < vai_cnt; i++) { //존재한 변수만큼 조회 쿼리를 만든다
			if (i == 0) { //최초
				SMS_MSG_QUERY1 += "SELECT T.MEM_NO, '" + SMS_MSG + "'";
				SMS_MSG_QUERY1 = SMS_MSG_QUERY1.replaceAll("\\{" + query_lsit0.get(i) + "}", "' || SUBSTRB(NVL(T" + i + "."
						+ query_lsit2.get(i) + ", '" + query_lsit4.get(i) + "'), 0," + query_lsit5.get(i) + ") || '");
				SMS_MSG_QUERY2 += " FROM [TARGETTABLE] T";
				SMS_MSG_QUERY3 += " , (SELECT * FROM " + query_lsit1.get(i) + ") T" + i;
				SMS_MSG_QUERY4 += " WHERE T.MEM_NO = T" + i + "." + query_lsit3.get(i) + "(+)";
			} else {
				SMS_MSG_QUERY1 = SMS_MSG_QUERY1.replaceAll("\\{" + query_lsit0.get(i) + "}", "' || SUBSTRB(NVL(T" + i + "."
						+ query_lsit2.get(i) + ", '" + query_lsit4.get(i) + "'), 0," + query_lsit5.get(i) + ") || '");
				SMS_MSG_QUERY3 += " , (SELECT * FROM " + query_lsit1.get(i) + ") T" + i;
				SMS_MSG_QUERY4 += " AND T.MEM_NO = T" + i + "." + query_lsit3.get(i) + "(+)";
			}
		}

		SMS_MSG_QUERY = SMS_MSG_QUERY1 + SMS_MSG_QUERY2 + SMS_MSG_QUERY3 + SMS_MSG_QUERY4;

		log.info("=============================================");
		log.info("SMS_MSG_QUERY ::: " + SMS_MSG_QUERY);
		log.info("=============================================");

		//입력 값
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("FLOWCHARTID", Common.nvl(request.getParameter("FLOWCHARTID"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("CHANNEL_CD", "SMS"); //SMS

		map.put("SMS_MSG", Common.nvl(request.getParameter("SMS_MSG"), ""));
		map.put("SMS_MSG_QUERY", Common.nvl(SMS_MSG_QUERY, ""));
		map.put("SMS_PRIORITY_RNK", Common.nvl(request.getParameter("SMS_PRIORITY_RNK"), ""));

		map.put("SMS_DISP_TIME", Common.nvl(request.getParameter("SMS_DISP_TIME"), ""));

		map.put("SMS_SEND_PREFER_CD", Common.nvl(request.getParameter("SMS_SEND_PREFER_CD"), ""));

		map.put("SMS_LONGURL", Common.nvl(request.getParameter("SMS_LONGURL"), ""));
		map.put("SMS_SHORTURL", Common.nvl(request.getParameter("SMS_SHORTURL"), ""));
		map.put("SMS_DISP_DT", Common.nvl(request.getParameter("SMS_DISP_DT"), ""));
		map.put("SMS_CALLBACK", Common.nvl(request.getParameter("SMS_CALLBACK"), ""));
		String SMS_RETURNCALLS[] = request.getParameterValues("SMS_RETURNCALL");
		String SMS_RETURNCALL = "";
		for (int i = 0; i < SMS_RETURNCALLS.length; i++) {
			if (i == 0) {
				SMS_RETURNCALL = SMS_RETURNCALLS[i];
			} else {
				SMS_RETURNCALL += ";" + SMS_RETURNCALLS[i];
			}
		}
		map.put("SMS_RETURNCALL", SMS_RETURNCALL);
		map.put("CREATE_ID", user.getId());
		map.put("UPDATE_ID", user.getId());

		//캠페인의 상태체크(START일경우에는 수정못함)
		CampaignInfoBO bo = campaignInfoService.getCampaignInfo(map);
		String CMP_STATUS = Common.nvl(bo.getCamp_status_cd(), "");

		if (!CMP_STATUS.equals("START")) {
			//SMS 정보 저장
			channelService.setChannelSms(map);
		}

		//캠페인 상태 리턴
		map.put("CMP_STATUS", CMP_STATUS);

		jsonView.render(map, request, response);
	}

	/**
	 * 채널 EMAIL 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/channelEmail.do")
	public String pageChannelEmail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		//채널 목록 조회
		map.put("codeId", "C011");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> channel_list = commCodeService.getCommCodeDtlList(map);

		//우선순위
		map.put("codeId", "C006");
		List<UaextCodeDtlBO> priority_rank = commCodeService.getCommCodeDtlList(map);

		//EMAIL우선순위별발송시간
		map.put("codeId", "C027");
		List<UaextCodeDtlBO> priority_rank_sendtime = commCodeService.getCommCodeDtlList(map);

		//사용자 변수 목록을 조회
		map.put("codeId", "C013");
		List<UaextCodeDtlBO> vri_list = commCodeService.getCommCodeDtlList(map);

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("CELLID       : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD   : " + request.getParameter("CHANNEL_CD"));
		log.info("COPYCHANNEL  : " + request.getParameter("COPYCHANNEL"));   // KANG-20200417
		log.info("=============================================");

		//채널정보 조회
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CELLID",     Common.nvl(request.getParameter("CELLID"), ""));
		map.put("CHANNEL_CD", Common.nvl(request.getParameter("CHANNEL_CD"), ""));

		ChannelBO bo = channelService.getChannelDtlInfo(map);

		if ( bo.getEmail_subject() != null ){
			bo.setEmail_subject(bo.getEmail_subject().replaceAll("\"", "&quot;"));
		}

		modelMap.addAttribute("channel_list", channel_list);
		modelMap.addAttribute("priority_rank", priority_rank);
		modelMap.addAttribute("priority_rank_sendtime", priority_rank_sendtime);
		modelMap.addAttribute("vri_list", vri_list);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("CHANNEL_CD", request.getParameter("CHANNEL_CD"));
		modelMap.addAttribute("COPYCHANNEL", request.getParameter("COPYCHANNEL"));   // KANG-20200417
		modelMap.addAttribute("DISABLED", request.getParameter("DISABLED"));

		return "channel/channelEmail";
	}

	/**
	 * 채널 EMAIL 페이지 호출   // KANG-20200417
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/copyChannelEmail.do")
	public String pageCopyChannelEmail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		/////////////////////////////////////////
		// 채널 복사 KANG-20200415
		log.info("=============================================");
		log.info("srcCellId     : " + request.getParameter("srcCellId"));
		log.info("srcChannelCd  : " + request.getParameter("srcChannelCd"));
		log.info("tgtCampaignId : " + request.getParameter("tgtCampaignId"));
		log.info("tgtCellId     : " + request.getParameter("tgtCellId"));
		log.info("tgtChannelCd  : " + request.getParameter("tgtChannelCd"));
		log.info("tgtDispDt     : " + request.getParameter("tgtDispDt"));
		log.info("CampaignId    : " + request.getParameter("CampaignId"));
		log.info("CELLID        : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD    : " + request.getParameter("CHANNEL_CD"));
		log.info("COPYCHANNEL   : " + request.getParameter("COPYCHANNEL"));
		log.info("MANUAL_TRANS_YN    : " + request.getParameter("MANUAL_TRANS_YN"));        // KANG-20200606: create
		log.info("DISP_TIME          : " + request.getParameter("DISP_TIME"));              // KANG-20200606: create
		log.info("SEND_PREFER_CD     : " + request.getParameter("SEND_PREFER_CD"));         // KANG-20200606: create
		log.info("=============================================");
		map.clear();
		map.put("srcCellId"    , request.getParameter("srcCellId"    ));
		map.put("srcChannelCd" , request.getParameter("srcChannelCd" ));
		map.put("tgtCampaignId", request.getParameter("tgtCampaignId"));
		map.put("tgtCellId"    , request.getParameter("tgtCellId"    ));
		map.put("tgtChannelCd" , request.getParameter("tgtChannelCd" ));
		map.put("tgtDispDt"    , request.getParameter("tgtDispDt"    ));
		map.put("CampaignId"   , request.getParameter("CampaignId"   ));
		map.put("CELLID"       , request.getParameter("CELLID"       ));
		map.put("CHANNEL_CD"   , request.getParameter("CHANNEL_CD"   ));
		map.put("COPYCHANNEL"  , request.getParameter("COPYCHANNEL"  ));
		//ChannelBO bo = channelService.getChannelDtlInfo(map);

		//채널 목록 조회
		map.put("codeId", "C011");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> channel_list = commCodeService.getCommCodeDtlList(map);

		//우선순위
		map.put("codeId", "C006");
		List<UaextCodeDtlBO> priority_rank = commCodeService.getCommCodeDtlList(map);

		//EMAIL우선순위별발송시간
		map.put("codeId", "C027");
		List<UaextCodeDtlBO> priority_rank_sendtime = commCodeService.getCommCodeDtlList(map);

		//사용자 변수 목록을 조회
		map.put("codeId", "C013");
		List<UaextCodeDtlBO> vri_list = commCodeService.getCommCodeDtlList(map);

		// KANG-20200418: change logic
		ChannelBO tgtbo = null;
		ChannelBO bo = null;
		if (true) {
			//paramter
			log.info("=============================================");
			log.info("tgtCampaignId   : " + request.getParameter("tgtCampaignId"));
			log.info("tgtCellId       : " + request.getParameter("tgtCellId"));
			log.info("tgtChannelCd   : " + request.getParameter("tgtChannelCd"));
			log.info("=============================================");

			//채널정보 조회
			map.put("CAMPAIGNID", Common.nvl(request.getParameter("tgtCampaignId"), ""));
			map.put("CELLID", Common.nvl(request.getParameter("tgtCellId"), ""));
			map.put("CHANNEL_CD", Common.nvl(request.getParameter("tgtChannelCd"), ""));

			tgtbo = channelService.getChannelDtlInfo(map);
		}
		if (true) {
			//paramter
			log.info("=============================================");
			log.info("CampaignId   : " + request.getParameter("CampaignId"));
			log.info("CELLID       : " + request.getParameter("CELLID"));
			log.info("CHANNEL_CD   : " + request.getParameter("CHANNEL_CD"));
			log.info("=============================================");

			//채널정보 조회
			map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
			map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
			map.put("CHANNEL_CD", Common.nvl(request.getParameter("CHANNEL_CD"), ""));

			bo = channelService.getChannelDtlInfo(map);
		}

		// KANG-20200417: change values
		bo.setCampaigncode(tgtbo.getCampaigncode());
		bo.setCampaignname(tgtbo.getCampaignname());
		bo.setCampaignid(tgtbo.getCampaignid());
		bo.setCellid(tgtbo.getCellid());
		bo.setCellname(tgtbo.getCellname());
		bo.setChannel_cd(tgtbo.getChannel_cd());
		bo.setEmail_disp_dt(request.getParameter("tgtDispDt"));
		bo.setCamp_status_cd("EDIT");
		bo.setCamp_term_cd(tgtbo.getCamp_term_cd());
		bo.setEmail_disp_dt(tgtbo.getEmail_disp_dt());
		bo.setCamp_bgn_dt(tgtbo.getCamp_bgn_dt());
		bo.setCamp_end_dt(tgtbo.getCamp_end_dt());
		bo.setCreate_id(tgtbo.getCreate_id());   // KANG-20200422: create upddate
		bo.setCreate_nm(tgtbo.getCreate_nm());
		bo.setCreate_dt(tgtbo.getCreate_dt());
		bo.setUpdate_id(tgtbo.getUpdate_id());
		bo.setUpdate_nm(tgtbo.getUpdate_nm());
		bo.setUpdate_dt(tgtbo.getUpdate_dt());

		if (true) {
			// KANG-20200622: condition: bo is manual and tgt is manual and tgt is SEND02
			log.info("============ KANG-20200622(org) =============");
			log.info("bo.manual_trans_yn       : " + bo.getManual_trans_yn());
			log.info("bo.email_disp_time       : " + bo.getEmail_disp_time());
			log.info("---------------------------------------------");
			log.info("tgtbo.manual_trans_yn       : " + tgtbo.getManual_trans_yn());
			log.info("tgtbo.email_disp_time       : " + tgtbo.getEmail_disp_time());
			log.info("=============================================");
			
			if (tgtbo.getManual_trans_yn().equals("N")
					&& bo.getManual_trans_yn().equals("N")) {
				// KANG-20200622: copy
				log.info("KANG-20200622 >>>>>> because of condition_OK!!, then COPY from tgt.....");
			} else {
				// KANG-20200622: no copy, original
				bo.setManual_trans_yn(request.getParameter("MANUAL_TRANS_YN"));         // KANG-20200606: create
				bo.setEmail_disp_time(request.getParameter("DISP_TIME"));               // KANG-20200606: create
			}
		}

		if ( bo.getEmail_subject() != null ){
			bo.setEmail_subject(bo.getEmail_subject().replaceAll("\"", "&quot;"));
		}

		modelMap.addAttribute("channel_list", channel_list);
		modelMap.addAttribute("priority_rank", priority_rank);
		modelMap.addAttribute("priority_rank_sendtime", priority_rank_sendtime);
		modelMap.addAttribute("vri_list", vri_list);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("CHANNEL_CD", request.getParameter("CHANNEL_CD"));
		modelMap.addAttribute("COPYCHANNEL", request.getParameter("COPYCHANNEL"));   // KANG-20200417
		modelMap.addAttribute("DISABLED", request.getParameter("DISABLED"));

		return "channel/channelEmail";
	}

	/**
	 * 채널 EMAIL 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("setChannelEmail.do")
	public void setChannelEmail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("CAMPAIGNID           : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE         : " + request.getParameter("CAMPAIGNCODE"));
		log.info("FLOWCHARTID          : " + request.getParameter("FLOWCHARTID"));
		log.info("CELLID               : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD           : " + request.getParameter("CHANNEL_CD"));

		log.info("EMAIL_NAME           : " + request.getParameter("EMAIL_NAME"));
		log.info("EMAIL_DESC           : " + request.getParameter("EMAIL_DESC"));
		log.info("EMAIL_EDIT_YN        : " + request.getParameter("EMAIL_EDIT_YN"));
		log.info("EMAIL_SUBJECT        : " + request.getParameter("EMAIL_SUBJECT"));
		log.info("EMAIL_CONTENT        : " + request.getParameter("EMAIL_CONTENT"));
		log.info("EMAIL_FROMNAME       : " + request.getParameter("EMAIL_FROMNAME"));
		log.info("EMAIL_FROMADDRESS    : " + request.getParameter("EMAIL_FROMADDRESS"));
		log.info("EMAIL_REPLYTO        : " + request.getParameter("EMAIL_REPLYTO"));
		log.info("EMAIL_DISP_DT        : " + request.getParameter("EMAIL_DISP_DT"));
		log.info("EMAIL_PRIORITY_RNK   : " + request.getParameter("EMAIL_PRIORITY_RNK"));
		log.info("EMAIL_DISP_TIME      : " + request.getParameter("EMAIL_DISP_TIME"));
		log.info("useIndi              : " + request.getParameter("useIndi"));
		log.info("=============================================");

		//입력 값
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("FLOWCHARTID", Common.nvl(request.getParameter("FLOWCHARTID"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("CHANNEL_CD", "EMAIL"); //EMAIL

		map.put("EMAIL_NAME", Common.nvl(request.getParameter("EMAIL_NAME"), ""));
		map.put("EMAIL_DESC", Common.nvl(request.getParameter("EMAIL_DESC"), ""));
		map.put("EMAIL_EDIT_YN", Common.nvl(request.getParameter("EMAIL_EDIT_YN"), ""));
		map.put("EMAIL_SUBJECT", Common.nvl(request.getParameter("EMAIL_SUBJECT"), ""));
		map.put("EMAIL_CONTENT", Common.nvl(request.getParameter("EMAIL_CONTENT"), ""));
		map.put("EMAIL_FROMNAME", Common.nvl(request.getParameter("EMAIL_FROMNAME"), ""));
		map.put("EMAIL_FROMADDRESS", Common.nvl(request.getParameter("EMAIL_FROMADDRESS"), ""));
		map.put("EMAIL_REPLYTO", Common.nvl(request.getParameter("EMAIL_REPLYTO"), ""));
		map.put("EMAIL_DISP_DT", Common.nvl(request.getParameter("EMAIL_DISP_DT"), ""));
		map.put("EMAIL_PRIORITY_RNK", Common.nvl(request.getParameter("EMAIL_PRIORITY_RNK"), ""));
		map.put("EMAIL_DISP_TIME", Common.nvl(request.getParameter("EMAIL_DISP_TIME"), ""));
		map.put("useIndi", Common.nvl(request.getParameter("useIndi"), "N"));
		map.put("CREATE_ID", user.getId());
		map.put("UPDATE_ID", user.getId());

		//캠페인의 상태체크(START일경우에는 수정못함)
		CampaignInfoBO bo = this.campaignInfoService.getCampaignInfo(map);
		String CMP_STATUS = Common.nvl(bo.getCamp_status_cd(), "");

		if (!CMP_STATUS.equals("START")) {
			//EMAIL 정보 저장
			this.channelService.setChannelEmail(map);
		}

		//캠페인 상태 리턴
		map.put("CMP_STATUS", CMP_STATUS);

		jsonView.render(map, request, response);
	}

	@RequestMapping("/channel/_test_channelMobile.do")
	public String _test_channelMobile(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {

		return "channel/_test_channelMobile";
	}

	/**
	 * 채널 모바일 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/channelMobile.do")
	public String pageChannelMobile(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		//채널 목록 조회
		map.put("codeId", "C011");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> channel_list = commCodeService.getCommCodeDtlList(map);

		//우선순위
		map.put("codeId", "C006");
		List<UaextCodeDtlBO> priority_rank = commCodeService.getCommCodeDtlList(map);

		//MOBILE우선순위별발송시간
		map.put("codeId", "C028");
		List<UaextCodeDtlBO> priority_rank_sendtime = commCodeService.getCommCodeDtlList(map);

		//알리미타임라인노출여부
		map.put("codeId", "C024");
		List<UaextCodeDtlBO> timeline_disp_yn = commCodeService.getCommCodeDtlList(map);

		//알리미타임라인노출여부
		map.put("codeId", "C025");
		List<UaextCodeDtlBO> push_msg_popup_indc_yn = commCodeService.getCommCodeDtlList(map);

		//모바일 알리미 구분
		map.put("codeId", "C009");
		List<UaextCodeDtlBO> mobileApp_list = commCodeService.getCommCodeDtlList(map);

		//연결페이지 구분
		map.put("codeId", "G006");
		List<UaextCodeDtlBO> mobileSendPreferCd = commCodeService.getCommCodeDtlList(map);

		//사용자 변수
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));
		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("CELLID       : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD   : " + request.getParameter("CHANNEL_CD"));
		log.info("COPYCHANNEL  : " + request.getParameter("COPYCHANNEL"));   // KANG-20200417
		log.info("=============================================");

		//채널정보 조회
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("CHANNEL_CD", Common.nvl(request.getParameter("CHANNEL_CD"), ""));

		ChannelBO bo = channelService.getChannelDtlInfo(map);

		modelMap.addAttribute("channel_list", channel_list);
		modelMap.addAttribute("priority_rank", priority_rank);
		modelMap.addAttribute("priority_rank_sendtime", priority_rank_sendtime);
		modelMap.addAttribute("timeline_disp_yn", timeline_disp_yn);
		modelMap.addAttribute("push_msg_popup_indc_yn", push_msg_popup_indc_yn);
		modelMap.addAttribute("mobileApp_list", mobileApp_list);
		modelMap.addAttribute("mobileSendPreferCd", mobileSendPreferCd);

		modelMap.addAttribute("vri_list", vri_list);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("CELLID", request.getParameter("CELLID"));
		modelMap.addAttribute("CHANNEL_CD", request.getParameter("CHANNEL_CD"));
		modelMap.addAttribute("COPYCHANNEL", request.getParameter("COPYCHANNEL"));   // KANG-20200417
		modelMap.addAttribute("DISABLED", request.getParameter("DISABLED"));

		return "channel/channelMobile";
	}

	/**
	 * 채널 모바일 복사 페이지 호출   // KANG-20200415
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/copyChannelMobile.do")
	public String pageCopyChannelMobile(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		/////////////////////////////////////////
		// 채널 복사 KANG-20200415
		log.info("=============================================");
		log.info("srcCellId               : " + request.getParameter("srcCellId"));
		log.info("srcChannelCd            : " + request.getParameter("srcChannelCd"));
		log.info("tgtCampaignId           : " + request.getParameter("tgtCampaignId"));
		log.info("tgtCellId               : " + request.getParameter("tgtCellId"));
		log.info("tgtChannelCd            : " + request.getParameter("tgtChannelCd"));
		log.info("tgtDispDt               : " + request.getParameter("tgtDispDt"));
		log.info("CampaignId              : " + request.getParameter("CampaignId"));
		log.info("CELLID                  : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD              : " + request.getParameter("CHANNEL_CD"));
		log.info("COPYCHANNEL             : " + request.getParameter("COPYCHANNEL"));
		log.info("MANUAL_TRANS_YN         : " + request.getParameter("MANUAL_TRANS_YN"));   // KANG-20200606: create
		log.info("DISP_TIME               : " + request.getParameter("DISP_TIME"));         // KANG-20200606: create
		log.info("SEND_PREFER_CD          : " + request.getParameter("SEND_PREFER_CD"));    // KANG-20200606: create
		log.info("=============================================");
		map.clear();
		map.put("srcCellId"    , request.getParameter("srcCellId"    ));
		map.put("srcChannelCd" , request.getParameter("srcChannelCd" ));
		map.put("tgtCampaignId", request.getParameter("tgtCampaignId"));
		map.put("tgtCellId"    , request.getParameter("tgtCellId"    ));
		map.put("tgtChannelCd" , request.getParameter("tgtChannelCd" ));
		map.put("tgtDispDt"    , request.getParameter("tgtDispDt"    ));
		map.put("CampaignId"   , request.getParameter("CampaignId"   ));
		map.put("CELLID"       , request.getParameter("CELLID"       ));
		map.put("CHANNEL_CD"   , request.getParameter("CHANNEL_CD"   ));
		map.put("COPYCHANNEL"  , request.getParameter("COPYCHANNEL"  ));
		//ChannelBO bo = channelService.getChannelDtlInfo(map);


		//채널 목록 조회
		map.clear();
		map.put("codeId", "C011");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> channel_list = commCodeService.getCommCodeDtlList(map);

		//우선순위
		map.put("codeId", "C006");
		List<UaextCodeDtlBO> priority_rank = commCodeService.getCommCodeDtlList(map);

		//MOBILE우선순위별발송시간
		map.put("codeId", "C028");
		List<UaextCodeDtlBO> priority_rank_sendtime = commCodeService.getCommCodeDtlList(map);

		//알리미타임라인노출여부
		map.put("codeId", "C024");
		List<UaextCodeDtlBO> timeline_disp_yn = commCodeService.getCommCodeDtlList(map);

		//알리미타임라인노출여부
		map.put("codeId", "C025");
		List<UaextCodeDtlBO> push_msg_popup_indc_yn = commCodeService.getCommCodeDtlList(map);

		//모바일 알리미 구분
		map.put("codeId", "C009");
		List<UaextCodeDtlBO> mobileApp_list = commCodeService.getCommCodeDtlList(map);

		//연결페이지 구분
		map.put("codeId", "G006");
		List<UaextCodeDtlBO> mobileSendPreferCd = commCodeService.getCommCodeDtlList(map);

		//사용자 변수
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));
		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		// KANG-20200418: change logic
		ChannelBO tgtbo = null;
		ChannelBO bo = null;
		if (true) {
			//paramter
			log.info("=============================================");
			log.info("tgtCampaignId   : " + request.getParameter("tgtCampaignId"));
			log.info("tgtCellId       : " + request.getParameter("tgtCellId"));
			log.info("tgtChannelCd   : " + request.getParameter("tgtChannelCd"));
			log.info("=============================================");

			//채널정보 조회
			map.put("CAMPAIGNID", Common.nvl(request.getParameter("tgtCampaignId"), ""));
			map.put("CELLID", Common.nvl(request.getParameter("tgtCellId"), ""));
			map.put("CHANNEL_CD", Common.nvl(request.getParameter("tgtChannelCd"), ""));

			tgtbo = channelService.getChannelDtlInfo(map);
		}
		if (true) {
			//paramter
			log.info("=============================================");
			log.info("CampaignId   : " + request.getParameter("CampaignId"));
			log.info("CELLID       : " + request.getParameter("CELLID"));
			log.info("CHANNEL_CD   : " + request.getParameter("CHANNEL_CD"));
			log.info("=============================================");

			//채널정보 조회
			map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
			map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
			map.put("CHANNEL_CD", Common.nvl(request.getParameter("CHANNEL_CD"), ""));

			bo = channelService.getChannelDtlInfo(map);
		}
		
		// KANG-20200417: change values
		bo.setCampaigncode(tgtbo.getCampaigncode());
		bo.setCampaignname(tgtbo.getCampaignname());
		bo.setCampaignid(tgtbo.getCampaignid());
		bo.setCellid(tgtbo.getCellid());
		bo.setCellname(tgtbo.getCellname());
		bo.setChannel_cd(tgtbo.getChannel_cd());
		bo.setMobile_disp_dt(request.getParameter("tgtDispDt"));
		bo.setCamp_status_cd("EDIT");
		bo.setCamp_term_cd(tgtbo.getCamp_term_cd());
		bo.setMobile_disp_dt(tgtbo.getMobile_disp_dt());
		bo.setCamp_bgn_dt(tgtbo.getCamp_bgn_dt());
		bo.setCamp_end_dt(tgtbo.getCamp_end_dt());
		bo.setCreate_id(tgtbo.getCreate_id());  // KANG-20200422: create upddate
		bo.setCreate_nm(tgtbo.getCreate_nm());
		bo.setCreate_dt(tgtbo.getCreate_dt());
		bo.setUpdate_id(tgtbo.getUpdate_id());
		bo.setUpdate_nm(tgtbo.getUpdate_nm());
		bo.setUpdate_dt(tgtbo.getUpdate_dt());
		
		if (true) {
			// KANG-20200622: condition: bo is manual and tgt is manual and tgt is SEND02
			log.info("============ KANG-20200622(org) =============");
			log.info("bo.manual_trans_yn        : " + bo.getManual_trans_yn());
			log.info("bo.mobile_disp_time       : " + bo.getMobile_disp_time());
			log.info("bo.mobile_send_prefer_cd  : " + bo.getMobile_send_prefer_cd());
			log.info("---------------------------------------------");
			log.info("tgtbo.manual_trans_yn        : " + tgtbo.getManual_trans_yn());
			log.info("tgtbo.mobile_disp_time       : " + tgtbo.getMobile_disp_time());
			log.info("tgtbo.mobile_send_prefer_cd  : " + tgtbo.getMobile_send_prefer_cd());
			log.info("=============================================");
			
			if (tgtbo.getManual_trans_yn().equals("N")
					&& bo.getManual_trans_yn().equals("N")
					&& bo.getMobile_send_prefer_cd().equals("SEND02")) {
				// KANG-20200622: copy
				log.info("KANG-20200622 >>>>>> because of condition_OK!!, then COPY from tgt.....");
			} else {
				// KANG-20200622: no copy, original
				bo.setManual_trans_yn(request.getParameter("MANUAL_TRANS_YN"));         // KANG-20200606: create
				bo.setMobile_disp_time(request.getParameter("DISP_TIME"));              // KANG-20200606: create
				bo.setMobile_send_prefer_cd(request.getParameter("SEND_PREFER_CD"));    // KANG-20200606: create
			}
		}
		
		modelMap.addAttribute("channel_list", channel_list);
		modelMap.addAttribute("priority_rank", priority_rank);
		modelMap.addAttribute("priority_rank_sendtime", priority_rank_sendtime);
		modelMap.addAttribute("timeline_disp_yn", timeline_disp_yn);
		modelMap.addAttribute("push_msg_popup_indc_yn", push_msg_popup_indc_yn);
		modelMap.addAttribute("mobileApp_list", mobileApp_list);
		modelMap.addAttribute("mobileSendPreferCd", mobileSendPreferCd);

		modelMap.addAttribute("vri_list", vri_list);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("CELLID", request.getParameter("CELLID"));
		modelMap.addAttribute("CHANNEL_CD", request.getParameter("CHANNEL_CD"));
		modelMap.addAttribute("COPYCHANNEL", request.getParameter("COPYCHANNEL"));   // KANG-20200417
		modelMap.addAttribute("DISABLED", request.getParameter("DISABLED"));

		return "channel/channelMobile";
	}

	/**
	 * KANG-20190328: get
	 *
	 * 채널 MOBILE 정보 얻기
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping("getChannelMobileAlimi.do")
	public void getChannelMobileAlimi(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		String CELLID = Common.nvl(request.getParameter("cellId"), "25");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("CELLID", CELLID);

		// paramter
		log.info("=============================================");
		log.info("map       : " + map);
		log.info("=============================================");

		//if (Flag.flag) this.channelService.delChannelMobileAlimi(map);   // KANG-20190406: imsi
		ChannelAlimiBO alimi = this.channelService.getChannelMobileAlimi(map);
		if (alimi == null) {
			// if not exists, then create default data
			log.info("ChannelAlimi: NULL -> create default data..");
			UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");
			String jsonDummyAlimi = "{"
					+ "\"alimiShow\":\"N\","
					+ "\"alimiText\":\"\","
					+ "\"alimiType\":\"001\","
					+ "\"title1\":\"\","
					+ "\"advText\":\"광고\","
					+ "\"title2\":\"\","
					+ "\"title3\":\"\","
					+ "\"arrImg\":[{\"imgUrl\":\"\"}],"
					+ "\"ftrText\":\"\","
					+ "\"ftrMblUrl\":\"\","
					+ "\"ftrWebUrl\":\"\""
					+ "}";
			String jsonDummyBlock = this.getBlockContent(jsonDummyAlimi.replace("\\\"", "\""));  // alimi -> Block
			//jsonDummyBlock = "{}";
			log.info("composites: " + jsonDummyBlock);

			map.put("CELLID", CELLID);
			map.put("CAMPAIGNCODE", "");
			map.put("CAMPAIGNID", "");
			map.put("CHANNEL_CD", "MOBILE");
			map.put("MOBILE_APP_KD_CD", "");
			map.put("TALK_MSG_DISP_YN", "N");   // <- show/hide, important
			map.put("TALK_MSG_SUMMARY", "");
			map.put("TALK_MSG_TMPLT_NO", "001");
			map.put("TALK_BLCK_CONT", jsonDummyBlock.replace("\"", "\\\""));   // for inserting to oracle table
			map.put("MOBILE_SEND_PREFER_CD", "");
			map.put("MOBILE_PERSON_MSG_YN", "N");
			map.put("useIndi", "N");
			map.put("CREATE_ID", user.getId());
			map.put("UPDATE_ID", user.getId());

			// KANG-20190328: save alimi data
			if (Flag.flag) {
				this.channelService.setChannelMobileAlimi(map);   // for inserting to oracle table
			}
			alimi = this.channelService.getChannelMobileAlimi(map);  // select dummy record
		}

		// JOB
		String jsonAlimi = getJsonAlimi(alimi);    // get jsonDummyAlimi(not exist) or jsonAlimi(exist)
		jsonAlimi = jsonAlimi.replace("\\\"", "\"");
		log.info("jsonAlimi: " +  jsonAlimi);

		map.put("alimi", jsonAlimi);

		jsonView.render(map, request, response);
	}

	private String getJsonAlimi(ChannelAlimiBO alimi) {
		JsonObject objReturn = new JsonObject();        // target
		objReturn.addProperty("alimiShow", Common.nvl(alimi.getTalkMsgDispYn(), "N"));
		objReturn.addProperty("alimiText", Common.nvl(alimi.getTalkMsgSummary(), ""));
		objReturn.addProperty("alimiType", Common.nvl(alimi.getTalkMsgTmpltNo(), ""));

		JsonParser parser = new JsonParser();
		JsonArray arrRoot = parser.parse(Common.nvl(alimi.getTalkBlckCont(), "{}").replace("\\\"", "\"")).getAsJsonArray();
		for (JsonElement element : arrRoot) {
			//if (Flag.flag) System.out.println(">>>>> " + element);
			String id = element.getAsJsonObject().get("id").getAsString();
			JsonElement payload = element.getAsJsonObject().get("payload");
			switch (id) {
			case "Block_Top_Cap":
				if (Flag.flag) {
					objReturn.addProperty("title1", Common.nvl(payload.getAsJsonObject().get("text1").getAsString(), ""));
					objReturn.addProperty("advText", Common.nvl(payload.getAsJsonObject().get("sub_text1").getAsString(), ""));
				}
				break;
			case "Block_Bold_Text":
				if (Flag.flag) {
					objReturn.addProperty("title2", Common.nvl(payload.getAsJsonObject().get("text1").getAsString(), ""));
					objReturn.addProperty("title3", Common.nvl(payload.getAsJsonObject().get("sub_text1").getAsString(), ""));
				}
				break;
			case "Block_Btn_View":
				if (Flag.flag) {
					objReturn.addProperty("ftrText", Common.nvl(payload.getAsJsonObject().get("text1").getAsString(), ""));
					objReturn.addProperty("ftrMblUrl", Common.nvl(payload.getAsJsonObject().get("linkUrl1").getAsJsonObject().get("mobile").getAsString(), ""));
					objReturn.addProperty("ftrWebUrl", Common.nvl(payload.getAsJsonObject().get("linkUrl1").getAsJsonObject().get("web").getAsString(), ""));
				}
				break;
			case "Block_Img_500":
				if (Flag.flag) {
					JsonArray subArr = new JsonArray();
					for (JsonElement subElement : payload.getAsJsonArray()) {
						JsonObject subObj = new JsonObject();
						subObj.addProperty("imgUrl", Common.nvl(subElement.getAsJsonObject().get("imgUrl1").getAsString(), ""));
						subArr.add(subObj);
					}
					objReturn.add("arrImg", subArr);
				}
				break;
			case "Block_Img_240":
				if (Flag.flag) {
					JsonArray subArr = new JsonArray();
					JsonObject subObj = new JsonObject();
					subObj.addProperty("imgUrl", payload.getAsJsonObject().get("imgUrl1").getAsString());
					subArr.add(subObj);
					objReturn.add("arrImg", subArr);
				}
				break;
			case "Block_Product_Price":
				if (Flag.flag) {
					JsonArray subArr = new JsonArray();
					for (JsonElement subElement : payload.getAsJsonArray()) {
						JsonObject subObj = new JsonObject();
						subObj.addProperty("prdUrl", subElement.getAsJsonObject().get("imgUrl1").getAsString());
						subObj.addProperty("prdName", subElement.getAsJsonObject().get("text1").getAsString());
						subObj.addProperty("prdPrice", subElement.getAsJsonObject().get("price1").getAsString());
						subObj.addProperty("prdUnit", subElement.getAsJsonObject().get("priceUnit1").getAsString());
						subObj.addProperty("prdMblUrl", subElement.getAsJsonObject().get("linkUrl1").getAsJsonObject().get("mobile").getAsString());
						subObj.addProperty("prdWebUrl", subElement.getAsJsonObject().get("linkUrl1").getAsJsonObject().get("web").getAsString());
						subArr.add(subObj);
					}
					objReturn.add("arrPrd", subArr);
				}
				break;
			case "Block_Coupon_Text":
				if (Flag.flag) {
					JsonArray subArr = new JsonArray();
					for (JsonElement subElement : payload.getAsJsonArray()) {
						JsonObject subObj = new JsonObject();
						subObj.addProperty("cpnNumber", subElement.getAsJsonObject().get("couponNo").getAsString());
						subObj.addProperty("cpnText1", subElement.getAsJsonObject().get("couponText").getAsString());
						subObj.addProperty("cpnText2", subElement.getAsJsonObject().get("title1").getAsString());
						subObj.addProperty("cpnText3", subElement.getAsJsonObject().get("sub_text1").getAsString());
						subObj.addProperty("cpnText4", subElement.getAsJsonObject().get("sub_text2").getAsString());
						subObj.addProperty("cpnVisible", subElement.getAsJsonObject().get("isDisplayBtn").getAsBoolean() ? "show" : "hide");
						subArr.add(subObj);
					}
					objReturn.add("arrCpn", subArr);
				}
				break;
			case "Block_Sub_Text":
				if (Flag.flag) {
					JsonArray subArr = new JsonArray();
					JsonObject subObj = new JsonObject();
					subObj.addProperty("annText", payload.getAsJsonObject().get("text1").getAsString());
					subObj.addProperty("annFixed", payload.getAsJsonObject().get("align").getAsString());
					subArr.add(subObj);
					objReturn.add("arrAnn", subArr);
				}
				break;
			default:
				if (Flag.flag) System.out.println(">>>>> switch(id) has a default value.... id=" + id);
				break;
			}
		}
		return objReturn.toString();
	}

	/**
	 * KANG-20190328: set
	 *
	 * 채널 MOBILE 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("setChannelMobile.do")
	public void setChannelMobile(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("CAMPAIGNID              : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE            : " + request.getParameter("CAMPAIGNCODE"));
		log.info("FLOWCHARTID             : " + request.getParameter("FLOWCHARTID"));
		log.info("CELLID                  : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD              : " + request.getParameter("CHANNEL_CD"));

		log.info("MOBILE_APP_KD_CD        : " + request.getParameter("MOBILE_APP_KD_CD"));
		log.info("MOBILE_DISP_TITLE       : " + request.getParameter("MOBILE_DISP_TITLE"));
		log.info("MOBILE_CONTENT          : " + request.getParameter("MOBILE_CONTENT"));
		log.info("MOBILE_ADD_TEXT         : " + request.getParameter("MOBILE_ADD_TEXT"));
		log.info("MOBILE_DISP_DT          : " + request.getParameter("MOBILE_DISP_DT"));
		log.info("MOBILE_PRIORITY_RNK     : " + request.getParameter("MOBILE_PRIORITY_RNK"));
		log.info("MOBILE_DISP_TIME        : " + request.getParameter("MOBILE_DISP_TIME"));
		log.info("TIMELINE_DISP_YN        : " + request.getParameter("TIMELINE_DISP_YN"));
		log.info("PUSH_MSG_POPUP_INDC_YN  : " + request.getParameter("PUSH_MSG_POPUP_INDC_YN"));
		log.info("THUM_IMG_URL            : " + request.getParameter("THUM_IMG_URL"));
		log.info("BNNR_IMG_URL            : " + request.getParameter("BNNR_IMG_URL"));
		log.info("BNNR_STR_IMG_URL        : " + request.getParameter("BNNR_STR_IMG_URL"));  // KANG-20200508
		log.info("useIndi                 : " + request.getParameter("useIndi"));
		log.info("MOBILE_SEND_PREFER_CD   : " + request.getParameter("MOBILE_SEND_PREFER_CD"));

		log.info("ALIMI_PARAMS            : " + request.getParameter("ALIMI_PARAMS"));
		log.info("=============================================");

		if (Flag.flag) {
			// 알리미
			String json = request.getParameter("ALIMI_PARAMS");
			JsonNode root = this.objectMapper.readTree(json);
			map.put("TALK_MSG_DISP_YN", root.path("alimiShow").asText());
			map.put("TALK_MSG_SUMMARY", root.path("alimiText").asText());
			map.put("TALK_MSG_TMPLT_NO", root.path("alimiType").asText());

			String jsonBlckCont = this.getBlockContent(json);
			//map.put("JSON_CONTENT", jsonBlckCont);
			map.put("TALK_BLCK_CONT", jsonBlckCont.replace("\"", "\\\"").replace("'", "\\'"));
		}

		//입력 값
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("FLOWCHARTID", Common.nvl(request.getParameter("FLOWCHARTID"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("CHANNEL_CD", "MOBILE"); //MOBILE

		map.put("MOBILE_APP_KD_CD", Common.nvl(request.getParameter("MOBILE_APP_KD_CD"), ""));
		map.put("MOBILE_DISP_TITLE", Common.nvl(request.getParameter("MOBILE_DISP_TITLE"), ""));
		map.put("MOBILE_CONTENT", Common.nvl(request.getParameter("MOBILE_CONTENT"), ""));
		map.put("MOBILE_ADD_TEXT", Common.nvl(request.getParameter("MOBILE_ADD_TEXT"), ""));
		map.put("MOBILE_DISP_DT", Common.nvl(request.getParameter("MOBILE_DISP_DT"), ""));
		map.put("MOBILE_PRIORITY_RNK", Common.nvl(request.getParameter("MOBILE_PRIORITY_RNK"), ""));
		map.put("MOBILE_DISP_TIME", Common.nvl(request.getParameter("MOBILE_DISP_TIME"), ""));
		map.put("TIMELINE_DISP_YN", Common.nvl(request.getParameter("TIMELINE_DISP_YN"), ""));
		map.put("PUSH_MSG_POPUP_INDC_YN", Common.nvl(request.getParameter("PUSH_MSG_POPUP_INDC_YN"), ""));
		map.put("THUM_IMG_URL", Common.nvl(request.getParameter("THUM_IMG_URL"), ""));
		map.put("BNNR_IMG_URL", Common.nvl(request.getParameter("BNNR_IMG_URL"), ""));
		map.put("BNNR_STR_IMG_URL", Common.nvl(request.getParameter("BNNR_STR_IMG_URL"), ""));

		map.put("MOBILE_LNK_PAGE_TYP", Common.nvl(request.getParameter("MOBILE_LNK_PAGE_TYP"), ""));
		map.put("MOBILE_LNK_PAGE_URL", Common.nvl(request.getParameter("MOBILE_LNK_PAGE_URL"), ""));

		map.put("useIndi", Common.nvl(request.getParameter("useIndi"), "N"));
		map.put("MOBILE_SEND_PREFER_CD", Common.nvl(request.getParameter("MOBILE_SEND_PREFER_CD"), ""));

		map.put("CREATE_ID", user.getId());
		map.put("UPDATE_ID", user.getId());

		//캠페인의 상태체크(START일경우에는 수정못함)
		CampaignInfoBO bo = this.campaignInfoService.getCampaignInfo(map);
		String CMP_STATUS = Common.nvl(bo.getCamp_status_cd(), "");

		if (Flag.flag) {
			// add this.channelService.setChannelMobileAlimi
			if (!CMP_STATUS.equals("START")) {
				//모바일 정보 저장
				this.channelService.setChannelMobile(map);

				// KANG-20190328: save alimi data
				if (Flag.flag) {

					// data covert from pc to block
					// this.channelService.setChannelMobileAlimi(map);
					ChannelAlimiBO alimi = this.channelService.getChannelMobileAlimi(map);
					if (alimi == null) {
						this.channelService.insertChannelMobileAlimi(map);
					} else {
						this.channelService.updateChannelMobileAlimi(map);
					}
				}
			}
		}

		if (!Flag.flag) {
			// TODO KANG-20190416: test for CLOB
			String cellId = (String) map.get("CELLID");  // CELLID
			String channelCd = (String) map.get("CHANNEL_CD"); // CHANNEL_CD
			String talkBlckCont = (String) map.get("TALK_BLCK_CONT"); // TALK_BLCK_CONT

			StringBuffer sb = new StringBuffer();
			for (int i=0; i < 70000; i++) {
				sb.append("1234567890");
			}

			map.put("CELLID", "1004");
			map.put("CHANNEL_CD", "MOBILE");
			map.put("TALK_BLCK_CONT", sb.toString());

			ChannelAlimiBO alimi = this.channelService.getChannelMobileAlimi(map);
			if (alimi == null) {
				this.channelService.insertChannelMobileAlimi(map);
			} else {
				this.channelService.updateChannelMobileAlimi(map);
			}

			// restore
			map.put("CELLID", cellId);
			map.put("CHANNEL_CD", channelCd);
			map.put("TALK_BLCK_CONT", talkBlckCont);
		}

		//캠페인 상태 리턴
		map.put("CMP_STATUS", CMP_STATUS);

		this.jsonView.render(map, request, response);
	}

	/**
	 * KANG-20200406: set
	 *
	 * 채널 MOBILE 정보 강제저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("setChannelMobileForce.do")
	public void setChannelMobileForce(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("CAMPAIGNID              : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE            : " + request.getParameter("CAMPAIGNCODE"));
		log.info("FLOWCHARTID             : " + request.getParameter("FLOWCHARTID"));
		log.info("CELLID                  : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD              : " + request.getParameter("CHANNEL_CD"));

		log.info("MOBILE_APP_KD_CD        : " + request.getParameter("MOBILE_APP_KD_CD"));
		log.info("MOBILE_DISP_TITLE       : " + request.getParameter("MOBILE_DISP_TITLE"));
		log.info("MOBILE_CONTENT          : " + request.getParameter("MOBILE_CONTENT"));
		log.info("MOBILE_ADD_TEXT         : " + request.getParameter("MOBILE_ADD_TEXT"));
		log.info("MOBILE_DISP_DT          : " + request.getParameter("MOBILE_DISP_DT"));
		log.info("MOBILE_PRIORITY_RNK     : " + request.getParameter("MOBILE_PRIORITY_RNK"));
		log.info("MOBILE_DISP_TIME        : " + request.getParameter("MOBILE_DISP_TIME"));
		log.info("TIMELINE_DISP_YN        : " + request.getParameter("TIMELINE_DISP_YN"));
		log.info("PUSH_MSG_POPUP_INDC_YN  : " + request.getParameter("PUSH_MSG_POPUP_INDC_YN"));
		log.info("THUM_IMG_URL            : " + request.getParameter("THUM_IMG_URL"));
		log.info("BNNR_IMG_URL            : " + request.getParameter("BNNR_IMG_URL"));
		log.info("useIndi                 : " + request.getParameter("useIndi"));
		log.info("MOBILE_SEND_PREFER_CD   : " + request.getParameter("MOBILE_SEND_PREFER_CD"));

		log.info("ALIMI_PARAMS            : " + request.getParameter("ALIMI_PARAMS"));
		log.info("=============================================");

		if (Flag.flag) {
			// 알리미
			String json = request.getParameter("ALIMI_PARAMS");
			JsonNode root = this.objectMapper.readTree(json);
			map.put("TALK_MSG_DISP_YN", root.path("alimiShow").asText());
			map.put("TALK_MSG_SUMMARY", root.path("alimiText").asText());
			map.put("TALK_MSG_TMPLT_NO", root.path("alimiType").asText());

			String jsonBlckCont = this.getBlockContent(json);
			//map.put("JSON_CONTENT", jsonBlckCont);
			map.put("TALK_BLCK_CONT", jsonBlckCont.replace("\"", "\\\"").replace("'", "\\'"));
		}

		//입력 값
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("FLOWCHARTID", Common.nvl(request.getParameter("FLOWCHARTID"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("CHANNEL_CD", "MOBILE"); //MOBILE

		map.put("MOBILE_APP_KD_CD", Common.nvl(request.getParameter("MOBILE_APP_KD_CD"), ""));
		map.put("MOBILE_DISP_TITLE", Common.nvl(request.getParameter("MOBILE_DISP_TITLE"), ""));
		map.put("MOBILE_CONTENT", Common.nvl(request.getParameter("MOBILE_CONTENT"), ""));
		map.put("MOBILE_ADD_TEXT", Common.nvl(request.getParameter("MOBILE_ADD_TEXT"), ""));
		map.put("MOBILE_DISP_DT", Common.nvl(request.getParameter("MOBILE_DISP_DT"), ""));
		map.put("MOBILE_PRIORITY_RNK", Common.nvl(request.getParameter("MOBILE_PRIORITY_RNK"), ""));
		map.put("MOBILE_DISP_TIME", Common.nvl(request.getParameter("MOBILE_DISP_TIME"), ""));
		map.put("TIMELINE_DISP_YN", Common.nvl(request.getParameter("TIMELINE_DISP_YN"), ""));
		map.put("PUSH_MSG_POPUP_INDC_YN", Common.nvl(request.getParameter("PUSH_MSG_POPUP_INDC_YN"), ""));
		map.put("THUM_IMG_URL", Common.nvl(request.getParameter("THUM_IMG_URL"), ""));
		map.put("BNNR_IMG_URL", Common.nvl(request.getParameter("BNNR_IMG_URL"), ""));

		map.put("MOBILE_LNK_PAGE_TYP", Common.nvl(request.getParameter("MOBILE_LNK_PAGE_TYP"), ""));
		map.put("MOBILE_LNK_PAGE_URL", Common.nvl(request.getParameter("MOBILE_LNK_PAGE_URL"), ""));

		map.put("useIndi", Common.nvl(request.getParameter("useIndi"), "N"));
		map.put("MOBILE_SEND_PREFER_CD", Common.nvl(request.getParameter("MOBILE_SEND_PREFER_CD"), ""));

		map.put("CREATE_ID", user.getId());
		map.put("UPDATE_ID", user.getId());

		//캠페인의 상태체크(START일경우에는 수정못함)
		CampaignInfoBO bo = this.campaignInfoService.getCampaignInfo(map);
		String CMP_STATUS = Common.nvl(bo.getCamp_status_cd(), "");

		if (Flag.flag) {
			// add this.channelService.setChannelMobileAlimi
			if (!CMP_STATUS.equals("START") || true) { // save force
				//모바일 정보 저장
				this.channelService.setChannelMobile(map);

				// KANG-20190328: save alimi data
				if (Flag.flag) {

					// data covert from pc to block
					// this.channelService.setChannelMobileAlimi(map);
					ChannelAlimiBO alimi = this.channelService.getChannelMobileAlimi(map);
					if (alimi == null) {
						this.channelService.insertChannelMobileAlimi(map);
					} else {
						this.channelService.updateChannelMobileAlimi(map);
					}
				}
			}
		}

		if (!Flag.flag) {
			// TODO KANG-20190416: test for CLOB
			String cellId = (String) map.get("CELLID");  // CELLID
			String channelCd = (String) map.get("CHANNEL_CD"); // CHANNEL_CD
			String talkBlckCont = (String) map.get("TALK_BLCK_CONT"); // TALK_BLCK_CONT

			StringBuffer sb = new StringBuffer();
			for (int i=0; i < 70000; i++) {
				sb.append("1234567890");
			}

			map.put("CELLID", "1004");
			map.put("CHANNEL_CD", "MOBILE");
			map.put("TALK_BLCK_CONT", sb.toString());

			ChannelAlimiBO alimi = this.channelService.getChannelMobileAlimi(map);
			if (alimi == null) {
				this.channelService.insertChannelMobileAlimi(map);
			} else {
				this.channelService.updateChannelMobileAlimi(map);
			}

			// restore
			map.put("CELLID", cellId);
			map.put("CHANNEL_CD", channelCd);
			map.put("TALK_BLCK_CONT", talkBlckCont);
		}

		//캠페인 상태 리턴
		map.put("CMP_STATUS", CMP_STATUS);

		this.jsonView.render(map, request, response);
	}


	//private static boolean flag = true;
	private Gson gson = new Gson();

	@SuppressWarnings("unchecked")
	private String getBlockContent(String json) {
		String ret = "";
		String jsonParams = null;
		Map<String, Object> mapParams = null;
		List<Block> composites = null;

		if (Flag.flag) {
			switch("000") {
			case "001":  // Type-1
				jsonParams = "{\"alimiShow\":\"Y\",\"alimiText\":\"Sample Alimi Type-1\",\"alimiType\":\"001\","
						+ "\"title1\":\"패션워크\",\"advText\":\"광고\",\"title2\":\"반값 타임딜 하루 1번 오픈\",\"title3\":\"놓치지마세요!\","
						+ "\"ftrText\":\"상세보기(44)\",\"ftrMblUrl\":\"http://m.11st.co.kr/MW/MyPage/V1/benefitCouponDownList.tmall\",\"ftrWebUrl\":\"http://11st.co.kr\","
						+ "\"arrImg\":["
						+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample1.png\"},"
						+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample2.png\"},"
						+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample1.png\"},"
						+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample2.png\"},"
						+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample1.png\"}"
						+ "]}";
				break;
			case "002":  // Type-2
				jsonParams = "{\"alimiShow\":\"N\",\"alimiText\":\"Sample Alimi Type-2\",\"alimiType\":\"002\","
						+ "\"title1\":\"패션워크\",\"advText\":\"광고\",\"title2\":\"반값 타임딜 하루 4번 오픈\",\"title3\":\"놓치지마세요!\","
						+ "\"ftrText\":\"상세보기(1)\",\"ftrMblUrl\":\"http://m.11st.co.kr/MW/MyPage/V1/benefitCouponDownList.tmall\",\"ftrWebUrl\":\"http://11st.co.kr\","
						+ "\"arrImg\":["
						+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_240_sample1.png\"}"
						+ "],"
						+ "\"arrPrd\":["
						+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_small1.jpg\",\"prdName\":\"임시상품-1\",\"prdPrice\":\"10,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
						+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_small2.jpg\",\"prdName\":\"임시상품-2\",\"prdPrice\":\"20,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
						+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_small3.jpg\",\"prdName\":\"임시상품-3\",\"prdPrice\":\"30,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"}"
						+ "]}";
				break;
			case "003":  // Type-3
				jsonParams = "{\"alimiShow\":\"N\",\"alimiText\":\"Sample Alimi Type-3\",\"alimiType\":\"003\","
						+ "\"title1\":\"패션워크\",\"advText\":\"광고\",\"title2\":\"반값 타임딜 하루 4번 오픈\",\"title3\":\"놓치지마세요!\","
						+ "\"ftrText\":\"상세보기(1)\",\"ftrMblUrl\":\"http://m.11st.co.kr/MW/MyPage/V1/benefitCouponDownList.tmall\",\"ftrWebUrl\":\"http://11st.co.kr\","
						+ "\"arrImg\":["
						+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_240_sample1.png\"}"
						+ "],"
						+ "\"arrCpn\":["
						+ "{\"cpnText1\":\"30%, 2,500(1)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567891\",\"cpnVisible\":\"show\"},"
						+ "{\"cpnText1\":\"30%, 2,500(2)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567892\",\"cpnVisible\":\"hide\"},"
						+ "{\"cpnText1\":\"30%, 2,500(3)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567893\",\"cpnVisible\":\"show\"},"
						+ "{\"cpnText1\":\"30%, 2,500(4)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567894\",\"cpnVisible\":\"hide\"},"
						+ "{\"cpnText1\":\"30%, 2,500(5)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567895\",\"cpnVisible\":\"show\"},"
						+ "{\"cpnText1\":\"30%, 2,500(6)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567896\",\"cpnVisible\":\"hide\"}"
						+ "]}";
				break;
			case "004":  // Type-4
				jsonParams = "{\"alimiShow\":\"N\",\"alimiText\":\"Sample Alimi Type-4\",\"alimiType\":\"004\","
						+ "\"title1\":\"패션워크\",\"advText\":\"광고\",\"title2\":\"반값 타임딜 하루 4번 오픈\",\"title3\":\"놓치지마세요!\","
						+ "\"ftrText\":\"상세보기(1)\",\"ftrMblUrl\":\"http://m.11st.co.kr/MW/MyPage/V1/benefitCouponDownList.tmall\",\"ftrWebUrl\":\"http://11st.co.kr\","
						+ "\"arrAnn\":["
						+ "{\"annText\":\"직영몰 상품의 주문량이 많아 배송이 늦어질 수 있습니다.\",\"annFixed\":\"center\"}"
						+ "]}";
				break;
			case "005":  // Type-5
				jsonParams = "{\"alimiShow\":\"N\",\"alimiText\":\"Sample Alimi Type-5\",\"alimiType\":\"005\","
						+ "\"title1\":\"패션워크\",\"advText\":\"광고\",\"title2\":\"반값 타임딜 하루 4번 오픈\",\"title3\":\"놓치지마세요!\","
						+ "\"ftrText\":\"상세보기(1)\",\"ftrMblUrl\":\"http://m.11st.co.kr/MW/MyPage/V1/benefitCouponDownList.tmall\",\"ftrWebUrl\":\"http://11st.co.kr\","
						+ "\"arrPrd\":["
						+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_big1.jpg\",\"prdName\":\"임시상품-1\",\"prdPrice\":\"10,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
						+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_big2.jpg\",\"prdName\":\"임시상품-2\",\"prdPrice\":\"20,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
						+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_big3.jpg\",\"prdName\":\"임시상품-3\",\"prdPrice\":\"30,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
						+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_big1.jpg\",\"prdName\":\"임시상품-4\",\"prdPrice\":\"40,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
						+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_big2.jpg\",\"prdName\":\"임시상품-5\",\"prdPrice\":\"50,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
						+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_big3.jpg\",\"prdName\":\"임시상품-6\",\"prdPrice\":\"60,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"}"
						+ "]}";
				break;
			case "006":  // Type-6
				jsonParams = "{\"alimiShow\":\"N\",\"alimiText\":\"Sample Alimi Type-6\",\"alimiType\":\"006\","
						+ "\"title1\":\"패션워크\",\"advText\":\"광고\",\"title2\":\"반값 타임딜 하루 4번 오픈\",\"title3\":\"놓치지마세요!\","
						+ "\"ftrText\":\"상세보기(1)\",\"ftrMblUrl\":\"http://m.11st.co.kr/MW/MyPage/V1/benefitCouponDownList.tmall\",\"ftrWebUrl\":\"http://11st.co.kr\","
						+ "\"arrCpn\":["
						+ "{\"cpnText1\":\"30%, 2,500(1)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567891\",\"cpnVisible\":\"show\"},"
						+ "{\"cpnText1\":\"30%, 2,500(2)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567892\",\"cpnVisible\":\"hide\"},"
						+ "{\"cpnText1\":\"30%, 2,500(3)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567893\",\"cpnVisible\":\"show\"},"
						+ "{\"cpnText1\":\"30%, 2,500(4)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567894\",\"cpnVisible\":\"hide\"},"
						+ "{\"cpnText1\":\"30%, 2,500(5)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567895\",\"cpnVisible\":\"show\"},"
						+ "{\"cpnText1\":\"30%, 2,500(6)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567896\",\"cpnVisible\":\"hide\"}"
						+ "]}";
				break;
			default:
				jsonParams = json;
				break;
			}
		}

		if (Flag.flag) {
			mapParams = this.gson.fromJson(jsonParams, new TypeToken<Map<String, Object>>(){}.getType());
			if (Flag.flag) {
				System.out.println("----- mapParams main -----");
				System.out.println("alimiShow: " + mapParams.get("alimiShow"));
				System.out.println("alimiText: " + mapParams.get("alimiText"));
				System.out.println("alimiType: " + mapParams.get("alimiType"));
				System.out.println("jsonParams(=json): " + jsonParams);
			}
		}

		if (Flag.flag) {
			switch((String) mapParams.get("alimiType")) {
			case "001":  // Type-1
				if (Flag.flag) {
					List<BlockImg500.Value> listImg = new ArrayList<>();
					for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrImg")) {
						listImg.add(new BlockImg500.Value((String) map.get("imgUrl")));
					}
					composites = Lists.newArrayList(
							new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
							, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2"), (String) mapParams.get("title3")))
							, new BlockImg500(listImg)
							, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
					);
				}
				break;
			case "002":  // Type-2
				if (Flag.flag) {
					Map<String, Object> mapImg = ((List<Map<String, Object>>) mapParams.get("arrImg")).get(0);
					List<BlockProductPrice.Value> listProduct = new ArrayList<>();
					for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrPrd")) {
						listProduct.add(new BlockProductPrice.Value(
								(String) map.get("prdUrl"),
								(String) map.get("prdName"),
								(String) map.get("prdPrice"),
								(String) map.get("prdUnit"),
								new BlockLinkUrl((String) map.get("prdMblUrl"), (String) map.get("prdWebUrl"))
								));
					}
					composites = Lists.newArrayList(
							new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
							, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2"), (String) mapParams.get("title3")))
							, new BlockImg240(new BlockImg240.Value((String)mapImg.get("imgUrl")))
							, new BlockProductPrice(listProduct)
							, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
					);
				}
				break;
			case "003":  // Type-3
				if (Flag.flag) {
					Map<String, Object> mapImg = ((List<Map<String, Object>>) mapParams.get("arrImg")).get(0);
					List<BlockCouponText.Value> listCoupon = new ArrayList<>();
					for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrCpn")) {
						listCoupon.add(new BlockCouponText.Value(
								/* couponNo, couponText, title1, sub_text1, sub_text2, true */
								(String) map.get("cpnNumber"),
								(String) map.get("cpnText1"),
								(String) map.get("cpnText2"),
								(String) map.get("cpnText3"),
								(String) map.get("cpnText4"),
								"show".equals((String) map.get("cpnVisible")) ? true : false
								));
					}
					composites = Lists.newArrayList(
							new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
							, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2"), (String) mapParams.get("title3")))
							, new BlockImg240(new BlockImg240.Value((String) mapImg.get("imgUrl")))
							, new BlockCouponText(listCoupon)
							, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
					);
				}
				break;
			case "004":  // Type-4
				if (Flag.flag) {
					Map<String, Object> mapAnn = ((List<Map<String, Object>>) mapParams.get("arrAnn")).get(0);
					composites = Lists.newArrayList(
							new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
							, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2"), (String) mapParams.get("title3")))
							, new BlockSubText(new BlockSubText.Value((String)mapAnn.get("annText"), BlockSubTextAlignType.CENTER))
							, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
					);
				}
				break;
			case "005":  // Type-5
				if (Flag.flag) {
					List<BlockProductPrice.Value> listProduct = new ArrayList<>();
					for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrPrd")) {
						listProduct.add(new BlockProductPrice.Value(
								(String) map.get("prdUrl"),
								(String) map.get("prdName"),
								(String) map.get("prdPrice"),
								(String) map.get("prdUnit"),
								new BlockLinkUrl((String) map.get("prdMblUrl"), (String) map.get("prdWebUrl"))
								));
					}
					composites = Lists.newArrayList(
							new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
							, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2"), (String) mapParams.get("title3")))
							, new BlockProductPrice(listProduct)
							, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
					);
				}
				break;
			case "006":  // Type-6
				if (Flag.flag) {
					List<BlockCouponText.Value> listCoupon = new ArrayList<>();
					for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrCpn")) {
						listCoupon.add(new BlockCouponText.Value(
								/* couponNo, couponText, title1, sub_text1, sub_text2, true */
								(String) map.get("cpnNumber"),
								(String) map.get("cpnText1"),
								(String) map.get("cpnText2"),
								(String) map.get("cpnText3"),
								(String) map.get("cpnText4"),
								"show".equals((String) map.get("cpnVisible")) ? true : false
								));
					}
					composites = Lists.newArrayList(
							new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
							, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2"), (String) mapParams.get("title3")))
							, new BlockCouponText(listCoupon)
							, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
					);
				}
				break;
			default:
				composites = Lists.newArrayList();
				break;
			}

			if (Flag.flag) {
				ret = new GsonBuilder().setPrettyPrinting().create().toJson(composites);
				System.out.println("----- composites main -----");
				// System.out.println(">>>>> composites: " + composites);
				System.out.println(">>>>> ret: " + ret);
			}
		}

		return ret;
	}

	/**
	 * 채널 Toast배너 링크URL 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("channelToastLinkUrl.do")
	public void pageChannelToastLinkUrl(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//linkUrl
		map.put("codeId", "C021"); //PCID 일때의 LinkUrl
		map.put("TOAST_EVNT_TYP_CD", Common.nvl(request.getParameter("TOAST_EVNT_TYP_CD"), ""));
		String linkUrl = Common.nvl(channelService.getChannelToastLinkUrl(map), "");

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("CELLID       : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD   : " + request.getParameter("CHANNEL_CD"));
		log.info("TOAST_EVNT_TYP_CD   : " + request.getParameter("TOAST_EVNT_TYP_CD"));
		log.info("=============================================");

		map.put("TOAST_LINK_URL", linkUrl);

		jsonView.render(map, request, response);
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
	@RequestMapping("/delChannelInfo.do")
	public void delChannelInfo(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		log.info("=============================================");
		log.info("CELLID               : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD           : " + request.getParameter("CHANNEL_CD"));
		log.info("=============================================");

		//
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("CHANNEL_CD", Common.nvl(request.getParameter("CHANNEL_CD"), ""));

		channelService.delChannelInfo(map);

		jsonView.render(map, request, response);
	}

	/**
	 * 채널 LMS 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/channelLms.do")
	public String pageChannelLms(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		//채널 목록 조회
		map.put("codeId", "C011");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> channel_list = commCodeService.getCommCodeDtlList(map);

		//우선순위
		map.put("codeId", "C006");
		List<UaextCodeDtlBO> priority_rank = commCodeService.getCommCodeDtlList(map);

		//SMS우선순위별발송시간
		map.put("codeId", "C026");
		List<UaextCodeDtlBO> priority_rank_sendtime = commCodeService.getCommCodeDtlList(map);

		//완료시 전달번호
		map.put("codeId", "C012");
		List<UaextCodeDtlBO> comp_list = commCodeService.getCommCodeDtlList(map);

		//CALLBACK 번호
		map.put("codeId", "C023");
		List<UaextCodeDtlBO> callback_list = commCodeService.getCommCodeDtlList(map);

		//사용자 변수
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));
		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("CELLID       : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD   : " + request.getParameter("CHANNEL_CD"));
		log.info("COPYCHANNEL  : " + request.getParameter("COPYCHANNEL"));   // KANG-20200417
		log.info("=============================================");

		//채널정보 조회
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("CHANNEL_CD", Common.nvl(request.getParameter("CHANNEL_CD"), ""));

		ChannelBO bo = channelService.getChannelDtlInfo(map);

		modelMap.addAttribute("channel_list", channel_list);
		modelMap.addAttribute("priority_rank", priority_rank);
		modelMap.addAttribute("priority_rank_sendtime", priority_rank_sendtime);
		//modelMap.addAttribute("campScheduleTime", Common.campScheduleTime);

		modelMap.addAttribute("vri_list", vri_list);
		modelMap.addAttribute("comp_list", comp_list);
		modelMap.addAttribute("callback_list", callback_list);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("CHANNEL_CD", request.getParameter("CHANNEL_CD"));
		modelMap.addAttribute("COPYCHANNEL", request.getParameter("COPYCHANNEL"));   // KANG-20200417
		modelMap.addAttribute("DISABLED", request.getParameter("DISABLED"));

		return "channel/channelLms";
	}

	/**
	 * 채널 LMS 페이지 호출    // KANG-20200417
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/copyChannelLms.do")
	public String pageCopyChannelLms(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//사용자 정보
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		/////////////////////////////////////////
		// 채널 복사 KANG-20200415
		log.info("=============================================");
		log.info("srcCellId     : " + request.getParameter("srcCellId"));
		log.info("srcChannelCd  : " + request.getParameter("srcChannelCd"));
		log.info("tgtCampaignId : " + request.getParameter("tgtCampaignId"));
		log.info("tgtCellId     : " + request.getParameter("tgtCellId"));
		log.info("tgtChannelCd  : " + request.getParameter("tgtChannelCd"));
		log.info("tgtDispDt     : " + request.getParameter("tgtDispDt"));
		log.info("CampaignId    : " + request.getParameter("CampaignId"));
		log.info("CELLID        : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD    : " + request.getParameter("CHANNEL_CD"));
		log.info("COPYCHANNEL   : " + request.getParameter("COPYCHANNEL"));
		log.info("MANUAL_TRANS_YN  : " + request.getParameter("MANUAL_TRANS_YN"));   // KANG-20200606: create
		log.info("DISP_TIME        : " + request.getParameter("DISP_TIME"));         // KANG-20200606: create
		log.info("SEND_PREFER_CD   : " + request.getParameter("SEND_PREFER_CD"));    // KANG-20200606: create
		log.info("=============================================");
		map.clear();
		map.put("srcCellId"    , request.getParameter("srcCellId"    ));
		map.put("srcChannelCd" , request.getParameter("srcChannelCd" ));
		map.put("tgtCampaignId", request.getParameter("tgtCampaignId"));
		map.put("tgtCellId"    , request.getParameter("tgtCellId"    ));
		map.put("tgtChannelCd" , request.getParameter("tgtChannelCd" ));
		map.put("tgtDispDt"    , request.getParameter("tgtDispDt"    ));
		map.put("CampaignId"   , request.getParameter("CampaignId"   ));
		map.put("CELLID"       , request.getParameter("CELLID"       ));
		map.put("CHANNEL_CD"   , request.getParameter("CHANNEL_CD"   ));
		map.put("COPYCHANNEL"  , request.getParameter("COPYCHANNEL"  ));
		//ChannelBO bo = channelService.getChannelDtlInfo(map);

		//채널 목록 조회
		map.put("codeId", "C011");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> channel_list = commCodeService.getCommCodeDtlList(map);

		//우선순위
		map.put("codeId", "C006");
		List<UaextCodeDtlBO> priority_rank = commCodeService.getCommCodeDtlList(map);

		//SMS우선순위별발송시간
		map.put("codeId", "C026");
		List<UaextCodeDtlBO> priority_rank_sendtime = commCodeService.getCommCodeDtlList(map);

		//완료시 전달번호
		map.put("codeId", "C012");
		List<UaextCodeDtlBO> comp_list = commCodeService.getCommCodeDtlList(map);

		//CALLBACK 번호
		map.put("codeId", "C023");
		List<UaextCodeDtlBO> callback_list = commCodeService.getCommCodeDtlList(map);

		//사용자 변수
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));
		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		// KANG-20200418: change logic
		ChannelBO tgtbo = null;
		ChannelBO bo = null;
		if (true) {
			//paramter
			log.info("=============================================");
			log.info("tgtCampaignId   : " + request.getParameter("tgtCampaignId"));
			log.info("tgtCellId       : " + request.getParameter("tgtCellId"));
			log.info("tgtChannelCd   : " + request.getParameter("tgtChannelCd"));
			log.info("=============================================");

			//채널정보 조회
			map.put("CAMPAIGNID", Common.nvl(request.getParameter("tgtCampaignId"), ""));
			map.put("CELLID", Common.nvl(request.getParameter("tgtCellId"), ""));
			map.put("CHANNEL_CD", Common.nvl(request.getParameter("tgtChannelCd"), ""));

			tgtbo = channelService.getChannelDtlInfo(map);
		}
		if (true) {
			//paramter
			log.info("=============================================");
			log.info("CampaignId   : " + request.getParameter("CampaignId"));
			log.info("CELLID       : " + request.getParameter("CELLID"));
			log.info("CHANNEL_CD   : " + request.getParameter("CHANNEL_CD"));
			log.info("=============================================");

			//채널정보 조회
			map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
			map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
			map.put("CHANNEL_CD", Common.nvl(request.getParameter("CHANNEL_CD"), ""));

			bo = channelService.getChannelDtlInfo(map);
		}

		// KANG-20200417: change values
		bo.setCampaigncode(tgtbo.getCampaigncode());
		bo.setCampaignname(tgtbo.getCampaignname());
		bo.setCampaignid(tgtbo.getCampaignid());
		bo.setCellid(tgtbo.getCellid());
		bo.setCellname(tgtbo.getCellname());
		bo.setChannel_cd(tgtbo.getChannel_cd());
		bo.setLms_disp_dt(request.getParameter("tgtDispDt"));
		bo.setCamp_status_cd("EDIT");
		bo.setCamp_term_cd(tgtbo.getCamp_term_cd());
		bo.setLms_disp_dt(tgtbo.getLms_disp_dt());
		bo.setCamp_bgn_dt(tgtbo.getCamp_bgn_dt());
		bo.setCamp_end_dt(tgtbo.getCamp_end_dt());
		bo.setCreate_id(tgtbo.getCreate_id());   // KANG-20200422: create upddate
		bo.setCreate_nm(tgtbo.getCreate_nm());
		bo.setCreate_dt(tgtbo.getCreate_dt());
		bo.setUpdate_id(tgtbo.getUpdate_id());
		bo.setUpdate_nm(tgtbo.getUpdate_nm());
		bo.setUpdate_dt(tgtbo.getUpdate_dt());
		bo.setLms_returncall("");   // KANG-20200418

		if (true) {
			// KANG-20200622: condition: bo is manual and tgt is manual and tgt is SEND02
			log.info("============ KANG-20200622(org) =============");
			log.info("bo.manual_trans_yn     : " + bo.getManual_trans_yn());
			log.info("bo.lms_disp_time       : " + bo.getLms_disp_time());
			log.info("---------------------------------------------");
			log.info("tgtbo.manual_trans_yn     : " + tgtbo.getManual_trans_yn());
			log.info("tgtbo.lms_disp_time       : " + tgtbo.getLms_disp_time());
			log.info("=============================================");
			
			if (tgtbo.getManual_trans_yn().equals("N")
					&& bo.getManual_trans_yn().equals("N")) {
				// KANG-20200622: copy
				log.info("KANG-20200622 >>>>>> because of condition_OK!!, then COPY from tgt.....");
			} else {
				// KANG-20200622: no copy, original
				bo.setManual_trans_yn(request.getParameter("MANUAL_TRANS_YN"));         // KANG-20200606: create
				bo.setLms_disp_time(request.getParameter("DISP_TIME"));                 // KANG-20200606: create
			}
		}
		
		modelMap.addAttribute("channel_list", channel_list);
		modelMap.addAttribute("priority_rank", priority_rank);
		modelMap.addAttribute("priority_rank_sendtime", priority_rank_sendtime);
		//modelMap.addAttribute("campScheduleTime", Common.campScheduleTime);

		modelMap.addAttribute("vri_list", vri_list);
		modelMap.addAttribute("comp_list", comp_list);
		modelMap.addAttribute("callback_list", callback_list);

		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute("CHANNEL_CD", request.getParameter("CHANNEL_CD"));
		modelMap.addAttribute("COPYCHANNEL", request.getParameter("COPYCHANNEL"));   // KANG-20200417
		modelMap.addAttribute("DISABLED", request.getParameter("DISABLED"));

		return "channel/channelLms";
	}

	/**
	 * 채널 SMS 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("setChannelLms.do")
	public void setChannelLms(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		//paramter
		log.info("=============================================");
		log.info("CAMPAIGNID           : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE         : " + request.getParameter("CAMPAIGNCODE"));
		log.info("FLOWCHARTID          : " + request.getParameter("FLOWCHARTID"));
		log.info("CELLID               : " + request.getParameter("CELLID"));
		log.info("CHANNEL_CD           : " + request.getParameter("CHANNEL_CD"));
		log.info("LMS_TITLE            : " + request.getParameter("LMS_TITLE"));
		log.info("LMS_MSG              : " + request.getParameter("LMS_MSG"));
		log.info("LMS_PRIORITY_RNK     : " + request.getParameter("LMS_PRIORITY_RNK"));
		log.info("LMS_DISP_TIME        : " + request.getParameter("LMS_DISP_TIME"));
		log.info("LMS_LONGURL          : " + request.getParameter("LMS_LONGURL"));
		log.info("LMS_SHORTURL         : " + request.getParameter("LMS_SHORTURL"));
		log.info("LMS_DISP_DT          : " + request.getParameter("LMS_DISP_DT"));
		log.info("LMS_CALLBACK         : " + request.getParameter("LMS_CALLBACK"));
		log.info("LMS_RETURNCALL       : " + request.getParameterValues("LMS_RETURNCALL"));
		log.info("=============================================");

		String LMS_MSG = Common.nvl(request.getParameter("LMS_MSG"), "");

		//사용자 변수 목록을 조회
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));

		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		int vai_cnt = 0;
		List<String> query_lsit0 = new ArrayList<String>(); //변수명
		List<String> query_lsit1 = new ArrayList<String>(); //참조테이블
		List<String> query_lsit2 = new ArrayList<String>(); //참조컬럼
		List<String> query_lsit3 = new ArrayList<String>(); //키컬럼
		List<String> query_lsit4 = new ArrayList<String>(); //널값일경우
		List<String> query_lsit5 = new ArrayList<String>(); //MAX BYTE

		for (int i = 0; i < vri_list.size(); i++) { //SMS 메세지에 사용자변수가 사용되었는지 체크
			UaextVariableBO bo = vri_list.get(i);

			log.info("=============================================");
			String vari_name = "{" + bo.getVari_name() + "}";
			log.info("getVari_name   : " + vari_name);

			if (LMS_MSG.indexOf(vari_name) > -1) { //변수가 존재할경우 조회 쿼리를 만든다
				log.info("변수 존재함!");

				//테스트용 데이터 조회
				String VARI_NAME = bo.getVari_name();
				String REF_TABLE = bo.getRef_table();
				String REF_COLUMN = bo.getRef_column();
				String KEY_COLUMN = bo.getKey_column();
				String IF_NULL = bo.getIf_null();
				String MAX_LENGTH = bo.getMax_byte();

				query_lsit0.add(VARI_NAME);
				query_lsit1.add(REF_TABLE);
				query_lsit2.add(REF_COLUMN);
				query_lsit3.add(KEY_COLUMN);
				query_lsit4.add(IF_NULL);
				query_lsit5.add(MAX_LENGTH);

				vai_cnt++; //카운트 +1

				log.info("* VARI_NAME : " + VARI_NAME + " * REF_TABLE : " + REF_TABLE + " * REF_COLUMN : " + REF_COLUMN
						+ " * KEY_COLUMN : " + KEY_COLUMN + " * IF_NULL : " + IF_NULL + " * MAX_LENGTH : " + MAX_LENGTH);
			} else {
				log.info("변수 미존재..");
			}
			log.info("=============================================");
		}

		// 		조회쿼리를 생성하여 db에 저장한다(ex)
		//		SELECT T.MEM_NO, T1.NAME || '님 반갑습니다 ' || T2.RANK || '등급이 되셨습니다'
		//		  FROM [TARGETTABLE] T
		//		,(SELECT NAME FROM TABLE1) T1
		//		,(SELECT CODE FROM TABLE2) T2
		//		WHERE T0.MEM_NO = T1.KEY1(+)
		//		  AND T0.MEM_NO = T2.KEY2(+)

		String LMS_MSG_QUERY = "";
		String LMS_MSG_QUERY1 = ""; //SELECT T.MEM_NO,
		String LMS_MSG_QUERY2 = ""; //[TARGETTABLE]
		String LMS_MSG_QUERY3 = ""; //FROM
		String LMS_MSG_QUERY4 = ""; //WHERE

		for (int i = 0; i < vai_cnt; i++) { //존재한 변수만큼 조회 쿼리를 만든다

			if (i == 0) { //최초
				LMS_MSG_QUERY1 += "SELECT T.MEM_NO, '" + LMS_MSG + "'";
				LMS_MSG_QUERY1 = LMS_MSG_QUERY1.replaceAll("\\{" + query_lsit0.get(i) + "}", "' || SUBSTRB(NVL(T" + i + "."
						+ query_lsit2.get(i) + ", '" + query_lsit4.get(i) + "'), 0," + query_lsit5.get(i) + ") || '");
				LMS_MSG_QUERY2 += " FROM [TARGETTABLE] T";
				LMS_MSG_QUERY3 += " , (SELECT * FROM " + query_lsit1.get(i) + ") T" + i;
				LMS_MSG_QUERY4 += " WHERE T.MEM_NO = T" + i + "." + query_lsit3.get(i) + "(+)";
			} else {
				LMS_MSG_QUERY1 = LMS_MSG_QUERY1.replaceAll("\\{" + query_lsit0.get(i) + "}", "' || SUBSTRB(NVL(T" + i + "."
						+ query_lsit2.get(i) + ", '" + query_lsit4.get(i) + "'), 0," + query_lsit5.get(i) + ") || '");
				LMS_MSG_QUERY3 += " , (SELECT * FROM " + query_lsit1.get(i) + ") T" + i;
				LMS_MSG_QUERY4 += " AND T.MEM_NO = T" + i + "." + query_lsit3.get(i) + "(+)";
			}
		}

		LMS_MSG_QUERY = LMS_MSG_QUERY1 + LMS_MSG_QUERY2 + LMS_MSG_QUERY3 + LMS_MSG_QUERY4;

		log.info("=============================================");
		log.info("LMS_MSG_QUERY ::: " + LMS_MSG_QUERY);
		log.info("=============================================");

		//입력 값
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("FLOWCHARTID", Common.nvl(request.getParameter("FLOWCHARTID"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("CHANNEL_CD", "LMS"); //SMS
		map.put("LMS_TITLE", Common.nvl(request.getParameter("LMS_TITLE"), ""));
		map.put("LMS_MSG", Common.nvl(request.getParameter("LMS_MSG"), ""));
		map.put("LMS_MSG_QUERY", Common.nvl(LMS_MSG_QUERY, ""));
		map.put("LMS_PRIORITY_RNK", Common.nvl(request.getParameter("LMS_PRIORITY_RNK"), ""));

		map.put("LMS_DISP_TIME", Common.nvl(request.getParameter("LMS_DISP_TIME"), ""));

		map.put("LMS_LONGURL", Common.nvl(request.getParameter("LMS_LONGURL"), ""));
		map.put("LMS_SHORTURL", Common.nvl(request.getParameter("LMS_SHORTURL"), ""));
		map.put("LMS_DISP_DT", Common.nvl(request.getParameter("LMS_DISP_DT"), ""));
		map.put("LMS_CALLBACK", Common.nvl(request.getParameter("LMS_CALLBACK"), ""));
		String LMS_RETURNCALLS[] = request.getParameterValues("LMS_RETURNCALL");
		String LMS_RETURNCALL = "";
		for (int i = 0; i < LMS_RETURNCALLS.length; i++) {
			if (i == 0) {
				LMS_RETURNCALL = LMS_RETURNCALLS[i];
			} else {
				LMS_RETURNCALL += ";" + LMS_RETURNCALLS[i];
			}
		}
		map.put("LMS_RETURNCALL", LMS_RETURNCALL);
		map.put("CREATE_ID", user.getId());
		map.put("UPDATE_ID", user.getId());

		//캠페인의 상태체크(START일경우에는 수정못함)
		CampaignInfoBO bo = campaignInfoService.getCampaignInfo(map);
		String CMP_STATUS = Common.nvl(bo.getCamp_status_cd(), "");

		if (!CMP_STATUS.equals("START")) {
			//SMS 정보 저장
			channelService.setChannelLms(map);
		}

		//캠페인 상태 리턴
		map.put("CMP_STATUS", CMP_STATUS);

		jsonView.render(map, request, response);
	}

	/**
	 * 채널 LMS ShortURL가져오기
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channelLmsShortUrl.do")
	public void channelLmsShortUrl(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("LMS_LONGURL   : " + request.getParameter("LMS_LONGURL"));

		String LMS_LONGURL = "http://bizapi.11st.co.kr/jsp/message/get_callback_url.jsp?domain=11st.kr&url="
				+ Common.nvl(request.getParameter("LMS_LONGURL"), "");

		log.info("LMS_LONGURL2   : " + LMS_LONGURL);
		log.info("=============================================");

		//url 가져오기
		URL url = null;
		String line = "";
		BufferedReader input = null;
		String ShortUrl = "";

		try {
			url = new URL(LMS_LONGURL);
			input = new BufferedReader(new InputStreamReader(url.openStream()));
			while ((line = input.readLine()) != null) {
				ShortUrl += line;
			}

			log.info("=============================================");
			log.info("SHORT_URL   : " + ShortUrl);
			log.info("=============================================");
		} catch (MalformedURLException mue) {
			log.info("잘못되 URL입니다. 사용법 : java URLConn http://hostname/path]");
		} catch (IOException ioe) {
			log.info("IOException " + ioe);
			ioe.printStackTrace();
		}

		map.put("SHORT_URL", ShortUrl);

		jsonView.render(map, request, response);
	}

	/**
	 * 채널 SMS 미리보기
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channelLmsPreview.do")
	public void channelLmsPreview(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("LMS_INPUT_MSG   : " + request.getParameter("LMS_INPUT_MSG"));
		log.info("=============================================");

		String LMS_MSG = Common.nvl(request.getParameter("LMS_INPUT_MSG"), "");

		//사용자 변수 목록을 조회
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));

		List<UaextVariableBO> vri_list = variableService.getVariableList(map);

		for (int i = 0; i < vri_list.size(); i++) { //Toast 메세지에 사용자변수가 사용되었는지 체크
			UaextVariableBO bo = vri_list.get(i);

			log.info("=============================================");
			String vari_name = "{" + bo.getVari_name() + "}";
			log.info("getVari_name   : " + vari_name);

			if (LMS_MSG.indexOf(vari_name) > -1) { //변수가 존재할경우
				log.info("변수 존재함!");

				//테스트용 데이터 조회
				map.put("REF_TABLE", bo.getRef_table());
				map.put("REF_COLUMN", bo.getRef_column());
				map.put("KEY_COLUMN", bo.getKey_column());
				map.put("MAX_BYTE", bo.getMax_byte());

				String preval = variableService.getVariablePreVal(map);
				log.info("조회된 변수값   : " + preval);

				//변수값 변경하기
				LMS_MSG = LMS_MSG.replaceAll("\\" + vari_name, preval);
				log.info("변경된 값   : " + LMS_MSG);

			} else {
				log.info("변수 미존재..");
			}
			log.info("=============================================");
		}

		map.put("LMS_INPUT_MSG", LMS_MSG);

		jsonView.render(map, request, response);
	}

	@Resource(name = "testTargetService")
	private TestTargetService testTargetService;

	/**
	 * KANG-20190426:
	 *
	 * 채널 Alimi Test Send 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/channel/channelAlimiTestSend.do")
	public String channelAlimiTestSend(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {

		//paramter
		log.info("==================== request =========================");
		log.info("SERVER_TYPE          : " + request.getParameter("SERVER_TYPE"));
		log.info("TALK_MSG_TEMP_NO     : " + request.getParameter("TALK_MSG_TEMP_NO"));
		log.info("TALK_DISP_YN         : " + request.getParameter("TALK_DISP_YN"));
		log.info("IOS_MSG              : " + request.getParameter("IOS_MSG"));
		log.info("AND_TOP_MSG          : " + request.getParameter("AND_TOP_MSG"));
		log.info("AND_BTM_MSG          : " + request.getParameter("AND_BTM_MSG"));
		log.info("DETAIL_URL           : " + request.getParameter("DETAIL_URL"));
		log.info("BANNER_URL           : " + request.getParameter("BANNER_URL"));
		log.info("ETC_DATA             : " + request.getParameter("ETC_DATA"));
		log.info("TALK_SUMMARY_MSG     : " + request.getParameter("TALK_SUMMARY_MSG"));
		log.info("ALIMI_MESSAGE        : " + request.getParameter("ALIMI_MESSAGE"));
		log.info("SEND_DATETIME        : " + request.getParameter("SEND_DATETIME"));
		log.info("=============================================");

		Map<String,String> mapAlimiMessage = gson.fromJson(request.getParameter("ALIMI_MESSAGE"), new TypeToken<Map<String, Object>>(){}.getType());
		String jsonTalkMessage = new GsonBuilder().setPrettyPrinting().create().toJson(mapAlimiMessage);
		//System.out.println(">>>>> " + jsonTalkMessage);

		if (Flag.flag) {
			log.info("=============================================");
			log.info("SMEM_ID   : " + request.getParameter("SMEM_ID"));
			log.info("=============================================");

			//조회조건
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("SMEM_ID", Common.nvl(request.getParameter("SMEM_ID"), ""));
			//테스트 대상 목록 조회
			List<UaextCampaignTesterBO> list = this.testTargetService.getTestTargetList(map);
			if (Flag.flag) {
				for (UaextCampaignTesterBO bo : list) {
					System.out.printf(">>>>> %s(%s)%n", bo.getName(), bo.getMem_no());
				}
			}

			modelMap.addAttribute("testTargetList", list);
		}

		modelMap.addAttribute("SERVER_TYPE", request.getParameter("SERVER_TYPE"));
		modelMap.addAttribute("TALK_MSG_TEMP_NO", request.getParameter("TALK_MSG_TEMP_NO"));
		modelMap.addAttribute("TALK_DISP_YN", request.getParameter("TALK_DISP_YN"));
		modelMap.addAttribute("IOS_MSG", request.getParameter("IOS_MSG"));  // (테스트) 추가
		modelMap.addAttribute("AND_TOP_MSG", request.getParameter("AND_TOP_MSG"));  // (테스트) 추가
		modelMap.addAttribute("AND_BTM_MSG", request.getParameter("AND_BTM_MSG"));  // (테스트) 추가
		modelMap.addAttribute("DETAIL_URL", request.getParameter("DETAIL_URL"));
		modelMap.addAttribute("BANNER_URL", request.getParameter("BANNER_URL"));
		modelMap.addAttribute("ETC_DATA", request.getParameter("ETC_DATA"));
		modelMap.addAttribute("TALK_SUMMARY_MSG", request.getParameter("TALK_SUMMARY_MSG"));  // (테스트) 추가
		modelMap.addAttribute("ALIMI_MESSAGE", jsonTalkMessage);
		modelMap.addAttribute("SEND_DATETIME", request.getParameter("SEND_DATETIME"));

		log.info("===================== modelMap ========================");
		log.info("SERVER_TYPE          : " + modelMap.get("SERVER_TYPE"));
		log.info("TALK_MSG_TEMP_NO     : " + modelMap.get("TALK_MSG_TEMP_NO"));
		log.info("TALK_DISP_YN         : " + modelMap.get("TALK_DISP_YN"));
		log.info("IOS_MSG              : " + modelMap.get("IOS_MSG"));
		log.info("AND_TOP_MSG          : " + modelMap.get("AND_TOP_MSG"));
		log.info("AND_BTM_MSG          : " + modelMap.get("AND_BTM_MSG"));
		log.info("DETAIL_URL           : " + modelMap.get("DETAIL_URL"));
		log.info("BANNER_URL           : " + modelMap.get("BANNER_URL"));
		log.info("ETC_DATA             : " + modelMap.get("ETC_DATA"));
		log.info("TALK_SUMMARY_MSG     : " + modelMap.get("TALK_SUMMARY_MSG"));
		log.info("ALIMI_MESSAGE        : " + modelMap.get("ALIMI_MESSAGE"));
		log.info("SEND_DATETIME        : " + modelMap.get("SEND_DATETIME"));
		log.info("=============================================");

		return "channel/channelAlimiTestSend";
	}

	/**
	 * KANG-20190429:
	 *
	 * send 채널 Alimi Test
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/sendChannelAlimiTest.do")
	public void sendChannelAlimiTest(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		log.info("====================== request =======================");
		log.info("TARGET_LIST          : " + request.getParameter("TARGET_LIST"));
		log.info("SERVER_TYPE          : " + request.getParameter("SERVER_TYPE"));
		log.info("TALK_MSG_TEMP_NO     : " + request.getParameter("TALK_MSG_TEMP_NO"));
		log.info("TALK_DISP_YN         : " + request.getParameter("TALK_DISP_YN"));
		log.info("IOS_MSG              : " + request.getParameter("IOS_MSG"));
		log.info("AND_TOP_MSG          : " + request.getParameter("AND_TOP_MSG"));
		log.info("AND_BTM_MSG          : " + request.getParameter("AND_BTM_MSG"));
		log.info("DETAIL_URL           : " + request.getParameter("DETAIL_URL"));
		log.info("BANNER_URL           : " + request.getParameter("BANNER_URL"));
		log.info("ETC_DATA             : " + request.getParameter("ETC_DATA"));
		log.info("TALK_SUMMARY_MSG     : " + request.getParameter("TALK_SUMMARY_MSG"));
		log.info("ALIMI_MESSAGE        : " + request.getParameter("ALIMI_MESSAGE"));
		log.info("SEND_DATETIME        : " + request.getParameter("SEND_DATETIME"));
		log.info("=============================================");

		if (Flag.flag) {
			// send Alimi
			List<Block> composites = getComposites(request.getParameter("ALIMI_MESSAGE"));

			// target member
			Long memberNo = Long.parseLong(request.getParameter("TARGET_LIST"));

			// environment
			System.setProperty("server.type", request.getParameter("SERVER_TYPE"));

			// 알림톡 템플릿에 등록한 메시지 타입코드 or "002"
			String talkMsgTempNo = request.getParameter("TALK_MSG_TEMP_NO");

			// 발송대상 앱코드
			AppKdCdType appKdCd = AppKdCdType.ELEVENSTAPP;

			// 푸시메시지
			JsonObject obj = new JsonObject();
			obj.addProperty("IOS_MSG", request.getParameter("IOS_MSG"));
			obj.addProperty("AND_TOP_MSG", request.getParameter("AND_TOP_MSG"));
			obj.addProperty("AND_BTM_MSG", request.getParameter("AND_BTM_MSG"));

			// Url
			String detailUrl = request.getParameter("DETAIL_URL");
			String bannerUrl = request.getParameter("BANNER_URL");
			String etcSasData = request.getParameter("ETC_DATA");
			Map<String,String> mapEtcSasData = gson.fromJson(etcSasData, new TypeToken<Map<String, Object>>(){}.getType());
			String summary = request.getParameter("TALK_SUMMARY_MSG");  // 알림톡방 리스트에 노출 할 메시지

			/////////////////////////////////////////
			// 알림톡 인자 세팅
			PushTalkParameter pushTalkParam = new PushTalkParameter(talkMsgTempNo, memberNo);
			pushTalkParam.setAppKdCd(appKdCd);             // 발송대상 앱코드
			//pushTalkParam.setMsgGrpNo(1235L);              // 메시지 식별 그룹번호. 없을경우 생략가능
			pushTalkParam.setPushIosMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushTopMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushBottomMessage(obj.toString());  // JSON (?)
			//pushTalkParam.setPushIosMessage(obj.get("IOS_MSG").getAsString());         // IOS message
			//pushTalkParam.setPushTopMessage(obj.get("AND_TOP_MSG").getAsString());     // Android Top message
			//pushTalkParam.setPushBottomMessage(obj.get("AND_BTM_MSG").getAsString());  // Android Bottom message
			pushTalkParam.setTalkDispYn("Y");              // 고정 처리 (Y) 알림-혜택톡방 동시 사용함
			pushTalkParam.setDetailUrl(detailUrl);         // 일반푸시 사용시- 클릭URL
			pushTalkParam.setBannerUrl(bannerUrl);         // 푸시배너이미지. 없을경우 생략가능
			pushTalkParam.setEtcData(mapEtcSasData);       // 기타 데이타 SAS에서 사용
			pushTalkParam.setTalkSummaryMessage(summary);  // 알림톡방 리스트에 노출 할 메시지
			pushTalkParam.setTalkMessage(composites);      // data from DB Table CM_CAMPAIGN_CHANNEL_JS
			pushTalkParam.setSendAllwBgnDt(new Date());    // 예약발송시 설정.
			// SMS 셋팅 http://wiki.11stcorp.com/pages/viewpage.action?pageId=214088691
			//pushTalkParam.setSmsMsg("SMS 스펙에 해당하는 데이터 작성");
			// 테스트 데이터 셋팅, 운영모드 일 경우 Remarking
			if (Flag.flag) {
				System.out.println(">>>>> " + pushTalkParam);
			}

			try {
				//알림톡 전송
				int RET = -1;
				if (Flag.flag) RET = PushTalkSendService.INSTANCE.remoteSyncPush(Lists.newArrayList(pushTalkParam));
				map.put("RET", String.format("%d", RET));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		if (Flag.flag) System.out.println(">>>>> map = " + map);
		jsonView.render(map, request, response);
	}

	@SuppressWarnings("unchecked")
	private List<Block> getComposites(String json) {
		String jsonParams = json;
		Map<String, Object> mapParams = null;
		List<Block> composites = null;

		if (Flag.flag) {
			mapParams = this.gson.fromJson(jsonParams, new TypeToken<Map<String, Object>>(){}.getType());
			if (Flag.flag) {
				System.out.println("----- mapParams main -----");
				System.out.println("alimiShow: " + mapParams.get("alimiShow"));
				System.out.println("alimiText: " + mapParams.get("alimiText"));
				System.out.println("alimiType: " + mapParams.get("alimiType"));
				System.out.println("jsonParams(=json): " + jsonParams);
			}
		}

		if (Flag.flag) {
			switch((String) mapParams.get("alimiType")) {
			case "001":  // Type-1
				if (Flag.flag) {
					List<BlockImg500.Value> listImg = new ArrayList<>();
					for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrImg")) {
						listImg.add(new BlockImg500.Value((String) map.get("imgUrl")));
					}
					composites = Lists.newArrayList(
							new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
							, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2"), (String) mapParams.get("title3")))
							, new BlockImg500(listImg)
							, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
					);
				}
				break;
			case "002":  // Type-2
				if (Flag.flag) {
					Map<String, Object> mapImg = ((List<Map<String, Object>>) mapParams.get("arrImg")).get(0);
					List<BlockProductPrice.Value> listProduct = new ArrayList<>();
					for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrPrd")) {
						listProduct.add(new BlockProductPrice.Value(
								(String) map.get("prdUrl"),
								(String) map.get("prdName"),
								(String) map.get("prdPrice"),
								(String) map.get("prdUnit"),
								new BlockLinkUrl((String) map.get("prdMblUrl"), (String) map.get("prdWebUrl"))
								));
					}
					composites = Lists.newArrayList(
							new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
							, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2"), (String) mapParams.get("title3")))
							, new BlockImg240(new BlockImg240.Value((String)mapImg.get("imgUrl")))
							, new BlockProductPrice(listProduct)
							, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
					);
				}
				break;
			case "003":  // Type-3
				if (Flag.flag) {
					Map<String, Object> mapImg = ((List<Map<String, Object>>) mapParams.get("arrImg")).get(0);
					List<BlockCouponText.Value> listCoupon = new ArrayList<>();
					for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrCpn")) {
						listCoupon.add(new BlockCouponText.Value(
								/* couponNo, couponText, title1, sub_text1, sub_text2, true */
								(String) map.get("cpnNumber"),
								(String) map.get("cpnText1"),
								(String) map.get("cpnText2"),
								(String) map.get("cpnText3"),
								(String) map.get("cpnText4"),
								"show".equals((String) map.get("cpnVisible")) ? true : false
								));
					}
					composites = Lists.newArrayList(
							new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
							, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2"), (String) mapParams.get("title3")))
							, new BlockImg240(new BlockImg240.Value((String) mapImg.get("imgUrl")))
							, new BlockCouponText(listCoupon)
							, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
					);
				}
				break;
			case "004":  // Type-4
				if (Flag.flag) {
					Map<String, Object> mapAnn = ((List<Map<String, Object>>) mapParams.get("arrAnn")).get(0);
					composites = Lists.newArrayList(
							new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
							, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2"), (String) mapParams.get("title3")))
							, new BlockSubText(new BlockSubText.Value((String)mapAnn.get("annText"), BlockSubTextAlignType.CENTER))
							, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
					);
				}
				break;
			case "005":  // Type-5
				if (Flag.flag) {
					List<BlockProductPrice.Value> listProduct = new ArrayList<>();
					for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrPrd")) {
						listProduct.add(new BlockProductPrice.Value(
								(String) map.get("prdUrl"),
								(String) map.get("prdName"),
								(String) map.get("prdPrice"),
								(String) map.get("prdUnit"),
								new BlockLinkUrl((String) map.get("prdMblUrl"), (String) map.get("prdWebUrl"))
								));
					}
					composites = Lists.newArrayList(
							new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
							, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2"), (String) mapParams.get("title3")))
							, new BlockProductPrice(listProduct)
							, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
					);
				}
				break;
			case "006":  // Type-6
				if (Flag.flag) {
					List<BlockCouponText.Value> listCoupon = new ArrayList<>();
					for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrCpn")) {
						listCoupon.add(new BlockCouponText.Value(
								/* couponNo, couponText, title1, sub_text1, sub_text2, true */
								(String) map.get("cpnNumber"),
								(String) map.get("cpnText1"),
								(String) map.get("cpnText2"),
								(String) map.get("cpnText3"),
								(String) map.get("cpnText4"),
								"show".equals((String) map.get("cpnVisible")) ? true : false
								));
					}
					composites = Lists.newArrayList(
							new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
							, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2"), (String) mapParams.get("title3")))
							, new BlockCouponText(listCoupon)
							, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
					);
				}
				break;
			default:
				composites = Lists.newArrayList();
				break;
			}
		}

		return composites;
	}

	/**
	 * KANG-20200429:
	 * KANG-20200508:
	 *
	 * send 채널 Alimi Test
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Value("#{contextProperties['banner.rol.image']}") // http://img.011st.com/11st-push/o.jpg;sz=800x464/#bannerImg#;sz=800x464;g=0;/#addImg#;g=9;off=-10+35
	private String bannerRolImage;
	@Value("#{contextProperties['banner.add.image']}")  // http://i.011st.com/ui_img/cm_display/2018/04/MPMCD/0402/txt_b_w.png
	private String bannerAddImage;
	@RequestMapping("/channel/makeBnnrStrUrl.do")
	public void makeBnnrStrUrl(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		log.info("=============================================");
		log.info("bannerImg       : " + request.getParameter("bannerImg"));
		log.info("bannerRolImage  : " + bannerRolImage);
		log.info("bannerAddImage  : " + bannerAddImage);
		log.info("=============================================");
		
		String bannerImg = request.getParameter("bannerImg");
		
		URLCodec urlCodec = new URLCodec();
		String encBannerImg = urlCodec.encode(bannerImg);
		String encAddImg = urlCodec.encode(bannerAddImage);

		String rolImg = bannerRolImage;
		rolImg = StringUtils.replace(rolImg, "#bannerImg#", encBannerImg);
		rolImg = StringUtils.replace(rolImg, "#addImg#", encAddImg);

		map.put("rolImg", rolImg);
		log.info("=============================================");
		log.info("rolImg  : " + rolImg);
		log.info("map     : " + map);
		log.info("=============================================");
		
		jsonView.render(map, request, response);
	}
}
