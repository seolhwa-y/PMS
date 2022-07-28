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
			<div id="projectInfo" class="pro">
				<div class="box item title">메일 보낸 멤버</div>
				<div id="sendlist" class="pro list items"></div>
			</div>
			<div id="pmbMembers" class="pro list">
				<div class="box item title">추가로 초대 가능한 멤버</div>
				<div id="list" class="pro list items"></div>
			</div>
			<div id="proMembers" class="pro list">
				<div class="box item title">추가로 초대 예정 멤버</div>
				<div id="invite" class="pro invite items"></div>
				<div id="send" style="display:none;"><input type="button" class="btn" value="SEND EMAIL" onClick="sendEmail2()"/></div>
			</div>
		</div>
	
	
	<form name="clientData"></form>
</body>
</html>