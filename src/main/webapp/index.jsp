<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>EveryNotice</title>
<link rel="stylesheet" href="./css/custom.css">
<style>
body{
	font-family:"Gill Sans", 'Gill Sans MT', Calibri, "Trebuchet MS", sans-serif;
	background:#fafafa;
	height:100%;
}

.box {
	backgroud-color: blue;
	width: 1000px;
	height: 500px;
	position: absolute;
	left: 50%;
	top: 50%;
	transform: translate(-50%, -50%);
	text-align: center;
}

.button1 {
	margin: 15px;
	width: 200px;
	height: 60px;
	font-size: 30px;
	text-transform: uppercase;
	letter-spacing: 2.5px;
	font-weight: 500;
	color: #000;
	background-color: #E6E6FA;
	border: none;
	border-radius: 10px;
	box-shadow: 0px 8px 15px rgba(0, 0, 0, 0.1);
	transition: all 0.3s ease 0s;
	cursor: pointer;
	outline: none;
	width: 200px;
}

.button1:hover {
	background-color: #0174DF;
	box-shadow: 0px 15px 20px rgba(0, 64, 128, 0.4);
	color: #fff;
	transform: translateY(-7px);
}
</style>
</head>
<body>
	<%
	if (session.getAttribute("userId") != null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'notice.jsp'");
		script.println("</script>");
		script.close();
		}
	%>
	<div class="box">
		<h1>Every Notice</h1>

			<button class="button1"><a href="userJoin.jsp">회원가입</a></button>
			<br>

			<button class="button1"><a href="userLogin.jsp">로그인</a></button>
			<br> <br>Copyrightⓒ2021 by wonjong, hyojeong, songhee
	</div>
</body>
</html>