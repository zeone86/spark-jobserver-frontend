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

api = require('../services/api.coffee')
prettyPrint = require('../services/pretty-print.coffee')


module.exports = React.createClass
  componentWillMount: ->
    api.jobConfig(@props.id).then (result) => @setState(config: result)

  getInitialState: ->
    config: null

  render: ->
    if not @state.config then return null

    <pre dangerouslySetInnerHTML={{ __html: prettyPrint.json(this.state.config) }} />