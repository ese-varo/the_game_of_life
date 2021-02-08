require_relative 'cell'

class Board
  attr_reader :size, :cells

  def initialize(size)
    @size  = size
    @cells = capture_cells
  end

  def update_cells
    cells.each do |row|
      row.each { |cell| cell.current_state = cell.next_state }
    end
  end

  def render
    cells.each do |row|
      row.each { |cell| print cell }
      puts
    end
    puts "Press \"ctrl + z\" to exit"
  end

  def next_iteration
    cells.each do |row|
      row.each do |cell|
        neighbors = alive_neighbors_counter(cell.position)
        cell.new_state(neighbors)
      end
    end
  end

private
  def alive_neighbors_counter(cell_position)
    x, y = cell_position
    neighbor_x = x - 1
    neighbor_y = y - 2
    neighbors = 0
    3.times do
      3.times do
        neighbor_y += 1
        next if (neighbor_x.negative? or neighbor_y.negative?) or
                (neighbor_x >= size or neighbor_y >= size)
        neighbors += cells[neighbor_x][neighbor_y].current_state
      end
      neighbor_x += 1
      neighbor_y = y - 2
    end
    neighbors -= cells[x][y].current_state
  end

  def capture_cells
    Array.new(size) do |x|
      Array.new(size) { |y| Cell.new([x, y], random_life) }
    end
  end

  def random_life
    rand(1..100) > 40 ? 0 : 1
  end
end

=begin

  -------------------------
  x-1,y-1 | x-1,y | x-1,y+1
  --------|-------|--------
  x,y-1   | (x,y) | x,y+1
  --------|-------|--------
  x+1,y-1 | x+1,y | x+1,y+1
  -------------------------

=end
