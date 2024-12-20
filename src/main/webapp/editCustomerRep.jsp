<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<%
try {
    // Get username and new password from the form
    String username = request.getParameter("username");
    String newPassword = request.getParameter("newPassword");

    // Update password in Employees
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    String query = "UPDATE Employees SET PasswordHash = SHA2(?, 256) WHERE Username = ? AND Role = 'CustomerRep'";
    PreparedStatement ps = con.prepareStatement(query);
    ps.setString(1, newPassword);
    ps.setString(2, username);
    int rows = ps.executeUpdate();

    if (rows > 0) {
        out.println("<h3>Password Updated Successfully!</h3>");
    } else {
        out.println("<h3>No Customer Representative Found with Username: " + username + "</h3>");
    }
} catch (Exception e) {
    out.println("<h3>Error: " + e.getMessage() + "</h3>");
}
%>
<a href="adminPage.jsp">Back to Admin Controls</a>
