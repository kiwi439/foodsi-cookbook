Rails.application.routes.draw do
  scope path: ApplicationResource.endpoint_namespace, defaults: { format: :jsonapi } do
    resources :authors, only: %i[index show] do
      get :statistics, on: :member
    end
    resources :users, only: %i[show]
    resources :categories, only: :index
    resources :recipes, only: %i[index show] do
      patch :feature, on: :member
      patch :unfeature, on: :member
    end
    resources :likes, only: %i[index show create destroy]
    mount VandalUi::Engine, at: '/vandal'
  end
end
