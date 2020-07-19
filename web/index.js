var memory;
var instance;

fetch('./compiler-web.wasm').then(response =>
  response.arrayBuffer()
).then(bytes => WebAssembly.instantiate(bytes, {
  env: {
    print: function print(byteOffset) {
      var s = '';
      var a = new Uint8Array(memory.buffer);
      for (var i = byteOffset; a[i]; i++) {
        s += String.fromCharCode(a[i]);
      }
      document.write(s);
    }
  }
})
).then(results => {
  instance = results.instance;
  memory = instance.exports.pagememory;
  instance.exports.out();
}).catch(console.error);
