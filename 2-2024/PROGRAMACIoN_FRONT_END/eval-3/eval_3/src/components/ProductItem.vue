<template>
    <div class="product-item">
      <img :src="product.image" :alt="product.name">
      <div>
        <h3>{{ product.name }} - Precio $: {{ product.price }}</h3>
        <button @click="addToCart">Agregar al carrito</button>
      </div>
    </div>
  </template>
  
  <script lang="ts">
  import { defineComponent, PropType } from 'vue';
  
  interface Product {
    name: string;
    price: number;
    stock: number;
    image: string;
  }
  
  export default defineComponent({
    name: 'ProductItem',
    props: {
      product: {
        type: Object as PropType<Product>,
        required: true
      }
    },
    methods: {
      addToCart() {
        this.$emit('add-to-cart', this.product);
      }
    }
  });
  </script>
  
  <style scoped>
  .product-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20px;
  }
  
  .product-item img {
    width: 50px;
    height: 50px;
    object-fit: cover;
    border-radius: 4px;
  }
  
  .product-item button {
    background-color: #6200ea;
    color: white;
    border: none;
    border-radius: 4px;
    padding: 10px 20px;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }
  
  .product-item button:hover {
    background-color: #3700b3;
  }
  </style>
  