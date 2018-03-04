# frozen_string_literal: true

# ruby stdlib
require 'yaml'
require 'uri'

# gems
require 'rack'
require 'rack/parser'
require 'rack/cors'
require 'haml'
require 'sass'
require 'coffee-script'
require 'mongo'
require 'faye/websocket'
require 'eventmachine'
require 'logger'

# code
require 'ki/utils/annotations'
require 'ki/utils/descendants'
require 'ki/utils/api_error'
require 'ki/utils/extra_ruby'
require 'ki/utils/logger'
require 'ki/utils/indifferent_hash'

require 'ki/modules/query_interface'
require 'ki/modules/restrictions'
require 'ki/modules/callbacks'
require 'ki/modules/model_helper'

require 'ki/middleware/helpers/format_of_helper'
require 'ki/middleware/helpers/public_file_helper'
require 'ki/middleware/helpers/haml_compiler_helper'
require 'ki/middleware/helpers/redirect_to_helper'
require 'ki/middleware/helpers/view_helper'

require 'ki/middleware/base_middleware'
require 'ki/middleware/init_middleware'
require 'ki/middleware/api_handler'
require 'ki/middleware/public_file_server'
require 'ki/middleware/sass_compiler'
require 'ki/middleware/haml_compiler'
require 'ki/middleware/coffee_compiler'
require 'ki/middleware/insta_doc'
require 'ki/middleware/admin_interface_generator'
require 'ki/middleware/realtime'

require 'ki/ki_config'
require 'ki/helpers'
require 'ki/orm'
require 'ki/model'
require 'ki/channel_manager'
require 'ki/base_request'
require 'ki/ki_app'

require 'ki/ki'
