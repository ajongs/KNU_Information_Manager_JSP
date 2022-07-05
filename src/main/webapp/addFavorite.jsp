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
				String thisForm = request.getParameter("thisForm");
				String url=request.getParameter("url");
				String title=request.getParameter("title");
				
				
				try{
					InitialContext ctx = new InitialContext();
					DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
					Connection con = ds.getConnection();
					
					PreparedStatement pstmt = null;
					
					//// ------------------------여기 고쳐야됌 유저생성시 --------------------------
					//세션 얻어와서 유저 닉네임이랑 같은지 확인하자
					String sql1 = "SELECT title FROM favorite WHERE userId = ?;";
					pstmt = con.prepareStatement(sql1);
					pstmt.setString(1, userId);
					
					ResultSet result = pstmt.executeQuery();
					while(result.next()){
						if(result.getString(1).equals(title)){
							out.println("<span id='result'>이미 추가된 항목입니다.</span>");
							return;
						}
					}
					
					//System.out.println("이거 찍히면안됌 ");
					String sql2 = "INSERT INTO favorite values(? , ? , ?);";
					pstmt=null;
					pstmt = con.prepareStatement(sql2);
					pstmt.setString(1, userId);
					pstmt.setString(2, title);
					pstmt.setString(3, url);
					
					pstmt.executeUpdate();
					pstmt.close();
					con.close();
				}catch(Exception e){
					out.println("db오류");
					e.printStackTrace();
				}
				
				//System.out.println("리턴하면 이게 찍힐까?");
				out.println("<span id='result'>즐겨찾기에 추가되었습니다.</span>");
				
			%>	
</body>
</html>