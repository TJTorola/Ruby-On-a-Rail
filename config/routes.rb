Rail.router.draw do
	get "/cats", "Cats#index"
	get "/cats/:id", "Cats#show"
end