Rails.application.routes.draw do
  root "nobeta#index"
  get "/" => "nobeta#index"
  post "nobeta" => "nobeta#nobeta"
  post "file_download" => "nobeta#file_download"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
