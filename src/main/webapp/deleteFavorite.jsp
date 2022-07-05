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
				String userId = (String)session.getAttribute("userId");
				String title=request.getParameter("title");
				
				
				try{
					InitialContext ctx = new InitialContext();
					DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
					Connection con = ds.getConnection();
					
					PreparedStatement pstmt = null;
					
					String sql = "DELETE FROM favorite WHERE userId = ? && title = ?;";
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, userId);
					pstmt.setString(2, title);
					
					pstmt.executeUpdate();
					pstmt.close();
					con.close();
				}catch(Exception e){
					out.println("db오류");
					e.printStackTrace();
				}
				out.println("<span id='result'>삭제되었습니다.</span>");
				
			%>	
</body>
</html>