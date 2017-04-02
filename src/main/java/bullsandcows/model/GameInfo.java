package bullsandcows.model;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;

/**
 * Created by leonid on 01.04.17.
 */
public class GameInfo {
    @Getter
    private final User user;
    @Getter
    private final int requiredNumber;
    @Getter
    private ArrayList<Integer> attempts;
    @Getter @Setter
    private GameStatus gameStatus;

    public GameInfo(User user, int requiredNumber) {
        this.user = user;
        this.requiredNumber = requiredNumber;
        this.attempts = new ArrayList<Integer>();
        this.gameStatus = GameStatus.IN_PROCESS;
    }

    public void addAttempt(int attempt){
        attempts.add(attempt);
    }

    public int getAttemptCount(){
        return attempts.size();
    }


}
