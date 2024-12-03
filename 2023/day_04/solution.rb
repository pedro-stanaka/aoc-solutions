def card_value(card)
  winning_numbers, my_numbers = card.split(' | ').map { |part| part.split.map(&:to_i) }
  matched_numbers = my_numbers & winning_numbers
  matched_numbers.empty? ? 0 : 2**(matched_numbers.size - 1)
end

def total_card_value(cards)
  cards.map { |card| card_value(card) }.sum
end

cards = File.readlines('input_part_1.txt').map do |line|
  line.split(':').last.chomp
end

puts total_card_value(cards)