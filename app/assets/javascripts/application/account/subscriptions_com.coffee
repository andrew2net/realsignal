subscriptionsCtrl = ($scope, $http, $uibModal, Subscription, Flash) ->
  # Get temp link for Telegram bot authentication.
  $scope.getTeleramLink = ->
    $http.get '/api/telegram_token'
    .then (resp) ->
      $scope.token = resp.data

  checkAvailablePlans = ->
    $http.get '/account/subscriptions/has_available_plans'
      .then (resp) -> $scope.hasAvailablePlans = resp.data.has_available_plans

  # Stop subscribing
  $scope.stopSubscription = ($event, subscription) ->
    $event.target.disabled = true
    # Asck confirmation
    confirm = $uibModal.open {
      component: 'confirmComponent'
      resolve: {
        message: -> "Stop supscription #{subscription.name}"
      }
    }
    confirm.result.then ->
      subscription.$stop ->
        $event.target.disabled = false
        checkAvailablePlans()
        Flash.create 'success', 'The subscription is stopped'
      , ->
        $event.target.disabled = false
        Flash.create 'danger', 'Fail stop the subscription'
    , ->
      $event.target.disabled = false

  checkAvailablePlans()
  $scope.subscriptions = Subscription.query()
  $scope

subscriptionsCtrl.$inject = ['$scope', '$http', '$uibModal', 'Subscription', 'Flash']

angular.module 'AccountApp'
.component 'subscriptions', {
  templateUrl: '/api/views/subscriptions'
  controller: subscriptionsCtrl
}
