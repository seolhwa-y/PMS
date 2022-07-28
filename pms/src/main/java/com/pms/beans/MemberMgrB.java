package com.pms.beans;

import lombok.Data;

@Data
public class MemberMgrB {
	private String pmbCode;
	private String pmbName;
	private String pmbEmail;
	private String proCode;
	private String pmbAccept;
	private String pmbLevelName;
	private String pmbClassName;
	private String inviteDate; // 인증보낸 날짜
	private String expireDate; // 인증만료 날짜
}
