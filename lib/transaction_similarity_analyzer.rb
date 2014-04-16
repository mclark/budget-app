
class TransactionSimilarityAnalyzer

  def initialize(transaction, minimum_similarity: 0.75, results: 5, benchmark: false)
    @transaction = transaction
    @results = results
    @benchmark = benchmark
    @minimum_similarity = minimum_similarity
  end

  def best_category
    results = call()

    #TODO: take frequency of the results and decide most likely single result
    if results.length > 0
      Category.find(results.first)
    else
      nil
    end
  end

  def call
    escaped_description = ActiveRecord::Base.sanitize(transaction.description)

    txns = Transaction.select(:category_id, "levenshtein(description, #{escaped_description}) as distance")
                      .order("distance asc")
                      .limit(results)

    txns.reject {|t| t.distance.to_i > minimum_distance}.map(&:category_id)
  end

private
  attr_reader :transaction, :results, :benchmark, :minimum_similarity

  def minimum_distance
    (minimum_similarity * transaction.description.length).round
  end

end