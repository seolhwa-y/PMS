<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>:: PMS :: Project Management System</title>
<script src="/res/js/common.js"></script>
<script>
function init(){
	getAjaxJson("https://api.ipify.org", "format=json", "setPublicIp");
	
	lightBoxCtl('PMS Access', true);
	let cbody = document.getElementById("cbody");
	let box = [];
	box.push(createInput("text", "pmbCode", "회원코드", "box"));
	box.push(createInput("password", "pmbPassword", "패스워드", "box"));
	box.push(createInput("button", "", "패스워드", "btn"));
	box[2].setAttribute("value","로 그 인");
	box[2].addEventListener("click", access);
	
	for(idx=0;idx<box.length; idx++){
		cbody.appendChild(box[idx])	
	}
	
	const message = "${message}";
	if(message != "") alert(message); 
}

function access(){
	let publicIp = createInput("hidden", "aslPublicIp", "", "");
	publicIp.setAttribute("value", jsonData.ip);
	
	const pmsCode = document.getElementsByName("pmbCode")[0];
	const pmsPassword = document.getElementsByName("pmbPassword")[0];
	
	/* data의 유무 확인 */
	if(pmsCode.value.length == 0) {
		pmsCode.focus();
		return;
	}
	if(pmsPassword.value.length == 0){
		pmsPassword.focus();
		return;
	}
	
	/* form 개체에 pmscode와 pmsPassword 개체를 자식으로 편입 */
	let form = document.getElementsByName("clientData")[0];
	form.action = "Auth";
	form.method = "post";
	
	const dataDiv = document.getElementById("canvas");
	dataDiv.appendChild(publicIp);
	form.appendChild(dataDiv);
	
	
	form.submit();
}

function getJoinForm(){
	let form = document.getElementsByName("clientData")[0];
	form.action = "MoveJoinForm";
	form.method = "get";
	
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
				<div id="cfoot"><span onClick="getJoinForm()">회원가입</span></div>
			</div>
		</div>	
	</div>
	<!-- Light Box End -->
	
	<form name="clientData"></form>
</body>
</html>

<!-- 학습목표 
 Request Part : FrontEnd : hoonzzang.jsp
 	- 사용자 데이터의 유효성 판단
 	- 서버 요청
 	  -- 요청방식, 요청 서비스코드, 요청 데이터 
 Request Part : BackEnd - Controller
    - RequestMethod.POST, RequestMethod.GET
    - @RequestMapping (value={"", ""}, method= {"",""}) 
    - @ModelAttribute  >> Client Data >> Bean << Client Data Name = Bean Field Name
    
 Request Part : BackEnd - Service
    - 서비스 요청의 패턴화 >> backContoller
      -- 서비스 코드 인식
	- Database 와의 연동 >> Interface >> mapper >> db

 Response Part: BackEnd >> Service
    - 서버데이터 >> Model.addAttribute
    - Client Page >> View("page") 
     >> ModelAndView
    - return ModelAndView
 
 Response Part: BackEnd >> Controller
    - return ModelAndView
 
 Response Part : FrontEnd : main.jsp
-->