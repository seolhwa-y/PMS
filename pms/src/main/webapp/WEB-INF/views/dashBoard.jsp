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

function jobCtl(){
	const form = document.getElementsByName("clientData")[0];
	form.action = "MoveJobs";
	form.method = "post";
	let proCode = document.getElementsByClassName("proCode")[0].value;
	form.appendChild(createHidden("proCode", proCode));
	
	form.submit();
	
}

function memberCtl(idx){
	const form = document.getElementsByName("clientData")[0];
	form.action = "MoveMemberMgr";
	form.method = "post";
	let proCode = document.getElementsByClassName("proCode")[idx].value;
	form.appendChild(createHidden("proCode", proCode));
	
	form.submit();
}

function progressCtl(){
	const form = document.getElementsByName("clientData")[0];
	form.action = "MoveProgressMgr";
	form.method = "post";
	let proCode = document.getElementsByClassName("proCode")[0].value;
	form.appendChild(createHidden("proCode", proCode));
	
	form.submit();
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
			<div id="my-info">회원코드 : ${accessInfo.pmbCode} /
		회원성명 : ${accessInfo.pmbName} /
		회원등급 : ${accessInfo.pmbLevelName}
		<input id="accessOutBtn" value="로그아웃" type="button" onclick="accessOut()" /></div>
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
					${ProjectInfo }
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