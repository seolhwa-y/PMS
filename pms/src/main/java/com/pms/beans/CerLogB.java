package com.pms.beans;

import java.util.List;

import lombok.Data;

@Data
public class CerLogB {
	private String proCode; // 프로젝트 코드
	private String spmbCode; // 보낸 사람 코드
	private String rpmbCode; // 받은 사람 코드
	private String senderName; // 보낸 사람 이름
	private String receiverName; // 받은 사람 이름
	private String authResult; // aul코드
	private String inviteDate; // 인증보낸 날짜
	private String randomCode; // 인증코드
	private String expireDate; // 인증만료 날짜
	private String authResultName; // aul 이름
	private List<ProBean> proBean;
}
