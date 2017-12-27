library(shiny)

# Define UI for application that predicts next word
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predict Next Word - Coursera Data Science Capstone Project"),
  fluidRow(HTML("<strong>Done by: Dilip Suwal</strong>") ),
  fluidRow(HTML("<strong>Date: 27-Dec-2017</strong>") ),
  
  fluidRow(
    br(),
    p("The purpose of this application is to predict the next word after user enters a sentence without a last word. The application predicts the last word using  
      N-Gram backoff model.The model gets trained using training data set comprised of twiter, blog, and news data sets.")),
    br(),
    br(),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput("InputString", "Enter a sentence without a last word", value = ""),
      actionButton("do", "Predict Word")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h4("The predicted next word is"), 
      fluidRow(column(5, verbatimTextOutput("PredictedWord", placeholder = TRUE)))
    )
  )
))
