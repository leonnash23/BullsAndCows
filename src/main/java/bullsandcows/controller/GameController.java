package bullsandcows.controller;

import bullsandcows.model.GameInfo;
import bullsandcows.model.GameStatus;
import bullsandcows.model.User;
import lombok.Getter;

import java.sql.SQLException;
import java.util.HashSet;
import java.util.Random;
import java.util.Scanner;

/**
 * Created by leonid on 01.04.17.
 */

public class GameController {
    private UserDAO userDAO;
    @Getter
    private GameInfo gameInfo;

    public GameController(User user) {
        this.gameInfo = new GameInfo(user, generateNumber());

    }
    public GameController(GameInfo gameInfo){
        this.gameInfo = gameInfo;

    }
    private int generateNumber(){
        Random random = new Random();
        int temp = 0;
        do {
            temp = random.nextInt(9000)+1000;
        }while (!checkNumber(temp));
        System.out.println(temp);
        return temp;
    }
    private boolean checkNumber(int number){
        HashSet<Integer> numbers = new HashSet<Integer>();
        int temp = 0;
        for (int i = 1;i<=4;i++){
            temp = (number%((int)Math.pow(10,i)))/((int)Math.pow(10,i-1));
            if(numbers.contains(temp)){
                return false;
            }
            else{
                numbers.add(temp);
            }
        }
        return true;
    }
    /**
     *
     * @param number
     * @return count of bulls(ans[0]) and of cows(ans[1])
     */
    public int[] doAttempt(int number){
        gameInfo.addAttempt(number);
        int[] ans = getBullsAndCows(number);
        if (ans[0]==4){
            gameInfo.setGameStatus(GameStatus.ENDED);
            gameInfo.getUser().updateRating(gameInfo.getAttemptCount());
            try {
                userDAO = new UserDAO();
                userDAO.saveUser(gameInfo.getUser());
            } catch (SQLException e) {
                    e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } finally {
                try {
                    userDAO.closeDB();
                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return ans;
    }
    public int[] getBullsAndCows(int number){
        int[] ans = new int[2];
        String req = String.valueOf(gameInfo.getRequiredNumber());
        String get = String.valueOf(number);
        for(int i=0;i<4;i++){
            if(req.indexOf(get.charAt(i))!=-1){
                if (req.indexOf(get.charAt(i)) == i){
                    ans[0]++;
                }
                else {
                    ans[1]++;
                }
            }
        }
        return ans;
    }
    public static void main(String[] args) {
        User user = new User("Leonid","12345",0);
        GameController gameController = new GameController(user);
        Scanner sc = new Scanner(System.in);
        int[] gameAns;
        int temp;
        while (gameController.gameInfo.getGameStatus()== GameStatus.IN_PROCESS){
            temp = sc.nextInt();
            if(temp == -1){
                System.out.println(gameController.gameInfo.getRequiredNumber());
                continue;
            }
            gameAns = gameController.doAttempt(temp);
            System.out.printf("%d) %d Bulls, %d Cows\n",
                    gameController.gameInfo.getAttemptCount(),gameAns[0],gameAns[1]);
        }
        System.out.printf("Attempts count = %d\n",gameController.gameInfo.getAttemptCount());
    }

    public void newGame() {
        gameInfo = new GameInfo(gameInfo.getUser(), generateNumber());
    }
}
