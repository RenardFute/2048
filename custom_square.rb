# frozen_string_literal: true

# A util class to draw squares
class CustomSquare
  @title = ''
  @height = 20
  @width = 20
  @color = 'random'
  @coord_y = 0
  @coord_y = 0


  def initialize(title, width, height, color, coord_x, coord_y)
    @title = title
    @color = color
    @height = width
    @width = height
    @coord_x = coord_x
    @coord_y = coord_y
  end

  def draw_bg
    Square.new(
      x: @coord_x, y: @coord_y,
      size: @size,
      color: @color
    )
  end

  def get_brightness_from_hew(hex)
    hex_color = hex.gsub('#', '')
    rgb = hex_color.scan(/../).map(&:hex)
    brightness  = rgb[0].to_i
    brightness += rgb[1].to_i
    brightness += rgb[2].to_i
    (brightness / (255 * 3))
  end

  def draw_txt
    Text.new(
      @title,
      x: @coord_x + (@width / 2) - @width / 3 - 5,
      y: @coord_y + (@height / 2) - @height / 5,
      style: 'bold',
      size: [@height, @width].max / 5,
      color: get_brightness_from_hew(@color) < 0.5 ? '#F8F7F4' : '#6B635C'
    )
  end

  def draw
    draw_bg
    draw_txt
  end
end
