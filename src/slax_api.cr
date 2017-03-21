require "kemal"
require "ecr"
require "dotenv"
require "pg"
require "crecto"

require "./slax_api/models.cr"
require "./slax_api/controllers/post_controller.cr"
require "./slax_api/controllers/user_controller.cr"
require "./slax_api/routes.cr"

Dotenv.load

Kemal.run

