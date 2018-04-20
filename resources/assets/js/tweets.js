require('./bootstrap');

window.Vue = require('vue');
window.axios = require('axios')

Vue.component('searchtweets-component', require('./components/SearchTweetsComponent.vue'));

const tweets = new Vue({
    el: '#tweets'
});
