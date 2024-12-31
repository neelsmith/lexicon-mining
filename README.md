# LexiconMining.jl

The aim of this project is to extract latent morphological data in the digital edition of Lewis-Short's *Latin Dictionary*, and format for use with the Tabulae system for building Latin morphological parsers.

In 2025, it is being completely rewritten to use ChatGPT for the first round of data extraction. The process could be outlined as:

1. Use ChatGPT to extract morphological data from Christopher Blackwell's Markdown edition of Lewis-Short.
2. Parse the ChatGPT output into a Julia object model for each morphological type ("part of speech").
3. Create delimited-text representations of the data usable with [Tabulae](https://github.com/neelsmith/Tabulae.jl) 

