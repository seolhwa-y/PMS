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
	alert("Jobs");
}
function changePJ(){
	let proCode = document.getElementById("projectName").value;
	const form = document.getElementsByName("clientData")[0];
	
	form.action = "MoveResultMgr";
	form.method = "post";
	form.appendChild(createHidden("proCode", proCode));
	
	form.submit();
}
function nextMc(code){ // code= proCode:mouCode:josCode:mcCode

	let info = code.split(":");
	let clientData="proCode="+info[0]+"&mouCode="+info[1]+"&josCode="+info[2];
	postAjaxJson("GetMcaList", clientData, "callBack");
}
function callBack(ajaxData){
	const mcaList = JSON.parse(ajaxData);
	
	for(idx=0;idx<4;idx++){
		let mcaDiv = document.getElementsByName("code")[idx];
		mcaDiv.innerHTML = "";
		mcaDiv.innerHTML = mcaList.mcaCount[idx][0]+
							   ":"+mcaList.mcaCount[idx][1]+
							   ":"+mcaList.mcaCount[idx][2]+
							   "/"+mcaList.mcaCount[idx][3];
		let code = mcaList.proCode+":"+mcaList.mouCode+":"+mcaList.josCode+":"+mcaList.mcCode[idx];
							
		mcaDiv.appendChild(createHidden("hiddenCode",code));
	}

}
function getMetList(num){
	 let code = "";
	 let info = []; 
	 let clientData = "";
	 

	switch(num){
	case "1" : code += document.getElementsByName("hiddenCode")[0].value;
			 info = code.split(":");
			 clientData += "proCode="+info[0]+"&mouCode="+info[1]+"&josCode="+info[2]+"&mcCode="+info[3];

			break;
	case "2" :code += document.getElementsByName("hiddenCode")[1].value;
			 info = code.split(":");
			 clientData += "proCode="+info[0]+"&mouCode="+info[1]+"&josCode="+info[2]+"&mcCode="+info[3];

			break;
	case "3" : code += document.getElementsByName("hiddenCode")[2].value;
			 info = code.split(":");
			 clientData += "proCode="+info[0]+"&mouCode="+info[1]+"&josCode="+info[2]+"&mcCode="+info[3];
			break;
	case "4" : code += document.getElementsByName("hiddenCode")[3].value;
			 info = code.split(":");
			 clientData += "proCode="+info[0]+"&mouCode="+info[1]+"&josCode="+info[2]+"&mcCode="+info[3];
			break;
			default:
	}
	postAjaxJson("GetMetList", clientData, "makeMethodList");
}
function makeMethodList(ajaxData){
	const metInfo = JSON.parse(ajaxData);
	const metList = metInfo.mcaList;
	let methodSpace = document.getElementById("16");
	methodSpace.innerHTML = "";
	let code ="";
	for(idx=0;idx<metList.length;idx++){
		code = metList[idx].proCode+":"+metList[idx].mouCode+":"+metList[idx].josCode+":"+metList[idx].pmbCode+":"+metList[idx].mcCode+":"+metList[idx].metCode+":"+metList[idx].metState;
		methodSpace.appendChild(createDiv("10"+idx,"", code, metList[idx].metName))
		let div = document.getElementById("10"+idx);
		div.addEventListener("click", function(){
			workSpace(div.getAttribute("value"));
		});
		if(metList[idx].metState == "RD"){
			div.setAttribute("class", "white");
		}else if(metList[idx].metState == "IN"){
			div.setAttribute("class", "blue");
		}else if(metList[idx].metState == "CP"){
			div.setAttribute("class", "gray");
		}
	}
	//alert("확인"+metList[0].proCode);
	//alert("확인"+metInfo);
	
}
function workSpace(code){
	//alert(code);
	let info = code.split(":");
	//info[6] = State
	//alert(info[6]);
	
	clear();
	switch(info[6]){
	case "RD" :alert("RD");	
	document.getElementById("22").style.display = "flex"; // 작업시작 버튼 보여주기
		break;
	case "IN" : alert("IN");
	document.getElementById("18").style.display = "flex"; // 파일추가 버튼 보여주기
	//document.getElementById("19").style.display = "flex"; // 파일삭제
	document.getElementById("20").style.display = "flex"; // 파일등록
	document.getElementById("21").style.display = "flex"; // 작업완료 버튼 보여주기
		break;
	case "CP" : alert("CP");
	document.getElementById("23").style.display = "flex"; // 서버전송 버튼 보여주기
		break;
		default:
	}
	
}
function clear(){
	let a = document.getElementById("18");
	a.style.display = "none"; // 파일추가 버튼 감추기
	//let b = document.getElementById("19");
	//b.style.display = "none"; // 파일삭제
	let c = document.getElementById("20");
	c.style.display = "none"; // 파일등록
	let d = document.getElementById("21");
	d.style.display = "none"; // 작업완료 버튼 감추기
	let e = document.getElementById("22");
	e.style.display = "none"; // 작업시작 버튼 감추기
	let f = document.getElementById("23");
	f.style.display = "none"; // 서버전송 버튼 감추기 
}
</script>
<style>
/* @import url("resources/css/common.css"); */
.pro		{position:relative; float:left;
	width:30%; height:90%;margin-top:2%; margin-left:2.5%;
	border:1px solid rgba(255, 187, 0, 1);
	text-align:center;}
