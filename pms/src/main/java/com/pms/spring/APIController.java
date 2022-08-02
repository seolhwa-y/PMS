package com.pms.spring;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.pms.beans.CerB;
import com.pms.beans.MemberMgrB;
import com.pms.beans.ModuleB;
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
		model.addAttribute(mb);
		project.backController(1, model);
		return (MemberMgrB)model.getAttribute("memberMgrB");
		
	}
	
	@SuppressWarnings("unchecked")
	@PostMapping("/UpdModule")
	public ModuleB updModul(Model model, @ModelAttribute ModuleB module){
		/* Developer : 지수 */

		model.addAttribute(module);
		project.backController(2, model);
		return (ModuleB)model.getAttribute("moduleB");
		
	}
	@SuppressWarnings("unchecked")
	@PostMapping("/InsModule")
	public ModuleB insModul(Model model, @ModelAttribute ModuleB module){
		/* Developer : 지수 */

		model.addAttribute(module);
		project.backController(3, model);
		return (ModuleB)model.getAttribute("moduleB");

	}
	@SuppressWarnings("unchecked")
	@PostMapping("/InsJobs")
	public ModuleB insJobs(Model model, @ModelAttribute ModuleB module){
		/* Developer : 지수 */

		model.addAttribute(module);
		project.backController(6, model);
		return (ModuleB)model.getAttribute("moduleB");
		
	}
	@SuppressWarnings("unchecked")
	@PostMapping("/DelModule")
	public ModuleB delModule(Model model, @ModelAttribute ModuleB module){
		/* Developer : 지수 */

		model.addAttribute(module);
		project.backController(4, model);
		return (ModuleB)model.getAttribute("moduleB");
		
	}
	@SuppressWarnings("unchecked")
	@PostMapping("/UpdJobs")
	public ModuleB updJobs(Model model, @ModelAttribute ModuleB module){
		/* Developer : 지수 */

		model.addAttribute(module);
		project.backController(5, model);
		return (ModuleB)model.getAttribute("moduleB");
		
	}
	@SuppressWarnings("unchecked")
	@PostMapping("/DelJobs")
	public ModuleB delJobs(Model model, @ModelAttribute ModuleB module){
		/* Developer : 지수 */

		model.addAttribute(module);
		project.backController(7, model);
		return (ModuleB)model.getAttribute("moduleB");

	}
	/*
	 * 	
	@PostMapping("/ReSendEmail")
	public String reSendEmail(Model model, @ModelAttribute MemberMgrB mb){
		System.out.println(mb);
		model.addAttribute(mb);
		project.backController(1, model);
		return "memberMgr";
	}
	*/
}

 
