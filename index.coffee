#!/usr/bin/env coffee
_ = require 'lodash'
kit = require 'nokit'
yakuUtils = require 'yaku/lib/utils'

br = kit.require 'brush'

SNAKECASE_RE = /(?:^|\s|\.|\@|\(|\$)(?!_)[a-z]+_\w+(?:$|\s|\.|\(|,|:|-|\+|\[)/gm
PROJECT_PATH = '../xuetanzou'

kit.glob [
    "#{PROJECT_PATH}/**/*.coffee"
    "#{PROJECT_PATH}/**/*.jade"
    "!#{PROJECT_PATH}/node_modules/**"
    "!#{PROJECT_PATH}/bower_components/**"
]
.then (fs) ->
    convert = (f) ->
        kit.readFile f, 'utf8'
        .then (str) ->
            kit.log "\n#{f}: "
            match = str.match SNAKECASE_RE
            if not _.isEmpty match
                for item in _.uniq _.filter _.map(match, (item) ->
                    item.replace(/\.|\s+|\(|\@|\$|,|:|-|\+|\[/g, '')
                )
                    re = new RegExp item, 'g'
                    camelCase = _.camelCase item
                    kit.log br.blue(item) + br.cyan(' -> ') + br.blue(camelCase)
                    str = str.replace re, camelCase
            kit.writeFile f, str

    tasks = _.map fs, (f) ->
        convert(f)

    yakuUtils.async 1, tasks
.then ->
    kit.log br.green '\nDone!'
