describe Jarvis::Generators::Otomata do
  before :each do
    @generator = Jarvis::Generators::Otomata.new
  end

  after :each do
    @generator = nil
  end

  it 'should respond to poke' do
    @generator.poke 1, 1
    @generator.grid[1][1].should == [:up]

    @generator.poke 1, 1
    @generator.grid[1][1].should == [:right]

    @generator.poke 1, 1
    @generator.grid[1][1].should == [:down]

    @generator.poke 1, 1
    @generator.grid[1][1].should == [:left]

    @generator.poke 1, 1
    @generator.grid[1][1].should == []
  end

  it 'should move up properly' do
    @generator.poke 1, 1
    @generator.next
    @generator.grid[1][0].should == [:up]
  end

  it 'should move right properly' do
    @generator.poke 1, 1
    @generator.poke 1, 1
    @generator.next
    @generator.grid[2][1].should == [:right]
  end

  it 'should move down properly' do
    @generator.poke 1, 1
    @generator.poke 1, 1
    @generator.poke 1, 1
    @generator.next
    @generator.grid[1][2].should == [:down]
  end

  it 'should move left properly' do
    @generator.poke 1, 1
    @generator.poke 1, 1
    @generator.poke 1, 1
    @generator.poke 1, 1
    @generator.next
    @generator.grid[0][1].should == [:left]
  end

  it 'should change direction when something hits a wall' do
    @generator.poke 1, 1
    @generator.next
    @generator.next
    @generator.grid[1][1].should == [:down]
  end

  it 'sould respond properly to collisions' do
    # This is hard to visualise but what I'm trying to test for is the following
    # three moves:
    #
    # +-+-+-+ +-+-+-+ +-+-+-+
    # | |V| | | | | | | | | |
    # +-+-+-+ +-+-+-+ +-+-+-+
    # |>| | | | |O| | |<| | |
    # +-+-+-+ +-+-+-+ +-+-+-+
    # | | | | | | | | | |V| |
    # +-+-+-+ +-+-+-+ +-+-+-+
    @generator.poke 1, 0
    @generator.poke 1, 0
    @generator.poke 1, 0

    @generator.poke 0, 1
    @generator.poke 0, 1

    @generator.next
    @generator.next

    @generator.grid[0][1].should == [:left]
    @generator.grid[1][2].should == [:down]
  end
end
