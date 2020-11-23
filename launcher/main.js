const {
    app,
    BrowserWindow
} = require('electron');
const ipc = require('electron').ipcMain

if (handleSquirrelEvent(app)) {
    return;
}

const nativeImage = require('electron').nativeImage;
var image = nativeImage.createFromPath(__dirname + '/icon.ico');

const path = require('path');
const {
    timeStamp
} = require('console');

let mainWindow

function createWindow() {
    mainWindow = new BrowserWindow({
        width: 1300,
        height: 800,
        icon: image,
        resizable: false,
        webPreferences: {
            preload: path.join(__dirname, 'preload.js')
        }
    })

    mainWindow.setMenuBarVisibility(false)

    mainWindow.webContents.on('new-window', function (e, url) {
        e.preventDefault();
        require('electron').shell.openExternal(url);
    });

    mainWindow.webContents.on("devtools-opened", () => { mainWindow.webContents.closeDevTools(); });

    mainWindow.loadFile('index.html')

    mainWindow.on('closed', function () {
        mainWindow = null
    })
    
}