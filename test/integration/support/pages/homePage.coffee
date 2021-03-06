Page          = require './seleniumPage'
webdriver       = require 'selenium-webdriver'
Q               = require 'q'

module.exports = class HomePage extends Page
  url: ''
  clickSearchStores: -> @waitForReady().then => @pressButton ".searchStores"
  searchStoresText: (text) ->
    @waitForSelectorClickable '#storeSearchTerm'
    .then => @type "#storeSearchTerm", text
  clickDoSearchStores: @::pressButton.partial "#doSearch"
  searchProductsText: @::type.partial "#productSearchTerm"
  clickDoSearchProducts: @::pressButton.partial "#doSearchProduct"
  storesWithoutFlyersLength: -> @findElements('#storesWithoutFlyer .storeWithoutFlyer').then captureAttribute 'length'
  storesLength: -> @findElements('#stores .store').then captureAttribute 'length'
  stores: ->
    @findElements('#stores .store')
    .then (ss) =>
      getStores = for s in ss
        do (s) =>
          @resolveObj
            name: @getAttributeIn s, 'meta[itemprop="name"]', 'content'
            slug: @getAttributeIn(s, 'a', 'href').then (href) -> href.substr href.lastIndexOf('/')+ 1
      Q.all getStores
  storeLink: (_id) -> @getAttribute "#store#{_id} .link", 'href'
  searchProductsLength: -> @findElements('#productsSearchResults .product').then captureAttribute 'length'
  productLink: (_id) -> @getAttribute "#product#{_id} .link", 'href'
  productsLength: -> @findElements('#products .product').then (els) -> els.length
  firstStoreId: -> @getAttribute '.store[data-id]', 'data-id'
  firstProductId: -> @getAttribute '.product[data-id]', 'data-id'
  product: (_id) ->
    product = {}
    Q.all [
      @getAttribute("#product#{_id}", "data-id").then (t) -> product._id = t
      @getInnerHtml("#product#{_id} .storeName").then (t) -> product.storeName = t
      @getAttribute("#product#{_id}_picture img", "src").then (t) -> product.picture = t
      @getAttribute("#product#{_id}_picture", "href").then (t) -> product.slug = t
    ]
    .then -> product
  storesIds: @::getAttributeInElements.partial '#stores .store', "data-id"
