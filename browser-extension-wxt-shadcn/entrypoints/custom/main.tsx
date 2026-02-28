import React from 'react';
import ReactDOM from 'react-dom/client';
import { RandomPage } from './RandomPage';
import '@/entrypoints/shared/styles.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <RandomPage />
  </React.StrictMode>,
);