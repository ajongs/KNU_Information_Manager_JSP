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
	String userNickname = null;
	String userEmail = null;

	if(request.getParameter("userId") != null) {
		userId = request.getParameter("userId");
	}
	if(request.getParameter("userPassword") != null) {
		userPassword = request.getParameter("userPassword");
	}
	if(request.getParameter("userNickname") != null) {
		userNickname = request.getParameter("userNickname");
	}
	if(request.getParameter("userEmail") != null) {
		userEmail = request.getParameter("userEmail");
	}
	
	if(userId == null || userPassword == null || userNickname == null || userEmail == null ) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.')");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	String target = "@";
	String smail = "@smail.kongju.ac.kr";
	int target_num = userEmail.indexOf(target);
	String stdresult = userEmail.substring(target_num);
	
	if(stdresult.equals(smail)!=true){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('공주대학교 학생 메일이 아닙니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	UserDAO userDAO = new UserDAO();
	if (userDAO.setUserEmailDuplicate(userEmail)){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 존재하는 이메일입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	int result = userDAO.join(new UserDTO(userId, userPassword, userNickname, userEmail, SHA256.getSHA256(userEmail), false));
	if(result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 존재하는 아이디 혹은 닉네임입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else { // 회원가입 성공 -> 로그인
		session.setAttribute("userId", userId);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'emailSendAction.jsp'");
		script.println("</script>");
		script.close();
		return;
	} 
%>