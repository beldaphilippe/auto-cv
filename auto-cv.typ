#import "@preview/datify:1.0.1": custom-date-format
#import "@preview/fontawesome:0.6.1": fa-icon
// in grand part inspired from https://github.com/dialvarezs/neat-cv

// ============================== CONSTANTS ==============================

// main content
#let ENTRY_LEFT_COLUMN_WIDTH = 2em
#let ENTRY_DATE_FONT_SIZE_SCALE = 0.9
#let ENTRY_CONTENT_FONT_SIZE_SCALE = 1.2//0.85
#let ENTRY_GAP = 1.2em // spacing between consecutive entries

// side bar
#let SIDE_CONTENT_FONT_SIZE_SCALE = 0.72

// footer
#let FOOTER_FONT_SIZE_SCALE = 0.7
#let DOT_SEPARATOR = box(inset: (x: 0.5em), sym.dot.c)

// other
#let _page-labels = (
  af: ("Bladsy", "van"),
  ca: ("Pàgina", "de"),
  cs: ("Strana", "z"),
  da: ("Side", "af"),
  de: ("Seite", "von"),
  en: ("Page", "of"),
  es: ("Página", "de"),
  et: ("Leht", "lehest"),
  fi: ("Sivu", "/"),
  fr: ("Page", "sur"),
  hr: ("Stranica", "od"),
  hu: ("Oldal", "/"),
  it: ("Pagina", "di"),
  ja: ("ページ", "/"),
  ko: ("페이지", "/"),
  nl: ("Pagina", "van"),
  no: ("Side", "av"),
  pl: ("Strona", "z"),
  pt: ("Página", "de"),
  ro: ("Pagina", "din"),
  ru: ("Страница", "из"),
  sk: ("Strana", "z"),
  sl: ("Stran", "od"),
  sr: ("Страна", "од"),
  sv: ("Sida", "av"),
  tr: ("Sayfa", "/"),
  uk: ("Сторінка", "з"),
  zh: ("第", "页，共"),
)

// ============================== STATES ==============================
#let _theme = state("_theme", (:))
#let _author = state("_author", (:))

// ============================== CODE ==============================
#let contact-info() = context {
  let accent-color = _theme.get().accent-color

  let contact-defs = (
    ("email", "envelope", a => link("mailto:" + a.email, a.email)),
    (
      "matrix",
      "comment",
      a => link("https://matrix.to/#/" + a.matrix, a.matrix),
    ),
    ("phone", "mobile-screen", a => link("tel:" + a.phone, a.phone)),
    ("address", "house", a => a.address),
  )

  let contact-items = ()
  for (key, icon, render) in contact-defs {
    if key in _author.get() {
      contact-items += (
        [#v(-0.2em) #fa-icon(icon, fill: accent-color)],
        render(_author.get()),
      )
    }
  }

  if contact-items.len() > 0 {
    table(
      columns: (1em, 1fr),
      align: (center, left),
      inset: 0pt,
      column-gutter: 0.5em,
      row-gutter: 1em,
      stroke: none,
      ..contact-items
    )
  }
}
#let __fa-icon-outline(
  /// FontAwesome icon name
  /// -> string
  icon,
  /// Icon size
  /// -> length
  size: 1.5em,
) = (
  context {
    box(
      fill: _theme.get().accent-color.lighten(10%),
      width: size,
      height: size,
      radius: size / 2,
      align(
        center + horizon,
        [
          // Adjust vertical position slightly to center the icon
          #v(-0.15 * size)
          #fa-icon(icon, fill: white, size: size - .55em)
        ],
      ),
    )
  }
)
#let __social-link(
  /// FontAwesome icon name
  /// -> string
  icon,
  /// Link URL
  /// -> string
  url,
  /// Display text
  /// -> string
  display,
  /// Icon size
  /// -> length
  size: 1.5em,
  inline: false,
) = (
  context {
    set text(size: 0.95em)

    // block(width: 100%, height: size, radius: 0.6em, align(horizon, [
    //   #__fa-icon-outline(icon, size: size)
    //   #box(inset: (left: 0.2em), height: 100%, link(url)[#display])
    // ]))

    let content = align(horizon, [
      #link(url)[
        #__fa-icon-outline(icon, size: size)
        #box(inset: (left: 0.2em), height: 100%, display)
      ]
    ])

    if inline {
      box(height: size, content)
    } else {
      block(width: 100%, height: size, radius: 0.6em, content)
    }
  }
)
#let social-links() = (
  context {
    let social-defs = (
      ("website", "globe", ""),
      ("twitter", "twitter", "https://twitter.com/"),
      ("mastodon", "mastodon", "https://mastodon.social/"),
      ("github", "github", "https://github.com/"),
      ("gitlab", "gitlab", "https://gitlab.com/"),
      ("linkedin", "linkedin", "https://www.linkedin.com/in/"),
      ("researchgate", "researchgate", "https://www.researchgate.net/profile/"),
      (
        "scholar",
        "google-scholar",
        "https://scholar.google.com/citations?user=",
      ),
      ("orcid", "orcid", "https://orcid.org/"),
    )

    set text(size: 0.95em)

    for (key, icon, url-prefix) in social-defs {
      if key in _author.get() {
        let url = url-prefix + _author.get().at(key)
        let display = _author.get().at(key)

        if key == "website" {
          display = display.replace(regex("https?://"), "")
        } else if key == "mastodon" {
          url = {
            let parts = display.split("@")
            if parts.len() >= 3 {
              "https://" + parts.at(2) + "/@" + parts.at(1)
            } else {
              url-prefix + display
            }
          }
        }

        __social-link(icon, url, display)
      }
    }

    if "custom-links" in _author.get() {
      for link in _author.get().custom-links {
        __social-link(
          if "icon-name" in link and link.icon-name != none {
            link.icon-name
          } else {
            "link"
          },
          link.url,
          link.label,
        )
      }
    }
  }
)

