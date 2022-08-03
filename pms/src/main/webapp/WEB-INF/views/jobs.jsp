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
	
	modalBottom.innerHTML = "<input type='button' class='box' value='O' onclick=\"updModuleCtl(\'"+code+"\')\"/>"
							+"<input type='button' class='box' value='X' onclick='cancel()'/>";
	
	modalBox.style.display = "block";
}
function updModuleCtl(code){
	alert(code);
	const moduleName = document.querySelector(".moduleName");
	const moduleComment = document.querySelector(".moduleComment");
	let info = code.split(":");
	let clientData = "proCode="+info[0]+"&mouCode="+info[1]+"&mouName="+moduleName.value+"&mouComments="+moduleComment.value;
	alert(clientData);
	
	postAjaxJson("UpdModule", clientData, "callBack1");
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
	modalContent.innerHTML = "<input type='button'class='box' value='O' onclick=\"delModuleCtl(\'"+code+"\')\"/>"
	+"<input type='button' class='box' value='X' onclick='cancel()'/>";
	
	modalBox.style.display = "block";
}
function delModuleCtl(code){
	let info = code.split(":");
	let clientData = "proCode="+info[0]+"&mouCode="+info[1];
	alert(clientData);
	
	postAjaxJson("DelModule", clientData, "callBack1");
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
	modalContent.innerHTML = "모듈 코드 : <input class='box moduleCode' type='text' maxlength='2' />"
							+"모듈 이름 : <input class='box moduleName' type='text' />"
							+"모듈 설명 : <input class='box moduleComments' type='text' />";
	modalBottom.innerHTML = "<input type='button' class='box' value='O' onclick=\"insModuleCtl(\'"+proCode+"\')\"/>"
	+"<input type='button' class='box' value='X' onclick='cancel()'/>";

}
function insModuleCtl(proCode){
	let moduleCode = document.querySelector(".moduleCode").value;
	let moduleName = document.querySelector(".moduleName").value;
	let moduleComments = document.querySelector(".moduleComments").value;
	alert(proCode);
	let clientData = "proCode="+proCode+"&mouCode="+moduleCode+"&mouName="+moduleName+"&mouComments="+moduleComments;
	alert(clientData);
	
	
	postAjaxJson("InsModule", clientData, "callBack1");
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
	
	modalBottom.innerHTML = "<input class='box' type='button' value='O' onclick=\"updJobsCtl(\'"+code+"\')\"/>"
							+"<input class='box' type='button' value='X' onclick='cancel()'/>";
	
	modalBox.style.display = "block";
	
}
function updJobsCtl(code){
	alert(code);
	const josName = document.querySelector(".josName");
	const josComment = document.querySelector(".josComment");
	let info = code.split(":");
	let clientData = "proCode="+info[0]+"&josCode="+info[1]+"&josName="+josName.value+"&josComments="+josComment.value;
	alert(clientData);
	
	postAjaxJson("UpdJobs", clientData, "callBack2");
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
	modalContent.innerHTML = "<input class='box' type='button' value='O' onclick=\"delJobsCtl(\'"+code+"\')\"/>"
	+"<input class='box' type='button' value='X' onclick='cancel()'/>";
	
	modalBox.style.display = "block";
}
function delJobsCtl(code){
	let info = code.split(":");
	let clientData = "proCode="+info[0]+"&josCode="+info[1];
	alert(clientData);
	
	postAjaxJson("DelJobs", clientData, "callBack2");
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
	modalContent.innerHTML = "좝 코드 : <input class='box jobsCode' type='text' maxlength='3' />"
							+"좝 이름 : <input class='box jobsName' type='text' />"
							+"좝 설명 : <input class='box jobsComments' type='text' />";
	modalBottom.innerHTML = "<input class='box' type='button' value='O' onclick=\"insJobsCtl(\'"+proCode+"\')\"/>"
	+"<input class='box' type='button' value='X' onclick='cancel()'/>";

}
function insJobsCtl(proCode){
	let JobsCode = document.querySelector(".jobsCode").value;
	let JobsName = document.querySelector(".jobsName").value;
	let JobsComments = document.querySelector(".jobsComments").value;
	alert(proCode);
	let clientData = "proCode="+proCode+"&josCode="+JobsCode+"&josName="+JobsName+"&josComments="+JobsComments;
	alert(clientData);
	
	postAjaxJson("InsJobs", clientData, "callBack2");
}
function updModuleJobs(code){ // code = proCode:mouCode:josCode:pmbCode
	alert("updJobs진입");
	let info = code.split(":");
	let modalContent = document.querySelector("#modalContent");
	let modalBox = document.querySelector("#modalBox");
	let modalTitle = document.querySelector("#modalTitle");
	let modalBottom = document.querySelector("#modalBottom");
	modalContent.innerHTML= "";
	
	modalTitle.innerText="모듈앤좝 수정";
	
	modalContent.innerHTML = "${UpdModuleJobList}"
	modalBottom.innerHTML = "<input class='box' type='button' value='O' onclick=\"updModuleJobsCtl(\'"+code+"\')\"/>"
							+"<input class='box' type='button' value='X' onclick='cancel()'/>";
	
	modalBox.style.display = "block";
	
}
function updModuleJobsCtl(code){
	alert(code);
	let mjPmb = document.getElementsByName("mjPmb")[0];
	let pmbCode = mjPmb.options[mjPmb.selectedIndex].value;
	
	let info = code.split(":");
	let clientData = "proCode="+info[0]+"&mouCode="+info[1]+"&josCode="+info[2]+"&pmbCode="+pmbCode;
	alert(clientData);
	
	postAjaxJson("UpdModuleJobs", clientData, "callBack3");
}
function delModuleJobs(code){// code = proCode:mouCode:josCode:pmbCode
	alert(code);
	let modalContent = document.querySelector("#modalContent");
	let modalBox = document.querySelector("#modalBox");
	let modalTitle = document.querySelector("#modalTitle");
	let modalBottom = document.querySelector("#modalBottom");
	modalTitle.innerHTML="";
	modalContent.innerHTML= "";
	modalBottom.innerHTML="";
	
	modalTitle.innerText = "모듈앤좝 삭제";
	modalContent.innerHTML = "<input class='box' type='button' value='O' onclick=\"delModuleJobsCtl(\'"+code+"\')\"/>"
	+"<input class='box' type='button' value='X' onclick='cancel()'/>";
	
	modalBox.style.display = "block";
}
function delModuleJobsCtl(code){
	let info = code.split(":");
	let clientData = "proCode="+info[0]+"&mouCode="+info[1]+"&josCode="+info[2]+"&pmbCode="+info[3];
	alert(clientData);
	
	postAjaxJson("DelModuleJobs", clientData, "callBack3");
}
function insModuleJobs(proCode){
	alert(proCode);
	let modalContent = document.querySelector("#modalContent");
	let modalBox = document.querySelector("#modalBox");
	let modalTitle = document.querySelector("#modalTitle");
	let modalBottom = document.querySelector("#modalBottom");
	modalContent.innerHTML= "";
	modalBottom.innerHTML="";
	
	modalTitle.innerText = "모듈좝 등록";
	modalContent.innerHTML = "${insMJList}";
	modalBottom.innerHTML = "<input class='box' type='button' value='O' onclick=\"insModuleJobsCtl(\'"+proCode+"\')\"/>"
	+"<input class='box' type='button' value='X' onclick='cancel()'/>";

}
function insModuleJobsCtl(proCode){
	let mjMou = document.getElementsByName("mjMou")[0];
	let MouCode = mjMou.options[mjMou.selectedIndex].value;

	let mjJos = document.getElementsByName("mjJos")[0];
	let JosCode = mjJos.options[mjJos.selectedIndex].value;
	
	let mjPmb = document.getElementsByName("mjPmb")[0];
	let PmbCode = mjPmb.options[mjPmb.selectedIndex].value;

	let clientData = "proCode="+proCode+"&mouCode="+MouCode+"&josCode="+JosCode+"&pmbCode="+PmbCode;
	alert(clientData);
	
	postAjaxJson("InsMJ", clientData, "callBack3"); 
}
function updMethod(code){// code = proCode:mouCode:josCode:metCode:mcCode
	alert("updJobs진입");
	let info = code.split(":");
	let modalContent = document.querySelector("#modalContent");
	let modalBox = document.querySelector("#modalBox");
	let modalTitle = document.querySelector("#modalTitle");
	let modalBottom = document.querySelector("#modalBottom");
	modalContent.innerHTML= "";
	
	modalTitle.innerText="메서드 수정";
	
	modalContent.innerHTML = "<input id='metName' maxlength='2' type='text' placeholder='메서드 네임을 입력하세요'/>";
	modalContent.innerHTML += "${UpdMethodList}";
	
	modalBottom.innerHTML = "<input class='box' type='button' value='O' onclick=\"updMethodCtl(\'"+code+"\')\"/>"
							+"<input class='box' type='button' value='X' onclick='cancel()'/>";
	
	modalBox.style.display = "block";
	
}
function updMethodCtl(code){
	alert(code);
	let mcInfo = document.getElementsByName("mcInfo")[0];
	let mcInfoCode = mcInfo.options[mcInfo.selectedIndex].value;
	let metName = document.getElementById("metName").value;
	
	let info = code.split(":");
	let clientData = "proCode="+info[0]+"&mouCode="+info[1]+"&josCode="+info[2]+"&metCode="+info[3]+"&mcCode="+mcInfoCode+"&metName="+metName;
	alert(clientData);
	
	postAjaxJson("UpdMethod", clientData, "callBack4");
}
function delMethod(code){// code = proCode:mouCode:josCode:metCode:mcCode
	alert(code);
	let modalContent = document.querySelector("#modalContent");
	let modalBox = document.querySelector("#modalBox");
	let modalTitle = document.querySelector("#modalTitle");
	let modalBottom = document.querySelector("#modalBottom");
	modalTitle.innerHTML="";
	modalContent.innerHTML= "";
	modalBottom.innerHTML="";
	
	modalTitle.innerText = "메서드 좝 삭제";
	modalContent.innerHTML = "<input class='box' type='button' value='O' onclick=\"delMethodCtl(\'"+code+"\')\"/>"
	+"<input class='box' type='button' value='X' onclick='cancel()'/>";
	
	modalBox.style.display = "block";
}
function delMethodCtl(code){
	let info = code.split(":");
	let clientData = "proCode="+info[0]+"&mouCode="+info[1]+"&josCode="+info[2]+"&metCode="+info[3]+"&mcCode="+info[4];
	alert(clientData);
	
	postAjaxJson("DelMethod", clientData, "callBack4");
}
function insMethod(proCode){
		alert(proCode);
	let modalContent = document.querySelector("#modalContent");
	let modalBox = document.querySelector("#modalBox");
	let modalTitle = document.querySelector("#modalTitle");
	let modalBottom = document.querySelector("#modalBottom");
	modalContent.innerHTML= "";
	modalBottom.innerHTML="";
	
	modalTitle.innerText = "메서드 등록";
	modalContent.innerHTML = "<input id='metName' type = 'text' maxlength = '2' placeholder='메서드 이름을 입력하세요'/>";
	modalContent.innerHTML += "${insMetList}";
	modalBottom.innerHTML = "<input class='box' type='button' value='O' onclick=\"insMethodCtl(\'"+proCode+"\')\"/>"
	+"<input class='box' type='button' value='X' onclick='cancel()'/>";

}
function insMethodCtl(proCode){
	alert(proCode);
	let mjMou = document.getElementsByName("mjMou")[0];
	let MouCode = mjMou.options[mjMou.selectedIndex].value;

	let mjJos = document.getElementsByName("mjJos")[0];
	let JosCode = mjJos.options[mjJos.selectedIndex].value;
	
	let mcInfo = document.getElementsByName("mcInfo")[0];
	let mcInfoCode = mcInfo.options[mcInfo.selectedIndex].value;
	
	let metName = document.getElementById("metName").value;
	
	let clientData = "proCode="+proCode+"&mouCode="+MouCode+"&josCode="+JosCode+"&mcCode="+mcInfoCode+"&metName="+metName;
	alert(clientData);
	
	postAjaxJson("InsMet", clientData, "callBack4"); 
}
function callBack1(ajaxData){
	let NewModuleList = document.getElementById("newModuleList");
	NewModuleList.innerHTML = "";
	
	const info = JSON.parse(ajaxData);
 	alert(info.length);
 	alert(info.size);
	for(idx=0; idx<info.length; idx++) {
		NewModuleList.innerHTML += "<div class = 'ModuleList' >";
		NewModuleList.innerHTML += "<div> 순번 : " + idx + "</div>";
		NewModuleList.innerHTML += "<div>MOUNAME = " + info[idx].mouName + "</div>";
		NewModuleList.innerHTML += "<div>MOUCOMMENTS = " + ((info[idx].mouComments == null)? "none" : info[idx].mouComments) + "</div>";
		NewModuleList.innerHTML += "<input type='button' class='box' value='수정' onclick=\"updModule(\'"+ info[idx].proCode +":"+ info[idx].mouCode +":"+ info[idx].mouName +":"+ info[idx].mouComments+"\')\"/>";
		NewModuleList.innerHTML += "<input type='button' class='box' value='삭제' onclick=\"delModule(\'"+ info[idx].proCode +':'+ info[idx].mouCode +":" +"\')\"/>";
		NewModuleList.innerHTML += "</div>";

	}
	}
	

