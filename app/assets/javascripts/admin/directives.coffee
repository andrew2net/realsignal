angular.module 'app'
.directive 'compareTo', ->
  {
    require: 'ngModel'
    scope: {
      otherModelValue: '=compareTo'
    }
    link: (scope, element, attributes, ngModel)->
      ngModel.$validators.compareTo = (modelValue)->
        modelValue == scope.otherModelValue

      scope.$watch 'otherModelValue', -> ngModel.$validate()
  }
.directive 'stringToNumber', ->
  {
    require: 'ngModel',
    link: (scope, element, attrs, ngModel)->
      ngModel.$parsers.push (value)->
        '' + value

      ngModel.$formatters.push (value)->
        parseFloat value
  }
