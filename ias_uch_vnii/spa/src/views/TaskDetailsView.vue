<template>
  <div class="card">
    <div class="page-header">
      <h1 class="page-title">Заявка #{{ task?.id }}</h1>
      <div>
        <button class="btn outline" @click="openLegacy">Старый вид</button>
        <button class="btn outline" @click="goBack">Назад</button>
        <button class="btn primary" @click="editTask">Редактировать</button>
      </div>
    </div>

    <div v-if="error" class="notice">{{ error }}</div>
    <div v-if="loading">Загрузка...</div>

    <div v-if="task" class="form-grid">
      <div class="form-field">
        <label>Описание</label>
        <div>{{ task.description }}</div>
      </div>
      <div class="form-field">
        <label>Статус</label>
        <select v-model="form.status_id">
          <option v-for="status in options.statuses" :key="status.id" :value="status.id">
            {{ status.name }}
          </option>
        </select>
      </div>
      <div class="form-field" v-if="isAdmin && options.executors.length">
        <label>Исполнитель</label>
        <select v-model="form.executor_id">
          <option value="">—</option>
          <option v-for="user in options.executors" :key="user.id" :value="user.id">
            {{ user.name }}
          </option>
        </select>
      </div>
      <div class="form-field">
        <label>Автор</label>
        <div>{{ task.user_name }}</div>
      </div>
      <div class="form-field">
        <label>Исполнитель</label>
        <div>{{ task.executor_name || '—' }}</div>
      </div>
      <div class="form-field">
        <label>Комментарий</label>
        <textarea v-model="form.comment" rows="3"></textarea>
      </div>
      <div class="form-field">
        <label>Создано</label>
        <div>{{ task.date }}</div>
      </div>
      <div class="form-field">
        <label>Обновлено</label>
        <div>{{ task.last_time_update }}</div>
      </div>
      <div>
        <button class="btn primary" @click="saveUpdates" :disabled="saving">
          {{ saving ? 'Сохранение...' : 'Сохранить изменения' }}
        </button>
      </div>
      <div class="form-field" v-if="task.attachments?.length">
        <label>Вложения</label>
        <ul>
          <li v-for="file in task.attachments" :key="file.id">
            <span>
              <i class="fas" :class="file.icon"></i>
              <a :href="file.preview_url" target="_blank" rel="noopener">
                {{ file.name }}
              </a>
            </span>
            <button v-if="isAdmin" class="btn outline" @click="removeAttachment(file)">
              Удалить
            </button>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import api from '../api/client';

const route = useRoute();
const router = useRouter();
const task = ref(null);
const error = ref('');
const loading = ref(true);
const saving = ref(false);

const appContext = window.__APP_CONTEXT__ || {};
const isAdmin = Boolean(appContext?.user?.isAdministrator);

const options = ref({
  statuses: [],
  executors: [],
});

const form = ref({
  status_id: '',
  executor_id: '',
  comment: '',
});

const loadTask = async () => {
  error.value = '';
  loading.value = true;
  try {
    const { data } = await api.get(`/tasks/${route.params.id}`);
    task.value = data.data;
    form.value.status_id = task.value.status_id;
    form.value.executor_id = task.value.executor_id || '';
    form.value.comment = task.value.comment || '';
  } catch (err) {
    error.value = 'Не удалось загрузить заявку.';
  } finally {
    loading.value = false;
  }
};

const loadOptions = async () => {
  try {
    const { data } = await api.get('/tasks/options');
    options.value = data.data || { statuses: [], executors: [] };
  } catch (err) {
    error.value = 'Не удалось загрузить справочники.';
  }
};

const saveUpdates = async () => {
  error.value = '';
  saving.value = true;
  try {
    const payload = new FormData();
    payload.append('status_id', form.value.status_id);
    payload.append('executor_id', form.value.executor_id || '');
    payload.append('comment', form.value.comment || '');
    await api.post(`/tasks/${route.params.id}/update`, payload);
    await loadTask();
  } catch (err) {
    error.value = 'Не удалось сохранить изменения.';
  } finally {
    saving.value = false;
  }
};

const removeAttachment = async (file) => {
  if (!confirm(`Удалить вложение "${file.name}"?`)) {
    return;
  }
  try {
    const payload = new FormData();
    payload.append('attachment_id', file.id);
    await api.post(`/tasks/${route.params.id}/delete-attachment`, payload);
    await loadTask();
  } catch (err) {
    error.value = 'Не удалось удалить вложение.';
  }
};

const editTask = () => {
  router.push(`/tasks/${route.params.id}/edit`);
};

const goBack = () => {
  router.push('/tasks');
};

const openLegacy = () => {
  window.open(`/tasks/view?id=${route.params.id}`, '_blank');
};

onMounted(async () => {
  await loadOptions();
  await loadTask();
});
</script>
