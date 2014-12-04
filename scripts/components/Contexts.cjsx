# @cjsx React.DOM

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

React = require('react/addons')
Row = require('react-bootstrap/Row')

api = require('../services/api.coffee')
contextLoaded = require('../events/context-loaded.coffee')
contextRemoved = require('../events/context-removed.coffee')
Context = require('./Context.cjsx')
CreateContext = require('./CreateContext.cjsx')


module.exports = React.createClass
  componentWillMount: ->
    api.contexts().then (result) => @setState(contexts: result)
    contextLoaded.add @uploaded
    contextRemoved.add @removed

  componentWillUnmount: ->
    contextLoaded.remove @uploaded
    contextRemoved.remove @removed

  removed: (context) ->
    contexts = @state.contexts.filter (c) -> c != context
    @setState(contexts: contexts)

  uploaded: ->
    api.contexts().then (result) => @setState(contexts: result, success: true)

  getInitialState: ->
    contexts: []
    success: false

  render: ->
    contextList = @state.contexts.map (context) => <Context key={ context } name={ context } />

    <div>
      <Row>
        <h1>Available contexts</h1>
        <table className="table table-striped">
          <thead>
            <tr>
              <th>Name</th>
              <th></th>
            </tr>
          </thead>
          <tbody>{ contextList }</tbody>
        </table>
      </Row>
      <CreateContext success={ this.state.success } />
    </div>