// Typst Resume Template
// Mirrors the website (templates/main.html + public/css/custom.css): the same
// Georgia + Songti type, colours and spacing ratios, scaled to one A4 page.
//
// Single-page fitting: every vertical gap is its website value (`rhythm`)
// times a scale k. The generator raises `density` (lowering k) until the
// content fits on one page; whatever height is left goes to fractional gaps,
// so the page always ends at the bottom margin.
#import "@preview/sicons:16.0.0": sicon

#let color-accent = rgb("#0f172a")
#let color-heading = rgb("#111827")
#let color-text = rgb("#1f2937")
#let color-muted = rgb("#6b7280")
#let color-muted-strong = rgb("#4b5563")
#let color-divider = rgb("#cbd5e1")
#let color-surface = rgb("#f8fafc")
#let color-star = rgb("#d4a72c")

// What the website actually renders on macOS (Computer Modern isn't a
// system font, so browsers fall through to Georgia).
#let fonts = ("Georgia", "Songti SC", "STSong")
#let body-size = (zh: 9.5pt, en: 9pt)

// Songti SC's Bold face is very light; browsers on macOS thicken it when
// rendering, so on paper its Black face is what matches the website's bold.
// Georgia has no heavier face and falls back to its Bold.
#let bold = 900

// Vertical rhythm at k = 1, in em of the body size, from the website CSS.
#let rhythm = (
  leading: 0.75em, // li line-height 1.5
  bullet: 0.95em, // line gap + li margin-bottom 0.2rem
  heading: 0.85em, // entry heading → first bullet (margin-bottom 0.3rem)
  entry: 1.9em, // .resume-entry + .resume-entry (margin-top 18px)
  section: 2.4em, // section margin-top 32px
  title: 1.05em, // h2 rule → first entry (margin-bottom 13px)
)
#let density-step = 0.03
#let rhythm-scale = state("resume-rhythm-scale", 1.0)

// Separator between consecutive entries of a section.
#let entry-gap = context {
  v(rhythm.entry * rhythm-scale.get())
  v(0.4fr)
}

// `.entry-role::before { content: "·"; margin: 0 0.45em }`
#let sep = [#h(0.45em)#text(fill: color-muted)[·]#h(0.45em)]

// Brand icon from Simple Icons (https://simpleicons.org, via `sicons`), in
// the website's `.contact-line i` colour and dropped below the baseline like
// Font Awesome's `vertical-align: -0.125em`. The icon is placed in a
// zero-height box so it never makes its line taller than plain text, which
// would shift the single-page fit.
#let brand-icon(slug, fill: color-muted-strong) = box(
  width: 1em,
  place(bottom, dy: 0.125em, sicon(slug: slug, size: 1em, icon-color: fill.to-hex())),
)

// Prefix `body` with a brand icon; Simple Icons only has brand logos, so
// items without a brand (`slug: none`) stay plain text.
#let with-icon(slug, body) = if slug == none { body } else {
  [#brand-icon(slug)#h(0.35em)#body]
}

// Drop the scheme and trailing slash so links read like the website.
#let display-url(url) = url.replace("https://", "").replace("http://", "").trim("/", at: end)

// `h2`: bold accent title with a hairline underneath.
#let section-title(title, size: 1.05em, below: rhythm.title) = block(
  width: 100%,
  above: 0pt,
  below: below,
  sticky: true,
  inset: (bottom: 0.4em),
  stroke: (bottom: 0.5pt + color-divider),
  text(size: size, weight: bold, fill: color-accent, tracking: 0.06em, upper(title)),
)

