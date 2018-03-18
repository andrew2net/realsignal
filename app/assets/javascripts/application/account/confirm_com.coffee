confirmComponentCtrl = ($scope) ->
  $scope.$onInit = () -> $scope.message = $scope.resolve.message
  $scope

confirmComponentCtrl.$inject = ['$scope']

angular.module 'AccountApp'
.component 'confirmComponent', {
  templateUrl: 'confirmModal.html'
  bindings: {
    resolve: '<'
    close: '&'
    dismiss: '&'
  }
  controller: confirmComponentCtrl
}
