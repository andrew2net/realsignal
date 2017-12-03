angular.module 'AccountApp', ['ui.bootstrap', 'ui.router', 'ncy-angular-breadcrumb', 'ngSanitize']
.config [
  '$stateProvider'
  '$locationProvider'
  '$breadcrumbProvider'
  ($stateProvider, $locationProvider, $breadcrumbProvider)->
    dashboardState = {
      name: 'dashboard'
      url: '/account/dashboard'
      controller: 'DashboardCtrl'
      templateUrl: '/api/views/dashboard'
      ncyBreadcrumb: { label: '<i class="fa fa-line-chart"></i> Dashboard' }
    }

    subscriptionsState = {
      name: 'subscriptions'
      url: '/account/subscriptions'
      component: 'subscriptions'
      ncyBreadcrumb: { label: '<i class="fa fa-file-text-o"></i> Subscriptions' }
    }

    $stateProvider.state dashboardState
    $stateProvider.state subscriptionsState
    $locationProvider.html5Mode true

    $breadcrumbProvider.setOptions({
      template: """
      <ol class="breadcrumb">
        <li ng-repeat="step in steps | limitTo:(steps.length-1)">
            <a href="{{step.ncyBreadcrumbLink}}" ng-bind-html="step.ncyBreadcrumbLabel"></a>
        </li>
        <li ng-repeat="step in steps | limitTo:-1" class="active">
            <span ng-bind-html="step.ncyBreadcrumbLabel"></span>
        </li>
      </ol>"""
    })
]
