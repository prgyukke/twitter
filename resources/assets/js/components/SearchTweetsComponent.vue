<template>
    <ul id="search">
        <li v-for="tweet in tweets" :style='tweet.position'>
            <div class='tweet'>
                <div class='image'><img :src='tweet.image'></div>
                <p>{{tweet.text}}</p>
            </div>
        </li>
    </ul>
</template>

<script>
    export default {
        mounted() {
            this.getTweets()
        },
        props : {
            keyword : {
                type : String,
                default : '検索'
            }
        },
        data : function(){
            return {
                tweets : [],
                sinceId : null,
                windowHeight : window.innerHeight,
                windowWidth : window.innerWidth,
                viewTime : 1500,
                maxTweets : 15,
            }
        },
        methods : {
            randomTop : function(){
                return Math.floor(Math.random() * (this.windowHeight + 1 - 450));
            },
            randomLeft : function(){
                return Math.floor(Math.random() * (this.windowWidth + 1 - 450));
            },
            setRandomPosition : function(){
                return 'left: ' + this.randomLeft() + 'px; top: ' + this.randomTop() + 'px;';
            },
            getTweets() {
                axios.post('http://192.168.33.101/api/search/', {
                    keyword: this.keyword,
                    sinceId: this.sinceId
                }).then(
                    res => {
                        res.data.forEach(function(value,index){
                            if (index == 1) this.sinceId = value.id;
                            setTimeout(function() {
                                this.tweets.push({
                                    position : this.setRandomPosition(),
                                    image : value.image + ":small",
                                    text : value.text,
                                });
                                if (this.tweets.length > this.maxTweets) this.tweets.shift();
                            }.bind(this), this.viewTime * index);
                        }.bind(this));
                    }
                );
                setTimeout(function() {
                    this.getTweets();
                }.bind(this), 20000);
            },
        }
    }
</script>
