package com.skplanet.sascm.service;

import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.UaextCodeDtlBO;
import com.skplanet.sascm.object.UaextCodeMstBO;

/**
 * CommCodeService
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface CommCodeService {

	/**
	 * 공통코드 마스터 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<UaextCodeMstBO> getCommCodeList(Map<String, Object> param) throws Exception;

	/**
	 * 공통코드 마스터 목록 건수 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCommCodeListCnt(Map<String, Object> param) throws Exception;

	/**
	 * 공통코드 상세 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<UaextCodeDtlBO> getCommCodeDtlList(Map<String, Object> param) throws Exception;

	/**
	 * 공통코드 상세 목록 조회 2  // KANG-20200415: add
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<UaextCodeDtlBO> getCommCodeDtlList2(Map<String, Object> param) throws Exception;  // KANG-20200415: add

	/**
	 * 공통코드 마스터 중복 여부 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCommCodeDupCnt(Map<String, Object> param) throws Exception;

	/**
	 * 공통코드 상세 중복 여부 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getCommCodeDtlDupCnt(Map<String, Object> param) throws Exception;

	/**
	 * 공통코드 마스터 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCommCodeMst(Map<String, Object> param) throws Exception;

	/**
	 * 공통코드 마스터 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int updateCommCodeMst(Map<String, Object> param) throws Exception;

	/**
	 * 공통코드 마스터 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public UaextCodeMstBO getCommCodeMst(Map<String, Object> param) throws Exception;

	/**
	 * 공통코드 상세 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setCommCodeDtl(Map<String, Object> param) throws Exception;

	/**
	 * 공통코드 상세 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int updateCommCodeDtl(Map<String, Object> param) throws Exception;


	/**
	 * 공통코드 상세코드 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public UaextCodeDtlBO getCommCodeDtl(Map<String, Object> param) throws Exception;
}
