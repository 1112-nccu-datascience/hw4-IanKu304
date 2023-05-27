

server <- function(input, output,session) {
  library(shiny)
  library(ggbiplot)
  library(ggplot2)
  library(bslib)
  library(factoextra)
  library(FactoMineR)
  
  data(iris)
  data <- iris[, 1:4]
  log.ir <- log(iris[, 1:4])
  ir.species <- iris[, 5]
  ir.pca <- prcomp(log.ir,center = TRUE, scale. = TRUE)
  
  
  
  output$scatter <- renderPlot({
    if (input$PCx[1]==input$PCx[2]){
      hist(ir.pca$x[,input$PCx[1]])
    }else{
      g <- ggbiplot(ir.pca, choices = c(input$PCx), groups = ir.species,ellipse = TRUE)
      g <- g + scale_color_discrete(name = '')
      g <- g + theme(legend.direction = 'horizontal', legend.position = 'top')
      g
    }
  })
  output$PCA = renderTable({
    ir.pca$x}, rownames = TRUE
  )
  output$PCA1 = renderTable({
    ir.pca$rotation}, rownames = TRUE
  )
  output$corr = renderTable({
    cor(iris[,1:4])
  })
  output$iris = renderTable({
    i = sample(1:150,input$datas)
    out = iris[sort(i),]
    max_ = c(max(out[,1]),max(out[,2]),max(out[,3]),max(out[,4]),"")
    min_ = c(min(out[,1]),min(out[,2]),min(out[,3]),min(out[,4]),"")
    mean_ = c(mean(out[,1]),mean(out[,2]),mean(out[,3]),mean(out[,4]),"")
    VAR = c(var(out[,1]),var(out[,2]),var(out[,3]),var(out[,4]),"")
    add = data.frame(rbind(max_, min_,mean_,VAR))
    colnames(add) = colnames(out)
    rownames(add) = c("max","min","mean","variance")
    rbind.data.frame(out,add)
    }, rownames = TRUE
  )
  output$ClusterPlot <- renderPlot({
    kmeans.cluster <- kmeans( data, centers=input$bins)
    fviz_cluster(kmeans.cluster,           
                 data = data,              
                 geom = c("point","text"), 
                 ellipse.type = "norm")      
  })
  
  output$CAPlot <- renderPlot({

    caplot <- CA(iris[1:input$sample, -5], graph = F)
    fviz_ca_biplot(caplot, repel = FALSE)   
  })
  
  output$Heatmap <- renderPlot({
    library(corrplot)
    corr = cor(iris[,1:4])
    corrplot(corr , type = "upper", 
             tl.col = "black", tl.srt = 45)
  })
  
  observeEvent(input$Reset, {
    output$ClusterPlot <- renderPlot({
      kmeans.cluster <- kmeans( data, centers=input$bins)
      fviz_cluster(kmeans.cluster,           
                   data = data,              
                   geom = c("point","text"), 
                   ellipse.type = "norm")      
    })
  })
  
  observeEvent(input$Renew, {
    output$iris = renderTable({
      i = sample(1:150,input$datas)
      out = iris[sort(i),]
      max_ = c(max(out[,1]),max(out[,2]),max(out[,3]),max(out[,4]),"")
      min_ = c(min(out[,1]),min(out[,2]),min(out[,3]),min(out[,4]),"")
      mean_ = c(mean(out[,1]),mean(out[,2]),mean(out[,3]),mean(out[,4]),"")
      VAR = c(var(out[,1]),var(out[,2]),var(out[,3]),var(out[,4]),"")
      add = data.frame(rbind(max_, min_,mean_,VAR))
      colnames(add) = colnames(out)
      rownames(add) = c("max","min","mean","variance")
      rbind.data.frame(out,add)
      }, rownames = TRUE
    )
  })
}