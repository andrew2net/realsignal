angular.module 'AccountApp'
.component 'subscriptions', {
  templateUrl: '/api/views/subscriptions'
  controller: ['$scope', '$http', ($scope, $http) ->
    $scope.getTeleramLink = ->
      $http.get '/api/telegram_token'
      .then (resp) ->
        $scope.token = resp.data
  ]
}
