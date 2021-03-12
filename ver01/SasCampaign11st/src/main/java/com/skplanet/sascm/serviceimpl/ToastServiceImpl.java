package com.skplanet.sascm.serviceimpl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.ToastDAO;
import com.skplanet.sascm.object.ToastMsgMstrSrcBO;
import com.skplanet.sascm.service.ToastService;

/**
 * ToastServiceImpl
 * 
 * @author 김일범
 * @since 2013-12-05
 * @version $Revision$
 */
@Service("toastService")
public class ToastServiceImpl implements ToastService {

	@Resource(name = "toastDAO")
	private ToastDAO toastDAO;

	/**
	 * 토스트 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<ToastMsgMstrSrcBO> getToastList(Map<String, Object> param) throws Exception {
		return toastDAO.getToastList(param);
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
	public String getToastListCnt(Map<String, Object> param) throws Exception {
		return toastDAO.getToastListCnt(param);
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
	public ToastMsgMstrSrcBO getToastDetail(Map<String, Object> param) throws Exception {
		return toastDAO.getToastDetail(param);
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
	public int setToastDetail(Map<String, Object> param) throws Exception {
		return toastDAO.setToastDetail(param);
	}

}
