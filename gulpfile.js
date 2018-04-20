var gulp    = require( 'gulp' );

var stylus  = require( 'gulp-stylus' );
var plumber = require( 'gulp-plumber' );
var csscomb = require( 'gulp-csscomb' );

//stylusコンパイル
gulp.task( 'stylus', function() {
    return gulp.src( 'resources/assets/stylus/**/*.styl' )
        .pipe( plumber() )
        .pipe( stylus() )
        .pipe( csscomb() )
        .pipe( gulp.dest('public/css') )
} );

//gulp にてstylusを監視し、更新があれば上記タスクを実行
gulp.task( 'default', function() {
    gulp.watch( 'resources/assets/stylus/**/*.styl', [ 'stylus' ] )
} );