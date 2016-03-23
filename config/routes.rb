Rails.application.routes.draw do
  root to: "polls#landing"
  get '/:slug', to: 'polls#router', as: :polls
  post '/:slug', to: 'polls#create'
end
