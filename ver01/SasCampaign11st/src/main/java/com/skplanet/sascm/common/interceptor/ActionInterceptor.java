package com.skplanet.sascm.common.interceptor;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.skplanet.sascm.service.SessionService;
import com.skplanet.sascm.util.Flag;
import com.skplanet.sascm.vo.SessionVO;

public class ActionInterceptor extends HandlerInterceptorAdapter {
	
	protected Log log = LogFactory.getLog(ActionInterceptor.class);

	// server.static.url = http://localhost
	@Value("#{contextProperties['server.static.url']}")
	private String staticURL;

	@Value("#{contextProperties['server.static.path']}")
	private String staticPATH;

	// server.static.url.sasurl = http://11campb-operwb-alp01:7980
	@Value("#{contextProperties['server.static.url.sasurl']}")
	private String staticPATHSasurl;

	// server.static.vaurl=http://11campb-operwb-alp01:7980
	@Value("#{contextProperties['server.static.vaurl']}")
	private String staticPATHSvaurl;

	// server.type.chk = DEV
	@Value("#{contextProperties['server.type.chk']}")
	private String staticServerType;

	// server.type.aprvid = admin
	@Value("#{contextProperties['server.type.aprvid']}")
	private String staticServerTypeAprvid;

	@Inject
	private SessionService sessionService;

	private static final String CMM_CODE = "USER000099";

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		if (log.isDebugEnabled()) {
			log.debug("KANG-20190308 ====================================== ActionInterceptor START  ======================================");
			log.debug("KANG-20190308 Request URI \t:  " + request.getRequestURI());
		}

		request.setAttribute("staticURL", staticURL);
		request.setAttribute("staticPATH", staticPATH);
		request.setAttribute("staticPATHSasurl", staticPATHSasurl);
		request.setAttribute("staticPATHSvaurl", staticPATHSvaurl);
		request.setAttribute("staticServerType", staticServerType);
		request.setAttribute("staticServerTypeAprvid", staticServerTypeAprvid);

		//String userId = null;
		String url = request.getRequestURI();

		SessionVO sessionVo = this.sessionService.getSession(request);

		HttpSession session = request.getSession(false);
		if (session == null) {
			if (Flag.flag) System.out.println("KANG-20190308: >>>>> session is null!!!");
		} else if (session.getAttribute("ACCOUNT") != null) {
			//userId = sessionVo.getUserId();
			if (sessionVo.getUserType().indexOf(CMM_CODE) == -1) {
				this.sessionService.removeMuzSession(request);
				throw new ModelAndViewDefiningException(new ModelAndView("redirect:/autherror.do"));
			}
			if (url.indexOf("/login.do") > -1) {
				new ModelAndView("redirect:/main.do");
			}
		} else {
			// no authentication
			if (url.indexOf("/login.do") > -1) {
				return true;
			} else if (url.indexOf("/ajax_login_proc.do") > -1) {   // controller.LoginController.loginProc()
				return true;
			} else if (url.indexOf("/loginReload.do") > -1) {
				return true;
			} else if (url.indexOf("/autherror.do") > -1) {
				return true;
			} else if (url.indexOf("/notice/getNoticeList.do") > -1) {
				return true;
			} else if (url.indexOf("/callCopyCoupon.do") > -1) {
				return true;
			} else if (url.indexOf("/Kang/") > -1) {
				return true;
			} else {
				throw new ModelAndViewDefiningException(new ModelAndView("redirect:/login.do?url="+url));
			}
		}

		return super.preHandle(request, response, handler);
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		if (log.isDebugEnabled()) {
			log.debug("KANG-20190308 ====================================== ActionInterceptor END ======================================\n");
		}
	}
}