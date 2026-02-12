<template>
  <div class="card">
    <div class="page-header">
      <h1 class="page-title">{{ isEdit ? 'Редактирование заявки' : 'Создание заявки' }}</h1>
      <div>
        <button class="btn outline" @click="openLegacy">Старый вид</button>
        <button class="btn outline" @click="goBack">Назад</button>
      </div>
    </div>

    <div v-if="error" class="notice">{{ error }}</div>

    <form class="form-grid" @submit.prevent="submitForm">
      <div class="form-field">
        <label for="description">Описание</label>
        <textarea id="description" v-model="form.description" rows="4" required></textarea>
      </div>

      <div class="form-field">
        <label for="status">Статус</label>
        <select id="status" v-model="form.status_id" required>
          <option v-for="status in options.statuses" :key="status.id" :value="status.id">
            {{ status.name }}
          </option>
        </select>
      </div>

      <div class="form-field" v-if="options.executors.length">
        <label for="executor">Исполнитель</label>
        <select id="executor" v-model="form.executor_id">
          <option value="">—</option>
          <option v-for="user in options.executors" :key="user.id" :value="user.id">
            {{ user.name }}
          </option>
        </select>
      </div>

      <div class="form-field">
        <label for="comment">Комментарий</label>
        <textarea id="comment" v-model="form.comment" rows="3"></textarea>
      </div>

      <div class="form-field" v-if="!isEdit">
        <label for="files">Вложения</label>
        <input id="files" type="file" multiple @change="onFilesChange" />
      </div>

      <div>
        <button class="btn primary" type="submit" :disabled="submitting">
          {{ submitting ? 'Сохранение...' : 'Сохранить' }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import api from '../api/client';

const route = useRoute();
const router = useRouter();
const isEdit = computed(() => Boolean(route.params.id));
const submitting = ref(false);
const error = ref('');

const form = ref({
  description: '',
  status_id: '',
  executor_id: '',
  comment: '',
});

const files = ref([]);

const options = ref({
  statuses: [],
  executors: [],
});

const loadOptions = async () => {
  try {
    const { data } = await api.get('/tasks/options');
    options.value = data.data || { statuses: [], executors: [] };
    if (!form.value.status_id && options.value.statuses.length) {
      form.value.status_id = options.value.statuses[0].id;
    }
  } catch (err) {
    error.value = 'Не удалось загрузить справочники.';
  }
};

const loadTask = async () => {
  if (!isEdit.value) return;
  try {
    const { data } = await api.get(`/tasks/${route.params.id}`);
    const task = data.data;
    form.value.description = task.description;
    form.value.status_id = task.status_id;
    form.value.executor_id = task.executor_id || '';
    form.value.comment = task.comment || '';
  } catch (err) {
    error.value = 'Не удалось загрузить заявку.';
  }
};

const onFilesChange = (event) => {
  files.value = Array.from(event.target.files || []);
};

const submitForm = async () => {
  error.value = '';
  submitting.value = true;
  try {
    const payload = new FormData();
    payload.append('description', form.value.description);
    payload.append('status_id', form.value.status_id);
    if (form.value.executor_id) {
      payload.append('executor_id', form.value.executor_id);
    }
    if (form.value.comment) {
      payload.append('comment', form.value.comment);
    }
    if (!isEdit.value) {
      files.value.forEach((file) => {
        payload.append('uploadFiles[]', file);
      });
    }

    if (isEdit.value) {
      await api.post(`/tasks/${route.params.id}/update`, payload);
    } else {
      await api.post('/tasks', payload);
    }

    router.push('/tasks');
  } catch (err) {
    error.value = 'Не удалось сохранить заявку.';
  } finally {
    submitting.value = false;
  }
};

const goBack = () => {
  router.push('/tasks');
};

const openLegacy = () => {
  if (isEdit.value) {
    window.open(`/tasks/update?id=${route.params.id}`, '_blank');
  } else {
    window.open('/tasks/create', '_blank');
  }
};

onMounted(async () => {
  await loadOptions();
  await loadTask();
});
</script>
