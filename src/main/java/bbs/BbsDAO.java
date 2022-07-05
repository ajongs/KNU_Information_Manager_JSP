package bbs;
 
import java.sql.*;
import java.util.ArrayList;
import javax.sql.*;
import javax.naming.*;
public class BbsDAO {
    
    public BbsDAO(){ 
    }
    
    public String getDate() // 占쏙옙占쏙옙챨占쏙옙占� 占쌍억옙占쌍깍옙占쏙옙占쏙옙
    {
    	Connection conn=null;           
        ResultSet rs=null;             
        PreparedStatement pstmt=null;
        String SQL = "SELECT NOW()"; // 占쏙옙占쏙옙챨占쏙옙占� 占쏙옙타占쏙옙占쏙옙 mysql
        try {
        	InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			conn = ds.getConnection();
            pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if(rs.next()) {
                return rs.getString(1);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        	try { if(conn != null) conn.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {	e.printStackTrace(); }
        }
        return ""; // 占쏙옙占쏙옙占싶븝옙占싱쏙옙 占쏙옙占쏙옙
    }
    
    public int getNext()
    {
        String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; // 占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙 占쏙옙占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙 占쏙옙占쏙옙 占쏙옙占쏙옙占승댐옙
        Connection conn=null;           
        ResultSet rs=null;             
        PreparedStatement pstmt=null;
        try {     
        	InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			conn = ds.getConnection();
            pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if(rs.next()) {
                return rs.getInt(1) + 1; // 占쏙옙 占쏙옙占쏙옙 占쌉시깍옙占쏙옙 占쏙옙호
            }
            return 1; // 첫 占쏙옙째 占쌉시뱄옙占쏙옙 占쏙옙占�
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
        	try { if(conn != null) conn.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {	e.printStackTrace(); }
        }
        return -1; // 占쏙옙占쏙옙占싶븝옙占싱쏙옙 占쏙옙占쏙옙
    }
    
    public int write(String bbsTitle, String userId, String bbsContent) {
        String SQL = "INSERT INTO BBS VALUES (?,?,?,?,?,?)";
        Connection conn=null;           
        ResultSet rs=null;             
        PreparedStatement pstmt=null;
        try {
        	InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			conn = ds.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext());
            pstmt.setString(2, bbsTitle);
            pstmt.setString(3, userId);
            pstmt.setString(4, getDate());
            pstmt.setString(5, bbsContent);
            pstmt.setInt(6, 1);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
        	try { if(conn != null) conn.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {	e.printStackTrace(); }
        }
        return -1; // 占쏙옙占쏙옙占싶븝옙占싱쏙옙 占쏙옙占쏙옙
    }

    public ArrayList<Bbs> getList(int pageNumber)
    {
    	Connection conn=null;           
        ResultSet rs=null;             
        PreparedStatement pstmt=null;
        String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10"; // 占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙 占쏙옙占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙 占쏙옙占쏙옙 占쏙옙占쏙옙占승댐옙
        ArrayList<Bbs> list = new ArrayList<Bbs>();
        try {
        	InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			conn = ds.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext() - (pageNumber - 1 ) * 10);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Bbs bbs = new Bbs();
                bbs.setBbsID(rs.getInt(1));
                bbs.setBbsTitle(rs.getString(2));
                bbs.setuserId(rs.getString(3));
                bbs.setBbsDate(rs.getString(4));
                bbs.setBbsContent(rs.getString(5));
                bbs.setBbsAvailable(rs.getInt(6));
                list.add(bbs);
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
    
//  占쏙옙占쏙옙징 처占쏙옙占쏙옙 占쏙옙占쏙옙 占쌉쇽옙
  public boolean nextPage(int pageNumber) {
	  Connection conn=null;           
      ResultSet rs=null;             
      PreparedStatement pstmt=null;
      String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1"; 
      try {
    	  InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			conn = ds.getConnection();
          pstmt = conn.prepareStatement(SQL);
          pstmt.setInt(1, getNext() - (pageNumber - 1 ) * 10);
          rs = pstmt.executeQuery();
          if (rs.next())
          {
              return true;
          }
      } catch (Exception e) {
          e.printStackTrace();
      }finally {
      	try { if(conn != null) conn.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(pstmt != null) pstmt.close(); } catch (Exception e) {	e.printStackTrace(); }
			try { if(rs != null) rs.close(); } catch (Exception e) {	e.printStackTrace(); }
      }
      return false; 
  }
  
  public Bbs getBbs(int bbsID)
  {
	  Connection conn=null;           
      ResultSet rs=null;             
      PreparedStatement pstmt=null;
  	String SQL = "SELECT * FROM BBS WHERE bbsID = ?"; 
  	try {
  		InitialContext ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
		conn = ds.getConnection();
  		pstmt = conn.prepareStatement(SQL);
  		pstmt.setInt(1, bbsID);
  		rs = pstmt.executeQuery();              
  		if (rs.next()) 
  		{
  			Bbs bbs = new Bbs();                
  			bbs.setBbsID(rs.getInt(1));              
  			bbs.setBbsTitle(rs.getString(2));                   
  			bbs.setuserId(rs.getString(3));                
  			bbs.setBbsDate(rs.getString(4));              
  			bbs.setBbsContent(rs.getString(5));    
  			bbs.setBbsAvailable(rs.getInt(6));  
  			return bbs;               
  		}        
  	} catch (Exception e) {        
  		e.printStackTrace();           
  	} finally {
    	try { if(conn != null) conn.close(); } catch (Exception e) {	e.printStackTrace(); }
		try { if(pstmt != null) pstmt.close(); } catch (Exception e) {	e.printStackTrace(); }
		try { if(rs != null) rs.close(); } catch (Exception e) {	e.printStackTrace(); }
    }     
  	return null; 
  }
  
	public int update(int bbsID, String bbsTitle, String bbsContent)
	{
		Connection conn=null;           
        ResultSet rs=null;             
        PreparedStatement pstmt=null;
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		try {
			InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(SQL);      
			pstmt.setString(1, bbsTitle);        
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
	        } catch (Exception e) {
	        	e.printStackTrace();
	        }finally {
	        	try { if(conn != null) conn.close(); } catch (Exception e) {	e.printStackTrace(); }
				try { if(pstmt != null) pstmt.close(); } catch (Exception e) {	e.printStackTrace(); }
				try { if(rs != null) rs.close(); } catch (Exception e) {	e.printStackTrace(); }
	        }
		return -1; // 占쏙옙占쏙옙占싶븝옙占싱쏙옙 占쏙옙占쏙옙
		}
	
	public int delete(int bbsID) {
		Connection conn=null;           
        ResultSet rs=null;             
        PreparedStatement pstmt=null;
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID=?";
		try {
			InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(SQL);      
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
	        } catch (Exception e) {
	        	e.printStackTrace();
	        }finally {
	        	try { if(conn != null) conn.close(); } catch (Exception e) {	e.printStackTrace(); }
				try { if(pstmt != null) pstmt.close(); } catch (Exception e) {	e.printStackTrace(); }
				try { if(rs != null) rs.close(); } catch (Exception e) {	e.printStackTrace(); }
	        }
		return -1; // 占쏙옙占쏙옙占싶븝옙占싱쏙옙 占쏙옙占쏙옙
		}
}


 
