
# Declare variables for cropping

point_num = 1
x_coords = []
y_coords = []
points = []
click_point = { }
myPath = null
myCircle = null
canvas_selector = '#canvas-1'
project_id = $(canvas_selector).attr('data-project-id')
project_image = $(canvas_selector).attr('data-project-image')
project_image_id = $(canvas_selector).attr('data-project-image-id')
url = $(canvas_selector).attr('data-crop-url')
limit = $(canvas_selector).attr('data-crop-limit')
tags = eval($(canvas_selector).attr('data-tags'))
defaultTagIndex = 0
menuRegion = []
objectCompleted = false

# Initialize myPath

reset_path = () ->
  myPath = new Path
  myPath.opacity = 0.5
  myPath.fillColor = 'red'
  myPath.closed = true
  x_coords = []
  y_coords = []
  points = []
  point_num = 1
  objectCompleted = false

reset_path()

# Label a selected region

label = (path, tag, fillColor) ->
  border = new Path.Rectangle(path.bounds)
  border.strokeColor = 'black'
  border.opacity = 0.5
  text = new PointText(new Point(path.bounds.x, path.bounds.y-6))
  text.content = tag
  text.characterStyle =
    fontSize: 20
    font: 'Arial'
  rect = new Path.Rectangle(text.bounds)
  rect.fillColor = fillColor
  rect.opacity = 0.5
  rect.strokeColor = 'black'
  text.fillColor = 'black'
  text.insertAbove(rect)
  text.needsUpdate = true
  rect.needsUpdate = true
  border.needsUpdate = true
  view.update()

# Add cropper's initials to a selected region

initials = (path, tag) ->
  text = new PointText(new Point(path.bounds.x+path.bounds.width, path.bounds.y + path.bounds.height))
  text.content = tag
  text.style =
    fontSize: 10
    font: 'Arial'
    justification: 'right'
  text.needsUpdate = true
  view.update()

# Add a loaded or newly created region to the active region for the context menu

addContextMenuRegion = (path) ->
  x = path.bounds.x-5
  y = path.bounds.y-5
  w = path.bounds.width+10
  h = path.bounds.height+10
  menuRegion.push { x: x, y: y, w: w, h: h }

# Get tagged region data from database and draw on the image

redraw = () ->
  $.ajax
    type: 'GET'
    url: url
    dataType: 'json'
    contentType: 'application/json'
    success: (data) ->
      i = 0
      while i < data.length
        myPath = new Path
        ii = 0
        fillColor = 'red'
        if !data[i]['owned']
          fillColor = 'yellow'
        while ii < data[i]['coords'].length
          myPath.fillColor = fillColor
          myPath.opacity = 0.5
          myPath.strokeColor = 'black'
          myPath.add new Point(data[i]['coords'][ii].x, data[i]['coords'][ii].y)
          ii++
        myPath.closed = true
        label(myPath, data[i]['tag'], fillColor)
        if !data[i]['owned']
          initials(myPath, data[i]['owner'])
        addContextMenuRegion(myPath)
        myPath.needsUpdate = true
        i++
      reset_path()
      view.update()

# Load the current image onto the canvas

raster = null

load_image = () ->
    if raster
        raster.remove()
    raster = new Raster $("#canvas-1").attr("data-project-image")
    raster.on 'load', () ->
        canvas = $("#canvas-1")
        canvas.width(raster.width)
        canvas.height(raster.height)
        raster.position = [raster.width/2, raster.height/2]
        view.setViewSize(canvas.width(), canvas.height())
        redraw()

load_image()

# Close currently active path and submit to server

