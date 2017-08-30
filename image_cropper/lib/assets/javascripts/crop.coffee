
# Extract data from view

canvas_selector = '#canvas-1'
project_id = $(canvas_selector).attr('data-project-id')
project_image = $(canvas_selector).attr('data-project-image')
project_image_id = $(canvas_selector).attr('data-project-image-id')
url = $(canvas_selector).attr('data-crop-url')
limit = Number($(canvas_selector).attr('data-crop-limit'))
tags = eval($(canvas_selector).attr('data-tags'))
thickness = eval($(canvas_selector).attr('data-thickness'))
defaultFillColor = 'green'
otherOwnerFillColor = 'yellow'
defaultStrokeColor = 'green'

# Current region being specified

points = []
pointRightClick = { }
pathPolygon = null
circleCurPoint = null
rectCurBB = null
objectCompleted = false

# Context menu variables

defaultTagIndex = 0
menuRegion = []

# Drag and drop interactions

dragging = false
selectedObjects = []
selectedObjectIndex = null
draggingRegionStartPoint = null

# Initialize pathPolygon

reset_path = () ->
  if pathPolygon
    pathPolygon.remove()
  pathPolygon = new Path
  pathPolygon.opacity = 0.5
  pathPolygon.fillColor = defaultFillColor
  pathPolygon.closed = true
  points = []
  objectCompleted = false

reset_path()

# Label a selected region

label = (object) ->
  border = new Path.Rectangle(object.polygon.bounds)
  border.strokeColor = defaultStrokeColor
  border.strokeWidth = thickness
  border.opacity = 0.5
  text = new PointText(new Point(object.polygon.bounds.x, object.polygon.bounds.y-6))
  text.content = object.tag
  text.characterStyle =
    fontSize: 20
    font: 'Arial'
  rect = new Path.Rectangle(text.bounds)
  rect.fillColor = object.fillColor
  rect.opacity = 0.5
  rect.strokeColor = defaultStrokeColor
  text.fillColor = 'black'
  text.insertAbove(rect)
  text.needsUpdate = true
  rect.needsUpdate = true
  border.needsUpdate = true
  object.text = text
  object.border = border
  object.labelBorder = rect

# Add cropper's initials to a selected region

addInitials = (object) ->
  if object.owned
    object.initials = null
  else
    x = object.polygon.bounds.x+object.polygon.bounds.width
    y = object.polygon.bounds.y + object.polygon.bounds.height
    text = new PointText(new Point(x, y))
    text.content = object.owner
    text.style =
      fontSize: 10
      font: 'Arial'
      justification: 'right'
    text.needsUpdate = true
    object.initials = text

# Add a loaded or newly created region to the active region for the context menu

addContextMenuRegion = (object) ->
  x = object.polygon.bounds.x-5
  y = object.polygon.bounds.y-5
  w = object.polygon.bounds.width+10
  h = object.polygon.bounds.height+10
  menuRegion.push { x: x, y: y, w: w, h: h }

# Draw polygon for selected object

drawPolygon = (object, coords) ->
  object.polygon = new Path
  object.points = []
  coords.forEach (coord) ->
    object.polygon.fillColor = object.fillColor
    object.polygon.opacity = 0.5
    object.polygon.strokeColor = defaultStrokeColor
    object.polygon.add new Point(coord.x, coord.y)
    object.points.push({ x: coord.x, y: coord.y })
  object.polygon.closed = true
  object.polygon.needsUpdate = true
  if limit == 2
    object.rect = new Path.Rectangle(object.polygon.bounds)
    object.rect.fillColor = object.fillColor
    object.rect.opacity = 0.5
    object.rect.strokeColor = defaultStrokeColor

# Draw a selected object

drawSelectedObject = (objectAttrs) ->
  object = { }
  object.owned = objectAttrs['owned']
  object.tag = objectAttrs['tag']
  object.id = objectAttrs['id']
  object.owner = objectAttrs['owner']
  object.fillColor = defaultFillColor
  if !object.owned
    object.fillColor = otherOwnerFillColor
  drawPolygon(object, objectAttrs['coords'])
  label(object)
  addInitials(object)
  addContextMenuRegion(object)
  selectedObjects.push(object)

# Get tagged region data from database and draw on the image

redraw = () ->
  $.ajax
    type: 'GET'
    url: url
    dataType: 'json'
    contentType: 'application/json'
    success: (data) ->
      i = 0
      selectedObjects = []
      while i < data.length
        drawSelectedObject(data[i])
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

displayError = (xhr) ->
  errors = xhr.responseJSON.error
  $('div#errors').remove()
  $('div.messages').append(
    '<div id="errors" class="alert alert-danger"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><p>Error:</p><ul></ul></div>')
  for message of errors
    $('#errors ul').append '<li>' + errors[message] + '</li>'

# Close currently active path and submit to server

postNewCrop = (tagId) ->
  tag = null
  tags.forEach (aTag, i) ->
    if aTag.id.toString() == tagId.toString()
      tag = aTag
  if circleCurPoint
    circleCurPoint.remove()
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
      displayError(xhr)
      pathPolygon.needsUpdate = true
      pathPolygon.remove()
      view.update()
      reset_path()
    success: (data) ->
      drawSelectedObject(data)
      reset_path()
      $('.context-menu-list').hide()
      view.update()

