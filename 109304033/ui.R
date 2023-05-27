library(shiny)
library(ggbiplot)
library(ggplot2)
library(bslib)

# apply PCA - scale. = TRUE is highly advisable, but default is FALSE. 
data(iris)
ui <- navbarPage("NCCU_DS2023_hw4_109304033",
                 tabPanel("Info",
                          h2("111學年度下學期資料科學第4次作業"),
                          h6("Credit by 109304033 統計三 顧以恩"),
                          h3("簡介"),
                          h4("以iris資料庫進行主成分分析、對應分析以及分群練習，並使用shiny套件製作成可互動之應用程式"
                          )
                 ),
                 tabPanel("PCA",
                          fluidRow(
                            h2("PCA"),
                            column(
                              9, tabsetPanel(
                                tabPanel("Biplots",
                                         sliderInput(inputId = "PCx",
                                                     label = "Components show",
                                                     min = 1,
                                                     max = 4,
                                                     value = c(1,2)),
                                         plotOutput("scatter")),
                                tabPanel("PCs", tableOutput("PCA")),
                                tabPanel("Transformation",tableOutput("PCA1"))
                                
                              )
                              
                            )
                          )),
                 tabPanel("CA",
                          fluidRow(
                            h2("Correspondence analysis"),
                            tabPanel(
                                  selectInput("CAx","Species",choices = iris$Species),
                                  sliderInput(inputId = "sample",
                                              label = "Number of inputs:",
                                              min = 10,
                                              max = 150,
                                              value = 100),
                                  plotOutput("CAPlot")
                                  )
                            )
                          ),
                 tabPanel("Cluster",
                          h2("Cluster"),
                          sliderInput(inputId = "bins",
                                      label = "Number of clusters:",
                                      min = 2,
                                      max = 5,
                                      value = 3),
                          actionButton("Reset", "Regenerate"),
                          plotOutput(outputId = "ClusterPlot")
                          
                 ),
                 tabPanel("Data",
                          fluidRow(
                            h2("Iris"),
                            tabsetPanel(
                              tabPanel("Raw data",
                                       sliderInput(inputId = "datas",
                                                   label = "Number of datas:",
                                                   min = 5,
                                                   max = 150,
                                                   value = 5),
                                       actionButton("Renew", "Draw"),
                                       tableOutput("iris")
                                       
                              ),
                              tabPanel("Correlation",
                                       tableOutput("corr"),
                                       plotOutput(outputId = "Heatmap")
                              )
                            )
                          )
                )

                          
)

