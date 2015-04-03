data =
  * name: "Celkem"
    firemni: 125564
    soukrome: 66750
  * name: "Škoda"
    firemni: 45846
    soukrome: 12245
  * name: "Hyundai"
    firemni: 9517
    soukrome: 9417
  * name: "Volkswagen"
    firemni: 12581
    soukrome: 5700
  * name: "Ford"
    firemni: 8371
    soukrome: 4205
  * name: "Dacia"
    firemni: 4184
    soukrome: 5096


ig.firemni = (container) ->
  format = ig.utils.formatNumber
  container.append \h2
    ..html "Nová firemní × soukromá vozidla v roce 2014"
  container.selectAll \div.item .data data .enter!append \div
    ..attr \class \item
    ..append \span .attr \class \name .html (.name)
    ..append \div .attr \class \half-line
    ..append \div
      ..attr \class \bar
      ..append \div
        ..attr \class \fill
        ..style \width -> "#{100 * it.firemni / (it.firemni + it.soukrome)}%"
    ..append \div .attr \class \half-line-inner
    ..append \span
      ..attr \class \nove
      ..html ->
        "<b>#{format it.firemni}</b><br>
        #{format it.firemni / (it.firemni + it.soukrome) * 100} %"
    ..append \span
      ..attr \class \ojete
      ..html ->
        "<b>#{format it.soukrome}</b><br>
        #{format it.soukrome / (it.firemni + it.soukrome) * 100} %"
    ..filter ((d, i) -> i == 0)
      ..append \span
        ..attr \class \popisek-nove
        ..html "Firemní"
      ..append \span
        ..attr \class \popisek-ojete
        ..html "Soukromé"
