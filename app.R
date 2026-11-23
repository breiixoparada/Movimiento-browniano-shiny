# LIBRERÍAS

library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(tidyr)

# FUNCIÓN DE SIMULACIÓN

simular_bm <- function(N, n, T_max){
  dt <- T_max / n
  inc <- matrix(rnorm(N * n, sd = sqrt(dt)),nrow = n,ncol = N)
  
  W <- rbind(rep(0, N),apply(inc, 2, cumsum))
  
  list(t = seq(0, T_max, length.out = n + 1),W = W)
}



# INTERFAZ GRÁFICA

ui <- navbarPage("Movimiento Browniano", theme = shinytheme("flatly"),
                 
                 # ---------------------------------------------------
                 # PESTAÑA 1
                 # ---------------------------------------------------
                 
                 tabPanel("Trayectorias",sidebarLayout(
                   sidebarPanel(
                     sliderInput("T","Horizonte temporal T", min = 0.5 , max = 10 , 
                                 value = 1,step = 0.5),
                     sliderInput("n","Número de pasos", min = 100 , max = 2000 , 
                                 value = 500,step = 100),
                     sliderInput("N","Número de trayectorias", min = 1 , max = 200 , 
                                 value = 50),
                     actionButton("simular","Simular")),
                   
                   mainPanel(plotOutput("plot_tray",height = "500px"))
                   
                 )
                 ),
                 
                 # ---------------------------------------------------
                 # PESTAÑA 2
                 # ---------------------------------------------------
                 
                 tabPanel("Distribución",plotOutput("plot_dist",height = "550px")
                          
                 ),
                 
                 # ---------------------------------------------------
                 # PESTAÑA 3
                 # ---------------------------------------------------
                 
                 tabPanel("Estadísticos",h3("Resumen estadístico"),tableOutput("tabla_stats")
                          
                 ),
                 
                 # ---------------------------------------------------
                 # PESTAÑA 4
                 # ---------------------------------------------------
                 
                 tabPanel("MSD",plotOutput("plot_msd",height = "550px")
                          
                 ),
                 
                 # ---------------------------------------------------
                 # PESTAÑA 5
                 # ---------------------------------------------------
                 
                 tabPanel("Teoría vs Simulación",h3("Comparación entre teoría y simulación"),
                          tableOutput("tabla_teoria"))
                 
)


# SERVIDOR


server <- function(input, output, session){
  
  # ---------------------------------------------------
  # SIMULACIÓN
  # ---------------------------------------------------
  
  sim <- eventReactive(input$simular,
                       {simular_bm(input$N,input$n,input$T)},ignoreNULL = FALSE)
  
  # ---------------------------------------------------
  # TRAYECTORIAS
  # ---------------------------------------------------
  
  output$plot_tray <- renderPlot({
    d <- sim()
    df <- data.frame(t = d$t,d$W)
    df <- pivot_longer(df,-t,names_to = "id")
    
    ggplot(df,aes(x = t,y = value,group = id)
    ) +
      
      geom_line(alpha = min(0.6, 20/input$N),color = "blue",linewidth = 0.35
      ) +
      
      geom_hline(yintercept = 0,linetype = "dashed"
      ) +
      
      labs(title = paste(input$N, "trayectorias brownianas"),x = "Tiempo",
           y = "Posición"
      ) +
      
      theme_minimal()
    
  })
  
  # ---------------------------------------------------
  # DISTRIBUCIÓN
  # ---------------------------------------------------
  
  output$plot_dist <- renderPlot({
    
    finales <- sim()$W[nrow(sim()$W), ]
    
    df <- data.frame(
      posicion = finales
    )
    
    ggplot(df, aes(posicion)) +
      
      geom_histogram(
        aes(y = after_stat(density)),
        bins = 30,
        fill = "lightblue",
        color = "black"
      ) +
      
      stat_function(
        fun = dnorm,
        args = list(
          mean = mean(finales),
          sd = sd(finales)
        ),
        linewidth = 1
      ) +
      
      labs(
        title = "Distribución de posiciones finales",
        x = "Posición",
        y = "Densidad"
      ) +
      
      theme_minimal()
    
  })
  
  # ---------------------------------------------------
  # ESTADÍSTICOS
  # ---------------------------------------------------
  
  output$tabla_stats <- renderTable({
    
    finales <- sim()$W[nrow(sim()$W), ]
    
    data.frame(Magnitud = c("Media","Varianza","Desviación típica","Mínimo",
                            "Máximo"),
               Valor = round(c(mean(finales),var(finales),sd(finales),
                               min(finales),max(finales)),4))
  })
  
  # ---------------------------------------------------
  # MSD
  # ---------------------------------------------------
  
  output$plot_msd <- renderPlot({
    d <- sim()
    tiempos <- d$t
    msd <- apply(d$W^2,1,mean)
    
    teorica <- tiempos
    
    df <- data.frame(tiempo = tiempos,simulada = msd,teorica = teorica)
    
    ggplot(df, aes(tiempo)) +
      
      geom_line(aes(y = simulada),linewidth = 1
      ) +
      
      geom_line(aes(y = teorica),linewidth = 1,linetype = "dashed"
      ) +
      
      labs(title = "MSD simulada vs teoría",x = "Tiempo",y = "MSD"
      ) +
      
      theme_minimal()
    
  })
  
  # ---------------------------------------------------
  # TEORÍA VS SIMULACIÓN
  # ---------------------------------------------------
  
  output$tabla_teoria <- renderTable({
    
    finales <- sim()$W[nrow(sim()$W), ]
    
    data.frame(Magnitud = c("Media","Varianza"),Teoria = c(0,input$T),
               Simulacion = round(c(mean(finales),var(finales)),4))
    
  })
  
}

shinyApp(ui, server, options=list(height = 650))