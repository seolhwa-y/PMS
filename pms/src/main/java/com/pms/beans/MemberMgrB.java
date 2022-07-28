package com.pms.beans;

import lombok.Data;

@Data
public class MemberMgrB {
	private String pmbCode;
	private String pmbName;
	private String pmbEmail;
	private String proCode;
	private String proAccept;
	private String expireDate; // 인증만료 날짜
}
