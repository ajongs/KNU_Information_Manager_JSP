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
	function addFavorite(btn){
		var tr = btn.parentNode.parentNode;
		var url = tr.cells[1].childNodes[0].getAttribute('href');
		var title = tr.cells[1].childNodes[0].innerHTML;
		var thisForm = "btn_cse_click.jsp";
		var formUrl = "addFavorite.jsp?";
		var query = "url="+url+"&title="+title+"&thisForm="+thisForm;
		
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
		}
	}
	function jf_viewArtcl(siteId, fnctNo, bbsArtclSeq) {
		//event.preventDefault ? event.preventDefault() : (event.returnValue = false);
		var url = kurl( '/bbs/' + siteId + "/" + fnctNo + "/" + bbsArtclSeq + "/artclView" );
		$( "form[name='viewForm']" ).attr( "action", url );
		$( "form[name='viewForm']" ).submit();
	}
	function kurl(url){
		var newUrl = "https://cse.kongju.ac.kr"+url;
		console.log(newUrl);
		return newUrl;
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
			  		script.println("alert('????????? ????????? ????????????.')");
			  		script.println("location.href = 'index.jsp'"); 
			  		script.println("</script>");
			  		script.close();
			  		return;
			  	}
				%>
	<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.0/js/bootstrap.bundle.min.js"></script>

<form name="viewForm" method="post">
	<input type="hidden" name="layout" value="JYZDOGPCncVlhwx32BNp%2BbECT9MbeWxhVFwsIyGN%2F0c%3D">
</form>


<header class="navbar navbar-expand navbar-dark bg-dark bd-navbar">
  <a class="navbar-brand" href="notice.jsp" style="font-size:25px;">EveryNotice</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarNav">
    <ul class="navbar-nav ml-auto">
				<li class="nav-item"><a class="nav-link"> <%=userNickname%>???, ???????????????!</a></li>
				<li class="nav-item"><a class="nav-link" href="userLogout.jsp">????????????</a></li>
			</ul>
  </div>
</header>

<div class="container-fluid">
  <div class="row flex-nowrap">
    <div class="col-3 bd-sidebar">
        <nav id="sidebar">
				<div class="sidebar-header">
					<h3> ????????? ?????????...	</h3>
				</div>
				<ul class="list-unstyled componenets">
					
					<li id="selected">
						<a href="notice.jsp">
							<span>????????????</span></a>
					</li>
					<li>
						<a href="#"></span>????????????</a>
					</li>
					<li>
						<a href="freeBoard.jsp">
							<span></span>???????????????</a>
					</li>
					<li>
						<a href="#"></span>???????????????</a>
					</li>
					<li>
						<a href="keyword.jsp"></span>????????? ??????</a>
					</li>
				</ul>
			</nav>
      <div class='bd-sidebar-footer'>
        <span>Copyright???2021 by wonjong, hyojeong, songhui</span>
      </div>
    </div>
    <main class="col-9 py-md-3 pl-md-5 bd-content" role="main">
	
	<!-- Large button group -->
	<span style="font-size:40px; margin-right:10px;">????????????(??????????????????)</span><br>
	<div class="btn-group">
		<button class="btn-site site-selected" id="btn-knu" onclick="location.href='notice.jsp'">???????????????</button>
		<button class="btn-site" id="btn-cse">??????????????????</button>
	</div>
	<br><span> ????????? 
	<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%
			request.setCharacterEncoding("UTF-8");
			List<String> list = new ArrayList<>();
			
			try{
				InitialContext ctx = new InitialContext();
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
				Connection con = ds.getConnection();
				
				PreparedStatement pstmt = null;
				String sql = "select keyword from keyword where nickname = ?;";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, nickname);
				
				ResultSet result = pstmt.executeQuery();
				while (result.next()) {
					list.add(result.getString(1));
					out.print("#"+result.getString(1)+" ");
				
				}
					result.close();
					pstmt.close();
					con.close();
				}catch(Exception e){
					out.println("db??????");
					e.printStackTrace();
				}
				
			%>	
			??? ????????? ???????????????
			</span>
	<br><br>
	<div class="table">
		<table style="width:100%;">
			<thead>
				<tr>
					<th style="width:10%;">no.</th>
					<th style="width:75%;">??????</th>
					<th style="width:15%; text-align:right;">????????????</th>
				</tr>
			</thead>
			<tbody>
				<%
	
	int count =0;
	String CSE_URL = "https://cse.kongju.ac.kr/bbs/ZD1110/1405/artclList.do";
	// ????????? ???????????? ????????????(?????? ???????????? ?????? ????????? ??? ?????????)
	Document doc;
	for (int i = 0; i < 5; i++) {
		doc = Jsoup.connect(CSE_URL).data("page", Integer.toString(i)).post();
		Elements posts = doc.select(".td-subject a");
		Boolean isEmpty = posts.isEmpty();
		
		
		if(isEmpty==false){
			for (Element e : posts) {
				for(String keyword : list){
	                if(e.text().contains(keyword)){
	                    count++;
	                    String location[] = e.attr("href").split("/");
	                    System.out.println("location2: "+ location[2]);
	                    System.out.println("location3: "+ location[3]);
	                    System.out.println("location4: "+ location[4]);
	                    /*
	                    out.println("<tr><td>"+count+"</td><td><a href='https://cse.kongju.ac.kr"+e.attr("href")+"'>"+e.text()+
	                    		"</td><td style='text-align:right;'><button class='btn btn-primary' onclick='addFavorite(this)'"+
	                    		" style='margin:0;'>??????</td></tr>");*/
	                    
	                    out.println("<tr><td>"+count+"</td><td><a href='#' onclick=jf_viewArtcl('"+location[2]+"','"+location[3]+"','"+location[4]+"')>"+e.text()+
	                    		"</td><td style='text-align:right;'><button class='btn btn-primary' onclick='addFavorite(this)'"+
	                    		" style='margin:0;'>??????</td></tr>");
	                   // System.out.println("count"+count+"text:"+e.text());
	                }
	            }
			}
		}
	}
	count=0;
	//String title=doc.title();
	//out.println("<tr><td>"+2+"</td><td>"+posts.text()+"</td></tr>");
	%>
			</tbody>
		</table>
	</div>
    </main>
  </div>
</div>
</body>
</html>