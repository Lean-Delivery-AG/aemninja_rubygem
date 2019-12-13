Aemninja.configure do |config|
  config.instances = {
    author: { host: "localhost:4502", user: "admin", password: "admin"},
    publish: { host: "localhost:4503", user: "admin", password: "admin"}
  }
end
