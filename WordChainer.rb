require 'set'
require 'byebug'
class WordChainer
    attr_reader :dict

    def adjacent_words(word)
        adjacent_words = []
        word.each_char.with_index do |old_letter, idx|
            ('a'..'z').each do |new_letter|
                next if old_letter == new_letter
                new_word = word[0...idx] + new_letter + word[idx + 1..-1]
                adjacent_words << new_word if dict.include?(new_word)
            end
        end
        adjacent_words
    end
    
    def initialize(dictionary_file_name)
        @dict = Set.new
        File.open(dictionary_file_name, 'r').each { |word| @dict << word.chomp }
    end

    def run(source, target)
        @current_words = [source]
        @all_seen_words = { source => nil}

        get_related_words(target)
        puts build_path(target)
    end

    def get_related_words(target)
        until @current_words.empty? || @all_seen_words.include?(target)
            new_current_words = []

            @current_words.each do |current_word|
                new_current_words += explore_current_words(current_word)
            end

            @current_words = new_current_words
        end
    end

    def explore_current_words(current_word)
        new_current_words = []
        adjacent_words(current_word).each do |adj_word|
            if !@all_seen_words.include?(adj_word)
                new_current_words << adj_word
                @all_seen_words[adj_word] = current_word
            end
        end
        new_current_words
    end

    def build_path(target)
        path = [target]
        until @all_seen_words[target] == nil
            path.unshift(@all_seen_words[target])
            target = @all_seen_words[target]
        end
        path
    end

end

if __FILE__ == $PROGRAM_NAME
    word_chain = WordChainer.new("dictionary.txt")
    word_chain.run("rail", "ruby")
end