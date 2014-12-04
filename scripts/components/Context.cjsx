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
Button = require('react-bootstrap/Button')
Modal = require('react-bootstrap/Modal')
ModalTrigger = require('react-bootstrap/ModalTrigger')

api = require('../services/api.coffee')
contextRemoved = require('../events/context-removed.coffee')


ConfirmDelete = React.createClass
  delete: ->
    @props.onDelete()
    @props.onRequestHide()

  render: ->
    <Modal animation={ true } backdrop={ true } title="Delete context" onRequestHide={ @props.onRequestHide }>
      <div className="modal-body">
        <p>Are you sure to delete context { @props.name }?</p>
      </div>
      <div className="modal-footer">
        <Button onClick={ @props.onRequestHide }>No, thanks</Button>
        <Button bsStyle="danger" onClick={ @delete }>Sure, go on!</Button>
      </div>
    </Modal>


module.exports = React.createClass
  delete: ->
    api.deleteContext(@props.name).then (response) =>
      contextRemoved.dispatch @props.name

  render: ->
    modal = <ConfirmDelete name={ @props.name } onDelete={ @delete } />

    <tr>
      <td>{ @props.name }</td>
      <td>
        <ModalTrigger modal={ modal }>
          <Button bsStyle="danger">Delete</Button>
        </ModalTrigger>
      </td>
    </tr>