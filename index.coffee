_ = require 'lodash'
kit = require 'nokit'
yakuUtils = require 'yaku/lib/utils'

br = kit.require 'brush'

SNAKECASE_RE = /[a-z]+_\w+/g
PROJECT_PATH = '../muui'

kit.glob [
    "#{PROJECT_PATH}/**/*.coffee"
    "#{PROJECT_PATH}/**/*.jade"
    "!#{PROJECT_PATH}/node_modules/**"
]
.then (fs) ->
    convert = (f) ->
        kit.readFile f, 'utf8'
        .then (str) ->
            kit.log "\n#{f}: "
            match = str.match SNAKECASE_RE
            if not _.isEmpty match
                for item in _.uniq(match)
                    re = new RegExp('(\/|\'){1}' + item)
                    if re.test str or item.i
                        kit.log 'Exclude: ' + br.red item
                        continue
                    re = new RegExp item, 'g'
                    camelCase = _.camelCase item
                    kit.log br.blue(item) + br.cyan(' -> ') + br.blue(camelCase)
                    str = str.replace re, camelCase
            kit.writeFile f, str

    tasks = _.map fs[0..1], (f) ->
        convert(f)

    yakuUtils.async 1, tasks
.then ->
    kit.log br.green '\nDone!'
