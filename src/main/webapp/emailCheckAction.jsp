<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String code = null;
	if(request.getParameter("code") != null) {
		code = request.getParameter("code");
	}
	UserDAO userDAO = new UserDAO();
	String userId = null;
	if(session.getAttribute("userId")!=null) {
		userId = (String) session.getAttribute("userId");
	}
	if(userId == null) {
		
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('로그인을 해주세요!');");
	script.println("location.href = userLogin.jsp;");
	script.println("</script>");
	script.close();
	return;
	}

	String email = userDAO.getUserEmail(userId);
	boolean isRight = (new SHA256().getSHA256(email).equals(code)) ? true : false;
	
	if(isRight == true) {
		userDAO.setUserEmailChecked(userId);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('인증에 성공했습니다.');");
		script.println("location.href = 'notice.jsp';");
		script.println("</script>");
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다. ');");
		script.println("location.href = 'index.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
%>