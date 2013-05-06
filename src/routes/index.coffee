Product     = require '../models/product'
Store       = require '../models/store'
_           = require 'underscore'
everyauth   = require 'everyauth'

exports.admin = (req, res) ->
  unless req.loggedIn
    return res.redirect 'login'
  unless req.user.isSeller
    return res.redirect 'notseller'
  req.user.populate 'stores', (err, user) ->
    res.render 'admin', stores: user.stores

exports.notSeller = (req, res) -> res.render 'notseller'

exports.adminStore = (req, res) ->
  store = Store.create name: req.body.name, phoneNumber: req.body.phoneNumber, city: req.body.city, state: req.body.state, otherUrl: req.body.otherUrl, banner: req.body.banner
  store.save (err) ->
    if err?
      res.json 400, err
    else
      res.json 201, store

exports.index = (req, res) ->
  Product.find (err, products) ->
    dealWith err
    viewModelProducts = _.map products, (p) -> p.toSimpleProduct()
    res.render "index", products: viewModelProducts

exports.store = (req, res) ->
  Store.findWithProductsBySlug req.params.storeSlug, (err, store, products) ->
    dealWith err
    return res.renderWithCode 404, 'store', store: null, products: [] if store is null
    viewModelProducts = _.map products, (p) -> p.toSimpleProduct()
    res.render "store", store: store, products: viewModelProducts, (err, html) ->
      #console.log html
      res.send html

exports.product = (req, res) ->
  Product.findByStoreSlugAndSlug req.params.storeSlug, req.params.productSlug, (err, product) ->
    dealWith err
    return res.send 404 if product is null
    res.json product.toSimpleProduct()
