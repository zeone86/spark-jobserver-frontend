# Copyright 2014 UniCredit S.p.A.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

rest = require('rest')
mime = require('rest/interceptor/mime')
errorCode = require('rest/interceptor/errorCode')
interceptor = require('rest/interceptor')

identity = (x) -> x

# needed because the server response is not valid JSON
# but still uses the application/json content type
fixJson = interceptor
  init: identity
  request: identity
  response: identity
  success: identity
  error: (resp, config, meta) ->
    if resp.status.code == 200 then { entity: resp.entity, status: resp.status }

client = rest.wrap(mime).wrap(fixJson).wrap(errorCode, code: 500);
baseUrl = ''

module.exports =
  jobs: ->
    client(path: "#{ baseUrl }/jobs").then (response) -> response.entity

  jobResult: (id) ->
    client(path: "#{ baseUrl }/jobs/#{ id }").then (response) -> response.entity

  jobConfig: (id) ->
    client(path: "#{ baseUrl }/jobs/#{ id }/config").then (response) -> response.entity

  jobSubmit: (config, appName, classPath, context) ->
    params =
      appName: appName
      classPath: classPath
    if context then params.context = context
    client(path: "#{ baseUrl }/jobs", entity: config, params: params)

  jars: ->
    client(path: "#{ baseUrl }/jars").then (response) -> response.entity

  jarLoad: (appName, jar) ->
    client(path: "#{ baseUrl }/jars/#{ appName }", entity: jar)

  contexts: ->
    client(path: "#{ baseUrl }/contexts").then (response) -> response.entity

  createContext: (name, cpu, memory, unit) ->
    unitShort = unit[0].toUpperCase()
    params = {}
    if cpu then params['num-cpu-cores'] = cpu
    if memory then params['memory-per-node'] = "#{ memory }#{ unitShort }"
    client(path: "#{ baseUrl }/contexts/#{ name }", method: 'POST', params: params)

  deleteContext: (name) ->
    client(path: "#{ baseUrl }/contexts/#{ name }", method: 'DELETE')