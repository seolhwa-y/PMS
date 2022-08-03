package com.pms.inter;

import java.util.HashMap;
import java.util.List;

import com.pms.beans.*;


public interface MapperInter {
	public String isMember(CerB cb);
	public String getPmbCode();
	public List<CerB> getLevelList();
	public List<CerB> getClassList();
	public int insPmb(CerB cb);
	public int insAsl(CerB cb);
	public List<CerB> getAccessInfo(CerB cb);
	public String isAccess(CerB cb);
	public int insProject(ProBean pro);
	public List<CerB> getMembers();
	public int insProjectMembers(ProBean pro);
	public int insAuthLog(CerLogB cl);
	public List<CerB> checkInvite();
	public List<CerB> receivedInvitationInfo();
	public List<CerB> sendInvitationInfo();
	public List<CerB> getProCode();
	
	public int updProjectMembers(EmailCerB ecb);
	public int updAuthLog(EmailCerB ecb);
	
	public String getMemberNum(ProjectInfoB proInfo);
	
	/* 내가 속한 프로젝트 정보 */
	public List<ProBean> getProject(ProBean pro);
	public List<MemberMgrB> getSendEmailList(ProBean pro);
	
	public List<MemberMgrB> isAcceptMember(ProBean pro);
	public List<MemberMgrB> notInviteMember();
	
	/* 업무관리 페이지 전달 정보*/
	public List<ModuleB> getModuleList(HashMap<String,String> map);
	
	public List<ModuleB> getJobsList(HashMap<String,String> map);
	public List<ModuleB> getMJList(HashMap<String,String> map);
	public List<ModuleB> getMethodList(HashMap<String,String> map);
	
	/* Module update, delete, insert */
	public int updModule(ModuleB module);
	public int delModule(ModuleB module);
	public int insModule(ModuleB module);
	//public List<ModuleB> getModuleList(HashMap map);
	
	/* Jobs update, delete, insert */
	public int updJobs(ModuleB module);
	public int delJobs(ModuleB module);
	public int insJobs(ModuleB module);
	public List<ModuleB> getJobsList(ModuleB module);

	/* ModuleJobs update, delete, insert */
	public int updModuleJobs(ModuleB module);
	public int delModuleJobs(ModuleB module);
	public int insModuleJobs(ModuleB module);
	public List<ModuleB> getModuleJobsList(ModuleB module);
	public List<ModuleB> getPmbInfo(HashMap<String,String> map);
	
	/* Method update, delete, insert */
	public int updMethod(ModuleB module);
	public int delMethod(ModuleB module);
	public int insMethod(ModuleB module);
	public List<ModuleB> getMethodList(ModuleB module);
	public List<ModuleB> getMcList();
	public String getMetCode(ModuleB module);
	
	/* 프로젝트 진행 페이지에서 프로젝트 정보 가져오기 */
	public List<ProgressMgrB> getProInfo(HashMap<String,String> map);
	public List<ProgressMgrB> getModuleNum(HashMap<String,String> map);
	public List<ProgressMgrB> getJobsNum(HashMap<String,String> map);
	public List<ProgressMgrB> getModuleJobsNum(HashMap<String,String> map);
	public List<ProgressMgrB> getMethodNum(HashMap<String,String> map);
}
