package com.pms.services;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
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
				case 5:
					this.moveResultMgr(mav);
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

	private void moveResultMgr(ModelAndView mav) {
		ProgressMgrB pb = (ProgressMgrB) mav.getModel().get("progressMgrB");
		System.out.println(pb.getProCode());
		HashMap<String,String> map = new HashMap<String,String>();
		map.put("proCode", pb.getProCode());

		try {
			CerB cb =  (CerB)this.pu.getAttribute("accessInfo");
			map.put("pmbCode", cb.getPmbCode());
			
			//프로젝트이름 보내주기
			mav.addObject("proName", this.makeSelectName(this.session.selectList("getProNameList", map),map));
			
			// MC별로 메서드 갯수 가져오기
			map.put("mcCode", "CT");
			mav.addObject("ctNum",this.session.selectOne("getMyMethodCount",map)+" / "+this.session.selectOne("getTotalMethodCount",map));
			map.put("mcCode", "VI");
			mav.addObject("viNum",this.session.selectOne("getMyMethodCount",map)+" / "+this.session.selectOne("getTotalMethodCount",map));
			map.put("mcCode", "MO");
			mav.addObject("moNum",this.session.selectOne("getMyMethodCount",map)+" / "+this.session.selectOne("getTotalMethodCount",map));
			map.put("mcCode", "DA");
			mav.addObject("daNum",this.session.selectOne("getMyMethodCount",map)+" / "+this.session.selectOne("getTotalMethodCount",map));
			
			// MJ NAME 가져오기
			mav.addObject("mjName", this.makeMJList(this.session.selectList("getMJName",map)));

		} catch (Exception e) {e.printStackTrace();	}
		
		//프로젝트 팀장,팀원,날짜 보내주기
		mav.addObject("proInfo", this.makeProInfo(this.session.selectList("getProInfo",map)));
		
		//모듈갯수 가져오기
		mav.addObject("moduleNum",this.session.selectOne("getModuleNum",map));
		//잡갯수 가져오기
		mav.addObject("jobsNum",this.session.selectOne("getJobsNum",map));
		//모듈앤잡갯수 가져오기
		mav.addObject("mjNum",this.session.selectOne("getModuleJobsNum",map));
		//메서드갯수 가져오기
		mav.addObject("methodNum",this.session.selectOne("getMethodNum",map));
		
		mav.setViewName("result");

			}
	

	private String makeMJList(List<ModuleB> selectList) {
		StringBuffer sb = new StringBuffer();
		for(ModuleB mb : selectList) {
			sb.append("<div class = 'mjName' onclick=\"window.nextMc(\'"+mb.getProCode()+":"+mb.getMouCode()+":"+mb.getJosCode()+"\')\">"+mb.getMjName()+"</div>");
		}
		
		return sb.toString();
	}

	private String makeSelectName(List<ProgressMgrB> selectList, HashMap<String,String> map) {
		StringBuffer sb = new StringBuffer();
		
		if(map.get("proCode").equals("N")) {
			map.put("proCode",this.session.selectOne("getRecentProject",map));
		}
		
		sb.append("<select id='projectName' onchange='changePJ()' class='selectBox'>");
		if(selectList != null && selectList.size() > 0) {
			for(ProgressMgrB pb : selectList) {
				if(pb.getProCode().equals(map.get("proCode"))) {
					sb.append("<option value='"+ pb.getProCode()+"' selected>"+pb.getProName()+ " </option>");
				}else {
					sb.append("<option value='"+ pb.getProCode() +"'>"+ pb.getProName() +"</option>");	
				}
			}
		}else {
			sb.append("<option disabled selected>선택하실 모듈이 없습니다</option>");
		}
		sb.append("</select>");
		
		return sb.toString();
	}

	private void newInviteMember(ModelAndView mav) {
		try {

			ProBean pro = (ProBean)mav.getModel().get("proBean");
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
				case 2:
					this.updModule(model);
					break;
				case 3:
					this.insModule(model);
					break;
				case 4:
					this.delModule(model);
					break;
				case 5:
					this.updJobs(model);
					break;
				case 6:
					this.insJobs(model);
					break;
				case 7:
					this.delJobs(model);
					break;
				case 8:
					this.insMJ(model);
					break;
				case 9:
					this.insMet(model);
					break;
				case 10:
					this.delModuleJobs(model);
					break;
				case 11:
					this.delMethod(model);
					break;
				case 12:
					this.updModuleJobs(model);
					break;
				case 13:
					this.updMethod(model);
					break;
				case 14:
					this.getMcaList(model);
					break;
				case 15:
					this.getMetList(model);
					break;
				default:
				}

			} else {
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 메서드 리스트 가져오기
	private void getMetList(Model model) {
		ModuleB module =(ModuleB) model.getAttribute("moduleB");
		HashMap<String,Object> map = new HashMap<String,Object>();
		List<ModuleB> mcaList = new ArrayList<ModuleB>();
		
		try {
			map.put("proCode", module.getProCode());
			map.put("mouCode", module.getMouCode());
			map.put("josCode", module.getJosCode());
			map.put("mcCode", module.getMcCode());
			map.put("pmbCode", ((CerB)this.pu.getAttribute("accessInfo")).getPmbCode());
		} catch (Exception e) {e.printStackTrace();
		}
		mcaList = this.session.selectList("getMetList",map);
		map.put("mcaList", mcaList);
		model.addAttribute("map",map);
	}

	private void getMcaList(Model model) {
		ModuleB module =(ModuleB) model.getAttribute("moduleB");
		HashMap<String,Object> map = new HashMap<String,Object>();
		List<ModuleB> mcaList = new ArrayList<ModuleB>();
		
		//{시작전,진행중,완료,내가맡은 모든 메서드 토탈}
		int[][] methodCount = {{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}};
		String[] mcCode = {"CT","VI","MO","DA"};
		System.out.println(module.getMouCode());
		//map.put("CTrd", methodCount[0][0]);
		map.put("mcCode", mcCode);
		try {
			map.put("proCode", module.getProCode());
			map.put("mouCode", module.getMouCode());
			map.put("josCode", module.getJosCode());
			map.put("pmbCode", ((CerB)this.pu.getAttribute("accessInfo")).getPmbCode());
		} catch (Exception e) {e.printStackTrace();
		}
		mcaList = this.session.selectList("getMcaCount",map);
		for(int idx=0;idx<mcaList.size();idx++) {
			switch(mcaList.get(idx).getMcCode()) {
			case "CT" : 
				methodCount[0][3]++;
				switch(mcaList.get(idx).getMetState()) {
				case "RD":
					methodCount[0][0]++;
					break;
				case "IN":
					methodCount[0][1]++;
					break;
				case "CP":
					methodCount[0][2]++;
					break;
				default:
				}
				break;
			case "VI" :
				methodCount[1][3]++;
				switch(mcaList.get(idx).getMetState()) {
				case "RD":
					methodCount[1][0]++;
					break;
				case "IN":
					methodCount[1][1]++;
					break;
				case "CP":
					methodCount[1][2]++;
					break;
				default:
				}
				break;
			case "MO" :
				methodCount[2][3]++;
				switch(mcaList.get(idx).getMetState()) {
				case "RD":
					methodCount[2][0]++;
					break;
				case "IN":
					methodCount[2][1]++;
					break;
				case "CP":
					methodCount[2][2]++;
					break;
				default:
				}
				break;
			case "DA" :
				methodCount[3][3]++;
				switch(mcaList.get(idx).getMetState()) {
				case "RD":
					methodCount[3][0]++;
					break;
				case "IN":
					methodCount[3][1]++;
					break;
				case "CP":
					methodCount[3][2]++;
					break;
				default:
				}
				break;
			default:
			}
			
		}
		map.put("mcaCount", methodCount);
		//위에서 맵에다 담았으니까 map을 model에 넣어줌
		model.addAttribute("map",map);
	}

	private void updMethod(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		ModuleB module = (ModuleB) model.getAttribute("moduleB");
		map.put("proCode", module.getProCode());		if(this.convertToBoolean(this.session.update("updMethod", module))) { 

		}
		model.addAttribute("moduleB", this.session.selectList("getMethodList", map));

	}

	private void updModuleJobs(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		ModuleB module = (ModuleB) model.getAttribute("moduleB");
		map.put("proCode", module.getProCode());		if(this.convertToBoolean(this.session.update("updModuleJobs", module))) { 

		}
		model.addAttribute("moduleB", this.session.selectList("getMJList", map));

	}

	private void delMethod(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		ModuleB module = (ModuleB) model.getAttribute("moduleB");
		map.put("proCode", module.getProCode());
		if(this.convertToBoolean(this.session.delete("delMethod", module))) {

		}else {
			module.setMessage("삭제 실패. 연관된 하위 항목을 먼저 삭제해주세요");
			model.addAttribute("moduleB",module);
		}
		model.addAttribute("moduleB", this.session.selectList("getMethodList", map));

	}

	private void delModuleJobs(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		ModuleB module = (ModuleB) model.getAttribute("moduleB");
		map.put("proCode", module.getProCode());		
		if(this.convertToBoolean(this.session.delete("delModuleJobs", module))) {

		}else {
			module.setMessage("삭제 실패. 연관된 하위 항목을 먼저 삭제해주세요");
			model.addAttribute("moduleB",module);
		}
		model.addAttribute("moduleB", this.session.selectList("getMJList", map));

	}

	private void insMet(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		ModuleB module = (ModuleB) model.getAttribute("moduleB");
		map.put("proCode", module.getProCode());
		String metCode = this.session.selectOne("getMetCode", module);
		if( metCode == null) {
			module.setMetCode(module.getMouCode()+"01");
		}else{
			int code = Integer.parseInt(metCode) + 1;
			module.setMetCode(Integer.toString(code));
		}
		
		if(this.convertToBoolean(this.session.insert("insMethod", module))) {

		}
		model.addAttribute("moduleB", this.session.selectList("getMethodList", map));

	}

	private void insMJ(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		ModuleB module = (ModuleB) model.getAttribute("moduleB");
		map.put("proCode", module.getProCode());		
		if(this.convertToBoolean(this.session.insert("insModuleJobs", module))) {
		}
		model.addAttribute("moduleB", this.session.selectList("getMJList", map));

	}

	private void delJobs(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		ModuleB module = (ModuleB) model.getAttribute("moduleB");
		map.put("proCode", module.getProCode());		
		if(this.convertToBoolean(this.session.delete("delJobs", module))) {

		}else {
			module.setMessage("삭제 실패. 연관된 하위 항목을 먼저 삭제해주세요");
			model.addAttribute("moduleB",module);
		}
		model.addAttribute("moduleB", this.session.selectList("getJobsList", map));

	}

	private void updJobs(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		ModuleB module = (ModuleB) model.getAttribute("moduleB");
		map.put("proCode", module.getProCode());		if(this.convertToBoolean(this.session.update("updJobs", module))) { 

		}
		model.addAttribute("moduleB", this.session.selectList("getJobsList", map));

	}

	private void delModule(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		ModuleB module = (ModuleB) model.getAttribute("moduleB");
		map.put("proCode", module.getProCode());
		if(this.convertToBoolean(this.session.delete("delModule", module))) {
		}else {
			module.setMessage("삭제 실패. 연관된 하위 항목을 먼저 삭제해주세요");
			model.addAttribute("moduleB",module);
		}
		model.addAttribute("moduleB",(this.session.selectList("getModuleList", map)));

	}

	private void insJobs(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		ModuleB module = (ModuleB) model.getAttribute("moduleB");
		map.put("proCode", module.getProCode());
		if(this.convertToBoolean(this.session.insert("insJobs", module))) {
		
		}
		model.addAttribute("moduleB", this.session.selectList("getJobsList", map));

	}

	private void insModule(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		ModuleB module = (ModuleB) model.getAttribute("moduleB");
		map.put("proCode", module.getProCode());
		
		if(this.convertToBoolean(this.session.insert("insModule", module))) {
		
		}
		model.addAttribute("moduleB",this.session.selectList("getModuleList", map));
		System.out.println(model.getAttribute("moduleB"));
	}

	private void updModule(Model model) {
		HashMap<String,String> map = new HashMap<String,String>();
		ModuleB module = (ModuleB) model.getAttribute("moduleB");
		map.put("proCode", module.getProCode());
		if(this.convertToBoolean(this.session.update("updModule", module))) {
			
		}
		model.addAttribute("moduleB",(this.session.selectList("getModuleList", map)));

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
		HashMap<String,String> map = new HashMap<String,String>();
		map.put("proCode", ((ModuleB) mav.getModel().get("moduleB")).getProCode());
		ModuleB module = (ModuleB) mav.getModel().get("moduleB");
		
		/* ModuleList */
		mav.addObject("ModuleList", this.test(this.session.selectList("getModuleList", map), 1));
		//mav.addObject("updMouList", this.makeUpdSelect(this.session.selectList("getModuleList", map),1));
		/* JobList */
		mav.addObject("JobList", this.test(this.session.selectList("getJobsList", map), 2));
		//mav.addObject("updJosList", this.makeUpdSelect(this.session.selectList("getJobsList", map),2));
		/* ModuleJobList */
		mav.addObject("ModuleJobList", this.test(this.session.selectList("getMJList", map), 3));
		mav.addObject("insMJList", this.makeInsSelect(this.session.selectList("getModuleList", map),1)+this.makeInsSelect(this.session.selectList("getJobsList", map),2)+this.makeInsSelect(this.session.selectList("getPmbInfo", map),3));
		mav.addObject("UpdModuleJobList", this.makeInsSelect(this.session.selectList("getPmbInfo", map),3));
		/* MethodList */
		mav.addObject("MethodList", this.test(this.session.selectList("getMethodList", map), 4));
		mav.addObject("insMetList", this.makeInsSelect(this.session.selectList("getModuleList", map),1)+this.makeInsSelect(this.session.selectList("getJobsList", map),2)+this.makeInsSelect(this.session.selectList("getMcList"),4));				
		mav.addObject("proCode", module.getProCode());
		mav.addObject("UpdMethodList", this.makeInsSelect(this.session.selectList("getMcList"),4));
		mav.setViewName("jobs");
	}
	

	private String makeInsSelect(List<ModuleB> selectList, int num) {
		StringBuffer sb = new StringBuffer();
		
		switch(num) {
		case 1 : 
			sb.append("<select name='mjMou' class='box'>");
			sb.append("<option disabled selected> 모듈을 선택 하세요</option>");
			if(selectList != null && selectList.size() > 0) {
				for(ModuleB mb : selectList) {
					sb.append("<option value='"+ mb.getMouCode() +"'>"+ mb.getMouName() +"</option>");
				}
			}else {
				sb.append("<option disabled selected>선택하실 모듈이 없습니다</option>");
			}
			sb.append("</select>");
			break;
		case 2 :
			sb.append("<select name='mjJos' class='box'>");
			sb.append("<option disabled selected> 좝을 선택 하세요</option>");
			if(selectList != null && selectList.size() > 0) {
				for(ModuleB mb : selectList) {
					sb.append("<option value='"+ mb.getJosCode() +"'>"+ mb.getJosName() +"</option>");
					
				}
			}else {
				sb.append("<option disabled selected>선택하실 잡이 없습니다</option>");
			}
			sb.append("</select>");
			break;
		case 3 :
			sb.append("<select name='mjPmb' class='box'>");
			sb.append("<option disabled selected> 담당자를 선택하세요</option>");
			if(selectList != null && selectList.size() > 0) {
				for(ModuleB mb : selectList) {
					try {
						mb.setPmbName(this.enc.aesDecode(mb.getPmbName(), mb.getPmbCode()));
					} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException
							| NoSuchPaddingException | InvalidAlgorithmParameterException
							| IllegalBlockSizeException | BadPaddingException e) {e.printStackTrace();}
					sb.append("<option value='"+ mb.getPmbCode() +"'>"+ mb.getPmbName() +"</option>");
				}
			}else {
				sb.append("<option disabled selected>선택하실 멤버가 없습니다</option>");
			}
			sb.append("</select>");
			break;
		case 4 :
			sb.append("<select name='mcInfo' class='box'>");
			sb.append("<option disabled selected>메소드 카테고리를 선택하세요</option>");
			if(selectList != null && selectList.size() > 0) {
				for(ModuleB mb : selectList) {
					sb.append("<option value='"+ mb.getMcCode() +"'>"+ mb.getMcName() + "</option>");
				}
			}else {
				sb.append("<option disabled selected>선택하실 카테고리가 없습니다</option>");
			}
			break;
			default:
		}
		return sb.toString();
	}

	private String makeUpdSelect(List<ModuleB> selectList, int num) {
		StringBuffer sb = new StringBuffer();
		
		switch(num) {
			case 3 :
				sb.append("<select name='mjPmb' class='box'>");
				sb.append("<option disabled selected> 담당자를 선택하세요</option>");
				if(selectList != null && selectList.size() > 0) {
					for(ModuleB mb : selectList) {
						try {
							mb.setPmbName(this.enc.aesDecode(mb.getPmbName(), mb.getPmbCode()));
						} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException
								| NoSuchPaddingException | InvalidAlgorithmParameterException
								| IllegalBlockSizeException | BadPaddingException e) {e.printStackTrace();}
						sb.append("<option value='"+ mb.getPmbCode() +"'>"+ mb.getPmbName() +"</option>");
					}
				}else {
					sb.append("<option disabled selected>선택하실 멤버가 없습니다</option>");
				}
				break;
			case 4 :
				sb.append("메소드 이름 : <input class='box' type='text' placeholder='메소드 이름' maxlength='2' />");
				sb.append("<select name='mcInfo' class='box'>");
				sb.append("<option disabled selected>메소드 카테고리를 선택하세요</option>");
				if(selectList != null && selectList.size() > 0) {
					for(ModuleB mb : selectList) {
						sb.append("<option value='"+ mb.getMcCode() +"'>"+ mb.getMcName() + "</option>");
					}
				}else {
					sb.append("<option disabled selected>선택하실 카테고리가 없습니다</option>");
				}
				break;
				
			default :
		}
		
		
		return sb.toString();
	}

	private String test(List<ModuleB> list , int num) {
		StringBuffer sb = new StringBuffer();
		
		switch(num) {
		
		case 1 :
			System.out.println("여기는 오니?");
			int idx = 0;
			for(ModuleB mb : list) {
				sb.append("<div class = 'ModuleList' >");
				if(list != null && list.size() > 0){
					idx ++;
					sb.append("<div> 순번 : " + idx + "</div>");
					sb.append("<div>MOUNAME = " + mb.getMouName() + "</div>");
					sb.append("<div>MOUCOMMENTS = " + ((mb.getMouComments() == null)? "none" : mb.getMouComments()) + "</div>");
					sb.append("<input type='button' class='box' value='수정' onclick=\"updModule(\'"+ mb.getProCode() +":"+ mb.getMouCode() +":"+ mb.getMouName() +":"+ mb.getMouComments()+"\')\"/>");
					sb.append("<input type='button' class='box' value='삭제' onclick=\"delModule(\'"+ mb.getProCode() +':'+ mb.getMouCode() +":" +"\')\"/>");
				}
				sb.append("</div>");
			}
			System.out.println(sb);
			break;
			
		case 2 : 
			idx = 0;
			for(ModuleB mb : list) {

				sb.append("<div class = 'JobList' >");
				if(list != null && list.size() > 0){
					idx ++;
					sb.append("<div> 순번 : " + idx + "</div>");
					sb.append("<div>JOSNAME = " + mb.getJosName() + "</div>");
					sb.append("<div>JOSCOMMENTS = " + ((mb.getJosComments() == null)? "none" : mb.getJosComments()) + "</div>");
					sb.append("<input type='button' class='box' value='수정' onclick=\"window.updJobs(\'"+ mb.getProCode() +":"+ mb.getJosCode() +":"+ mb.getJosName() +":"+ mb.getJosComments()+"\')\" />");
					sb.append("<input type='button' class='box' value='삭제' onclick=\"window.delJobs(\'"+ mb.getProCode() +":"+ mb.getJosCode()+"\')\" />");
				
				}
				sb.append("</div>");
			}
			break;
			
		case 3 : 
			idx = 0;
			for(ModuleB mb : list) {
				sb.append("<div class = 'ModuleJobList' >");
				if(list != null && list.size() > 0){
					idx ++;
					try {
						mb.setPmbName(this.enc.aesDecode(mb.getPmbName(), mb.getPmbCode()));
						sb.append("<div> 순번 : " + idx + "</div>");
						sb.append("<input type='hidden' value='" + mb.getProCode() + "'/>");
						sb.append("<div>MOUNAME = " + mb.getMouName() + "</div>");
						sb.append("<div>JOSNAME = " + mb.getJosName() + "</div>");
						sb.append("<div>PMBNAME = " + mb.getPmbName() + "</div>");
						sb.append("<input type='hidden' value='" + mb.getPmbCode() + "'/>");
						sb.append("<input type='button' class='box' value='수정' onclick=\"window.updModuleJobs(\'"+ mb.getProCode() +":"+ mb.getMouCode()+":"+ mb.getJosCode()+":"+ mb.getPmbCode() +":"+ mb.getPmbName()+"\')\" />");
						sb.append("<input type='button' class='box' value='삭제' onclick=\"window.delModuleJobs(\'"+ mb.getProCode() +":"+ mb.getMouCode()+":"+ mb.getJosCode()+":"+ mb.getPmbCode() +"\')\" />");
						
					} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException
							| NoSuchPaddingException | InvalidAlgorithmParameterException | IllegalBlockSizeException
							| BadPaddingException e) {e.printStackTrace();}
					}
				sb.append("</div>");
			}
			break;
			
		case 4 : 			
			idx = 0;
			for(ModuleB mb : list) {
				sb.append("<div class = 'MethodList' >");
				if(list != null && list.size() > 0){
					idx ++;
					sb.append("<div> 순번 : " + idx + "</div>");
					sb.append("<div>MOUNAME = " + mb.getMouName() + "</div>");
					sb.append("<div>JOSNAME = " + mb.getJosName() + "</div>");
					sb.append("<div>METNAME = " + mb.getMetName() + "</div>");
					sb.append("<div>MCNAME = " + mb.getMcName() + "</div>");
					sb.append("<input type='button' class='box' value='수정' onclick=\"window.updMethod(\'"+ mb.getProCode() +":"+ mb.getMouCode() +":"+ mb.getJosCode() +":"+ mb.getMetCode() +":"+ mb.getMcCode() +"\')\" />");
					sb.append("<input type='button' class='box' value='삭제' onclick=\"window.delMethod(\'"+ mb.getProCode() +":"+ mb.getMouCode() +":"+ mb.getJosCode() +":"+ mb.getMetCode() +":"+ mb.getMcCode() +"\')\" />");
				
				}
				sb.append("</div>");
			}
			break;
			
		default : 
		}
		return sb.toString();
	}
	