function callBack2(ajaxData){
	let NewJobsList = document.getElementById("newJobsList");
	NewJobsList.innerHTML = "";
	
	const info = JSON.parse(ajaxData);
 	alert(info.length);
 	alert(info.size);
	for(idx=0; idx<info.length; idx++) {
		NewJobsList.innerHTML += "<div class = 'NewJobsList' >";
		NewJobsList.innerHTML += "<div> 순번 : " + idx + "</div>";
		NewJobsList.innerHTML += "<div>JOSNAME = " + info[idx].josName + "</div>";
		NewJobsList.innerHTML += "<div>JOSCOMMENTS = " + ((info[idx].josComments == null)? "none" : info[idx].josComments) + "</div>";
		NewJobsList.innerHTML += "<input type='button' class='box' value='수정' onclick=\"updModule(\'"+ info[idx].proCode +":"+ info[idx].josCode +":"+ info[idx].josName +":"+ info[idx].josComments+"\')\"/>";
		NewJobsList.innerHTML += "<input type='button' class='box' value='삭제' onclick=\"delModule(\'"+ info[idx].proCode +':'+ info[idx].josCode +":" +"\')\"/>";
		NewJobsList.innerHTML += "</div>";

	}
	}

function callBack3(ajaxData){
	let NewModuleJobsList = document.getElementById("newModuleJobsList");
	NewModuleJobsList.innerHTML = "";
	
	const info = JSON.parse(ajaxData);
 	alert(info.length);
 	alert(info.size);
	for(idx=0; idx<info.length; idx++) {
		NewModuleJobsList.innerHTML += "<div class = 'ModuleList' >";
		NewModuleJobsList.innerHTML += "<div> 순번 : " + idx + "</div>";
		NewModuleJobsList.innerHTML += "<div>MOUNAME = " + info[idx].mouName + "</div>";
		NewModuleJobsList.innerHTML += "<div>JOSNAME = " + info[idx].josName + "</div>";
		NewModuleJobsList.innerHTML += "<div>PMBNAME = " + info[idx].pmbName + "</div>";
		NewModuleJobsList.innerHTML += "<input type='button' class='box' value='수정' onclick=\"updModule(\'"+ info[idx].proCode +":"+ info[idx].mouCode +":"+ info[idx].pmbCode +":"+ info[idx].pmbName+"\')\"/>";
		NewModuleJobsList.innerHTML += "<input type='button' class='box' value='삭제' onclick=\"delModule(\'"+ info[idx].proCode +':'+ info[idx].mouCode +":" + info[idx].pmbCode +"\')\"/>";
		NewModuleJobsList.innerHTML += "</div>";

	}
	}

