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
Col = require('react-bootstrap/Col')
Alert = require('react-bootstrap/Alert')
Input = require('react-bootstrap/Input')
Select = require('react-select')

api = require('../services/api.coffee')
contextLoaded = require('../events/context-loaded.coffee')


units = [
  { value: 'K', label: 'Kb' }
  { value: 'M', label: 'Mb' }
  { value: 'G', label: 'Gb' }
]

module.exports = React.createClass
  mixins: [React.addons.LinkedStateMixin]

  getInitialState: ->
    cpu: null
    memory: null
    memoryUnit: 'M'
    error: null

  isInteger: (text) -> parseInt(text).toString() == text

  validate: (ref) ->
    value = if @refs[ref] then @refs[ref].getValue()
    if value and not @isInteger(value) then 'error'

  changeUnit: (unit) -> @setState(memoryUnit: unit)

  submit: ->
    if @state.cpu and not @isInteger(@state.cpu) then return
    if @state.memory and not @isInteger(@state.memory) then return
    api.createContext(@state.contextName, @state.cpu, @state.memory, @state.memoryUnit).then @handleResponse

  handleResponse: (response) ->
    if response.status.code == 200
      contextLoaded.dispatch true
      @setState(error: null)
    else
      @setState(error: response.entity.result)

  render: ->
    error = if @state.error then <Alert bsStyle="danger">{ @state.error }</Alert>
    success = if @props.success and not @state.error then <Alert bsStyle="success">'Context successfully created'</Alert>

    <form onSubmit={ this.submit } className="context-form">
      <h3>New context</h3>
      { error }
      { success }

      <Row>
        <Col md={4}>
          <Input type="text" label='Context name' placeholder="context" valueLink={ @linkState('contextName') } />
        </Col>
        <Col md={2}>
          <Input type="text"
            label='Number of Cpu'
            ref='cpu'
            placeholder="total cpu"
            bsStyle={ @validate('cpu') }
            valueLink={ @linkState('cpu') } />
        </Col>
        <Col md={2}>
          <Input type="text"
            label='Memory per node'
            ref='memory'
            placeholder="memory"
            bsStyle={ @validate('memory') }
            valueLink={ @linkState('memory') } />
        </Col>
        <Col md={2}>
          <div className="form-group">
            <label className="control-label">Unit</label>
            <Select value={ @state.memoryUnit } options={ units } onChange={ @changeUnit } />
          </div>
        </Col>
      </Row>
      <Row>
        <Col md={4}>
          <Input type="submit" value="Submit" />
        </Col>
      </Row>
    </form>