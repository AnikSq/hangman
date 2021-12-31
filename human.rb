class Hangman
    attr_reader :word ,:guess_word
    def initialize(name)
        @name = name
        @word = File.readlines("word_list.txt").sample.chomp.downcase
        until @word.length > 4 && @word.length < 13
            @word = File.readlines("word_list.txt").sample.chomp.downcase
        end
        @count = 12
        @guess_word = ""
        length = @word.length
        length.times do 
            @guess_word+=" "
        end
        @incorrect_words = []
    end


    
    def playing_game
        saying
        puts "To save game press 1"
        puts "To load last save press 2"
        until @count == 0 || @guess_word == @word
            save_game
            load_game
            ask_player
            check_word_include
            show_chars
            win
            lose
        end
    end


    
    def save_game
        require 'yaml'
        if @player_input == '1'
            @save = {'name'=>@name,'word'=>@word,'count'=>@count,'guess_word'=>@guess_word,'incorrect_words'=>@incorrect_words}
            output = File.new('prefs.yml','w')
            output.puts YAML.dump(@save)
            output.close
        end
    end

    def load_game
        require 'yaml'
        if @player_input == '2' 
            output = File.new('prefs.yml','r')
            @save = YAML.load(output.read)
            output.close
            @name = @save['name']
            @word = @save['word']
            @count = @save['count']
            @guess_word = @save['guess_word']
            @incorrect_words = @save['incorrect_words']
        end
    end

    def show_chars
        puts "Your incompleted word is "
        puts "||--------------||"
        puts "||--------------||"
        puts "||#{@guess_word}"
        puts "||--------------||"
        puts "||--------------||"
        puts "You have #{@count} chances left"
    end

    def win
        if @guess_word == @word
            puts "The word to guess was #{word}"
            puts "Your completed word is #{@guess_word}"
            puts "Ho Ho Ho, You are indeed very knowledgeable #{@name}"
        end
    end

    def lose
        if @count == 0 
            puts "You Screwed up , TLDR: You lost"
            puts "Don't worry too much, play again"
        end
    end

    def ask_player
        all_chars = ('a'..'z').to_a
        all_chars.push('1')
        all_chars.push('2')
        @player_input = gets.chomp.downcase
        until @player_input.length == 1 && all_chars.include?(@player_input)
            puts "You need to enter a single character between a and z"
            @player_input = gets.chomp.downcase
        end
    end


  

    def check_word_include
        if @word.include?(@player_input)
            index = 0
            i = 0
            index_list = []
            while i < @word.length
               if @player_input == @word[i] && @guess_word[i] == " "
                index = i
                index_list.push(index)
               end
               i+=1
            end
            if @guess_word[index] == " "
                @guess_word[index] = @player_input
                puts "Ho Ho, Right Word guessed"
            else
                puts "That place is already taken"
            end
        elsif @player_input == '1' || @player_input == '2'
            puts "Okay"
        else
            puts "Wrong word , wrong word"
            @count -=1
            @incorrect_words << @player_input
            puts "For reference here are the wrong words"
            puts "You've already entered #{@incorrect_words}"
        end
    end

    def saying
        puts "Hello #{@name} , How's your day today."
        sleep 0.3
        puts "Since now , you've come to play hangman ho ho ho"
        sleep 0.5
        puts "Let's see if you will win a game of Hangman"
    end
end

not_hang = Hangman.new("Anik")
not_hang.playing_game
