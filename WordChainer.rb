require 'set'
require 'byebug'
class WordChainer
    def adjacent_words(word)
        @dict.select { |term| word.length == term.length && is_one_letter_different?(word, term) }
    end

    def is_one_letter_different?(word1, word2)
        count = 0
        word2.each_char.with_index { |char, idx| count += 1 if char != word1[idx] }
        count == 1
    end
    
    def initialize(dictionary_file_name)
        @dict = Set.new
        File.open(dictionary_file_name, 'r').each { |word| @dict << word.chomp }
        @current_words = []
        @all_seen_words = {}
    end

    def run(source, target)
        @current_words << source
        @all_seen_words[source] = nil

        until @current_words.empty? || @all_seen_words.include?(target)
            new_current_words = []

            @current_words.each do |current_word|
                new_current_words += explore_current_words(current_word)
            end

            # new_current_words.each { |word| print "#{@all_seen_words[word]}: #{word}    "}
            @current_words = new_current_words
        end

        puts build_path(target)

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