package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.ToastDAO;
import com.skplanet.sascm.object.ToastMsgMstrSrcBO;

/**
 * ToastDAOImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("toastDAO")
public class ToastDAOImpl extends AbstractDAO implements ToastDAO {

	/**
	 * 토스트 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<ToastMsgMstrSrcBO> getToastList(Map<String, Object> param) throws SQLException {
		return (List<ToastMsgMstrSrcBO>) selectList("Toast.getToastList", param);
	}

	/**
	 * 토스트 목록 전체 건수
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getToastListCnt(Map<String, Object> param) throws SQLException {
		return (String) selectOne("Toast.getToastListCnt", param);
	}

	/**
	 * 토스트 상세 보기
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public ToastMsgMstrSrcBO getToastDetail(Map<String, Object> param) throws SQLException {
		return (ToastMsgMstrSrcBO) selectOne("Toast.getToastDetail", param);
	}

	/**
	 * 토스트 상세 정보 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setToastDetail(Map<String, Object> param) throws SQLException {
		return (int) update("Toast.setToastDetail", param);
	}
}
