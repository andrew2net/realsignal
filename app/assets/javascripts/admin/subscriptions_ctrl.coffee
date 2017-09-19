angular.module 'app'
.controller 'SubscriptionCtrl', [
  '$scope', '$editModal', '$http', 'Subscription', 'User', 'SubscriptionType', 'PortfolioStrategy',
  ($scope, $editModal, $http, Subscription, User, SubscriptionType, PortfolioStrategy)->
    users = null
    subscriptionTypes = null
    periods = null

    $scope.subscriptionsGrid = {
      columnDefs: [
        { name: 'User', field: 'user().name()' }
        { name: 'Email', field: 'user().email'}
        {
          name: 'Subscription type',
          field: 'subscriptionType().portfolioPeriod()'
        }
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

    user = (user_id)->
      user_id = this.user_id if this.user_id
      users.find (elm)-> elm.id == user_id

    subscriptionPortfolioPeriod = ->
      st = this   # SubscriptionType
      portfolio = portfolioStrategies.find (elm)-> elm.id == st.portfolio_strategy_id
      period = periods.find((elm)-> elm.id == st.period).name
      "#{portfolio.name} (#{period} - $#{this.price})"

    subscriptionType = (subscription_type_id)->
      subscription_type_id = this.subscription_type_id if this.subscription_type_id
      subscriptionTypes.find (elm)-> elm.id == subscription_type_id

    loadItems = ->
      $scope.loadingItems = true
      $scope.subscriptions = Subscription.query (data)->
        for s in data
          s.user = user
          s.subscriptionType = subscriptionType
          s.end_date = new Date s.end_date if s.end_date
        $scope.loadingItems = false

    User.query (data)->
      users = data
      for u in users
        u.name = userName
        u.nameEmail = userNameEmail
      loadItems() if subscriptionTypes

    SubscriptionType.query (data)->
      subscriptionTypes = data
      for s in subscriptionTypes
        s.portfolioPeriod = subscriptionPortfolioPeriod
      loadItems() if users

    $http.get '/admin/subscription_types/periods'
    .then (resp)->
      periods = resp.data

    portfolioStrategies = PortfolioStrategy.query()

    callbacks = {
      reloadItems: loadItems
      users: -> users
      user: user
      subscriptionTypes: -> subscriptionTypes
    }

    templateUrl = 'subscriptionModal.html'
    $scope.addItem = -> $editModal.open new Subscription, templateUrl, callbacks
    $scope.editItem = (row)-> $editModal.open row.entity, templateUrl, callbacks
    $scope.removeItem = (row)-> $editModal.remove(row.entity,
      "#{row.entity.user().name()} #{row.entity.subscriptionType().portfolioPeriod()}", loadItems)
]
