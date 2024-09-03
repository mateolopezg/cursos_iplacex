<!-- src/components/GradeCalculator.vue -->
<template>
  <div class="container mt-5">
    <h1>Cálculo de calificaciones</h1>
    <form @submit.prevent="calculate">
      <div class="form-group">
        <label for="nota1">Nota 1</label>
        <input type="number" id="nota1" v-model="nota1" class="form-control" min="10" max="70" required />
      </div>
      <div class="form-group">
        <label for="nota2">Nota 2</label>
        <input type="number" id="nota2" v-model="nota2" class="form-control" min="10" max="70" required />
      </div>
      <div class="form-group">
        <label for="nota3">Nota 3</label>
        <input type="number" id="nota3" v-model="nota3" class="form-control" min="10" max="70" required />
      </div>
      <div class="form-group">
        <label for="asistencia">Asistencia %</label>
        <input type="number" id="asistencia" v-model="asistencia" class="form-control" min="0" max="100" required />
      </div>
      <button type="submit" class="btn btn-primary">Calcular</button>
    </form>
    <div v-if="message" class="mt-3 alert" :class="{'alert-success': passed, 'alert-danger': !passed}">
      {{ message }}
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      nota1: null,
      nota2: null,
      nota3: null,
      asistencia: null,
      message: '',
      passed: false
    }
  },
  methods: {
    calculate() {
      const promedio = (this.nota1 * 0.35) + (this.nota2 * 0.35) + (this.nota3 * 0.30);
      if (promedio >= 40 && this.asistencia >= 80) {
        this.passed = true;
        this.message = `Aprobado con promedio de ${promedio.toFixed(2)} y asistencia de ${this.asistencia}%`;
      } else {
        this.passed = false;
        this.message = `Reprobado con promedio de ${promedio.toFixed(2)} y asistencia de ${this.asistencia}%`;
      }
    }
  }
}
</script>
