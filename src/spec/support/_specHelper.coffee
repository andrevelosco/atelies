require './jasmineMatchersHelper'
jasmineBeforeAfterHelper      = require './jasmineBeforeAfterHelper'

for key,value of jasmineBeforeAfterHelper
  exports[key] = value

exports.whenDone = (condition, callback) ->
  if condition()
    process.nextTick callback
  else
    process.nextTick -> whenDone(condition, callback)

exports.waitSeconds = (seconds, callback) ->
  future = new Date()
  future.setSeconds(new Date().getSeconds()+seconds)
  exports.whenDone ->
    now = new Date()
    now > future
  , callback