#let resume(
  author: "",
  location: "",
  email: "",
  phone: "",
  github: "",
  telegram: "",
  personal-site: "",
  blog: "",
  lang: "zh",
  density: 0,
  body,
) = {
  let k = calc.max(0.3, 1 - density * density-step)
  let size = body-size.at(lang, default: 10pt)
  set document(author: author, title: author + "'s Resume")
  set page(paper: "a4", margin: (x: 1.4cm, y: 1.1cm))
  set text(font: fonts, size: size, fill: color-text, lang: lang)
  // Optimized breaking balances wrapped lines instead of orphaning a word.
  set par(justify: false, linebreaks: "optimized", leading: rhythm.leading * k)
  set list(
    marker: text(fill: color-accent, size: 1.1em, baseline: -0.02em)[•],
    indent: 0.35em,
    body-indent: 0.6em,
    spacing: rhythm.bullet * k,
  )
  show list: set block(above: rhythm.heading * k, below: 0pt)
  show heading.where(level: 2): it => {
    v(rhythm.section * k)
    v(1fr)
    section-title(it.body, size: 1.05 * size, below: rhythm.title * k)
  }
  rhythm-scale.update(k)

  // Header: name, then a single contact line, as on the website.
  block(
    below: 0pt,
    text(size: 27pt, weight: bold, fill: color-heading, tracking: -0.02em, author),
  )
  let email-icon = if email.ends-with("@gmail.com") { "gmail" }
  let contacts = (
    if location != "" { location },
    if email != "" { link("mailto:" + email, with-icon(email-icon, email)) },
    if phone != "" { phone },
    if personal-site != "" { link(personal-site, display-url(personal-site)) },
    if blog != "" { link(blog, display-url(blog)) },
    if github != "" {
      link("https://github.com/" + github, with-icon("github", "github.com/" + github))
    },
    if telegram != "" {
      link("https://t.me/" + telegram, with-icon("telegram", "t.me/" + telegram))
    },
  ).filter(i => i != none)
  block(
    above: 1.3em,
    below: 1.35em,
    text(
      size: 0.84em,
      fill: color-muted,
      contacts.map(box).join(text(fill: color-divider)[#h(0.56em)/#h(0.56em)]),
    ),
  )

  body

  // Expose the final page count so the generator can detect overflow.
  context [#metadata(counter(page).final().first()) <resume-pages>]
}

// `.entry-heading`: bold title, optional muted subtitle, date on the right.
#let entry-heading(title, subtitle: "", date: "") = block(
  width: 100%,
  above: 0pt,
  below: 0pt,
  sticky: true,
  {
    text(size: 1.02em, weight: bold, fill: color-heading, title)
    if subtitle != "" {
      // A trailing full-width bracket already carries half an em of blank
      // space; pull the separator back so the gap matches the other lines.
      if type(title) == str and title.ends-with("）") { h(-0.5em) }
      text(size: 1.02em, fill: color-muted-strong, [#sep#subtitle])
    }
    h(1fr)
    text(
      size: 0.82em,
      fill: color-muted,
      tracking: 0.02em,
      number-width: "tabular",
      date,
    )
  },
)

// Work experience entry: company in bold, role after it in regular weight.
// Separate consecutive entries with `#entry-gap`.
#let work(
  company: "",
  position: "",
  date: "",
  body,
) = block(width: 100%, above: 0pt, below: 0pt, {
  entry-heading(company, subtitle: position, date: date)
  body
})

// Education entry: school and date, then "major · degree" underneath.
#let education(
  institution: "",
  major: "",
  degree: "",
  date: "",
) = block(width: 100%, above: 0pt, below: 0pt, {
  entry-heading(institution, date: date)
  context block(
    above: rhythm.heading * rhythm-scale.get(),
    below: 0pt,
    text(fill: color-muted-strong, (major, degree).filter(s => s != "").join(" · ")),
  )
})

// `.project-role`: small outlined label, e.g. "Committer".
#let role-badge(role) = box(
  inset: (x: 0.4em),
  outset: (y: 0.2em),
  radius: 1.5pt,
  stroke: 0.5pt + color-divider,
  text(size: 0.81em, fill: color-muted-strong, tracking: 0.03em, role),
)

// `.project-entry` content; the card chrome comes from `project-grid`.
#let project(
  name: "",
  role: "",
  url: "",
  repo_label: "",
  stars: "",
  description: "",
) = {
  block(width: 100%, below: 0pt, {
    link(url, text(size: 1.07em, weight: bold, fill: color-heading, name))
    if role != "" {
      h(0.35em)
      role-badge(role)
    }
    h(1fr)
    if stars != "" {
      text(size: 0.93em, fill: color-muted-strong, number-width: "tabular")[
        #text(fill: color-star)[★]#h(0.2em)#stars
      ]
    }
  })
  if repo_label != "" {
    let repo-icon = if url.contains("github.com/") { "github" }
    block(above: 0.55em, below: 0pt, link(url, text(
      size: 0.95em,
      fill: color-muted-strong,
      with-icon(repo-icon, repo_label),
    )))
  }
  if description != "" {
    block(above: 0.6em, below: 0pt, description)
  }
}

// `.project-grid`: three columns of cards; cells in a row share a height.
#let project-grid(..items) = {
  // Keep each card whole; move the row to the next page instead of splitting.
  set grid.cell(breakable: false)
  set text(size: 0.84em)
  set par(leading: 0.6em)
  grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.75em,
    row-gutter: 0.75em,
    inset: (x: 0.95em, y: 0.85em),
    fill: color-surface,
    stroke: 0.5pt + color-divider,
    ..items.pos(),
  )
}
