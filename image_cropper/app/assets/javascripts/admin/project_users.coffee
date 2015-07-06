$ ->
  $('input.project').click (e) ->
    url = $(e.target).attr('data-remote')
    project_user_id = $(e.target).attr('value')
    ischeck = $(e.target).is(':checked')
    if ischeck
      $.ajax
        type: 'post'
        url: url
        success: (textStatus, jqXHR) ->
          #window.setAlert 'success', 'Setting was successfully updated.'
        error: (jqXHR, textStatus, errorThrown) ->
          #window.setAlert 'danger', 'Settings cannot be updated' + jqXHR.responseText + '.'
      return
    else
      $.post(url, { _method: 'delete' }, null, "script");
  return
