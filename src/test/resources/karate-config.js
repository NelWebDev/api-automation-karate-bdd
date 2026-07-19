function fn() {
  var env = karate.env || 'dev';

  var urls = {
    dev: 'https://restful-booker.herokuapp.com'
  };

  if (!urls[env] && !karate.properties['baseUrl']) {
    throw new Error('Unsupported karate.env: ' + env);
  }

  var config = {
    env: env,
    baseUrl: karate.properties['baseUrl'] || urls[env]
  };

  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 10000);
  karate.configure('ssl', true);

  return config;
}
