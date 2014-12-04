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
{ Route, Redirect } = Router = require('react-router')

Main = require('./components/Main.cjsx')
Jobs = require('./components/Jobs.cjsx')
JobResult = require('./components/JobResult.cjsx')
JobSubmit = require('./components/JobSubmit.cjsx')
Jars = require('./components/Jars.cjsx')
Contexts = require('./components/Contexts.cjsx')


window.onload = ->
  routes =
    <Route name="main" path="/" handler={ Main }>
      <Redirect path="/" to="jobs" />
      <Route name="jobs" handler={ Jobs } />
      <Route name="job" path="/job/:id" handler={ JobResult } />
      <Route name="submit-job" handler={ JobSubmit } />
      <Route name="contexts" handler={ Contexts } />
      <Route name="jars" handler={ Jars } />
    </Route>

  Router.run routes, (Handler) ->
    React.render(<Handler/>, document.body)