#let entry(
  /// Entry title
  /// -> string
  title: "",
  /// Date or range
  /// -> string
  date: "",
  /// Institution or company
  /// -> string
  institution: "",
  /// Location
  /// -> string
  location: "",
  /// Description/details
  /// -> content
  description,
) = {
  context block(above: 0em, below: 0em)[
    #grid(
      columns: (ENTRY_LEFT_COLUMN_WIDTH, auto),
      align: (center, left),
      // column-gutter: .8em,
      gutter: 0em,
      stroke: (x, y) => if x == 0 { (left: .1em + black) },
      // stroke: black,
      [
        #let line-stroke = .11em + _theme.get().header-color
        #let circle-radius = .25em
        #place(center + top, dx: -ENTRY_LEFT_COLUMN_WIDTH / 2)[
          #circle(radius: circle-radius, stroke: line-stroke, fill: white)
        ]
      ],
      [
        // #set text(size: ENTRY_CONTENT_FONT_SIZE_SCALE * 1em)
        #if title != "" or date != "" [
          #text(size: 1.1em, weight: "semibold", title) #h(1fr) #text(size: ENTRY_DATE_FONT_SIZE_SCALE * 1em)[#date]\
        ]
        #text(smallcaps([
          #if institution != "" or location != "" [
            #fa-icon("location-dot", size: 0.85em, fill: _theme.get().accent-color)
            #institution, #location \
          ]
        ]))
        #text(size: 1em, description)
        #v(ENTRY_GAP)
      ],
    )
  ]
}

