<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<meta name="viewprot"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Every Notice</title>
<link rel='stylesheet'
	href='//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/css/bootstrap.min.css'>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link rel="stylesheet" href="./css/bootstrap.min.css">
<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
	<%
	String userId = "";
	String userNickname = "";
	if (session.getAttribute("userId") != null) {
		userId = (String) session.getAttribute("userId");
		userNickname = new UserDAO().getUserNickname(userId);
	}
	String userEmail = "";
	if(session.getAttribute("userEmail") != null) {
		userEmail = (String) session.getAttribute(userEmail);
	}
	if(userEmail != "") {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요!');");
		script.println("location.href = 'userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>
	<header class="navbar navbar-expand navbar-dark bg-dark bd-navbar">
		<a class="navbar-brand" href="index.jsp" style="font-size: 30px;">EveryNotice</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarNav" aria-controls="navbarNav"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav ml-auto">
				<li class="nav-item"><a class="nav-link"> <%=userNickname%>님, 안녕하세요!</a></li>
				<li class="nav-item"><a class="nav-link" href="userLogout.jsp">로그아웃</a></li>
			</ul>
		</div>
	</header>
	<section class="container mt-3" style="max-width: 560px;">
		<div class="alert alert-warning mt-4" role="alert">이메일 주소 인증을
			하셔야 이용 가능합니다.  인증 메일을 받지 못하셨나요?</div>
		<a href="emailSendAction.jsp" class="btn btn-primary">인증 메일 다시 받기</a>
	</section>
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script scr="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script scr="./js/popper.min.js"></script>
	<!-- 부트스르탭 자바스크립트 추가하기 -->
	<script scr="./js/bootstrap.min.js"></script>


</body>
</html>