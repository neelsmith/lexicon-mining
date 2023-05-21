# Read mainentries.cex and extract morphological info.
#
# Run from root of repository:
f = joinpath(pwd(), "cex", "lewis-short", "morphinfo.cex")
readlines(f) .|> morphData