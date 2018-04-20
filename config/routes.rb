Rails.application.routes.draw do

  # static
  root('static_pages#home')
  get('/help', to: 'static_pages#help')
  get('/about', to: 'static_pages#about')
  get('/contact', to: 'static_pages#contact')

  # users
  get('/signup', to: 'users#new')
  post('/signup', to: 'users#create')
  resources(:users)

  # sessions
  get('/login', to: 'sessions#new')
  post('/login', to: 'sessions#create')
  delete('/logout', to: 'sessions#destroy')

  # account activations
  resources(:account_activations, only: %i[edit])

  # password resets
  get('password_resets/new')
  get('password_resets/edit')
  resources(:password_resets, only: %i[new create edit update])

  # microposts
  resources(:microposts, only: %i[create destroy])

end
