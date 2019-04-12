package com.skplanet.sascm.controller;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.skplanet.sascm.vo.MemberVO;

@Service
public class LoginValidate implements Validator {

	@SuppressWarnings("unused")
	@Inject
	private MessageSourceAccessor messageSourceAccessor;

	/**
	 *
	 */
	public boolean supports(Class<?> arg0) {
		return MemberVO.class.isAssignableFrom(arg0);
	}

	/**
	 *
	 */
	@Override
	public void validate(Object target, Errors errors) {
	}

	/**
	 *
	 * @param arg0
	 * @return
	 */
	public Map<String,Object> validate(Object arg0) {
		@SuppressWarnings("unused")
		MemberVO memberVO = (MemberVO) arg0;

		Map<String,Object> map = new HashMap<String,Object>();
		/*
		if (StringUtil.isNull(memberVO.getId())) {
			map.put("code", "99");
			map.put("msg", messageSourceAccessor
					.getMessage("login.error.message001"));
		}

		if (StringUtil.isNull(memberVO.get())) {
			map.put("code", "99");
			map.put("msg", messageSourceAccessor
					.getMessage("login.error.message001"));
		}
		*/
		return map;
	}
}