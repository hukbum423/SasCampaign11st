package com.skplanet.sascm.service;

import java.util.List;
import java.util.Map;

import com.skplanet.sascm.object.UaextNoticeBO;

/**
 * NoticeService
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
public interface NoticeService {

  /**
   * 공지사항 목록 조회
   * 
   * @param request
   * @param response
   * @param modelMap
   * @return
   * @throws Exception
   */
  public List<UaextNoticeBO> getNoticeList(Map<String, Object> param) throws Exception;

  /**
   * 공지사항 목록 건수 조회
   * 
   * @param request
   * @param response
   * @param modelMap
   * @return
   * @throws Exception
   */
  public String getNoticeListCnt(Map<String, Object> param) throws Exception;

  /**
   * 공지사항 목록 조회(프론트용)
   * 
   * @param request
   * @param response
   * @param modelMap
   * @return
   * @throws Exception
   */
  public List<UaextNoticeBO> getNoticeList2(Map<String, Object> param) throws Exception;

  /**
   * 공지사항 목록 건수 조회(프론트용)
   * 
   * @param request
   * @param response
   * @param modelMap
   * @return
   * @throws Exception
   */
  public String getNoticeListCnt2(Map<String, Object> param) throws Exception;

  /**
   * 공지사항 상세 조회
   * 
   * @param request
   * @param response
   * @param modelMap
   * @return
   * @throws Exception
   */
  public UaextNoticeBO getNoticeDetail(Map<String, Object> param) throws Exception;

  /**
   * 공지사항 상세 조회
   * 
   * @param request
   * @param response
   * @param modelMap
   * @return
   * @throws Exception
   */
  public int setNoticeDetail(Map<String, Object> param) throws Exception;

  /**
   * 공지사항 삭제
   * 
   * @param request
   * @param response
   * @param modelMap
   * @return
   * @throws Exception
   */
  public int delteNoticeDetail(Map<String, Object> param) throws Exception;

}