//	private void moveJobsCtl(ModelAndView mav) {
//		System.out.println("GKFGKS");
//		/* Project 정보 조회  ModuleList 조회  JobList 조회 ModuleJobList 조회  MethodList 조회 */
//		List<ProBean> projectList = this.session.selectList("getProjectDetail", ((ProBean)mav.getModel().get("proBean")));
//		
//		if(projectList.size() > 0) {
//			mav.addObject("ModuleList",this.makeJobs1(projectList.get(0)));
//		}else {
//			
//		}
//				
//		mav.setViewName("jobs");
//	}
	
//	/* Module List */
//	private String makeJobs1(ProBean project) {
//		StringBuffer sb = new StringBuffer();
//		// 모듈
//		sb.append("<table>");
//		if(project.getModuleList().size() > 0 ) {
//			sb.append("<tr><th>순번</th><th>모듈명</th><th>모듈상세</th><th>Action</th></tr>");
//			int idx = 0;
//			for(ModuleList module : project.getModuleList()) {
//				idx++;
//				sb.append("<tr><td>" + idx + "</td><td>" + module.getMouName() + "</td><td>" + module.getMouComments() + "</td><td>"
//						+ "<button class=\"\" onClick=\"updModule('" + module.getProCode() + "','" + module.getMouCode() + "')\">수정</button>"
//						+ "<button class=\"\" onClick=\"delModule('" + module.getProCode() + "', '" + module.getMouCode() + "')\">삭제</button></td></tr>");
//			}
//		}else {
//			sb.append("<tr><td>등록 모듈 없음</td></tr>");
//		}
//		sb.append("</table>");
//		
//		//좝
//		sb.append("<table>");
//		if(project.getModuleList().size() > 0 ) {
//			sb.append("<tr><th>순번</th><th>좝명</th><th>좝상세</th><th>Action</th></tr>");
//			int idx = 0;
//			for(JobList jos : project.getJobsList()) {
//				idx++;
//				sb.append("<tr><td>" + idx + "</td><td>" + jos.getJosName() + "</td><td>" + jos.getJosComments() + "</td><td>"
//						+ "<button class=\"\" onClick=\"updModule('" + jos.getProCode() + "','" + jos.getJosCode() + "')\">수정</button>"
//						+ "<button class=\"\" onClick=\"delModule('" + jos.getProCode() + "', '" + jos.getJosCode() + "')\">삭제</button></td></tr>");
//			}
//		}else {
//			sb.append("<tr><td>등록 모듈 없음</td></tr>");
//		}
//		sb.append("</table>");
//		
//		// 모듈좝
//		sb.append("<table>");
//		if(project.getModuleList().size() > 0 ) {
//			sb.append("<tr><th>순번</th><th>모듈명</th><th>모듈상세</th><th>Action</th></tr>");
//			int idx = 0;
//			for(ModuleJobList mj : project.getModuleJobsList()) {
//				idx++;
//				sb.append("<tr><td>" + idx + "</td><td>" + mj.getMouCode() + "</td><td>" + mj.getJosCode() + "</td><td>"
//						+ "<button class=\"\" onClick=\"updModule('" + mj.getProCode() + "','" + mj.getPmbCode() + "')\">수정</button>"
//						+ "<button class=\"\" onClick=\"delModule('" + mj.getProCode() + "', '" + mj.getPmbCode() + "')\">삭제</button></td></tr>");
//			}
//		}else {
//			sb.append("<tr><td>등록 모듈 없음</td></tr>");
//		}
//		sb.append("</table>");
//		
//		// 메소드
//		sb.append("<table>");
//		if(project.getModuleList().size() > 0 ) {
//			sb.append("<tr><th>순번</th><th>모듈명</th><th>모듈상세</th><th>Action</th></tr>");
//			int idx = 0;
//			for(MethodList mt : project.getMethodList()) {
//				idx++;
//				sb.append("<tr><td>" + idx + "</td><td>" + mt.getMetName() + "</td><td>" + mt.getMcName() + "</td><td>"
//						+ "<button class=\"\" onClick=\"updModule('" + mt.getProCode() + "','" + mt.getMouCode() + "',"
//						+ "'" + mt.getJosCode() + "','" + mt.getMetCode() + "','" + mt.getMcCode() + "')\">수정</button>"
//						+ "<button class=\"\" onClick=\"delModule('" + mt.getProCode() + "','" + mt.getMouCode() + "',"
//						+ "'" + mt.getJosCode() + "','" + mt.getMetCode() + "','" + mt.getMcCode() + "')\\\">삭제</button></td></tr>");
//			}
//		}else {
//			sb.append("<tr><td>등록 모듈 없음</td></tr>");
//		}
//		sb.append("</table>");
//		
//		return sb.toString();
//	}
//	
	// memberMgr 화면 이동
	private void moveMemberMgr(ModelAndView mav) { //mav proBean 도착
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
	
	private String makeProInfo(List<ProgressMgrB> list) {
		StringBuffer sb = new StringBuffer();
		String TeamLeader = "";
		String TeamMember = "";
		System.out.println(list);

				//팀장만 TeamLeader에 set
				try {
					for(int idx=0;idx<list.size();idx++) {
						System.out.println("position은? "+list.get(idx).getPrmPosition());
					if(list.get(idx).getPrmPosition().equals("MG")) {
						TeamLeader += this.enc.aesDecode(list.get(idx).getPmbName(),list.get(idx).getPmbCode());
						if(list.size() != idx-1) { //마지막만빼고 이름 사이사이에 공백 넣어주기
							TeamLeader += " ";
							}
						}else if(list.get(idx).getPrmPosition().equals("MB")){
							//팀원만 TeamMember에 set
							TeamMember += this.enc.aesDecode(list.get(idx).getPmbName(),list.get(idx).getPmbCode());
							if(list.size() != idx-1) {
								TeamMember += " ";
							}
						}
					}
				} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException
						| NoSuchPaddingException | InvalidAlgorithmParameterException | IllegalBlockSizeException
						| BadPaddingException e) {
					e.printStackTrace();
				}
				sb.append("<div class='proInfo proLeader'> 프로젝트 팀장 : "+TeamLeader+"</div>");
				sb.append("<div class='proInfo proMember'> 프로젝트 팀원 : "+TeamMember+"</div>");
				sb.append("<div class='proInfo proPeriod'> 프로젝트 기간 : "+list.get(0).getProStart()+"~"+list.get(0).getProEnd()+"</div>");
				
				return sb.toString();
		}

		
		
	}
	
