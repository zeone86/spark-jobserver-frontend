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
ramda = require('ramda')

api = require('../services/api.coffee')
Job = require('./Job.cjsx')


module.exports = React.createClass
  componentWillMount: ->
    api.jobs().then (result) => @setState(jobs: result)

  getInitialState: ->
    jobs: []

  render: ->
    jobList = ramda.reverse(@state.jobs).map (job) -> <Job job={ job } key={ job.jobId }/>

    <Row>
      <h1>Latest jobs</h1>
      <table className="table table-striped">
        <thead>
          <tr>
            <th>Id</th>
            <th>Job Name</th>
            <th>Context</th>
            <th>Duration</th>
            <th>Started at</th>
          </tr>
        </thead>
        <tbody>{ jobList }</tbody>
      </table>
    </Row>