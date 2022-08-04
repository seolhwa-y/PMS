<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>::PMS New Project::</title>
<script src="resources/js/common.js" type=""></script>
<script>
function initNewPlzec(){
	document.getElementById("content").style.display="none";
	document.getElementById("list").innerText="";
	document.getElementById("invite").innerText="";
	
	const lightBox = makeLightBox("New Project", "regProject", "cancelProject");
	document.body.appendChild(lightBox);
	let image = document.querySelector("#image");
/* 	image.style.backgroundImage = "url('/res/images/project.jpg')"; */
	image.style.backgroundSize = "cover";
	
	let box = document.querySelector(".light-box");
	box.style.width = "50%";
	box.style.height = "50%";
	
	let cBody = document.getElementById("cbody");
	
	/* PROJECT TITLE */
	let proName = createInput("text", "proInfo", "프로젝트 명", "box");
	cBody.appendChild(proName);
	/* PROJECT COMMENTS */
	let	comments = createTextarea("proInfo", 3, 30, "box");
	cBody.appendChild(comments);
	
	/* PROJECT DATE */
	let date1 = createInput("date", "proInfo", "프로젝트 시작", "box");
	let date2 = createInput("date", "proInfo", "프로젝트 종료", "box");
	cBody.appendChild(date1);
	cBody.appendChild(date2);
	
	/* PROJECT VISIBLE */
	let pub = createInput("button", "proInfo", "", "box");
	pub.setAttribute("value", "공개");
	pub.style.backgroundColor = "rgba(0,84,255,1)";
	pub.style.color = "rgba(255,255,255, 1)";
	pub.addEventListener("click", toggleButton);

	cBody.appendChild(pub);
	
 	lightBox.style.display = "block";
}
function regProject(){
	const dataName = ["proName", "proComment", "proStart", "proEnd", "proVisible"];
	const formData = document.getElementsByName("proInfo");
	let clientData = "";
	alert(formData[3].value);
	for(idx=0;idx<formData.length;idx++){
		clientData += (idx==0? "":"&");
		clientData += (dataName[idx] + "=" + formData[idx].value);
	}
	
	postAjaxJson("RegProject", clientData, "callBack");
}

function callBack(ajaxData){
	const memberList = JSON.parse(ajaxData);
	
	if(memberList[0].message != "프로젝트등록실패"){
		/* 프로젝트 등록 정보 복사하기 */
		const formData = document.getElementsByName("proInfo");
		let projectInfo = document.getElementById("projectInfo");
		
		const child = projectInfo.childNodes;
		child[3].innerText = ("Code : " + memberList[0].message);
		child[5].innerText = ("Name : " + formData[0].value);
		child[11].innerText = ("Detail Comment : " + formData[1].value);
		child[7].innerText = ("Peoriod : " + formData[2].value + " ~ " + formData[3].value);
		child[9].innerText = ("Share : " + formData[4].value);
		
		/* 전체 멤버리스트 출력 */
		let list = document.getElementById("list");
		for(idx=0; idx<memberList.length;idx++){
			let info = "<span class='small'>"+ memberList[idx].pmbClassName +"</span><br/>";
			info += "<span calss='general'>"+ memberList[idx].pmbName + "[" + memberList[idx].pmbLevelName + "]</span>";
			let div = createDiv("", "box multi", memberList[idx].pmbCode +":"+memberList[idx].pmbEmail, info);
			div.addEventListener("dblclick", function(){
				moveDiv(this);
			});
			list.appendChild(div);
		}
		
		/* 프로젝트 등록 창 삭제 */
		cancelProject();
		document.getElementById("content").style.display="block";
	}else{
		alert(memberList[0].message);
	}
		
}

function moveDiv(obj){
	let pmbMembers = document.getElementById("list");
	let proMembers = document.getElementById("invite");
	let sendBtn = document.getElementById("send");
	if(obj.className=="box multi"){
		proMembers.appendChild(obj);
		obj.className="box multi invite";
	}else{
		pmbMembers.appendChild(obj);
		obj.className="box multi";
	}
	sendBtn.style.display = (proMembers.childNodes.length>0)? "block" : "none";
}

