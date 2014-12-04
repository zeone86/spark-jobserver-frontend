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
Router = require('react-router')
Row = require('react-bootstrap/Row')
Jumbotron = require('react-bootstrap/Jumbotron')

Config = require('./Config.cjsx')
api = require('../services/api.coffee')
prettyPrint = require('../services/pretty-print.coffee')


module.exports = React.createClass
  mixins: [ Router.State ]

  componentWillMount: ->
    api.jobResult(@getParams().id).then (result) => @setState(result)

  getInitialState: ->
    status: null
    result: null

  render: ->
    if @state.status == null then return null

    labelClass = React.addons.classSet
      "label": true
      "label-default": @state.status == "RUNNING"
      "label-success": @state.status == "OK"
      "label-danger": @state.status == "ERROR"

    <Row>
      <h1>Job { @props.id }</h1>
      <br />
      <p><label className={ labelClass }>{ this.state.status.toLowerCase() }</label></p>
      <br />
      <pre dangerouslySetInnerHTML={{ __html: prettyPrint.json(this.state.result) }} />
      <h3>Configuration</h3>
      <Config id={ this.getParams().id } />
    </Row>