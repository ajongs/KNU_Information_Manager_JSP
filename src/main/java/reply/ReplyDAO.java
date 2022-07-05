package reply;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.InitialContext;
import javax.sql.DataSource;

import bbs.Bbs;

public class ReplyDAO {
	
	public ReplyDAO() {
        
    }
	
	
	public ArrayList<Reply> getList(int bbsID,int pageNumber){
		Connection conn=null;           
        ResultSet rs=null;             
        PreparedStatement pstmt=null;
		String SQL="SELECT * FROM REPLY WHERE replyID<? AND replyAvailable=1 AND bbsID=? ORDER BY replyID DESC LIMIT 10";
		ArrayList<Reply> list=new ArrayList<Reply>();
		try {
			InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			conn = ds.getConnection();
			pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1,getNext()-(pageNumber-1)*10);
			pstmt.setInt(2, bbsID);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				Reply reply=new Reply();
				reply.setuserId(rs.getString(1));
				reply.setReplyID(rs.getInt(2));
				reply.setReplyContent(rs.getString(3));
				reply.setBbsID(bbsID);
				reply.setReplyAvailable(1); // rs.getInt(5) => out of index ����
				list.add(reply);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
        	try { if(conn != null) conn.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {	e.printStackTrace(); }
        }
		return list;
	}
	
	public int getNext() {
		Connection conn=null;           
        ResultSet rs=null;             
        PreparedStatement pstmt=null;
		String SQL="select replyID FROM REPLY ORDER BY replyID DESC";
		try {
			InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			conn = ds.getConnection();
			pstmt=conn.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				System.out.println(rs.getInt(1)); // select������ ù��° ��
				return rs.getInt(1)+1;  // ���� �ε���(���� �Խñ� ����) +1 ��ȯ
			}
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
        	try { if(conn != null) conn.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {	e.printStackTrace(); }
        }
		return -1;
	}
	public int write(int bbsID,String replyContent,String userId) {
		String SQL="INSERT INTO REPLY VALUES(?,?,?,?,?)";
		Connection conn=null;           
        ResultSet rs=null;             
        PreparedStatement pstmt=null;
		try {
			InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			conn = ds.getConnection();
			pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1,userId);
			pstmt.setInt(2, getNext());
			pstmt.setString(3, replyContent);
			pstmt.setInt(4,bbsID);
			pstmt.setInt(5,1);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
        	try { if(conn != null) conn.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {	e.printStackTrace(); }
        }
		return -1;
	}
	
	 public Reply getReply(int replyID)
	  {
		 Connection conn=null;           
	        ResultSet rs=null;             
	        PreparedStatement pstmt=null;
	  	String SQL = "SELECT * FROM reply WHERE replyID = ?"; 
	  	try {
	  		InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			conn = ds.getConnection();
	  		pstmt = conn.prepareStatement(SQL);
	  		pstmt.setInt(1, replyID);
	  		rs = pstmt.executeQuery();              
	  		if (rs.next()) 
	  		{
	  			Reply reply = new Reply();  
	  			reply.setuserId(rs.getString(1));
	  			reply.setReplyID(rs.getInt(2));              
	  			reply.setReplyContent(rs.getString(3));                   
	  			reply.setBbsID(rs.getInt(4));                
	  			reply.setReplyAvailable(5);              
	  			return reply;               
	  		}        
	  	} catch (Exception e) {        
	  		e.printStackTrace();           
	  	}      finally {
        	try { if(conn != null) conn.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {	e.printStackTrace(); }
        }
	  	return null; 
	  }
	 
	public int delete(int replyID) {
		String SQL = "UPDATE reply SET replyAvailable = 0 WHERE replyID=?";
		Connection conn=null;           
        ResultSet rs=null;             
        PreparedStatement pstmt=null;
		try {
			InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(SQL);      
			pstmt.setInt(1, replyID);
			return pstmt.executeUpdate();
	        } catch (Exception e) {
	        	e.printStackTrace();
	        }finally {
	        	try { if(conn != null) conn.close(); } catch (Exception e) {	e.printStackTrace(); }
				try { if(pstmt != null) pstmt.close(); } catch (Exception e) {	e.printStackTrace(); }
				try { if(rs != null) rs.close(); } catch (Exception e) {	e.printStackTrace(); }
	        }
		return -1; // �����ͺ��̽� ����
		}
}