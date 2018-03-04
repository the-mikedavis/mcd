export default function () {
  const svg = d3.select('svg#barchart'),
    margin = window.margin || {left: 40, right: 20, top: 20, bottom: 30};

  let lang_data;

  function render(data) {

    if (data === undefined)
      data = lang_data;

    const largest = Math.max.apply(Math, data.map(e => e.time));

    svg.selectAll('*').remove();
    lang_data = data;

    // sizing stuff
    let height = svg.node().getBoundingClientRect().width,
      width;

    svg.attr('height', height);

    width = height - margin.right - margin.left;
    height = height - margin.top - margin.bottom;

    let x = d3.scaleBand().rangeRound([0, width]).padding(0.1),
      y = d3.scaleLinear().rangeRound([height, 0]),
      g = svg.append('g')
        .attr('transform', `translate(${margin.left},${margin.top})`);

    x.domain(data.map(function (e) {
      return width > 500 ? e.name : e.alias || e.name;
    }));
    y.domain([0, largest]);

    g.append('g')
      .attr('class', 'axis xaxis')
      .attr('transform', `translate(0,${height})`)
      .call(d3.axisBottom(x));

    g.append('g')
      .attr('class', 'axis yaxis')
      .call(d3.axisLeft(y).ticks(5));

    g.selectAll('rect.bar')
      .data(data)
      .enter()
      .append('rect')
      .classed('bar', true)
      .attr('x', d => x(width > 500 ? d.name : d.alias || d.name))
      .attr('y', d => y(d.time))
      .attr('width', x.bandwidth())
      .attr('height', d => height - y(d.time))
      .attr('stroke', '#000')
      .attr('stroke-width', 1)
      .style('fill', d => d.color || "#000");
  }

  d3.json('/json/linguae.json', render);

  let timer;
  window.onresize = function() {
    clearTimeout(timer);
    timer = setTimeout(render, 100);
  };
}
