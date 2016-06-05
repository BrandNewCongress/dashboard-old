(function(window) {
  var loadMetricPoints = function (metric) {
    var figCont = $('<div class="fig-cont col-md-6"></div>');
    $('<h2>' + metric.name + '</h2>').appendTo(figCont);
    $('<h5>' + (metric.description || '') + '</h5>').appendTo(figCont);
    var fig = $('<figure style="height: 400px;"></figure>').appendTo(figCont);
    figCont.appendTo($('#chart-cont'));

    $.getJSON('/metric_points/' + metric.id, function (series) {
      var opts = {
        // ID of the element in which to draw the chart.
        element: fig,
        // Chart data records -- each entry in this array corresponds to a point on
        // the chart.
        data: series,
        // The name of the data record attribute that contains x-values.
        xkey: 'datetime',
        // A list of names of data record attributes that contain y-values.
        ykeys: ['value'],
        // Labels for the ykeys -- will be displayed when you hover over the
        // chart.
        labels: ['Value'],
        dateFormat: function (ts) {
          return moment.utc(ts).format("ddd, MMMM D, YYYY");
        },
        lineColors: [
          'purple',
          'Crimson',
          'blue',
          'ForestGreen',
          'orange',
          'BurlyWood',
          'DodgerBlue',
          'Aquamarine',
          'maroon'
        ].sort(function() { return .5 - Math.random(); }),
        resize: true,
        redraw: true
      };

      opts.preUnits = metric.unit === 'dollars' ? '$' : '';

      new Morris.Line(opts);
    });
  };

  var loadMetrics = function () {
    $.getJSON('/metrics', function (metrics) {
      metrics.forEach(function (metric) {
        loadMetricPoints(metric);
      })
    });
  };

  $(function () {
    loadMetrics();
  });
})(window);

