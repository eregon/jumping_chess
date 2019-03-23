COLORS = %i[
  black red green yellow blue purple cyan white
]

if WASM
  COLOR_MAPPINGS = {
    cyan: "deepskyblue",
    yellow: "orange",
    nil => "silver",
  }
  NORMAL = COLORS.map.with_index { |c,i| [c, "<span style='color: #{COLOR_MAPPINGS[c] || c}'>"] }
  BRIGHT = COLORS.map.with_index { |c,i| [:"bright_#{c}", "<span style='color: #{COLOR_MAPPINGS[c] || c}; font-weight: bold;'>"] }
  RESET_COLOR = "</span>"
else
  NORMAL = COLORS.map.with_index { |c,i| [c, "\e[#{30+i}m"] }
  BRIGHT = COLORS.map.with_index { |c,i| [:"bright_#{c}", "\e[#{30+i};1m"] }
  RESET_COLOR = "\e[0m"
end

ALL_COLORS = (NORMAL + BRIGHT).to_h

def colorize(text, color)
  if color
    "#{ALL_COLORS[color]}#{text}#{RESET_COLOR}"
  else
    "#{text}"
  end
end
