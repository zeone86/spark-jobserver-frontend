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

time = require('../services/time.coffee')
clickJob = require('../events/click-job.coffee')


module.exports = React.createClass
  click: ->
    clickJob.dispatch @props.job.jobId

  render: ->
    job = @props.job
    label = React.addons.classSet
      "label": true
      "clickable": true
      "label-default": job.status == "RUNNING"
      "label-success": job.status == "FINISHED"
      "label-danger": job.status == "ERROR"

    <tr>
      <td><label className={label} onClick={ this.click }>{ job.jobId }</label></td>
      <td>{ job.classPath }</td>
      <td>{ job.context }</td>
      <td>{ time.formatSecsDuration(job.duration) }</td>
      <td>{ time.format(job.startTime) }</td>
    </tr>