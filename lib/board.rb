class Board
  attr_accessor :cups
  attr_reader :name1, :name2

  SIDE1_INDICES = (0..5).to_a
  SIDE2_INDICES = (7..12).to_a
  CUP_INDICES = SIDE1_INDICES + SIDE2_INDICES
  

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
    @cups = Array.new(14) {[]}    
    self.place_stones
  end

  def place_stones
    CUP_INDICES.each {|index| @cups[index] = [:stone] * 4}
  end

  def valid_move?(start_pos)
    raise 'Invalid starting cup' if !CUP_INDICES.include?(start_pos)
    raise 'Starting cup is empty' if cups[start_pos].empty?
  end

  def make_move(start_pos, current_player_name)
    current_player_store_pos = current_player_name == name1 ? 6 : 13
    opponent_store_pos = current_player_name == name1 ? 13 : 6
    number_of_stones = @cups[start_pos].length
    @cups[start_pos] = []
    current_pos = start_pos
    until number_of_stones == 0
      current_pos = (current_pos + 1) % 14
      if current_pos != opponent_store_pos
        @cups[current_pos] += [:stone]
        number_of_stones -= 1
      end
    end
    ending_cup_idx = current_pos
    self.render
    next_turn(ending_cup_idx, current_player_store_pos)
  end

  def next_turn(ending_cup_idx, current_player_store_pos)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if ending_cup_idx == current_player_store_pos
      :prompt
    elsif cups[ending_cup_idx].length == 1
      :switch
    else
      ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    SIDE1_INDICES.all? {|index| cups[index].empty?} || SIDE2_INDICES.all? {|index| cups[index].empty?}
  end

  def winner
    case cups[6] <=> cups[13]
    when 1
      name1
    when -1
      name2
    when 0
      :draw
    end
  end
end
