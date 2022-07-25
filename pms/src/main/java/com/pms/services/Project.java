package com.pms.services;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

import com.pms.utils.Encryption;
import com.pms.utils.ProjectUtils;
import com.pms.inter.ServicesRule;

@Service
public class Project implements ServicesRule{

	@Autowired
	private SqlSessionTemplate session; // db 접근 
	@Autowired
	private Encryption enc;	// 암호화 복호화 
	@Autowired
	private ProjectUtils pu; // 세션 
	@Autowired 
	private DashBoard dBoard; // 대쉬보드 

	public Project() {
	}

	/* FORM 방식 Controller */
	public void backController(int serviceCode, ModelAndView mav) {

		try {
			if(this.pu.getAttribute("accessInfo") != null) {
				switch(serviceCode) {
				case 0 : 
					this.entrance(mav);
					break;
				case 1:
					this.regProjectMembersCtl(mav);
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
					this.regProjectCtl(model);
					break;
				default:
				}
			}else {

			}
		}catch (Exception e) {e.printStackTrace();}
	}

	// 프로젝트 화면 이동 
	private void entrance(ModelAndView mav) {
		mav.setViewName("project");
	}

	// 프로젝트등록 
	@Transactional
	private void regProjectCtl(Model model) {

	}

	// 프로젝트등록 후 멤버초대 메일 
	private void regProjectMembersCtl(ModelAndView mav) {
		this.dBoard.backController(0, mav);
	}

	// INSERT OR UPDATE 되었는지 확인 
	private boolean convertToBoolean(int number) {		
		return number == 0?false:true;
	}

}
