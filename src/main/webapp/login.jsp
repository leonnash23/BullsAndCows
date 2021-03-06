<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="bullsandcows.model.User" %>
<%@ page import="bullsandcows.controller.UserDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%
    boolean login = false;
    User user = null;

    if(request.getParameter("login") !=null){
        login = true;
        try {
            UserDAO userDAO = new UserDAO();
            user = userDAO.getUserByLoginPassword(request.getParameter("login"),
                    request.getParameter("password"));
            userDAO.closeDB();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    if(login && user !=null){
    session.setAttribute("user",user);
    response.sendRedirect("index.jsp");
    }

    pageContext.setAttribute("login",login);
    pageContext.setAttribute("user",user!=null);
%>
<html>
<head>
    <title>Вход</title>
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
        <a href="#" data-activates="mobile-demo" class="button-collapse"><i class="material-icons">menu</i></a>
        <ul id="nav-mobile" class="right hide-on-med-and-down">
            <li><a href="top.jsp">Рейтинг</a></li>
            <li><a href="registration.jsp">Регистрация</a></li>
        </ul>
        <ul class="side-nav" id="mobile-demo">
            <li><a href="top.jsp">Рейтинг</a></li>
            <li><a href="registration.jsp">Регистрация</a></li>
        </ul>
    </div>
</nav>
<div class="container">
    <div class="row">
        <div class="col s12 m4 l2"></div>
        <div class="col s12 m4 l8">
            <c:if test="${login && !user}">
                <p class="flow-text">Неверный логин или пароль</p>
            </c:if>
            <c:if test="${!login || !user}">
                <form action="login.jsp">
                    <div class="row">
                        <div class="input-field col s12 m4 l8">
                            <input type="text" placeholder="Логин"  name="login"  required="required">
                        </div>
                    </div>
                    <div class="row">
                        <div class="input-field col s12 m4 l8">
                            <input type="password" placeholder="Пароль"  name="password"  required="required">
                        </div>
                    </div>
                    <button class="btn waves-effect waves-light" type="submit" >Войти</button>
                </form>
            </c:if>
        </div>
        <div class="col s12 m4 l2"></div>
    </div>
</div>
<script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="js/materialize.min.js"></script>
<script>
    $(".button-collapse").sideNav();
</script>
</body>
</html>