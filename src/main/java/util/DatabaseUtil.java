package util;

import java.sql.Connection;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DatabaseUtil { //실직적으로 데이터베이스와 연동
	public static Connection getConnection() {
		try {
			InitialContext ctx = new InitialContext();
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mysql");
			Connection conn = ds.getConnection();
			return conn;
		} catch (Exception e){
			e.printStackTrace();
		}
		return null;
	}
}
