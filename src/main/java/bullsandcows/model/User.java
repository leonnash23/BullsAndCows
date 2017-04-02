package bullsandcows.model;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

/**
 * Created by leonid on 01.04.17.
 */
@RequiredArgsConstructor
public class User {
    
    private final String login;
    private final String password;
    @Getter
    private double rating;

    public double updateRating(int newRating){
        rating = (rating+newRating)/2;
        return rating;
    }
}
