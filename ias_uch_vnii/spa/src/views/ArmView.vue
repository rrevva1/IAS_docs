<template>
  <div class="card">
    <div class="page-header">
      <h1 class="page-title">Учет технических средств</h1>
      <div>
        <button class="btn outline" @click="openLegacy">Старый вид</button>
        <button class="btn outline" @click="loadData">
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
  { field: 'user_name', headerName: 'Пользователь', minWidth: 160 },
  { field: 'location_name', headerName: 'Помещение', minWidth: 140 },
  { field: 'cpu', headerName: 'ЦП', minWidth: 120 },
  { field: 'ram', headerName: 'ОЗУ', minWidth: 100 },
  { field: 'disk', headerName: 'Диск', minWidth: 120 },
  { field: 'system_block', headerName: 'Системный блок', minWidth: 160 },
  { field: 'inventory_number', headerName: 'Инв. №', minWidth: 120 },
  { field: 'monitor', headerName: 'Монитор', minWidth: 140 },
  { field: 'hostname', headerName: 'Имя ПК', minWidth: 140 },
  { field: 'ip', headerName: 'IP', minWidth: 120 },
  { field: 'os', headerName: 'ОС', minWidth: 140 },
  { field: 'other_tech', headerName: 'ДР техника', minWidth: 160 },
];

const loadData = async () => {
  error.value = '';
  try {
    const { data } = await api.get('/arm');
    rowData.value = data.data || [];
  } catch (err) {
    error.value = 'Не удалось загрузить данные учета ТС.';
  }
};

onMounted(loadData);

const openLegacy = () => {
  window.open('/arm/index', '_blank');
};
</script>
