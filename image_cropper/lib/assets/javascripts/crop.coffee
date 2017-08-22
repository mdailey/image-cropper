
# Declare variables for cropping

point_num = 1
x_coords = []
y_coords = []
points = []
click_point = { }
myPath = null
myCircle = null
project_id = $('#canvas-1').attr('data-project-id')
project_image = $('#canvas-1').attr('data-project-image')
project_image_id = $('#canvas-1').attr('data-project-image-id')
url = $('#canvas-1').attr('data-crop-url')
limit = $('#canvas-1').attr('data-crop-limit')
tags = eval($('#canvas-1').attr('data-tags'))
defaultTag = tags[0].name
menuRegion = []

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

initials = (path, tag) ->
  text = new PointText(new Point(path.bounds.x+path.bounds.width, path.bounds.y + path.bounds.height))
  text.content = tag
  text.style =
    fontSize: 10
    font: 'Arial'
    justification: 'right'
  text.needsUpdate = true
  view.update()

addContextMenuRegion = (path) ->
  x = path.bounds.x-5
  y = path.bounds.y-5
  w = path.bounds.width+10
  h = path.bounds.height+10
  menuRegion.push { x: x, y: y, w: w, h: h }

# Get data from database and draw on image

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

# Load image

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

# <Enter> key event handler. Close the current path and POST to server.

$('body').keyup (event) ->
  if event.which == 13
    if myCircle
      myCircle.remove()
      view.update()
    $.ajax
      type: 'POST'
      url: url
      data:
        project_crop_image:
          project_image_id: project_image_id
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
        label(myPath, defaultTag, 'red')
        addContextMenuRegion(myPath)
        reset_path()

# Context menu right click event

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

$.contextMenu
  selector: '#canvas-1'
  reposition: false
  build: (trigger, e) ->
    x = e.pageX - $('#canvas-1').offset().left
    y = e.pageY - $('#canvas-1').offset().top
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
