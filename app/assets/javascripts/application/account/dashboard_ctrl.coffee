angular.module 'AccountApp'
.controller 'DashboardCtrl', ['$scope', '$http', ($scope, $http)->
  equity_growth_data = []

  getData = (strategy)->
    promise = $http.get '/api/equity_growth', params: {strategy: strategy}
    promise.then (resp)-> equity_growth_data = resp.data.map (d)->
      d[0] = new Date d[0]
      d[1] = parseFloat d[1]
      d
    promise

  drawChart = ->
    options = {
      title: 'Equity Growth'
    }
    chart = new google.visualization.LineChart document.getElementById('chart')

    data = new google.visualization.DataTable()
    data.addColumn('date', 'Date')
    data.addColumn('number', 'Equity Growth')
    data.addRows equity_growth_data
    chart.draw data, options

  $scope.strategyChanged = (strategy)->
    getData(strategy).then drawChart

  google.charts.load 'current', {packages: ['corechart']}

  $http.get '/api/strategies'
  .then (resp)->
    $scope.strategies = resp.data
    $scope.strategy = $scope.strategies[0].id
    getData($scope.strategy).then ->
      google.charts.setOnLoadCallback drawChart
]
