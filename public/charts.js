$(function() {
    console.log("Hi");
    var count = 0;
    var filter = ['os', 'ip', 'date'];
    // console.log(visit_set);
    $("#redraw_chart").click(function() {
        parseData('time');
    });
    parseData('pie');


    function parseData(param) {
        _.forEach(visit_set, function(value, key) {
            var visits = extractVisits(value);
            if (param == 'pie') {
                var res = getTotals(visits, filter);
                setupPieChart(0, res.length, res);
            } else if (param == 'time') {
                var res = getVisitsByTime(visits);
                setupTimeChart(0, res.length, res);
            }
        });
    }

    function setupPieChart(count, n, dataset) {
        // console.log(dataset);
        _.times(n, function() {
            $('#container' + count).empty();
            $('#container' + count).highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: 1, //null,
                    plotShadow: false
                },
                title: {
                    text: 'Visit Breakdown by OS'
                },
                tooltip: {
                    pointFormat: '{series.name}: <b> {point.y}</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name} </b>: {point.percentage:.1f} % '
                        }
                    }
                },
                series: [{
                    type: 'pie',
                    name: '# of vists',
                    data: []
                }]
            });
            chart = $('#container' + count).highcharts();
            chart.series[0].setData(dataset);
            count++;
        });

    }

    function setupTimeChart(count, n, dataset) {
        // console.log(dataset);
        _.times(n, function() {
            $('#container' + count).empty();
            $('#container' + count).highcharts('StockChart', {
                chart: {
                    events: {
                        load: function() {

                            // set up the updating of the chart each second
                            var series = this.series[0];
                            setInterval(function() {
                                var x = (new Date()).getTime(), // current time
                                    y = Math.round(Math.random() * 10);
                                series.addPoint([x, y], true, true);
                            }, 1000);
                        }
                    }
                },

                rangeSelector: {
                    buttons: [{
                        count: 1,
                        type: 'minute',
                        text: '1M'
                    }, {
                        count: 5,
                        type: 'minute',
                        text: '5M'
                    }, {
                        type: 'all',
                        text: 'All'
                    }],
                    inputEnabled: false,
                    selected: 0
                },

                title: {
                    text: 'Live random visit'
                },

                exporting: {
                    enabled: false
                },

                series: [{
                    name: 'Random visit',
                    data: (function() {
                        // generate an array of random data
                        var data = [],
                            time = (new Date()).getTime(),
                            i;

                        for (i = -999; i <= 0; i += 1) {
                            data.push([
                                time + i * 1000,
                                Math.round(Math.random() * 10)
                            ]);
                        }
                        return data;
                    }())
                }]
            });
        });
    }

    function extractVisits(dataset) {
        var res = new Array();
        _.forEach(dataset.data, function(value, key) {
            res.push(value.attributes);
        });
        return res;
    }

    function getTotals(dataset, filter) {
        var res = [];
        res.os = _.countBy(dataset, function(o) {
            return o[filter[0]];
        });
        // res.ip = _.countBy(dataset, function(o) {
        //     return o[filter[1]];
        // });
        _.forEach(res.os, function(value, key) {
            res.push([key, value]);
        })
        return res;
    }

    function getVisitsByTime(dataset) {
        var res = [];
        res.date = _.countBy(dataset, function(o) {
            return o['date'];
        });
        _.forEach(res.date, function(value, key) {
            res.push([parseInt(key, 10), value]);
        })
        return res;
    }
});
