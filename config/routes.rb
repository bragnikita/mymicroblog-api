Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :posts  do
    get '/edit', action: :edit
    put '/content/:preview', action: :update_content
    put '/content', action: :update_content
    get '/preview', action: :preview
    patch '/property', action: :update_attribute
  end

  controller :images do
    post '/images', action: :create
    post '/posts/:post_id/images', action: :create_and_attach_post
    get '/posts/:post_id/images', action: :get_post_images
  end
end
