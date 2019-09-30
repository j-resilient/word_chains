require 'set'
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
        @all_seen_words = []
    end

    # def run(source, target)
    #     @current_words << source
    #     @all_seen_words << source

    #     until @current_words.empty?
    #         new_current_words = []

    #     end
    # end
end

if __FILE__ == $PROGRAM_NAME
    x = WordChainer.new("dictionary.txt")
    puts x.adjacent_words("cat")
end