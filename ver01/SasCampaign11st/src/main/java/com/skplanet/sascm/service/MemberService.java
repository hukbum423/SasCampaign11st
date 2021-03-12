package com.skplanet.sascm.service;

import java.util.List;

import com.skplanet.sascm.vo.MemberVO;

/**
 * <pre>
 * com.skplanet.sascm.member.service
 * MemberService.java
 * </pre>
 *
 * @Author 		: dev
 * @Date		: 2015. 9. 22.
 * @Version	: 
 */
public interface MemberService {
	
	/**
	 * <pre>
	 * Description	:  회원리스트
	 * </pre>
	 * @Method Name : getMemberLit
	 *
	 * @param memberVo
	 * @return
	 * @throws Exception
	 */
	public List<MemberVO> getMemberLit(MemberVO memberVo) throws Exception;
	
	/**
	 * <pre>
	 * Description	:  회원 상세보기
	 * </pre>
	 * @Method Name : getMemberView
	 *
	 * @param memberVo
	 * @return
	 * @throws Exception
	 */
	public MemberVO getMemberView(MemberVO memberVo) throws Exception;
	
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
	public MemberVO ajaxUserType(MemberVO memberVo) throws Exception;
	
	/**
	 * <pre>
	 * Description	:  회원 권한 수정
	 * </pre>
	 * @Method Name : updateMemberUserType
	 *
	 * @param memberVo
	 * @throws Exception
	 */
	public void updateMemberUserType(MemberVO memberVo) throws Exception;
	
	/**
	 * <pre>
	 * Description	:  전체 회원 카운트
	 * </pre>
	 * @Method Name : getMemberTotalCnt
	 *
	 * @return
	 * @throws Exception
	 */
	public MemberVO getMemberTotalCnt() throws Exception;
	
}
