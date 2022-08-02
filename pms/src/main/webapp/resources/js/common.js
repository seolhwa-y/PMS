let jsonData;

function lightBoxCtl(title, disp){
	let canvas = document.getElementById("canvas");
	let header = document.getElementById("cheader");
	header.innerText = title;
	canvas.style.display = disp? "block":"none";
	
}

function createDiv(id, className, value, text){
	let div = document.createElement("div");
	if(id != "") div.setAttribute("id", id);
	if(className != "") div.setAttribute("class", className);
	if(value != "") div.setAttribute("value", value);
	if(text != "") div.innerHTML = text;
	
	return div;
}

function createInput(typeName, objName, placeholder, className){
	let input = document.createElement("input");
	input.setAttribute("type", typeName);
	input.setAttribute("name", objName);
	input.setAttribute("placeholder", placeholder);
	input.setAttribute("class", className);
	
	return input;
}

function createHidden(objName, value){
	let input = document.createElement("input");
	input.setAttribute("type", "hidden");
	input.setAttribute("name", objName);
	input.setAttribute("value", value);
	
	return input;
}

function createTextarea(objName, rows, cols, className){
	let textArea = document.createElement("textarea");
	textArea.setAttribute("name", objName);
	textArea.setAttribute("rows", rows);
	textArea.setAttribute("cols", cols);
	textArea.setAttribute("class", className);
	
	return textArea;
}

/* 패스워드 유효성 검사 
   - 문자의 종류가 3개 이상
*/
function isCharCheck(text, type){
	let result;
	
	const largeChar = /[A-Z]/;
	const smallChar = /[a-z]/;
	const num = /[0-9]/;
	const specialChar = /[!@#$%^&*]/;
	
	let typeCount = 0;
	
	if(largeChar.test(text)) typeCount++;
	if(smallChar.test(text)) typeCount++;
	if(num.test(text)) typeCount++;
	if(specialChar.test(text)) typeCount++;
	
	if(type){
		result = typeCount >= 3? true:false;
	}else{
		result = typeCount == 0? true:false;
	}
	
	return result;
}

function isCharLengthCheck(text, minimum, maximum){
	let result = false;
	
	if(maximum != null){
		if(text.length >= minimum && text.length <= maximum) result = true;
	} else{
		if(text.length >= minimum) result = true;
	}
	
	return result;
}



/* AJAX :: GET */
function getAjaxJson(jobCode, clientData, fn){
	const ajax =  new XMLHttpRequest();
	const action = (clientData != "")? (jobCode + "?" + clientData):jobCode;
	
	ajax.onreadystatechange = function(){
		if(ajax.readyState == 4 && ajax.status == 200){
			window[fn](ajax.responseText);
		}
	};
	
	ajax.open("get", action);
	ajax.send();
}

/* AJAX :: POST */
function postAjaxJson(jobCode, clientData, fn){
	const ajax =  new XMLHttpRequest();
	
	ajax.onreadystatechange = function(){
		if(ajax.readyState == 4 && ajax.status == 200){
			window[fn](ajax.responseText);
		}
	};
	
	ajax.open("post", jobCode);
	ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	ajax.send(clientData);
}

/* Public IP Saving */
function setPublicIp(ajaxData){
	jsonData = JSON.parse(ajaxData);
}

function newProject(){
	alert("New");
	let form = document.getElementsByName("clientData")[0];
	form.action = "NewProject";
	form.method = "post";
	form.submit();
}

function makeLightBox(title, fn1, fn2){
	let cheader = document.createElement("div");
	cheader.setAttribute("id", "cheader");
	cheader.innerText = title;
	
	let cbody = document.createElement("div");
	cbody.setAttribute("id", "cbody");
	
	let cfoot = document.createElement("div");
	cfoot.setAttribute("id", "cfoot");
	
	let reg = document.createElement("button");
	reg.setAttribute("class", "btn small");
	reg.innerText = "O";
	reg.addEventListener("click", window[fn1]);
	cfoot.appendChild(reg);
	
	let closing = document.createElement("button");
	closing.setAttribute("class", "btn small");
	closing.innerText = "X";
	closing.addEventListener("click", window[fn2]);
	cfoot.appendChild(closing);
	
	let content = document.createElement("div");
	content.setAttribute("class", "lightbox content");
	content.appendChild(cheader);
	content.appendChild(cbody);
	content.appendChild(cfoot);
	
	let image = document.createElement("div");
	image.setAttribute("id", "image");
	image.setAttribute("class", "lightbox image");
	
	let box = document.createElement("div");
	box.setAttribute("class", "light-box");
	box.appendChild(image);
	box.appendChild(content);
	
	let lightBox = document.createElement("div");
	lightBox.setAttribute("id", "canvas");
	lightBox.setAttribute("class", "canvas");
	
	lightBox.appendChild(box);
	
	return lightBox;
}

function cancelProject(){
	let canvas = document.getElementById("canvas");
	canvas.remove();
}

function moveDashBoard(){
	const form = document.getElementsByName("clientData")[0];
	form.action = "DashBoard";
	form.method = "post";
	
	form.submit();
	
}
function accessOut(){
	let form = document.getElementsByName("clientData")[0];
	
	form.action = "Logout";
	form.method = "post";
	form.submit();
}