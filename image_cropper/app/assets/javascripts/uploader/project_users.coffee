$ ->
  $('input.user').click (e) ->
    url = $(e.target).attr('data-remote')
    project_user_id = $(e.target).attr('value')
    ischeck = $(e.target).is(':checked')
    if ischeck
      $.ajax
        type: 'post'
        url: url
        success: (textStatus, jqXHR) ->
          window.location = window.location.pathname
      return
    else
      $.post(url, { _method: 'delete' }, null, "script");
      window.location = window.location.pathname
  return

  