function callBack4(ajaxData){
	let NewMethodList = document.getElementById("newMethodList");
	NewMethodList.innerHTML = "";
	
	const info = JSON.parse(ajaxData);
 	alert(info.length);
 	alert(info.size);
	for(idx=0; idx<info.length; idx++) {

		NewMethodList.innerHTML += "<div class = 'ModuleList' >";
		NewMethodList.innerHTML += "<div> 순번 : " + (idx+1) + "</div>";
		NewMethodList.innerHTML += "<div>MOUNAME = " + info[idx].mouName + "</div>";
		NewMethodList.innerHTML += "<div>JOSNAME = " + info[idx].josName + "</div>";
		NewMethodList.innerHTML += "<div>METNAME = " + info[idx].metName + "</div>";
		NewMethodList.innerHTML += "<div>MCNAME = " + info[idx].mcName + "</div>";
		NewMethodList.innerHTML += "<input type='button' class='box' value='수정' onclick=\"updModule(\'"+ info[idx].proCode +':'+ info[idx].mouCode +":"+ info[idx].josCode +":"+ info[idx].metCode +":"+ info[idx].mcCode +"\')\"/>";
		NewMethodList.innerHTML += "<input type='button' class='box' value='삭제' onclick=\"delModule(\'"+ info[idx].proCode +':'+ info[idx].mouCode +":"+ info[idx].josCode +":"+ info[idx].metCode +":"+ info[idx].mcCode +"\')\"/>";
		NewMethodList.innerHTML += "</div>";

	}
	}

