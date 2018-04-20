require('./bootstrap');

window.Vue = require('vue');

Vue.component('searchtweets-component', require('./components/SearchTweetsComponent.vue'));

const tweets = new Vue({
    el: '#tweets'
});
