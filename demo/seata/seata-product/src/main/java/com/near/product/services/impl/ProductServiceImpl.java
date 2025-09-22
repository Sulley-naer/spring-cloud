package com.near.product.services.impl;

import Product.Product;
import com.near.product.mapper.ProductsMapper;
import com.near.product.services.ProductService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ProductServiceImpl implements ProductService {

    @Resource
    private ProductsMapper productsMapper;

    @Override
    @Transactional
    public Product findById(Long id) {
        return productsMapper.findById(id);
    }

    @Override
    @Transactional
    public List<Product> findAll() {
        return productsMapper.findAll();
    }

    @Override
    @Transactional
    public Product save(Product product) {
        productsMapper.insert(product);
        return product;
    }

    @Override
    @Transactional
    public Product update(Product product) {
        productsMapper.update(product);
        return product;
    }

    @Override
    @Transactional
    public void deleteById(Long id) {
        productsMapper.deleteById(id);
    }
}