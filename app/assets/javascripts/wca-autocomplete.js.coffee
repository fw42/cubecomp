$(document).ready ->
  $wcaIdField = $("#competitor_wca")
  return unless $wcaIdField.length > 0
  return unless $wcaIdField.attr("data-enable") == "true"

  autocompleteURL = $wcaIdField.attr("data-url")

  fetchData = (q, callback) ->
    $.getJSON(autocompleteURL + "/#{q}.json")
      .done (result) ->
        callback(result)

  auto = $wcaIdField.typeahead {
    minLength: 6
  }, {
    source: $.debounce(250, fetchData)

    matcher: (item) ->
      true

    name: 'wca-competitors'

    displayKey: (object) ->
      object.id

    templates:
      suggestion: (item) ->
        '<li><a tabindex="-1" href="javascript:void(0)"><strong>' + item.id + '</strong></a> <small>(' + item.name + ')</small></li>'
  }

  auto.bind "typeahead:selected", (event, object) ->
    names = object.name.split(" ")
    firstName = names[0]
    lastName = names.slice(1, names.length).join(" ")
    country = object.countryId
    gender = object.gender

    $("#competitor_first_name").val(firstName)
    $("#competitor_last_name").val(lastName)
    $("#competitor_country_id option").filter( ->
      $(this).html().toLowerCase() == country.toLowerCase()
    ).attr("selected", "selected")
    switch gender
      when "m" then $("#competitor_gender").val("male")
      when "f" then $("#competitor_gender").val("female")
      when "o" then $("#competitor_gender").val("other")