.pro.list	{margin-left:2.1%;overflow-x:hidden;overflow-y:auto;}
.pro.list.items	{border:0px; width:90%; height:100%;margin-left:0;}
.pro.invite.items	{border:0px; width:100%; height:70%;margin-left:0;}

body	{ top:0; left:0;}
span	{ width:40%}
/* PMS Template */
#plzec-zone	{
	position:absolute; top:3px; left:3px; 
	width:calc(100% - 3px); height:calc(100% - 3px);background-color: rgba(76,76,76,1);
}
#menu-icon	{ float:left;
	width: 50px; height: 50px;
	border-right: 3px solid rgba(255, 255, 255, 1);
	border-bottom: 3px solid rgba(255, 255, 255, 1);
	background-color: rgba(33,33,33,1); color: rgba(255,187,0,1);
	font-size:2.5rem; text-align:center; line-height:40px;
	overflow:hidden;
}

#menu-icon:hover	{background-color:rgba(255,187,0,1); color:rgba(33,33,33,1);
	cursor:pointer;
	border-right-color:rgba(0, 0, 0, 1);
	border-bottom-color:rgba(0, 0, 0, 1);} 

.line	{
	width:42px; height:5px;
	background-color:rgba(255,255,255,1);margin:9px auto;
	transition-duration:0.5s;}

#menu-icon:hover #top{
	transform:translateY(15px) rotate(90deg);
	background-color:rgba(0,0,0,1)
}
#menu-icon:hover #mid{
	opacity:0;
}
#menu-icon:hover #btm{
	transform:translateY(-15px);
	background-color:rgba(0,0,0,1)
}


#notice-zone{ float:left;
	width: calc(100% - 56px); height: 50px;
	border-right: 3px solid rgba(255, 255, 255, 1);
	border-bottom: 3px solid rgba(255, 255, 255, 1); 
	background-color: rgba(255,187,0,1);
}

#notice	{position:relative; float:left; 
	top:50%;left:10%; transform:translate(-18%, -50%);
	width:50%; height:70%;
	background-color:rgba(33, 33, 33, 0.25);color:rgba(255,255,255,1);
	border-radius:5px;}
	
#notice-icon	{float:left; 
	width:7%;height:100%;
/* 	background-image: url('/res/images/megaphone.png'); */
	background-size:contain; background-repeat:no-repeat;}

#notice-article	{float:right;
	width:90%;height:100%; line-height:35px;
}

#my-info	{position:relative; float:left; 
	top:50%;left:10%; transform:translate(30%, -50%);
	width:30%; height:70%;line-height:35px; text-align:center;
	background-color:rgba(33, 33, 33, 0.25);color:rgba(255,255,255,1);
	border-radius:5px;}

