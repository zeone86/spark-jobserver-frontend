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
Col = require('react-bootstrap/Col')
Alert = require('react-bootstrap/Alert')
Input = require('react-bootstrap/Input')
Select = require('react-select')

api = require('../services/api.coffee')


sync = [
  { value: 'true', label: 'True' }
  { value: 'false', label: 'False' }
]

makeOption = (param) ->
  value: param
  label: param

module.exports = React.createClass
  mixins: [React.addons.LinkedStateMixin, Router.Navigation]

  componentWillMount: ->
    api.contexts().then (result) =>
      @setState(contexts: result.map(makeOption))
    api.jars().then (result) => @setState(applications: Object.keys(result).map(makeOption))

  getInitialState: ->
    application: null
    context: null
    config: ''
    classPath: null
    sync: 'false'
    error: null
    success: null
    applications: []
    contexts: []

  changeApplication: (app) -> @setState(application: app)

  changeContext: (context) -> @setState(context: context)

  changeSync: (sync) -> @setState(sync: sync)

  backtoJobs: ->
    @transitionTo('jobs')

  submit: ->
    if not @state.classPath
      @setState(error: 'Missing classPath')
      return
    if not @state.application
      @setState(error: 'Missing application')
      return
    api.jobSubmit(@state.config, @state.application, @state.classPath, @state.context,@state.sync).then @handleResponse

  handleResponse: (response) ->
    if response.status.code == 202
      id = response.entity.result.jobId
      @setState(error: null, success: "Job successfully submitted with id #{ id }")
      setTimeout @backtoJobs, 3000
    else
      @setState(error: response.entity.result, success: null)

  render: ->
    error = if @state.error then <Alert bsStyle="danger">{ @state.error }</Alert>
    success = if @state.success then <Alert bsStyle="success">{ @state.success }</Alert>

    <form onSubmit={ this.submit } className="job-form">
      <h3>Submit job</h3>
      { error }
      { success }

      <Row>
        <Col md={2}>
          <Input type="textarea"
            label='Configuration'
            valueLink={ @linkState('config') } />
        </Col>
        <Col md={2}>
          <div className="form-group">
            <label className="control-label">Application</label>
            <Select value={ @state.application } options={ @state.applications } onChange={ @changeApplication } />
          </div>
        </Col>
        <Col md={4}>
          <Input type="text"
            label='classPath'
            placeholder="memory"
            valueLink={ @linkState('classPath') } />
        </Col>
        <Col md={2}>
          <div className="form-group">
            <label className="control-label">Context</label>
            <Select value={ @state.context } options={ @state.contexts } onChange={ @changeContext } />
          </div>
        </Col>
          <Col md={1}>
                  <div className="form-group">
                    <label className="control-label">Sync</label>
                    <Select value={ @state.sync } options={ sync } onChange={ @changeSync } />
                  </div>
                </Col>
      </Row>
      <Row>
        <Col md={4}>
          <Input type="submit" value="Submit" />
        </Col>
      </Row>
    </form>