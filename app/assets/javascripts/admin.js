// Those two have to be loaded in this order
//= require jquery
//= require jquery.turbolinks

//= require jquery_ujs
//= require jquery.nested_attributes
//= require jquery.ba-throttle-debounce

// require sb-admin-2/jquery-1.11.0
//= require sb-admin-2/bootstrap.min
//= require sb-admin-2/plugins/metisMenu/metisMenu.min
// require sb-admin-2/plugins/morris/raphael.min
// require sb-admin-2/plugins/morris/morris.min
// require sb-admin-2/plugins/morris/morris-data
//= require sb-admin-2/sb-admin-2

//= require codemirror
//= require codemirror/modes/htmlmixed
//= require codemirror/modes/xml
//= require codemirror/modes/javascript
//= require codemirror/modes/css

//= require typeahead.jquery
//= require wca-autocomplete

// This should be the last one to be loaded
//= require turbolinks

function setAllTooltips() {
  $('.with-tooltip').tooltip({
    selector: "[data-toggle=tooltip]",
    container: "body",
    html: true
  })
}

function hideAllTooltips() {
  $('.tooltip').hide();
}
