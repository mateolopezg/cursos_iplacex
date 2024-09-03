import { createRouter, createWebHistory } from 'vue-router'
import GradeCalculator from '../components/GradeCalculator.vue'
import RegisterForm from '../components/RegisterForm.vue'

const routes = [
  {
    path: '/',
    name: 'GradeCalculator',
    component: GradeCalculator
  },
  {
    path: '/register',
    name: 'RegisterForm',
    component: RegisterForm
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
