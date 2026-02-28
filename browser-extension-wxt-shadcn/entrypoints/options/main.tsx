import React from 'react';
import ReactDOM from 'react-dom/client';
import { SettingsApp } from './SettingsApp';
import '@/entrypoints/shared/styles.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <SettingsApp />
  </React.StrictMode>,
);