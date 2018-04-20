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

    public function search(Request $request)
    {
        $rawTweets       = $this->twitterService->search($request['keyword'], $request['sinceId']);
        $formattedTweets = $this->twitterService->formatTweets($rawTweets);

        return response()->json($formattedTweets);
    }
}