package orders;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class order {
    private long orderId;
    private String description;
    private List<Object> items;

    public order(long orderId, String description) {
        this.orderId = orderId;
        this.description = description;
    }
}
