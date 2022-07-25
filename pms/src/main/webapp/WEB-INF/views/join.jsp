<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>::PMS JOIN::</title>
<script src="/res/js/common.js"></script>
<script>
function init(){
	getAjaxJson("https://api.ipify.org", "format=json", "setPublicIp");
	
	lightBoxCtl('PMS MEMBER JOIN', true);
	let cbody = document.getElementById("cbody");
	let box = [];
	box.push(createInput("text", "pmbCode", "회원코드", "box"));
	box[0].setAttribute("value", "${pmbCode}");
	box[0].setAttribute("readOnly", true);
	
	box.push(createInput("password", "pmbPassword", "패스워드", "box"));
	box.push(createInput("text", "pmbName", "회원성명", "box"));
	box.push(createInput("text", "pmbEmail", "회원이메일", "box"));
	
	box.push(createInput("button", "", "", "btn"));
	box[4].setAttribute("value","회 원 가 입");
	box[4].addEventListener("click", pmsMemberJoin);
	
	for(idx=0;idx<box.length-1; idx++){
		cbody.appendChild(box[idx])	
	}
	
	let origin = cbody.innerHTML;
	cbody.innerHTML = (origin + "${selectData}");
	
	cbody.appendChild(box[box.length-1]);
	
	let lightBox = document.querySelector(".light-box");
	lightBox.className = "light-box-big";
}

function pmsMemberJoin(){
	/* Hidden Type 생성 */
	let publicIp = createInput("hidden", "aslPublicIp", "", "");
	publicIp.setAttribute("value", jsonData.ip);
	/* HTML Object 연결 : canvas, 회원코드, 패스워드, 회원성명, 등급, 반, form */
	let htmlObj = [];
	htmlObj.push(document.getElementsByName("pmbCode")[0]);
	htmlObj.push(document.getElementsByName("pmbPassword")[0]);
	htmlObj.push(document.getElementsByName("pmbName")[0]);
	htmlObj.push(document.getElementsByName("pmbLevel")[0]);
	htmlObj.push(document.getElementsByName("pmbClass")[0]);
	
	/* 유효성 검사 */
	  // 1. 패스워드 유효성 검사 >> 영문자 대소문자, 숫자, 특수문자 >> 3개이상의 타입을 사용하였는지
	  //                    >> 전체 문자 수는 6개 이상
	if(isCharCheck(htmlObj[1].value, true)){
		if(!isCharLengthCheck(htmlObj[1].value, 6)) {
			alert("패스워드는 6자 이상이어야 합니다.");
			htmlObj[1].value = "";
			htmlObj[1].focus();
			return;
		}
	}else{
		alert("영문 대·소문자, 숫자, 특수문자 중 3종류 이상의 문자를 사용하셔야 합니다.");
		htmlObj[1].value = "";
		htmlObj[1].focus();
		return;
	}	
	  
	  // 2. 문자 수가 2~5범위, 한글체크
	if(isCharCheck(htmlObj[2].value, false)){
		if(!isCharLengthCheck(htmlObj[2].value, 2, 5)){
			alert("성명은 2글자 ~ 5글자 범위어야 합니다.");
			htmlObj[2].focus();
			return;
		}
	}else{
		alert("성명은 한글로만 입력하셔야 합니다.");
		htmlObj[2].focus();
		return;
	}
	  
	// 3. LevelCode와 ClassCode가 선택되었는지에 대한 검사
	if(htmlObj[3].selectedIndex <= 0){
		alert("회원레벨을 선택하셔야 합니다.");
		htmlObj[3].focus();
		return;
	}
	if(htmlObj[4].selectedIndex <= 0){
		alert("회원님의 반을 선택하셔야 합니다.");
		htmlObj[4].focus();
		return;
	} 
  
	const canvas = document.getElementById("canvas");
	canvas.appendChild(publicIp);
	let form = document.getElementsByName("clientData")[0];
	form.action = "Join";
	form.method = "post";
	
	form.appendChild(canvas);
	
	form.submit();	  
}
</script>
<style>
	@import url("/res/css/common.css");
	
</style>
</head>
<body onLoad="init()">


<!-- Light Box Start -->
	<div id="canvas" class="canvas">
		<div class="light-box">
			<div class="lightbox image"></div>
			<div class="lightbox content">
				<div id="cheader"></div>
				<div id="cbody"></div>
				<div id="cfoot"></div>
			</div>
		</div>	
	</div>
	<!-- Light Box End -->
	
	<form name="clientData"></form>
</body>
</html>