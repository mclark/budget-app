
class window.MoneyTimeBarPlot
  month = d3.time.format("%b")
  monthYear = d3.time.format("%b %Y")
  money = (x) -> accounting.formatMoney(x)
  
  constructor: (options) ->
    @url = options.url

    @width = options.dimensions.width
    @height = options.dimensions.height
    @margin = options.dimensions.margin

    @svg = d3.select options.parent
             .append "svg"
             .attr "width", @width + @margin.left + @margin.right
             .attr "height", @height + @margin.top + @margin.bottom
             .append "g"
             .attr "transform", "translate(#{@margin.left},#{@margin.top})"

    @x_scale = d3.time.scale().range([20, @width - 20])

    @y_scale = d3.scale.linear().range([0, @height])

    @x_axis = d3.svg.axis()
                    .scale @x_scale
                    .orient "bottom"
                    .ticks d3.time.month, 1
                    .tickFormat month

    @y_axis = d3.svg.axis()
                    .scale @y_scale
                    .orient "left"
                    .tickFormat money

    @tip = d3.tip()
             .attr "class", "d3-tip"
             .offset [-10, 0]
             .html (d) -> "<strong>#{monthYear(d.month)}:</strong> <span style='color:red'>#{money(d.net)}"

    @svg.call(@tip)

  fetch: ->
    d3.csv @url
      .row (d) -> month: new Date(Number(d.month)), net: Number(d.net)
      .get (err, data) => @render(data)

  render: (data) ->
    make_x_axis = =>
      d3.svg.axis().scale(@x_scale).orient("bottom").ticks(6)

    make_y_axis = =>
      d3.svg.axis().scale(@y_scale).orient("left").ticks(10)

    x_extent = d3.extent(data, (d) -> d.month)
    y_extent = d3.extent(data, (d) -> d.net).reverse()

    @x_scale.domain(x_extent)
    @y_scale.domain(y_extent).nice()

    @svg.append "g"
        .attr "class", "grid"
        .attr "transform", "translate(0,#{@height})"

    @svg.append "g"
        .attr "class", "grid"
        .attr "transform", "translate(0,#{@height})"
        .call make_x_axis().tickSize(-@height, 0, 0).tickFormat("")

    @svg.append "g"
        .attr "class", "grid"
        .call make_y_axis().tickSize(-@width, 0, 0).tickFormat("")

    @svg.selectAll ".bar"
        .data data
        .enter()
          .append("rect")
          .attr "class", (d) -> if d.net < 0 then "bar negative" else "bar positive"
          .attr "x", (d) => @x_scale(d.month) - 20
          .attr "y", (d) => @y_scale(Math.max(0, d.net))
          .attr "width", 40
          .attr "height", (d) => Math.abs(@y_scale(d.net) - @y_scale(0))
          .on "mouseover", @tip.show
          .on "mouseout", @tip.hide

    @svg.append "g"
        .attr "class", "x axis"
        .attr "transform", "translate(0,#{@y_scale(0)})"
        .call @x_axis

    @svg.append("g")
        .attr "class", "y axis"
        .call @y_axis

    null