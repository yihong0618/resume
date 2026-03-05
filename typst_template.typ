// Typst Resume Template
// Cold, restrained visual style aligned with website structure
#let color-accent = rgb("#0f172a")
#let color-heading = rgb("#111827")
#let color-text = rgb("#1f2937")
#let color-muted = rgb("#6b7280")
#let color-muted-strong = rgb("#4b5563")
#let color-muted-deep = rgb("#374151")
#let color-divider = rgb("#cbd5e1")
#let color-surface = rgb("#f8fafc")
#let color-chip-bg = rgb("#e5e7eb")

#let resume(
  author: "",
  location: "",
  email: "",
  phone: "",
  github: "",
  telegram: "",
  personal-site: "",
  blog: "",
  body,
) = {
  set document(author: author, title: author + "'s Resume")
  set page(
    paper: "a4",
    margin: (x: 1.45cm, y: 1.05cm),
  )
  set text(
    font: ("New Computer Modern", "Heiti SC", "Songti SC", "STSong"),
    size: 9.85pt,
    fill: color-text,
    lang: "zh",
  )
  set par(justify: false, leading: 0.58em)

  // Header
  align(left)[
    #block(
      inset: (bottom: 2pt),
      text(
        size: 23pt,
        weight: "bold",
        fill: color-heading,
        author
      )
    )
  ]

  // Contact information (plain text links)
  align(left)[
    #block(
      inset: (top: 2pt, bottom: 5pt),
      [
        #let contact-items = ()

        #if location != "" {
          contact-items.push(
            box[#text(size: 8.4pt, fill: color-muted)[#location]]
          )
        }

        #if email != "" {
          contact-items.push(
            box[#text(size: 8.4pt, fill: color-muted)[#link("mailto:" + email)[#email]]]
          )
        }

        #if phone != "" {
          contact-items.push(
            box[#text(size: 8.4pt, fill: color-muted)[#phone]]
          )
        }

        #if github != "" {
          contact-items.push(
            box[#text(size: 8.4pt, fill: color-muted)[#link("https://github.com/" + github)[github.com/#github]]]
          )
        }

        #if personal-site != "" {
          contact-items.push(
            box[#text(size: 8.4pt, fill: color-muted)[#link(personal-site)[Website]]]
          )
        }

        #if blog != "" {
          contact-items.push(
            box[#text(size: 8.4pt, fill: color-muted)[#link(blog)[Blog]]]
          )
        }

        #contact-items.join(" / ")
      ]
    )
  ]

  // Horizontal line
  line(length: 100%, stroke: 0.6pt + color-accent)

  // Body
  body
}

// Section heading
#let section-heading(title) = {
  block(
    inset: (top: 8pt, bottom: 2.4pt),
    text(
      size: 10.8pt,
      weight: "bold",
      fill: color-accent,
      title
    )
  )
  line(length: 100%, stroke: 0.4pt + color-divider)
  v(2pt)
}

// Update heading style
#show heading.where(level: 2): it => section-heading(it.body)

// Work experience entry
#let work(
  title: "",
  location: "",
  date: "",
  body,
) = {
  block(
    inset: (top: 1.3pt, bottom: 2.6pt),
    [
      #grid(
        columns: (1fr, auto),
        column-gutter: 6pt,
        [
          #text(weight: "semibold", size: 10.3pt, fill: color-heading)[#title] \
          #text(size: 8.4pt, fill: color-muted, style: "italic")[#location]
        ],
        align(right)[
          #text(size: 8.2pt, fill: color-muted)[#date]
        ]
      )
      #v(0.8pt)
      #body
    ]
  )
}

// Project entry with stars in compact list layout
#let project(
  name: "",
  url: "",
  repo_label: "",
  stars: "",
  description: "",
) = {
  block(
    breakable: false,
    inset: (top: 1.8pt, bottom: 2.4pt),
    [
      #box(
        fill: color-surface,
        stroke: 0.35pt + color-divider,
        inset: (x: 7pt, y: 5pt),
        radius: 2.5pt,
        [
          #grid(
            columns: (1fr, auto),
            column-gutter: 6pt,
            [
              #text(weight: "semibold", size: 10pt, fill: color-heading)[#link(url)[#name]]
            ],
            [
              #if stars != "" and stars != "N/A" [
                #text(size: 8.6pt, fill: color-muted-deep)[stars #stars]
              ]
            ],
          )
          #if repo_label != "" [
            #v(0.8pt)
            #link(url)[#text(size: 8.3pt, fill: color-muted-deep)[github.com/#repo_label]]
          ]
          #if description != "" [
            #v(1.2pt)
            #text(size: 8.9pt, fill: color-text)[#description]
          ]
        ]
      )
    ]
  )
}

// Education entry
#let education(
  institution: "",
  major: "",
  degree: "",
  date: "",
) = {
  block(
    inset: (top: 1.4pt, bottom: 2.4pt),
    [
      #grid(
        columns: (1fr, auto),
        column-gutter: 6pt,
        [
          #text(weight: "semibold", size: 10.3pt, fill: color-heading)[#institution] \
          #text(size: 8.4pt, fill: color-muted)[#degree, #major]
        ],
        align(right)[
          #text(size: 8.2pt, fill: color-muted)[#date]
        ]
      )
    ]
  )
}

// Skills section
#let skills(skill-list) = {
  block(
    inset: (top: 1.4pt, bottom: 2.6pt),
    [
      #box[
        #for (i, skill) in skill-list.enumerate() [
          #box(
            fill: color-chip-bg,
            inset: (x: 5pt, y: 2.4pt),
            radius: 2pt,
            text(size: 8.4pt, fill: color-heading, weight: "medium")[#skill]
          )
          #h(2.4pt)
        ]
      ]
    ]
  )
}
