<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>:: PMS Landing ::</title>
<script src="/res/js/common.js"></script>
<script>
function init(){
	getAjaxJson("https://api.ipify.org", "format=json", "callServer");
} 

function callServer(ajaxData){
	jsonData = JSON.parse(ajaxData);
	const publicIp = ("aslPublicIp=" + jsonData.ip);
	location.href = "http://192.168.0.54/First?" + publicIp;
} 
</script>
</head>
<body onLoad="init()">

</body>
</html>