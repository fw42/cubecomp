class window.EmailTemplateFetcher
  constructor: (@base_url) ->

  setEditor: (editor) ->
    console.log("set editor")
    @editor = editor

  fetch: (id) ->
    if id
      url = @base_url + '/' + id
      $.getJSON url, (data) =>
        @setValues(data['subject'], data['content'])
    else
      @setValues('', '')

  setValues: (subject, content) ->
    $('input#competitor_email_subject').val(subject)
    @editor.setValue(content)
