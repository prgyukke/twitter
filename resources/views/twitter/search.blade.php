<!doctype html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>search</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <div id="tweets" class="container">
        <searchtweets-component></searchtweets-component>

        {{ $keyword }}
    </div>
    <script src="/js/tweets.js"></script>
</body>
</html>