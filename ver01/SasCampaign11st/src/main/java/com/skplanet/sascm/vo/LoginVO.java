package com.skplanet.sascm.vo;

import java.io.Serializable;

public class LoginVO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	/** 사용자 아이디 */
	private String userId;
	/** 사용자 비번 */
	private String userPw;
	/** 사용자 로그인여부 */
	private String loginYn;
	/** 사용자 권한(관리자,뮤지션,악기사,기획사) */
	private String userType;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPw() {
		return userPw;
	}
	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}
	public String getLoginYn() {
		return loginYn;
	}
	public void setLoginYn(String loginYn) {
		this.loginYn = loginYn;
	}
	public String getUserType() {
		return userType;
	}
	public void setUserType(String userType) {
		this.userType = userType;
	}
	
	
	
}