Rail.router.draw do
	get "/", 'ApplicationController#show'
	get "/cats/:cat_id/toy/:id", "ApplicationController#showCats"
end