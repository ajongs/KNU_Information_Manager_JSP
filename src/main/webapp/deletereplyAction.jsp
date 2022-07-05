<!-- 실제로 글쓰기를 눌러서 만들어주는 Action페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="reply.ReplyDAO" %>
<%@ page import="reply.Reply" %>
<%@ page import="java.io.PrintWriter" %> <!-- 자바스크립트 문장사용 -->
<% request.setCharacterEncoding("UTF-8"); %> <!-- 건너오는 모든 파일을 UTF-8로 -->
 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Every Notice</title>
</head>
<body>
    <%
        String userId = (String) session.getAttribute("userId"); 
        if(userId == null)
        {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인을 하세요')");
            script.println("location.href = 'login.jsp'");
            script.println("</script>");
        } 
        int replyID = 0;
        if (request.getParameter("replyID") != null)
        {
        	replyID = Integer.parseInt(request.getParameter("replyID"));
        }

        Reply reply = new ReplyDAO().getReply(replyID);
        if (!userId.equals(reply.getuserId()))
        {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('권한이 없습니다')");
            script.println("location.href = 'ViewPost.jsp'");
            script.println("</script>");
        
        } else { 
            ReplyDAO repDAO = new ReplyDAO();
            int result = repDAO.delete(replyID);
                if(result == -1){ // 글삭제에 실패했을 경우
                    PrintWriter script = response.getWriter(); //하나의 스크립트 문장을 넣을 수 있도록.
                    script.println("<script>");
                    script.println("alert('댓글 삭제에 실패했습니다.')");
                    script.println("history.back()");
                    script.println("</script>");
                }
                else { // 글삭제에 성공했을 경우
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("location.href= 'freeBoard.jsp'");
                    script.println("</script>");
                }
       
        } 
    %>
</body>
</html>