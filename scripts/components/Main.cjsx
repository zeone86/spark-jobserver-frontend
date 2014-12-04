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
{ Link, RouteHandler, Navigation } = require('react-router')
Nav = require('react-bootstrap/Nav')
NavItem = require('react-bootstrap/NavItem')

clickJob = require('../events/click-job.coffee')


module.exports = React.createClass
  mixins: [Navigation]

  componentWillMount: ->
    clickJob.add (id) =>
      @transitionTo('job', id: id)

  render: ->
    <div className="container">
      <Nav bsStyle="pills">
        <NavItem>
          <Link to="jobs">Jobs</Link>
        </NavItem>
        <NavItem>
          <Link to="submit-job">Submit job</Link>
        </NavItem>
        <NavItem>
          <Link to="contexts">Contexts</Link>
        </NavItem>
        <NavItem>
          <Link to="jars">Applications</Link>
        </NavItem>
      </Nav>
      <RouteHandler />
    </div>