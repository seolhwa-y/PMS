package com.pms.services;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.mail.internet.MailDateFormat;
import javax.mail.internet.MimeMessage;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

import com.pms.utils.*;
import com.pms.beans.*;
import com.pms.inter.*;

@Service
public class Project implements ServicesRule {

	@Autowired
	private SqlSessionTemplate session; // db 접근
	@Autowired
	private Encryption enc; // 암호화 복호화
	@Autowired
	private ProjectUtils pu; // 세션
	@Autowired
	private DashBoard dBoard; // 대쉬보드
	@Autowired
	private JavaMailSenderImpl mail; // 자바에서 메일 보내기

	public Project() {
	}

	/* FORM 방식 Controller */
	public void backController(int serviceCode, ModelAndView mav) {

		try {
			if (this.pu.getAttribute("accessInfo") != null) {
				switch (serviceCode) {
				case 0:
					this.entrance(mav);
					break;
				case 1:
					this.regProjectMembersCtl(mav);
					break;
				case 2:
					this.moveJobs(mav);
					break;
				case 3:
					this.moveMemberMgr(mav);
					break;
				case 4:
					this.newInviteMember(mav);
					break;
				default:
				}
			} else {
				mav.setViewName("login");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void newInviteMember(ModelAndView mav) {
		try {

			ProBean pro = (ProBean)mav.getModel().get("proBean");
			System.out.println(pro.getProMembers().get(0).getPmbCode());
			int result = this.session.insert("insProjectMembers", pro);
			String subject = "[초대장] 프로젝트 참여 초대";
			String sender = "zzanggirlji@naver.com";
			MimeMessage javaMail = mail.createMimeMessage();
			MimeMessageHelper mailHelper = new MimeMessageHelper(javaMail, "UTF-8");
			CerLogB log = null;
			for (int idx = 0; idx < result; idx++) {
				log = new CerLogB();
				if (!((CerB) this.pu.getAttribute("accessInfo")).getPmbCode()
						.equals(((ProBean) mav.getModel().get("proBean")).getProMembers().get(idx).getPmbCode())) {
					String content = "<H1>[PMS] 귀하를 프로젝트에 초대합니다.</H1><H3>아래의 인증코드를 시스템의 알림을 참고하여 수락하여 주시기 바랍니다.</H3><H2>인증코드 : "
							+ this.enc.aesEncode(((ProBean) mav.getModel().get("proBean")).getProCode(),
									((ProBean) mav.getModel().get("proBean")).getProMembers().get(idx).getProEmail())
							+ "</H2>";
					mailHelper.setFrom(sender);
					mailHelper.setTo(((ProBean) mav.getModel().get("proBean")).getProMembers().get(idx).getProEmail());
					mailHelper.setSubject(subject);
					mailHelper.setText(content, true);
					mail.send(javaMail);
					log.setProCode(pro.getProCode());
					log.setAuthResult("NA");
					log.setSpmbCode(((CerB) this.pu.getAttribute("accessInfo")).getPmbCode());
					log.setRpmbCode(((ProBean) mav.getModel().get("proBean")).getProMembers().get(idx).getPmbCode());
					this.session.insert("insAuthLog", log);
				} else {
					log.setAuthResult("AU");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.dBoard.backController(0, mav);
		
	}

	/* AJAX 방식 Controller */
	public void backController(int serviceCode, Model model) {
		try {
			if (this.pu.getAttribute("accessInfo") != null) {
				switch (serviceCode) {
				case 0:
					this.regProjectCtl(model);
					break;
				case 1:
					this.reSendEmailCtl(model);
					break;
				default:
				}
			} else {
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// ajax 메일재전송
	private void reSendEmailCtl(Model model) {

		try {
			String subject = "[초대장] 프로젝트 참여 초대";
			String sender = "zzanggirlji@naver.com";
			MimeMessage javaMail = mail.createMimeMessage();
			MimeMessageHelper mailHelper = new MimeMessageHelper(javaMail, "UTF-8");
			CerLogB log = null;
			
				log = new CerLogB();
					MemberMgrB mb = (MemberMgrB)model.getAttribute("memberMgrB");
					String content = "<H1>[PMS] 귀하를 프로젝트에 초대합니다.</H1><H3>아래의 인증코드를 시스템의 알림을 참고하여 수락하여 주시기 바랍니다.</H3><H2>인증코드 : "
							+ this.enc.aesEncode(mb.getProCode(),mb.getPmbEmail())
							+ "</H2>";
					mailHelper.setFrom(sender);
					mailHelper.setTo(mb.getPmbEmail());
					mailHelper.setSubject(subject);
					mailHelper.setText(content, true);
					mail.send(javaMail);
					log.setProCode(mb.getProCode());
					log.setAuthResult("NA");
					log.setSpmbCode(((CerB) this.pu.getAttribute("accessInfo")).getPmbCode());
					log.setRpmbCode(mb.getPmbCode());
					this.session.insert("insAuthLog", log);


		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	// 프로젝트 화면 이동
	private void entrance(ModelAndView mav) {
		mav.setViewName("newProject");
	}

	// 프로젝트 등록
	@Transactional
	private void regProjectCtl(Model model) {
		List<CerB> memberList = null;
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
		try {
			CerB cb = ((CerB) this.pu.getAttribute("accessInfo"));
			String proCode = sdf.format(date) + cb.getPmbCode();
			((ProBean) model.getAttribute("proBean")).setProCode(proCode);
			((ProBean) model.getAttribute("proBean")).setProVisible(
					(((ProBean) model.getAttribute("proBean")).getProVisible().equals("공개")) ? "T" : "F");
			if (this.convertToBoolean(this.session.insert("insProject", ((ProBean) model.getAttribute("proBean"))))) {
				memberList = this.session.selectList("getMembers", cb);
				memberList.get(0).setMessage(proCode);
				for (CerB ce : memberList) {
					System.out.println("GHKR DLS " +ce.getPmbName() );
					System.out.println("GHKR DLS " +this.enc.aesDecode(ce.getPmbName(), ce.getPmbCode()));
					ce.setPmbName(this.enc.aesDecode(ce.getPmbName(), ce.getPmbCode()));
					ce.setPmbEmail(this.enc.aesDecode(ce.getPmbEmail(), ce.getPmbCode()));
				}
			} else {
				memberList = new ArrayList<CerB>();
				cb = new CerB();
				cb.setMessage("프로젝트등록실패");
				memberList.add(cb);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("MemberList", memberList);
	}

	// 프로젝트 등록 후 멤버초대 메일
	private void regProjectMembersCtl(ModelAndView mav) {
		try {
			ProBean pro = (ProBean)mav.getModel().get("proBean");
			CerB auth = ((CerB) this.pu.getAttribute("accessInfo"));
			ProMemberB proB = new ProMemberB();
			proB.setPmbCode(auth.getPmbCode());
			proB.setProEmail(auth.getPmbEmail());
			proB.setProPosition("MG");
			proB.setProAccept("AC");
			((ProBean) mav.getModel().get("proBean")).getProMembers().add(proB);
			int result = this.session.insert("insProjectMembers", (ProBean) mav.getModel().get("proBean"));
			String subject = "[초대장] 프로젝트 참여 초대";
			String sender = "zzanggirlji@naver.com";
			MimeMessage javaMail = mail.createMimeMessage();
			MimeMessageHelper mailHelper = new MimeMessageHelper(javaMail, "UTF-8");
			CerLogB log = null;
			for (int idx = 0; idx < result; idx++) {
				log = new CerLogB();
				if (!((CerB) this.pu.getAttribute("accessInfo")).getPmbCode()
						.equals(((ProBean) mav.getModel().get("proBean")).getProMembers().get(idx).getPmbCode())) {
					String content = "<H1>[PMS] 귀하를 프로젝트에 초대합니다.</H1><H3>아래의 인증코드를 시스템의 알림을 참고하여 수락하여 주시기 바랍니다.</H3><H2>인증코드 : "
							+ this.enc.aesEncode(((ProBean) mav.getModel().get("proBean")).getProCode(),
									((ProBean) mav.getModel().get("proBean")).getProMembers().get(idx).getProEmail())
							+ "</H2>";
					mailHelper.setFrom(sender);
					mailHelper.setTo(((ProBean) mav.getModel().get("proBean")).getProMembers().get(idx).getProEmail());
					mailHelper.setSubject(subject);
					mailHelper.setText(content, true);
					mail.send(javaMail);
					log.setProCode(pro.getProCode());
					log.setAuthResult("NA");
					log.setSpmbCode(((CerB) this.pu.getAttribute("accessInfo")).getPmbCode());
					log.setRpmbCode(((ProBean) mav.getModel().get("proBean")).getProMembers().get(idx).getPmbCode());
					this.session.insert("insAuthLog", log);
				} else {
					log.setAuthResult("AU");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.dBoard.backController(0, mav);
	}
	
	// jobs 화면 이동
	private void moveJobs(ModelAndView mav) {
		System.out.println(((ProBean)mav.getModel().get("proBean")).getProCode());
		mav.setViewName("jobs");
	}
	
	// memberMgr 화면 이동
	private void moveMemberMgr(ModelAndView mav) { //mav proBean 도착
		System.out.println(((ProBean)mav.getModel().get("proBean")).getProCode());
		ProBean pro = ((ProBean)mav.getModel().get("proBean"));

		// 1번박스 초대보냈던 리스트
		// 1-1. proAccept = ac인 멤버 가져오기
		mav.addObject("sendList" ,this.makeAcList(this.session.selectList("getSendList", pro)));
		
		// 1-2  proAccept = st인 멤버 가져오기
		mav.addObject("stList",this.makeStList(this.session.selectList("getExpireSendList", pro)));
		
		// 2번박스 그외 초대가능한 새로운 멤버리스트
		mav.addObject("newList",this.makeNotInviteMember(this.session.selectList("notInviteMember", pro)) +"<input name='code' type='hidden' value = '"+pro.getProCode()+"'/>");
		
		/*
		// 3번박스 -> newProject.jsp에서 moveDiv참조 여기선x
	    */
		mav.setViewName("memberMgr");
	}

	
	// 1-1번 ac인 멤버 가져오기
	private String makeAcList(List<MemberMgrB> list) {
		StringBuffer sb = new StringBuffer();

		for(MemberMgrB mb: list) {
			if(mb.getPrmAccept().equals("AC")) {
					try {
						mb.setPmbName(this.enc.aesDecode(mb.getPmbName(), mb.getPmbCode()));
						mb.setPmbEmail(this.enc.aesDecode(mb.getPmbEmail(), mb.getPmbCode()));

						sb.append("<div name='acList' class='box multi' value='"+ mb.getPmbCode() +":"+mb.getPmbEmail()+"'>");
						sb.append("<span class='small' name='smailList'>"+ mb.getPmbCode() +"</span><br/>");
						sb.append("<span class='general'>"+ mb.getPmbName()+"</span>");
						sb.append("</div>");
					} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException
							| NoSuchPaddingException | InvalidAlgorithmParameterException | IllegalBlockSizeException
							| BadPaddingException e) {e.printStackTrace();}
			}
		}
		return sb.toString();
	}
	
	// 1-2번 st인 멤버 가져오기
	private String makeStList(List<MemberMgrB> list) {
		//st인 애들 가져오고 만료여부 확인
		StringBuffer sb = new StringBuffer();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		
		int idx = -1;
		for(MemberMgrB mb: list) {
				try {
					idx ++;
					if(!((CerB) this.pu.getAttribute("accessInfo")).getPmbCode().equals(mb.getPmbCode())) {
					boolean expired = Long.parseLong(mb.getExpireDate().substring(0))
							- Long.parseLong(sdf.format(new Date())) >= 0 ? true : false;
							
					mb.setPmbName(this.enc.aesDecode(mb.getPmbName(), mb.getPmbCode()));
					mb.setPmbEmail(this.enc.aesDecode(mb.getPmbEmail(), mb.getPmbCode()));

					sb.append("<div name='seList' class='box multi seList' value='"+ mb.getPmbCode() +":"+mb.getPmbEmail()+":"+ mb.getProCode() +"'>");
					sb.append("<span class='small' name='smailList'>"+ mb.getPmbCode() +"</span><br/>");
					sb.append("<span class='general'>"+ mb.getPmbName()+"</span>");
					//sb.append("<input type='hidden' value=" "/>")
					sb.append("<input name='resend' type='button' value='메일 재전송' onClick='window.resendEmail("+idx +")'" + (expired ? "disabled" : "")+"/>");
					// if~~ ac상태면 놔두고 st상태에서 인증만료가되면 메일재전송 버튼 만들어서 메일보내기 인증만료 전이면 그냥 st로 보이게
					sb.append("</div>");

					}
				} catch (Exception e) {e.printStackTrace();	}
			}
		return sb.toString();
	}
	
	// 2번박스 그외 초대가능한 새로운 멤버리스트
	private String makeNotInviteMember(List<MemberMgrB> list) {
		StringBuffer sb = new StringBuffer();

		for(MemberMgrB mb: list) {
				try {
					mb.setPmbName(this.enc.aesDecode(mb.getPmbName(), mb.getPmbCode()));
					mb.setPmbEmail(this.enc.aesDecode(mb.getPmbEmail(), mb.getPmbCode()));

					sb.append("<div ondblclick='window.moveDiv(this)' class='box multi' value='"+ mb.getPmbCode() +":"+mb.getPmbEmail()+"'>");
					sb.append("<span class='small' name='smailList'>"+ mb.getPmbCode() +"</span><br/>");
					sb.append("<span class='general'>"+ mb.getPmbName()+"</span>");
					sb.append("</div>");
				} catch (Exception e) {e.printStackTrace();	}
		}
		return sb.toString();
	}

	// INSERT OR UPDATE 되었는지 확인
	private boolean convertToBoolean(int number) {
		return number == 0 ? false : true;
	}

}
