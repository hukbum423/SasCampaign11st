package com.skplanet.sascm.serviceimpl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.TableInfoDAO;
import com.skplanet.sascm.object.UaextTableInfoDtlBO;
import com.skplanet.sascm.object.UaextTableInfoMstBO;
import com.skplanet.sascm.service.TableInfoService;

/**
 * TableInfoServiceImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Service("tableInfoService")
public class TableInfoServiceImpl implements TableInfoService {

	@Resource(name = "tableInfoDAO")
	private TableInfoDAO tableInfoDAO;

	/**
	 * 테이블 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<UaextTableInfoMstBO> getTableInfoList(Map<String, Object> param) throws Exception {
		return tableInfoDAO.getTableInfoList(param);
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
	public String getTableInfoListCnt(Map<String, Object> param) throws Exception {
		return tableInfoDAO.getTableInfoListCnt(param);
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
	public UaextTableInfoMstBO getTableInfoMaster(Map<String, Object> param) throws Exception {
		return tableInfoDAO.getTableInfoMaster(param);
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
	public String getTableInfoMstDupCnt(Map<String, Object> param) throws Exception {
		return tableInfoDAO.getTableInfoMstDupCnt(param);
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
	public int setTableInfoMst(Map<String, Object> param) throws Exception {
		return tableInfoDAO.setTableInfoMst(param);
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
	public int updateTableInfoMst(Map<String, Object> param) throws Exception {
		return tableInfoDAO.updateTableInfoMst(param);
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
	public int deleteTableInfoMst(Map<String, Object> param) throws Exception {
		return tableInfoDAO.deleteTableInfoMst(param);
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
	@Override
	public List<UaextTableInfoDtlBO> getTableInfoDetail(Map<String, Object> param) throws Exception {
		return tableInfoDAO.getTableInfoDetail(param);
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
	public int setTableInfoDetail(Map<String, Object> param) throws Exception {
		return tableInfoDAO.setTableInfoDetail(param);
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
	public int deleteTableInfoDetailAll(Map<String, Object> param) throws Exception {
		return tableInfoDAO.deleteTableInfoDetailAll(param);
	}
}
