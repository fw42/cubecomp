$(document).ready ->
  return unless $("#competitor_wca").length > 0
  return unless $("#competitor_wca").attr("data-enable") == "true"

  autocompleteURL = $("#competitor_wca").attr("data-url")

  auto = $("#competitor_wca").typeahead {
    minLength: 6
  },{
    source: (q, callback) ->
      $.getJSON(autocompleteURL + "?q=#{q}")
        .done (result) ->
          callback(result)
    matcher: (item) ->
      true
    name: 'wca-competitors'
    displayKey: (object) ->
      object.id
    templates:
      suggestion: (item) ->
        '<li role="presentation"><a role="menuitem" tabindex="-1" href="#"><strong>' + item.id + '</strong></a> <small>(' + item.name + ')</small></li>'
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
