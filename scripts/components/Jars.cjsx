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
{ compose, map, toPairs, sortBy, head } = require('ramda')

api = require('../services/api.coffee')
jarLoaded = require('../events/jar-loaded.coffee')
Jar = require('./Jar.cjsx')
JarLoad = require('./JarLoad.cjsx')


module.exports = React.createClass
  componentWillMount: ->
    api.jars().then (result) => @setState(jars: result)
    jarLoaded.add @uploaded

  componentWillUnmount: ->
    jarLoaded.remove @uploaded

  uploaded: ->
    api.jars().then (result) => @setState(jars: result, success: true)

  getInitialState: ->
    jars: {}
    success: false

  render: ->
    if (toPairs(@state.jars).length == 0) then return null
    jarList = compose(
      map((jar) -> <Jar jar={ jar } key={ jar[0] }/>)
      sortBy(head)
      toPairs
    )(@state.jars)

    <div>
      <Row>
        <h1>Uploaded applications</h1>
        <table className="table table-striped">
          <thead>
            <tr>
              <th>Name</th>
              <th>Uploaded at</th>
            </tr>
          </thead>
          <tbody>{ jarList }</tbody>
        </table>
      </Row>
      <JarLoad success={ @state.success } />
    </div>