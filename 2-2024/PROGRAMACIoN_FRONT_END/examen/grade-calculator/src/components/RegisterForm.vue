<!-- src/components/RegisterForm.vue -->
<template>
  <div class="container mt-5">
    <h1>Formulario de registro</h1>
    <form @submit.prevent="register">
      <div class="form-group">
        <label for="name">Nombre</label>
        <input type="text" id="name" v-model="name" class="form-control" required />
      </div>
      <div class="form-group">
        <label for="email">Correo</label>
        <input type="email" id="email" v-model="email" class="form-control" required />
      </div>
      <div class="form-group">
        <label for="password">Contraseña</label>
        <input type="password" id="password" v-model="password" class="form-control" required />
      </div>
      <div class="form-group">
        <label for="confirmPassword">Repetir Contraseña</label>
        <input type="password" id="confirmPassword" v-model="confirmPassword" class="form-control" required />
      </div>
      <button type="submit" class="btn btn-primary">Enviar</button>
    </form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      name: '',
      email: '',
      password: '',
      confirmPassword: ''
    }
  },
  methods: {
    register() {
      if (this.password !== this.confirmPassword) {
        alert('Las contraseñas no coinciden');
      } else {
        alert('El registro se ha realizado correctamente');
      }
    }
  }
}
</script>
