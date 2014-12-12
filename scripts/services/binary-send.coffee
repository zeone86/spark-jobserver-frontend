When = require('when')

byteValue = (x) -> x.charCodeAt(0) & 0xff

sendAsBinaryDefault = (data) ->
  ords = Array.prototype.map.call(data, byteValue)
  ui8a = new Uint8Array(ords)
  this.send(ui8a.buffer)

XMLHttpRequest.prototype.sendAsBinary ?= sendAsBinaryDefault


module.exports = (url, data, type) ->
  deferred = When.defer()
  xhr = new XMLHttpRequest()
  xhr.open('POST', url)
  xhr.overrideMimeType(type)
  xhr.setRequestHeader("Content-Type", type)
  xhr.onloadend = ->
    entity = try
      JSON.parse(xhr.responseText)
    catch e
      xhr.responseText

    deferred.resolve
      status:
        code: xhr.status
        text: xhr.statusText
      entity: entity
  xhr.sendAsBinary(data)
  deferred.promise