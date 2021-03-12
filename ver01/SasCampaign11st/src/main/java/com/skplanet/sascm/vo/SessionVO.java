package com.skplanet.sascm.vo;

import java.io.Serializable;

public class SessionVO implements Serializable {
	
	private static final long serialVersionUID = 1L;

	/** 사용자 아이디 */
	private String userId;
	/** 사용자 로그인여부 */
	private String loginYn;
	
	private String userType;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
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
