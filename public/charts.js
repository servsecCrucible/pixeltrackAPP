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
            // $('#container' + count).empty();
            $('#container' + count).highcharts('StockChart', {
                loading: {
                    hideDuration: 1000,
                    showDuration: 1000
                },
                rangeSelector: {
                    selected: 1,
                    inputEnabled: $('#container' + count).width() > 480
                },

                tooltip: {
                    pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>${point.y}</b><br/>',
                    valueDecimals: 2
                },
                colors: ['#4D90FE', '#1BC123'],
                title: {
                    text: 'Visits by TIme'
                },

                chart: {},
                series: [{
                    data: []
                }]
            });

            var sortedData = _.sortBy(dataset, function(num) {
                return num;
            });
            console.log(sortedData);
            chart = $('#container' + count).highcharts('StockChart');
            chart.series[0].setData(sortedData);
            chart.series[0].name = 'yea';
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
            res.push([parseInt(key,10), value]);
        })
        return res;
    }
});
