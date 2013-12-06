var flatiron = require('flatiron'),
    app = flatiron.app,
    exec = require('child_process').exec;

app.use(flatiron.plugins.http);

app.router.path('/', function () {

  this.post(function () {
    repo = this.req.body.repository.url.match(/\:(.*)\.git/)[1];
    name = this.req.body.repository.name;
    console.log('Deploying: '+name);
    exec('bash repos/'+name+'.sh',function (error, stdout, stderr) {
      console.log('stdout: ' + stdout);
      console.log('stderr: ' + stderr);
      if (error !== null) {
        console.log('exec error: ' + error);
      }
    });
    this.res.end();
  });
});

app.start(9001, function (err) {
  if (err) {
    throw err;
  }

  var addr = app.server.address();
  app.log.info('Listening on http://' + addr.address + ':' + addr.port);
});
