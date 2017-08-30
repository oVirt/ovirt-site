//= require jquery
//= require moment
//= require fullcalendar
//= require chartjs
//= require_tree ./vendor
//= require_tree ./lib

/* Turn off parts of bootstrap that you do not need in
 * _bootstrap-includes.js */
//= require _bootstrap-includes

//= require bootstrap-sortable
var expandIcon =   "▾";
var collapseIcon = "▸";

var stateToggleLeftAreaOpen;

$( document ).ready(function() {
  stateToggleLeftAreaOpen = getCookie("stateToggleLeftAreaOpen");
  handleToggleLeftArea();
});
$( "#toggleLeftArea" ).click(function() {
  handleToggleLeftArea();
});

function handleToggleLeftArea (){
  setCookie("stateToggleLeftAreaOpen",stateToggleLeftAreaOpen);
  if (stateToggleLeftAreaOpen) {
      $('#toggleLeftArea').html(expandIcon+ " Features List");
      $('.feature-sidebar').show();
      $('.feature-info').removeClass( "col-md-12" ).addClass( "col-md-8" );
  } else {

      $('#toggleLeftArea').html(collapseIcon+" Features List");
      $('.feature-sidebar').hide();
      $('.feature-info').removeClass( "col-md-8" ).addClass( "col-md-12" );
  }
  stateToggleLeftAreaOpen = !stateToggleLeftAreaOpen;
}


var arrStateToggleOpenCategories = {};
var enableUI = true;
function restoreStateToggleOpenCategories(){
  $( document ).ready(function() {
    arrStateToggleOpenCategories = getCookie("arrStateToggleOpenCategories");
    if (arrStateToggleOpenCategories == null) {
        arrStateToggleOpenCategories = {};
    }
    $('.feature_list_in_category').hide();
    $('.collapseExpandSection').html (collapseIcon);
    if (enableUI) {
      for (featureCategory in arrStateToggleOpenCategories) {
        if (arrStateToggleOpenCategories[featureCategory]) {
          var el = $('#' + featureCategory);
          handleToggleFeatureCategory(el, true);
          }
      }
    }
  });
}
restoreStateToggleOpenCategories();

function handleSearchActive(){
  if (enableUI) {
    $('.feature_list_in_category').show();
    $('.collapseExpandSection').html (expandIcon);
  }
  enableUI = false;
}

function handleSearchDeactivate(){
  enableUI = true;
  restoreStateToggleOpenCategories();
}

$( ".ovirtToggleFeatureCategory" ).click(function() {
  if (enableUI) {handleToggleFeatureCategory($(this),false);}
});

function handleToggleFeatureCategory(scope, isCookie){
  scope.parent().find('.feature_list_in_category').toggle( 0, function() {
    var catName = scope.parent().find(".ovirtToggleFeatureCategory")[0].id;
    var catValue = isCookie ?  true : scope.parent().find('.feature_list_in_category').is( ":visible" );
    arrStateToggleOpenCategories ["catName"] = catValue;
    if (catValue) {
      (scope.parent().find('.collapseExpandSection')).html (expandIcon);
      arrStateToggleOpenCategories[catName] = true;
    } else {
      (scope.parent().find('.collapseExpandSection')).html (collapseIcon);
      delete arrStateToggleOpenCategories[catName];
    }
    setCookie("arrStateToggleOpenCategories", arrStateToggleOpenCategories);
  });
}






function setCookie(cname, cvalue) {
    localStorage.setItem(cname, JSON.stringify(cvalue));
}


function getCookie(cname) {
  return JSON.parse(localStorage.getItem(cname));
}
