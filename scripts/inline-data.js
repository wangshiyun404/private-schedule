// 把 schedule.json 内嵌进每个 HTML（随后整页加密），并删除明文数据文件
const fs = require('fs'), path = require('path');
const pub = path.join(__dirname, '..', 'public');
const dataFile = path.join(pub, 'data', 'schedule.json');
const json = fs.readFileSync(dataFile, 'utf8');
const shim = `<meta name="robots" content="noindex,nofollow"><script>window.__SCHEDULE__=${json.replace(/</g, '\\u003c')};(function(){var f=window.fetch.bind(window);window.fetch=function(u,o){if(typeof u==='string'&&u.indexOf('data/schedule.json')!==-1){return Promise.resolve(new Response(JSON.stringify(window.__SCHEDULE__),{headers:{'Content-Type':'application/json'}}));}return f(u,o);};})();</script>`;
for (const f of fs.readdirSync(pub).filter(f => f.endsWith('.html'))) {
  const p = path.join(pub, f);
  let h = fs.readFileSync(p, 'utf8');
  h = h.includes('<head>') ? h.replace('<head>', '<head>' + shim) : shim + h;
  fs.writeFileSync(p, h);
}
fs.rmSync(path.join(pub, 'data'), { recursive: true, force: true });
fs.writeFileSync(path.join(pub, 'robots.txt'), 'User-agent: *\nDisallow: /\n');
console.log('inlined into html, data/ removed');
