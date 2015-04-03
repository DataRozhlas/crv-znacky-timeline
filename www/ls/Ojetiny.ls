data =
  * name: "Všechna vozidla"
    ojete: 149089
    nove: 268531
  * name: "Osobní automobily"
    ojete: 121846
    nove: 192923
  * name: \Motocykly
    ojete: 11799
    nove: 15969
  * name: "Autobusy"
    ojete: 242
    nove: 1452
  * name: "Nákladní vozy"
    ojete: 16934
    nove: 33683
  * name: "Traktory"
    ojete: 472
    nove: 2621


ig.ojetiny = (container) ->
  format = ig.utils.formatNumber
  container.append \h2
    ..html "Koupená nová × ojetá vozidla v roce 2014"
  container.selectAll \div.item .data data .enter!append \div
    ..attr \class \item
    ..append \span .attr \class \name .html (.name)
    ..append \div .attr \class \half-line
    ..append \div
      ..attr \class \bar
      ..append \div
        ..attr \class \fill
        ..style \width -> "#{100 * it.nove / (it.ojete + it.nove)}%"
    ..append \div .attr \class \half-line-inner
    ..append \span
      ..attr \class \nove
      ..html ->
        "<b>#{format it.nove}</b><br>
        #{format it.nove / (it.ojete + it.nove) * 100} %"
    ..append \span
      ..attr \class \ojete
      ..html ->
        "<b>#{format it.ojete}</b><br>
        #{format it.ojete / (it.ojete + it.nove) * 100} %"
    ..filter ((d, i) -> i == 0)
      ..append \span
        ..attr \class \popisek-nove
        ..html "Nové"
      ..append \span
        ..attr \class \popisek-ojete
        ..html "Ojeté"
