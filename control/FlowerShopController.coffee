request = require "request"

module.exports = (FlowerShop, User) =>

	renderShopPage: (req, res)=>
		FlowerShop.findById req.params.flowershopId, (err, shop)=>
			return res.render('shop', {shop: shop, title: shop.name})

	login: (req, res)=>
		console.log 'Endpoint: Login Shop'
		return res.redirect "/" unless (req.body.username? and req.body.password)
		data = {username: req.body.username, password: req.body.password}
		User.findWithUsername data, (err, user)=>
			return res.redirect '/' if not user or err?
			req.session.user = user
			console.log 'User: ' + JSON.stringify user
			if not user.flowershopId?
				return res.redirect '/'
			FlowerShop.findById user.flowershopId, (err, shop)=>
				return res.redirect '/' if err? or not shop?
				req.session.shop = shop
				console.log "Redirect /shop/" + user.flowershopId
				return res.redirect '/shop/' + user.flowershopId

	create: (req, res)=>
		console.log 'Endpoint: Create'
		if not req.body.username? or 
		not req.body.password?
			return res.redirect "/"
		data = {name: req.body.name, phone: req.body.phone, address: req.body.address}
		FlowerShop.findOrCreate data, (err, shop, created)=>
			console.log err if err?
			req.session.shop = shop
			console.log {error: "Not Created 1"} unless created
			return res.redirect "/" unless created
			data = {username: req.body.username, password: req.body.password}
			data.shop = shop
			data.username
			User.findOrCreateWithShop data, (err, user, created)=>
				console.log {error: "Not Created 2"} unless created
				return res.redirect "/" unless created
				return res.redirect '/shop/' + shop._id
		

