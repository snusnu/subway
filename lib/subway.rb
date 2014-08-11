# encoding: utf-8

require 'substation'
require 'ipaddress'
require 'request'
require 'response'
require 'anima'
require 'mustache'
require 'multi_json'
require 'rbnacl'
require 'bcrypt'
require 'inflecto'
require 'lupo'
require 'procto'
require 'morpher'

# Support code for running substation apps on rack
module Subway

  # Represent an undefined argument
  Undefined = Module.new.freeze

  # An empty hash useful for (default} parameters
  EMPTY_HASH = {}.freeze

  # An empty frozen string
  EMPTY_STRING = ''.freeze

  # An empty frozen array
  EMPTY_ARRAY = [].freeze

end # module Subway

require 'subway/utils'
require 'subway/http'
require 'subway/route'
require 'subway/route/config'
require 'subway/route_set'
require 'subway/route_set/mutable'
require 'subway/router'
require 'subway/router/builder'
require 'subway/router/builder/http_router'
require 'subway/routes'
require 'subway/mustache/view'
require 'subway/request'
require 'subway/response'
require 'subway/session'
require 'subway/presenter'
require 'subway/pager'
require 'subway/page'
require 'subway/handler'
require 'subway/handler/morpher'
require 'subway/handler/validator'
require 'subway/handler/responder'
require 'subway/handler/responder/html'
require 'subway/handler/responder/json'
require 'subway/handler/redirector'
require 'subway/handler/redirector/found'
require 'subway/handler/renderer'
require 'subway/handler/renderer/mustache'
require 'subway/handler/cookie/loader'
require 'subway/handler/cookie/dumper'
require 'subway/secret_box'
require 'subway/password'
require 'subway/environment'
require 'subway/facade'
