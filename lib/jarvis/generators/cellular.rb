require 'colored'

module Jarvis::Generators
  class CellularAutonoma < NoteGenerator
    def initialize density = 0.4
      # Construct the "world" grid (16x12)
      @grid   = generate_grid 16, 8, density
      # Index for the counting of columns across
      @index  = 0
      @scale  = Jarvis::Scale.c_minor
      @length = Jarvis::Note::QUARTER
    end

    # Generates the next iteration of the given grid. If no grid is passed in as
    # an argument, the instance's grid is used.
    #
    # The next iteration of the grid is returned and the original grid passed in
    # remains the same as it was before the method call.
    def next_generation grid = @grid
      new_grid = generate_grid

      grid.each_index do |y|
        grid[y].each_index do |x|
          if grid[y][x]
            # Any live cell with fewer than two live neighbours dies
            if alive_neighbours(x, y) < 2
              new_grid[y][x] = false
              # Any live cell with greater than 3 neighbours dies
            elsif alive_neighbours(x, y) > 3
              new_grid[y][x] = false
            end
          else
            # Any dead cell with exactly three neighbours becomes populated
            if alive_neighbours(x, y) == 3
              new_grid[y][x] = true
            end
          end
        end
      end

      return new_grid
    end

    # Does the same as the next_generation method but overwrites the current
    # instance's grid with the new iteration instead of leaving it untouched.
    def next_generation!
      @grid = next_generation
    end

    # Generates an arbitrary sized grid of boolean values that will represent the
    # grid for the Game of Life rules. True means alive, false means dead.
    #
    # The x and y arguments, first and second respectively, represent the
    # dimensions of the grid. The third argument, density, refers to how densely
    # populated the grid will be. This is a number between 0 and 1.
    def generate_grid x = 16, y = 8, density = 0
      new_grid = []

      y.times { new_grid << [] }
      new_grid.each do |array|
        x.times do
          if rand < density
            array << true
          else
            array << false
          end
        end
      end
    end

    # Calculates the number of "alive" cells around a specific cell in the grid.
    #
    # Example:
    #
    #   Take the following grid:
    #
    #   +-+-+-+
    #   |#| |#|
    #   +-+-+-+
    #   | |#| |
    #   +-+-+-+
    #   | | | |
    #   +-+-+-+
    #
    #   alive_neighbours 0, 0
    #   #=> 1
    #
    #   alive_neighbours 2, 0
    #   #=> 2
    def alive_neighbours x, y, grid = @grid
      count = 0
      x_max = grid.first.length - 1
      y_max = grid.length - 1

      count += 1 if x > 0     and y > 0     and grid[y-1][x-1]
      count += 1 if y < y_max and x > 0     and grid[y+1][x-1]
      count += 1 if y > 0     and x < x_max and grid[y-1][x+1]
      count += 1 if x < x_max and y < y_max and grid[y+1][x+1]
      count += 1 if y > 0     and               grid[y-1][x]
      count += 1 if x > 0     and               grid[y][x-1]
      count += 1 if x < x_max and               grid[y][x+1]
      count += 1 if y < y_max and               grid[y+1][x]

      return count
    end

    # Pretty prints a 2 dimensional grid of boolean values.
    #
    # Example:
    #
    #   grid = [[true, false], [false, true]]
    #   print_grid grid
    #   #=> +-+-+
    #       |#| |
    #       +-+-+
    #       | |#|
    #       +-+-+
    #
    # This method will highlight the current column that is being pointed at by
    # the @index instance variable. i.e. the next column that will be returned by
    # the next method.
    def print_grid grid = @grid
      puts (('+-' * grid.first.length) + '+').black
      grid.each do |row|
        row.each_with_index do |cell, index|
          if index == @index
            print '|'.black
            print cell ? '#'.blue : ' '
          else
            print '|'.black
            print cell ? '#' : ' '
          end
        end
        print '|'.black
        puts ("\n" + ('+-' * row.length) + '+').black
      end
    end

    # Uses the instance's @grid variable to return an array of notes. The notes
    # will be decided by the y coordinate of the position on the grid being used
    # as an index to the @scale array in this instance.
    #
    # An empty array represents a column on the grid consisting entirely of dead
    # cells.
    #
    # All notes will have the same duration, represented by the @length instance
    # variable.
    def next
      note = Jarvis::Note.new
      note.notes = []
      note.duration = @length

      @grid.each_with_index do |item, index|
        note.notes.push @scale[index] if item[@index] == true
      end

      print_grid

      if @index == @grid.first.length - 1
        next_generation!
      end

      @index = (@index + 1) % @grid.first.length

      note
    end
  end
end
