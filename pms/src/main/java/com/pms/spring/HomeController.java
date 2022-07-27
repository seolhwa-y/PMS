package com.pms.spring;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.pms.beans.CerB;
import com.pms.beans.EmailCerB;
import com.pms.beans.ProBean;
import com.pms.services.Certification;
import com.pms.services.DashBoard;
import com.pms.services.Project;

@Controller
public class HomeController {
	@Autowired
	private Certification cer;
	@Autowired
	private Project project;
	@Autowired
	private DashBoard dBoard;

	// 랜딩페이지 
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		return "landing";
	}

	// 첫번째 페이지 - 로그인 페이지 :: 대쉬보드 페이지 
	@RequestMapping(value = "/First", method = RequestMethod.GET)
	public ModelAndView home(HttpServletRequest req, ModelAndView mav,@ModelAttribute CerB cb) {
		/* Developer : 설화 */
		cb.setAslPrivateIp(req.getRemoteAddr());
		mav.addObject(cb);
		this.cer.backController(0, mav);
		return mav;
	}

	// 회원가입 폼 이동 
	@RequestMapping(value="/MoveJoinForm", method= RequestMethod.GET)
	public ModelAndView joinForm(ModelAndView mav, @ModelAttribute CerB cb) {
		/* Developer : 설화 */
		this.cer.backController(1, mav);
		return mav;
	}

	// 회원가입 제어 
	@RequestMapping(value="/Join", method= RequestMethod.POST)
	public ModelAndView join(HttpServletRequest req, ModelAndView mav, @ModelAttribute CerB cb) {
		/* Developer : 설화 */
		cb.setAslPrivateIp(req.getRemoteAddr());
		mav.addObject(cb);
		this.cer.backController(2, mav);
		return mav;
	}

	// 로그인 제어 
	@RequestMapping(value = "/Auth", method = RequestMethod.POST)
	public ModelAndView auth(HttpServletRequest req,ModelAndView mav, @ModelAttribute CerB cb) {
		/* Developer : 설화 */
		cb.setAslPrivateIp(req.getRemoteAddr());
		mav.addObject(cb);
		this.cer.backController(3, mav);
		return mav;
	}

	// 로그아웃 제어 
	@RequestMapping(value="/Logout", method= RequestMethod.POST)
	public ModelAndView logOut(HttpServletRequest req, ModelAndView mav, @ModelAttribute CerB cb) {
		/* Developer : 설화 */
		this.cer.backController(4, mav);
		return mav;
	}

	// 프로젝트 페이지 이동 
	@RequestMapping(value="/NewProject", method= RequestMethod.POST)
	public ModelAndView newProject(HttpServletRequest req, ModelAndView mav, @ModelAttribute CerB cb) {
		/* Developer : 지수 */
		this.project.backController(0, mav);
		return mav;
	}

	// 프로젝트 생성 후 멤버 초대 
	@RequestMapping(value="/InviteMemberV", method= RequestMethod.POST)
	public ModelAndView inviteMember(HttpServletRequest req, ModelAndView mav, @ModelAttribute ProBean pro) {
		/* Developer : 지수 */
		mav.addObject(pro);
		this.project.backController(1, mav);
		System.out.println("hi");
		return mav;
	}

	// 대쉬보드 페이지 이동 
	@RequestMapping(value="/DashBoard", method= RequestMethod.POST)
	public ModelAndView dashBoard(HttpServletRequest req, ModelAndView mav, @ModelAttribute CerB cb) {
		/* Developer : 채이 */
		this.dBoard.backController(0, mav);
		return mav;
	}

	// 메일로 받은 인증코드 확인 후 UPDATE
	@RequestMapping(value="/EmailCodeCer", method= RequestMethod.POST)
	public ModelAndView acceptMember(HttpServletRequest req, ModelAndView mav, @ModelAttribute EmailCerB ecb) {
		/* Developer : 채이 */
		mav.addObject(ecb);
		this.dBoard.backController(1, mav);
		return mav;
	}
	
	// 
		@RequestMapping(value = "/MoveJobs", method = RequestMethod.POST)
		public ModelAndView moveJobs(HttpServletRequest req, ModelAndView mav,@ModelAttribute ProBean pro) {
	
			mav.addObject(pro);
			this.project.backController(2, mav);
			return mav;
		}
}
