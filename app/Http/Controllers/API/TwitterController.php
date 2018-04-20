<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\TwitterService;

class TwitterController extends Controller
{
    private $twitterService;

    public function __construct(TwitterService $twitterService)
    {
        $this->twitterService = $twitterService;
    }

    public function search($keyword)
    {
        $rawTweets       = $this->twitterService->search($keyword);
        $mediaTweets     = $this->twitterService->extractMediaTweets($rawTweets);
        $formattedTweets = $this->twitterService->formatTweets($mediaTweets);

        return response()->json($formattedTweets);
    }
}