package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.NoticeDAO;
import com.skplanet.sascm.object.UaextNoticeBO;

/**
 * NoticeDAOImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("noticeDAO")
public class NoticeDAOImpl extends AbstractDAO implements NoticeDAO {

	/**
	 * 공지사항 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<UaextNoticeBO> getNoticeList(Map<String, Object> param) throws SQLException {
		return (List<UaextNoticeBO>) selectList("Notice.getNoticeList", param);
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
	public String getNoticeListCnt(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Notice.getNoticeListCnt", param);
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
	@SuppressWarnings("unchecked")
	@Override
	public List<UaextNoticeBO> getNoticeList2(Map<String, Object> param) throws SQLException {
		return (List<UaextNoticeBO>) selectList("Notice.getNoticeList2", param);
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
	public String getNoticeListCnt2(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Notice.getNoticeListCnt2", param);
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
	public UaextNoticeBO getNoticeDetail(Map<String, Object> param) throws SQLException {
		return (UaextNoticeBO) selectOne("Notice.getNoticeDetail", param);
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
	public int setNoticeDetail(Map<String, Object> param) throws SQLException {
		return (int) update("Notice.setNoticeDetail", param);
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
	public int delteNoticeDetail(Map<String, Object> param) throws SQLException {
		return (int) delete("Notice.delteNoticeDetail", param);
	}
}
