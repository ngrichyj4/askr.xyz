Rails.application.routes.draw do
  root to: "polls#landing"
  get '/:slug', to: 'polls#router', as: :polls
  post '/:slug', to: 'polls#create'

  scope '/api/1' do
    get 'slug_is_available', to: 'polls#slug_is_available'
    get 'slug_is_valid', to: 'polls#slug_is_valid'
  end
end
