<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>::PMS Jobs::</title>
<script src="resources/js/common.js" type=""></script>
<script>

function initJobs(){ 
/* 	
	const lightBox = makeLightBox("", "confirm", "cancel");
	document.body.appendChild(lightBox);

	let box = document.querySelector(".light-box");
	box.style.width = "50%";
	box.style.height = "50%";
	
	lightBox.style.display = ""; */
}

function updModule(code){ // code = proCode:mouCode:mouName:mouComment
	alert("updModule진입");
	let info = code.split(":");
	let modalContent = document.querySelector("#modalContent");
	let modalBox = document.querySelector("#modalBox");
	let modalTitle = document.querySelector("#modalTitle");
	let modalBottom = document.querySelector("#modalBottom");
	modalContent.innerHTML= "";
	
	modalTitle.innerText="모듈 수정";
	
	modalContent.innerHTML = "모듈 이름 : <input class='box moduleName' type='text' value=\'"+info[2]+"\' />"
							+"모듈 내용 : <input class='box moduleComment' type='text' value=\'"+info[3]+"\' />";
	
	modalBottom.innerHTML = "<input type='button' value='O' onclick=\"updModuleCtl(\'"+code+"\')\"/>"
							+"<input type='button' value='X' onclick='cancel()'/>";
	
	modalBox.style.display = "block";
}
function updModuleCtl(code){
	alert(code);
	const moduleName = document.querySelector(".moduleName");
	const moduleComment = document.querySelector(".moduleComment");
	let info = code.split(":");
	let clientData = "proCode="+info[0]+"&mouCode="+info[1]+"&mouName="+moduleName.value+"&mouComments="+moduleComment.value;
	alert(clientData);
	
	postAjaxJson("UpdModule", clientData, "callBack");
}
function delModule(code){ // code = proCode:mouCode
	alert(code);
	let modalContent = document.querySelector("#modalContent");
	let modalBox = document.querySelector("#modalBox");
	let modalTitle = document.querySelector("#modalTitle");
	let modalBottom = document.querySelector("#modalBottom");
	modalTitle.innerHTML="";
	modalContent.innerHTML= "";
	modalBottom.innerHTML="";
	
	modalTitle.innerText = "모듈 삭제";
	modalContent.innerHTML = "<input type='button' value='O' onclick=\"delModuleCtl(\'"+code+"\')\"/>"
	+"<input type='button' value='X' onclick='cancel()'/>";
	
	modalBox.style.display = "block";
}
function delModuleCtl(code){
	let info = code.split(":");
	let clientData = "proCode="+info[0]+"&mouCode="+info[1];
	alert(clientData);
	
	postAjaxJson("DelModule", clientData, "callBack");
}
function insModule(proCode){ 
	alert(proCode);
	let modalContent = document.querySelector("#modalContent");
	let modalBox = document.querySelector("#modalBox");
	let modalTitle = document.querySelector("#modalTitle");
	let modalBottom = document.querySelector("#modalBottom");
	modalContent.innerHTML= "";
	modalBottom.innerHTML="";
	
	modalTitle.innerText = "모듈 등록";
	modalContent.innerHTML = "모듈 코드 : <input class='moduleCode' type='text' maxlength='2' />"
							+"모듈 이름 : <input class='moduleName' type='text' />"
							+"모듈 설명 : <input class='moduleComments' type='text' />";
	modalBottom.innerHTML = "<input type='button' value='O' onclick=\"insModuleCtl(\'"+proCode+"\')\"/>"
	+"<input type='button' value='X' onclick='cancel()'/>";

}
function insModuleCtl(proCode){
	let moduleCode = document.querySelector(".moduleCode").value;
	let moduleName = document.querySelector(".moduleName").value;
	let moduleComments = document.querySelector(".moduleComments").value;
	alert(proCode);
	let clientData = "proCode="+proCode+"&mouCode="+moduleCode+"&mouName="+moduleName+"&mouComments="+moduleComments;
	alert(clientData);
	
	postAjaxJson("InsModule", clientData, "callBack");
}
function updJobs(code){ // code = proCode:josCode
	alert("updJobs진입");
	let info = code.split(":");
	let modalContent = document.querySelector("#modalContent");
	let modalBox = document.querySelector("#modalBox");
	let modalTitle = document.querySelector("#modalTitle");
	let modalBottom = document.querySelector("#modalBottom");
	modalContent.innerHTML= "";
	
	modalTitle.innerText="좝 수정";
	
	modalContent.innerHTML = "좝 이름 : <input class='box josName' type='text' value=\'"+info[2]+"\' />"
							+"좝 내용 : <input class='box josComment' type='text' value=\'"+info[3]+"\' />";
	
	modalBottom.innerHTML = "<input type='button' value='O' onclick=\"updJobsCtl(\'"+code+"\')\"/>"
							+"<input type='button' value='X' onclick='cancel()'/>";
	
	modalBox.style.display = "block";
	
}
function updJobsCtl(code){
	alert(code);
	const josName = document.querySelector(".josName");
	const josComment = document.querySelector(".josComment");
	let info = code.split(":");
	let clientData = "proCode="+info[0]+"&josCode="+info[1]+"&josName="+josName.value+"&josComments="+josComment.value;
	alert(clientData);
	
	postAjaxJson("UpdJobs", clientData, "callBack");
}
function delJobs(code){ // code = proCode:josCode
	alert(code);
	let modalContent = document.querySelector("#modalContent");
	let modalBox = document.querySelector("#modalBox");
	let modalTitle = document.querySelector("#modalTitle");
	let modalBottom = document.querySelector("#modalBottom");
	modalTitle.innerHTML="";
	modalContent.innerHTML= "";
	modalBottom.innerHTML="";
	
	modalTitle.innerText = "좝 삭제";
	modalContent.innerHTML = "<input type='button' value='O' onclick=\"delJobsCtl(\'"+code+"\')\"/>"
	+"<input type='button' value='X' onclick='cancel()'/>";
	
	modalBox.style.display = "block";
}
function delJobsCtl(code){
	let info = code.split(":");
	let clientData = "proCode="+info[0]+"&josCode="+info[1];
	alert(clientData);
	
	postAjaxJson("DelJobs", clientData, "callBack");
}
function insJobs(proCode){ 
	alert(proCode);
	let modalContent = document.querySelector("#modalContent");
	let modalBox = document.querySelector("#modalBox");
	let modalTitle = document.querySelector("#modalTitle");
	let modalBottom = document.querySelector("#modalBottom");
	modalContent.innerHTML= "";
	modalBottom.innerHTML="";
	
	modalTitle.innerText = "좝 등록";
	modalContent.innerHTML = "좝 코드 : <input class='jobsCode' type='text' maxlength='3' />"
							+"좝 이름 : <input class='jobsName' type='text' />"
							+"좝 설명 : <input class='jobsComments' type='text' />";
	modalBottom.innerHTML = "<input type='button' value='O' onclick=\"insJobsCtl(\'"+proCode+"\')\"/>"
	+"<input type='button' value='X' onclick='cancel()'/>";

}
function insJobsCtl(proCode){
	let JobsCode = document.querySelector(".jobsCode").value;
	let JobsName = document.querySelector(".jobsName").value;
	let JobsComments = document.querySelector(".jobsComments").value;
	alert(proCode);
	let clientData = "proCode="+proCode+"&josCode="+JobsCode+"&josName="+JobsName+"&josComments="+JobsComments;
	alert(clientData);
	
	postAjaxJson("InsJobs", clientData, "callBack");
}
function updModuleJobs(code){ // code = proCode:mouCode:josCode:pmbCode
	let cbody = document.getElementById("cbody");
	cbody.innerHTML= "";
	let canvas = document.getElementById("canvas");
	const info = code.split(":");

	cbody.innerHTML= "${updMJList}";
	
	canvas.style.display = "block";
}
function delModuleJobs(code){// code = proCode:mouCode:josCode:pmbCode
	alert(code);
}
function insModuleJobs(){
	
}
function updMethod(code){// code = proCode:mouCode:josCode:metCode:mcCode
	let cbody = document.getElementById("cbody");
	cbody.innerHTML= "";
	let canvas = document.getElementById("canvas");
	const info = code.split(":");


	cbody.innerHTML= "${updMetList}";
	
	
	canvas.style.display = "block";
}
function delMethod(code){// code = proCode:mouCode:josCode:metCode:mcCode
	alert(code);
}
function insMethod(){

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
function confirm(){
	const moduleName = document.querySelector(".moduleName");
	const moduleComment = document.querySelector(".moduleComment");
}
function cancel(){
	let canvas = document.getElementById("canvas");
	canvas.style.display = "none";
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

<style>
#modalBox {
 	position: absolute; 
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	display: none;
	background-color: rgba(0, 0, 0, 0.7);
}
#modalBoby {
 	position: absolute;
	width: 30%;
	height: 60%;
	top: 50%;
	left: 50%;
 	transform: translate(-50%, -50%); 
	background-color: #FFFFFF;
}
#modalTitle {
	display : flex;
	flex-direction: column;
	justify-content: center;
	width: 100%;
	height: 10%;
	font-size: 35px;
	text-align: center;
	font-weight: 800;
	/* 배경 그라데이션 */
	border:none;
	background: linear-gradient(to right top, rgb(64, 201, 247), rgb(205, 73, 253));
    color: #fff;
}
#modalContent {
	display : flex;
	flex-direction: column;
	justify-content: space-evenly;
	align-items: center;
	width: 100%;
	height: 70%;
}
#modalBottom {
	display : flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 20%;
}
</style>
</head>
<body onLoad="initJobs()" >
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
			<div id="modalBox">
				<div id="modalBody">
					<div id="modalTitle"></div>
					<div id="modalContent"></div>
					<div id="modalBottom"></div>
				</div>
			</div>
			<div id = "moduleList">
				<div id = "ModuleList" class = "module">모듈 관리
					<input type="button" value ="등록" onclick="insModule('${param.proCode}')"/>
				 ${ModuleList}</div>
				<div id = "JobList" class = "module">잡 관리
					<input type="button" value ="등록" onclick="insJobs('${param.proCode}')"/>
				  ${JobList}</div>
				<div id = "ModuleJobList" class = "module">모듈-잡 연계 
					<input type="button" value ="등록" onclick="insModuleJobs('${param.proCode}')"/>
				  ${ModuleJobList}</div>
				<div id = "MethodList" class = "module">메소드 등록 
					<input type="button" value ="등록" onclick="insMethod('${param.proCode}')"/>
				  ${MethodList}</div>
			</div>
		</div>

	<form name="clientData"></form>
</body>
</html>