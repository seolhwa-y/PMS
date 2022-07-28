package com.pms.spring;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.pms.beans.CerB;
import com.pms.beans.MemberMgrB;
import com.pms.beans.ProBean;
import com.pms.services.Project;

@RestController
public class APIController {
	
	@Autowired
	private Project project;
	
	// AJAX 방식으로 받은 데이터로 프로젝트 등록 
	@SuppressWarnings("unchecked")
	@PostMapping("/RegProject")
	public List<CerB> regProject(Model model, @ModelAttribute ProBean pro){
		/* Developer : 지수 */
		model.addAttribute(pro);
		project.backController(0, model);
		return (List<CerB>)model.getAttribute("MemberList");
	}
	
	@SuppressWarnings("unchecked")
	@PostMapping("/ReSendEmail")
	public MemberMgrB reSendEmail(Model model, @ModelAttribute MemberMgrB mb){
		/* Developer : 지수 */
		System.out.println(mb);
		model.addAttribute(mb);
		project.backController(1, model);
		return (MemberMgrB)model.getAttribute("memberMgrB");
	}
}

 
