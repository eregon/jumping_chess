MRUBY = RUBY_ENGINE == "mruby"
WASM = MRUBY && MRUBY_PLATFORM == 'wasm'

if MRUBY
  module Kernel
    def require(feature)
    end

    def require_relative(feature)
    end
  end
end

require_relative 'jumping_chess/color'
require_relative 'jumping_chess/coord'
require_relative 'jumping_chess/player'
require_relative 'jumping_chess/state'
require_relative 'jumping_chess/save'
require_relative 'jumping_chess/ui'
require_relative 'jumping_chess/game'
