class Otomata < NoteGenerator
  def initialize x = 8, y = 8
    @x = x
    @y = y
    @grid = generate_grid
    @scale = Scale.c_major
  end

  # Generates a 2 dimensional array, x by y elements, all empty arrays. Just a
  # blank grid ready for use in this otomata style generator.
  def generate_grid x = @x, y = @y
    new_grid = []

    y.times { new_grid << [] }
    new_grid.each do |array|
      x.times do
        array << []
      end
    end
  end

  def next
    notes = []

    @x.times do |x|
      if @grid[x][0].length > 0 or @grid[x][@y - 1].length > 0
        notes << @scale[x]
      end
    end

    @y.times do |y|
      if @grid[0][y].length > 0 or @grid[@x - 1][y].length > 0
        notes << @scale[y]
      end
    end

    print_grid

    Thread.exclusive do
      next_generation!
    end

    return Note.new notes, Note.length(2)
  end

  # Gets the next generation of the otomata grid. Deals with moving all of the
  # placed nodes correctly.
  #
  # This method will return a new grid, it will not overwrite the existing @grid
  # instance variable.
  def next_generation
    new_grid = generate_grid

    @x.times do |x|
      @y.times do |y|
        # If we are at an edge, reverse direction
        @grid[x][y].each do |node|
          if (x == 0      and node == :left) or
             (x == @x - 1 and node == :right) or
             (y == 0      and node == :up) or
             (y == @y - 1 and node == :down)

            @grid[x][y].delete node

            # Don't want to introduce nil elements into the grid.
            new_direction = reverse_direction(node)
            @grid[x][y] << new_direction unless new_direction.nil?
          end
        end

        # If there are more than one nodes on a square, rotate them.
        if @grid[x][y].length > 1
          new_nodes = []
          @grid[x][y].each do |node|
            # Don't want to introduce nil elements into the grid
            new_direction = rotate_direction(node)
            new_nodes << new_direction unless new_direction.nil?
          end

          @grid[x][y] = new_nodes
        end

        # Finally, perform the relevant moves
        @grid[x][y].each do |node|
          case node
          when :up
            new_grid[x][y-1] << :up
          when :down
            new_grid[x][y+1] << :down
          when :left
            new_grid[x-1][y] << :left
          when :right
            new_grid[x+1][y] << :right
          end
        end
      end
    end

    return new_grid
  end

  # This method does the same thing as its non-exclamation mark counterpart,
  # except it overwrites the contents of the @grid instance variable with the
  # next generation grid.
  def next_generation!
    @grid = next_generation
  end

  # Pretty prints a 2 dimensional grid of values.
  #
  # Example:
  #
  #   grid = [[nil, :up], [:down, nil]]
  #   print_grid grid
  #   #=> +-+-+
  #       | |^|
  #       +-+-+
  #       |V| |
  #       +-+-+
  def print_grid grid = @grid
    puts (('+-' * grid.first.length) + '+').black
    @y.times do |y|
      @x.times do |x|
        print '|'.black
        print text_representation(grid[x][y])
      end
      print '|'.black
      puts ("\n" + ('+-' * grid[y].length) + '+').black
    end
  end

  # Takes a node and gets the textual representation of that node to be printed
  # out on the grid. For example, up is ^, down is V and so on.
  def text_representation node
    return ' ' unless node.is_a? Array
    return ' ' if node.length == 0
    return 'O' if node.length > 1

    case node.first
    when :left
      '<'
    when :up
      '^'
    when :down
      'V'
    when :right
      '>'
    else
      ' '
    end
  end

  # Takes a node as input and returns its reverse direction.
  def reverse_direction node
    case node
    when :up
      :down
    when :down
      :up
    when :left
      :right
    when :right
      :left
    else
      nil
    end
  end

  # Takes a node as input and returns its rotated clockwise direction.
  def rotate_direction node
    case node
    when :up
      :right
    when :down
      :left
    when :left
      :up
    when :right
      :down
    else
      nil
    end
  end

  def handle_input input
    case input
    when /^poke/
      input = input.split(' ')
      x = input[1].to_i
      y = input[2].to_i

      if x >= 0 and x < @x and y >= 0 and y < @y
        poke_value = poke x, y
        "Poked #{x}, #{y}. New value: #{poke_value}."
      else
        "Invalid co-ordinates: x = #{x}, y = #{y}"
      end
    end
  end

  # "Pokes" a cell in the grid, either turning it on if it's off, rotating it if
  # it's on and turning it off if it is at the end of its rotation.
  def poke x, y
    case @grid[x][y].first
    when nil
      @grid[x][y][0] = :up
    when :up
      @grid[x][y][0] = :right
    when :down
      @grid[x][y][0] = :left
    when :left
      @grid[x][y] = []
    when :right
      @grid[x][y][0] = :down
    end
  end
end
