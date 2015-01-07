
class CategoricalSpendingReport

  def initialize(category)
    @category = category
  end

  def groups
    data.map {|r| Group.new(r) }
  end

  def monthly_average
    groups.map(&:cents).sum.to_f / groups.length
  end

private
  attr_reader :category

  def data
    @data ||= ActiveRecord::Base.connection.execute <<-EOS
      select 
        extract(month from date) as month, 
        extract(year from date) as year, 
        sum(cents) as cents 
      from
        transactions 
      where
        category_id = #{category.id}
      group by 
        extract(year from date), 
        extract(month from date)
      order by
        extract(year from date),
        extract(month from date)     
    EOS
  end

  class Group < Struct.new(:year, :month, :cents)
    def initialize(row)
      super *row.values_at("year", "month", "cents").map(&:to_i)
    end

    def start_of_period
      Time.local(year, month, 1)
    end

    def end_of_period
      start_of_period.at_end_of_month
    end
  end
end