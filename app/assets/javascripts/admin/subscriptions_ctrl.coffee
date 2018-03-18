angular.module 'app'
.controller 'SubscriptionCtrl', [
  '$scope',
  '$editModal',
  '$http',
  '$q',
  'Subscription',
  'User',
  'SubscriptionType',
'PortfolioStrategy',
  ($scope, $editModal, $http, $q, Subscription, User, SubscriptionType, PortfolioStrategy) ->
    users = []
    subscriptionTypes = []
    periods = null
    portfolioStrategies = []

    $scope.subscriptionsGrid = {
      columnDefs: [
        { name: 'User', field: 'user().name()' }
        { name: 'Email', field: 'user().email' }
        {
          name: 'Subscription type',
          field: 'subscriptionType().portfolioPeriod()'
        }
        { field: 'status', width: 100 }
        {
          name: 'Valid through'
          field: 'end_date'
          type: 'date'
          cellFilter: 'date:"dd-MM-yyyy"'
          width: 120
        }
        {
          name: 'Add'
          field: 'add'
          headerCellTemplate: 'gridAddButton.html'
          cellTemplate: 'gridEditRemoveButtons.html'
          width: 60
        }
      ]
      data: 'subscriptions'
    }

    userName = -> "#{this.first_name} #{this.last_name}"

    userNameEmail = -> "#{this.name()} #{this.email}"

    user = (user_id) ->
      user_id = this.user_id if this.user_id
      users.find (elm) -> elm.id == user_id

    subscriptionPortfolioPeriod = ->
      st = this   # SubscriptionType
      portfolio = portfolioStrategies.find (elm) -> elm.id == st.portfolio_strategy_id
      period = periods.find((elm) -> elm.id == st.period).name
      "#{portfolio.name} (#{period} - $#{this.price})"

    subscriptionType = (subscription_type_id) ->
      subscription_type_id = this.subscription_type_id if this.subscription_type_id
      subscriptionTypes.find (elm) -> elm.id == subscription_type_id

    subscriptionRelations = (data) ->
      for s in data
        s.user = user
        s.subscriptionType = subscriptionType
        s.end_date = new Date s.end_date if s.end_date
      data

    loadItems = ->
      $scope.loadingItems = true
      $scope.subscriptions = Subscription.query (data) ->
        subscriptionRelations data
        $scope.loadingItems = false
    
    subscriptionsQuery = ->
      d = $q.defer()
      Subscription.query (data) ->
        subscriptionRelations data
        d.resolve data
      d.promise

    usersQuery = ->
      d = $q.defer()
      User.query (data) -> d.resolve data
      d.promise

    subscriptionTypesQuery = ->
      d = $q.defer()
      SubscriptionType.query (data) -> d.resolve data
      d.promise

    portfolioStrategiesQuery = ->
      d = $q.defer()
      PortfolioStrategy.query (data) -> d.resolve data
      d.promise

    $scope.loadingItems = true
    $q.all([
      subscriptionsQuery()
      usersQuery()
      subscriptionTypesQuery()
      $http.get '/admin/subscription_types/periods'
      portfolioStrategiesQuery()
    ]).then (data) ->
      $scope.subscriptions = data[0]
      users = data[1]
      subscriptionTypes = data[2]
      periods = data[3].data
      portfolioStrategies = data[4]

      for u in users
        u.name = userName
        u.nameEmail = userNameEmail

      for s in subscriptionTypes
        s.portfolioPeriod = subscriptionPortfolioPeriod
      
      $scope.loadingItems = false

    # Callbacks for modal form.
    callbacks = {
      reloadItems: loadItems
      users: -> users
      user: user
      subscriptionTypes: -> subscriptionTypes
    }

    templateUrl = 'subscriptionModal.html'
    # Open modal form for new item
    $scope.addItem = -> $editModal.open new Subscription, templateUrl, callbacks
    # Open modal form for edit item
    $scope.editItem = (row) -> $editModal.open row.entity, templateUrl, callbacks
    $scope.removeItem = (row) -> $editModal.remove(row.entity,
      "#{row.entity.user().name()} #{row.entity.subscriptionType().portfolioPeriod()}", loadItems)
]
