package com.skplanet.sascm.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.skplanet.sascm.common.util.StringUtil;
import com.skplanet.sascm.object.UsmUserBO;
import com.skplanet.sascm.service.LoginService;
import com.skplanet.sascm.service.SessionService;
import com.skplanet.sascm.util.Flag;
import com.skplanet.sascm.vo.MemberVO;
import com.skplanet.sascm.vo.SessionVO;


@Controller
public class LoginController {

	private static final Logger logger = LoggerFactory .getLogger(LoginController.class);

	@Inject
	private LoginService loginService;

	@Inject
	private SessionService sessionService;

	@SuppressWarnings("unused")
	@Inject
	private StringUtil stringUtil;

	@Inject
	private MessageSourceAccessor messageSourceAccessor;

	/**
	 * <pre>
	 * Description	:  Logn 화면
	 * </pre>
	 *
	 * @Method Name : login
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login.do", method = RequestMethod.GET)
	public String login(HttpServletRequest request, Model model) throws Exception {
		try {
			if (sessionService.getSession(request) != null){
				new ModelAndView("redirect:/main.do");
			}
		} catch (Exception e) {
			e.printStackTrace();
			sessionService.removeMuzSession(request);
		}
		return "login";
	}

	@RequestMapping(value = "/loginReload.do", method = RequestMethod.GET)
	public String loginReload(HttpServletRequest request, Model model) throws Exception {
		return "loginReload";
	}

	/**
	 * <pre>
	 * Description	:  Login 처리 Ajax
	 * </pre>
	 *
	 * @Method Name : loginProc
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ajax_login_proc.do", method = RequestMethod.POST)
	public String loginProc(HttpServletRequest request, Model model) throws Exception {
		Map<String, Object> jsonModel = new HashMap<String, Object>();

		MemberVO memberVo = new MemberVO();
		if (Flag.flag) System.out.println(">>>>> " + request.getParameter("id"));
		memberVo.setUserid(request.getParameter("id").replace("@saspw", ""));
		//memberVo.setUserPw(stringUtil.strSHA256("1234"));

		if (StringUtil.isNull(memberVo.getUserid())) {
			/* ID 오류 */
			jsonModel.put("code", messageSourceAccessor.getMessage("login.error.code"));
			jsonModel.put("msg", messageSourceAccessor .getMessage("login.error.message001"));

			System.out.println("Login PROC 1 @@@@@@@@@@@@@@@@@@@@");
//		} else if (StringUtil.isNull(memberVo.getUserPw())) {
//			 PW 오류
//			jsonModel.put("code",
//					messageSourceAccessor.getMessage("login.error.code"));
//			jsonModel.put("msg", messageSourceAccessor
//					.getMessage("login.error.message002"));
		} else {
			try {
				List<SessionVO> resultVo = new ArrayList<SessionVO>();
				//List<SessionVO> resultVo = loginService.getLoginInfo(memberVo);
				SessionVO sessionVo = new SessionVO();
				sessionVo.setUserId(memberVo.getUserid());
				sessionVo.setUserType("USER000099");
				resultVo.add(0, sessionVo);

				logger.debug("#########################");
				if (resultVo.size()==0) {
					 //ID/PW 오류
					jsonModel.put("code", messageSourceAccessor .getMessage("login.error.code"));
					jsonModel.put("msg", messageSourceAccessor .getMessage("login.error.message003"));
					System.out.println("Login PROC 2 @@@@@@@@@@@@@@@@@@@@");
				} else {
					jsonModel.put("code", messageSourceAccessor.getMessage("login.success.code"));

					SessionVO loginVo = resultVo.get(0);

					memberVo = this.loginService.getMemberView(memberVo);

					UsmUserBO bo = new UsmUserBO();
					bo.setName(memberVo.getUserid());
					bo.setId(Integer.toString(memberVo.getId()));

					// 세션 처리
					HttpSession session = request.getSession(false);
					if (session != null) {
						session.invalidate();  //초기화
					}
					session = request.getSession(true);
					session.setAttribute("ACCOUNT", bo);

					System.out.println(">>>>> session name : " + bo.getName());
					System.out.println(">>>>> session id : " + bo.getId());

					this.sessionService.setSession(request, loginVo);
				}
			} catch (Exception e) {
				logger.debug("LoginController exception");
				e.printStackTrace();
			}
		}

		model.addAllAttributes(jsonModel);

		return "jsonView";
	}

	@RequestMapping(value = "/autherror.do", method = RequestMethod.GET)
	public String autherror(Model model) throws Exception {
		return "autherror";
	}

	@RequestMapping(value = "/logout.do", method = RequestMethod.GET)
	public String logout(HttpServletRequest request,Model model) throws Exception {
		HttpSession session = request.getSession();
		session.invalidate();

		return "login";
	}
}
