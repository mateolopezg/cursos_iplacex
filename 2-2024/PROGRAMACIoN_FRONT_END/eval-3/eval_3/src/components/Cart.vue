<template>
  <div class="cart">
    <h2>Productos en el carrito</h2>
    <div v-for="item in cart" :key="item.name" class="cart-item">
      <div>
        <h3>{{ item.name }} - Precio $: {{ item.price }} (x{{ item.quantity }})</h3>
        <button @click="removeFromCart(item)">Quitar del carrito</button>
      </div>
    </div>
    <h3 class="total-price">Total a pagar: ${{ totalPrice }}</h3>
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType, computed } from 'vue';

interface CartItem {
  name: string;
  price: number;
  quantity: number;
}

export default defineComponent({
  name: 'Cart',
  props: {
    cart: {
      type: Array as PropType<CartItem[]>,
      required: true
    }
  },
  setup(props) {
    const totalPrice = computed(() => {
      return props.cart.reduce((total, item) => total + item.price * item.quantity, 0);
    });

    return {
      totalPrice
    };
  },
  methods: {
    removeFromCart(item: CartItem) {
      this.$emit('remove-from-cart', item);
    }
  }
});
</script>

<style scoped>
.cart {
  width: 48%;
}

.cart h2 {
  text-align: center;
  margin-bottom: 20px;
}

.cart-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}

.cart-item button {
  background-color: #6200ea;
  color: white;
  border: none;
  border-radius: 4px;
  padding: 10px 20px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.cart-item button:hover {
  background-color: #3700b3;
}

.total-price {
  text-align: center;
  font-size: 1.5rem;
  margin-top: 20px;
}
</style>
