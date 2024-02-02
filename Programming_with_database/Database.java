  //programming with querying 
import java.sql.*;
public class Main {
    public static void main(String args[]) {

        Statement stmt = null;
        try {
           Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:Port/Database_name", "User_name", "Password");
//test
//            insert(1, "John Doe", 30, "123 Main St", 50000.0);
//           insert(2, "Amir", 30, "123 Main St", 50000.0);
//            read(1);
//            read(2);
//            update(1,"address","USA");
//            update(2,"NAME","amirreza");
//            delete(c,1);
//            delete(c,2);

          //Create Table
            stmt = c.createStatement();
            String sql = "CREATE TABLE Employee " +
                    "(ID INT PRIMARY KEY NOT NULL, " +
                    " NAME TEXT NOT NULL, " +
                    " AGE INT NOT NULL, " +
                    " ADDRESS CHAR(50), " +
                    " SALARY REAL)";
            stmt.executeUpdate(sql);
            stmt.close();
            c.close();
        } catch (SQLException e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            System.exit(0);

            System.out.println("Table created successfully");
        }
    }

    public static void insert(int id, String name, int age, String address, double salary) {

        PreparedStatement stmt = null;
        try {

          Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:Port/Database_name", "User_name", "Password");
          c.setAutoCommit(false);

            String sql = "INSERT INTO Employee (ID, NAME, AGE, ADDRESS, SALARY) " + "VALUES (?, ?, ?, ?, ?)";
            stmt = c.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.setString(2, name);
            stmt.setInt(3, age);
            stmt.setString(4, address);
            stmt.setDouble(5, salary);
            stmt.executeUpdate();

            c.commit();
            stmt.close();
            c.close();
        } catch (SQLException e) {
            System.err.println(e.getClass().getName() + ": " + e.getMessage());
            System.exit(0);
        }
        System.out.println("Record created successfully");
    }
    public static void read(int id) {


        try {
            Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:Port/Database_name", "User_name", "Password");

            String sql = "SELECT * FROM Employee WHERE id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                int dbId = rs.getInt("id");
                String name = rs.getString("name");
                int age = rs.getInt("age");
                String add = rs.getString("address");
                double sal = rs.getDouble("salary");


                System.out.println("ID = " + dbId);
                System.out.println("Name = " + name);
                System.out.println("Age = " + age);
                System.out.println("Address = " + add);
                System.out.println("salary = " + sal);
            }

            conn.close();
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
    public static void delete(Connection conn, int rowId) throws SQLException {
        PreparedStatement stmt = conn.prepareStatement("DELETE FROM Employee WHERE id = ?");
        stmt.setInt(1, rowId);
        stmt.executeUpdate();
        System.out.println("Record deleted successfully");
    }
    public static void update(int id, String attributeName, Object attributeValue) throws SQLException {
        Connection c = DriverManager.getConnection("jdbc:postgresql://localhost:Port/Database_name", "User_name", "Password");
        PreparedStatement stmt = conn.prepareStatement(String.format("UPDATE Employee SET %s = ? WHERE id = ?", attributeName));
        stmt.setObject(1, attributeValue);
        stmt.setInt(2, id);
        stmt.executeUpdate();
        conn.close();
        System.out.println("Record updated successfully");
    }
}
