# Data tomada de: https://www.datos.gov.co/Transporte/Encuesta-de-movilidad-de-Bogot-2015-Caracterizaci-/mvbb-bn7j
require(data.table)
d <- fread("data/encuesta-de-movilidad-de-bogota-2015_viajes.csv")

# Cálculo de tiempo de viaje
cols <- c("dif_hora", "dif_minuto", "dif_segundo")
d[, (cols) := tstrsplit(DIFERENCIA_HORAS, ":", fixed = TRUE)]
d[, (cols) := lapply(.SD, as.numeric), .SDcols = cols]
d[, ]

# Gráfico de las latitudes y longitudes
require(plotly)
plot_ly(d[
    !is.na(LATITUD_DESTINO) & 
    !is.na(LONGITUD_DESTINO) &
    LATITUD_DESTINO > 0 &
    LONGITUD_DESTINO > 0
  ]
  , x = ~LONGITUD_DESTINO
  , y = ~LATITUD_DESTINO
  , type = "scatter"
)
