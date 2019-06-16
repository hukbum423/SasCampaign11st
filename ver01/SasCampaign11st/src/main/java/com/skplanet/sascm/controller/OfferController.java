package com.skplanet.sascm.controller;

import java.text.SimpleDateFormat;
import java.util.Enumeration;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.json.MappingJacksonJsonView;

import com.skplanet.sascm.object.CampaignInfoBO;
import com.skplanet.sascm.object.CampaignOfferBO;
import com.skplanet.sascm.object.CupnStatBO;
import com.skplanet.sascm.object.OfferCouponInfoBO;
import com.skplanet.sascm.object.OfferCuBO;
import com.skplanet.sascm.object.OfferCuCtgrBO;
import com.skplanet.sascm.object.OfferPnBO;
import com.skplanet.sascm.object.UaextCodeDtlBO;
import com.skplanet.sascm.object.UsmUserBO;
import com.skplanet.sascm.service.CampaignInfoService;
import com.skplanet.sascm.service.CommCodeService;
import com.skplanet.sascm.service.OfferService;
import com.skplanet.sascm.util.CheckCopyCouponNo;
import com.skplanet.sascm.util.Common;
import com.skplanet.sascm.util.Flag;

/**
 * OfferController
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Controller
public class OfferController {

	private final Log log = LogFactory.getLog(getClass());

	@Resource(name = "offerService")
	private OfferService offerService;

	@Resource(name = "campaignInfoService")
	private CampaignInfoService campaignInfoService;

	@Resource(name = "commCodeService")
	private CommCodeService commCodeService;

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

	@Value("#{contextProperties['server.type.aprvid']}")
	private String staticServerTypeAprvid;

	//AJAX
	@Autowired
	private MappingJacksonJsonView jsonView;

	/**
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping("/getOfferInfoList.do")
	public void getOfferInfoList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("campaignid"));
		log.info("=============================================");

		//캠페인 정보 상세 조회
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("campaignid"), ""));
		map.put("USER_ID", user.getId());

		//오퍼 목록
		List<CampaignOfferBO> offer_list = campaignInfoService.getCampaignOfferList(map);

		//대상수준에 따른 유효성 체크
		//1. 대상수준이 PCID일경우 오퍼의 사용여부 체크
		// String offerUseChk = campaignInfoService.getCampaignOfferUseChk(map);

		//3. 사용자의 권한이 N이 아닐때는 더미오퍼를 사용할수 없다. 유효성 체크
		// String dummyOfferChk = campaignInfoService.getCampaignChannelValiChk2(map);

		//4. 대상수준이 DEVICE_ID 일 경우 더미오퍼만 사용가능
		// String dummyOfferChkDeviceId = campaignInfoService.getCampaignChannelValiChkforDeviceId(map);

		map.put("offer_list", offer_list);
		// map.put("offerUseChk", offerUseChk);
		// map.put("dummyOfferChk", dummyOfferChk);
		// map.put("dummyOfferChkDeviceId", dummyOfferChkDeviceId);

		jsonView.render(map, request, response);
	}

	/**
	 * KANG-20190411: for analyzing
	 * 
	 * 오퍼 쿠폰 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/offer/offerCoupon.do")
	public String pageOfferCoupon(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("CELLID       : " + request.getParameter("CELLID"));
		log.info("OFFERID      : " + request.getParameter("OFFERID"));
		log.info("=============================================");

		//오퍼(포인트, 마일리지) 정보 상세 조회
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), "").replace(" ", ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), "").replace(" ", ""));
		map.put("OFFERID", Common.nvl(request.getParameter("OFFERID"), "").replace("\t", ""));

		OfferCuBO bo = this.offerService.getOfferCuInfo(map);

		modelMap.addAttribute("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		modelMap.addAttribute("bo", bo);

		return "offer/offerCoupon";
	}

	/**
	 * 템플릿 쿠폰 정보 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/offer/getOfferTmplCupnInfo.do")
	public void getOfferTmplCupnInfo(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("S_TMPL_CUPN_NO   : " + request.getParameter("S_TMPL_CUPN_NO"));
		log.info("OFFER_TYPE_CD    : " + request.getParameter("OFFER_TYPE_CD"));
		log.info("OFFER_SYS_CD     : " + request.getParameter("OFFER_SYS_CD"));
		log.info("=============================================");

		map.put("S_TMPL_CUPN_NO", Common.nvl(request.getParameter("S_TMPL_CUPN_NO"), ""));
		map.put("OFFER_TYPE_CD", Common.nvl(request.getParameter("OFFER_TYPE_CD"), ""));
		map.put("OFFER_SYS_CD", Common.nvl(request.getParameter("OFFER_SYS_CD"), ""));

		//템플릿 쿠폰번호 조회
		OfferCouponInfoBO bo = new OfferCouponInfoBO();

		bo = offerService.getOfferTmplCupnInfoOM(map);
		if (request.getParameter("OFFER_SYS_CD").equals("OM")) { //OM쿠폰정보 조회
			bo = offerService.getOfferTmplCupnInfoOM(map);
		} else if (request.getParameter("OFFER_SYS_CD").equals("MM")) { //MM쿠폰정보 조회
			bo = offerService.getOfferTmplCupnInfoMM(map);
		}

		List<OfferCuCtgrBO> ctgrList = offerService.getBoCategoryList(map);

		map.put("bo", bo);
		map.put("ctgrList", ctgrList);

		jsonView.render(map, request, response);
	}

	/**
	 * 오퍼정보 입력(쿠폰)
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setOfferCu.do")
	public void setOfferCu(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		log.info("=============================================");
		log.info("CAMPAIGNID           : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE         : " + request.getParameter("CAMPAIGNCODE"));
		log.info("FLOWCHARTID          : " + request.getParameter("FLOWCHARTID"));
		log.info("CELLID               : " + request.getParameter("CELLID"));
		log.info("OFFERID              : " + request.getParameter("OFFERID"));
		log.info("OFFER_TYPE_CD        : " + request.getParameter("OFFER_TYPE_CD"));
		log.info("OFFER_SYS_CD         : " + request.getParameter("OFFER_SYS_CD"));
		log.info("DISP_NAME            : " + request.getParameter("DISP_NAME"));
		log.info("TMPL_CUPN_NO         : " + request.getParameter("TMPL_CUPN_NO"));
		log.info("TMPL_CUPN_NO_USE_YN  : " + request.getParameter("TMPL_CUPN_NO_USE_YN"));
		log.info("=============================================");

		//입력 값
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("FLOWCHARTID", Common.nvl(request.getParameter("FLOWCHARTID"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("OFFERID", Common.nvl(request.getParameter("OFFERID").replace("\t", ""), ""));
		map.put("OFFER_TYPE_CD", Common.nvl(request.getParameter("OFFER_TYPE_CD"), ""));
		map.put("OFFER_SYS_CD", Common.nvl(request.getParameter("OFFER_SYS_CD"), ""));
		map.put("DISP_NAME", Common.nvl(request.getParameter("DISP_NAME"), ""));
		map.put("TMPL_CUPN_NO", Common.nvl(request.getParameter("TMPL_CUPN_NO"), ""));
		map.put("TMPL_CUPN_NO_USE_YN", Common.nvl(request.getParameter("TMPL_CUPN_NO_USE_YN"), ""));
		map.put("CREATE_ID", Common.nvl(user.getId(), ""));
		map.put("UPDATE_ID", Common.nvl(user.getId(), ""));

		//캠페인의 상태체크(START일경우에는 수정못함)
		CampaignInfoBO bo = campaignInfoService.getCampaignInfo(map);
		String CMP_STATUS = Common.nvl(bo.getCamp_status_cd(), "");

		if (!CMP_STATUS.equals("START")) {
			offerService.setOfferCu(map);
			@SuppressWarnings("unused")
			CheckCopyCouponNo ccc = new CheckCopyCouponNo();
			String tmpOfferId = Common.nvl(request.getParameter("OFFERID").replace("\t", ""), "");
			log.debug(request.getParameter("CampaignId"));
			log.debug(request.getParameter("CELL_PACKAGE_SK"));
			log.debug(tmpOfferId);
			try {// 443: campaign_sk // 1580 : rund id = cell_package_sk
				CheckCopyCouponNo.checkCouponNo(request.getParameter("CampaignId"), request.getParameter("CELL_PACKAGE_SK"), dbconnUrl, dbconnUser, dbconnPass, dbconnBoUrl, dbconnBoUser, dbconnBoPass, Integer.parseInt(tmpOfferId));
			} catch (Exception e) {
				log.debug("CheckCopyCouponNo.checkCouponNo ERROR !!!! ");
				e.printStackTrace();
			}
		}

		//캠페인 상태 리턴
		map.put("CMP_STATUS", CMP_STATUS);

		jsonView.render(map, request, response);
	}

	/**
	 * 오퍼 포인트 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/offer/offerPoint.do")
	public String pageOfferPoint(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("CELLID       : " + request.getParameter("CELLID"));
		log.info("OFFERID      : " + request.getParameter("OFFERID"));
		log.info("=============================================");

		//연결페이지 구분
		map.put("codeId", "C030");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> offerAplyCdList = commCodeService.getCommCodeDtlList(map);

		//연결페이지 구분
		map.put("codeId", "C031");
		List<UaextCodeDtlBO> prodRecomCdList = commCodeService.getCommCodeDtlList(map);

		//오퍼(포인트, 마일리지) 정보 상세 조회
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("OFFERID", Common.nvl(request.getParameter("OFFERID"), ""));

		OfferPnBO bo = offerService.getOfferPnInfo(map);

		modelMap.addAttribute("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("offerAplyCdList", offerAplyCdList);
		modelMap.addAttribute("prodRecomCdList", prodRecomCdList);

		return "offer/offerPoint";
	}

	/**
	 * 오퍼 11페이포인트 페이지 호출: KANG-20190530
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/offer/offerPTPoint.do")
	public String pageOfferPTPoint(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + request.getParameter("CampaignId"));
		log.info("CELLID       : " + request.getParameter("CELLID"));
		log.info("OFFERID      : " + request.getParameter("OFFERID"));
		log.info("=============================================");

		//연결페이지 구분
		map.put("codeId", "C030");
		map.put("USE_YN", "Y");
		List<UaextCodeDtlBO> offerAplyCdList = commCodeService.getCommCodeDtlList(map);

		//연결페이지 구분
		map.put("codeId", "C031");
		List<UaextCodeDtlBO> prodRecomCdList = commCodeService.getCommCodeDtlList(map);

		//오퍼(포인트, 마일리지) 정보 상세 조회
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("OFFERID", Common.nvl(request.getParameter("OFFERID"), ""));

		OfferPnBO bo = offerService.getOfferPnInfo(map);

		modelMap.addAttribute("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		modelMap.addAttribute("bo", bo);
		modelMap.addAttribute("offerAplyCdList", offerAplyCdList);
		modelMap.addAttribute("prodRecomCdList", prodRecomCdList);

		return "offer/offerPTPoint";
	}

	/**
	 * 오퍼정보 입력(포인트, 마일리지)
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setOfferPn.do")
	public void setOfferPn(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		log.info("=============================================");
		log.info("CAMPAIGNID           : " + request.getParameter("CampaignId"));
		log.info("CAMPAIGNCODE         : " + request.getParameter("CAMPAIGNCODE"));
		log.info("FLOWCHARTID          : " + request.getParameter("FLOWCHARTID"));
		log.info("CELLID               : " + request.getParameter("CELLID"));
		log.info("OFFERID              : " + request.getParameter("OFFERID"));
		log.info("OFFER_TYPE_CD        : " + request.getParameter("OFFER_TYPE_CD"));
		log.info("OFFER_SYS_CD         : " + request.getParameter("OFFER_SYS_CD"));
		log.info("DISP_NAME            : " + request.getParameter("DISP_NAME"));
		log.info("OFFER_AMT            : " + request.getParameter("OFFER_AMT"));

		log.info("OFFER_APLY_CD            : " + request.getParameter("OFFER_APLY_CD"));
		log.info("PROD_RECOM_CD            : " + request.getParameter("PROD_RECOM_CD"));

		log.info("=============================================");

		//입력 값
		map.put("CAMPAIGNID", Common.nvl(request.getParameter("CampaignId"), ""));
		map.put("CAMPAIGNCODE", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
		map.put("FLOWCHARTID", Common.nvl(request.getParameter("FLOWCHARTID"), ""));
		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("OFFERID", Common.nvl(request.getParameter("OFFERID").replace("\t", ""), ""));
		map.put("OFFER_TYPE_CD", Common.nvl(request.getParameter("OFFER_TYPE_CD"), ""));
		map.put("OFFER_SYS_CD", Common.nvl(request.getParameter("OFFER_SYS_CD"), ""));
		map.put("DISP_NAME", Common.nvl(request.getParameter("DISP_NAME"), ""));
		map.put("OFFER_AMT", Common.nvl(request.getParameter("OFFER_AMT"), ""));
		map.put("OFFER_APLY_CD", Common.nvl(request.getParameter("OFFER_APLY_CD"), ""));
		map.put("PROD_RECOM_CD", Common.nvl(request.getParameter("PROD_RECOM_CD"), ""));
		map.put("CREATE_ID", Common.nvl(user.getId(), ""));
		map.put("UPDATE_ID", Common.nvl(user.getId(), ""));

		//캠페인의 상태체크(START일경우에는 수정못함)
		CampaignInfoBO bo = campaignInfoService.getCampaignInfo(map);
		String CMP_STATUS = Common.nvl(bo.getCamp_status_cd(), "");

		if (!CMP_STATUS.equals("START")) {
			offerService.setOfferPn(map);
		}

		//캠페인 상태 리턴
		map.put("CMP_STATUS", CMP_STATUS);

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
	@RequestMapping("/offer/offer.do")
	public String pageCampaignInfoList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		@SuppressWarnings("unused")
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("CampaignId   : " + "123");
		log.info("=============================================");

		//
		map.put("CAMPAIGNID", "123");
		map.put("USER_ID", "123");

		//
		//List<CampaignOfferBO> offer_list = campaignInfoService.getCampaignOfferList(map);

		//
		//1.
		//String offerUseChk = campaignInfoService.getCampaignOfferUseChk(map);

		//3.
		//String dummyOfferChk = campaignInfoService.getCampaignChannelValiChk2(map);

		//4.
		//String dummyOfferChkDeviceId = campaignInfoService.getCampaignChannelValiChkforDeviceId(map);

		//CampaignInfoBO bo = campaignInfoService.getCampaignInfo(map);

		//modelMap.addAttribute("bo", bo);
		//modelMap.addAttribute("offer_list", offer_list);
		//modelMap.addAttribute("offerUseChk", offerUseChk);
		//modelMap.addAttribute("dummyOfferChk", dummyOfferChk);
		//modelMap.addAttribute("dummyOfferChkDeviceId", dummyOfferChkDeviceId);

		modelMap.addAttribute("CAMPAIGNID", "123");

		return "offer/offer";
	}

	/**
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping("offer/getBoCategory.do")
	public void getBoCategory(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		@SuppressWarnings("unused")
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		log.info("============================================================");
		log.info("level           : " + request.getParameter("level"));
		log.info("disp_ctgr1           : " + request.getParameter("disp_ctgr1"));
		log.info("disp_ctgr2           : " + request.getParameter("disp_ctgr2"));
		log.info("disp_ctgr3           : " + request.getParameter("disp_ctgr3"));
		log.info("disp_ctgr4           : " + request.getParameter("disp_ctgr4"));
		log.info("============================================================");

		//입력 값
		map.put("level", Common.nvl(request.getParameter("level"), ""));
		map.put("disp_ctgr1", Common.nvl(request.getParameter("disp_ctgr1"), ""));
		map.put("disp_ctgr2", Common.nvl(request.getParameter("disp_ctgr2"), ""));
		map.put("disp_ctgr3", Common.nvl(request.getParameter("disp_ctgr3"), ""));
		map.put("disp_ctgr4", Common.nvl(request.getParameter("disp_ctgr4"), ""));

		//캠페인의 상태체크(START일경우에는 수정못함)
		List<OfferCuCtgrBO> boList = offerService.getBoCategory(map);

		//캠페인 상태 리턴
		map.put("boList", boList);

		jsonView.render(map, request, response);
	}

	/**
	 *
	 * @param request
	 * @param response
	 * @param arrKey
	 * @param modelMap
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping("offer/getSubCategory.do")
	public void getSubCategory(HttpServletRequest request, HttpServletResponse response, @RequestParam("arrKey") String[] arrKey, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		@SuppressWarnings("unused")
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		log.info("============================================================");
		log.info("cateNo           : " + request.getParameter("cateNoVal"));
		log.info("arrKey           : " + arrKey);
		log.info("============================================================");

		//입력 값
		/*
		map.put("level", Common.nvl(request.getParameter("level"), ""));
		map.put("disp_ctgr1", Common.nvl(request.getParameter("disp_ctgr1"), ""));
		map.put("disp_ctgr2", Common.nvl(request.getParameter("disp_ctgr2"), ""));
		map.put("disp_ctgr3", Common.nvl(request.getParameter("disp_ctgr3"), ""));
		map.put("disp_ctgr4", Common.nvl(request.getParameter("disp_ctgr4"), ""));
		*/

		map.put("cateNo", Common.nvl(request.getParameter("cateNoVal"), ""));
		map.put("arrKey", arrKey);

		//캠페인의 상태체크(START일경우에는 수정못함)
		List<OfferCuCtgrBO> boList = offerService.getBoSubCategory(map);

		//캠페인 상태 리턴
		map.put("boList", boList);

		jsonView.render(map, request, response);
	}

	/**
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping("offer/copyCoupon.do")
	@SuppressWarnings("unused")
	public void copyCoupon(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		log.info("============================================================");
		log.info("OfferController.copyCoupon        : ");
		//log.info("cateNo           : " + request.getParameter("cateNoVal"));
		//log.info("arrKey           : " + arrKey);
		log.info("============================================================");

		//입력 값
		SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		// ####### 쿠폰 복사 처리
		// ########### 복사할 쿠폰번호
		map.put("p_cupn_no", Common.nvl(request.getParameter("S_TMPL_CUPN_NO"), ""));
		// ########### 쿠폰명
		map.put("p_cupn_nm", Common.nvl(request.getParameter("DISP_NAME"), ""));

		String pCupnDscMthdCd = Common.nvl(request.getParameter("p_cupn_dsc_mthd_cd"), "");
		// ########### 할인방식코드 (01=정액, 02=정률)
		map.put("p_cupn_dsc_mthd_cd", pCupnDscMthdCd);

		// ########### 할인금액/할인율
		if(null != request.getParameter("p_dsc_amt_rt") && request.getParameter("p_dsc_amt_rt") != ""){
			if(pCupnDscMthdCd.equals("01")){
				String pDscAmtRt = Common.nvl(request.getParameter("p_dsc_amt_rt"), "0");
				pDscAmtRt = pDscAmtRt.replace(",", "");
				map.put("p_dsc_amt_rt", Integer.parseInt(pDscAmtRt));
			}else if(pCupnDscMthdCd.equals("02")){
				String pDscAmtRt = Common.nvl(request.getParameter("p_dsc_amt_rt"), "0");
				map.put("p_dsc_amt_rt", Integer.parseInt(pDscAmtRt));
			}
		}else{
			map.put("p_dsc_amt_rt", 0);
		}

		// ########### 최대할인금액
		if(null != request.getParameter("p_max_dsc_amt") && request.getParameter("p_max_dsc_amt") != ""){
			String pMaxDscAmt = Common.nvl(request.getParameter("p_max_dsc_amt"), "0");
			pMaxDscAmt = pMaxDscAmt.replace(",", "");
			map.put("p_max_dsc_amt", Integer.parseInt(pMaxDscAmt));
		}else{
			map.put("p_max_dsc_amt", 0);
		}

		// ########### 최저사용조건금액
		if(null != request.getParameter("p_min_ord_amt") && request.getParameter("p_min_ord_amt") != ""){
			String pMinOrdAmt = Common.nvl(request.getParameter("p_min_ord_amt"), "0");
			pMinOrdAmt = pMinOrdAmt.replace(",", "");
			map.put("p_min_ord_amt", Integer.parseInt(pMinOrdAmt));
		}else{
			map.put("p_min_ord_amt", 0);
		}

		String p_iss_cn_bgn_dt = "";
		p_iss_cn_bgn_dt += Common.nvl(request.getParameter("p_iss_cn_bgn_dt"), "");
		p_iss_cn_bgn_dt += " ";
		p_iss_cn_bgn_dt += Common.nvl(request.getParameter("p_iss_cn_bgn_tm"), "");
		p_iss_cn_bgn_dt += ":00";
		// ############ 발급기간 시작
		map.put("p_iss_cn_bgn_dt", transFormat.parse(p_iss_cn_bgn_dt));

		String p_iss_cn_end_dt = "";
		p_iss_cn_end_dt += Common.nvl(request.getParameter("p_iss_cn_end_dt"), "");
		p_iss_cn_end_dt += " ";
		p_iss_cn_end_dt += Common.nvl(request.getParameter("p_iss_cn_end_tm"), "");
		p_iss_cn_end_dt += ":59";
		// ############ 발급기간 종료
		map.put("p_iss_cn_end_dt", transFormat.parse(p_iss_cn_end_dt));

		String p_eftv_bgn_dt = "";
		p_eftv_bgn_dt += Common.nvl(request.getParameter("p_eftv_bgn_dt"), "") + " 00:00:00";
		// ############ 유효기간 시작
		map.put("p_eftv_bgn_dt", transFormat.parse(p_eftv_bgn_dt));

		String p_eftv_end_dt = "";
		p_eftv_end_dt += Common.nvl(request.getParameter("p_eftv_end_dt"), "") + " 23:59:59";
		// ############ 유효기간 종료
		map.put("p_eftv_end_dt", transFormat.parse(p_eftv_end_dt));

		String p_wire_wirelss_clf_cd = "01";
		if(Common.nvl(request.getParameter("p_wire_wirelss_clf_cd"), "") == "03"){
			p_wire_wirelss_clf_cd = Common.nvl(request.getParameter("p_wire_wirelss_clf_cd"), "");
		}
		// ############ 적용사이트제한 (01=공통, 02=유선(여기선사용안함), 03=무선)
		map.put("p_wire_wirelss_clf_cd", p_wire_wirelss_clf_cd);

		String p_isu_qty;
		p_isu_qty = Common.nvl(request.getParameter("p_isu_qty"), "0");
		map.put("p_isu_qty", p_isu_qty);

		// ############ 쿠폰 복사하는 사용자의 사번
		map.put("p_create_id", staticServerTypeAprvid);
		// ############ 쿠폰 승인하는 사용자의 사번
		map.put("p_aprv_id", staticServerTypeAprvid);
		// ####### 쿠폰 복사 처리 ///

		// ####### 쿠폰 카테고리 처리
		String p_ctgr_no_list = "";
		@SuppressWarnings("rawtypes")
		Enumeration params = request.getParameterNames();
		while (params.hasMoreElements()){
			String name = (String)params.nextElement();
			if(name.indexOf("trCtgr_") == 0){
				if (Flag.flag) System.out.println("KANG-20190412: " + name + " : " +request.getParameter(name) + " --- " + name.indexOf("trCtgr_"));
				String [] tmpTrCtgr = request.getParameter(name).split("_");
				if (Flag.flag) System.out.println("KANG-20190412: " + "tmpTrCtgr[chkNo] : " + tmpTrCtgr[tmpTrCtgr.length-1]);
				if(!p_ctgr_no_list.equals("")){
					p_ctgr_no_list += ",";
				}
				p_ctgr_no_list += tmpTrCtgr[tmpTrCtgr.length-1];
			}
		}
		// ####### 쿠폰 카테고리 처리
		if (Flag.flag) System.out.println("KANG-20190412: " + map);

		// 캠페인의 상태체크(START일경우에는 수정못함 처리해야함.)
		this.offerService.copyCoupon(map);

		map.put("p_ctgr_no_list", p_ctgr_no_list);
		map.put("p_update_id", staticServerTypeAprvid);
		this.offerService.copyCouponCtgr(map);

		if (Flag.flag) System.out.println("KANG-20190412: map.get('r_cupn_no') = " + ((Long)map.get("r_cupn_no")));

		jsonView.render(map, request, response);
	}

	/**
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping("offer/deleteCoupon.do")
	public void deleteCoupon(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("CELLID", Common.nvl(request.getParameter("CELLID"), ""));
		map.put("OFFERID", Common.nvl(request.getParameter("OFFERID"), ""));

		CupnStatBO cupnStatBo = new CupnStatBO();
		cupnStatBo = offerService.getCampaignStat(map);

		@SuppressWarnings("unused")
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		log.info("============================================================");
		// log.info("cateNo           : " + request.getParameter("cateNoVal"));
		//log.info("arrKey           : " + arrKey);
		log.info("============================================================");


		// #######
		if(null != cupnStatBo){
			String campaignCode = Common.nvl(request.getParameter("CAMPAIGNCODE"), "");
			String treatmentCode = Common.nvl(cupnStatBo.getTreatmentcode(), "")+"_"+Common.nvl(cupnStatBo.getOfferid(), "");
			String cupnNo = Common.nvl(cupnStatBo.getCupn_no(), "");

			if(null != campaignCode && null != treatmentCode && cupnNo != null && !campaignCode.equals("") && !treatmentCode.equals("") && !cupnNo.equals("")){
				map.put("campaigncode", Common.nvl(request.getParameter("CAMPAIGNCODE"), ""));
				map.put("treatmentcode", Common.nvl(cupnStatBo.getTreatmentcode()+"_"+cupnStatBo.getOfferid(), ""));
				map.put("cupn_no", Common.nvl(cupnStatBo.getCupn_no(), ""));
				offerService.deleteCoupon(map);
				map.put("resultVal", "0000");
			}else{
				map.put("resultVal", "9999");
			}
		}else{
			map.put("resultVal", "9999");
		}

		jsonView.render(map, request, response);
	}

	/**
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @param session
	 * @throws Exception
	 */
	@RequestMapping("offer/editCoupon.do")
	public void editCoupon(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		@SuppressWarnings("unused")
		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		log.info("============================================================");
		//log.info("cateNo           : " + request.getParameter("cateNoVal"));
		//log.info("arrKey           : " + arrKey);
		log.info("============================================================");

		// ####### 쿠폰 카테고리 처리
		String p_ctgr_no_list = "";
		@SuppressWarnings("rawtypes")
		Enumeration params = request.getParameterNames();
		while (params.hasMoreElements()){
			String name = (String)params.nextElement();
			if(name.indexOf("trCtgr_") == 0){
				//System.out.println(name + " : " +request.getParameter(name) + " --- " + name.indexOf("trCtgr_"));
				String [] tmpTrCtgr = request.getParameter(name).split("_");
				System.out.println("tmpTrCtgr[chkNo] : " + tmpTrCtgr[tmpTrCtgr.length-1]);
				if(!p_ctgr_no_list.equals("")){
					p_ctgr_no_list += ",";
				}
				p_ctgr_no_list += tmpTrCtgr[tmpTrCtgr.length-1];
			}
		}

		// ####### 쿠폰 카테고리 처리 ///
		// ########### 카테고리 수정할 쿠폰번호
		map.put("r_cupn_no", Common.nvl(request.getParameter("S_TMPL_CUPN_NO"), ""));
		map.put("p_ctgr_no_list", p_ctgr_no_list);
		map.put("p_update_id", staticServerTypeAprvid);
		offerService.copyCouponCtgr(map);

		jsonView.render(map, request, response);
	}
}


