package orders;

import lombok.Data;

import java.util.List;

@Data
public class order {
    private long orderId;
    private String description;
    private List<Object> items;
}
