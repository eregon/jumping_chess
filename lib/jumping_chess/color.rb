COLORS = %i[
  black red green yellow blue purple cyan white
]
NORMAL = COLORS.map.with_index { |c,i| [c, "\e[#{30+i}m"] }
BRIGHT = COLORS.map.with_index { |c,i| [:"bright_#{c}", "\e[#{30+i};1m"] }
ALL_COLORS = (NORMAL + BRIGHT).to_h
RESET_COLOR = "\e[0m"

def colorize(text, color)
  if color
    "#{ALL_COLORS[color]}#{text}#{RESET_COLOR}"
  else
    "#{text}"
  end
end
