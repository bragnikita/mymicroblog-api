Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :posts  do
    get '/edit', action: :edit
    put '/content/:preview', action: :update_content
    put '/content', action: :update_content
    get '/preview', action: :preview
  end
end
