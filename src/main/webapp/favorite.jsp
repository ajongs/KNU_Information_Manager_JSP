<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="org.jsoup.Jsoup" %>
<%@ page import="org.jsoup.nodes.Document" %>
<%@ page import="org.jsoup.nodes.Element" %>
<%@ page import="org.jsoup.select.Elements" %>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
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
	#selected{
		border:none;
		color:#263485;
		background:#fff;
	}
	#sidebar ul li a:hover{
		color:#263485;
		background:#fff;
	}
	.notice-content{
		display:block;
		width:100%;
		height:100%;
		border:1px solid #000000;
	}
</style>
<script>
	var request=null;
	var tr = null;
	function deleteFavorite(btn){
		tr = btn.parentNode.parentNode;
		//var url = tr.cells[1].childNodes[0].getAttribute('href');
		var title = tr.cells[1].childNodes[0].innerHTML;
		var formUrl = "deleteFavorite.jsp?";
		var query = "title="+title;
		
		createRequest();
		request.open("POST", formUrl, true);
		request.onreadystatechange=updatePage;
		request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		request.send(query);
	}
	function createRequest(){
		try{
			request = new XMLHttpRequest();
			request.responseType = 'document';	
		} catch(failed){
			request = null;
		}
		if(request==null){
			alert("Error creating request object!");
		}
	}
	function updatePage(){
		if(request.readyState==4){
			var response = request.response;
			var result = response.getElementById("result").innerHTML;
			alert(result);
			tr.parentNode.removeChild(tr);
			tr = null;
		}
	}
</script>
</head>
<body>
	      <%
      		String nickname = (String)session.getAttribute("userId");
			  	String userNickname = "";
			  	if (session.getAttribute("userId") != null) {
			  		nickname = (String) session.getAttribute("userId");
			  		userNickname = new UserDAO().getUserNickname(nickname);
			  		boolean emailChecked = new UserDAO().getUserEmailChecked(nickname);
			  		if (emailChecked == false) {
			  			PrintWriter script = response.getWriter();
			  			script.println("<script>");
			  			script.println("location.href = 'emailSendConfirm.jsp'");
			  			script.println("</script>");
			  			script.close();
			  			return;
			  		}
			  	}
			  	else {
			  		PrintWriter script = response.getWriter();
			  		script.println("<script>");
			  		script.println("alert('로그인 상태가 아닙니다.')");
			  		script.println("location.href = 'index.jsp'"); 
			  		script.println("</script>");
			  		script.close();
			  		return;
			  	}
				%>

	<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/js/bootstrap.bundle.min.js"></script>



<header class="navbar navbar-expand navbar-dark bg-dark bd-navbar">
  <a class="navbar-brand" href="notice.jsp" style="font-size:25px;">EveryNotice</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarNav">
    <ul class="navbar-nav ml-auto">
				<li><a class="nav-link"> <%=userNickname%>님, 안녕하세요!</a></li>
				<li><a class="nav-link" href="userLogout.jsp">로그아웃</a></li>
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
					<li id="selected"><a href="favorite.jsp"><span>즐겨찾기</span></a></li>
					<li><a href="freeBoard.jsp"><span>자유게시판</span></a></li>
					<li><a href="keyword.jsp"><span>키워드 설정</span></a></li>
				</ul>
			</nav>
      <div class='bd-sidebar-footer'>
      	<span>Copyrightⓒ2021 by wonjong, hyojeong, songhee</span>
      </div>
    </div>
    <main class="col-9 py-md-3 pl-md-5 bd-content" role="main">
	
	<span style="font-size:40px; margin-right:10px;">내가 추가한 공지사항</span><br>
	<br><br>
	<div class="table">
		<table style="width:100%;">
			<thead>
				<tr>
					<th style="width:10%;">no.</th>
					<th style="width:75%;">제목</th>
					<th style="width:15%; text-align:right;">즐겨찾기 삭제</th>
				</tr>
			</thead>
			<tbody>
			<%
				request.setCharacterEncoding("UTF-8");
				String userId = (String)session.getAttribute("userId");
				int count =0;
				try{
					InitialContext ctx = new InitialContext();
					DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
					Connection con = ds.getConnection();
					
					PreparedStatement pstmt = null;
					String sql = "select title, url from favorite where userId = ?;";
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, userId);
					
					ResultSet result = pstmt.executeQuery();
					
					while (result.next()) {
						count++;
						out.println("<tr><td>"+count+"</td><td><a href="+result.getString(2)+">"+result.getString(1)+
		                		"</td><td style='text-align:right;'><button class='btn btn-primary' onclick='deleteFavorite(this)'"+
	                		" style='margin:0;'>삭제</td></tr>");
					}
				
					result.close();
					pstmt.close();
					con.close();
				}catch(Exception e){
					out.println("db오류");
					e.printStackTrace();
				}
				count=0;
			%>	
	
	
			</tbody>
		</table>
	</div>
    </main>
  </div>
</div>
</body>
</html>