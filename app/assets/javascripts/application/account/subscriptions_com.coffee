angular.module 'AccountApp'
.component 'subscriptions', {
  templateUrl: '/api/views/subscriptions'
  controller: ['$scope', '$http', '$uibModal', ($scope, $http, $uibModal)->
    $scope.getTeleramLink = ->
      $http.get '/api/telegram_token'
      .then (resp)->
        $scope.token = resp.data

    $scope.showSelectSubscriptionModal = ->
      modalInstance = $uibModal.open {
        component: 'selectSubscriptionModal'
      }
  ]
}
.component 'selectSubscriptionModal', {
  templateUrl: 'selectSubscriptionModal.html'
}