#menues	{ float:left;
	width: 50px; height: calc(100% - 56px); 
	border-right: 3px solid rgba(255, 255, 255, 1);
	border-bottom: 3px solid rgba(255, 255, 255, 1);
	background-color: rgba(255,187,0,1); 
}

#content{position: relative;float:left; 
    height: 35rem; width: 100%;
    display: flex;
    flex-direction: column; 
}



/* LightBox */	
.canvas	{position:absolute; top:0; left:0;
	width:100%; height:100%;background-color: rgba(76,76,76,0.7);
	display:none;}

.light-box	{ position:absolute; 
	top:50%;left:50%; transform:translate(-50%, -50%);
	width:40%;height:40%;background-color: rgba(255,187,0,1);
	border-radius:10px;}

.light-box-big	{ position:absolute; 
	top:50%;left:50%; transform:translate(-50%, -50%);
	width:50%;height:55.5%;background-color: rgba(255,187,0,1);
	border-radius:10px;}
	
.lightbox{float:left;}
.lightbox.image{
	width:30%;height:100%; border-radius:10px 0px 0px 10px;
	/* background-image: url('/res/images/hoonzzang.jpg'); background-size:contain; */
	background-repeat:no-repeat;}
.lightbox.content{ width:70%;height:100%; border-radius:0px 10px 10px 0px;}

#cheader{ width:100%; height:20%; border-radius:0px 10px 0px 0px;
	font-size:1.3rem; font-weight:900;}
#cbody{ width:100%; height:65%; border-radius:0px 0px 0px 0px; text-align:center;}
#cfooter{ width:100%; height:15%; border-radius:0px 0px 10px 0px;}

.box	{margin-top:10px;text-align:center;
	width:80%; height:25px; background-color:rgba(255,187,0,1);
	border:1px solid #FFFFFF; border-radius:20px;
	font-size:1rem;color:#FFFFFF;transition:0.5s;
}
.box.item{margin:10px auto;width:90%;height:35px;line-height:35px;}
.box.item.title{margin:20px auto;width:90%;height:50px; 
		font-size:1.3rem;line-height:50px; background-color:rgba(0,66,237,0.8);
		border-radius:5px;}
.box.item.textareabox	{ width:90%; height:45%;}
.box.multi 	{margin:10px auto; width:90%; height:50px; border-radius:5px;}
span.small	{font-size:0.8rem;}
span.general{font-size:1.1rem;}

.box.multi:hover	{background-color:rgba(255,0,127,0.5); 
	transform:translateX(15%); box-shadow: 0 10px 10px rgba(0,0,0,0.3);}
.box.multi.invite:hover	{background-color:rgba(255,0,127,0.5); 
	transform:translateX(-15%); box-shadow: 0 10px 10px rgba(0,0,0,0.3);}
.box:focus	{background-color:rgba(255,0,127,0.5); 
	transform:translateX(15%); box-shadow: 0 10px 10px rgba(0,0,0,0.3);}

.btn	{position:relative; float:left; margin-top:1%;margin-left:5% ;text-align:center; 
	width:90%; height:30px; overflow:hidden; 
	background-color:rgba(204,166,61,1);	border:1px solid #FFFFFF; border-radius:5px;
	color:#FFFFFF;font-weight:900; font-size:1rem; 
	cursor:pointer; transition:0.5s;
}

.btn.small{width:40%;}
.btn:hover {background-color:rgba(255,0,127,0.5); 
	transform:translateX(13%); box-shadow: 0 10px 10px rgba(0,0,0,0.3);}

#invitationInfo{height:25%;margin-left:5px;}
.invitation {float:left; 
	width:48.5%; height:100%; margin:10px 5px 10px 10px;
	border:1px solid rgba(255,187,0,1); }
.notice		{width:100%; height:30px; background-color:rgba(255,187,0,1);
	color:rgba(255,255,255,1); text-align:center;line-height:30px;}
	
