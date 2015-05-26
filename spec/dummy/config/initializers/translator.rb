if Rails.env.development?
  conn = Mongo::Connection.new.db("translator_test").collection("translations")
  Translator.current_store = Translator::MongoStore.new(conn)
#  Translator.current_store = Translator::RedisStore.new(Redis.new)

  I18n.backend = Translator.setup_backend(I18n::Backend::Simple.new)
end

#Translator.auth_handler = proc {
#  authenticate_or_request_with_http_basic do |user_name, password|
#    user_name == 'some' && password == 'user'
#  end
#}

Translator.auth_handler = proc {
  unless current_user && current_user.roles.include?(Role.find_by_name("admin"))
    redirect_to new_user_session_path
  end
}

