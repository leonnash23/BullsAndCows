<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="bullsandcows.model.User" %>
<%@ page import="bullsandcows.controller.UserDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("user") != null){
        pageContext.setAttribute("user",true);
        pageContext.setAttribute("login", ((User)session.getAttribute("user")).getLogin());
    }
    try {
        UserDAO userDAO = new UserDAO();
        User[] users = userDAO.getTopUsers();
        userDAO.closeDB();
        pageContext.setAttribute("users",users);
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<html>
<head>
    <title>Top</title>
    <!--Import Google Icon Font-->
    <link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!--Import materialize.css-->
    <link type="text/css" rel="stylesheet" href="css/materialize.css"  media="screen,projection"/>

    <!--Let browser know website is optimized for mobile-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
</head>
<body>
    <nav>
        <div class="nav-wrapper">
            <a href="#" class="brand-logo">Bulls And Cows</a>
            <ul id="nav-mobile" class="right hide-on-med-and-down">
                <c:choose>
                    <c:when test="${user}">
                        <li><a href="index.jsp">Играть</a></li>
                        <li><a href="logout.jsp">Выход</a></li>
                    </c:when>
                    <c:when test="${!user}">
                        <li><a href="registration.jsp">Регистрация</a></li>
                        <li><a href="login.jsp">Вход</a></li>
                    </c:when>
                </c:choose>
            </ul>
        </div>
    </nav>
    <div class="container">
        <div class="row">
            <div class="col s12 m4 l2"></div>
            <div class="col s12 m4 l8">
                <table class="highlight">
                    <thead>
                    <tr>
                        <th>Логин</th>
                        <th>Среднее число ходов</th>
                    </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${users}" var="u">
                            <tr>
                                <c:choose>
                                    <c:when test="${user && login == u.login}">
                                        <td><p class="flow-text" style="color: red">${u.login}</p></td>
                                    </c:when>
                                    <c:when test="${!user || login != u.login}">
                                        <td><p class="flow-text">${u.login}</p></td>
                                    </c:when>
                                </c:choose>
                                <td><p class="flow-text">${u.rating}</p></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="col s12 m4 l2"></div>
        </div>
    </div>
    <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
    <script type="text/javascript" src="js/materialize.min.js"></script>
</body>
</html>
