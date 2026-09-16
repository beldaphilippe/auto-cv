#import "../auto-cv.typ": __social-link, contact-info, cv, entry, social-links

#let language = "en"

#let author = (
  firstname: "Quacky",
  lastname: "Duck",
  email: "oh@my.duck",
  phone: "+001 23 45 67 89",
  address: "Shore, Lake",
  position: "Bread Eater, World Ender",
  github: "quackyduck_",
  linkedin: "quackyduck_",
)

#cv(
  author: author,
  profile-picture: image("images/duck.jpg"),
  profile-picture-zoom: 1.,
  gdpr: false,
  page-lang: language,
  summary: [
    An awesome creature.
  ],
  // sidebar content
  [
    = Searching
    Big pay job.\
    Available until rain.

    = Contact
    #contact-info()
    #social-links()

    = Skills
    - Dynamic
    - Young
    - Hungry
  ],
  // body
  [
    = Education
    #entry(
      title: "Feather Degree",
      location: "Countryside",
      institution: "The Farm",
      date: "2024 - Present",
      [
        Special Honors
      ],
    )
    #entry(
      title: "School of life",
      location: "The Nest",
      institution: "The Egg Brotherhood",
      date: "2023-2024",
      [],
    )

    = Projects #text(size: .6em)[#__social-link("github", "https://github.com/" + author.github, "", inline: true)]
    #entry(
      title: "Baguette",
      date: "2025",
      [
        First year pastry project.
      ],
    )
    #entry(
      title: "Find food",
      date: "2023 - Present",
      [
        Personal project
        - Weight increase of the soul physical vessel
        - Application of biological processes
      ],
    )

    = Work Experience
    #entry(
      title: "Volunteering",
      location: "The Park",
      institution: "Fountain",
      date: "2022",
      [
        Being part of the park community, receiving and sorting donations (bread).
      ],
    )
    
    = Interests
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 1em,
      [
        *Arts:* Eggs

        *Reading:*
        - Communist Manifesto (Karl Marx)
      ],
      [
        *Video Games:*
        - Untitled Goose Game
        - Breath of the Wild

        *Sports:*·\
        Flying, Swimming, Running
      ],
    )
  ],
)
