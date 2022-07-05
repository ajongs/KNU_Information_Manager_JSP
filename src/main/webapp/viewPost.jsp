<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%><%@ page import="user.UserDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="reply.Reply" %>
<%@ page import="reply.ReplyDAO" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>EveryNotice</title>
<link rel='stylesheet'
	href='//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/css/bootstrap.min.css'>
<style>
.bd-navbar {
	position: sticky;
	top: 0;
	z-index: 1071;
	min-height: 4rem;
	box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, .05), inset 0 -1px 0
		rgba(0, 0, 0, .1);
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
	color: white;
	text-align: center;
}

a, a:hover, a:focus {
	color: inherit;
	text-decoration: none;
	transition: all 0.3s;
	border-radius: 0 30px 30px 0;
}

#sidebar {
	position: sticky;
	width: 220px;
	height: 100%;
	background: #263485;
	color: #fff;
	overflow-y: auto;
	display: block;
}

#sidebar .sidebar-header {
	padding: 20px;
	background: #263485;
}

#sidebar ul p {
	color: #fff;
	padding: 10px;
}

#sidebar ul li a {
	padding: 10px;
	font-size: 1.2em;
	display: block;
}

#sidebar ul li a:hover {
	color: #263485;
	background: #fff;
}

#selected {
	border: none;
	color: #263485;
	background: #fff;
}
</style>
</head>
<body>
	<script
		src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script
		src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/js/bootstrap.bundle.min.js"></script>
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
	int bbsID = 0;
	int replyID = 0;
	
    if (request.getParameter("bbsID") != null)
    {
        bbsID = Integer.parseInt(request.getParameter("bbsID"));
    }
    int pageNumber=1;
	// pageNumber는 URL에서 가져온다.
	if(request.getParameter("pageNumber")!=null){
		pageNumber=Integer.parseInt(request.getParameter("pageNumber"));
	}
    if (bbsID == 0)
    {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다')");
        script.println("location.href = 'bbs.jsp'");
        script.println("</script>");
    }
    Bbs bbs = new BbsDAO().getBbs(bbsID);
	%>
	<header class="navbar navbar-expand navbar-dark bg-dark bd-navbar">
		<a class="navbar-brand" href="notice.jsp" style="font-size: 25px;">EveryNotice</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarNav" aria-controls="navbarNav"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav ml-auto">
				<li><a class="nav-link"> <%=userNickname%>님, 안녕하세요!</a></li>
				<li class="nav-item"><a class="nav-link" href="userLogout.jsp">로그아웃</a></li>
			</ul>
		</div>
	</header>
	<div class="container-fluid">
		<div class="row flex-nowrap">
			<div class="col-3 bd-sidebar">
				<nav id="sidebar">
					<div class="sidebar-header">
						<h3>
						  	<img src="header.png" width="180px">
						</h3>
					</div>
					<ul class="list-unstyled componenets">

						<li><a href="notice.jsp"><span>공지사항</span></a></li>
						<li><a href="#"><span>즐겨찾기</span></a></li>
						<li id="selected"><a href="freeBoard.jsp"><span>자유게시판</span></a></li>
						<li><a href="keyword.jsp"><span>키워드 설정</span></a></li>
					</ul>
				</nav>
				<div class='bd-sidebar-footer'>
					<span>Copyrightⓒ2021 by wonjong, hyojeong, songhui</span>
				</div>
			</div>
			<main class="col-9 py-md-3 pl-md-5 bd-content" role="main">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="3"
								style="background-color: #eeeeee; text-align: center;">게시판
								글 보기</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="width: 20%;">글 제목</td>
							<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></td>
						</tr>
						<tr>
							<td>작성자</td>
							<% String name = new UserDAO().getUserNickname(bbs.getuserId());%>
							<td colspan="2"><%= name.replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></td>
						</tr>
						<tr>
							<td>작성일자</td>
							<td colspan="2"><%= bbs.getBbsDate().substring(0,11) + bbs.getBbsDate().substring(11, 13) + "시" 
		                                + bbs.getBbsDate().substring(14,16) + "분"  %></td>
						</tr>
						<tr>
							<td>내용</td>
							<td colspan="2" style="min-height: 200px; text-align: left;">
								<!-- 특수문자를 제대로 출력하기위해 & 악성스크립트를 방지하기위해 --> <%= bbs.getBbsContent().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></td>
						</tr>
					</tbody>
				</table>
				<form method="post" action="replyAction.jsp?bbsID=<%= bbsID %>">
				<table class="table"
					style="text-align: center; border: 1px solid #dddddd">
					<%-- 홀,짝 행 구분 --%>
					<thead>
						<tr>
							<th colspan="3"
								style="background-color: #eeeeeee; text-align: center;">댓글</th>
						</tr>
					</thead>
					<tbody>
					
						<%
							ReplyDAO replyDAO=new ReplyDAO();
							ArrayList<Reply> list=replyDAO.getList(bbsID, pageNumber);
							for(int i=list.size()-1;i>=0;i--){
							
						%>

						<tr>
							<td style="text-align: left;"><%= list.get(i).getReplyContent() %></td>
							<% String nickname = new UserDAO().getUserNickname(list.get(i).getuserId());%>
							<td style="text-align: right;"><%= nickname %>
							<a href="deletereplyAction.jsp?replyID=<%=list.get(i).getReplyID()%>" class="btn ">삭제</a>
							</td>
						</tr>
					
						<%
								}
						%>
						<tr>
							<td colspan="3">
							<textarea type="text" class="form-control" placeholder="댓글을 입력하세요." name="replyContent" maxlength="1000"></textarea>	
							<input type="submit" class="btn" value="댓글입력">
							</td>
							
						</tr>
					</tbody>
				</table>
				
			</form>
				<a href="freeBoard.jsp" class="btn btn-primary">목록</a>

				<%
		                if(userId != null && userId.equals(bbs.getuserId()))
		                {
		            %>
				<a href="updatePost.jsp?bbsID=<%=bbsID %>" class="btn btn-primary">수정</a>
				<a onclick="return confirm('삭제하시겠습니까?')"
					href="deleteAction.jsp?bbsID=<%=bbsID %>" class="btn btn-primary">삭제</a>

				<%     
		                }
		            %>
			</main>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
