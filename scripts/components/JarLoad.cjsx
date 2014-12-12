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

api = require('../services/api.coffee')
jarLoaded = require('../events/jar-loaded.coffee')


module.exports = React.createClass
  mixins: [React.addons.LinkedStateMixin]

  getInitialState: ->
    appName: ''
    file: null
    fileType: null
    error: null

  submit: (event) ->
    if not @state.appName
      @setError('No application name')
      return
    if not @state.file
      @setError('No file selected')
      return
    api.jarLoad(@state.appName, @state.file, @state.fileType).then @handleResponse

  setError: (text) -> @setState(error: text)

  handleFile: (event) ->
    file = event.target.files[0]
    type = file.type
    reader = new FileReader()
    reader.onload = (upload) =>
      @setState(file: upload.target.result, fileType: type)
    reader.readAsBinaryString(file)

  handleResponse: (response) ->
    if response.status.code == 200
      jarLoaded.dispatch true
      @setError(null)
    else
      console.log response
      @setError(response.entity.result)

  render: ->
    error = if @state.error then <Alert bsStyle="danger">{ @state.error }</Alert>
    success = if @props.success and not @state.error then <Alert bsStyle="success">'Application successfully uploaded'</Alert>

    <form onSubmit={ this.submit } className="jar-form">
      <h3>New application</h3>
      { error }
      { success }

      <Row>
        <Col md={4}>
          <Input type="text" label='Application name' placeholder="application" valueLink={ @linkState('appName') } />
        </Col>
        <Col md={4}>
          <Input type="file" label="Jar File" onChange={ @handleFile } />
        </Col>
      </Row>
      <Row>
        <Col md={4}>
          <Input type="submit" value="Submit" />
        </Col>
      </Row>
    </form>