def send_mail(digests)
  text_digest = digests[:text_digest]
  html_digest = digests[:html_digest]

  # Extract to sendgrid_setup
  server_settings = { address: SMTP_SERVER,
                      port: SERVER_PORT,
                      user_name: EMAIL_USERNAME,
                      password: EMAIL_PASSWORD,
                      authentication: SERVER_AUTH,
                      domain: SERVER_DOMAIN }


  if Pony.mail(to: EMAIL_TO,
               from: EMAIL_FROM,
               via: :smtp,
               via_options: server_settings,
               subject: "#{SUBJECT_PREFIX} - #{Time.now.strftime('%m-%d-%Y')}",
               html_body: html_digest,
               body: text_digest)
    puts "Digest sent..."
  end
end
