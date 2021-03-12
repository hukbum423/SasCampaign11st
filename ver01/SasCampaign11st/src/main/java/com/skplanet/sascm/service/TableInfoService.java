package com.skplanet.sascm.service;

import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.UaextTableInfoDtlBO;
import com.skplanet.sascm.object.UaextTableInfoMstBO;

/**
 * TableInfoService
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface TableInfoService {

	/**
	 * 테이블 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<UaextTableInfoMstBO> getTableInfoList(Map<String, Object> param) throws Exception;

	/**
	 * 테이블 목록 전체 건수
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getTableInfoListCnt(Map<String, Object> param) throws Exception;

	/**
	 * 테이블 마스터 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public UaextTableInfoMstBO getTableInfoMaster(Map<String, Object> param) throws Exception;

	/**
	 * 테이블 마스터 중복 체크
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public String getTableInfoMstDupCnt(Map<String, Object> param) throws Exception;

	/**
	 * 테이블 마스터 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setTableInfoMst(Map<String, Object> param) throws Exception;

	/**
	 * 테이블 마스터 정보 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int updateTableInfoMst(Map<String, Object> param) throws Exception;

	/**
	 * 테이블 마스터 정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int deleteTableInfoMst(Map<String, Object> param) throws Exception;

	/**
	 * 테이블 상세정보 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public List<UaextTableInfoDtlBO> getTableInfoDetail(Map<String, Object> param) throws Exception;

	/**
	 * 테이블 상세정보 저장
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int setTableInfoDetail(Map<String, Object> param) throws Exception;
	
	/**
	 * 테이블 상세정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	public int deleteTableInfoDetailAll(Map<String, Object> param) throws Exception;

}
