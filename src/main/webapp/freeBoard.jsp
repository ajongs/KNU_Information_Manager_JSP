<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>

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
	else{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 상태가 아닙니다.')");
		script.println("location.href = 'index.jsp'"); 
		script.println("</script>");
		script.close();
		return;
	}
	int pageNumber = 1; // 기본페이지 기본적으로 페이지 1부터 시작하므로
    if (request.getParameter("pageNumber") != null)
    {
        pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
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
						<img src = "header.png" width = "180px">
					</div>
					<ul class="list-unstyled componenets">

						<li><a href="notice.jsp"><span>공지사항</span></a></li>
						<li><a href="favorite.jsp"><span>즐겨찾기</span></a></li>
						<li><a href="freeBoard.jsp"><span>자유게시판</span></a></li>
						<li><a href="keyword.jsp"><span>키워드 설정</span></a></li>
					</ul>
				</nav>
				<div class='bd-sidebar-footer'>
			      <span>Copyrightⓒ2021 by wonjong, hyojeong, songhui</span>
			    </div>
			</div>
			
			<main class="col-9 py-md-3 pl-md-5 bd-content" role="main">
				<div class="row">
		            <table class="table table-striped" style="text-align:center; border:1px solid #dddddd">
		                <thead>
		                    <tr>
		                        <th style="background-color:#eeeeee; text-align:center;">번호</th>
		                        <th style="background-color:#eeeeee; text-align:center;">제목</th>
		                        <th style="background-color:#eeeeee; text-align:center;">작성자</th>
		                        <th style="background-color:#eeeeee; text-align:center;">작성일</th>
		                    </tr>
		                </thead>
		                <tbody>
			                <%
			                    BbsDAO bbsDAO = new BbsDAO();
			                    ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
			                    for(int i = 0; i < list.size(); i++)
			                    {
			                %>
			                
			                    <tr>
			                        <td><%=list.get(i).getBbsID() %></td> <!-- 특수문자를 제대로 출력하기위해 & 악성스크립트를 방지하기위해 -->
			                        <td><a href="viewPost.jsp?bbsID=<%=list.get(i).getBbsID()%>"><%=list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></a></td>
			                        <% String nickname = new UserDAO().getUserNickname(list.get(i).getuserId());%>
			                        <td><%=nickname%></td>
			                        <td><%=list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11, 13) + "시" 
			                        + list.get(i).getBbsDate().substring(14,16) + "분" %></td>
			                    </tr>
			                <%
			                    }
			                %>
		                </tbody>
		            
		            </table>
		            <%
		                if(pageNumber != 1) {
		            %>
		                <a href="freeBoard.jsp?pageNumber=<%=pageNumber - 1 %>" class="btn btn-success btn-arrow-left">이전</a>
		            <%
		                } if (bbsDAO.nextPage(pageNumber + 1)) {
		            %>
		                <a href="freeBoard.jsp?pageNumber=<%=pageNumber + 1 %>" class="btn btn-success btn-arrow-left">다음</a>
		            
		            <%
		                }
		            %>
		            <a href="writeBoard.jsp" class="btn btn-primary pull-right">글쓰기</a>
		        </div>
			</main>
        
    </div>
		</div>
	</div>
</body>
</html>