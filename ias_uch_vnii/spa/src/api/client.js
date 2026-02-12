import axios from 'axios';

const appContext = window.__APP_CONTEXT__ || {};

const client = axios.create({
  baseURL: '/api',
  withCredentials: true,
  headers: {
    'X-Requested-With': 'XMLHttpRequest',
  },
});

if (appContext.csrfToken) {
  client.defaults.headers.common['X-CSRF-Token'] = appContext.csrfToken;
}

export default client;
