package bullsandcows.controller;

import bullsandcows.model.User;

import java.sql.*;
import java.util.ArrayList;

/**
 * Created by leonid on 02.04.17.
 */
public class UserDAO {

    private Connection conn;
    private Statement statement;
    private ResultSet resultSet;


    public UserDAO() throws ClassNotFoundException, SQLException {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:DATA.db");
        createDB();
    }

    private void createDB() throws SQLException {
        statement = conn.createStatement();
        statement.execute("CREATE TABLE if not exists 'users' " +
                "(" +
                " 'login' text NOT NULL ," +
                " 'password' text NOT NULL ," +
                " 'rating' real NOT NULL ," +
                "PRIMARY KEY ('login'));");
    }

    public void closeDB() throws ClassNotFoundException, SQLException {
        resultSet.close();
        statement.close();
        conn.close();
    }

    public boolean saveUser(User user) throws SQLException {
        if(isUserExist(user)){
            statement.execute("UPDATE users SET rating = "+user.getRating()
                    +" WHERE login = '"+user.getLogin()+"' and password = '"+user.getPassword()+"'");
            return true;
        }
        return false;
    }

    public boolean saveNewUser(User user) throws SQLException {
      if(isUserExist(user)){
          return false;
      } else {
          statement.execute("INSERT INTO 'users' ('login', 'password', 'rating') " +
                  "VALUES ('"+user.getLogin()+"','"+user.getPassword()+"',"+user.getRating()+");");
          return true;
      }
    }

    private boolean isUserExist(User user) throws SQLException {
        resultSet = statement.executeQuery("SELECT * FROM users WHERE login='"+user.getLogin()+
        "'AND password='"+user.getPassword()+"'");
        return resultSet.next();
    }

    public User getUserByLoginPassword(String login, String password) throws SQLException {
        resultSet = statement.executeQuery("SELECT * FROM users WHERE login = '"+login+
                    "' AND password = '"+password+"'");
        if(resultSet.next()){
            return new User(login,password, resultSet.getDouble("rating"));
        }
        else {
            return null;
        }
    }

    public User[] getTopUsers() throws SQLException {
        ArrayList<User> users = new ArrayList<User>();
        resultSet = statement.executeQuery("SELECT * FROM users WHERE rating <> 0.0 ORDER BY rating");
        while (resultSet.next()){
            users.add(new User(resultSet.getString("login"),
                    resultSet.getString("password"),
                    resultSet.getDouble("rating")));
        }
        User[] users1 = new User[users.size()];
        return users.toArray(users1);
    }

}
