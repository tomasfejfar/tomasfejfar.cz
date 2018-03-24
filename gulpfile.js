var gulp = require('gulp');
var watch = require('gulp-watch');
var gulputil = require('gulp-util');
var path = require('path');
var exec = require('child_process').exec;
var notify = require("gulp-notify");
var os = require('os');
var notifier = require('node-notifier');

var notify = function (message) {
    notifier.notify({
        title: "Gulp",
        message: message + "\n" + (new Date()).toLocaleTimeString(),
        wait: false, // Wait for User Action against Notification or times out. Same as timeout = 5 seconds
        timeout: 1
    });
};

gulp.task('default', function () {
    // Generate current version
    notify('Build started');
    exec(path.normalize('vendor/bin/statie generate source'), function (err, stdout, stderr) {
        gulputil.log(stdout);
        gulputil.log(stderr);
    });

    // Run local server, open localhost:8000 in your browser
    exec('php -S 0.0.0.0:8000 -t output');

    gulputil.log('Server is ready at http://localhost:8000');
    notify('Server ready');

    gulp.watch(
        // For the second arg see: https://github.com/floatdrop/gulp-watch/issues/242#issuecomment-230209702
        ['source/**/*', 'statie.yml', '!**/*___jb_tmp___'],
        { ignoreInitial: false },
        function() {
		    exec(path.normalize('vendor/bin/statie generate source  --no-ansi'), function (err, stdout, stderr) {
                gulputil.log(stdout);
                gulputil.log(stderr);
                if (stderr||stdout) {
                    notify(stdout + "\n" + stderr);
                }
            });
        }
    );
});
