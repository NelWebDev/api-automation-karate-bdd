function fn() {
  var env = karate.env || 'dev';

  var config = {
    env: env,
    baseUrl: 'https://restful-booker.herokuapp.com'
  };

  karate.configure('connectTimeout', 10000);
  karate.configure('readTimeout', 10000);

  return config;
}
