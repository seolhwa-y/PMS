package com.pms.inter;

import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

public interface ServicesRule {
	public void backController(int serviceCode, ModelAndView mav);//page
	public void backController(int serviceCode, Model model);//api
}
