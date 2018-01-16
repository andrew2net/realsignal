angular.module 'AccountApp'
.component 'showSubscription', {
  bindings: { subscription: '<', billingAddr: '<' }
  templateUrl: '/api/views/show_subscription'
  controller: ['$http', '$state', '$stateParams', 'Flash',
    ($http, $state, $stateParams, Flash) ->

      @formSubmit = (e) ->
        # e.preventDefault()
        # @disableSubmitButton = true
        @cardHolderName = "#{@billingAddr.first_name} #{@billingAddr.last_name}"

      return
  ]
}
