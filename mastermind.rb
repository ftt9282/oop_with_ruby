module Mastermind

class Gameplay
  def initialize
    @player_name = Player.new
    @board = Board.new
    @ai = AI.new
  end

  def start_game
  	winning_combination = @ai.winning_combination
    puts "This is Mastermind. I don't feel like explaining the rules. Start by selecting 4 colors seperated by spaces\n"
    puts "The colors you can choose from are: 'blue', 'green', 'orange', 'purple', 'red' and 'yellow'\n"
    puts "Choose your colors..."
    make_guesses(winning_combination)
  end

  def make_guesses(winning_combination)
    12.times do |index|
    	colors = gets.chomp
    	choose_colors(colors, index)
    	@board.show_board
    	puts @ai.winning_combination
    	exact, close = find_matches(colors, winning_combination)
    	if exact == 4
    		game_over
    	else 
    		puts "Looks like you got #{exact} exactly right and #{close} close guesses."
    	end
    	puts "\nChoose some more colors. " + (11-index).to_s + " turns left..."
    end
  end

  def choose_colors(colors, index)
  	color_array = colors.split
    @board.assign_row_colors(color_array, index)
  end

  def find_matches(guess, winner)
    exact, close = 0, 0
    match_hash = {}
    guess = guess.split
    guess.each_with_index do |c, i|
      match_hash[c] = winner.count(c) unless match_hash.key?(c)
      puts match_hash[c]
      if c == winner[i]
        exact += 1
        match_hash[c] -= 1
        if match_hash[c] < 0
        	close -= 1
        	match_hash[c] += 1
        end
      elsif winner.include? c
        close += 1 if match_hash[c] > 0
        match_hash[c] -= 1
      else
      end
    end
    return exact, close
  end

  def game_over
    puts "You win!! You win!!"
    exit
  end
end

class Player
  def initialize
  	@player_name = set_name
  end

  def set_name
  	print "Hi there. What is your name: "
  	a_name = gets.chomp
  	puts "Alright, #{a_name}. Let's begin.\n\n"
  	a_name
  end
end

class AI
  attr_reader :winning_combination
  
  def initialize
    @winning_combination = generate_winning_colors
  end

  def generate_winning_colors
    ai_color_hash = { 1 => 'blue', 2 => 'green', 3 => 'orange', 4 => 'purple', 5 => 'red', 6 => 'yellow' }
    winner = []
    4.times do
      winner << ai_color_hash[rand(1..6)]
    end
    winner
  end
end

class Board
  def initialize
  	@board = create_board
  end

  def show_board
  	print "==========\n"
    @board.each do |row|
      row.show_row
      print "\n"
    end
    print "==========\n"
  end

  def create_board
    board_array = []
      12.times do
      board_array << Row.new
    end
    board_array
  end

  def assign_row_colors(colors, row_num)
    colors.each_with_index do |color, index|
      @board[row_num].assign_peg_color(color.to_sym, index)
    end
  end
end

class Row
  @@color_hash = { :blue => 'B', :green => 'G', :orange => 'O', :purple => 'P', :red => 'R', :yellow => 'Y' }

  def initialize
    @row = create_row
  end

  def create_row
    row_array = []
    4.times do
      row_array << Peg.new
    end
    row_array
  end

  def show_row
  	@row.each do |peg|
      print peg.peg_color + "  "
    end
  end

  def assign_peg_color(color, index)
    @row[index].peg_color = @@color_hash[color]
  end
end

class Peg
  attr_accessor :peg_color

  def initialize
    @peg_color = '-'
  end
end

end

new_game = Mastermind::Gameplay.new
new_game.start_game