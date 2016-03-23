Rails.application.routes.draw do
  root to: "polls#landing"
  get '/:slug', to: 'polls#router', as: :polls
  post '/:slug', to: 'polls#create'

  scope '/api/1' do
    get 'slug_is_available/:slug', to: 'polls#slug_is_available'
  end
end
