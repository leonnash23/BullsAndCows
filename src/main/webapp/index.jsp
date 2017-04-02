<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="bullsandcows.model.User" %>
<%@ page import="bullsandcows.controller.GameController" %>
<%@ page import="bullsandcows.model.GameInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="bullsandcows.model.GameStatus" %>
<%@ page contentType="text/html;charset=utf-8" %>
<html>
<head>
    <!--Import Google Icon Font-->
    <link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!--Import materialize.css-->
    <link type="text/css" rel="stylesheet" href="css/materialize.css"  media="screen,projection"/>

    <!--Let browser know website is optimized for mobile-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script>
        function writeNumber(n) {
            var hiddenStr = document.getElementById("number");
            if(hiddenStr.getAttribute("value") === "Введите число"){
                hiddenStr.setAttribute("value","")
            }
            hiddenStr.setAttribute('value', String(hiddenStr.value)+String(n));
            var viewStr = document.getElementById("viewNumber");
            viewStr.innerHTML = hiddenStr.getAttribute("value");
            if(hiddenStr.getAttribute("value").length===4){
                hide(document.getElementById("numberKeyboard"))
            }
        }
        function hide(el) {
            el.style.display = 'none'
        }
        function show(el) {
            el.style.display = ''
        }
        function del() {
            var hiddenStr = document.getElementById("number");
            var val = hiddenStr.getAttribute("value");
            if(val.length !== 0) {
                var last = val[val.length - 1];
                hiddenStr.setAttribute("value", val.slice(0, -1));
                var viewStr = document.getElementById("viewNumber");
                viewStr.innerHTML = hiddenStr.getAttribute("value");
                if (hiddenStr.getAttribute("value").length < 4) {
                    show(document.getElementById("numberKeyboard"))
                }
                show(document.getElementById(last))
            }
        }
        function check(el) {
            var hiddenStr = document.getElementById("number");
            if(hiddenStr.getAttribute("value").length<4){
                alert("Введите четыре цифры");
            } else {
                el.submit()
            }
        }
    </script>
</head>
<body>
<nav>
    <div class="nav-wrapper">
        <a href="#" class="brand-logo">Bulls And Cows</a>
        <ul id="nav-mobile" class="right hide-on-med-and-down">
            <li><a href="registration.jsp">Регистрация</a></li>
        </ul>
    </div>
</nav>
    <div class="container">
        <div class="row">
            <div class="col s12 m4 l2"></div>
            <div class="col s12 m4 l8">

                <%
                    GameInfo gameInfo = (GameInfo) session.getAttribute("game");
                    GameController gameController;
                    if(gameInfo == null) {
                        User user = new User("Leonid", "123");
                        gameController = new GameController(user);
                    }else {
                        gameController = new GameController(gameInfo);
                    }
                    if(request.getParameter("number") != null){
                        gameController.doAttempt(Integer.parseInt(request.getParameter("number")));
                    }
                    if (request.getParameter("action") != null && request.getParameter("action").equals("newGame")){
                        gameController.newGame();
                    }
                    int[] bc;
                    ArrayList<Integer> attempts = gameController.getGameInfo().getAttempts();
                %>
                    <table class="highlight">
                        <thead>
                            <tr>
                                <th>Ваш ход</th>
                                <th>Результат</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (int i1 = 0; i1 < attempts.size(); i1++) {
                                    int i = attempts.get(i1);
                                    bc = gameController.getBullsAndCows(i);
                            %>
                            <tr>
                                <td><p class="flow-text"><%=i%></p></td>
                                <td><p class="flow-text"><%=bc[0]%>Б<%=bc[1]%>К</p></td>
                            </tr>
                            <%
                                }
                                session.setAttribute("game",gameController.getGameInfo());
                            %>
                        </tbody>
                    </table>
                <div class="row z-depth-4" style="padding: 10px">
                    <form action="/" method="post" onsubmit="check(this); return false">
                        <%
                        if(gameController.getGameInfo().getGameStatus() == GameStatus.IN_PROCESS){
                        %>
                        <input id="number" name="number"  hidden type="number" title="Number" value=""/>
                        <h2 id="viewNumber" class="flow-text">Введите число</h2>
                        <div id="numberKeyboard" class="center-align">
                            <a id='0' class="waves-effect waves-light btn-large" onclick="hide(this); writeNumber(0)">0</a>
                            <a id='1' class="waves-effect waves-light btn-large" onclick="hide(this); writeNumber(1)">1</a>
                            <a id='2' class="waves-effect waves-light btn-large" onclick="hide(this); writeNumber(2)">2</a>
                            <a id='3' class="waves-effect waves-light btn-large" onclick="hide(this); writeNumber(3)">3</a>
                            <a id='4' class="waves-effect waves-light btn-large" onclick="hide(this); writeNumber(4)">4</a>
                            <a id='5' class="waves-effect waves-light btn-large" onclick="hide(this); writeNumber(5)">5</a>
                            <a id='6' class="waves-effect waves-light btn-large" onclick="hide(this); writeNumber(6)">6</a>
                            <a id='7' class="waves-effect waves-light btn-large" onclick="hide(this); writeNumber(7)">7</a>
                            <a id='8' class="waves-effect waves-light btn-large" onclick="hide(this); writeNumber(8)">8</a>
                            <a id='9' class="waves-effect waves-light btn-large" onclick="hide(this); writeNumber(9)">9</a>
                        </div>
                        <div class="center-align">
                            <a class="btn waves-effect waves-light" onclick="del()" name="delete">Стереть</a>
                            <button class="btn waves-effect waves-light" type="submit" name="action">Отправить</button>
                        </div>
                        <%}else if(gameController.getGameInfo().getGameStatus() == GameStatus.ENDED) {%>
                        <div class="center-align">
                            <p class="flow-text">Число угадано на <%=gameController.getGameInfo().getAttemptCount()%> шаге! Поздравляем!</p>
                            <button class="btn waves-effect waves-light" type="submit"
                                    name="action" value="newGame">Начать новую игру</button>
                        </div>
                        <%}%>
                    </form>
                </div>
                <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
                <script type="text/javascript" src="js/materialize.min.js"></script>
            </div>
            <div class="col s12 m4 l2"></div>
        </div>
    </div>
</body>
</html>
