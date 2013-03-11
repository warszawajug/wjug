'use strict'

### Controllers ###

angular.module('app.controllers', [])

	.controller('AppCtrl', [
		'$scope'
		'$location'
		'$resource'
		'$rootScope'
		'$route'
		'$routeParams'
		'requestContext'
		'$window'

		($scope, $location, $resource, $rootScope, $route, $routeParams, requestContext, $window) ->
			# If there is no action, then the route is redirection from an unknown
			# route to a known route.
			isRouteRedirect = (route) -> not route.current.action

			renderContext = requestContext.getRenderContext()
			$scope.subview = renderContext.getNextSection()

			$scope.$on "requestContextChanged", ->
				# Make sure this change is relevant to this controller.
				return  unless renderContext.isChangeRelevant()

				# Update the view that is being rendered.
				next = renderContext.getNextSection()
				unless $scope.subview is next
					$scope.subview = next
					angular.element($window).scrollTop 0



			# Listen for route changes so that we can trigger request-context change events.
			$scope.$on "$routeChangeSuccess", (event) ->
				# If this is a redirect directive, then there's no taction to be taken.
				return  if isRouteRedirect($route)
				# Update the current request action change.
				requestContext.setContext $route.current.action, $routeParams
				# Announce the change in render conditions.
				$scope.$broadcast "requestContextChanged", requestContext


			# Uses the url to determine if the selected
			# menu item should have the class active.
			$scope.$location = $location
			$scope.$watch('$location.path()', (path) ->
				$scope.activeNavId = path || '/'
			)

			# getClass compares the current url with the id.
			# If the current url starts with the id it returns 'active'
			# otherwise it will return '' an empty string. E.g.
			#
			#   # current url = '/products/1'
			#   getClass('/products') # returns 'active'
			#   getClass('/orders') # returns ''
			#
			$scope.getClass = (id) ->
				if $scope.activeNavId == id
					return 'active'
				else
					return ''

	])

	.controller('PageCtrl', [
		'$scope'
		'requestContext'
		'$window'
		'$timeout'
		'$rootScope'
		'sectionScroller'

		($scope, requestContext, $window, $timeout, $rootScope, sectionScroller) ->

			renderContext = requestContext.getRenderContext requestContext.getRenderContext().getNextSection()

			$timeout ->
				sectionScroller renderContext.getNextSection(), 0

			$scope.$on "requestContextChanged", ->
				return if $rootScope.isUrlChangeIrrelevant
				return unless renderContext.isChangeRelevant() or $rootScope.isUrlChangeIrrelevant
				if (id = renderContext.getNextSection())?
					sectionScroller id, 1000

			$scope
	])