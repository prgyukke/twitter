<?php

namespace App\Services;

use Abraham\TwitterOAuth\TwitterOAuth;

class TwitterService
{
    public function __construct()
    {
        $this->connection = new TwitterOAuth(
            config('twitter.consumer_key'),
            config('twitter.consumer_secret'),
            config('twitter.access_token'),
            config('twitter.access_token_secret')
        );
    }

    public function search($keyword, $sinceId = null)
    {
        $query = "$keyword exclude:retweets filter:images";
        if ($sinceId) $query .= " since_id:$sinceId";

        $params = [
            "q"                => $query,
            "result_type"      => "recent",
            "include_entities" => true,
            "tweet_mode"       => "extended",
            "count"            => 5,
        ];
        $tweets = $this->connection->get('search/tweets', $params)->statuses;

        return $tweets;
    }

    public function formatTweets($tweets)
    {
        $formattedTweets = [];
        foreach ($tweets as $tweet) {
            $formattedTweets[] = [
                "id"         => $tweet->id,
                "text"       => $tweet->full_text,
                "image"      => $tweet->entities->media[0]->media_url,
                "user_name"  => $tweet->user->name,
                "user_image" => $tweet->user->profile_image_url,
            ];
        }

        return $formattedTweets;
    }
}
