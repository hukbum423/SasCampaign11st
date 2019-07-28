package com.skplanet.sascm.serviceimpl;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.service.SessionService;
import com.skplanet.sascm.vo.SessionVO;

@Service
public class SessionServiceImpl implements SessionService {

	// session name
	private static final String SESSION = "sessionVo";

	public SessionVO getSession(HttpServletRequest request) throws Exception {
		return (SessionVO) getMuzSession(request, SESSION);
	}

	public void setSession(HttpServletRequest request, Object obj) throws Exception {
		setMuzSession(request, SESSION, obj);
	}

	// get session information from request
	public Object getMuzSession(HttpServletRequest request, String str) throws Exception {
		return request.getSession().getAttribute(str);
	}

	// set session information to request
	public void setMuzSession(HttpServletRequest request, String str, Object obj) throws Exception {
		request.getSession().setAttribute(str, obj);
	}

	// remove session
	public void removeMuzSession(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		if (session != null) {
			session.invalidate();
		}
	}
}
