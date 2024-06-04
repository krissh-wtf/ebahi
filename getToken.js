// make this a bookmarklet to easily get your token in the console
// or copy and paste it into the console

javascript: (function () {
  let token;
  window.webpackChunkdiscord_app.push([
    [Math.random()],
    {},
    req => {
      if (!req.c) return;
      for (const m of Object.keys(req.c).map(x => req.c[x].exports).filter(x => x)) {
        if (m.default && m.default.getToken !== undefined) {
          token = m.default.getToken();
          break;
        }
        if (m.getToken !== undefined) {
          token = m.getToken();
          break;
        }
      }
    },
  ]);
  console.log('%cWorked!', 'font-size: 50px');
  console.log(`%cToken: ${token}`, 'font-size: 16px');
})();