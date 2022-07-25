package com.pms.services;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

import com.pms.utils.Encryption;
import com.pms.utils.ProjectUtils;
import com.pms.beans.CerLogB;
import com.pms.beans.ProjectInfoB;
import com.pms.inter.ServicesRule;

@Service
public class DashBoard implements ServicesRule{

	@Autowired
	private SqlSessionTemplate session; // db 접근 
	@Autowired
	private Encryption enc;	// 암호화 복호화 
	@Autowired
	private ProjectUtils pu; // 세션 
	@Autowired 
	private DashBoard dBoard; // 대쉬보드 
	
	public DashBoard() {
	}
	
	/* FORM 방식 Controller */
	public void backController(int serviceCode, ModelAndView mav) { 

		try {
			if(this.pu.getAttribute("accessInfo") != null) {
				switch(serviceCode) {
				case 0 : 
					this.entrance(mav);
					break;
				case 1 : 
					this.EmailCodeAuth(mav);
					break;
				default:
				}
			}else {
				mav.setViewName("login");
			}
		} catch (Exception e) {e.printStackTrace();}
	}

	/* AJAX 방식 Controller */
	public void backController(int serviceCode, Model model) {
		try {
			if(this.pu.getAttribute("accessInfo") != null) {
				switch(serviceCode) {
				case 0 : 
					break;
				default:
				}
			}else {

			}
		}catch (Exception e) {e.printStackTrace();}
	}
	
	// 대쉬보드 화면 이동 
	private void entrance(ModelAndView mav) {
		mav.setViewName("dashBoard");
	}

	// 메일로 보낸 인증코드 복호화하여 UPDATE -> PMB, AUL
	@Transactional
	private void EmailCodeAuth(ModelAndView mav) {

	}

	// 내가 참여한 프로젝트 정보 HTML
	private String projectInfo(List<ProjectInfoB> list) {
		return null;
	}

	// 받은 초청장 정보 HTML
	private String receivedInvitationInfo(List<CerLogB> list){
		return null;
	}

	// 보낸 초청장 정보 HTML
	private String sendInvitationInfo(List<CerLogB> list){
		return null;
	}
	
	// INSERT OR UPDATE 되었는지 확인 
	private boolean convertToBoolean(int number) {		
		return number == 0?false:true;
	}

}
