package com.near.product.services.impl;

import Product.Product;
import com.near.product.mapper.ProductsMapper;
import com.near.product.services.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductsMapper productsMapper;

    @Override
    public Product findById(Long id) {
        return productsMapper.findById(id);
    }

    @Override
    public List<Product> findAll() {
        return productsMapper.findAll();
    }

    @Override
    public Product save(Product product) {
        productsMapper.insert(product);
        return product;
    }

    @Override
    public Product update(Product product) {
        productsMapper.update(product);
        return product;
    }

    @Override
    public void deleteById(Long id) {
        productsMapper.deleteById(id);
    }
}