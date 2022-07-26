<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>:: PMS Main ::</title>
<script src="/resources/js/common.js"></script>
<script>
function accessOut(){
	let form = document.getElementsByName("clientData")[0];
	form.setAttribute("action", "AccessOut");
	form.setAttribute("method", "post");
	
	form.submit();
}
</script>
</head>
<body>
	마지막 로그인 시간 : ${accessInfo.aslDate}
	회원코드 : ${accessInfo.pmbCode}
	회원성명 : ${accessInfo.pmbName}
	회원등급 : ${accessInfo.pmbLevelName}
	클래스명 : ${accessInfo.pmbClassName}
	<input type="button" class="btn" value="로그아웃" onClick="accessOut()"/>
	
	
	<form name="clientData"></form>
</body>
</html>