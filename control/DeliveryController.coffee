request = require "request"
EventController = require("./EventController")()


module.exports = (Delivery, FlowerShop, User, Account) =>
	createDelivery: (req, res)=>
		data = req.body
		data.flowershopId = "#{req.session.shop._id}"
		Delivery.create data, (err, delivery)=>
			data.shopAddress = req.session.shop.address
			Account.getAllRegisteredDrivers (drivers)=>
				EventController.emitEvent driver.url, "rfq", "delivery_ready", data
