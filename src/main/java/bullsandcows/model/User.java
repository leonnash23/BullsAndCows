package bullsandcows.model;

import lombok.Getter;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

/**
 * Created by leonid on 01.04.17.
 */
@RequiredArgsConstructor
public class User {
    @Getter
    private final String login;
    @Getter
    private final String password;
    @Getter @NonNull
    private double rating;

    public double updateRating(int newRating){
        if(rating == 0.0){
            rating = newRating;
        } else {
            rating = (rating + newRating) / 2;
        }
        return rating;
    }
}
