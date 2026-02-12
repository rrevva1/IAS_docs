<template>
  <div class="card">
    <div class="page-header">
      <h1 class="page-title">Заявки</h1>
      <div>
        <button class="btn outline" @click="openLegacy">
          Старый вид
        </button>
        <button class="btn primary" @click="createTask">
          <i class="fas fa-plus"></i>
          Создать
        </button>
        <button class="btn outline" @click="loadTasks" :disabled="loading">
          <i class="fas fa-sync" :class="{ 'fa-spin': loading }"></i>
          Обновить
        </button>
        <button class="btn outline" @click="exportCsv">
          <i class="fas fa-file-csv"></i>
          CSV
        </button>
      </div>
    </div>

    <div v-if="error" class="notice">{{ error }}</div>

    <div class="grid-wrapper">
      <ag-grid-vue
        class="ag-theme-quartz"
        :columnDefs="columnDefs"
        :rowData="rowData"
        :pagination="true"
        :paginationPageSize="25"
        :animateRows="true"
        overlayNoRowsTemplate='<span class="ag-overlay-no-rows-center">Нет заявок</span>'
        overlayLoadingTemplate='<span class="ag-overlay-loading-center">Загрузка…</span>'
        @grid-ready="onGridReady"
        @rowDoubleClicked="openTask"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { AgGridVue } from 'ag-grid-vue3';
import api from '../api/client';

const router = useRouter();
const rowData = ref([]);
const error = ref('');
const loading = ref(false);
const gridApi = ref(null);

const columnDefs = [
  { field: 'id', headerName: 'ID', width: 90 },
  { field: 'description', headerName: 'Описание', flex: 2, minWidth: 260 },
  { field: 'status_name', headerName: 'Статус', minWidth: 140 },
  { field: 'user_name', headerName: 'Автор', minWidth: 160 },
  { field: 'executor_name', headerName: 'Исполнитель', minWidth: 160 },
  { field: 'date', headerName: 'Создано', minWidth: 160 },
  { field: 'last_time_update', headerName: 'Обновлено', minWidth: 160 },
];

const loadTasks = async () => {
  error.value = '';
  loading.value = true;
  showGridLoading(true);
  try {
    const { data } = await api.get('/tasks');
    rowData.value = (data && data.data) ? data.data : [];
  } catch (err) {
    error.value = err?.response?.data?.message || 'Не удалось загрузить список заявок.';
    rowData.value = [];
  } finally {
    loading.value = false;
    showGridLoading(false);
  }
};

const openTask = (event) => {
  if (event?.data?.id) {
    router.push(`/tasks/${event.data.id}`);
  }
};

const createTask = () => {
  router.push('/tasks/new');
};

const onGridReady = (params) => {
  gridApi.value = params.api;
};

const showGridLoading = (show) => {
  if (gridApi.value) {
    show ? gridApi.value.showLoadingOverlay() : gridApi.value.hideOverlay();
  }
};

const exportCsv = () => {
  if (gridApi.value) {
    gridApi.value.exportDataAsCsv({ fileName: 'tasks.csv' });
  }
};

const openLegacy = () => {
  window.open('/tasks/index', '_blank');
};

onMounted(loadTasks);
</script>
