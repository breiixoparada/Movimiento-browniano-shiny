# Movimiento browniano con Shiny

Aplicación interactiva en R (Shiny) que simula trayectorias del movimiento browniano y compara los resultados de la simulación con la teoría de Einstein.

## Autores

- Breixo Parada López
- Isabel de la Torre Barreiro

## Contenido

- `app.R`: código de la aplicación Shiny.
- `Movimiento_Browniano_con_shiny.Rmd`: documento con la introducción teórica, el planteamiento del modelo (ecuación de Langevin y proceso de Wiener) y el código de la simulación.
- `Movimiento-Browniano-con-shiny.pdf`: versión en PDF del documento.

## Parámetros

- **Trayectorias:** simulación de N trayectorias de movimiento browniano con horizonte temporal T y número de pasos configurables.
- **Distribución:** histograma de las posiciones finales comparado con la densidad normal teórica.
- **Estadísticos:** resumen de media, varianza, desviación típica, mínimo y máximo de las posiciones finales.
- **MSD:** desplazamiento cuadrático medio simulado frente a la predicción teórica.
- **Teoría vs simulación:** tabla de comparación entre los valores teóricos y los obtenidos en la simulación.

## Requisitos

R y los siguientes paquetes:

```r
install.packages(c("shiny", "shinythemes", "ggplot2", "dplyr", "tidyr"))
```

## Ejecución

1. Descarga o clona el repositorio.
2. Abre `app.R` en RStudio y pulsa **Run App**, o ejecuta desde la consola:

```r
shiny::runApp("ruta/a/la/carpeta/del/repositorio")
```
