package com.skplanet.sascm.service;

import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.ToastMsgMstrSrcBO;

/**
 * ToastService
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface ToastService {

	/**
	 * 토스트 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<ToastMsgMstrSrcBO> getToastList(Map<String, Object> param) throws Exception;

	/**
	 * 토스트 목록 전체 건수
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getToastListCnt(Map<String, Object> param) throws Exception;

	/**
	 * 토스트 상세 보기
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public ToastMsgMstrSrcBO getToastDetail(Map<String, Object> param) throws Exception;

	/**
	 * 토스트 상세 정보 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setToastDetail(Map<String, Object> param) throws Exception;

}
