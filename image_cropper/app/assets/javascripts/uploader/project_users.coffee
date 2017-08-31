
window.displayError = (xhr) ->
  errors = xhr.error
  $('div#errors').remove()
  $('div.messages').append(
    '<div id="errors" class="alert alert-danger"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><p>Error:</p><ul></ul></div>')
  for message of errors
    $('#errors ul').append '<li>' + errors[message] + '</li>'

$ ->
  $('input.user').click (e) ->
    url = $(e.target).attr('data-remote')
    project_user_id = $(e.target).attr('value')
    ischeck = $(e.target).is(':checked')
    if ischeck
      $.ajax
        type: 'post'
        url: url
        success: (data, textStatus, jqXHR) ->
          $(e.target).prop('checked', true)
          $(e.target).attr('data-remote', data.delete_path)
        error: (jqXHR, textStatus, error) ->
          window.displayError(jqXHR)
      return false
    else
      $.ajax
        type: 'delete'
        url: url
        success: (data, textStatus, jqXHR) ->
          $(e.target).prop('checked', false)
          $(e.target).attr('data-remote', data.create_path)
        error: (jqXHR, textStatus, error) ->
          window.displayError(jqXHR)
      return false
