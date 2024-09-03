<template>
  <div class="product-list">
    <h2>Productos disponibles</h2>
    <ProductItem
      v-for="product in products"
      :key="product.name"
      :product="product"
      @add-to-cart="addToCart"
    />
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from 'vue';
import ProductItem from './ProductItem.vue';

interface Product {
  name: string;
  price: number;
  stock: number;
  image: string;
}

export default defineComponent({
  name: 'ProductList',
  components: {
    ProductItem
  },
  props: {
    products: {
      type: Array as PropType<Product[]>,
      required: true
    }
  },
  methods: {
    addToCart(product: Product) {
      this.$emit('add-to-cart', product);
    }
  }
});
</script>

<style scoped>
.product-list {
  width: 48%;
}

.product-list h2 {
  text-align: center;
  margin-bottom: 20px;
}
</style>
