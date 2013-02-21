request = require "request"
EventController = require("./EventController")()


module.exports = (Delivery, FlowerShop, User, Account) =>
	createDelivery: (req, res)=>
		data = req.body
		data.flowershopId = "#{req.session.shop._id}"
		Delivery.create data, (err, delivery)=>
			data.shopAddress = req.session.shop.address
			Account.getAllRegisteredDrivers (err, drivers)=>
				return res.redirect '/shop/#{req.session.shop._id/test}' if err?
				EventController.emitEvent driver.uri, "rfq", "delivery_ready", data for driver in drivers
				res.redirect "/shop/#{req.session.shop._id}"
