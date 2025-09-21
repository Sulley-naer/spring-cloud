package com.near.product.services;

import Product.Product;

import java.util.List;

public interface ProductService {
    Product findById(Long id);

    List<Product> findAll();

    Product save(Product product);

    Product update(Product product);

    void deleteById(Long id);
}