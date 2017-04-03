<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="bullsandcows.model.User" %>
<%@ page import="bullsandcows.controller.UserDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%
    if(session.getAttribute("user") != null){
        response.sendRedirect("/");
        return;
    }
    boolean registation = false;
    boolean save = false;
    if(request.getParameter("login") != null){
        registation = true;
        UserDAO userDAO = null;
        try {
            userDAO = new UserDAO();
            User user = new User(request.getParameter("login"),
                    request.getParameter("password"),0);
            save = userDAO.saveNewUser(user);
            if(save) {
                session.setAttribute("user", user);
                pageContext.setAttribute("user", true);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            try {
                userDAO.closeDB();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    pageContext.setAttribute("reg",registation);
    pageContext.setAttribute("save",save);
%>
<html>
    <head>
        <title>Регистрация</title>
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
                    <li><a href="top.jsp">Рейтинг</a></li>
                    <c:choose>
                        <c:when test="${user}">
                            <li><a href="index.jsp">Играть</a></li>
                        </c:when>
                        <c:when test="${!user}">
                            <li><a href="login.jsp">Вход</a></li>
                        </c:when>
                    </c:choose>
                </ul>
            </div>
        </nav>
        <div class="container">
            <c:choose>
                <c:when test="${!reg}">
                    <div class="row">
                        <form class="col s12 offset-l4" action="registration.jsp">
                            <div class="row">
                                <div class="input-field col s4">
                                    <input type="text" placeholder="Логин"  name="login"  required="required">
                                </div>
                            </div>
                            <div class="row">
                                <div class="input-field col s4">
                                    <input type="password" placeholder="Пароль"  name="password"  required="required">
                                </div>
                            </div>
                            <button class="btn waves-effect waves-light" type="submit" >Зарегистрироваться</button>
                        </form>
                    </div>
                </c:when>
                <c:when test="${reg && save}">
                    <h2>Вы успешно зарегистрированы!</h2>
                </c:when>
                <c:when test="${reg && !save}">
                    <h2>Регистрация не прошла. Вероятно пользователь с таким логином уже существует.</h2>
                </c:when>
            </c:choose>
        </div>
        <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
        <script type="text/javascript" src="js/materialize.min.js"></script>
    </body>
</html>