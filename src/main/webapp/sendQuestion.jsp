<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Send a Question</title>
</head>
<body>
    <h2>Send a Question to a Representative</h2>
    <form method="POST" action="processQuestion.jsp">
        <label for="question">Your Question:</label><br>
        <textarea id="question" name="questionText" rows="4" cols="50" required></textarea><br>
        <button type="submit">Submit Question</button>
    </form>
</body>
</html>