function confirm(){
	const moduleName = document.querySelector(".moduleName");
	const moduleComment = document.querySelector(".moduleComment");
}
function cancel(){
	let modalBox = document.getElementById("modalBox");
	modalBox.style.display = "none";
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
			<div id = "moduleList" style = "text-align:center;">
				<div id = "ModuleList"  class = "module"><h3>모듈 관리</h3>
					<input type="button" class='box' value ="등록" onclick="insModule('${param.proCode}')"/>
					<div id = "newModuleList">${ModuleList}</div>
				 </div>
				<div id = "JobList" class = "module"><h3>잡 관리</h3>
					<input type="button" class='box' value ="등록" onclick="insJobs('${param.proCode}')"/>
				  <div id = "newJobsList">${JobList}</div>
				  </div>
				<div id = "ModuleJobList" class = "module"><h3>모듈-잡 연계</h3> 
					<input type="button" class='box' value ="등록" onclick="insModuleJobs('${param.proCode}')"/>
				  <div id = "newModuleJobsList">${ModuleJobList}</div>
	
				  </div>
				<div id = "MethodList" class = "module"><h3>메소드 등록</h3> 
					<input type="button" class='box' value ="등록" onclick="insMethod('${param.proCode}')"/>
				  <div id = "newMethodList">${MethodList}</div>
				  
				  </div>
			</div>
		</div>

	<form name="clientData"></form>
</body>
</html>