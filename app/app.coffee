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

			.when('/first', action: 'page1.first')
			.when('/second', action: 'page1.second')
			.when('/third', action: 'page1.third')
			.when('/test2', action: 'page2')

		# Catch all
			.otherwise({redirectTo: '/first'})

		# Without server side support html5 must be disabled.
		$locationProvider.html5Mode(false)



])
