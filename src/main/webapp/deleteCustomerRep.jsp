<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<%
try {
    // Get username from the form
    String username = request.getParameter("username");

    // Delete from Employees
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    String query = "DELETE FROM Employees WHERE Username = ? AND Role = 'CustomerRep'";
    PreparedStatement ps = con.prepareStatement(query);
    ps.setString(1, username);
    int rows = ps.executeUpdate();

    if (rows > 0) {
        out.println("<h3>Customer Representative Deleted Successfully!</h3>");
    } else {
        out.println("<h3>No Customer Representative Found with Username: " + username + "</h3>");
    }
} catch (Exception e) {
    out.println("<h3>Error: " + e.getMessage() + "</h3>");
}
%>
<a href="adminPage.jsp">Back to Admin Controls</a>
