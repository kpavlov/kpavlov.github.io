---
title: "Tags Input Control for AngularJS"
tags:
  - javascript
  - angularjs
comments: true
categories:
  - programming
date: 2015-05-30T09:53:19
---

Stay <abbr title="Don't Repeat Yourself">DRY</abbr>! Don't waste your time implementing tags input control for AngularJS yourself! There is an excellent AngularJS module for that called ["ngTagsInput"][github]. It's also supports autocomptetion, validations,custom styles and templates. See the [demos](http://mbenford.github.io/ngTagsInput/demos).

It took me just 10 minutes to add that type of control to my application.

All you need to do is:
1. Add NPM or Bower dependency
~~~bash
    npm install ng-tags-input --save
    bower install ng-tags-input --save
~~~
2. Include script and CSS to your html page. If you're using some dependency injection pre-processor like [gulp-inject](https://www.npmjs.com/package/gulp-inject) or [gulp-ng-inject](https://www.npmjs.com/package/gulp-ng-inject) you don't need it.

    ~~~html
    <script src="angular.js"></script>
    <script src="ng-tags-input.js"></script>
    <link rel="stylesheet" type="text/css" href="ng-tags-input.css">
    ~~~
3. declare module dependency:
    ~~~js
    angular.module('myApp', ['ngTagsInput'])
        .controller('MyCtrl', function($scope, $http) {
            $scope.tags = [
                { text: 'just' },
                { text: 'some' },
                { text: 'cool' },
                { text: 'tags' }
            ];
            $scope.loadTags = function(query) {
                 return $http.get('/tags?query=' + query);
            };
        });
    ~~~
4. Add input control to html
    ~~~html
    <body ng-app="myApp" ng-controller="MyCtrl">
        <tags-input ng-model="tags">
            <auto-complete source="loadTags($query)"></auto-complete>
        </tags-input>
    </body>
    ~~~

Pretty simple, isn't it?
The only thing to consider is handling of the `tags` model. `$scope.tags` will be an array of objects on the form `{text:value}`. You may need to transfer them to array of strings:
~~~js
var tagValues = $scope.tags.map(function(input) {return input.text;});
~~~


[github]: https://github.com/mbenford/ngTagsInput
