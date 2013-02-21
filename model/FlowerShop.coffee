mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = require('mongoose').Types.ObjectId


# FlowerShop Model
module.exports = (db) ->

  FlowerShopSchema = new Schema {
    name: String,
    phone: String,
    address: String
  }

  # Get a shop by id
  FlowerShopSchema.statics.findOrCreate = (data, cb) ->
    @findOne({"name": data.name}).exec (err, shop) ->
      return cb {error: "Database Error"} if err?
      if not shop?
        shop = new FlowerShop data
        shop.save (err) ->
          return cb(null, shop ,true)
      else
        cb null, shop, false

  FlowerShopSchema.statics.findById = (id, cb)->
    id = new ObjectId(id)
    console.log id
    @findOne("_id" : id).exec cb


  FlowerShop = db.model "FlowerShop", FlowerShopSchema