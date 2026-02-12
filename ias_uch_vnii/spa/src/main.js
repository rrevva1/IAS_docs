import { createApp } from 'vue';
import { AllCommunityModule, ModuleRegistry } from 'ag-grid-community';
import App from './App.vue';
import router from './router';
import './assets/main.css';
import 'ag-grid-community/styles/ag-grid.css';
import 'ag-grid-community/styles/ag-theme-quartz.css';

ModuleRegistry.registerModules([AllCommunityModule]);

const app = createApp(App);
app.use(router);
app.mount('#app');
