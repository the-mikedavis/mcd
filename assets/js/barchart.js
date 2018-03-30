export default function () {
  var svg = d3.select("svg#barchart"),
    margin = {top: 20, right: 20, bottom: 30, left: 50},
    true_width = svg.node().getBoundingClientRect().width,
    height = true_width / 2,
    width = true_width - margin.right - margin.left;

  const colors = {
    "Java": "#b07219",
    "C": "#555555",
    "C++": "#f34b7d",
    "Python": "#3572A5",
    "HTML": "#e34c26",
    "JavaScript": "#f1e05a",
    "CSS": "#563d7c",
    "Shell": "#89e051",
    "Clojure": "#db5855",
    "Elixir": "#6e4a7e"
  };

  svg.attr('height', height);

  height = height - margin.top - margin.bottom;

  var parseDate = d3.timeParse("%Y %b %d");

  var x = d3.scaleTime().range([0, width]),
    y = d3.scaleLinear().range([height, 0]);

  var stack = d3.stack();

  var area = d3.area()
    .curve(d3.curveMonotoneX)
    .x(function(d, i) { return x(d.data.date); })
    .y0(function(d) { return y(d[0]); })
    .y1(function(d) { return y(d[1]); });

  var g = svg.append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  d3.csv("/data/languages.csv", type, function(error, data) {
    if (error) throw error;

    var keys = data.columns.slice(1);

    x.domain(d3.extent(data, function(d) { return d.date; }));
    stack.keys(keys);

    var layer = g.selectAll(".layer")
      .data(stack(data))
      .enter().append("g")
      .attr("class", "layer")
      .attr('title', function(d) { return d.key; });

    layer.append("path")
      .attr("class", "area")
      .style("fill", function(d) { return colors[d.key]; })
      .attr("d", area);

    layer.filter(function(d) { return d[d.length - 1][1] - d[d.length - 1][0] > 0.01; })
      .append("text")
      .attr("x", width - 6)
      .attr("y", function(d) { return y((d[d.length - 1][0] + d[d.length - 1][1]) / 2); })
      .attr("dy", ".35em")
      .style("font", "10px sans-serif")
      .style("text-anchor", "end")
      .text(function(d) { return d.key; });

    g.append("g")
      .attr("class", "axis axis--x")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x));

    g.append("g")
      .attr("class", "axis axis--y")
      .call(d3.axisLeft(y).ticks(10, "%"));
  });

  function type(d, i, columns) {
    d.date = parseDate(d.date);
    for (var i = 1, n = columns.length; i < n; ++i) d[columns[i]] = d[columns[i]] / 100;
    return d;
  }
}
