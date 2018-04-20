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
                windowHeight : window.innerHeight,
                windowWidth : window.innerWidth,
            }
        },
        methods : {
            randomTop : function(){
                return Math.floor(Math.random() * (this.windowHeight + 1 - 350));
            },
            randomLeft : function(){
                return Math.floor(Math.random() * (this.windowWidth + 1 - 350));
            },
            setRandomPosition : function(){
                return 'left: ' + this.randomLeft() + 'px; top: ' + this.randomTop() + 'px;';
            },
            getTweets() {
                axios.get('http://192.168.33.101/api/search/' + this.keyword).then(
                    res => {
                        res.data.forEach(function(value,index){
                            setTimeout(function() {
                                this.tweets.push({
                                    position : this.setRandomPosition(),
                                    image : value.image,
                                    text : value.text,
                                });
                            }.bind(this), 1000 * index);
                        }.bind(this));
                    }
                );
            },
        }
    }
</script>
