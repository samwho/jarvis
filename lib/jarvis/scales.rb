module Jarvis
  class Scale
    include Notes

    def self.c_major
      [C2, D2, E2, F2, G2, A2, B2, C3]
    end

    def self.c_minor
      [C2, D2, Eb2, F2, G2, Ab2, Bb2, C3]
    end
  end
end
