<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String userId = null;
	String userPassword = null;

	if(request.getParameter("userId") != null) {
		userId = request.getParameter("userId");
	}
	if(request.getParameter("userPassword") != null) {
		userPassword = request.getParameter("userPassword");
	}

	if(userId == null || userPassword == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	UserDAO userDAO = new UserDAO();
	int result = userDAO.login(userId, userPassword);
	if(result == 1) { //로그인 성공
		session.setAttribute("userId", userId);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'notice.jsp'");
		script.println("</script>");
		script.close();
		return;
	} else if(result == 0){ 
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호를 다시 확인해주세요')");
		script.println("history.back()");
		script.println("</script>");
		script.close();
		return;
	} else if(result == -1){ 
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('아이디를 다시 확인해주세요')");
		script.println("history.back()");
		script.println("</script>");
		script.close();
		return;
	} else if(result == -2){ 
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류 발생')");
		script.println("history.back()");
		script.println("</script>");
		script.close();
		return;
	}
%>