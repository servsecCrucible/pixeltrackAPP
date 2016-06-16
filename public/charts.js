$(function() {
    // var arr = new Array();
    //     // campaign_set.tracker_set.forEach(function (item) {
    //     //   arr.push(item);
    //     // })
    //     console.log(visit_set);
    //     // console.log(arr);
    //     console.log(campaign_set);
    // campaign_set.forEach(function (item) {
    //       console.log(item.id);
    //     });
    // console.log(cvisit_set);
    console.log("Hi");
    // console.log(extractVisits(visit_set));
    var visit_array = extractVisits(visit_set);
    var res = getTotals(visit_array, 'hey');
    // console.log(res);
    // console.log(getTotals(visit_array,'hey'));
    $('#container0').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: 1, //null,
            plotShadow: false
        },
        title: {
            text: 'Production breakdown by volume'
        },
        tooltip: {
            pointFormat: '{series.name}: <b> {point.y} Kg</b>'
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
            name: 'Production Output',
            data: []
        }]
    });
    chart = $('#container0').highcharts();
    chart.series[0].setData(res);
});

function extractVisits(dataset) {
    var res = new Array();
    dataset.forEach(function(item) {
        item.data.forEach(function(x) {
            res.push(x.attributes);
        });
    });
    return res;
}

function getTotals(dataset, filter) {
    console.log(filter);
    var res = {};
    var hey = [];
    // console.log(dataset);
    res.os = _.countBy(dataset, function(o) {
        return o.os;
    });
    res.ip = _.countBy(dataset, function(o) {
        return o.ip;
    });
    _.forEach(res.os, function(value, key) {
        hey.push([key, value]);
    })
    console.log(hey);
    // console.log(_.countBy(dataset,dataset.os));
    // _.times(4, function(){
    //   console.log('boy');
    // })
    // var res = new Array();
    // dataset.forEach(function(item){
    //   // console.log(item);
    //   res.push(item);
    // });
    return hey;
}
