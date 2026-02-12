<template>
  <div class="card">
    <div class="page-header">
      <h1 class="page-title">Статистика заявок</h1>
      <div>
        <button class="btn outline" @click="openLegacy">Старый вид</button>
        <button class="btn outline" @click="loadStats">
          <i class="fas fa-sync"></i>
          Обновить
        </button>
      </div>
    </div>

    <div v-if="error" class="notice">{{ error }}</div>

    <div v-if="stats">
      <h3>По статусам</h3>
      <table class="table">
        <thead>
          <tr>
            <th>Статус</th>
            <th>Количество</th>
            <th>Доля</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="row in stats.statuses" :key="row.status_id">
            <td>{{ row.status_name }}</td>
            <td>{{ row.count }}</td>
            <td>{{ row.percentage }}%</td>
          </tr>
        </tbody>
      </table>

      <h3>Заявки по авторам</h3>
      <table class="table">
        <thead>
          <tr>
            <th>Пользователь</th>
            <th>Количество</th>
            <th>Доля</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="row in stats.byUsers" :key="row.name">
            <td>{{ row.name }}</td>
            <td>{{ row.count }}</td>
            <td>{{ row.percentage }}%</td>
          </tr>
        </tbody>
      </table>

      <h3>Выполненные заявки по исполнителям</h3>
      <table class="table">
        <thead>
          <tr>
            <th>Исполнитель</th>
            <th>Количество</th>
            <th>Доля</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="row in stats.byExecutors" :key="row.name">
            <td>{{ row.name }}</td>
            <td>{{ row.count }}</td>
            <td>{{ row.percentage }}%</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import api from '../api/client';

const stats = ref(null);
const error = ref('');

const loadStats = async () => {
  error.value = '';
  try {
    const { data } = await api.get('/stats/tasks');
    stats.value = data.data;
  } catch (err) {
    error.value = 'Не удалось загрузить статистику.';
  }
};

onMounted(loadStats);

const openLegacy = () => {
  window.open('/tasks/statistics', '_blank');
};
</script>
