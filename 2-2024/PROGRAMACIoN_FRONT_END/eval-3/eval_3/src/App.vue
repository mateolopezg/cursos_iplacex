<template>
  <div id="app">
    <div class="container">
      <ProductList :products="products" @add-to-cart="addToCart" />
      <Cart :cart="cart" @remove-from-cart="removeFromCart" />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';
import ProductList from './components/ProductList.vue';
import Cart from './components/Cart.vue';

interface Product {
  name: string;
  price: number;
  stock: number;
  image: string;
}

interface CartItem extends Product {
  quantity: number;
}

export default defineComponent({
  name: 'App',
  components: {
    ProductList,
    Cart
  },
  setup() {
    const products = ref<Product[]>([
      { name: 'Audífono', price: 30000, stock: 3, image: 'https://http2.mlstatic.com/D_NQ_NP_752703-MLU72930435239_112023-V.webp' },
      { name: 'Mouse', price: 20000, stock: 5, image: 'https://http2.mlstatic.com/D_NQ_NP_642150-MLU69345787274_052023-V.webp' },
      { name: 'Teclado', price: 15000, stock: 10, image: 'https://http2.mlstatic.com/D_NQ_NP_761104-MLA74651937680_022024-V.webp' },
      { name: 'Gabinete', price: 35000, stock: 4, image: 'https://http2.mlstatic.com/D_NQ_NP_781658-MLU76807941647_062024-V.webp' },
      { name: 'Pantalla', price: 175000, stock: 3, image: 'https://http2.mlstatic.com/D_NQ_NP_918155-MLU74085538958_012024-V.webp' },
      { name: 'Silla', price: 150000, stock: 2, image: 'https://http2.mlstatic.com/D_NQ_NP_721815-MLA71370137984_082023-V.webp' }
    ]);

    const cart = ref<CartItem[]>([]);

    const addToCart = (product: Product) => {
      const cartItem = cart.value.find(item => item.name === product.name);
      if (cartItem) {
        if (cartItem.quantity < product.stock) {
          cartItem.quantity++;
        }else {
          alert("No hay más unidades en stock")
        }
      } else {
        cart.value.push({ ...product, quantity: 1 });
      }
    };

    const removeFromCart = (product: Product) => {
      const cartItem = cart.value.find(item => item.name === product.name);
      if (cartItem) {
        cartItem.quantity--;
        if (cartItem.quantity === 0) {
          cart.value = cart.value.filter(item => item.name !== product.name);
        }
      }
    };

    return {
      products,
      cart,
      addToCart,
      removeFromCart
    };
  }
});
</script>

<style scoped>
.container {
  display: flex;
  justify-content: space-between;
}
</style>
