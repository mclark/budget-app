require 'awesome_nested_set_tree'

module ApplicationHelper

  def review_count
    @review_count ||= ImportableAccount.not_imported.count + ImportableTransaction.not_imported.count
  end

  def transactions_count
    @transactions_count ||= Transaction.count
  end

  def cents_to_dollars(cents)
    if cents
      (cents / 100.0).round(2)
    else
      0.00
    end
  end  

  def page_header(header="")
    content_tag(:div, class: "page-header") do
      content_tag(:h1, header)
    end
  end

  def grouped_options_for_income_and_expenses(selected=nil)
    categories = [Category.income, Category.expense].map(&:self_and_descendants).map(&:to_a).flatten
    grouped_options_for_categories(categories, selected)
  end

  def grouped_options_for_categories(categories, selected=nil)
    result = ""
    selected = selected.try(:to_i)

    visit = lambda do |elem|
      if elem.root?
        result << "<optgroup label='#{h elem.node.name}'>"
        elem.children.sort_by {|c| c.node.name }.each {|c| visit.call(c) }
        result << "</optgroup>"
      elsif elem.leaf?
        name = elem.ancestors[0..-2].map(&:node).map(&:name).join(" - ")
        value = elem.node.id
        is_selected = elem.node.id == selected ? "selected" : nil
        result << content_tag(:option, name, value: value, selected: is_selected)
      end
    end

    AwesomeNestedSetTree.from_nodes(categories).roots.each {|r| visit.call(r) }

    result.html_safe
  end

end
