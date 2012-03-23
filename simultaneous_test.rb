require 'unimidi'

notes = [
  [34, 36, 38],
  [36, 38, 40],
  [34, 36, 38],
  [36, 38, 40]
]

o = UniMIDI::Output.first

o.open do |o|
  notes.each do |notes|
    notes.each do |note|
      o.puts 0x90, note, 100
    end

    sleep(0.5)

    notes.each do |note|
      o.puts 0x80, note, 100
    end
  end
end
