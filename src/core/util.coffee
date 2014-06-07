slice = Array.prototype.slice

module.exports =
  last: (array, n = null) ->
    if n
      return slice.call(array, Math.max(array.length - n, 0))
    else
      return array[array.length - 1]

  matchSize: (elementToMatch, elementsToResize, callback = ->) ->
    resize = =>
      for el in elementsToResize
        el.style.width = "#{elementToMatch.offsetWidth}px"
        el.style.height = "#{elementToMatch.offsetHeight}px"
        if el.width?
          el.setAttribute('width', el.offsetWidth)
          el.setAttribute('height', el.offsetHeight)
      callback()

    elementToMatch.addEventListener 'resize', resize
    window.addEventListener 'resize', resize
    window.addEventListener 'orientationchange', resize
    resize()

  combineCanvases: (a, b) ->
    c = document.createElement('canvas')
    c.width = Math.max(a.width, b.width)
    c.height = Math.max(a.height, b.height)
    ctx = c.getContext('2d')
    ctx.drawImage(a, 0, 0)
    ctx.drawImage(b, 0, 0)
    c

  renderShapes: (shapes, bounds, scale=1, canvas=null) ->
    canvas = canvas or document.createElement('canvas')
    canvas.width = bounds.width * scale
    canvas.height = bounds.height * scale
    ctx = canvas.getContext('2d')
    ctx.translate(-bounds.x * scale, -bounds.y * scale)
    ctx.scale(scale, scale)
    for shape in shapes
      shape.draw(ctx)
    canvas

  # [{x, y, width, height}]
  getBoundingRect: (rects) ->
    return {x: 0, y: 0, width: 0, height: 0} unless rects.length
    minX = rects[0].x
    minY = rects[0].y
    maxX = rects[0].x + rects[0].width
    maxY = rects[0].y + rects[0].height
    for rect in rects
      minX = Math.floor Math.min(rect.x, minX)
      minY = Math.floor Math.min(rect.y, minY)
      maxX = Math.ceil Math.max(maxX, rect.x + rect.width)
      maxY = Math.ceil Math.max(maxY, rect.y + rect.height)
    {x: minX, y: minY, width: maxX - minX, height: maxY - minY}
