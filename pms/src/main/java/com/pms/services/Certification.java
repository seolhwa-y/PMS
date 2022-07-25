package com.pms.services;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

import com.pms.utils.Encryption;
import com.pms.utils.ProjectUtils;
import com.pms.beans.CerB;
import com.pms.inter.ServicesRule;

@Service
public class Certification implements ServicesRule{

	@Autowired
	private SqlSessionTemplate session; // db 접근 
	@Autowired
	private Encryption enc;	// 암호화 복호화 
	@Autowired
	private ProjectUtils pu; // 세션 
	@Autowired 
	private DashBoard dBoard; // 대쉬보드 

	public Certification() {
	}

	/* FORM 방식 Controller */
	public void backController(int serviceCode, ModelAndView mav) {
		switch(serviceCode) {

		case 0 :
			this.isFirstPage(mav);
			break;
		case 1 : 
			this.joinFormCtl(mav);
			break;
		case 2:
			this.joinMemberCtl(mav);
			break;
		case 3 :
			this.accessCtl(mav);
			break;
		case 4 :
			this.logOut(mav);
			break;
		default:
		}
	}

	/* AJAX 방식 Controller */
	public void backController(int serviceCode, Model model) {

	}

	// 첫페이지 : 세션 확인하여 로그인 :: 대쉬보드 결
	private void isFirstPage(ModelAndView mav)  {
		try {
			if((CerB)this.pu.getAttribute("accessInfo") != null) {
				CerB ce = (CerB)session.selectList("getAccessInfo",(CerB)this.pu.getAttribute("accessInfo")).get(0);
				ce.setPmbName(this.enc.aesDecode(ce.getPmbName(), ce.getPmbCode()));
				ce.setPmbEmail(this.enc.aesDecode(ce.getPmbEmail(), ce.getPmbCode()));
				this.pu .setAttribute("accessInfo", ce);
				this.dBoard.backController(0, mav);
			}
		} catch (Exception e) {e.printStackTrace();}
		mav.setViewName("login");
	}

	// 회원가입 페이지로 이동하면서 셀렉트를 폼에 넣어주기
	@Transactional(readOnly = true)
	private void joinFormCtl(ModelAndView mav) {
		mav.addObject("pmbCode", this.session.selectOne("getPmbCode"));
		mav.addObject("selectData", this.makeSelectHtml(this.session.selectList("getLevelList"), true, "pmbLevel") 
				+ this.makeSelectHtml(this.session.selectList("getClassList"), false, "pmbClass"));
		mav.setViewName("join");
	}

	// 셀렉트로 보내줄 Class :: Level 스트링으로 만들어서 넣어주기 
	private String makeSelectHtml(List<CerB> list, boolean type, String objName) {

		StringBuffer sb = new StringBuffer();
		sb.append("<select name='" + objName + "' class='box'>");
		sb.append("<option disabled selected>"+ objName.substring(3) +" Code 선택</option>");
		for(CerB auth : list) {
			sb.append("<option value='" + (type?auth.getPmbLevel():auth.getPmbClass()) + "'>" + (type?auth.getPmbLevelName():auth.getPmbClassName()) + "</option>");
		}
		sb.append("</select>");

		return sb.toString();
	} 

	// 회원가입 제어
	@Transactional(propagation=Propagation.REQUIRED)
	private void joinMemberCtl(ModelAndView mav) {
		String page = "join", message = "회원 가입 실패";
		CerB auth = ((CerB)mav.getModel().get("cerB"));

		auth.setPmbCode(this.session.selectOne("getPmbCode"));
		try {
			auth.setPmbName(this.enc.aesEncode(auth.getPmbName(), auth.getPmbCode()));
			auth.setPmbPassword(this.enc.encode(auth.getPmbPassword()));
			auth.setPmbEmail(this.enc.aesEncode(auth.getPmbEmail(), auth.getPmbCode()));
		} catch (InvalidKeyException | UnsupportedEncodingException | NoSuchAlgorithmException
				| NoSuchPaddingException | InvalidAlgorithmParameterException | IllegalBlockSizeException
				| BadPaddingException e) {
			e.printStackTrace();
		} 
		if(this.convertToBoolean(this.session.insert("insPmb", auth))) {
			page = "login";
			message = "회원 가입 성공\\n회원코드 : " + auth.getPmbCode();
		}
		mav.setViewName(page);
		mav.addObject("message", message);
	}

	// 로그인 제어 
	private void accessCtl(ModelAndView mav) {
		try {
			if(this.pu.getAttribute("accessInfo")!= null) {
				CerB cb = (CerB)this.session.selectList("getAccessInfo", (CerB)this.pu.getAttribute("accessInfo")).get(0);
				cb.setPmbName(this.enc.aesDecode(cb.getPmbName(), cb.getPmbCode()));
				cb.setPmbEmail(this.enc.aesDecode(cb.getPmbEmail(), cb.getPmbCode()));
				this.pu.setAttribute("accessInfo", cb);

				this.dBoard.backController(0, mav);
			}else {
				this.insAccessCtl(mav);
			}
		} catch (Exception e) {e.printStackTrace();}
	}

	// 로그인하면서 로그인 기록 생성 
	@Transactional(isolation=Isolation.READ_COMMITTED, propagation=Propagation.REQUIRED)
	private void insAccessCtl(ModelAndView mav) {	
		String page = "login";
		CerB cb = ((CerB)mav.getModel().get("cerB"));

		if(this.enc.matches(cb.getPmbPassword(),this.session.selectOne("isMember", cb))) {
			String dbData = (String)this.session.selectOne("isAccess", cb);
			if(dbData != null) {
				cb.setAslAction(-1);
				this.session.insert("insAsl", cb);
			}
			cb.setAslAction(1);
			if(this.convertToBoolean(this.session.insert("insAsl", cb))){
				CerB ce = (CerB)this.session.selectList("getAccessInfo", cb).get(0);
				try {
					ce.setPmbName(this.enc.aesDecode(ce.getPmbName(),ce.getPmbCode())); 
					ce.setPmbEmail(this.enc.aesDecode(ce.getPmbEmail(), ce.getPmbCode()));
					this.pu.setAttribute("accessInfo", ce);
					this.dBoard.backController(0, mav);
				} catch (Exception e) {e.printStackTrace();}	
			}
		}
		mav.setViewName(page); 
	}

	// 로그아웃 제어 
	@Transactional(propagation=Propagation.REQUIRED)
	private void logOut(ModelAndView mav) {
		String page ="redirect:/";
		CerB cb;
		try {
			cb = ((CerB)this.pu.getAttribute("accessInfo"));
			if(cb != null) {
				String dbData = ((String)this.session.selectOne("isAccess", cb));
				if(dbData != null) {
					cb.setAslAction(-1);
					if(!this.convertToBoolean(this.session.insert("insAsl",cb))) {
					}
					this.pu.removeAttribute("accessInfo");
				}
			}
		} catch (Exception e) {e.printStackTrace();}

		mav.setViewName(page);
	}

	// INSERT OR UPDATE 되었는지 확인 
	private boolean convertToBoolean(int number) {		
		return number == 0?false:true;
	}
}
