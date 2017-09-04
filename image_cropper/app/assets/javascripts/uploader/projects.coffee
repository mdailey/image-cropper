
$ ->
  $('input#project_tag_tokens').tokenInput '/uploader/tags.json',
    prePopulate: $('input#project_tag_tokens').data('load')
    crossDomain: false
