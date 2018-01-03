angular.module 'AccountApp'
.component 'showSubscription', {
  bindings: { subscription: '<', billingAddr: '<' }
  templateUrl: '/api/views/showSubscription'
  controller: ['$scope', '$http', '$state', '$stateParams', ($scope, $http, $state, $stateParams) ->

    $scope.formData = { billing_addr: @billingAddr }
    form = document.getElementById('payCCForm')

    # Called when token created successfully.
    successCallback = (data) ->
      # Set the token as the value for the token input
      $scope.formData.token = data.response.token.token

      $http.post "/account/subscriptions/#{$stateParams.id}/twocheckout_pay", $scope.formData
      .then ->
        $scope.disableSubmitButton = false
        if resp.responseCode == 'APPROVED'
          $state.go 'subscriptions'

    # Called when token creation fails.
    errorCallback = (data) ->
      $scope.disableSubmitButton = false
      if data.errorCode == 200
        # This error code indicates that the ajax call failed.
        # We recommend that you retry the token request.
      else
        alert(data.errorMsg)

    tokenRequest = ->
      # Setup token request arguments
      args = {
        sellerId: form.dataset.sellerId
        publishableKey: form.dataset.publishableKey
        ccNo: document.getElementById('ccNo').value
        cvv: document.getElementById("cvv").value
        expMonth: document.getElementById("expMonth").value
        expYear: document.getElementById("expYear").value
      }

      # Make the token request
      TCO.requestToken(successCallback, errorCallback, args)

    $scope.formSubmit = (e) ->
      e.preventDefault()
      $scope.disableSubmitButton = true
      # Call our token request function
      tokenRequest()

    $scope.onLoad = ->
      # Pull in the public encryption key for our environment
      TCO.loadPubKey(form.dataset.env)
      $scope.formData.billing_addr = @billingAddr

      # $("#myCCForm").submit((e)->
        # Call our token request function
        # tokenRequest()

        # Prevent form from submitting
        # false
      # )

    $scope
  ]
}