#let cv(
  paper-size: "a4",
  page-margin: (
    left: 3em,
    right: 3em,
    top: 3em,
    bottom: 3em,
  ),
  author: (
    firstname: "",
    lastname: "",
    email: "",
    phone: "",
    address: "",
    position: "",
  ),
  footer: auto,
  theme: (
    accent-color: rgb("#323b4c"),
    secondary-color: rgb("#e4e4e4"),
    font-color: rgb("#333333"),
    header-color: luma(50),
    fonts: (
      heading: "Fira Sans",
      body: ("Noto Sans", "Roboto"),
    ),
  ),
  sidebar-width: 16em,
  profile-picture: none,
  profile-picture-zoom: 1.,
  gdpr: true,
  date: auto,
  page-lang: "fr",
  summary: "",
  side-content,
  body,
) = {
  _theme.update(theme)
  _author.update(author)
  let profile-picture-radius = sidebar-width * 0.80 / 2

  set text(lang: page-lang)

  set page(
    paper: paper-size,
    margin: page-margin,
    background: {
      place(top + left, rect(
        width: sidebar-width,
        height: 100%,
        fill: theme.secondary-color,
      ))
      place(top, rect(
        width: 100%,
        fill: theme.header-color,
      ))
    },

    footer: if footer == auto {
      set align(center)
      set text(
        size: FOOTER_FONT_SIZE_SCALE * 1em,
        fill: theme.font-color.lighten(50%),
      )

      context {
        let footer-items = (
          [#author.firstname #author.lastname CV],
          if date == auto {
            custom-date-format(
              datetime.today(),
              pattern: "MMMM, yyyy",
              lang: text.lang,
            )
          } else {
            date
          },
        )

        if counter(page).final().first() > 1 {
          let page-lang = text.lang.split("-").first()
          let (pg, of) = _page-labels.at(
            page-lang,
            default: _page-labels.at("en"),
          )
          let cur = counter(page).get().first()
          let tot = counter(page).final().first()
          footer-items.push([#pg #cur #of #tot])
        }

        footer-items.join(DOT_SEPARATOR)
      }

      if gdpr {
        [
          #linebreak()
          I authorise the processing of personal data contained within my CV,
          according to GDPR (EU) 2016/679, Article 6.1(a).
        ]
      }
    } else {
      footer
    },
  )

  let header = context {
    block(
      width: 100%,
      fill: theme.header-color,
      outset: (right: page-margin.right, left: page-margin.left, top: page-margin.top),
      inset: (left: -page-margin.left, bottom: page-margin.top / 2),
      below: 0pt,
      [
        #let header-content = [
          #set align(center)
          #set text(fill: white, font: theme.fonts.heading) // if you see a warning here, your font was not found/loaded

          #text(size: 3em)[
            #text(weight: "light")[#author.firstname]
            #text(weight: "medium")[#author.lastname]
          ]

          #v(-2em)

          #set align(left)
          #set par(justify: true)
          #text(size: 1em)[
            #summary
          ]
        ]

        #if profile-picture != none [
          #grid(
            columns: (sidebar-width, auto),
            align: (center, center),
            inset: 0em,
            {},
            [
              #header-content
            ],
          )
        ] else [
          #box(inset: (left: page-margin.left))[#header-content]]
      ],
    )
  }

  let sidebar = context {
    [
      #pad(
        left: -page-margin.left,
        bottom: -page-margin.bottom,
      )[
        #let inset = (
          left: page-margin.left,
          right: page-margin.right / 2,
          top: page-margin.top / 2,
          bottom: page-margin.bottom,
        )

        #block(
          width: 100%,
          inset: inset,
          [
            #show heading.where(depth: 1): it => block(width: 100%, above: 2em)[
              #set text(
                font: theme.fonts.heading,
                fill: theme.accent-color,
                weight: "regular",
                size: 0.95em,
              )

              #grid(
                columns: (0pt, 1fr),
                align: horizon,
                box(
                  fill: theme.accent-color,
                  width: -0.29em / SIDE_CONTENT_FONT_SIZE_SCALE,
                  height: 0.86em / SIDE_CONTENT_FONT_SIZE_SCALE,
                  outset: (left: 0.43em / SIDE_CONTENT_FONT_SIZE_SCALE),
                ),
                it.body,
              )
            ]

            #if profile-picture != none {
              place(
                center,
                dx: (inset.right - inset.left) / 2,
                dy: -profile-picture-radius - page-margin.top / 2,
                block(
                  clip: true,
                  stroke: theme.secondary-color + 1mm, // theme.accent-color + 1mm,
                  radius: profile-picture-radius,
                  width: profile-picture-radius * 2,
                  inset: (1 - profile-picture-zoom) * profile-picture-radius,
                  profile-picture,
                ),
              )
            }

            #if profile-picture != none [
              #v(profile-picture-radius)
            ] else [
              #v(1em)
            ]

            #align(center)[
              #text(size: 1.1em, weight: "bold")[
                #upper(author.position)
              ]
            ]

            #side-content
          ],
        )
      ]
    ]
  }

  let main = block(
    inset: (top: 2em, bottom: 0em, left: 2em, right: 0em),
    [
      #set text(size: ENTRY_CONTENT_FONT_SIZE_SCALE * 1em)
      #show heading.where(depth: 1): it => block(width: 100%)[
        #text(
          fill: theme.accent-color,
          weight: "regular",
          font: theme.fonts.heading,
          size: 1em,
        )[#smallcaps(it.body)]
        #box(width: 1fr, line(length: 100%, stroke: theme.accent-color))
      ]

      #text(size: 0.9em)[#body]

    ],
  )

  header

  grid(
    columns: (sidebar-width - page-margin.left, auto),
    align: (left, left),
    sidebar, main,
  )
}