#senderItems, #receiverItems, .invitationList	{width:100%;margin:10px 0px 0px 0px;}
.invitationList 	{ height: 60%; overflow-x:hidden;overflow-y:auto;}
.member	{width:100%; height: 35px;  margin:5px 0px; line-height:35px;}
.member:hover	{ background-color:rgba(213, 213, 213, 1);cursor:pointer;}	
.items	{height:30px; height:100%; float:left;
	text-align:center;color:rgba(255,255,255,1);}
.items.name	{width:15%;}
.items.invite {width:30%;}
.items.expire {width:30%;}
.items.accept {width:20%;margin: 0 auto;}

.menu	{width:80%;height:6.5%;line-height:2.5rem;margin: 10px auto;
		border: 1px solid rgba(255,255,255,1);
		text-align:center; font-weight:900; color:rgba(255,255,255,1);}
.menu:hover	{color:rgba(255,187,0,1); background-color:rgba(255,255,255,1);
		cursor:pointer;}
.1{width:90%;
		}
.proLeader,.proMember,.proPeriod{
	text-align : center;
	background-color : white;
	border-radius : 25px;
	width:23rem;
}
.mjName{
	background-color : white; 
	border-radius : 25px; 
	width:23rem; 
	text-align : center;
}
.selectBox{
    text-align: center;
    width: 100%;
    height: 25px;
    background-color: white;
    border: 1px solid #FFFFFF;
    border-radius: 20px;
    font-size: 1rem;
    color: black;
    transition: 0.5s;}
