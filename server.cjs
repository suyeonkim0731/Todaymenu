'use strict';
const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const files = new Map([
  ['/', ['index.html', 'text/html; charset=utf-8']],
  ['/index.html', ['index.html', 'text/html; charset=utf-8']],
  ['/menu.json', ['menu.json', 'application/json; charset=utf-8']]
]);
const server = http.createServer((request, response) => {
  const file = files.get(new URL(request.url, 'http://localhost').pathname);
  if (!file) { response.writeHead(404); response.end('Not found'); return; }
  fs.readFile(path.join(__dirname, file[0]), (error, content) => {
    if (error) { response.writeHead(500); response.end('Unable to read file'); return; }
    response.writeHead(200, {'Content-Type': file[1], 'Cache-Control': 'no-cache'});
    response.end(content);
  });
});
server.on('error', error => { console.error(error.message); process.exitCode = 1; });
server.listen(8080, '127.0.0.1', () => console.log('http://localhost:8080/'));
