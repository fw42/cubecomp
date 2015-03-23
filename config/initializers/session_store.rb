# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, {
  key: '_cubecomp_session',
  secure: !Rails.env.development?,
  expire_after: 1.month,
  httponly: true
}
