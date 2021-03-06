# frozen_string_literal: true

require "secure_headers"

SecureHeaders::Configuration.default do |config|
  config.x_frame_options = "DENY"

  # rubocop:disable Lint/PercentStringArray
  config.csp = {
    default_src: %w['none'],
    img_src: %w['self' data: my.buckybox.com *.google-analytics.com *.pingdom.net notify.bugsnag.com *.tile.openstreetmap.org],
    script_src: %w['self' 'unsafe-inline' *.google-analytics.com *.pingdom.net https://d2wy8f7a9ursnm.cloudfront.net/bugsnag-3.min.js],
    style_src: %w['self' 'unsafe-inline'],
    form_action: %w['self' www.paypal.com],
    connect_src: %w['self' api.buckybox.com *.google-analytics.com],
    report_uri: %w[https://api.buckybox.com/v1/csp-report],
  }

  config.csp[:img_src] << "http://my.buckybox.local:3000" if Rails.env.development?

  # config.hpkp = {
  # TODO: set up HPKP
  # }
  # rubocop:enable Lint/PercentStringArray
end
