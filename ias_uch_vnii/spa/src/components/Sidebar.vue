<template>
  <aside class="app-sidebar">
    <div class="app-sidebar__header">
      <span>{{ appName }}</span>
    </div>
    <nav class="app-sidebar__nav">
      <RouterLink class="app-sidebar__item" :class="{ 'is-active': isActive('/tasks') }" to="/tasks">
        <i class="fas fa-folder-open"></i>
        <span>Заявки</span>
      </RouterLink>
      <RouterLink class="app-sidebar__item" :class="{ 'is-active': isActive('/statistics') }" to="/statistics">
        <i class="fas fa-chart-bar"></i>
        <span>Статистика заявок</span>
      </RouterLink>
      <RouterLink
        class="app-sidebar__item"
        :class="{ 'is-active': isActive('/arm') }"
        to="/arm"
      >
        <i class="fas fa-desktop"></i>
        <span>Учет ТС</span>
      </RouterLink>
      <RouterLink
        class="app-sidebar__item"
        :class="{ 'is-active': isActive('/users') }"
        to="/users"
      >
        <i class="fas fa-users"></i>
        <span>Пользователи</span>
      </RouterLink>
      <RouterLink class="app-sidebar__item" :class="{ 'is-active': isActive('/profile') }" to="/profile">
        <i class="fas fa-user"></i>
        <span>Мой профиль</span>
      </RouterLink>
    </nav>
    <div class="app-sidebar__footer">
      <button class="btn outline" @click="logout">
        <i class="fas fa-sign-out-alt"></i>
        Выйти
      </button>
    </div>
  </aside>
</template>

<script setup>
import { useRoute } from 'vue-router';

const route = useRoute();
const appContext = window.__APP_CONTEXT__ || {};

const appName = appContext.appName || 'IAS UCH VNII';

const isActive = (pathPrefix) => route.path.startsWith(pathPrefix);

const logout = () => {
  const form = document.createElement('form');
  form.method = 'POST';
  form.action = '/site/logout';
  const csrf = appContext.csrfToken;
  if (csrf) {
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = '_csrf';
    input.value = csrf;
    form.appendChild(input);
  }
  document.body.appendChild(form);
  form.submit();
};
</script>
