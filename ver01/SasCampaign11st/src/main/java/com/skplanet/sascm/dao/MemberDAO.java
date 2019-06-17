package com.skplanet.sascm.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.skplanet.sascm.common.dao.AbstractDAO;
import com.skplanet.sascm.vo.MemberVO;
/**
 * <pre>
 * com.skplanet.sascm.dao
 * MemberDAO.java
 * </pre>
 *
 * @Author 		: dev
 * @Date		: 2015. 9. 22.
 * @Version	:
 */
@Repository("memberDao")
public class MemberDAO extends AbstractDAO {

	/**
	 * <pre>
	 * Description	:  회원 리스트 조회
	 * </pre>
	 * @Method Name : getMemberLogin
	 *
	 * @param memberVo
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<MemberVO> getMemberList(MemberVO memberVo) throws Exception {
		return (List<MemberVO>) selectList("member.getMemberList", memberVo);
	}

	/**
	 * <pre>
	 * Description	:  회원정보 상세보기
	 * </pre>
	 * @Method Name : getMemberView
	 *
	 * @param memberVo
	 * @return
	 * @throws Exception
	 */
	public MemberVO getMemberView(MemberVO memberVo) throws Exception {
		return (MemberVO) selectOne("member.getMemberView", memberVo);
	}


	/**
	 * <pre>
	 * Description	:  회원 권한 수정
	 * </pre>
	 * @Method Name : updateMemberUserType
	 *
	 * @param memberVo
	 * @throws Exception
	 */
	public void updateMemberUserType(MemberVO memberVo) throws Exception {
		update("member.updateMemberUserType", memberVo);
	}

	/**
	 * <pre>
	 * Description	:  회원 권한 조회
	 * </pre>
	 * @Method Name : ajaxUserType
	 *
	 * @param memberVo
	 * @return
	 * @throws Exception
	 */
	public MemberVO ajaxUserType(MemberVO memberVo) throws Exception {
		return (MemberVO) selectOne("member.ajaxUserType", memberVo);
	}

	/**
	 * <pre>
	 * Description	:  회원 전체 카운트
	 * </pre>
	 * @Method Name : getMemberTotalCnt
	 *
	 * @return
	 * @throws Exception
	 */
	public MemberVO getMemberTotalCnt() throws Exception {
		return (MemberVO) selectOne("member.getMemberTotalCnt");
	}
}
