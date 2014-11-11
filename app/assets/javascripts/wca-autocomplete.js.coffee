$(document).ready ->
  autocompleteURL = $("#competitor_wca").attr("data-url")

  $("#competitor_wca").autocomplete(
    source: autocompleteURL,
    minLength: 6,
    select: (event, ui) ->

      names = ui.item.name.split(" ")
      firstName = names[0]
      lastName = names[1]
      country = ui.item.country
      gender = ui.item.gender

      # FIXME: Everything works except for
      #        setting wca id
      $("#competitor_wca").val(ui.item.id)
      $("#competitor_first_name").val(firstName)
      $("#competitor_last_name").val(lastName)
      $("#competitor_country_id option").filter( ->
        $(this).html().toLowerCase() == country.toLowerCase()
      ).attr("selected", "selected")
      switch gender
        when "m" then $("#competitor_male_true").attr("checked", "checked")
        when "f" then $("#competitor_male_false").attr("checked", "checked")
  ).autocomplete("instance")._renderItem = (ul, item) ->
    $("<li>")
      .append("<a>" + item.id + "<br>" + item.name + "</a>")
      .appendTo(ul)
