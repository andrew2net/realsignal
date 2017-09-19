angular.module 'app'
.controller 'SubscriptionTypesCtrl', ['$scope', '$http', '$editModal', 'SubscriptionType', 'PortfolioStrategy',
($scope, $http, $editModal, SubscriptionType, PortfolioStrategy)->
  $scope.itemName = 'Subscription type'
  $scope.subscriptionTypes = []
  portfolios = null
  periods = null

  $scope.subscriptionTypesGrid = {
    columnDefs: [
      { name: 'Portfolio', field: '_portfolio()' }
      { name: 'period', field: '_period()' }
      { field: 'price', type: 'number' }
      {
        name: 'Add'
        field: 'add'
        headerCellTemplate: 'gridAddButton.html'
        cellTemplate: 'gridEditRemoveButtons.html'
        width: 60
      }
    ]
    data: 'subscriptionTypes'
  }

  portfolioName = ->
    st = this
    portfolios.find((elm)-> elm.id == st.portfolio_strategy_id).name

  periodName = ->
    st = this
    periods.find((elm)-> elm.id == st.period).name

  loadItems = ->
    $scope.loadingItems = true
    $scope.subscriptionTypes = SubscriptionType.query (data)->
      for st in data
        st._portfolio = portfolioName
        st._period = periodName
      $scope.loadingItems = false

  PortfolioStrategy.query (data)->
    portfolios = data
    loadItems() if periods

  $http.get '/admin/subscription_types/periods'
  .then (resp)->
    periods = resp.data
    loadItems() if portfolios

  callbacks = {
    reloadItems: loadItems
    portfolios: -> portfolios
    periods: -> periods
  }

  templateUrl = 'subscriptionTypeModal.html'
  $scope.addItem = -> $editModal.open new SubscriptionType, templateUrl, callbacks
  $scope.editItem = (row)-> $editModal.open row.entity, templateUrl, callbacks
  $scope.removeItem = (row)-> $editModal.remove(row.entity,
    "'#{row.entity._portfolio()}' for #{row.entity._period()} period", loadItems)
]
