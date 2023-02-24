#install.packages("rcrossref")
#install.packages("rorcid")

id = c(
  "0000-0002-3026-5881", # L Laniewski-Wollk
  "0000-0001-6618-0532", # T Mitchell
  "0000-0002-1302-4859", # N Di Vaira
  "0000-0001-8596-9125", # C Leonardi
  "0000-0003-0183-5555", # G Gruszczynski
  "0000-0002-3154-1083", # D Sashko
  
)




tab=read.csv(textConnection('
name_s,                           scopus_id,                  orcid,      tclb,            mcf,       ccfd
"Christopher Leonardi",       "25646377900",  "0000-0001-8596-9125",        no,       lecturer,         no
"Lukasz Laniewski-Wollk",     "56719775800",  "0000-0002-3026-5881",    author,        postdoc,    adjunkt
"Travis Mitchell",            "57191284046",  "0000-0001-6618-0532",    mcontr,       lecturer,         no
"Reza Reisabadi",             "36731631700",                     NA,        no,   post-postdoc,         no
"Alexandra Roslin",           "56786451900",                     NA,        no,   post-postdoc,         no
"Nathan Di Vaira",            "57215219080",  "0000-0002-1302-4859",     contr,            phd,         no
"Bryce Hill",                 "57215223391",                     NA,      user,            phd,         no
"Sarah Brennand",                        NA,                     NA,        no,            phd,         no
"Dmytro Sashko",              "57305346800",  "0000-0002-3154-1083",     contr,            phd,         no
"Ian Lenane",                  "6506559458",                     NA,      user,            phd,         no
"Jon McCullough", "57611788200,57192239242",                     NA,      user,     alumni-phd,         no
"Duo Wang",                   "57200546044",  "0000-0002-2804-4369",      user,     alumni-phd,         no
"Michal Dzikowski",           "57188845641",  "0000-0001-5709-7235",    mcontr,             no, alumni-phd
'))


tab


person = rorcid::orcid_person(id)

do.call(rbind,lapply(person,function(x) lapply(x$name,function(x) if (is.list(x)) x$value else x)))



ret = rorcid::orcid_works(id)
works = ret$`0000-0001-6618-0532`$works

get.doi = function(x) {
  doi = x$`external-id-value`[x$`external-id-type`=="doi"]
  if (length(doi) == 0) NA else doi[1]
}

works$doi = sapply(works$`external-ids.external-id`, get.doi)

cbind(works$type,works$doi)

doi = sapply(works$`external-ids.external-id`, get.doi)
doi = unique(doi)
doi = sort(doi[!is.na(doi)])

crworks = rcrossref::cr_works(doi)

crworks$data$author
crworks$data$created
crworks$data$abstract
