angular.module 'app', ['ngResource', 'ui.router', 'ui.bootstrap', 'ui.grid']
.config ['$stateProvider', '$locationProvider',
  ($stateProvider, $locationProvider) ->
    mainState = {
      name: 'main'
      url: '/admin'
      controller: 'MainCtrl'
      templateUrl: '/admin/api/views/main'
    }
    papers = {
      name: 'main.papers'
      url: '/papers'
      controller: 'PapersCtrl'
      templateUrl: '/admin/api/views/papers'
    }
    tools = {
      name: 'main.tools'
      url: '/tools'
      controller: 'ToolsCtrl'
      templateUrl: '/admin/api/views/tools'
    }
    portfolioStrategies = {
      name: 'main.portfolio_strategies'
      url: '/portfolio_strategies'
      controller: 'PortfolioStrategiesCtrl'
      templateUrl: '/admin/api/views/portfolio_strategies'
    }
    strategies = {
      name: 'main.strategies'
      url: '/strategies'
      controller: 'StrategiesCtrl'
      templateUrl: '/admin/api/views/strategies'
    }
    subscribionTypes = {
      name: 'main.subscription_types'
      url: '/subscription_types'
      controller: 'SubscriptionTypesCtrl'
      templateUrl: '/admin/api/views/subscription_types'
    }
    subscriptions = {
      name: 'main.subscriptions'
      url: '/subscriptions'
      controller: 'SubscriptionCtrl'
      templateUrl: '/admin/api/views/subscriptions'
    }
    admins = {
      name: 'main.admins'
      url: '/admins'
      templateUrl: '/admin/api/views/admins'
      controller: 'AdminsCtrl'
    }
    users = {
      name: 'main.users'
      url: '/users'
      controller: 'UsersCtrl'
      templateUrl: '/admin/api/views/users'
    }
    signInState = {
      name: 'sign_in'
      url: '/admin/admins/sign_in'
      controller: 'SignInCtrl'
      templateUrl: '/admin/api/views/sign_in'
    }
    $stateProvider.state mainState
    $stateProvider.state papers
    $stateProvider.state tools
    $stateProvider.state portfolioStrategies
    $stateProvider.state strategies
    $stateProvider.state subscribionTypes
    $stateProvider.state subscriptions
    $stateProvider.state admins
    $stateProvider.state users
    $stateProvider.state signInState
    $locationProvider.html5Mode true
]
