<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Register</title>
</head>
<body>
    <h2>Register</h2>
    <form action="processRegistration.jsp" method="POST">
        First Name: <input type="text" name="firstName" required/> <br/>
        Last Name: <input type="text" name="lastName" required/> <br/>
        Email: <input type="email" name="email" required/> <br/>
        Username: <input type="text" name="username" required/> <br/>
        Password: <input type="password" name="password" required/> <br/>
        <input type="submit" value="Register"/>
    </form>
</body>
</html>