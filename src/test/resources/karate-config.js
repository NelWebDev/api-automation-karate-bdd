function fn() {
  var env = karate.env || 'dev';

  var config = {
    env: env,
    baseUrl: 'https://restful-booker.herokuapp.com'
  };

  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);

  return config;
}
