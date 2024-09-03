<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="#">Programación Front End</a>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
          <router-link class="nav-link" to="/">Cálculo de calificaciones</router-link>
        </li>
        <li class="nav-item">
          <router-link class="nav-link" to="/register">Formulario de Registro</router-link>
        </li>
      </ul>
    </div>
  </nav>
</template>
<script>
export default {
  name: 'Navbar'
}
</script>
<style scoped>
.navbar-brand {
  font-weight: bold;
}
</style>
