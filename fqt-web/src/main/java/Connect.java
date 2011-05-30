/**
 * Created by IntelliJ IDEA.
 * User: nanneosinga
 * Date: 5/25/11
 * Time: 8:12 PM
 * To change this template use File | Settings | File Templates.
 */
import java.sql.*;

public class Connect {
    public static void main (String[] args)
     {
         Connection conn = null;

         try
         {
             String userName = "nosinga@localhost";
             String password = "valkstraat06";
             String url = "jdbc:mysql://localhost:3306/fqt";
             Class.forName ("com.mysql.jdbc.Driver").newInstance ();
             conn = DriverManager.getConnection (url, userName, password);
             System.out.println ("Database connection established");
        }
         catch (Exception e)
         {
             e.printStackTrace();
             System.err.println ("Cannot connect to database server");
         }
         finally
         {
             if (conn != null)
             {
                 try
                 {
                     conn.close ();
                     System.out.println ("Database connection terminated");
                 }
                 catch (Exception e) { /* ignore close errors */ }
             }
         }
     }
 }
