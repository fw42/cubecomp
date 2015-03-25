$(document).ready ->
  $wcaIdField = $("#competitor_wca")
  return unless $wcaIdField.length > 0
  return unless $wcaIdField.attr("data-enable") == "true"

  autocompleteURL = $wcaIdField.attr("data-url")

  auto = $wcaIdField.typeahead {
    minLength: 6
  }, {
    source: (q, callback) ->
      $.getJSON(autocompleteURL + "/#{q}.json")
        .done (result) ->
          callback(result)

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
    lastName = names[1]
    country = object.country
    gender = object.gender

    $("#competitor_first_name").val(firstName)
    $("#competitor_last_name").val(lastName)
    $("#competitor_country_id option").filter( ->
      $(this).html().toLowerCase() == country.toLowerCase()
    ).attr("selected", "selected")
    switch gender
      when "m" then $("#competitor_male_true").attr("checked", "checked")
      when "f" then $("#competitor_male_false").attr("checked", "checked")
