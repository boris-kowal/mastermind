require 'pry'

class Game
  attr_accessor :list_solution

  def initialize
    @clue = []
    @count = 0
    @counter = 0
    @computer_code = 1122
    @list_solution = Array.new(5556, 1111)
    @list_solution.each_with_index { |element, index| @list_solution[index] = element + index }
  end

  def play
    puts "Welcome to mastermind! You can chose to guess computer code(Code breaker) or make the computer do the work!"
    puts "Number to guess is 4 digits, and each digit can be from 1 to 6"
    puts "X means that one digit is the correct number and at the correct place"
    puts "O means that the digit is the correct number but is at a wrong place"
    puts "------------------------------------"
    puts 'Do you want to be code maker or the code breaker?'
    puts 'Press 1 to be code maker'
    puts 'Press 2 to be code breaker'
    choice = gets.chomp
    if choice == '1'
      computer_play
    elsif choice == '2'
      human_play
    else
      puts "Please enter a valid choice"
      play
    end
  end

  def retry?
    puts "Do you want to play again? Y/N"
    input = gets.chomp.downcase
    if input == "y"
      initialize
      play
    elsif input == "n"
      puts 'Thank you!'
    else
      puts "Please enter valid choice"
      retry?
    end
  end

  def computer_code
    @computer_code = []
    4.times { @computer_code.push(rand(1..6)) }
    @computer_code = @computer_code.join.to_i
  end

  def get_player_code
    puts 'Type in 4 numbers from 1 to 6'
    input = gets.chomp
    while input.length != 4 || input.split('').any? { |num| num.to_i > 6 || num.to_i < 1 }
      puts 'Please enter valid number'
      input = gets.chomp
    end
    @player_code = input.to_i
  end

  def compare_code(code1, code2)
    tempo_clue = []
    code1.digits.reverse.each_index do |i|
      if code2.digits.reverse[i] == code1.digits.reverse[i]
        tempo_clue.unshift('X')
      elsif code2.digits.reverse.include?(code1.digits.reverse[i])
        tempo_clue.push('O')
      else
        next
      end
    end
    tempo_clue
  end

  def check_end(player)
    if @clue == %w[X X X X]
      puts "#{player}won!"
      retry?
    else
      puts 'Time out! Try again!'
      retry?
    end
  end

  def human_play
    computer_code
    while @clue != %w[X X X X] && @count < 12
      get_player_code
      @clue = compare_code(@player_code, @computer_code)
      @count += 1
      print "#{@player_code} | #{@clue}\n"
    end
    check_end('You ')
  end

  def computer_play
    get_player_code
    while @clue != %w[X X X X] && @count < 12
      computer_guess
      @clue = compare_code(@player_code, @computer_code)
      @count += 1
      @counter += 1
      print "#{@computer_code} | #{@clue}\n"
      sleep 1
    end
    check_end('Computer ')
  end

  def computer_guess
    if @counter.zero?
      @computer_code
    else
      @list_solution.delete_if { |element| compare_code(element, @computer_code) != @clue }
      @computer_code = @list_solution[0]
    end
  end
end

new_game = Game.new
new_game.play
