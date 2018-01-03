angular.module 'AccountApp'
.component 'selectPlan', {
  bindings: { subscriptionPlans: '<' }
  templateUrl: '/api/views/select_plan'
  controller: ['$scope', '$http', '$state', ($scope, $http, $state) ->
    $scope. subscribe = (plan) ->
      $http.post '/account/subscriptions', { plan: plan.id }
      .then (resp) ->
        $state.go 'subscriptions.show', { id: resp.data.subscription_id }
    $scope
  ]
}
