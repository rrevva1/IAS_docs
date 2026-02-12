<template>
  <div class="card">
    <div class="page-header">
      <h1 class="page-title">Пользователи</h1>
      <div>
        <button class="btn outline" @click="openLegacyIndex">
          Старый вид
        </button>
        <button class="btn primary" @click="openLegacyCreate">
          <i class="fas fa-user-plus"></i>
          Добавить пользователя
        </button>
        <button class="btn outline" @click="loadUsers">
          <i class="fas fa-sync"></i>
          Обновить
        </button>
      </div>
    </div>

    <div v-if="error" class="notice">{{ error }}</div>

    <ag-grid-vue
      class="ag-theme-quartz"
      :columnDefs="columnDefs"
      :rowData="rowData"
      :pagination="true"
      :paginationPageSize="25"
      :animateRows="true"
      @rowDoubleClicked="openLegacyView"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { AgGridVue } from 'ag-grid-vue3';
import api from '../api/client';

const rowData = ref([]);
const error = ref('');

const columnDefs = [
  { field: 'id', headerName: 'ID', width: 90 },
  { field: 'full_name', headerName: 'ФИО', minWidth: 200 },
  { field: 'email', headerName: 'Email', minWidth: 220 },
  { field: 'role_name', headerName: 'Роль', minWidth: 160 },
];

const loadUsers = async () => {
  error.value = '';
  try {
    const { data } = await api.get('/users');
    rowData.value = data.data || [];
  } catch (err) {
    error.value = 'Не удалось загрузить список пользователей.';
  }
};

const openLegacyCreate = () => {
  window.open('/users/create', '_blank');
};

const openLegacyView = (event) => {
  if (event?.data?.id) {
    window.open(`/users/view?id=${event.data.id}`, '_blank');
  }
};

const openLegacyIndex = () => {
  window.open('/users/index', '_blank');
};

onMounted(loadUsers);
</script>
