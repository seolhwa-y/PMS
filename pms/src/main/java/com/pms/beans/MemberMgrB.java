package com.pms.beans;

import lombok.Data;

@Data
public class MemberMgrB {
	private String pmbCode;
	private String pmbName;
	private String pmbEmail;
	private String proCode;
	private String prmAccept;
	private String prmPosition;
	private String inviteDate; // 초대 날짜
	private String expireDate; // 인증만료 날짜
}
