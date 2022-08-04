package com.pms.services;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.servlet.ModelAndView;

import com.pms.utils.*;
import com.pms.beans.*;
import com.pms.inter.*;

@Service
public class DashBoard implements ServicesRule {

	@Autowired
	private SqlSessionTemplate session; // db 접근
	@Autowired
	private Encryption enc; // 암호화 복호화
	@Autowired
	private ProjectUtils pu; // 세션
	@Autowired
	private DashBoard dBoard; // 대쉬보드

	public DashBoard() {
	}

	/* FORM 방식 Controller */
	public void backController(int serviceCode, ModelAndView mav) {
		try {
			if (this.pu.getAttribute("accessInfo") != null) {
				switch (serviceCode) {
				case 0:
					this.entrance(mav);
					break;
				case 1:
					this.EmailCodeCer(mav);
					break;
				default:
				}
			} else {
				mav.setViewName("login");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/* AJAX 방식 Controller */
	public void backController(int serviceCode, Model model) {
		try {
			if (this.pu.getAttribute("accessInfo") != null) {
				switch (serviceCode) {
				case 0:
					break;
				default:
				}
			} else {

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 대쉬보드 화면 이동
	private void entrance(ModelAndView mav) {
		try {
			mav.addObject("RInvitation", this.receivedInvitationInfo(
					this.session.selectList("receivedInvitationInfo", (CerB) this.pu.getAttribute("accessInfo"))));
			mav.addObject("SInvitation", this.sendInvitationInfo(
					this.session.selectList("sendInvitationInfo", (CerB) this.pu.getAttribute("accessInfo"))));
			mav.addObject("ProjectInfo", this
					.projectInfo(this.session.selectList("getProjectInfo", (CerB) this.pu.getAttribute("accessInfo"))));
			/* 교수님ver
			 * mav.addObject("ProjectInfo", this.makeProjectSlide(this.session.selectList("getProject", (AuthB)this.pu.getAttribute("accessInfo"))));
			 * */
			mav.setViewName("dashBoard");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 메일로 보낸 인증코드 복호화하여 UPDATE -> PMB, AUL
	@Transactional
	private void EmailCodeCer(ModelAndView mav) {
		EmailCerB ecb = ((EmailCerB) mav.getModel().get("emailCerB"));
		CerB cb = null;
		try {
			cb = ((CerB) this.pu.getAttribute("accessInfo"));
			if (cb != null) {
				ecb.setEmailCode(this.enc.aesDecode(ecb.getEmailCode(), cb.getPmbEmail()));
				if (!this.convertToBoolean(this.session.update("updProjectMembers", ecb))) {
					ecb.setAulResultCode("NN");
					
				}
				this.session.update("updAuthLog", ecb);
				ProMemberB pro = new ProMemberB();
				pro.setProCode(ecb.getEmailCode());
				pro.setPmbCode(cb.getPmbCode());
				pro.setProPosition("MB");
				this.session.update("updPrmPosition",pro);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			mav.addObject("RInvitation",
					this.receivedInvitationInfo(this.session.selectList("receivedInvitationInfo", cb)));
			mav.addObject("SInvitation", this.sendInvitationInfo(this.session.selectList("sendInvitationInfo", cb)));
			mav.addObject("ProjectInfo", this.projectInfo(this.session.selectList("getProjectInfo", cb)));
			mav.setViewName("dashBoard");
		}
		this.entrance(mav);
	}

	// 받은 초청장 정보 HTML
	private String receivedInvitationInfo(List<CerLogB> list) {
		StringBuffer sb = new StringBuffer();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		try {
			if (list.size() > 0) {
				int idx = -1;
				sb.append("<div id=\"invitationReceive\" class=\"invitation receive\">");
				sb.append("<div class=\"notice title\"> 내가 받은 초대장 </div>");
				sb.append("<div id=\"receiveItems\">");
				sb.append(
						"<div class=\"items name\">발송인</div><div class=\"items invite\">초대일자</div><div class=\"items expire\">만료일자</div><div class=\"items accept\">회신</div>");
				sb.append("</div>");
				sb.append("<div class=\"invitationList\">");
				for (CerLogB cl : list) {
					idx++;
					if (cl.getAuthResult().equals("NA")) {
						boolean expired = Long.parseLong(cl.getExpireDate().substring(0))
								- Long.parseLong(sdf.format(new Date())) >= 0 ? true : false;
								sb.append("<div id=\"member" + idx + "\" class=\"member\">");
								sb.append("<div class=\"items name\">"
										+ this.enc.aesDecode(cl.getSenderName(), cl.getSpmbCode()) + "</div>");
								sb.append("<div class=\"items invite\">" + cl.getInviteDate() + "</div>");
								sb.append("<div class=\"items expire\">" + cl.getExpireDate() + "</div>");
								sb.append("<div class=\"items accept\">");
								sb.append("<input type='button' onClick=\"window.invitationReplay(\'" + cl.getInviteDate()
								+ "\',\'" + cl.getSpmbCode() + "\',\'" + cl.getRpmbCode()
								+ "\', \'AC\', \'AU\')\" class=\"mini\" value=\"수락\" " + (expired ? "" : "disabled")
								+ " \\/>");
								sb.append("<input type='button' onClick=\"window.invitationReplay(\'" + cl.getInviteDate()
								+ "\',\'" + cl.getSpmbCode() + "\',\'" + cl.getRpmbCode()
								+ "\', \'RF\', \'AU\')\" class=\"mini\" value=\"거절\" " + (expired ? "" : "disabled")
								+ " \\/>");
								sb.append("</div>");
								sb.append("</div>");
					}
				}
				sb.append("</div>");
				sb.append("</div>");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sb.toString();
	}

	// 보낸 초청장 정보 HTML
	private String sendInvitationInfo(List<CerLogB> list) {
		StringBuffer sb = new StringBuffer();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		try {
			if (list.size() > 0) {
				int idx = -1;
				sb.append("<div id=\"invitationSend\" class=\"invitation send\">");
				sb.append("<div class=\"notice title\"> 내가 보낸 초대장 </div>");
				sb.append("<div id=\"senderItems\">");
				sb.append(
						"<div class=\"items name\">수취인</div><div class=\"items invite\">초대일자</div><div class=\"items expire\">만료일자</div><div class=\"items accept\">회신</div>");
				sb.append("</div>");
				sb.append("<div class=\"invitationList\">");
				for (CerLogB cl : list) {
					idx++;
					boolean expired = Long.parseLong(cl.getExpireDate().substring(0))
							- Long.parseLong(sdf.format(new Date())) >= 0 ? true : false;
							sb.append("<div id=\"receiver" + idx + "\" class=\"member\">");
							sb.append("<div class=\"items name\">" + this.enc.aesDecode(cl.getReceiverName(), cl.getRpmbCode())
							+ "</div>");
							sb.append("<div class=\"items invite\">" + cl.getInviteDate() + "</div>");
							sb.append("<div class=\"items expire\">" + cl.getExpireDate() + "</div>");
							sb.append(
									"<div class=\"items accept\">" + ((expired) ? cl.getAuthResultName() : "인증만료") + "</div>");
							sb.append("</div>");

				}
				sb.append("</div>");
				sb.append("</div>");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sb.toString();
	}

	// 내가 참여한 프로젝트 정보 HTML
	private String projectInfo(List<ProjectInfoB> list) {
		StringBuffer sb = new StringBuffer();
		try {
			CerB cb = (CerB) this.pu.getAttribute("accessInfo");
			
			if (list.size() > 0) {
				int idx = -1;
				for (ProjectInfoB pib : list) {
					idx++;
					sb.append("<div class = 'slide'>");
					sb.append("<div class = 'plzec'>");
					sb.append("<input type = 'hidden' class = 'proCode' value = '" + pib.getProCode()
					+ "' onClick = '' />");
					sb.append("<div class = 'header title'> 프로젝트명 : " + pib.getProName() + "</div>");
					sb.append("<input type = 'hidden' class = 'dirCode' value = '" + pib.getDirCode()
					+ "' onClick = '' />");
					sb.append("<div class = 'header person'> 매니저이름 : "
							+ this.enc.aesDecode(pib.getDirector(), pib.getDirCode()) + "</div>");
					sb.append("<div class = 'header person'> 프로젝트인원 : " + this.session.selectOne("getMemberNum", pib)  + "</div>");
					sb.append("<div class = 'header period'> 프로젝트기간 :" + pib.getPeriod() + "</div>");
					
					sb.append("<div class = 'shortcut'>");
					sb.append("<input type = 'button' class = 'exec progress' value = '프로젝트진행현황' onClick = 'progressCtl(\""+list.get(idx).getProCode()+"\")' />");
					sb.append("<input type = 'button' class = 'exec member' value = '멤버관리' onClick = 'window.memberCtl("+idx+")' />");
					sb.append("<input type = 'button' class = 'exec job' value = '업무관리' onClick = 'window.jobCtl()' />");
					sb.append("<input type = 'button' class = 'exec result' value = '결과관리' onClick = 'resultCtl(\""+list.get(idx).getProCode()+"\")'  />");
					sb.append("</div>");
					sb.append("</div>");
					sb.append("</div>");
					System.out.println("proCode= "+list.get(idx).getProCode());

				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sb.toString();
	}
	/* 프로젝트 슬라이드 */
/*	private String makeProjectSlide(List<ProBean> project) {
		StringBuffer sb = new StringBuffer();

		if(project != null && project.size() > 0) {
			for(ProBean pb : project) {
				sb.append("<div class=\"slide\">");
				sb.append("<div class=\"plzec\">");
				sb.append("<div class=\"header title\">" + pb.getProName() + "</div>");
				int count = 0;
				for(ProMembersB pm : pb.getProMembers()) {
					if(pm.getProAccept().equals("AC")) count++; 
					if(pm.getProPosition() != null && pm.getProPosition().equals("MG")) {
						try{
							sb.append("<div class=\"header director\">" + this.enc.aesDecode(pm.getPmbName(), pm.getPmbCode()) + "("+ pm.getPmbCode() +")</div>");
						}catch(Exception e) {e.printStackTrace();}
					}
				}
				
				sb.append("<div class=\"header person\">" + count + " Members</div>");
				sb.append("<div class=\"header period\">" + pb.getProStart() + " ~ " + pb.getProEnd() + "</div>");
				sb.append("<div class=\"shortcut\">");
				sb.append("<button class=\"exec progress\">프로젝트진행현황</button>");
				sb.append("<button class=\"exec member\">멤버관리</button>");
				sb.append("<button class=\"exec job\" onClick=\"mgrJob(\'" + pb.getProCode() + "\')\">업무관리</button>");
				sb.append("<button class=\"exec result\">결과관리</button>");
				sb.append("</div></div></div>");
			}
		}

		return sb.toString();
	}*/
	// INSERT OR UPDATE 되었는지 확인
	private boolean convertToBoolean(int number) {
		return number == 0 ? false : true;
	}

}
