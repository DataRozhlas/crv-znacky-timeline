ig.makeScrollable = (container) ->
  listItems = container.node!querySelectorAll \li
  list = container.select \ul
  maxHeight = 650
  container.style \height "#{maxHeight}px"
  currentGroup = []
  currentHeight = 0
  allGroups = []
  for item, index in listItems
    currentStart = item if currentStart is null
    height = item.clientHeight
    currentHeight += height
    if currentHeight > maxHeight
      padGroup do
        currentGroup
        maxHeight - (currentHeight - height)
      currentHeight = height
      allGroups.push currentGroup
      currentGroup = [item]
    else
      currentGroup.push item
  padGroup currentGroup, maxHeight - currentHeight
  allGroups.push currentGroup
  selector = container.append \div .attr \class \selector
  selectorItems = selector.selectAll \a.item .data allGroups .enter!append \a
    ..attr \href \#
    ..append \span
      ..attr \class \znacka
      ..html ->
        it.map (.querySelector ".name" .innerHTML) .join ", "

    ..attr \class \item
    ..on \click (d, index) ~>
      d3.event.preventDefault!
      list.style \transform "translate(0, -#{index * maxHeight}px)"
      selectorItems.classed \active (d, i) -> i is index

  selectorItems
    .classed \active (d, i) -> i is 0



padGroup = (group, heightSurplus) ->
  padding = Math.floor heightSurplus / (group.length + 1)
  for item in group
    item.style.marginTop = "#{padding}px"
  group[*-1].style.marginBottom = "#{padding}px"
