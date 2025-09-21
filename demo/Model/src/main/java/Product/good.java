package Product;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class good {

    private Long id;
    private String name;
    private BigDecimal price;
    private String description;
    private Integer stock;
    private java.sql.Timestamp createdAt;
    private java.sql.Timestamp updatedAt;
}
