'use strict';

var App;

App = angular.module('app', ['ngCookies', 'ngResource', 'app.controllers', 'app.directives', 'app.filters', 'app.services', 'ui', 'parallax']);

App.config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider, config) {
    $routeProvider.when('/about', {
      action: 'page1.about'
    }).when('/meetings', {
      action: 'page1.meetings'
    }).when('/liders', {
      action: 'page1.liders'
    }).when('/cooperation', {
      action: 'page1.cooperation'
    }).when('/library', {
      action: 'library'
    }).when('/companies', {
      action: 'page1.companies'
    }).when('/partners', {
      action: 'page1.partners'
    }).when('/contact', {
      action: 'contact'
    }).when('/meeting/106', {
      action: 'meeting106'
    }).when('/meeting/107', {
      action: 'meeting107'
    }).when('/meeting/108', {
      action: 'meeting108'
    }).when('/meeting/110', {
      action: 'meeting110'
    }).when('/meeting/111', {
      action: 'meeting111'
    }).when('/meeting/112', {
      action: 'meeting112'
    }).when('/meeting/113', {
      action: 'meeting113'
    }).otherwise({
      redirectTo: '/about'
    });
    return $locationProvider.html5Mode(false);
  }
]);
'use strict';

/* Controllers
*/

angular.module('app.controllers', []).controller('AppCtrl', [
  '$scope', '$location', '$resource', '$rootScope', '$route', '$routeParams', 'requestContext', '$window', function($scope, $location, $resource, $rootScope, $route, $routeParams, requestContext, $window) {
    var isRouteRedirect, renderContext;
    isRouteRedirect = function(route) {
      return !route.current.action;
    };
    renderContext = requestContext.getRenderContext();
    $scope.subview = renderContext.getNextSection();
    $scope.$on("requestContextChanged", function() {
      var next;
      if (!renderContext.isChangeRelevant()) {
        return;
      }
      next = renderContext.getNextSection();
      if ($scope.subview !== next) {
        $scope.subview = next;
        return angular.element($window).scrollTop(0);
      }
    });
    $scope.$on("$routeChangeSuccess", function(event) {
      if (isRouteRedirect($route)) {
        return;
      }
      requestContext.setContext($route.current.action, $routeParams);
      return $scope.$broadcast("requestContextChanged", requestContext);
    });
    $scope.$location = $location;
    $scope.$watch('$location.path()', function(path) {
      return $scope.activeNavId = path || '/';
    });
    return $scope.getClass = function(id) {
      if ($scope.activeNavId === id) {
        return 'active';
      } else {
        return '';
      }
    };
  }
]).controller('PageCtrl', [
  '$scope', 'requestContext', '$window', '$timeout', '$rootScope', 'sectionScroller', function($scope, requestContext, $window, $timeout, $rootScope, sectionScroller) {
    var renderContext;
    renderContext = requestContext.getRenderContext(requestContext.getRenderContext().getNextSection());
    $timeout(function() {
      return sectionScroller(renderContext.getNextSection(), 0);
    });
    $scope.$on("requestContextChanged", function() {
      var id;
      if ($rootScope.isUrlChangeIrrelevant) {
        return;
      }
      if (!(renderContext.isChangeRelevant() || $rootScope.isUrlChangeIrrelevant)) {
        return;
      }
      if ((id = renderContext.getNextSection()) != null) {
        return sectionScroller(id, 1000);
      }
    });
    return $scope;
  }
]);
'use strict';

/* Directives
*/

angular.module('app.directives', ['app.services']);
'use strict';

/* Filters
*/

angular.module('app.filters', []);
'use strict';

angular.module('parallax', []).factory('sectionScroller', [
  '$window', function($window) {
    return function(id, t) {
      var position, target, win;
      target = $("#" + id);
      win = angular.element($window);
      if (!target.length) {
        return;
      }
      if (target.outerHeight() < win.height()) {
        position = target.offset().top + target.outerHeight() / 2 - win.height() / 2;
      } else {
        position = target.offset().top;
      }
      position = Math.max(position, 0);
      return $.scrollTo(position, t, {
        easing: 'easeInOutExpo'
      });
    };
  }
]).factory('idGenerator', [
  function() {
    return {
      generateId: function(element, prefix) {
        var id;
        if ((id = element.attr('id')) == null) {
          while (true) {
            id = prefix + Math.floor(Math.random() * 1000);
            if (document.getElementById(id) == null) {
              break;
            }
          }
          element.attr('id', id);
        }
        return id;
      }
    };
  }
]).directive('parallax', [
  '$window', '$location', '$rootScope', 'idGenerator', function($window, $location, $rootScope, idGenerator) {
    return function(scope, element, attrs) {
      var eventSuffix, forced, id, move, newPos, win;
      newPos = function(x, firstTop, pos, speedFactor) {
        return "" + x + "% " + (Math.floor((firstTop - pos) * speedFactor)) + "px";
      };
      win = angular.element($window);
      id = idGenerator.generateId(element, 'parallax');
      eventSuffix = "prlx" + id;
      move = function(forced) {
        var firstTop, newPosition, scrollTop;
        if (element.hasClass('inview' || forced)) {
          scrollTop = win.scrollTop();
          firstTop = element.offset().top;
          newPosition = newPos(50, firstTop, scrollTop, attrs.parallax);
          return element.css({
            backgroundPosition: newPosition
          });
        }
      };
      win.bind("scroll." + eventSuffix, function() {
        return move();
      });
      win.bind("resize." + eventSuffix, function() {
        return move();
      });
      element.bind('inview', function(event, visible) {
        return element.toggleClass('inview', visible);
      });
      element.bind('$destroy', function() {
        win.unbind("scroll." + eventSuffix);
        return win.unbind("resize." + eventSuffix);
      });
      forced = true;
      return move(forced);
    };
  }
]).directive('page', [
  '$window', function($window) {
    return function(scope, element, attrs) {
      var resize, win;
      win = angular.element($window);
      win.bind('resize.page', function() {
        return resize();
      });
      resize = function() {
        var newHeight, pb, pt;
        pt = parseInt(element.css('paddingTop'));
        pb = parseInt(element.css('paddingBottom'));
        newHeight = (win.height() * attrs.page) - pt - pb;
        return element.css({
          height: newHeight > 0 ? newHeight : 'auto'
        });
      };
      return resize();
    };
  }
]).directive('scrollSpy', [
  '$location', '$rootScope', function($location, $rootScope) {
    return function(scope, element, attrs) {
      var changePath, id;
      if ((id = attrs.id) == null) {
        return;
      }
      changePath = function() {
        $location.path("/" + id).replace();
        $rootScope.isUrlChangeIrrelevant = true;
        scope.$apply();
        return $rootScope.isUrlChangeIrrelevant = void 0;
      };
      return element.find('[class*=span]').bind('inview', function(event, visible, visiblePartHorizontal, visiblePartVertical) {
        event.stopPropagation();
        if (visible && visiblePartVertical === 'both') {
          return changePath();
        }
      });
    };
  }
]);
'use strict';

