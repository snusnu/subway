# encoding: utf-8

require 'substation'
require 'request'
require 'response'
require 'anima'
require 'mustache'
require 'multi_json'
require 'rbnacl'
require 'bcrypt'

# Support code for running substation apps on rack
module Subway

  # Represent an undefined argument
  Undefined = Object.new.freeze

  # An empty hash useful for (default} parameters
  EMPTY_HASH = {}.freeze

end # module Subway

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
require 'subway/handler'
require 'subway/handler/applifier'
require 'subway/handler/rackifier'
require 'subway/handler/responder'
require 'subway/handler/responder/html'
require 'subway/handler/responder/json'
require 'subway/handler/renderer'
require 'subway/handler/renderer/mustache'
require 'subway/handler/serializer'
require 'subway/handler/serializer/json'
require 'subway/handler/deserializer'
require 'subway/handler/deserializer/json'
require 'subway/secret_box'
require 'subway/password'
