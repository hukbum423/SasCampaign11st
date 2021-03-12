package com.skplanet.sascm.serviceimpl;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.skplanet.sascm.dao.MemberDAO;
import com.skplanet.sascm.service.MemberService;
import com.skplanet.sascm.vo.MemberVO;


/**
 * <pre>
 * com.skplanet.sascm.member.service
 * MemberServiceImpl.java
 * </pre>
 *
 * @Author 		: dev
 * @Date		: 2015. 9. 22.
 * @Version	: 
 */
@Service
public class MemberServiceImpl implements MemberService {

	@Inject
	private MemberDAO memberDao;
	
	@Override
	public List<MemberVO> getMemberLit(MemberVO memberVo) throws Exception {
		return (List<MemberVO>) memberDao.getMemberList(memberVo);
	}

	@Override
	public MemberVO getMemberView(MemberVO memberVo) throws Exception {
		return (MemberVO) memberDao.getMemberView(memberVo);
	}

	@Override
	public MemberVO ajaxUserType(MemberVO memberVo) throws Exception {
		return (MemberVO) memberDao.ajaxUserType(memberVo);
	}

	@Override
	public void updateMemberUserType(MemberVO memberVo) throws Exception {
		memberDao.updateMemberUserType(memberVo);
	}

	@Override
	public MemberVO getMemberTotalCnt() throws Exception {
		return memberDao.getMemberTotalCnt();
	}

}
