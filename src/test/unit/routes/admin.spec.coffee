routes      = require '../../../routes'
Store       = require '../../../models/store'

describe 'AdminRoute', ->
  describe 'Access is granted correctly', ->
    it 'allows access and renders all the stores if signed in and seller', ->
      stores = []
      req = user: {isSeller:true, stores:stores}, loggedIn: true
      req.user.populate = (path, cb) -> cb null, req.user
      res = render: sinon.spy()
      routes.admin req, res
      res.render.should.have.been.calledWith 'admin', stores:stores
    it 'denies access if the user isnt a seller and shows a message page', ->
      stores = []
      res = redirect:sinon.spy()
      req = user: {isSeller:false}, loggedIn: true
      routes.admin req, res
      res.redirect.should.have.been.calledWith 'notseller'
    it 'denies access if not signed in', ->
      stores = []
      res = redirect: sinon.spy()
      req = loggedIn: false
      routes.admin req, res
      res.redirect.should.have.been.calledWith 'login'
  describe 'Shows correct content', ->
    it 'only user stores are shown', ->
      stores = [1]
      user = isSeller:true, stores: []
      user.populate = (path, cb) ->
        user.stores = stores
        cb null, user
      sinon.spy user, 'populate'
      req = user: user, loggedIn: true
      res = render: sinon.spy()
      routes.admin req, res
      user.populate.should.have.been.calledWith 'stores'
      res.render.should.have.been.calledWith 'admin', stores:stores
