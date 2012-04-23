require 'json'

module Jarvis::Generators
  class MarkovChains < NoteGenerator
    DEFAULT_NDB = Jarvis::ROOTDIR + '/data/db2.ndb'

    def initialize path = DEFAULT_NDB, lookahead = 0
      @data      = JSON.parse File.open(path) { |file| file.read }
      @lookahead = lookahead
      @prev_notes = []
    end

    def next
      data = @data
      @lookahead.times do |i|
        if @prev_notes.length > i and data.keys.include? @prev_notes[i]
          data = data[@prev_notes[i]]["next"]
        end
      end

      node = select_random_node data

      # Get a random number between 0 and the sum of all of the durations in the
      # random node selected above.
      r = rand(sum_durations(node))
      d = node[1]['durations'].each

      # Loop through all of the durations in the node and subtract the number of
      # times that duration has occurred from the random number generated above.
      #
      # Similar to the above loop, this is just a way of selecting a random
      # duration from the selected node.
      duration = loop do
        n  = d.next
        r -= n[1]

        if r <= 0
          break n[1]
        end
      end

      # Add the last note to top of the previous notes and pop the oldest note
      # off if our array is greater than the lookahead.
      @prev_notes.unshift(node[0])
      @prev_notes.pop if @prev_notes.length > @lookahead

      # Because durations are not specified in midi time pulses in the note
      # database file, we need to divide the number by something. 10 sound good
      # to me.
      Jarvis::Note.new create_notes(node[0]), duration / 10.0
    end

    # Selects a random node from a Hash based on the contents of the 'counts'
    # member on the has. Don't use this on any old hash, it need to be a hash in
    # the same format as what is created by the learnsong executable.
    #
    # The return value will be an array of two parts:
    #
    # [node_key, node_value]
    def select_random_node nodes
      # Get a random number between 0 and the sum of all counts in the note
      # database file specified to the constructor.
      r = rand sum_counts(nodes)
      d = nodes.each

      # Loop through the JSON nodes and subtract the count in that node from the
      # random number generated above. If the random number falls below 0,
      # return this node.
      #
      # This is basically just a method of selecting a random node from the note
      # database file.
      return loop do
        n  = d.next
        r -= n[1]['count']

        if r <= 0
          break n
        end
      end
    end

    # Because chords are represented as string of comma separated integers in
    # the Markov Chain note data format, this function will split them and
    # convert it into an actual array of integers.
    def create_notes note_string
      note_string.split(',').map { |n| n.to_i }
    end

    # Returns the sum of the 'count' elements in each data entry in the
    # @data hash. Essentially this is returning the total number of notes
    # in all of the scanned songs in the given note database.
    def sum_counts data = @data
      sum = 0

      data.each do |key, value|
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
end
