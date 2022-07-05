<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import='javax.mail.Transport'%>
<%@ page import='javax.mail.Message'%>
<%@ page import='javax.mail.Address'%>
<%@ page import='javax.mail.internet.InternetAddress'%>
<%@ page import='javax.mail.internet.MimeMessage'%>
<%@ page import='javax.mail.Session'%>
<%@ page import='javax.mail.Authenticator'%>
<%@ page import='java.util.Properties'%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="util.Gmail"%>
<%@ page import="java.io.PrintWriter"%>
<%
UserDAO userDAO = new UserDAO();
String userId = "";
String userNickname = "";
if (session.getAttribute("userId") != null) {
	userId = (String) session.getAttribute("userId");
	userNickname = new UserDAO().getUserNickname(userId);
}
if (userId == null) {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('로그인을 해주세요.');");
	script.println("location.href = 'userLogin.jsp';");
	script.println("</script>");
	script.close();
	return;
}

boolean emailChecked = userDAO.getUserEmailChecked(userId);
if (emailChecked == true) { //인증이 된 회원
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('이미 인증된 회원입니다.');");
	script.println("location.href = 'index.jsp';");
	script.println("</script>");
	script.close();
	return;
}

//사용자에게 보낼 메시지를 기입합니다.

String host = "http://localhost:8080/final_project/";
String from = "wp211204@gmail.com";
String to = userDAO.getUserEmail(userId);
String subject = "[Every Notice] 이메일 인증 메일";
String content = "다음 링크에 접속하여 이메일 확인을 진행하세요." + "<a href='" + host + "emailCheckAction.jsp?code="
		+ new SHA256().getSHA256(to) + "'>이메일 인증하기</a>";

// SMTP에 접속하기 위한 정보

Properties p = new Properties();
p.put("mail.smtp.host", "smtp.gmail.com");
p.put("mail.smtp.port", "465");
p.put("mail.smtp.starttls.enable", "true");
p.put("mail.smtp.auth", "true");
//p.put("mail.smtp.starttls.required", "true");
p.put("mail.smtp.ssl.protocols", "TLSv1.2");
p.put("mail.smtp.debug", "true");
p.put("mail.smtp.socketFactory.port", "465");
p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
p.put("mail.smtp.socketFactory.fallback", "false");

try {
	Authenticator auth = new Gmail();
	Session ses = Session.getInstance(p, auth);
	ses.setDebug(true);
	MimeMessage msg = new MimeMessage(ses);
	msg.setSubject(subject);
	Address fromAddr = new InternetAddress(from);
	msg.setFrom(fromAddr);
	Address toAddr = new InternetAddress(to);
	msg.addRecipient(Message.RecipientType.TO, toAddr);
	msg.setContent(content, "text/html;charset=UTF8");
	Transport.send(msg);

} catch (Exception e) {
	e.printStackTrace();
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('오류가 발생했습니다..');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;
}
%>

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
			<header class="navbar navbar-expand navbar-dark bg-dark bd-navbar">
	  <a class="navbar-brand" href="main.jsp" style="font-size:30px;">EveryNotice</a>
	  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
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
		<div class="alert alert-success mt-4" role="alert">이메일 주소 인증 메일이
			전송되었습니다.<br>회원가입시 입력했던 이메일에 들어가셔서 인증해주세요!</div>
	</section>
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script scr="./js/jquery.min.js"></script>
	<!-- 파퍼 자바스크립트 추가하기 -->
	<script scr="./js/popper.min.js"></script>
	<!-- 부트스르탭 자바스크립트 추가하기 -->
	<script scr="./js/bootstrap.min.js"></script>


</body>
</html>