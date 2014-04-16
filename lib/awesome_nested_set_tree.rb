
class AwesomeNestedSetTree
  include Enumerable

  def self.from_nodes(nodes)
    by_id = Hash[ nodes.map {|n| [n.id, n] } ]

    populate = -> (n) { nodes.select {|c| c.parent_id == n.node.id }.map {|c| x = Container.new(c, n, nil); x.children = populate.call(x); x } }

    roots = nodes.reject {|n| by_id.keys.include?(n.parent_id) }.map {|n| x = Container.new(n, nil, nil); x.children = populate.call(x); x }

    new(roots: roots)
  end

  attr_reader :roots

  def initialize(roots: [])
    @roots = roots
  end

  def each
    return to_enum(:each) unless block_given?

    visit = -> (n) { yield(n); n.children.each {|c| yield(c) } }

    @roots.each {|n| visit.call(n) }
  end

private
  Container = Struct.new(:node, :parent, :children) do
    def root?
      parent == nil
    end

    def leaf?
      children.length == 0
    end

    def ancestors
      result = [self]
      result << result.last.parent while result.last.parent
      result
    end

    def inspect
      type = if root?
        "Root"
      elsif leaf?
        "Leaf"
      else
        "Container"
      end

      "<#{type}: (#{children.length} children)>"
    end

    alias :to_s :inspect
    alias :to_str :inspect
  end

end