COLORS = %i[
  black red green yellow blue purple cyan white
].map.with_index { |c,i| [c, "\e[#{30+i}m"] }.to_h

RESET_COLOR = "\e[0m"

def colorize(text, color)
  if color
    "#{COLORS[color]}#{text}#{RESET_COLOR}"
  else
    "#{text}"
  end
end
