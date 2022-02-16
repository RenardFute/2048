# frozen_string_literal: true

require 'ruby2d'
require './custom_square'

set title: '2048'
set height: 800

@score = 0

@grid = [
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0]
]

@colors = {
  0 => '#C5BAAD',
  2 => '#eee4da',
  4 => '#ede0c8',
  8 => '#f2b179',
  16 => '#f59563',
  32 => '#f67c5f',
  64 => '#f65e3b',
  128 => '#edcf72',
  256 => '#edcc61',
  512 => '#edc850',
  1024 => '#edc53f',
  2048 => '#edc22e'
}

def draw_logo
  cs = CustomSquare.new(
    '2048',
    125,
    125,
    '#D9B543',
    10, 10
  )

  cs.draw
end

def generate_cell
  value = rand(1..2) * 2

  free_cells = []
  (0..3).each do |x|
    (0..3).each do |y|
      if @grid[y][x].zero?
        free_cells.append [y, x]
      end
    end
  end

  cell = free_cells.sample
  @grid[cell[0]][cell[1]] = value
end

def draw_grid

  width = get :width

  g_width = width - 50
  g_height = 525

  Rectangle.new(
    x: 25, y: 250,
    width: g_width,
    height: g_height,
    color: '#B1A497'
  )

  s_width = g_width / 4
  s_height = g_height / 4

  (0..3).each do |x|
    (0..3).each do |y|
      cs = CustomSquare.new(
        (@grid[y][x]).zero? ? '' : @grid[y][x],
        s_width,
        s_height,
        @colors[@grid[y][x]],
        50 + (s_width * x),
        265 + (s_height * y)
      )

      cs.draw
    end
  end
end

on :key_down do |event|
  key = event.key
  if key == 'down'
    (0..3).each do |x|
      (0..2).each do |y|
        y = 2 - y
        current = @grid[y][x]
        deepest = y
        (y..3).each do |_y|
          deepest = _y if @grid[_y][x].zero? || @grid[_y][x] == current
        end

        @score += @grid[deepest][x] * 2 if deepest != y && @grid[deepest][x] != 0

        @grid[deepest][x] += current
        @grid[y][x] -= current
      end
    end
  end


  if key == 'up'
    cell_merged = []
    (0..3).each do |x|
      (1..3).each do |y|
        current = @grid[y][x]
        highest = y
        y.downto(0) do |_y|
          highest = _y if @grid[_y][x].zero? || (@grid[_y][x] == current && !cell_merged.include?([_y, x]))
        end

        cell_merged.append [highest, x] if @grid[highest][x] == @grid[y][x] && highest != y

        @score += @grid[highest][x] * 2 if highest != y && @grid[highest][x] != 0

        @grid[highest][x] += current
        @grid[y][x] -= current
      end
    end
  end

  if key == 'right'
    (0..2).each do |x|
      (0..3).each do |y|
        x = 2 - x
        current = @grid[y][x]
        rightest = x
        (x..3).each do |_x|
          rightest = _x if @grid[y][_x].zero? || @grid[y][_x] == current
        end

        @score += @grid[y][rightest] * 2 if rightest != x && @grid[y][rightest] != 0

        @grid[y][rightest] += current
        @grid[y][x] -= current
      end
    end
  end

  if key == 'left'
    cell_merged = []
    (1..3).each do |x|
      (0..3).each do |y|
        current = @grid[y][x]
        leftest = x
        x.downto(0) do |_x|
          leftest = _x if @grid[y][_x].zero? || (@grid[y][_x] == current && !cell_merged.include?([y, _x]))
        end

        cell_merged.append [y, leftest] if @grid[y][leftest] == @grid[y][x] && leftest != x

        @score += @grid[y][leftest] * 2 if leftest != x && @grid[y][leftest] != 0

        @grid[y][leftest] += current
        @grid[y][x] -= current
      end
    end
  end

  if %w[down up left right].include?(key)
    generate_cell
  end
end

generate_cell
update do
  clear
  set background: '#FBF7ED'
  draw_logo
  draw_grid

  Text.new(
    "Score: #{@score}",
    x: 150, y: 10,
    size: 30,
    color: '#6B635C'
  )
end

show
