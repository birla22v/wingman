if Rails.env.production?
  ZeroPush.auth_token = 'ajshdjaksdh'
else
  ZeroPush.auth_token = 'asjdhaksjd'
end

require 'zero_push'

# One time initialization of the auth_token, config/initializers/zero_push.rb for instance
ZeroPush.auth_token = "server-auth-token"

# ZeroPush expects a hash as a notification
notification = {
  device_tokens: ["49c24ca3f1fbb09915655e4fb99879510e7fe8c0836561d1e913fc988a1ae666"],
  alert: "Something really awesome just happened!!",
  sound: "default",
  badge: 1
}

# Send the notification
ZeroPush.notify(notification)
