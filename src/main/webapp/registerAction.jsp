<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
				request.setCharacterEncoding("UTF-8");
				String keyword = request.getParameter("keyword");
				//String pw = request.getParameter("pw");
				String nickname=request.getParameter("nickname");
				//System.out.println("keyword : "+keyword);
				//System.out.println("nickname : "+nickname);
				
				try{
					InitialContext ctx = new InitialContext();
					DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
					Connection con = ds.getConnection();
					
					PreparedStatement pstmt = null;
					//// ------------------------여기 고쳐야됌 유저생성시 --------------------------
					//세션 얻어와서 유저 닉네임이랑 같은지 확인하자
					
					String sql = "insert into keyword values(null, ? , ?);";
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, nickname);
					pstmt.setString(2, keyword);
					
					pstmt.executeUpdate();
					pstmt.close();
					con.close();
				}catch(Exception e){
					out.println("db오류");
					e.printStackTrace();
				}
				
				out.println("<script>location.href='keyword.jsp'</script>");
				
			%>	
</body>
</html>