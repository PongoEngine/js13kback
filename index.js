const watch = require('node-watch');
const haxe = require('haxe').haxe;


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

    watch('./dist/index.js', { recursive: false }, function (event, filename) {
        if(event === "update") {
            bSync.reload();
        }
    });
}