# Translate selected crop by (dx, dy) and submit to server

translateSelectedCrop = (dx, dy) ->
  object = selectedObjects[selectedObjectIndex]
  newPoints = []
  object.points.forEach (point) ->
    newPoints.push({x: point.x + dx, y: point.y + dy})
  $.ajax
    type: 'PATCH'
    url: url + '/' + object.id
    data:
      project_crop_image:
        cords: newPoints
      format: 'json'
    error: (xhr, status, error) ->
      displayError(xhr)
    success: (data) ->
      object.border.remove()
      object.text.remove()
      object.labelBorder.remove()
      object.initials.remove() if object.initials
      object.polygon.remove()
      object.rect.remove() if object.rect
      selectedObjects.splice(selectedObjectIndex, 1)
      selectedObjectIndex = null
      drawSelectedObject(data)
      view.update()

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
    postNewCrop(tags[0].id)

# Add a point to current path

addPoint = (e) ->
  if points.length < limit or limit == 0 or limit == null
    if circleCurPoint
      circleCurPoint.remove()
    circleCurPoint = new (Path.Circle)(
      center: e.point
      radius: 3)
    circleCurPoint.strokeColor = defaultStrokeColor
    circleCurPoint.fillColor = 'white'
    pathPolygon.strokeColor = defaultStrokeColor
    pathPolygon.add new Point(e.point)
    points.push
      x: e.point.x
      y: e.point.y
    if limit > 0 and points.length >= limit
      objectCompleted = true
      complete_crop(e)

# Check if this is the beginning of a region move operation

startMove = (e) ->
  found = false
  selectedObjects.forEach (object, i) ->
    if object.text.bounds.contains(e.point)
      selectedObjectIndex = i
      draggingRegionStartPoint = e.point
      found = true
  return found

# Replace second path point during a drag-to-define action

replace_path_point = (e) ->
  if circleCurPoint
    circleCurPoint.remove()
  circleCurPoint = new (Path.Circle)(
    center: e.point
    radius: 3)
  circleCurPoint.strokeColor = defaultStrokeColor
  circleCurPoint.fillColor = 'white'
  pathPolygon.strokeColor = defaultStrokeColor
  if pathPolygon.segments.length >= 2
    pathPolygon.removeSegments(1)
  if points.length >= 2
    points = [points[0]]
  pathPolygon.add new Point(e.point)
  points.push
    x: e.point.x
    y: e.point.y

# Move current bounding box rectangle to indicated bounds

updateRectCurBB = (bounds) ->
  if rectCurBB
    rectCurBB.remove()
  rectCurBB = new Path.Rectangle(bounds)
  rectCurBB.strokeColor = defaultStrokeColor
  rectCurBB.opacity = 1.0
  rectCurBB.needsUpdate = true

moveSelectedObject = (e) ->
  dx = e.point.x - draggingRegionStartPoint.x
  dy = e.point.y - draggingRegionStartPoint.y
  draggingRegionStartPoint = null
  translateSelectedCrop(dx, dy)

# Mouse event handlers:
#  - left click extends the current path
#  - left click and drag on existing region label starts a region move action
#  - left click and drag for a 2-point crop allows specifying object in one drag action
#  - right click within existing region pops up context menu for that region

tool = new Tool
tool.onMouseDown = (e) ->
  if e.event.buttons == 1
    pointRightClick = { }
    dragging = false
    if !startMove(e)
      addPoint(e)

tool.onMouseDrag = (e) ->
  if e.event.buttons == 1
    if selectedObjectIndex != null
      bounds = selectedObjects[selectedObjectIndex].polygon.bounds
      x = bounds.x + e.point.x - draggingRegionStartPoint.x
      y = bounds.y + e.point.y - draggingRegionStartPoint.y
      updateRectCurBB({ x: x, y: y, width: bounds.width, height: bounds.height })
    else if limit == 2
      dragging = true
      replace_path_point(e)
      updateRectCurBB(pathPolygon.bounds)
    view.update()

tool.onMouseUp = (e) ->
  # Not sure why, but we seem to get button 0 for mouseup regardless of button.
  if selectedObjectIndex != null
    moveSelectedObject(e)
  else if limit == 2 and dragging and pathPolygon.segments.length >= 2
    dragging = false
    replace_path_point(e)
    objectCompleted = true
    complete_crop(e)
  if rectCurBB
    rectCurBB.needsUpdate = true
    rectCurBB.remove()

# <Enter> key event handler. Close the current path and POST to server.

$('body').keyup (event) ->
  if event.which == 13
    complete_crop(event)

# Context menu callback for right click on an existing region (DELETE option)

menuCallback = (key, options) ->
  if key == 'delete'
    $.ajax
      type: 'DELETE'
      url: url + '/1?x=' + pointRightClick.x + '&y=' + pointRightClick.y
      dataType: 'json'
      contentType: 'application/json'
      success: (data) ->
        location.reload()
  return true

# Context menu callback for selection of a tag from the radio button list

tagCallback = (key, options) ->
  val = $('input[name="context-menu-input-radio"]:checked').val()
  defaultTagIndex = val
  postNewCrop(val)

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
      pointRightClick.x = x
      pointRightClick.y = y
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
