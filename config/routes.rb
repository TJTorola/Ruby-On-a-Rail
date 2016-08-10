Rail.router.draw do
	get "/", 'Cats#show'
	get "/cats/:cat_id/toy/:id", "Cats#showCats"
end