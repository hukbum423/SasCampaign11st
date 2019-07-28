package com.skplanet.sascm.serviceimpl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.LoginDAO;
import com.skplanet.sascm.service.LoginService;
import com.skplanet.sascm.vo.MemberVO;
import com.skplanet.sascm.vo.SessionVO;

/**
 * <pre>
 * com.skplanet.sascm.login.service
 * LoginServiceImpl.java
 * </pre>
 *
 * @Author 		: dev
 * @Date		: 2015. 9. 21.
 * @Version	: 
 */
@Service
public class LoginServiceImpl implements LoginService {

	@Inject
	private LoginDAO loginDao;

	public List<SessionVO> getLoginInfo(MemberVO memberVo) throws Exception {
		return (List<SessionVO>) this.loginDao.getMemberLogin(memberVo);
	}
	
	public MemberVO getMemberView(MemberVO memberVo) throws Exception {
		return (MemberVO) this.loginDao.getMemberView(memberVo);
	}
}
