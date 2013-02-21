mongoose = require 'mongoose'
Schema = mongoose.Schema

# Delivery Model
module.exports = (db) ->

  DeliverySchema = new Schema {
    flowerShopId: String,
    address: String,
    pickupTime: Date,
    deliveryTime: Date
  }




  Delivery = db.model "Delivery", DeliverySchema