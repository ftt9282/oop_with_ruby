class Player
  @@total_players = 0
  attr_reader :player_name, :player_symbol

  def initialize(player_name)
    @player_name = player_name
    assign_letter
  end

  private

  def assign_letter
  	if @@total_players == 0
      @player_symbol = 'X'
    else
      @player_symbol = 'O'
    end
    @@total_players += 1
  end
end

class Board < Player
  @@move_count = 0
  attr_reader :move_count, :game_board

  def initialize
    @game_board = [['-','-','-'], ['-','-','-'], ['-','-','-']]
  end

  def show_winners
  	[ [@game_board[0][0], @game_board[0][1], @game_board[0][2]], [@game_board[1][0], @game_board[1][1], @game_board[1][2]], 
  	  [@game_board[2][0], @game_board[2][1], @game_board[2][2]], [@game_board[0][0], @game_board[1][1], @game_board[2][2]] ]
  end

  def show_board
  	puts "\n"
  	@game_board.each do |x|
  	  x.each do |y|
  	    print "#{y}  "
  	  end
  	  puts "\n"
  	end
  	puts "\n"
  end

  def check_if_empty(x, y)
  	return @game_board[x][y] == '-' ? true : false
  end

  def update_board(x, y, player)
  	@game_board[x][y] = player.player_symbol
  	@@move_count += 1
  end 
end

def gameplay(player1, player2)
  board = Board.new
  winner = false
  player_turn(player1, board)
  4.times do
    player_turn(player2, board)
    player_turn(player1, board)
  end
end

def player_turn(player, board)
  spot_taken = false
  while !spot_taken
  	x, y = process_move(player, board)
  	if board.check_if_empty(x, y)
  	  spot_taken = true
  	else
  	  puts "You picked a spot that was already taken. Try again."
  	end
  end
  board.update_board(x, y, player)
  board.show_board
  if check_for_winner(board)
  	puts "#{player.player_name} wins!!!"
  	exit
  end
end

def check_for_winner(board)
  winning_combos = board.show_winners

  winning_combo_string = winning_combos.join
  is_winner = /XXX|OOO/.match(winning_combo_string)
  is_winner
end

def process_move(player, board)
  possible_moves = { :top => 0, :center => 1, :bottom => 2, :left => 0, :middle => 1, :right => 2 }
  puts "#{player.player_name}'s turn. Choose a move"
  begin
  	text_move = gets.chomp
    vertical, horizontal = /^(top|center|bottom)[- ]?(left|middle|right)$/.match(text_move).captures
  rescue StandardError
  	puts "Error. That was not a valid entry. Try again."
  	retry
  else
  	return [possible_moves[vertical.to_sym], possible_moves[horizontal.to_sym]]
  end
end

puts "Player 1. What is your name?"
player1 = Player.new(gets.chomp)
puts "Player 2. What is your name?"
player2 = Player.new(gets.chomp)
gameplay(player1, player2)