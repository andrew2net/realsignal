angular.module 'app'
  .controller 'SignInCtrl', ['$scope', '$http', '$location',
  ($scope, $http, $location)->
    $scope.closeAlert = ->
      $scope.error = false

    $scope.submitForm = ->
      return unless $scope.admin.email and $scope.admin.password
      $scope.loading = true
      $http.post '/admin/admins/sign_in', $scope.admin
        .then (resp)->
          $location.path '/admin' if resp.data.result
          $scope.error = not resp.data.result
          $scope.loading = false
      return
    return
  ]