.white{
    background-color: white;
    width: 10rem; 
     border-radius : 25px;
}
.blue{
    background-color: powderblue;
        width: 10rem; 
     border-radius : 25px;
}
.gray{
    width: 10rem; 
     border-radius : 25px;
    background-color: gray;
}
</style>
</head>
<body onLoad="" >
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
           <div id="0" class="1" style="height: 95%; width: 100%;">
                <!-- 프로젝트 상단창 -->
                <div id = "1" class="1" style="top: 0; height: 30%; width: 95%; margin: 0 auto;">  
                    <div id = "2" class="1" style="top: 0; height: 19%; width: 100%; margin: 0 auto;">
                        <div id = "3" class="1" style="background-color : white; border-radius : 25px; width:100%; margin:0 auto; text-align : center;"> ${proName}</div>
                    </div>
                    <div style="bottom: 0; height: 80%; width: 100%; margin: 0 auto;">
                        <div id = "4" class="1" style="display: flex; justify-content: center; background-color: lightblue; float: left; height: 100%; width: 31%; margin: 0 auto;">
                            <div id = "5" class="1" style="display: flex; flex-direction: column; justify-content: space-around;">
                                ${proInfo}
                            </div>
                        </div>
                        <div id = "6" class="1" style="float: right; height: 80%; width: 68%; margin: 0 auto;">
                            <div id = "7" class="1" style="display: flex; justify-content: space-evenly; align-items: center; background-color: lightgray; height: 75%;"> 
                                <div style="text-align : center;background-color : white;	border-radius : 25px;	width:12rem; height :3rem; line-height: 3rem; ">${moduleNum} MOU</div>
                                <div style="text-align : center;background-color : white;	border-radius : 25px;	width:12rem; height :3rem; line-height: 3rem;">${jobsNum} JOS</div>
                                <div style="text-align : center;background-color : white;	border-radius : 25px;	width:12rem; height :3rem; line-height: 3rem;">${mjNum} MJ</div>
                                <div style="text-align : center;background-color : white;	border-radius : 25px;	width:12rem; height :3rem; line-height: 3rem;">${methodNum} MET</div>
                            </div>
                            <div id = "8" class="1" style="background-color: lightyellow; height: 50%;"> 프로젝트 진행률</div>
                        </div>
                    </div>
                </div>
                <!-- 프로젝트 하단창 -->
                <div id = "9" class="1" style="bottom: 0; height: 65%; width: 95%; margin: 0 auto;">
                    <div id = "10" class="1" style="background-color: lightblue; float: left; height: 100%; width: 31%; margin: 0 auto;"> 
                        <div id = "11" class="1" style="display: flex; flex-direction: column; justify-content: space-evenly; align-items: center; height: 100%; height: 100%; overflow: scroll;">
                            ${mjName}
                        </div>
                    </div>
                    <div id = "12" class="1" style="float: right; height: 100%; width: 68%; margin: 0 auto;">
                        <div id = "13" class="1" style="background-color: lightskyblue; float: left; height: 100%; width: 31%; margin: 0 auto;"> 
                            <div id = "14" class="1" style="display: flex; flex-direction: column; justify-content: space-evenly; align-items: center; height: 100%;">
                                <div id="controller" onclick="getMetList('1')" style="text-align : center;background-color : white;	border-radius : 25px;	width:12rem; height :3rem;  ">컨트롤러<br><div name="code">${ctNum}</div></div>
                                <div id="view" onclick="getMetList('2')" style="text-align : center;background-color : white;	border-radius : 25px;	width:12rem; height :3rem; ">뷰<br><div name="code">${viNum}</div></div>
                                <div id="service" onclick="getMetList('3')" style="text-align : center;background-color : white;	border-radius : 25px;	width:12rem; height :3rem; ">서비스<br><div name="code">${moNum}</div></div>
                                <div id="dao" onclick="getMetList('4')" style="text-align : center;background-color : white;	border-radius : 25px;	width:12rem; height :3rem; ">디에이오<br><div name="code">${daNum}</div></div>
                            </div>
                        </div>
                        <div style="float: right; height: 100%; width: 68%;">
                            <div id = "15" class="1" style="background-color: lightgray; height: 32%; width: 100%; margin: 0 auto;"> 
                                <div id = "16" class="1"style="display: flex; flex-wrap: wrap; flex-direction: row; justify-content: space-evenly; align-content: space-around; align-items: center; height: 100%; text-align: center;">
                                    <div style="width: 10rem; background-color : white; border-radius : 25px;"></div>
      									
                                </div>
                            </div>
                            <div id = "17" class="1" style="background-color: lightyellow; height: 68%; width: 100%; margin: 0 auto;">
                            	<!-- 18번~23번까지 display : none;처리 -->
                                <div id = "18"  style="float: left; width: 65%; height: 100%; display: none; flex-direction: column; align-items: center; justify-content: space-evenly;">
                                    <input type="file" value="파일찾기" style="width: 80%; background-color: purple; color: white; border: none;">
                                    <input type="file" value="파일찾기" style="width: 80%; background-color: purple; color: white; border: none;">
                                    <input type="file" value="파일찾기" style="width: 80%; background-color: purple; color: white; border: none;">
                                </div>
                                <div id = "19"style="display: flex; flex-direction: column; justify-content: space-around; float: right; width: 25%; height: 100%;">
                                    <div id = "20"style="display: none; flex-direction: column; justify-content: space-around; height: 65%;">
                                        <input type="button" value="파일추가" style="background-color: purple; color: white; border: none;">
                                        <input type="button" value="항목삭제" style="background-color: purple; color: white; border: none;">
                                        <input type="button" value="파일등록" style="background-color: purple; color: white; border: none;">
                                    </div>
                                    <div id = "21" style="display: none; flex-direction: column; justify-content: space-around; height: 11%;">
                                        <input type="button" value="작업완료" style="background-color: black; color: white; border: none;">
                                     </div>
                                     <div id = "22" style="display: none; flex-direction: column; justify-content: space-around; height: 11%;">
                                        <input type="button" value="작업시작" style="background-color: black; color: white; border: none;">
                                    </div>
                                    <div id = "23" style="display: none; flex-direction: column; justify-content: space-around; height: 11%;">
                                        <input type="button" value="서버전송" style="background-color: black; color: white; border: none;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div> 
		</div>
	
	
	<form name="clientData"></form>
</body>
</html>