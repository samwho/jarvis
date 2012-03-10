class Otomata < NoteGenerator
  def initialize
    @grid = generate_grid
  end

  def generate_grid x = 8, y = 8
    new_grid = []

    y.times { new_grid << [] }
    new_grid.each do |array|
      x.times do
        array << nil
      end
    end
  end

  def next

  end

  def handle_input input
    case input
    when /^flip/
      input = input.split(' ')
      x = input[1].to_i
      y = input[2].to_i
      flip x, y
    end
  end

  def flip x, y
    case @grid[x][y]
    when nil
      @grid[x][y] = :up
    when :up
      @grid[x][y] = :right
    when :down
      @grid[x][y] = :left
    when :left
      @grid[x][y] = nil
    when :right
      @grid[x][y] = :down
    end
  end
end
