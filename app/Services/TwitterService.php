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

    public function search($keyword)
    {
        $params = [
            "q"                => "$keyword",
            "result_type"      => "recent",
            "include_entities" => true,
            "tweet_mode"       => "extended",
        ];
        $tweets = $this->connection->get('search/tweets', $params)->statuses;

        return $tweets;
    }

    public function extractMediaTweets($tweets)
    {
        $extractedTweets = [];
        foreach ($tweets as $tweet) {
            if (!isset($tweet->entities->media)) continue;
            $extractedTweets[] = $tweet;
        }

        return $extractedTweets;
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
