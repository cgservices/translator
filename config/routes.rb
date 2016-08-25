# When Rails >= 3.1
if defined?(Translator::Engine)
  Translator::Engine.routes.draw do
    resources :translations, only: [:index, :create, :destroy]
    get '/translations/keys', to: "translations#keys"
  end
else
  Rails.application.routes.draw do
    resources :translations, :to => "Translator::Translations", only: [:index, :create, :destroy]
    get '/translations/keys', to: "translations#keys"
  end
end
