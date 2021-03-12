package com.skplanet.sascm.serviceimpl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.NoticeDAO;
import com.skplanet.sascm.object.UaextNoticeBO;
import com.skplanet.sascm.service.NoticeService;

/**
 * NoticeServiceImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Service("noticeService")
public class NoticeServiceImpl implements NoticeService {

	@Resource(name = "noticeDAO")
	private NoticeDAO noticeDAO;

	/**
	 * 공지사항 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<UaextNoticeBO> getNoticeList(Map<String, Object> param) throws Exception {
		return noticeDAO.getNoticeList(param);
	}

	/**
	 * 공지사항 목록 건수 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getNoticeListCnt(Map<String, Object> param) throws Exception {
		return noticeDAO.getNoticeListCnt(param);
	}

	/**
	 * 공지사항 목록 조회(프론트용)
 	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<UaextNoticeBO> getNoticeList2(Map<String, Object> param) throws Exception {
		return noticeDAO.getNoticeList2(param);
	}

	/**
	 * 공지사항 목록 건수 조회(프론트용)
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getNoticeListCnt2(Map<String, Object> param) throws Exception {
		return noticeDAO.getNoticeListCnt2(param);
	}

	/**
	 * 공지사항 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public UaextNoticeBO getNoticeDetail(Map<String, Object> param) throws Exception {
		return noticeDAO.getNoticeDetail(param);
	}

	/**
	 * 공지사항 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setNoticeDetail(Map<String, Object> param) throws Exception {
		return noticeDAO.setNoticeDetail(param);
	}

	/**
	 * 공지사항 삭제
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int delteNoticeDetail(Map<String, Object> param) throws Exception {
		return noticeDAO.delteNoticeDetail(param);
	}

}
