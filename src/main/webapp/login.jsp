<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>
    <form action="checkLoginDetails.jsp" method="POST">
        Username: <input type="text" name="username" required/> <br/>
        Password: <input type="password" name="password" required/> <br/>
        Role: 
        <select name="role" required>
            <option value="Customer">Customer</option>
            <option value="Admin">Admin</option>
            <option value="CustomerRep">Customer Representative</option>
        </select> <br/><br/>
        <input type="submit" value="Login"/>
    </form>
    <br/>
    <form action="register.jsp" method="GET">
        <input type="submit" value="Register"/>
    </form>
    <br/>
</body>
</html>
