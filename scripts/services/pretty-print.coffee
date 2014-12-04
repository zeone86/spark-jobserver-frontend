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

# from http://jsfiddle.net/unLSJ/

replacer = (match, pIndent, pKey, pVal, pEnd) ->
  key = '<span class=json-key>'
  val = '<span class=json-value>'
  str = '<span class=json-string>'
  r = pIndent || ''
  if (pKey)
    r = r + key + pKey.replace(/[": ]/g, '') + '</span>: '
  if (pVal)
    r = r + (if pVal[0] == '"' then str else val) + pVal + '</span>'
  r + (pEnd || '')

jsonLine = /^( *)("[\w]+": )?("[^"]*"|[\w.+-]*)?([,[{])?$/mg

module.exports =
  json: (obj) ->
    JSON.stringify(obj, null, 3)
      .replace(/&/g, '&amp;')
      .replace(/\\"/g, '&quot;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(jsonLine, replacer)