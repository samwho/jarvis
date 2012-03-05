require 'json'

class MarkhovChains
  def initialize path = 'note-database.ndb', lookahead = 0
    @data      = JSON.parse File.open(path) { |file| file.read }
    @lookahead = 0
  end

  def next
    r = rand sum_counts
    d = @data.each

    node = loop do
      n  = d.next
      r -= n[1]['count']

      if r <= 0
        break n
      end
    end

    r = rand(sum_durations(node))
    d = node[1]['durations'].each

    duration = loop do
      n  = d.next
      r -= n[1]

      if r <= 0
        break n[1]
      end
    end

    Note.new node[0].to_i, duration / 100.0
  end

  def handle_input input

  end

  # Returns the sum of the 'count' elements in each data entry in the
  # @data hash. Essentially this is returning the total number of notes
  # in all of the scanned songs in the given note database.
  def sum_counts
    sum = 0

    @data.each do |key, value|
      sum += value['count']
    end

    return sum
  end

  # Takes a node from the JSON data and sums up the duration occurence
  # counts.
  def sum_durations node
    sum = 0

    node[1]['durations'].each do |key, value|
      sum += value
    end

    return sum
  end
end
