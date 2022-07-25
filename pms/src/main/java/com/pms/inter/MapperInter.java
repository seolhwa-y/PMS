package com.pms.inter;

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
}
