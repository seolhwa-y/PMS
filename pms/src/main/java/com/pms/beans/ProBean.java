package com.pms.beans;

import java.util.List;

import lombok.Data;

@Data
public class ProBean {
	private String proCode;
	private String proName;
	private String proComment;
	private String proStart;
	private String proEnd;
	private String proVisible;
	private List<ProMemberB> proMembers;
	
	private List<ModuleList> moduleList;
	private List<JobList> jobsList;
	private List<ModuleJobList> moduleJobsList;
	private List<MethodList> methodList;
}
