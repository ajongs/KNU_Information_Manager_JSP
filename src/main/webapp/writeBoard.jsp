<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %><%@ page import="user.UserDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>EveryNotice</title>
<link rel='stylesheet' href='//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/css/bootstrap.min.css'>
<style>
	.bd-navbar {
	  position: sticky;
	  top: 0;
	  z-index: 1071;
	  min-height: 4rem;
	  box-shadow: 0 0.5rem 1rem rgba(0,0,0,.05), inset 0 -1px 0 rgba(0,0,0,.1);
	}
	.bd-sidebar {
	  position: sticky;
	  top: 4rem;
	  z-index: 1000;
	  height: calc(100vh - 4rem);
	  background: #eee;
	  max-width: 220px;
	  display: flex;
	  padding: 0;
	  flex-direction: column;
	}
	.bd-sidebar-body {
	  height: 100%;
	  overflow-y: auto;
	  display: block;
	}
	.bd-sidebar-body .nav {
	  display: block;
	}
	.bd-sidebar-body .nav>li>a {
	  display: block;
	  padding: .25rem 1.5rem;
	  font-size: 90%;
	}
	.bd-sidebar-footer {
	  padding: 1rem;
	  background: #343a40;
	  color:white;
	  text-align:center;
	}
	a, a:hover, a:focus{
		color : inherit;
		text-decoration:none;
		transition: all 0.3s;
		border-radius : 0 30px 30px 0;
	}
	#sidebar{
		position:sticky;
		width: 220px;
		height:100%;
		background:#263485;
		color:#fff;
	 	overflow-y: auto;
	 	display: block;
		
	}
	#sidebar .sidebar-header{
		padding:20px;
		background:#263485;
	}
	#sidebar ul p{
		color:#fff;
		padding:10px;
	}
	#sidebar ul li a{
		 padding: 10px;
		 font-size: 1.2em;
		 display:block;
	}
	#sidebar ul li a:hover{
		color:#263485;
		background:#fff;
	}
	#selected{
		border:none;
		color:#263485;
		background:#fff;
	}
</style>
</head>
<body>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/js/bootstrap.bundle.min.js"></script>
<%
	String userId = "";
	String userNickname = "";
	if (session.getAttribute("userId") != null) {
		userId = (String) session.getAttribute("userId");
		userNickname = new UserDAO().getUserNickname(userId);
		boolean emailChecked = new UserDAO().getUserEmailChecked(userId);
		if (emailChecked == false) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'emailSendConfirm.jsp'");
			script.println("</script>");
			script.close();
			return;
		}
	}
	%>
	<header class="navbar navbar-expand navbar-dark bg-dark bd-navbar">
		<a class="navbar-brand" href="notice.jsp" style="font-size:25px;">EveryNotice</a>
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
	<div class="container-fluid">
		<div class="row flex-nowrap">
			<div class="col-3 bd-sidebar">
				<nav id="sidebar">
					<div class="sidebar-header">
						<img src="header.png" width="180px">
					</div>
					<ul class="list-unstyled componenets">

						<li><a href="notice.jsp"><span>공지사항</span></a></li>
						<li><a href="favorite.jsp"><span>즐겨찾기</span></a></li>
						<li><a href="freeBoard.jsp"><span>자유게시판</span></a></li>
						<li><a href="keyword.jsp"><span>키워드 설정</span></a></li>
					</ul>
				</nav>
				<div class='bd-sidebar-footer'>
			      <span>Copyrightⓒ2021 by wonjong, hyojeong, songhee</span>
			    </div>
			</div>
			<main class="col-9 py-md-3 pl-md-5 bd-content" role="main">
				<form method="post" action="writeAction.jsp">
					<table class="table table-striped" style="text-align:center; border:1px solid #dddddd">
						<thead>
							<tr>
								<th colspan="2" style="background-color:#eeeeee; text-align:center;">게시판 글쓰기 양식</th>
				            </tr>
				        </thead>
				         <tbody>
				            <tr>
				            <td><input type="text" class="form-control" placeholder="글 제목"  name="bbsTitle" maxlength="50" ></td>
				            </tr>
				            <tr>
				            <td><textarea class="form-control" placeholder="글 내용"  name="bbsContent" maxlength="2048" style="height:350px" ></textarea></td>
				            </tr>
				        </tbody>
			        </table>
			        <input type="submit"  class="btn btn-primary pull-right" value="글쓰기">
			    </form>				
			</main>
		</div>
	</div>
	 <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	 <script src="js/bootstrap.js"></script>
</body>
</html>
