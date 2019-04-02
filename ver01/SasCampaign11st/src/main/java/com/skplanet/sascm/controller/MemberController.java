package com.skplanet.sascm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.skplanet.sascm.common.BaseVO;
import com.skplanet.sascm.service.MemberService;
import com.skplanet.sascm.vo.MemberVO;

/**
 * <pre>
 * com.skplanet.sascm.member.controller
 * MemberController.java
 * </pre>
 *
 * @Author 		: dev
 * @Date		: 2015. 9. 22.
 * @Version	:
 */
@Controller
public class MemberController {

	@Inject
	private MemberService memberService;

	@Inject
	private MessageSourceAccessor messageSourceAccessor;

	/**
	 * <pre>
	 * Description	:  회원 목록
	 * </pre>
	 * @Method Name : list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/member/list.do", method = RequestMethod.GET)
	public String list(HttpServletRequest request, Model model) throws Exception {
		MemberVO resultVo = memberService.getMemberTotalCnt();

		MemberVO memberVo = new MemberVO();

		int page = 1;
		if(null != request.getParameter("page")){
			page = (Integer.parseInt(request.getParameter("page")));
		}

		int limitVal = (page - 1) * BaseVO.NUM_PER_PAGE;

		memberVo.setLimitVal(limitVal);
		memberVo.setNumPerPage(BaseVO.NUM_PER_PAGE);
		memberVo.setPagePerList(BaseVO.PAGE_PER_LIST);
		memberVo.setQuery("");
		memberVo.setTotalData(resultVo.getTotalData());
		memberVo.setPage(page);

		List<MemberVO> listVo = memberService.getMemberLit(memberVo);

		model.addAttribute("list", listVo);
		model.addAttribute("pageVo", memberVo);

		return "member/list";
	}

	@RequestMapping(value = "/member/view.do", method = RequestMethod.GET)
	public String view(HttpServletRequest request, Model model) throws Exception {
		@SuppressWarnings("unused")
		int userNum = Integer.parseInt(request.getParameter("num"));

		MemberVO memberVo = new MemberVO();
		//memberVo.setUserNum(userNum);

		MemberVO listVo = memberService.getMemberView(memberVo);

		model.addAttribute("view", listVo);

		return "member/view";
	}

	/**
	 * <pre>
	 * Description	:  사용자 권한 조회
	 * </pre>
	 * @Method Name : ajaxUserType
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/member/ajax_user_type.do", method = RequestMethod.POST)
	public String ajaxUserType(HttpServletRequest request, Model model) throws Exception {
		Map<String, Object> jsonModel = new HashMap<String, Object>();

		String userId = request.getParameter("user_id");

		if (null != userId) {
			MemberVO memberVo = new MemberVO();
			//memberVo.setUserId(userId);

			MemberVO resultVo = memberService.ajaxUserType(memberVo);

			jsonModel.put("code", messageSourceAccessor .getMessage("member.list.success.code"));
			jsonModel.put("result", resultVo);
		}else{
			jsonModel.put("code", messageSourceAccessor .getMessage("member.list.error.code"));
			jsonModel.put("msg", messageSourceAccessor .getMessage("member.list.message01"));
		}

		model.addAllAttributes(jsonModel);

		return "jsonView";
	}

	/**
	 * <pre>
	 * Description	:  회원 권한 수정
	 * </pre>
	 * @Method Name : userTypeProc
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "/member/user_type_proc.do", method = RequestMethod.POST)
	public String userTypeProc(HttpServletRequest request, Model model) throws Exception {
 		String userId 		= request.getParameter("user_id");
		String userType[] 	= request.getParameterValues("user_type");
		String tmp = "";

		for (int i = 0; i < userType.length; i++) {
			tmp = userType[i]+",";
		}
		MemberVO memberVo = new MemberVO();

		//memberVo.setUserId(userId);
		//memberVo.setUserType(tmp);

		memberService.updateMemberUserType(memberVo);

		return "redirect:/member/list.do";
	}
}