function toggleButton(){

	let visible = document.getElementsByName("proInfo")[4];
	if(visible.value == "공개"){
		visible.value = "비공개";
		visible.style.backgroundColor = "rgba(237,0,0,1)";
	}else{
		visible.value = "공개";
		visible.style.backgroundColor = "rgba(0,84,255,1)";
	}
}

function sendEmail(){
	/* PROJECT CODE 가져오기 */
	const projectCode = document.getElementById("projectInfo").childNodes[3].innerText.substr(7,20);
	let clientData = "proCode=" + projectCode;	
	const inviteMembers = document.getElementById("invite").childNodes;
	for(let idx=0; idx<inviteMembers.length; idx++){
		const info = inviteMembers[idx].getAttribute("value").split(":");
		clientData += "&proMembers["+ idx +"].pmbCode="+info[0] +"&proMembers["+ idx +"].proEmail="+ info[1];
	}
	alert(clientData);
	postAjaxJson("InviteMember", clientData, "sendMailResult");
}

function sendEmail2(){
	let form = document.getElementsByName("clientData")[0];
	form.action="InviteMemberV";
	form.method="post";
	
	/* PROJECT CODE 가져오기 */
	form.appendChild(createHidden("proCode", document.getElementById("projectInfo").childNodes[3].innerText.substr(7,20)));
	
	const inviteMembers = document.getElementById("invite").childNodes;
	for(let idx=0; idx<inviteMembers.length; idx++){
		const info = inviteMembers[idx].getAttribute("value").split(":");
		form.appendChild(createHidden("proMembers["+ idx +"].pmbCode", info[0]));
		form.appendChild(createHidden("proMembers["+ idx +"].proEmail", info[1]));
		form.appendChild(createHidden("proMembers["+ idx +"].proPosition", ""/* info[2] */)); // 선택된 아가들꺼
		form.appendChild(createHidden("proMembers["+ idx +"].proAccept", 'ST'));
	}
	
	form.submit();
	
}

function sendMailResult(ajaxData){
	alert(ajaxData);
}
</script>
<style>
@import url("resources/css/common.css");
.pro		{position:relative; float:left;
	width:30%; height:90%;margin-top:2%; margin-left:2.5%;
	border:1px solid rgba(255, 187, 0, 1);
	text-align:center;}
.pro.list	{margin-left:2.1%;overflow-x:hidden;overflow-y:auto;}
.pro.list.items	{border:0px; width:90%; height:100%;margin-left:0;}
.pro.invite.items	{border:0px; width:100%; height:70%;margin-left:0;}

</style>
</head>
<body onLoad="initNewPlzec()">
	<div id="plzec-zone">
		<div id="menu-icon" onClick="initNewPlzec()">
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
		</div>
		<div id="menues">
			<div class="menu" onClick="moveDashBoard()">DB</div>
			<div class="menu" onClick="">PM</div>
		</div>
		<div id="content">
			<div id="projectInfo" class="pro">
				<div class="box item title">New Project Information</div>
				<div class="box item"></div>
				<div class="box item"></div>
				<div class="box item"></div>
				<div class="box item"></div>
				<div class="box item textareabox"></div>
			</div>
			<div id="pmbMembers" class="pro list">
				<div class="box item title">초대 가능한 멤버</div>
				<div id="list" class="pro list items"></div>
			</div>
			<div id="proMembers" class="pro list">
				<div class="box item title">초대 예정 멤버</div>
				<div id="invite" class="pro invite items"></div>
				<div id="send" style="display:none;"><input type="button" class="btn" value="SEND EMAIL" onClick="sendEmail2()"/></div>
			</div>
		</div>
	
	
	<form name="clientData"></form>
</body>
</html>