/*
map.put("level", Common.nvl(request.getParameter("level"), ""));
map.put("disp_ctgr1", Common.nvl(request.getParameter("S_TMPL_CUPN_NO"), ""));
map.put("disp_ctgr2", Common.nvl(request.getParameter("disp_ctgr2"), ""));
map.put("disp_ctgr3", Common.nvl(request.getParameter("disp_ctgr3"), ""));
map.put("disp_ctgr4", Common.nvl(request.getParameter("disp_ctgr4"), ""));

map.put("p_dsc_amt_rt", 50);
map.put("p_max_dsc_amt", 10);
map.put("p_min_ord_amt", 10);
*/

/*
map.put("p_cupn_no", Common.nvl(request.getParameter("S_TMPL_CUPN_NO"), ""));
map.put("p_cupn_nm", Common.nvl(request.getParameter("DISP_NAME"), ""));
map.put("p_cupn_dsc_mthd_cd", Common.nvl(request.getParameter("p_cupn_dsc_mthd_cd"), ""));

map.put("p_dsc_amt_rt", 50);
map.put("p_max_dsc_amt", 10);
map.put("p_min_ord_amt", 10);
map.put("p_iss_cn_bgn_dt", transFormat.parse("2007-12-22 15:25:46"));
map.put("p_iss_cn_end_dt", transFormat.parse("9999-12-31 23:59:59"));
map.put("p_eftv_bgn_dt", transFormat.parse("2007-12-22 15:25:46"));
map.put("p_eftv_end_dt", transFormat.parse("9999-12-31 23:59:59"));
map.put("p_wire_wirelss_clf_cd", "01");
map.put("p_create_id", "testnew");
map.put("p_aprv_id", "testnew");

*/
/*
{ call PKG_MT_CUPN_CRM.copy_coupon
    (
      '1097119028',
      '타운11번가 12월 3천원할인',
      '01',
      50,
      10,
      10,
      to_timestamp('12/22/2007 15:25:46.000', 'mm/dd/yyyy hh24:mi:ss.ff3'),
      to_timestamp('12/31/9999 23:59:59.000', 'mm/dd/yyyy hh24:mi:ss.ff3'),
      to_timestamp('12/22/2007 15:25:46.000', 'mm/dd/yyyy hh24:mi:ss.ff3'),
      to_timestamp('12/31/9999 23:59:59.000', 'mm/dd/yyyy hh24:mi:ss.ff3'),
      '01',
      'testnew',
      'testnew',
      '<OUT>'
    )
  }

    { call PKG_MT_CUPN_CRM.copy_coupon
          (
            1097119028,
            '타운11번가 12월 3천원할인',
            '01',
            3000,
            0,
            50000,
            to_timestamp('12/05/2013 00:00:00.000', 'mm/dd/yyyy hh24:mi:ss.ff3'),
            to_timestamp('12/31/2013 23:59:59.000', 'mm/dd/yyyy hh24:mi:ss.ff3'),
            to_timestamp('12/05/2013 00:00:00.000', 'mm/dd/yyyy hh24:mi:ss.ff3'),
            to_timestamp('12/31/2013 23:59:59.000', 'mm/dd/yyyy hh24:mi:ss.ff3'),
            '01',
            'testnew',
            'testnew',
            '<OUT>'
          )
        }

*/