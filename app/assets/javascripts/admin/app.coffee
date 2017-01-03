angular.module 'app', ['ngResource', 'ui.router', 'ui.bootstrap', 'ui.grid']
.config ['$stateProvider', '$locationProvider',
  ($stateProvider, $locationProvider)->
    mainState = {
      name: 'main'
      url: '/admin'
      controller: 'MainCtrl'
      templateUrl: '/admin/api/views/main'
    }
    subscribionTypes = {
      name: 'main.subscription_types'
      url: '/subscription_types/view'
      controller: 'SubscriptionTypesCtrl'
      templateUrl: '/admin/api/views/subscription_types'
    }
    admins = {
      name:'main.admins'
      url: '/admins/view'
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
    $stateProvider.state subscribionTypes
    $stateProvider.state admins
    $stateProvider.state users
    $stateProvider.state signInState
    $locationProvider.html5Mode true
]
.directive 'stringToNumber', ->
  return {
    require: 'ngModel',
    link: (scope, element, attrs, ngModel)->
      ngModel.$parsers.push (value)->
        '' + value

      ngModel.$formatters.push (value)->
        parseFloat value
  }
