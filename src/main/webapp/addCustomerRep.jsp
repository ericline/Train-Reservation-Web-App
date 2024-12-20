<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<%
try {
    // Get parameters from the form
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Hash the password and insert into Employees
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    String query = "INSERT INTO Employees (FirstName, LastName, Username, PasswordHash, Role) " +
                   "VALUES (?, ?, ?, SHA2(?, 256), 'CustomerRep')";
    PreparedStatement ps = con.prepareStatement(query);
    ps.setString(1, firstName);
    ps.setString(2, lastName);
    ps.setString(3, username);
    ps.setString(4, password);
    ps.executeUpdate();

    out.println("<h3>Customer Representative Added Successfully!</h3>");
} catch (Exception e) {
    out.println("<h3>Error: " + e.getMessage() + "</h3>");
}
%>
<a href="adminPage.jsp">Back to Admin Controls</a>