/* Sevices
*/

angular.module('app.services', []).value("RenderContext", function(requestContext, actionPrefix, paramNames) {
  var getNextSection, isChangeLocal, isChangeRelevant;
  getNextSection = function() {
    return requestContext.getNextSection(actionPrefix);
  };
  isChangeLocal = function() {
    return requestContext.startsWith(actionPrefix);
  };
  isChangeRelevant = function() {
    if (!requestContext.startsWith(actionPrefix)) {
      return false;
    }
    if (requestContext.hasActionChanged()) {
      return true;
    }
    return paramNames.length && requestContext.haveParamsChanged(paramNames);
  };
  return {
    getNextSection: getNextSection,
    isChangeLocal: isChangeLocal,
    isChangeRelevant: isChangeRelevant
  };
}).service("requestContext", [
  'RenderContext', function(RenderContext) {
    var action, getAction, getNextSection, getParam, getParamAsInt, getRenderContext, hasActionChanged, hasParamChanged, haveParamsChanged, isParam, params, previousAction, previousParams, sections, setContext, startsWith;
    action = "";
    sections = [];
    params = {};
    previousAction = "";
    previousParams = {};
    getAction = function() {
      return action;
    };
    getNextSection = function(prefix) {
      var depth;
      if (!startsWith(prefix)) {
        return null;
      }
      if (prefix === "") {
        return sections[0];
      }
      depth = prefix.split(".").length;
      if (depth === sections.length) {
        return null;
      }
      return sections[depth];
    };
    getParam = function(name, defaultValue) {
      if (angular.isUndefined(defaultValue)) {
        defaultValue = null;
      }
      return params[name] || defaultValue;
    };
    getParamAsInt = function(name, defaultValue) {
      var valueAsInt;
      valueAsInt = getParam(name, defaultValue || 0) * 1;
      if (isNaN(valueAsInt)) {
        return defaultValue || 0;
      } else {
        return valueAsInt;
      }
    };
    getRenderContext = function(requestActionLocation, paramNames) {
      requestActionLocation = requestActionLocation || "";
      paramNames = paramNames || [];
      if (!angular.isArray(paramNames)) {
        paramNames = [paramNames];
      }
      return new RenderContext(this, requestActionLocation, paramNames);
    };
    hasActionChanged = function() {
      return action !== previousAction;
    };
    hasParamChanged = function(paramName, paramValue) {
      if (!angular.isUndefined(paramValue)) {
        return !isParam(paramName, paramValue);
      }
      if (!previousParams.hasOwnProperty(paramName) && params.hasOwnProperty(paramName)) {
        return true;
      } else {
        if (previousParams.hasOwnProperty(paramName) && !params.hasOwnProperty(paramName)) {
          return true;
        }
      }
      return previousParams[paramName] !== params[paramName];
    };
    haveParamsChanged = function(paramNames) {
      var i, length;
      i = 0;
      length = paramNames.length;
      while (i < length) {
        if (hasParamChanged(paramNames[i])) {
          return true;
        }
        i++;
      }
      return false;
    };
    isParam = function(paramName, paramValue) {
      if (params.hasOwnProperty(paramName) && (params[paramName] === paramValue)) {
        return true;
      }
      return false;
    };
    setContext = function(newAction, newRouteParams) {
      previousAction = action;
      previousParams = params;
      action = newAction;
      sections = action.split(".");
      return params = angular.copy(newRouteParams);
    };
    startsWith = function(prefix) {
      if (!prefix.length || (action === prefix) || (action.indexOf(prefix + ".") === 0)) {
        return true;
      }
      return false;
    };
    return {
      getNextSection: getNextSection,
      getParam: getParam,
      getParamAsInt: getParamAsInt,
      getRenderContext: getRenderContext,
      hasActionChanged: hasActionChanged,
      hasParamChanged: hasParamChanged,
      haveParamsChanged: haveParamsChanged,
      isParam: isParam,
      setContext: setContext,
      startsWith: startsWith
    };
  }
]);
