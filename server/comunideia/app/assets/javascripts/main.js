/* ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- */
angular.module('comunideiaProto', [])
.controller('userSingleCtrl', ['$scope', function($scope) {
  $scope.currentTab         = 0;
}])
.controller('allProjectsCtrl', ['$scope', function($scope) {
  $scope.projType   = 0;
  $scope.toggleProjType = function() {
    $scope.projType = ($scope.projType == 0 ? 1 : 0)
  }
}])
.controller('projectSingleCtrl', ['$scope', function($scope) {
  $scope.selectedPledgeItem = 1;
  $scope.pledgedValue       = 10;
  $scope.currentTab         = 0;
  //----- ----- -----
  $scope.onPledgeValueChange = function() {
    var percent = (((window.v.valueFunded + (parseInt($scope.pledgedValue)) / 1000) / window.v.valueTotal) * 100) + "%";
    $("#pledge-metter .fund-mark, #fund-quantity-component").css("left", percent);
    $("#pledge-metter .to-fund").css("width", percent);
  }
  //----- ----- -----
  $("#predef-pledge-list").delegate(".pledge-item", "click", function(){
    var $this = $(this);
    $scope.$apply(function(){
      if ($this.data("pledge-value") >= $scope.pledgedValue) {
        $scope.pledgedValue = parseInt($this.data("pledge-value"));
        $scope.onPledgeValueChange();
      }
      $this.addClass("current").siblings().removeClass("current");
    });
  });
}])
.controller('newProjectCtrl', ['$scope', function($scope) {
  $scope.projectType = 0;
}])
.controller('accountActionModalCtrl', ['$scope', function($scope) {
  $scope.currentTab = 1;
  $scope.disposeModal = function(){
    $("#login-signup-modal").fadeOut();
  }
  window.accountActionModalScope = $scope;
}])
.controller('userSingleCtrl', ['$scope', function($scope) {
  $scope.currentTab         = 0;
}]);
/* ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- */
$(function(){
  //----- ----- ----- ----- -----
  var accountActionModal = $("#login-signup-modal");
  accountActionModal.hide();
  //----- ----- -----
  function openLoginModal() {
    var scope = angular.element(document.getElementById("login-signup-modal")).scope();
    //----- -----
    scope.$apply(function(){
      scope.currentTab = 0;
    });
    accountActionModal.fadeIn();
  }
  //----- ----- -----
  function openSignupModal() {
    var scope = angular.element(document.getElementById("login-signup-modal")).scope();
    //----- -----
    scope.$apply(function(){
      scope.currentTab = 1;
    });
    accountActionModal.fadeIn();
  }
  //----- ----- -----
  $("#header .menu .menu-item:nth-child(2)").on("click", function(evt){
    evt.preventDefault();
    openLoginModal();
  });
  //----- ----- -----
  $("#header .menu .menu-item:nth-child(3)").on("click", function(evt){
    evt.preventDefault();
    openSignupModal();
  });
  //----- ----- ----- ----- -----
  if (document.getElementById("project-pledge-area")) {
    $("#predef-pledge-list .pledge-item").eq(1).addClass("current");
  }
  if (document.getElementById("pledge-create-component")) {
    $("#pledge-create-component").delegate(".pledge-item", "click", function(){
      $(this).addClass("focus").siblings().removeClass("focus");
    });
  }
});
/* ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- */


