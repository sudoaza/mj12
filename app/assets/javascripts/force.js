

var width = $(window).width() - 30,
    height = $(window).height() - 100;

var color = d3.scale.category20();

var force = d3.layout.force()
    .charge(-60)
    .linkDistance(20)
    .size([width, height]);

var svg = d3.select("#chart").append("svg")
    .attr("width", width)
    .attr("height", height);

d3.json("/map.json", function(json) {

// Calcular la cantidad de links de cada nodo
// Ver node.attr("r")
  var links = [];
  json.links.forEach(function(l) {
    if (typeof(links[l.target]) == "undefined") links[l.target] = 0;
    if (typeof(links[l.source]) == "undefined") links[l.source] = 0;

    links[l.target]++;
    links[l.source]++;
  });

  force
      .nodes(json.nodes)
      .links(json.links)
      .start();

  var tip = d3.tip().attr('class', 'd3-tip').html(function(d) {
    return d.name+' con '+links[d.index]/2+' enlaces';
  });

  svg.call(tip);

  var link = svg.selectAll("line.link")
      .data(json.links)
    .enter().append("line")
      .attr("class", "link");

  var node = svg.selectAll("circle.node")
      .data(json.nodes)
    .enter().append("circle")
      .attr("class", "node")
      .attr("r", function(d) { return Math.log(links[d.index]) * 4 + 3; })
      .style("fill", function(d) { return color(d.weight); })
      .call(force.drag)
      .on('mouseover', tip.show)
      .on('mouseout', tip.hide);

  node.append("title")
      .text(function(d) { return d.name; });

  force.on("tick", function() {
    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    node.attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; });
  });
});

