# Declare variables for cropping
point_num = 1
x_cords = []
y_cords = []
points = []
click_point = []
myPath = new Path
project_id = $('#canvas-1').attr('data-project-id')
project_image = $('#canvas-1').attr('data-project-image')
project_image_id = $('#canvas-1').attr('data-project-image-id')
url = $('#canvas-1').attr('data-crop-url')
limit = $('#canvas-1').attr('data-crop-limit')

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
        while ii < data[i]['cords'].length
          myPath.fillColor = 'red'
          myPath.opacity = 0.5
          myPath.strokeColor = 'black'
          myPath.add new Point(data[i]['cords'][ii].x, data[i]['cords'][ii].y)
          ii++
        myPath.closed = true
        i++
      myPath = new Path
      return
  return


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

# Click event
tool = new Tool
tool.onMouseDown = (e) ->
    if point_num <= limit or limit == 99
      click_point = []
      if e.event.buttons == 1
        myCircle = new (Path.Circle)(
          center: e.point
          radius: 3)
        myCircle.strokeColor = 'black'
        myCircle.fillColor = 'white'
        myPath.strokeColor = 'black'
        myPath.add new Point(e.point)
        x_cords.push e.point.x
        y_cords.push e.point.y
        points.push
          x: e.point.x
          y: e.point.y
      click_point.push
        x: e.point.x
        y: e.point.y

# 'Enter' Event
$('body').keyup (event) ->
  if event.which == 13
    $.ajax
      type: 'POST'
      url: url
      data:
        project_crop_image:
          project_image_id: project_image_id
          image: Date.now().toString() + '.png'
        cords: points
      complete: ->
    x_cords = []
    y_cords = []
    points = []
    myPath.strokeColor = 'black'
    myPath.closed = true
    point_num = 0
    myPath = new Path
  return

# 'Right Click' Event
$.contextMenu
  selector: '#canvas-1'
  callback: (key, options) ->
    if key == 'delete'
      $.post url + '/1?x=' + click_point[0].x + '&y=' + click_point[0].y, { _method: 'delete' }, null, 'script'
      window.location = url
    return
  items: 'delete':
    name: 'Delete'
    icon: 'delete'
