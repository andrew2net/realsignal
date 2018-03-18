angular.module 'AccountApp'
.factory 'SubscriptionType', ['$resource', ($resource) ->
  $resource '/admin/subscription_types/:id.json', { id: '@id' }, { update: { method: 'PUT' } }
]
.factory 'Subscription', ['$resource', ($resource) ->
  $resource '/account/subscriptions/:id.json', { id: '@id' }, {
    update: { method: 'PUT' }
    stop: { method: 'POST', url: '/account/subscriptions/:id/stop.json' }
  }
]
