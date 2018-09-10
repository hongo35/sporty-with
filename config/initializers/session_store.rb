# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_sporty-with_session', expire_after: 2.year, secure: Rails.env.production?
