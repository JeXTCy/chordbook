import './application.scss'

import { createApp } from 'vue'
import { IonicVue } from '@ionic/vue'
import App from './views/App.vue'
import VueAxios from 'vue-axios'
import client from './client'
import store from './store'
import router from './router'
import telemetry from './telemetry'

const app = createApp(App)
  .use(IonicVue)
  .use(VueAxios, client)
  .use(store)
  .use(router)

router.isReady().then(() => {
  telemetry()
  app.mount('[data-behavior=vue]')
})
