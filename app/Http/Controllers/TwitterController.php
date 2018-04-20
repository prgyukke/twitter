<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class TwitterController extends Controller
{
    public function search($keyword)
    {
        return view('twitter.search', [
            'keyword'   => $keyword,
        ]);
    }
}
