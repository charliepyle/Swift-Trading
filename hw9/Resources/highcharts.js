Highcharts.getJSON('https://demo-live-data.highcharts.com/aapl-ohlcv.json', function (stock) {

    // split the data set into ohlc and volume
    var ohlc = [],
        volume = [],
        dataLength = data.length,
        // set the allowed units for data grouping
        groupingUnits = [[
            'week',                         // unit name
            [1]                             // allowed multiples
        ], [
            'month',
            [1, 2, 3, 4, 6]
        ]],

        i = 0;

    for (i; i < dataLength; i += 1) {
        ohlc.push([
            data[i][0], // the date
            data[i][1], // open
            data[i][2], // high
            data[i][3], // low
            data[i][4] // close
        ]);

        volume.push([
            data[i][0], // the date
            data[i][5] // the volume
        ]);
    }
    
    let stockClose;
    let stockVolume;

    let color;

    if (this.stock.change > 0) {
      color = 'green'
    }
    else if (this.stock.change == 0) {
      color = 'black'
    }
    else {
      color = 'red'
    }

    stockClose = this.stock.historicalStockClose;
    stockVolume = this.stock.historicalStockVolume;
    // create the chart
    Highcharts.stockChart('container', {

        rangeSelector: {
            selected: 2
        },

        title: {
            text: this.stock.ticker + ' Historical'
        },

        subtitle: {
            text: 'With SMA and Volume by Price Technical Indicators',
            useHTML: true
        },

        yAxis: [{
            startOnTick: false,
            endOnTick: false,
            labels: {
                align: 'right',
                x: -3
            },
            title: {
                text: 'OHLC'
            },
            height: '60%',
            lineWidth: 2,
            resize: {
                enabled: true
            }
        }, {
            labels: {
                align: 'right',
                x: -3
            },
            title: {
                text: 'Volume'
            },
            top: '65%',
            height: '35%',
            offset: 0,
            lineWidth: 2
        }],

        tooltip: {
            split: true
        },
        
        credits: {
            enabled: true
        },

//        plotOptions: {
//            series: {
//                dataGrouping: {
//                    units: groupingUnits
//                }
//            }
//        },

        series: [{
            type: 'candlestick',
            name: this.stock.ticker,
            id: 'ohlc',
            zIndex: 2,
            data: stockClose
        }, {
            type: 'column',
            name: this.stock.ticker + ' Volume',
            id: 'volume',
            data: stockVolume,
            yAxis: 1
        }, {
            type: 'vbp',
            linkedTo: 'ohlc',
            params: {
                volumeSeriesID: 'volume'
            },
            dataLabels: {
                enabled: false
            },
            zoneLines: {
                enabled: false
            }
        }, {
            type: 'sma',
            linkedTo: 'ohlc',
            zIndex: 1,
            marker: {
                enabled: false
            }
        }]
    });
});
