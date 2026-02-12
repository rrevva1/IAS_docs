<template>
  <div class="card">
    <div class="page-header">
      <h1 class="page-title">Мой профиль</h1>
      <div>
        <button class="btn outline" @click="openLegacy">Старый вид</button>
        <button class="btn outline" @click="loadProfile">Обновить</button>
      </div>
    </div>

    <div v-if="error" class="notice">{{ error }}</div>

    <div v-if="profile" class="form-grid">
      <div class="form-field">
        <label>ФИО</label>
        <div>{{ profile.full_name }}</div>
      </div>
      <div class="form-field">
        <label>Email</label>
        <div>{{ profile.email }}</div>
      </div>
      <div class="form-field">
        <label>Роли</label>
        <div>{{ profile.roles }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '../api/client';

const profile = ref(null);
const error = ref('');
const appContext = window.__APP_CONTEXT__ || {};
const userId = appContext?.user?.id;

const loadProfile = async () => {
  error.value = '';
  try {
    const { data } = await api.get('/meta/me');
    profile.value = data.data;
  } catch (err) {
    error.value = 'Не удалось загрузить профиль.';
  }
};

onMounted(loadProfile);

const openLegacy = () => {
  if (userId) {
    window.open(`/users/view?id=${userId}`, '_blank');
  }
};
</script>
