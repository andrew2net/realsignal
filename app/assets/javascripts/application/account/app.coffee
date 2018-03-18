angular.module 'AccountApp', [
  'ui.bootstrap'
  'ui.router'
  'ncy-angular-breadcrumb'
  'ngSanitize'
  'ngFlash'
  'ngResource'
  'ngAnimate'
]
.config [
  '$stateProvider'
  '$locationProvider'
  '$breadcrumbProvider'
  ($stateProvider, $locationProvider, $breadcrumbProvider) ->
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

    selectPlanState = {
      name: 'subscriptions.selectPlan'
      url: '/select_plan'
      views: { '@': 'selectPlan' }
      resolve: { subscriptionPlans: ['$http', ($http) ->
        $http.get '/account/subscriptions/plans.json'
        .then (resp) -> resp.data
      ] }
      ncyBreadcrumb: { label: 'Select subscription plan' }
    }

    subscriptionShowState = {
      name: 'subscriptions.show'
      url: '/:id'
      views: { '@': 'showSubscription' }
      resolve: {
        subscription: ['$http', '$stateParams', ($http, $stateParams) ->
          $http.get "/account/subscriptions/#{$stateParams.id}.json"
          .then (resp) -> resp.data
        ]
        billingAddr: ['$http', ($http) ->
          $http.get '/account/subscriptions/billing_addr.json'
          .then (resp) -> resp.data
        ]
      }
      ncyBreadcrumb: { label: 'Subscription details' }
    }

    subscriptionSuccessCheckout = {
      name: 'subscriptions.successCheckout'
      url: '/success'
      views: { '@': 'successCheckout' }
      ncyBreadcrumb: { label: 'Subscribed' }
    }

    $stateProvider.state dashboardState
    $stateProvider.state subscriptionsState
    $stateProvider.state selectPlanState
    $stateProvider.state subscriptionShowState
    $stateProvider.state subscriptionSuccessCheckout
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
