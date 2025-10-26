// Typst Resume Template
// A clean and modern resume template

#let color-accent = rgb("#0066cc")
#let color-text = rgb("#333333")
#let color-gray = rgb("#666666")

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
    margin: (x: 1.8cm, y: 1.5cm),
  )
  set text(
    font: ("New Computer Modern", "Heiti SC", "Songti SC", "STSong"),
    size: 10.5pt,
    fill: color-text,
    lang: "zh",
  )
  
  set par(justify: true)
  
  // Header with name
  align(center)[
    #block(
      text(
        size: 24pt,
        weight: "bold",
        fill: color-accent,
        author
      )
    )
  ]
  
  // Contact information
  align(center)[
    #block(
      inset: (top: 4pt, bottom: 8pt),
      [
        #let contact-items = ()
        
        #if location != "" {
          contact-items.push(
            box[#text(fill: color-gray)[📍 #location]]
          )
        }
        
        #if email != "" {
          contact-items.push(
            box[#text(fill: color-gray)[✉️ #link("mailto:" + email)[#email]]]
          )
        }
        
        #if phone != "" {
          contact-items.push(
            box[#text(fill: color-gray)[📱 #phone]]
          )
        }
        
        #if github != "" {
          contact-items.push(
            box[#text(fill: color-gray)[🔗 #link("https://github.com/" + github)[GitHub]]]
          )
        }
        
        #if telegram != "" {
          contact-items.push(
            box[#text(fill: color-gray)[💬 #link("https://t.me/" + telegram)[Telegram]]]
          )
        }
        
        #if personal-site != "" {
          contact-items.push(
            box[#text(fill: color-gray)[🌐 #link(personal-site)[Website]]]
          )
        }
        
        #if blog != "" {
          contact-items.push(
            box[#text(fill: color-gray)[📝 #link(blog)[Blog]]]
          )
        }
        
        #contact-items.join(" | ")
      ]
    )
  ]
  
  // Horizontal line
  line(length: 100%, stroke: 0.5pt + color-accent)
  
  // Body
  body
}

// Section heading
#let section-heading(title) = {
  block(
    inset: (top: 8pt, bottom: 4pt),
    text(
      size: 14pt,
      weight: "bold",
      fill: color-accent,
      title
    )
  )
  line(length: 100%, stroke: 0.5pt + color-gray)
  v(4pt)
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
    inset: (top: 4pt, bottom: 6pt),
    [
      #grid(
        columns: (1fr, auto),
        [
          #text(weight: "bold", size: 11pt)[#title] \
          #text(fill: color-gray, style: "italic")[#location]
        ],
        align(right)[
          #text(fill: color-gray)[#date]
        ]
      )
      #v(2pt)
      #body
    ]
  )
}

// Project entry
#let project(
  name: "",
  url: "",
  description: "",
) = {
  block(
    inset: (top: 2pt, bottom: 4pt),
    [
      - *#link(url)[#name]*#if description != "" [ - #description]
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
    inset: (top: 4pt, bottom: 6pt),
    [
      #grid(
        columns: (1fr, auto),
        [
          #text(weight: "bold", size: 11pt)[#institution] \
          #text(fill: color-gray)[#degree, #major]
        ],
        align(right)[
          #text(fill: color-gray)[#date]
        ]
      )
    ]
  )
}

// Skills section
#let skills(skill-list) = {
  block(
    inset: (top: 2pt, bottom: 4pt),
    [
      #box[
        #for (i, skill) in skill-list.enumerate() [
          #box(
            fill: rgb("#f0f0f0"),
            inset: (x: 8pt, y: 4pt),
            radius: 3pt,
            text(fill: color-text, weight: "medium")[#skill]
          )
          #h(4pt)
        ]
      ]
    ]
  )
}
