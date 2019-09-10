const watch = require('node-watch');
const haxe = require('haxe').haxe;
const browserSync = require("browser-sync");


console.log('\x1b[36m%s\x1b[0m', '[Haxe] Building project');
var cmd = haxe( "build.hxml");
cmd.stdout.on('close', () => {
    createWatcher();
});

    


function createWatcher() {
    console.log('\x1b[36m%s\x1b[0m', '[Proj] Created Watcher');
    const bSync = require("browser-sync").create();
    bSync.init({
        server: "./dist",
        open: false
    });

    haxe("--wait", "6221");

    watch('./src', { recursive: true }, function (event, filename) {
        if(event === "update") {
            console.log('\x1b[36m%s\x1b[0m', '[Haxe] Building project');
            var cmd = haxe( "build.hxml");
            cmd.stdout.on('close', () => {
                bSync.reload();
            });
        }
    });
}