<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <%
        session.setAttribute("user",null);
        session.setAttribute("game",null);
        response.sendRedirect("login.jsp");
    %>
</body>
</html>
