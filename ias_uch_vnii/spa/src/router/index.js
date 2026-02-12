import { createRouter, createWebHistory } from 'vue-router';
import TasksView from '../views/TasksView.vue';
import TaskFormView from '../views/TaskFormView.vue';
import TaskDetailsView from '../views/TaskDetailsView.vue';
import ArmView from '../views/ArmView.vue';
import UsersView from '../views/UsersView.vue';
import StatisticsView from '../views/StatisticsView.vue';
import ProfileView from '../views/ProfileView.vue';

const appContext = window.__APP_CONTEXT__ || {};
const isAdmin = Boolean(appContext?.user?.isAdministrator);

const routes = [
  {
    path: '/',
    redirect: () => (isAdmin ? '/tasks' : '/profile'),
  },
  { path: '/tasks', component: TasksView },
  { path: '/tasks/new', component: TaskFormView },
  { path: '/tasks/:id', component: TaskDetailsView, props: true },
  { path: '/tasks/:id/edit', component: TaskFormView, props: true },
  { path: '/statistics', component: StatisticsView },
  { path: '/arm', component: ArmView },
  { path: '/users', component: UsersView },
  { path: '/profile', component: ProfileView },
];

const router = createRouter({
  history: createWebHistory('/spa/'),
  routes,
});

router.beforeEach((to) => {
  if (to.meta.requiresAdmin && !isAdmin) {
    return '/profile';
  }
  return true;
});

export default router;
