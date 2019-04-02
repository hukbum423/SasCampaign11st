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

import com.skplanet.sascm.object.UaextVariableBO;
import com.skplanet.sascm.object.UsmUserBO;
import com.skplanet.sascm.service.VariableService;
import com.skplanet.sascm.util.Common;

/**
 * VariableController
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Controller
public class VariableController {

	private final Log log = LogFactory.getLog(getClass());

	@Resource(name = "variableService")
	private VariableService variableService;

	//AJAX
	@Autowired
	private MappingJacksonJsonView jsonView;

	/**
	 * 매개변수 관리 목록 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/variable/variableList.do")
	public String pageVariableList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		//paramter
		log.info("=============================================");
		log.info("SVARI_NAME   : " + request.getParameter("SVARI_NAME"));
		log.info("SKEY_COLUMN  : " + request.getParameter("SKEY_COLUMN"));
		log.info("=============================================");

		modelMap.addAttribute("SVARI_NAME", request.getParameter("SVARI_NAME"));
		modelMap.addAttribute("SKEY_COLUMN", request.getParameter("SKEY_COLUMN"));
		modelMap.addAttribute("USER", (UsmUserBO) session.getAttribute("ACCOUNT"));

		return "variable/variableList";
	}

	/**
	 * 매개변수 목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/getVariableList.do")
	public void getVariableList(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, UaextVariableBO bo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("SVARI_NAME   : " + request.getParameter("SVARI_NAME"));
		log.info("SKEY_COLUMN  : " + request.getParameter("SKEY_COLUMN"));
		log.info("=============================================");

		//조회조건
		map.put("SVARI_NAME", Common.nvl(request.getParameter("SVARI_NAME"), ""));
		map.put("SKEY_COLUMN", Common.nvl(request.getParameter("SKEY_COLUMN"), ""));

		//매개변수 목록 조회
		List<UaextVariableBO> list = variableService.getVariableList(map);

		map.put("VariableList", list);

		jsonView.render(map, request, response);
	}

	/**
	 * 매개변수 관리 상세 페이지 호출
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/variable/variableDetail.do")
	public String pageVariableDetail(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, UaextVariableBO bo, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		//paramter
		log.info("=============================================");
		log.info("VARI_NAME    : " + request.getParameter("VARI_NAME"));
		log.info("SVARI_NAME   : " + request.getParameter("SVARI_NAME"));
		log.info("SKEY_COLUMN  : " + request.getParameter("SKEY_COLUMN"));
		log.info("TYPE         : " + request.getParameter("TYPE"));
		log.info("=============================================");

		//조회조건
		map.put("VARI_NAME", Common.nvl(request.getParameter("VARI_NAME"), ""));

		//고객ID 부가 정보 조회
		if (request.getParameter("VARI_NAME") != null && !request.getParameter("VARI_NAME").equals("")) {
			bo = variableService.getVariableDetail(map);

			modelMap.addAttribute("bo", bo);
		}

		modelMap.addAttribute("SVARI_NAME", request.getParameter("SVARI_NAME"));
		modelMap.addAttribute("SKEY_COLUMN", request.getParameter("SKEY_COLUMN"));
		modelMap.addAttribute("TYPE", request.getParameter("TYPE"));
		modelMap.addAttribute("USER", (UsmUserBO) session.getAttribute("ACCOUNT"));

		return "variable/variableDetail";
	}

	/**
	 * 매개변수 등록
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/setVariable.do")
	public void setVariable(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		UsmUserBO user = (UsmUserBO) session.getAttribute("ACCOUNT");

		log.info("=============================================");
		log.info("VARI_NAME   : " + request.getParameter("VARI_NAME"));
		log.info("KEY_COLUMN  : " + request.getParameter("KEY_COLUMN"));
		log.info("REF_TABLE   : " + request.getParameter("REF_TABLE"));
		log.info("REF_COLUMN  : " + request.getParameter("REF_COLUMN"));
		log.info("IF_NULL     : " + request.getParameter("IF_NULL"));
		log.info("MAX_BYTE    : " + request.getParameter("MAX_BYTE"));
		log.info("USE_YN      : " + request.getParameter("USE_YN"));
		log.info("TYPE        : " + request.getParameter("TYPE"));
		log.info("=============================================");

		//입력 값
		map.put("VARI_NAME", Common.nvl(request.getParameter("VARI_NAME"), ""));
		map.put("KEY_COLUMN", Common.nvl(request.getParameter("KEY_COLUMN"), ""));
		map.put("REF_TABLE", Common.nvl(request.getParameter("REF_TABLE"), ""));
		map.put("REF_COLUMN", Common.nvl(request.getParameter("REF_COLUMN"), ""));
		map.put("IF_NULL", Common.nvl(request.getParameter("IF_NULL"), ""));
		map.put("MAX_BYTE", Common.nvl(request.getParameter("MAX_BYTE"), ""));
		map.put("USE_YN", Common.nvl(request.getParameter("USE_YN"), ""));
		map.put("CREATE_ID", user.getId());
		map.put("UPDATE_ID", user.getId());

		//참조테이블, 참조컬럼, 키컬럼의 유효성을 체크
		String valiChk = "";
		try {
			valiChk = variableService.getVariableChk(map);
		} catch (Exception e) {
			valiChk = e.toString();
			log.info("유효하지 않은 매개변수 테이블 ::: " + e);
		}

		if(valiChk == null){
			valiChk = "Y";
		}

		map.put("valiChk", valiChk);

		if (valiChk.equals("Y")) { //정상일경우에만 저장
			//신규일때만 중복체크
			String dupChk = "";
			String type = request.getParameter("TYPE");

			if (type.equals("I")) {
				dupChk = variableService.getVariableDup(map);
				map.put("dup", dupChk);
			}

			if (dupChk.equals("N") && type.equals("I")) {
				variableService.setVariable(map);
			} else if (type.equals("U")) {
				variableService.updateVariable(map);
			}
		}

		jsonView.render(map, request, response);
	}

	/**
	 * 매개변수 삭제
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/deleteVariable.do")
	public void deleteVariable(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap, HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		log.info("=============================================");
		log.info("VARI_NAME   : " + request.getParameter("VARI_NAME"));
		log.info("=============================================");

		map.put("VARI_NAME", Common.nvl(request.getParameter("VARI_NAME"), ""));

		variableService.deleteVariable(map);

		jsonView.render(map, request, response);
	}
}
