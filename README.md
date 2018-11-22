# STAT547 Homework 8 repository

This repo contains my homework 8 for STAT547. The goal of this homework was to change a boilerplate of the BC Liquor App, which was provided by the instructors.

The original code and data are from [Dean Attali's tutorial](https://deanattali.com/blog/building-shiny-apps-tutorial). The code can specifically be found [here](https://deanattali.com/blog/building-shiny-apps-tutorial/#12-final-shiny-app-code).

I made the following changes to the app:

- I made the table interactive by using the `DT`package.
- I added colours to the plot and changed the axes and legend labels and the theme
- I added text that summarizes the number of findings for each individual search
- I changed the type and country selection options so that the user can search for multiple types of drinks and multiple countries at the same time
- I changed the country selection so that searching for all countries is also an option

You can find my version of the app [here](https://fjbasedow.shinyapps.io/STAT545-HW08-BCL-app/).

The code for my app can be found [here](https://github.com/STAT545-UBC-students/hw08-fjbasedow/blob/master/bcl/app.R)

Cheers,
Rike
