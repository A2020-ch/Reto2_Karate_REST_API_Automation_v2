function fn() {
  var config = {
    baseUrl: karate.properties['octoperf.baseUrl'] || 'https://api.octoperf.com',
    octoperfUsername: java.lang.System.getenv('OCTOPERF_USERNAME'),
    octoperfPassword: java.lang.System.getenv('OCTOPERF_PASSWORD')
  };

  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 10000);
  return config;
}
