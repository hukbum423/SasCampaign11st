package com.skplanet.sascm.daoimpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.dao.TableInfoDAO;
import com.skplanet.sascm.object.UaextTableInfoDtlBO;
import com.skplanet.sascm.object.UaextTableInfoMstBO;

/**
 * TableInfoDAOImpl
 *
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Repository("tableInfoDAO")
public class TableInfoDAOImpl  extends AbstractDAO implements TableInfoDAO {

	/**
	 * 테이블 목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<UaextTableInfoMstBO> getTableInfoList(Map<String, Object> param) throws SQLException {
		return (List<UaextTableInfoMstBO>) selectList("TableInfo.getTableInfoList", param);
	}

	/**
	 * 테이블 목록 전체 건수
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getTableInfoListCnt(Map<String, Object> param) throws SQLException {
		return (String) selectOne("TableInfo.getTableInfoListCnt", param);
	}

	/**
	 * 테이블 마스터 상세 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public UaextTableInfoMstBO getTableInfoMaster(Map<String, Object> param) throws SQLException {
		return (UaextTableInfoMstBO) selectOne("TableInfo.getTableInfoMaster", param);
	}

	/**
	 * 테이블 마스터 중복 체크
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getTableInfoMstDupCnt(Map<String, Object> param) throws SQLException {
		return (String) selectOne("TableInfo.getTableInfoMstDupCnt", param);
	}

	/**
	 * 테이블 마스터 정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setTableInfoMst(Map<String, Object> param) throws SQLException {
		return (int) update("TableInfo.setTableInfoMst", param);
	}

	/**
	 * 테이블 마스터 정보 수정
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int updateTableInfoMst(Map<String, Object> param) throws SQLException {
		return (int) update("TableInfo.updateTableInfoMst", param);
	}

	/**
	 * 테이블 마스터 정보 삭제
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int deleteTableInfoMst(Map<String, Object> param) throws SQLException {
		return (int) delete("TableInfo.deleteTableInfoMst", param);
	}

	/**
	 * 테이블 상세정보 목록 조회
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<UaextTableInfoDtlBO> getTableInfoDetail(Map<String, Object> param) throws SQLException {
		return (List<UaextTableInfoDtlBO>) selectList("TableInfo.getTableInfoDetail", param);
	}

	/**
	 * 테이블 상세정보 저장
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setTableInfoDetail(Map<String, Object> param) throws SQLException {
		return (int) update("TableInfo.setTableInfoDetail", param);
	}

	/**
	 * 테이블 상세정보 삭제
	 *
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int deleteTableInfoDetailAll(Map<String, Object> param) throws SQLException {
		return (int) delete("TableInfo.deleteTableInfoDetailAll", param);
	}
}
