package com.skplanet.sascm.serviceimpl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.CommCodeDAO;
import com.skplanet.sascm.object.UaextCodeDtlBO;
import com.skplanet.sascm.object.UaextCodeMstBO;
import com.skplanet.sascm.service.CommCodeService;

/**
 * CommCodeServiceImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Service("commCodeService")
public class CommCodeServiceImpl implements CommCodeService {

	@Resource(name = "commCodeDAO")
	private CommCodeDAO commCodeDAO;

	/**
	 * 공통코드 마스터 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<UaextCodeMstBO> getCommCodeList(Map<String, Object> param) throws Exception {
		return commCodeDAO.getCommCodeList(param);
	}

	/**
	 * 공통코드 마스터 목록 건수 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCommCodeListCnt(Map<String, Object> param) throws Exception {
		return commCodeDAO.getCommCodeListCnt(param);
	}

	/**
	 * 공통코드 상세 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<UaextCodeDtlBO> getCommCodeDtlList(Map<String, Object> param) throws Exception {
		return commCodeDAO.getCommCodeDtlList(param);
	}

	/**
	 * 공통코드 상세 목록 조회 2   // KANG-20200415: add
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<UaextCodeDtlBO> getCommCodeDtlList2(Map<String, Object> param) throws Exception {
		return commCodeDAO.getCommCodeDtlList2(param);   // KANG-20200415: add
	}

	/**
	 * 공통코드 마스터 중복 여부 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCommCodeDupCnt(Map<String, Object> param) throws Exception {
		return commCodeDAO.getCommCodeDupCnt(param);
	}

	/**
	 * 공통코드 상세 중복 여부 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String getCommCodeDtlDupCnt(Map<String, Object> param) throws Exception {
		return commCodeDAO.getCommCodeDtlDupCnt(param);
	}

	/**
	 * 공통코드 마스터 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCommCodeMst(Map<String, Object> param) throws Exception {
		return commCodeDAO.setCommCodeMst(param);
	}

	/**
	 * 공통코드 마스터 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int updateCommCodeMst(Map<String, Object> param) throws Exception {
		return commCodeDAO.updateCommCodeMst(param);
	}

	/**
	 * 공통코드 마스터 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public UaextCodeMstBO getCommCodeMst(Map<String, Object> param) throws Exception {
		return commCodeDAO.getCommCodeMst(param);
	}

	/**
	 * 공통코드 상세 등록
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int setCommCodeDtl(Map<String, Object> param) throws Exception {
		return commCodeDAO.setCommCodeDtl(param);
	}

	/**
	 * 공통코드 상세 수정
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public int updateCommCodeDtl(Map<String, Object> param) throws Exception {
		return commCodeDAO.updateCommCodeDtl(param);
	}

	/**
	 * 공통코드 상세코드 상세 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public UaextCodeDtlBO getCommCodeDtl(Map<String, Object> param) throws Exception {
		return commCodeDAO.getCommCodeDtl(param);
	}
}