submit_crop = (tagId) ->
  tag = null
  tags.forEach (aTag, i) ->
    if aTag.id.toString() == tagId.toString()
      tag = aTag
  if myCircle
    myCircle.remove()
    view.update()
  $.ajax
    type: 'POST'
    url: url
    data:
      project_crop_image:
        project_image_id: project_image_id
        tag_id: tagId
        image: Date.now().toString() + '.png'
      cords: points
      format: 'json'
    error: (xhr, status, error) ->
      errors = xhr.responseJSON.error
      $('div#errors').remove()
      $('div.messages').append(
        '<div id="errors" class="alert alert-danger"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><p>Error:</p><ul></ul></div>')
      for message of errors
        $('#errors ul').append '<li>' + errors[message] + '</li>'
      myPath.needsUpdate = true
      myPath.remove()
      view.update()
      reset_path()
    success: ->
      label(myPath, tag.name, 'red')
      addContextMenuRegion(myPath)
      reset_path()
      $('.context-menu-list').hide()

# Tag a crop then submit to server

tag_and_submit_crop = (menuPos) ->
  # Data are actually submitted to the server by the menu callback
  $(canvas_selector).contextMenu(menuPos)

# Function to complete a crop

complete_crop = (e) ->
  if tags.length > 1
    menuPos = {x: $(canvas_selector).offset().left + e.point.x, y: $(canvas_selector).offset().top + e.point.y}
    tag_and_submit_crop(menuPos)
  else
    submit_crop(tags[0].id)

# Click event handler. Left click extends the current path.

tool = new Tool
tool.onMouseDown = (e) ->
  if point_num <= limit or limit == 99
    click_point = []
    point_num++
    if e.event.buttons == 1
      if myCircle
        myCircle.remove()
      myCircle = new (Path.Circle)(
        center: e.point
        radius: 3)
      myCircle.strokeColor = 'black'
      myCircle.fillColor = 'white'
      myPath.strokeColor = 'black'
      myPath.add new Point(e.point)
      x_coords.push e.point.x
      y_coords.push e.point.y
      points.push
        x: e.point.x
        y: e.point.y
      if point_num > limit
        objectCompleted = true
        complete_crop(e)

# <Enter> key event handler. Close the current path and POST to server.

$('body').keyup (event) ->
  if event.which == 13
    complete_crop(event)

# Context menu callback for right click on an existing region (DELETE option)

menuCallback = (key, options) ->
  if key == 'delete'
    $.ajax
      type: 'DELETE'
      url: url + '/1?x=' + click_point.x + '&y=' + click_point.y
      dataType: 'json'
      contentType: 'application/json'
      success: (data) ->
        location.reload()
  return true

# Context menu callback for selection of a tag from the radio button list

tagCallback = (key, options) ->
  submit_crop($('input[name="context-menu-input-radio"]:checked').val())

# Create a dynamic context menu for the canvas

$.contextMenu
  selector: canvas_selector
  reposition: false
  build: (trigger, e) ->
    if e.isTrigger and objectCompleted
      # We were triggered by completion of an object selection with multiple tags
      $('.context-menu-list').show()
      items = {
        'sep1': "---------"
      }
      tags.forEach (tag, i) ->
        selected = i == defaultTagIndex
        items['tag'+i] = { name: tag.name, type: 'radio', radio: 'radio', value: tag.id, selected: selected }
      items['sep2'] = "---------"
      items['button'] = { name: 'Submit', callback: tagCallback }
      return {
        items: items
      }
    else
      # We were triggered by right click on an existing object region
      x = e.pageX - $(canvas_selector).offset().left
      y = e.pageY - $(canvas_selector).offset().top
      click_point.x = x
      click_point.y = y
      found = false
      for r in menuRegion
        if x >= r.x and y >= r.y and x <= r.x + r.w and y <= r.y + r.h
          found = true
      if found
        $('.context-menu-list').show()
        return {
          callback: menuCallback
          items: {
            'delete': {name: 'Delete', icon: 'delete'}
          }
        }
      else
        $('.context-menu-list').hide()
        return {
          callback: (key, options) ->
            return true
          #items: {'empty': {name: 'No object here', icon: 'close'}}
          items: { }
        }
