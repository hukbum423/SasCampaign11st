package com.skplanet.sascm.controller;

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
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.view.json.MappingJacksonJsonView;

import com.skplanet.sascm.object.UaextCampaignTesterBO;
import com.skplanet.sascm.object.UsmUserBO;
import com.skplanet.sascm.service.TestTargetService;
import com.skplanet.sascm.util.Common;


@Controller
public class TestTargetController {

	private final Log log = LogFactory.getLog(getClass());

	@Resource(name = "testTargetService")
	private TestTargetService testTargetService;

	//AJAX
	@Autowired
	private MappingJacksonJsonView jsonView;

	/**
	 * 테스트 대상자 목록 페이지 호출
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/testTarget/testTargetList.do")
	public String pageTestTargetList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//paramter
		log.info("=============================================");
		log.info("SMEM_ID   : " + request.getParameter("SMEM_ID"));
		log.info("=============================================");

		modelMap.addAttribute("SMEM_ID", request.getParameter("SMEM_ID"));
		modelMap.addAttribute("USER", (UsmUserBO) session.getAttribute("ACCOUNT"));

		return "testTarget/testTargetList";
	}

	/**
	 * 테스트 대상자 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getTestTargetList.do")
	public void getTestTargetList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, UaextCampaignTesterBO bo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("SMEM_ID   : " + request.getParameter("SMEM_ID"));
		log.info("=============================================");

		//조회조건
		map.put("SMEM_ID", Common.nvl(request.getParameter("SMEM_ID"), ""));

		//테스트 대상 목록 조회
		List<UaextCampaignTesterBO> list = testTargetService.getTestTargetList(map);

		map.put("TestTargetList", list);

		jsonView.render(map, request, response);
	}

	/**
	 * 테스트 대상자 ID유효성 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getTestTargetMemId.do")
	public void getTestTargetMemId(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("MEM_ID    : " + request.getParameter("MEM_ID"));
		log.info("=============================================");

		//조회조건
		map.put("MEM_ID", Common.nvl(request.getParameter("MEM_ID"), ""));

		//고객id 존재여부 체크
		String chk = testTargetService.getTestTargetMemIdChk(map);

		if (!chk.equals("Y")) {//고객id가 미존재 할 경우
			map.put("chk", "N");
		} else {
			//테스트 대상 고객id 중복체크
			chk = testTargetService.getTestTargetMemIdDup(map);

			if (chk.equals("Y")) { //중복 id 
				map.put("chk", "D"); //중복ID		
			} else {
				map.put("chk", "Y"); //등록가능		
			}
		}

		log.info("=============================================");
		log.info("chk      : " + chk);
		log.info("=============================================");

		jsonView.render(map, request, response);
	}

	/**
	 * 테스트 대상자 상세 페이지 호출
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/testTarget/testTargetDetail.do")
	public String pageTestTargetDetail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, UaextCampaignTesterBO bo, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		log.info("=============================================");
		log.info("SMEM_ID   : " + request.getParameter("SMEM_ID"));
		log.info("MEM_ID    : " + request.getParameter("MEM_ID"));
		log.info("TYPE      : " + request.getParameter("TYPE"));
		log.info("=============================================");

		//조회조건
		map.put("MEM_ID", Common.nvl(request.getParameter("MEM_ID"), ""));

		//고객ID 부가 정보 조회
		if (request.getParameter("MEM_ID") != null && !request.getParameter("MEM_ID").equals("")) {
			bo = testTargetService.getTestTargetMemIdDtl(map);
			List<UaextCampaignTesterBO> list = testTargetService.getTestTargetMemIdPcList(map); //PCID 목록

			modelMap.addAttribute("bo", bo);
			modelMap.addAttribute("list", list);
			modelMap.addAttribute("MEM_ID", request.getParameter("MEM_ID"));
		}

		modelMap.addAttribute("SMEM_ID", request.getParameter("SMEM_ID"));
		modelMap.addAttribute("TYPE", request.getParameter("TYPE"));
		modelMap.addAttribute("USER", (UsmUserBO) session.getAttribute("ACCOUNT"));

		return "testTarget/testTargetDetail";
	}

	/**
	 * 테스트 대상자 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setTestTargetMemId.do")
	public void setTestTargetMemId(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		log.info("=============================================");
		log.info("MEM_ID    : " + request.getParameter("MEM_ID"));
		log.info("USE_YN    : " + request.getParameter("USE_YN"));
		log.info("TYPE      : " + request.getParameter("TYPE"));
		log.info("=============================================");

		//입력 값
		map.put("MEM_ID", Common.nvl(request.getParameter("MEM_ID"), ""));
		map.put("USE_YN", Common.nvl(request.getParameter("USE_YN"), ""));
		map.put("CREATE_ID", user.getId());
		map.put("UPDATE_ID", user.getId());

		//신규일때만 중복체크
		String dupChk = "";
		String type = request.getParameter("TYPE");

		//고객id 존재여부 체크
		String chk = testTargetService.getTestTargetMemIdChk(map);

		if (!chk.equals("Y")) {//고객id가 미존재 할 경우
			map.put("chk", "N");
		} else {
			if (type.equals("I")) {
				dupChk = testTargetService.getTestTargetMemIdDup(map);
				map.put("dup", dupChk);
			}

			if (dupChk.equals("N") && type.equals("I")) {
				testTargetService.setTestTargetMemId(map);
			} else if (type.equals("U")) {
				testTargetService.updateTestTargetMemId(map);
			}
		}

		jsonView.render(map, request, response);
	}

	/**
	 * 테스트 대상자 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/deleteTestTargetMemId.do")
	public void deleteTestTargetMemId(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		log.info("=============================================");
		log.info("MEM_ID    : " + request.getParameter("MEM_ID"));
		log.info("=============================================");

		//입력 값
		map.put("MEM_ID", Common.nvl(request.getParameter("MEM_ID"), ""));

		testTargetService.deleteTestTargetMemId(map);

		jsonView.render(map, request, response);
	}
}
