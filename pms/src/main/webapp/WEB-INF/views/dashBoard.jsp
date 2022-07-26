<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>::PMS Template::</title>
<script src="/resources/js/common.js" type=""></script>
<script>
let info = [];

function invitationReplay(inviteDate, sander, receiver, prmCode, aulCode){
	const lightBox = makeLightBox("인증 등록", "sendServer", "cancelSend");
	const codeInput = createInput("text", "emailCode", "인증 코드 입력", "box");
	
	document.body.appendChild(lightBox);
	let image = document.querySelector("#image");
/* 	image.style.backgroundImage = "url('/res/images/project.jpg')"; */
	image.style.backgroundSize = "cover";
	
	let box = document.querySelector(".light-box");
	box.style.width = "50%";
	box.style.height = "50%";
	
	let cBody = document.getElementById("cbody");	
	cBody.appendChild(codeInput);
		
	info.push(inviteDate);
	info.push(sander);
	info.push(receiver);
	info.push(prmCode);
	info.push(aulCode);
	
	lightBox.style.display = "block";
}

function sendServer(){
	const objName = ["inviteDate", "sander", "receiver", "proAcceptCode", "aulResultCode", "emailCode"];
	const form = document.getElementsByName("clientData")[0];
	const emailCode = document.getElementsByName("emailCode")[0].value;
	if( emailCode == "") return;
	
	form.action = "EmailCodeCer";
	form.method = "post";
	
	info.push(emailCode);
	
	for(idx=0; idx<info.length; idx++){
		form.appendChild(createHidden(objName[idx], info[idx]));	
	}
	
	form.submit();
}
function cancelSend(){
	// lightBox  Remove
	cancelProject();
}
</script>
<style>
@import url("resources/css/common.css");
@import url("resources/css/slide.css");
</style>
</head>
<body>
	<div id="plzec-zone">
		<div id="menu-icon" onClick="newProject()">
			<div id="top" class="line"></div>
			<div id="mid" class="line"></div>
			<div id="btm" class="line"></div>
		</div>
		<div id="notice-zone">
			<div id="notice">
				<div id="notice-icon"></div>
				<div id="notice-article">공지사항</div>
			</div>
			<div id="my-info">로그인 정보</div>
		</div>
		<div id="menues">
			<div class="menu" onClick="moveDashBoard()">DB</div>
			<div class="menu" onClick="">PM</div>
		</div>
		<div id="content">
			<div id="invitationInfo">
				${RInvitation }
				${SInvitation }
			</div>
			<div class="frame">
				<div class="myProjects">
					<div class="slide">
						<div class="plzec">
							<div class="header title">First Project</div>
							<div class="header director">HoonZzang</div>
							<div class="header person">5</div>
							<div class="header period">-2</div>
							<div class="shortcut">
								<button class="exec progress">프로젝트진행현황</button>
								<button class="exec member">멤버관리</button>
								<button class="exec job">업무관리</button>
								<button class="exec result">결과관리</button>
							</div>
						</div>
					</div>
					<div class="slide">
						<div class="plzec">
							<div class="header title">Second Project</div>
							<div class="header director">HoonZzang</div>
							<div class="header person">5</div>
							<div class="header period">-1</div>
							<div class="shortcut">
								<button class="exec progress">프로젝트진행현황</button>
								<button class="exec member">멤버관리</button>
								<button class="exec job">업무관리</button>
								<button class="exec result">결과관리</button>
							</div>
						</div>
					</div>
					<div class="slide">
						<div class="plzec">
							<div class="header title">Third Project</div>
							<div class="header director">HoonZzang</div>
							<div class="header person">5</div>
							<div class="header period">0</div>
							<div class="shortcut">
								<button class="exec progress">프로젝트진행현황</button>
								<button class="exec member">멤버관리</button>
								<button class="exec job">업무관리</button>
								<button class="exec result">결과관리</button>
							</div>
						</div>
					</div>
					<div class="slide">
						<div class="plzec">
							<div class="header title">Fourth Project</div>
							<div class="header director">HoonZzang</div>
							<div class="header person">5</div>
							<div class="header period">1</div>
							<div class="shortcut">
								<button class="exec progress">프로젝트진행현황</button>
								<button class="exec member">멤버관리</button>
								<button class="exec job">업무관리</button>
								<button class="exec result">결과관리</button>
							</div>
						</div>
					</div>
					<div class="slide">
						<div class="plzec">
							<div class="header title">Fifth Project</div>
							<div class="header director">HoonZzang</div>
							<div class="header person">5</div>
							<div class="header period">2</div>
							<div class="shortcut">
								<button class="exec progress">프로젝트진행현황</button>
								<button class="exec member">멤버관리</button>
								<button class="exec job">업무관리</button>
								<button class="exec result">결과관리</button>
							</div>
						</div>
					</div>
				</div>
				<button id="prev">P</button>
				<button id="next">N</button>				
			</div>
		</div>
	</div>
	
	<form name="clientData"></form>
	<script src="resources/js/slide.js" ></script>
</body>
</html>