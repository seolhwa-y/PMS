package com.pms.beans;

import java.util.List;

import lombok.Data;

@Data
public class ProMemberB {
		private String pmbCode;
		private String spmbCode;
		private String proPosition;
		private String proAccept;
		private String proEmail;
		private List<MemberMgrB> memberMgrB;
}
