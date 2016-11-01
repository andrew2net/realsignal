angular.module 'app', ['ui.router', 'ui.bootstrap']
.config [
  '$stateProvider'
  '$locationProvider'
  ($stateProvider, $locationProvider)->
    mainState = {
      name: 'main'
      url: '/'
      controller: 'MainCtrl'
      templateUrl: '/api/views/main'
    }
    $stateProvider.state mainState
    $locationProvider.html5Mode true
    return
]
