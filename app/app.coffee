'use strict'

# Declare app level module which depends on filters, and services
App = angular.module('app', [
  'ngCookies'
  'ngResource'
  'app.controllers'
  'app.directives'
  'app.filters'
  'app.services'
  'ui'
  'parallax'
])

App.config([
  '$routeProvider'
  '$locationProvider'

  ($routeProvider, $locationProvider, config) ->
    $routeProvider

      .when('/about', action: 'page1.about')
      .when('/meetings', action: 'page1.meetings')
      .when('/jcp', action: 'page1.jcp')
      .when('/liders', action: 'page1.liders')
      .when('/cooperation', action: 'page1.cooperation')
      .when('/library', action: 'library')
      .when('/partners', action: 'page1.partners')
      .when('/contact', action: 'contact')
      .when('/by-you', action: 'by-you')

    for num in [1..200]
      $routeProvider.when("/meeting/#{num}", action: "meeting#{num}")

    # Catch all
    $routeProvider.otherwise({redirectTo: '/about'})

    # Without server side support html5 must be disabled.
    $locationProvider.html5Mode(false)
])
